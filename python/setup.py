import setuptools

# get version
import nefindata

VERSION = nefindata.__version__

# requirements
with open("./nefindata/requirements.txt", "r") as r:
    reqs = r.read()

# description
with open("README.md", "r") as fh:
    long_description = fh.read()

setuptools.setup(
    name="nefindata",
    version=VERSION,
    license="MIT",
    description="Download data from NEFIN, the Brazilian Center for Research in Financial Economics of the University of São Paulo (http://www.nefin.com.br/)",
    long_description=long_description,
    long_description_content_type="text/markdown",
    author="Fernando Ramacciotti",
    author_email="fernandoramacciotti@gmail.com",
    url="https://github.com/fernandoramacciotti/nefindata",
    packages=setuptools.find_packages(),
    # download_url="https://github.com/user/reponame/archive/v_01.tar.gz",  # I explain this later on
    keywords=[
        "NEFIN",
        "financial",
        "time series",
        "financial market",
        "risk factors",
        "fama french",
        "fama factors",
        "Brazilian market",
    ],
    install_requires=reqs,  # I get to this in a second
    classifiers=[
        "Development Status :: 4 - Beta",
        "Intended Audience :: Developers",
        "Intended Audience :: Financial and Insurance Industry",
        "Intended Audience :: Science/Research",
        "Intended Audience :: Education",
        "Topic :: Software Development :: Build Tools",
        "License :: OSI Approved :: MIT License",
        "Programming Language :: Python :: 3",
        "Programming Language :: Python :: 3.4",
        "Programming Language :: Python :: 3.5",
        "Programming Language :: Python :: 3.6",
        "Programming Language :: Python :: 3.7",
    ],
)
