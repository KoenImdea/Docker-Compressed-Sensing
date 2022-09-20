docker run -d -p 8888:8888 \
	--name python-slim \
	--rm \
	--mount type=bind,source=/home/koen/Python,target=/home/user/notebooks \
	--mount type=bind,source=/mnt,target=/home/user/data \
	python-slim \
	jupyter-notebook --notebook-dir=~/notebooks --ip=0.0.0.0 --port=8888 --no-browser --NotebookApp.token='' --NotebookApp.password=''
