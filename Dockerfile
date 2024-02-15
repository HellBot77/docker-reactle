FROM alpine/git AS base

ARG TAG=latest
RUN git clone https://github.com/cwackerfuss/reactle.git && \
    cd reactle && \
    ([[ "$TAG" = "latest" ]] || git checkout ${TAG}) && \
    rm -rf .git

FROM node:alpine as build

WORKDIR /reactle
COPY --from=base /git/reactle .
RUN npm install && \
    export NODE_ENV=production && \
    npm run build

FROM pierrezemb/gostatic

COPY --from=build /reactle/build /srv/http
EXPOSE 8043
