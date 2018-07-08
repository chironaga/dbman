dbman
===============
dbman is a Database Manipulator for SQLite Database.

## Dependencies
- sequel

## Usage
どんなデータができるのかを知りたい。

1. 操作の前にDBをsnapshot.

```
$ ./db-save.rb ./*.db
```

2. 任意の操作をする

3. DBのレコード数を見る

```
$ ./db-count.rb ./example.db
```

4. レコードが増えている箇所の差分をみてhacking

```
$ ./db-diff.rb ./example.db.old ./example.db.new
```

5. hackが終わったら元の状態に戻す

```
$ ./db-restore.rb ./*.db
```

