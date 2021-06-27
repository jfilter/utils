#!/usr/bin/env bash
set -ex

# usage `cn someenv python=3.8` to specify the Python version

conda create -n "$1" "$2"
eval "$(conda shell.bash hook)"
conda activate "$1"
conda install -y -c conda-forge pandas poppler jupyterlab_code_formatter jupyterlab nodejs matplotlib black isort pylint scikit-learn spacy tqdm
pip install pillow pdf2image
jupyter labextension install @ryantam626/jupyterlab_code_formatter
jupyter serverextension enable --py jupyterlab_code_formatter
pip install ipywidgets
jupyter nbextension enable --py widgetsnbextension
jupyter labextension install @jupyter-widgets/jupyterlab-manager
