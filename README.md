# Python2.6

This uses a reference based on ubuntu to compile python2.6 version
[Reference](https://github.com/lovato/python-2.6.6/blob/master/Dockerfile)

# Testing with docker

To test the image is working you should enable to run the following command:
```bash
docker run --rm -it luighiv/python2.6:latest
```

Now you should load the folder python-mqtt in the container to probe it, so for
this use the following:
```bash
docker run --rm -it --name python-test --mount type=bind,source="$(pwd)"/python-mqtt,target=/home luighiv/python2.6:latest
```

## Add paho library

### Adding manually
Inside the container in the `home` path you should run:
```bash
python -m compileall paho
```
Then copy this version in the corresponding site packages folder for python
2.6:
```bash
cp -r /home/paho /usr/local/lib/python2.6/site-packages/
```

### Via distutils with setup.py
In the repository provided in `python-mqtt` there is a `setup.py` which may be
used to install the library in the local distribution in the image.
```bash
python setup.py install
```

## Python and OpenSSL

To make correctly you should perform the following steps based on the [response](https://stackoverflow.com/questions/44789416/python-build-error-failed-to-build-modules-ssl-and-hashlib):

1. Download the openssl library and perform:
```bash
curl https://ftp.openssl.org/source/old/1.0.2/openssl-1.0.2h.tar.gz -o /tmp/openssl1.0.2.tar.gz
cd /tmp && tar zxvf openssl1.0.2.tar.gz
cd /tmp/openssl-1.0.2h/
./config enable-shared 
make depend
make 
make install
```
2. Configure the path for the library:
```bash
export LD_LIBRARY_PATH=/usr/local/ssl/lib/:$LD_LIBRARY_PATH >> ~/.bashrc
echo $LD_LIBRARY_PATH
```
3. Configure python again, compile and install:
```bash
./configure --with-openssl
make 2>&1 | tee make.txt
make install
```

All this steps are considered in the Dockerfile so you don't need to perform
this steps as long as you use the Dockerfile provided.

> Notes
> 
> To debug make you could add the following:
> ```bash
>  make 2>&1 | tee make.txt
> ```

-------------------
## Testing with a broker
Its better test with a broker also in docker. For this we are going to use the
[ mosquito broker from Eclipse ](https://hub.docker.com/_/eclipse-mosquitto/)

Then we could launch this image from this path, with the script
`launch-broker.sh`.

Then inside the python-mqtt file there is examples to run with no-ssl under
`generic` folder. 

In the host machine you could probe with a subscriber as follows:
```bash
mosquitto_sub -d -h "localhost" -t "example/test"
```

Also you could probe for other public brokers:
```bash
mosquitto_sub -d -h "test.mosquitto.org" -t "example/test"
```

