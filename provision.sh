# install git docker
sudo yum install -y git docker > /dev/null 2>&1

# config docker
sudo service docker start
sudo chmod 666 /var/run/docker.sock

# clone and build docker image
git clone --depth=1 https://github.com/be5invis/Iosevka.git $HOME/mkdkimg
cd $HOME/mkdkimg/docker
docker build -t=fontcc .
cd $HOME
rm -rf mkdkimg/

# build Iosevka custom font
docker run -i --rm \
    -v $HOME/font_build:/work \
    --cpuset-cpus="0-13" \
    --memory="29g" \
    --oom-kill-disable \
    fontcc \
    --jCmd=9 \
    ttf::GitpIosevka_1 ttf-unhinted::GitpIosevka_1

