# MacOS Virtual Environment setup for python 3.7.x or higher

- It's strongly recommended to have python virtual environment setup for any projects/or development work, 
especially working with CI/CD Applications on contiannerized platforms.

> [python.org](https://www.python.org/)

### Steps
```sh

$pip install virtualenv                 #assume python3.7.x or higher version had been installed from python.org

$python(3) -m venv /path-to/myvenv  	#create a virtual env called myvenv
$source /path-to/myvenv/bin/activate	#activate virtual env
or
$. /path-to/myvenv/bin/activate

You will see a prompt shown below:
(myvenv) hostname:~
(myvenv) hostname:~ which python        #to show what path of python and pip are used
(myvenv) hostname:~ which pip
(myvenv) hostname:~ pip list
Package    Version
---------- -------
pip        19.2.3 
setuptools 40.8.0
```

### Create a requirements.txt file containing python packages/versions that you would like to install
If you have already installed standard python packages on non-virtual env,
you can open another Linux/MacOS shell and do the following: 
```sh
$pip freeze > requirements.txt
```
>For example of ML packages:
```sh
numpy==1.16.2
pandas==0.24.1
matplotlib==3.0.2
ipython==7.3.0
scikit-learn==0.20.2
scikit-image==0.15.0
seaborn==0.9.0
jupyter==1.0.0
```
Move this requirements.txt to /path-to/myvenv and run the following:
```sh
(myvenv) hostname:~ pip install -r requirements.txt
```
