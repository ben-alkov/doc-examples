FROM registry.access.redhat.com/ubi9/python-312

COPY . /src/simple-color-output
WORKDIR /src/simple-color-output

# Need to source the hermeto.env file to set the environment variables
# (in the same RUN instruction as the pip commands)
RUN source /tmp/hermeto.env \
    && python3 -m pip install -U pip \
    && python3 -m pip install --use-pep517 -r requirements.txt \
    && python3 -m pip install --use-pep517 .

CMD ["python3", "-m", "simple_color_output"]
