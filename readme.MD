# README

## Prerequisites

* **Apptainer** installed and on your `PATH`.

## Container Images

We use two pre-built Apptainer images from our GitLab registry:

| Image Purpose                        | Registry Path                                                                                       | Local Filename            |
| ------------------------------------ | --------------------------------------------------------------------------------------------------- | ------------------------- |
| Build & runtime for `tb-tdg-no-loop` | see below | `sifs/improv-144.sif`     |
| Build & runtime for `tb-main-loop`   | see below | `sifs/scheduler-main.sif` |

Pull both images before proceeding:

```bash
mkdir -p sifs
apptainer pull sifs/improv-144.sif \
  docker://registry.gitlab.com/ompcluster/containers/build-runtime-img/ubuntu20.04-cuda11.2-mpich:1882106760 
  

apptainer pull sifs/scheduler-main.sif \
  docker://registry.gitlab.com/ompcluster/containers/build-runtime-img/ubuntu20.04-cuda11.2-mpich:1854063649
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

```bash
project-root/
├── sifs/                      # Container images
│   ├── improv-144.sif         # For tb-tdg-no-loop
│   └── scheduler-main.sif     # For tb-main-loop
└── application/
    ├── tb-tdg-no-loop/        # No-loop application sources
    ├── tb-main-loop/          # Main-loop application sources
    └── taskgraph_experiments/ # Simulator
```

## Continuous Integration

A GitHub Actions workflow runs the notebooks automatically. It installs the dependencies from `requirements.txt` using Python 3.12, prepares the benchmark data files, executes each notebook with `nbconvert`, and uploads the resulting `plots` directory as a workflow artifact.

