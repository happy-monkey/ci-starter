# ci-starter

## Create a new project

To create a new project from scratch, juste run following command :
```
composer create-project happy-monkey/ci-starter <project_name>
```

## Makefile commands

### Assets
1. Run yarn install based on package.json. Packages will be downloaded in `/public/vendor` folder.
    ```
    make yarn
    ```

2. Run sass command to compile scss from `public/assets/scss` into compressed css in `public/assets/css` folder.
    ```
    make sass
    ```

### Composer commands

1. Install packages from composer.json.
    ```
    make composer-install
    ```

2. Update composer packages.
    ```
    make composer-update
    ```

3. Require a new package. The package name will be prompted after run command.
    ```
    make composer-require
    ```

4. Remove a package. The package name will be prompted after run command.
    ```
    make composer-remove
    ```

5. Display all package information.
    ```
    make composer-info
    ```

### Run project

1. Run this command the first time. 
   ```
   make init
   ```
   > This will execute following steps : 
   > - install yarn dependencies
   > - compile css
   > - build docker image
   > - run composer install

2. Start project
   ```
   make up
   ```
   > _App URL : http://localhost:8080_  
   > _phpMyAdmin URL : http://localhost:8001_  
   > _MailHog URL : http://localhost:8025_  

3. Open shell in app container
   ```
   make exec
   ```