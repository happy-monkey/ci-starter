# ci-starter

## Create a new project

```
composer create-project happy-monkey/ci-starter <project_name>
```

## Makefile

Run yarn install
```
make yarn
```

Compile scss
```
make sass
```

Generate migration file from local database
```
make migration-generate
```

Apply all migrations
```
make migration-migrate
```

Run docker build
```
make build
```

Launch project  
_App URL : http://localhost:8080_  
_phpMyAdmin URL : http://localhost:8001_
```
make install
make up
```

Open shell in app container
```
make exec
```
