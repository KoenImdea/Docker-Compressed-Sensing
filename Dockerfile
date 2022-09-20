FROM python:3.10-bullseye
MAINTAINER "Koen"

#Create Root password
RUN --mount=type=secret,id=passwd . /run/secrets/passwd \
	&& echo root:${PASSWD} | chpasswd
#RUN echo root:--mount=type=secret,id=passwd cat /run/secrets/passwd | chpasswd

#USER_ID and Group_ID should come from external
ARG USER_ID
ARG GROUP_ID

#Create User
RUN addgroup --gid $GROUP_ID user
RUN adduser --disabled-password --gecos '' --uid $USER_ID --gid $GROUP_ID user


USER user
WORKDIR /home/user
ENV PATH="$PATH:/home/user/.local/bin"
#Install Dependencies
RUN python -m pip install numba
RUN python -m pip install notebook
RUN python -m pip install spiepy
RUN python -m pip install nanonispy

#copy libbfgs
COPY --chown=user:user ./liblbfgs-1.10 /home/user/liblbfgs-1.10
COPY --chown=user:user ./pylbfgs /home/user/pylbfgs

#setup libbfgs
WORKDIR /home/user/liblbfgs-1.10
RUN ./autogen.sh
RUN ./configure --enable-sse2
RUN make
USER root
RUN make install

#setup pylbfgs
WORKDIR /home/user/pylbfgs
RUN python -m pip install numpy
RUN python setup.py install

#Reset user and workdir
USER user
WORKDIR /home/user


# Configuring access to Jupyter
RUN mkdir ~/notebooks
RUN mkdir ~/data
RUN ~/.local/bin/jupyter-notebook --generate-config

# Jupyter listens port: 8888
EXPOSE 8888
# Run Jupytewr notebook as Docker main process

#CMD ["jupyter-notebook", "--notebook-dir=~/notebooks", "--ip='*'", "--port=8888", "--no-browser"]
