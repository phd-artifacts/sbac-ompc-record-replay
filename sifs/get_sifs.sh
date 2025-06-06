apptainer pull docker://registry.gitlab.com/ompcluster/containers/build-runtime-img/ubuntu20.04-cuda11.2-mpich:1854063649
apptainer pull docker://registry.gitlab.com/ompcluster/containers/build-runtime-img/ubuntu20.04-cuda11.2-mpich:1854061961

mv ubuntu20.04-cuda11.2-mpich_1854063649.sif scheduler-main.sif
mv ubuntu20.04-cuda11.2-mpich_1854061961.sif improv-144.sif