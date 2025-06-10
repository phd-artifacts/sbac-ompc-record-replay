# README

## Prerequisites

* **Apptainer** installed and on your `PATH`.

## Container Images

We use two pre-built Apptainer images from our GitLab registry:

| Image Purpose                        | Registry Path                                                                                       | Local Filename            |
| ------------------------------------ | --------------------------------------------------------------------------------------------------- | ------------------------- |
| Build & runtime for `tb-tdg-no-loop` | `registry.gitlab.com/ompcluster/containers/build-runtime-img/ubuntu20.04-cuda11.2-mpich:1854061961` | `sifs/improv-144.sif`     |
| Build & runtime for `tb-main-loop`   | `registry.gitlab.com/ompcluster/containers/build-runtime-img/ubuntu20.04-cuda11.2-mpich:1854063649` | `sifs/scheduler-main.sif` |

Pull both images before proceeding:

```bash
mkdir -p sifs
apptainer pull \
  docker://registry.gitlab.com/ompcluster/containers/build-runtime-img/ubuntu20.04-cuda11.2-mpich:1854061961 \
  sifs/improv-144.sif
apptainer pull \
  docker://registry.gitlab.com/ompcluster/containers/build-runtime-img/ubuntu20.04-cuda11.2-mpich:1854063649 \
  sifs/scheduler-main.sif
```

---

## Build & Install

Be sure to get submodules:

```bash
git submodule update --init --recursive
```

### 1. `tb-tdg-no-loop`

```bash
apptainer exec sifs/improv-144.sif bash -lc '
  export CC=clang CXX=clang++
  cd application/tb-tdg-no-loop
  DEFAULT_FEATURES=0 USE_OMPCLUSTER=1 ./get_deps.sh
  DEFAULT_FEATURES=0 USE_OMPCLUSTER=1 ./build_all.sh
'
```

### 2. `tb-main-loop`

```bash
apptainer exec sifs/scheduler-main.sif bash -lc '
  export CC=clang CXX=clang++
  cd application/tb-main-loop
  DEFAULT_FEATURES=0 USE_OMPCLUSTER=1 ./get_deps.sh
  DEFAULT_FEATURES=0 USE_OMPCLUSTER=1 ./build_all.sh
'
```

```bash
apptainer exec sifs/improv-144.sif bash -lc '
  export CC=clang CXX=clang++
  cd ./application/taskgraph_experiments
  make -j
'
```

---

## Directory Layout

```
project-root/
├── sifs/                      # Container images
│   ├── improv-144.sif         # For tb-tdg-no-loop
│   └── scheduler-main.sif     # For tb-main-loop
└── application/
    ├── tb-tdg-no-loop/        # No-loop application sources
    ├── tb-main-loop/          # Main-loop application sources
    └── taskgraph_experiments/ # Simulator
```