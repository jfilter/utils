conda clean --all --yes;
docker system prune -a -f
trash-empty
rm -rf ~/.cache
