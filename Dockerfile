FROM amarburg/covis-postprocess:R2018a

RUN apt-get update && apt install -yq --no-install-recommends \
                            libarchive-dev netcat p7zip-full && \
      rm -rf /var/lib/apt/lists/*

# Pre-install dependencies by hand so they get cached in an earlier
#     Docker layer
RUN pip3 install --upgrade celery flower minio pymongo libarchive \
            python-decouple requests boto3 paramiko

# Install the local python packages
WORKDIR /code/covis-worker
ADD setup.py Makefile wait-for-it.sh ./
ADD apps/          ./apps/
ADD covis_db/      ./covis_db/
ADD covis_worker/  ./covis_worker/
ADD seed_data/seed_data.bson ./

## Make input/ directory local to working directory.
RUN ln -s ~/input .

RUN pip3 install -e .

## Switch to non-root user "covis"
RUN groupadd -g 999 covis && \
    useradd -r -u 999 -g covis covis
RUN chown -R covis:covis /code
USER covis

ENV LD_LIBRARY_PATH=$MATLAB_LD_LIBRARY_PATH

## Back to default entrypoint
ENTRYPOINT []
CMD ["make", "worker"]
