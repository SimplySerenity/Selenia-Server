FROM shufo/phoenix

COPY . /app

WORKDIR /app

CMD ["sh", "-c", "mix deps.get && mix phx.server"]