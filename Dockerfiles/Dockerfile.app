FROM node:16

LABEL maintainer="Jakub Nowak"

WORKDIR /jestApp

RUN git clone https://github.com/Qba02/jest-example-app.git

WORKDIR /jestApp/jest-example-app

RUN yarn install --omit=dev
RUN yarn run build
RUN npm install -g serve