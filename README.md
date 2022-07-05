# PoC Node.js build

Erick: 

BTW, I had an idea for the development environment on node. 

Every time I spend weeks without working on node, I have to pull the latest code and run make again. Even with caching and JS only enabled it takes hours to compile everything.

My idea is to put a GitHub Action to build a dev docker image on staging-14.x, master, and others.

So when I need to work on some specific branch, I just pull this docker image, map my js files to the container, and start working immediately without recompiling the project.

For new or old maintainers this would spin out the productivity to the top. What do you think?

Rich Trott: 

I think that's an interesting idea and I'm not opposed at all. I have a different idea and I'm about to open a pull request for, though, that tries to solve the same problem.  Go to https://gitpod.io/#https://github.com/Trott/io.js. It will (if you have a GitPod account) open a development environment on the main branch with node already compiled and (hopefully) artifacts cached so small changes compile very quickly. I was going to open a pull request for this today because I really want it in place for a code-and-learn-style event we're planning.
However, your approach might get more traction because it doesn't tie us to a vendor, for example.
So if it's not a ton of work and/or if you don't mind setting it up and having it end up being something not adopted, it would be great to see a proof-of-concept PR or something.

I agree that it's a worthwhile problem to solve--a huge pain point--and it would be great to have multiple solutions to compare/contrast.
Even if you develop/compile Node.js frequently, every time V8 is updated, it takes an hour or two to rebuild. :-(


# Steps to accomplish it

- setup on main, x.x-staging, x.x branches

- Node.js CI builds the whole thing as it does already

- add new github workflow to create the docker image (only for main branches)
  - Dockerfile:
    
    docker pull ubuntu:18.04
    ```sh

    sudo apt install ccache   # for Debian/Ubuntu, included in most Linux distros
    export CC="ccache gcc"    # add to your .profile
    export CXX="ccache g++"   # add to your .profile
    ./configure --node-builtin-modules-path $(pwd)
    make -j8
    ```

  - running
  given v16.x-staging branch 

  git clone nodejs 
  git checkout v16.x-staging
  docker run -it -v $(pwd):/node erickwendel/node-dev-js:v16.x-staging
    > ./node -v

  -


  docker build -t node-devjs-builder:v16.x-staging .
  docker run --name node-devjs-builder -v $(pwd)/node:/node -it node-devjs-builder bash
  time docker cp node-devjs-builder:/node node
  
  #make -j6  13030.26s user 1862.09s system 148% cpu 2:46:54.66 total
