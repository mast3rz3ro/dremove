# dremove

**A pure Bash script to remove duplicated files with ease.**

## remove duplicated files with ease.

### How to install:

```Bash
git clone https://github.com/mast3rz3ro/dremove && chmod +x dremove/dremove.sh && cp dremove/dremove.sh "$PREFIX/bin/dremove"
```

### How to use:

* Remove files with same hash:
```Bash
$ dremove somedir
```

* Remove any file with same hash:
```Bash
$ dremove somedir anotherdir moredir
```

* Enable quick test mode:
```Bash
$ export mode=test
$ dremove
generating test...
writting into: ./test/file 1 of 3.txt
writting into: ./test/file 2 of 3.txt
writting into: ./test/file 3 of 3.txt
creating log file: ~/dremove.log
generating hash: './test/file 1 of 3.txt'
generating hash: './test/file 2 of 3.txt'
found duplicated file: './test/file 2 of 3.txt' 9ffe7fef10741fb76dee5a345efc70b5
generating hash: './test/file 3 of 3.txt'
found duplicated file: './test/file 3 of 3.txt' 9ffe7fef10741fb76dee5a345efc70b5
total files: 3
total unique: 1
total removed: 2
total errors: 0
```


### License:

* GNU GPL-2.0 or later.

