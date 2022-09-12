#!/bin/bash
if [[ ! -d ~/.buserdev ]]; then
  mkdir -p ~/.buserdev/.cache \
           ~/.buserdev/.config \
           ~/.buserdev/.java \
           ~/.buserdev/.local \
           ~/.buserdev/.android \
           ~/.buserdev/.AndroidStudio3.5
  cid=$(docker create tonylampada/buserdev)
  docker cp $cid:/home/developer/.bashrc ~/.buserdev/
  docker cp $cid:/home/developer/.pyenv ~/.buserdev/
  docker cp $cid:/home/developer/.config ~/.buserdev/
  docker cp $cid:/home/developer/.nvm ~/.buserdev/
  docker cp $cid:/home/developer/Android ~/.buserdev/
  docker rm -v $cid
else # enquanto to desenvolvendo nos plugins do sublime
  cid=$(docker create tonylampada/buserdev)
  docker cp $cid:/home/developer/.config/sublime-text ~/.buserdev/.config
  #docker cp $cid:/home/developer/.nvm ~/.buserdev/
  #docker cp $cid:/home/developer/Android ~/.buserdev/
  docker rm -v $cid
fi

xhost +local:docker
# se for usar o android-studio com emulador, mete um --privileged aí
docker run -it --rm -e DISPLAY=$DISPLAY --net=host --privileged --name=buserdev \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -v ~/work:/home/developer/work \
  -v ~/.ssh:/home/developer/.ssh \
  -v ~/.gitconfig:/home/developer/.gitconfig \
  -v ~/.buserdev/.bashrc:/home/developer/.bashrc \
  -v ~/.buserdev/.cache:/home/developer/.cache \
  -v ~/.buserdev/.config:/home/developer/.config \
  -v ~/.buserdev/.android:/home/developer/.android \
  -v ~/.buserdev/.android:/home/developer/.AndroidStudio3.5 \
  -v ~/.buserdev/Android:/home/developer/Android \
  -v ~/.buserdev/.java:/home/developer/.java \
  -v ~/.buserdev/.local:/home/developer/.local \
  -v ~/.buserdev/.pyenv:/home/developer/.pyenv \
  -v ~/.buserdev/.nvm:/home/developer/.nvm \
  -v $(readlink -f $SSH_AUTH_SOCK):/ssh-agent \
  -e SSH_AUTH_SOCK=/ssh-agent \
 tonylampada/buserdev bash