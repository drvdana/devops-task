FROM docker.io/library/python:3.12-slim AS builder

SHELL ["/bin/bash", "-c"]

WORKDIR /home/appuser

RUN python3 -m venv .venv

COPY requirements.txt .
COPY build.sh .

RUN ./build.sh 

ENV PATH="/home/appuser/.venv/bin:$PATH"

COPY helloapp/ helloapp/
COPY test.sh .

RUN ./test.sh

# ---
# Final Image
FROM docker.io/library/python:3.12-slim

SHELL ["/bin/bash", "-c"]

RUN useradd --create-home appuser
WORKDIR /home/appuser

COPY --from=builder /home/appuser/.venv .venv
COPY helloapp/ helloapp/
COPY run.sh .

ENV PATH="/home/appuser/.venv/bin:$PATH"

RUN chown -R appuser:appuser /home/appuser

EXPOSE 8080
USER appuser

CMD ["./run.sh"]

