use parking_lot::Mutex;
use rustler::env::SavedTerm;
use rustler::resource::ResourceArc;
use rustler::{Env, OwnedEnv, Term};

type VR = ResourceArc<Outer>;

struct Outer {
    inner: Mutex<VecResource>,
}

struct VecResource {
    env: OwnedEnv,
    inner: std::vec::Vec<SavedTerm>,
}

#[rustler::nif(name = "new_impl")]
fn new() -> VR {
    ResourceArc::new(Outer {
        inner: Mutex::new(VecResource {
            env: OwnedEnv::new(),
            inner: vec![],
        }),
    })
}

#[rustler::nif(name = "with_capacity_impl")]
fn with_capacity(c: usize) -> VR {
    ResourceArc::new(Outer {
        inner: Mutex::new(VecResource {
            env: OwnedEnv::new(),
            inner: Vec::with_capacity(c),
        }),
    })
}

#[rustler::nif(name = "count_impl")]
fn count(v: VR) -> usize {
    let inner = v.inner.lock();
    inner.inner.len()
}

#[rustler::nif(name = "capacity_impl")]
fn capacity(v: VR) -> usize {
    let inner = v.inner.lock();
    inner.inner.capacity()
}

#[rustler::nif(name = "push_impl")]
fn push(v: VR, el: Term) -> VR {
    {
        let mut inner = v.inner.lock();
        // TODO: determine if this call to clear is necessary or not,
        // and whether `clear` is necesssary in general
        // inner.env.clear();
        let saved = inner.env.save(el);
        inner.inner.push(saved);
    }

    v
}

#[rustler::nif(name = "is_member_impl")]
fn is_member(v: VR, el: Term) -> bool {
    let inner = v.inner.lock();
    let saved = inner.env.save(el);

    inner.env.run(|inner_env| {
        let cloned = saved.load(inner_env);

        for element in &inner.inner {
            let loaded = element.load(inner_env);

            if loaded == cloned {
                return true;
            }
        }

        false
    })
}

#[rustler::nif(name = "clear_impl")]
fn clear(v: VR) -> VR {
    {
        let mut inner = v.inner.lock();
        inner.inner.clear();
    }

    v
}

#[rustler::nif(name = "last_impl")]
fn last<'a>(env: Env<'a>, v: VR, default: Term) -> Term<'a> {
    let inner = v.inner.lock();

    inner.env.run(|inner_env| {
        if let Some(last) = inner.inner.last() {
            let term = last.load(inner_env);
            term.in_env(env)
        } else {
            let saved = inner.env.save(default);
            let cloned = saved.load(inner_env);
            cloned.in_env(env)
        }
    })
}

#[rustler::nif(name = "to_list_impl")]
fn to_list(env: Env, v: VR) -> Vec<Term> {
    let inner = v.inner.lock();
    inner.env.run(|inner_env| {
        inner
            .inner
            .iter()
            .map(|t| {
                let cloned = t.load(inner_env);
                cloned.in_env(env)
            })
            .collect()
    })
}

#[rustler::nif(name = "from_list_impl")]
fn from_list(list: Term) -> VR {
    let list_len = list.list_length().unwrap();
    let list_iter = list.into_list_iterator().unwrap();

    let env = OwnedEnv::new();
    let mut v = Vec::with_capacity(list_len);

    for el in list_iter {
        let saved = env.save(el);
        v.push(saved);
    }

    ResourceArc::new(Outer {
        inner: Mutex::new(VecResource { env, inner: v }),
    })
}

#[rustler::nif(name = "at_impl")]
fn at<'a>(env: Env<'a>, v: VR, index: usize, default: Term) -> Term<'a> {
    let inner = v.inner.lock();

    inner.env.run(|inner_env| {
        if let Some(el) = inner.inner.get(index) {
            let term = el.load(inner_env);
            term.in_env(env)
        } else {
            let saved = inner.env.save(default);
            let cloned = saved.load(inner_env);
            cloned.in_env(env)
        }
    })
}

#[rustler::nif(name = "set_at_impl")]
fn set_at(v: VR, index: usize, el: Term) -> VR {
    {
        let mut inner = v.inner.lock();
        let saved = inner.env.save(el);
        inner.inner[index] = saved;
    }

    v
}

#[rustler::nif(name = "remove_impl")]
fn remove(v: VR, index: usize) -> VR {
    {
        let mut inner = v.inner.lock();
        inner.inner.remove(index);
    }

    v
}

// TODO: equality of some kind
// #[rustler::nif(name = "eq_impl")]
// fn eq(l: VR, r: VR) -> bool {
//     let llock = l.inner.lock();
//     let rlock = r.inner.lock();
//     llock.inner == rlock.inner
// }

fn on_load(env: Env, _info: Term) -> bool {
    rustler::resource!(Outer, env);
    true
}

rustler::init!(
    "Elixir.Vec",
    [
        at,
        capacity,
        clear,
        count,
        from_list,
        is_member,
        last,
        new,
        push,
        set_at,
        to_list,
        with_capacity,
    ],
    load = on_load
);
