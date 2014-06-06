hulk
====

Hulk is an ultra simple command line tool for running a list of bash commands synchronously.


## Usage

After adding a `hulk.yml` file to your project root, simply reference the following example to add hulk builds.

```YML
push:
  - "git add ."
  - "git commit -m 'Made some changes.'"
  - "git push origin master"
deploy:
  - --push
  - "git push -f heroku dev:master"
```

The above example will give you the following: 
 1. Calling `hulk push` will run the 3 commands you see under `push:`, in the order they appear, in a synchronous manner.
 2. Calling `hulk deploy` will run the `push` build, and then run the push to the heroku server. 

### Nesting builds

As shown in the above example, you can call other builds within your current build. Simply prefix the build name with `--` and hulk will understand what you're asking. After running the other build, hulk will continue on with the initial build called.

You can mix and match builds with commands, and nest builds as frequent, or infrequent as you like. Hulk can handle it.