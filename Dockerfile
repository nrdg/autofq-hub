# Choose your desired base image
FROM cschranz/gpu-jupyter:v1.4_cuda-11.2_ubuntu-20.04_python-only

# name your environment and choose the python version
ARG conda_env=afqinsight
ARG py_ver=3.7

# you can add additional libraries you want mamba to install by listing them below the first line and ending with "&& \"
# RUN mamba create --quiet --yes -p "${CONDA_DIR}/envs/${conda_env}" python=${py_ver} ipython ipykernel && \
#    mamba clean --all -f -y

# alternatively, you can comment out the lines above and uncomment those below
# if you'd prefer to use a YAML file present in the docker build context

COPY --chown=${NB_UID}:${NB_GID} environment.yml "/home/${NB_USER}/tmp/"
RUN cd "/home/${NB_USER}/tmp/" && \
     mamba env create -p "${CONDA_DIR}/envs/${conda_env}" -f environment.yml && \
     mamba clean --all -f -y

# create Python kernel and link it to jupyter
RUN "${CONDA_DIR}/envs/${conda_env}/bin/python" -m ipykernel install --user --name="${conda_env}" && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"

# any additional pip installs can be added by uncommenting the following line
# RUN "${CONDA_DIR}/envs/${conda_env}/bin/pip" install --quiet --no-cache-dir

# if you want this environment to be the default one, uncomment the following line:
# RUN echo "conda activate ${conda_env}" >> "${HOME}/.bashrc"
