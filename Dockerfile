# alwyas use slim and the lastest debian distro offered
FROM node:16-bullseye-slim as base

# change permissions to non-root user
RUN mkdir /main
# RUN mkdir /main && chown -R node:node  /main

WORKDIR /main

EXPOSE 3000
# USER node

# copy in with correct permissions. Using * prevents errors if file is missing
COPY package*.json yarn*.lock ./
# COPY --chown=node:node package*.json yarn*.lock ./


RUN npm install && npm cache clean --force
# copy files with correct permissions
# COPY --chown=node:node  . .
COPY  . .


RUN npm run build


FROM base as dev

# Install the Prisma client
RUN npx prisma generate

CMD ["npm", "run", "dev"]

FROM base as prod

ENV NODE_ENV=production

CMD ["npm", "run", "start"]
