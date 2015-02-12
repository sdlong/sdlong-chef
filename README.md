# This Chef for deploy rails application

## 系統需求：

* ubuntu 14.04 LTS



## 完成後的 Server 設定：

1. 基本 Server 設定 (e.g. apt, git, openssl, openssh ...)

2. Mysql

3. rbenv install ruby 2.1.2

4. Nginx + Unicorn

5. User



## 安裝方式：

### Repo:

1. Fork & git clone 下來

2. `$ bundle install`

3. `$ berks install`


### Vagrant + VirtualBox

1. 到 https://www.vagrantup.com/downloads 下載 Vagrant

2. 到 https://www.virtualbox.org/wiki/Downloads 下載 VirtualBox

3. `$ vagrant box add ubuntu/trusty64`



## 使用方式 ：

### Chef:

1. `$ vagrant up` 開啟虛擬機 (ubuntu 14.04 LTS)

2. `$ cat ~/.ssh/id_rsa.pub | ssh vagrant@10.10.10.10 "mkdir -p /home/vagrant/.ssh && cat >> /home/vagrant/.ssh/authorized_keys"` <br>
    將本機端的 ssh_key copy 到虛擬機， vagrant 的預設密碼是 *vagrant*

3. `$ ssh vagrant@10.10.10.10` (進入虛擬機) <br>
   => `$ ssh-keygen` => `$ more ~/.ssh/id_rsa.pub` <br>
   => 把出來的內容貼到 github account setting -> ssh_key 上

4. `$ knife solo prepare vagrant@10.10.10.10` 設定 chef 環境

5. 『 nodes/10.10.10.10.json.example 』 copy to 『 nodes/10.10.10.10.json 』 <br>
    => 第四行請換成你想設定的 Mysql 密碼

6. 『 data_bags/users/deploy.json.example 』 copy to <br>
   『 data_bags/users/deploy.json 』 (chef cook 用) <br>
   『 data_bags/users/apps.json 』 (capistrano deploy 用) <br>

7. 將上面二個檔案的第四行換成你要設定的密碼，第七行放你本機端的 ssh_key

8. 開始料理！ => `$ knife solo cook vagrant@10.10.10.10`

9. 第一次料理之後會幫你建立二個 user 權限: deploy & apps, <br>
   之後改用 `$ knife solo cook deploy@10.10.10.10` 即可

10. 第二次料理應該就能將環境架好

### Capistrano (以 Rails101s 為例)

1. `$ git clone git@github.com:sdlong/rails101s.git`

2. `$ bundle install`

3. `$ cap production deploy:check` 檢查 & 建立基本資料設定 => 會有 error 要你補尚未放入的檔案

4. `$ ssh apps@10.10.10.10`

5. 建立 rails101 的 databse => `$ mysqladmin -u root -p create rails101` <br>
   密碼在你設定的 nodes/10.10.10.10.json 上面

6. 到 /home/apps/rails101s/shared/config 補上 database.yml & secrets.yml

  ``` database.yml
  production:
    adapter: mysql2
    encoding: utf8
    database: rails101
    pool: 5
    username: root
    password: "xxxxx" # 密碼在你設定的 nodes/10.10.10.10.json 上面
    socket: /var/run/mysqld/mysqld.sock
  ```

  請在 rails repo 上 `$ rake secret` 複製貼上值到檔案上

  ``` secrets.yml
  production:
    secret_key_base: bdg23523...(替換掉)
  ```

7. (回到 rails repo) 再執行 `$ cap production deploy:check` 檢查無誤

8. `$ cap production deploy` 開始 deploy

9. http://10.10.10.10/  deploy 完成！



## 如何自訂

TODO
