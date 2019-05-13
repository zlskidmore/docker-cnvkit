# work from latest LTS ubuntu release
FROM ubuntu:18.04

# set the environment variables
ENV cnvkit_version 0.9.6
ENV r_version 3.5.3
ENV DEBIAN_FRONTEND=noninteractive

# run update and install necessary tools
RUN apt-get update -y && apt-get install -y \
    build-essential \
    vim \
    less \
    curl \
    libnss-sss \
    python3 \
    python3-pip \
    python3-numpy \
    python3-scipy \
    python3-matplotlib \
    python3-reportlab \
    python3-pandas \
    gfortran \
    libreadline-dev \
    libpcre3-dev \
    libcurl4-openssl-dev \
    build-essential \
    zlib1g-dev \
    libbz2-dev \
    liblzma-dev \
    openjdk-8-jdk \
    libssl-dev \
    libxml2-dev \
    wget

# download and install R
WORKDIR /usr/local/bin
RUN wget https://cran.r-project.org/src/base/R-3/R-${r_version}.tar.gz
RUN tar -zxvf R-${r_version}.tar.gz
WORKDIR /usr/local/bin/R-${r_version}
RUN ./configure --prefix=/usr/local/ --with-x=no
RUN make
RUN make install
RUN R --vanilla -e 'install.packages(c("devtools", "BiocManager"), repos="http://cran.us.r-project.org")'
RUN R --vanilla -e 'BiocManager::install(c("DNAcopy"))'

# download and install cnvkit
WORKDIR /usr/local/bin/
RUN curl -SL https://github.com/etal/cnvkit/archive/v${cnvkit_version}.tar.gz \
    | tar -zxvC /usr/local/bin/
WORKDIR /usr/local/bin/cnvkit-${cnvkit_version}
RUN pip3 install -e .

# set default command
CMD ["python3 cnvkit.py --help"]
