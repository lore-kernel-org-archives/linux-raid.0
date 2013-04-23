From: Andrei Banu <andrei.banu@redhost.ro>
Subject: Re: Incredibly poor performance of mdraid-1 with 2 SSD Samsung 840
 PRO
Date: Tue, 23 Apr 2013 13:17:59 +0300
Message-ID: <51765FD7.8090309@redhost.ro>
References: <5171CBF9.9020701@redhost.ro> <51732E2B.6090607@hardwarefreak.com> <5174501F.80509@redhost.ro> <51747382.1010105@hardwarefreak.com> <5a749bb56c88b6d6b8a806694b163bda@redhost.ro> <5175F71A.8030805@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5175F71A.8030805@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I am sorry for the very long email. And thanks a lot for all your patience.

1. DMESG doesn't show any "hard resetting link" at all.

2. The SSDs are connected to ATA 0 and ATA1. The server is brand new (or 
at least it should be).

3. Partition table:

root [~]# cat /etc/fstab
# Created by anaconda on Wed Apr  3 17:22:52 2013

UUID=8fedde2c-f5b7-4edf-975f-d8d087d79ebf       /       ext4 
noatime,usrjquota=quota.user,jqfmt=vfsv0        1       1
UUID=bfc50d02-6d4d-4510-93ea-27941cd49cf4 /boot ext4    
noatime,defaults        1 2
UUID=cef1d19d-2578-43db-9ffc-b6b70e227bfa swap swap    defaults        0 0
tmpfs                   /dev/shm                tmpfs defaults        0 0
devpts                  /dev/pts                devpts gid=5,mode=620  0 0
sysfs                   /sys                    sysfs defaults        0 0
proc                    /proc                   proc defaults        0 0
/usr/tmpDSK             /tmp                    ext3 
noatime,defaults,noauto        0 0

root [~]# cat /etc/mdadm.conf
# mdadm.conf written out by anaconda
MAILADDR root
AUTO +imsm +1.x -all
ARRAY /dev/md0 level=raid1 num-devices=2 
UUID=8a4b7005:a4f71a13:7d4659cf:104f9a4f
ARRAY /dev/md1 level=raid1 num-devices=2 
UUID=ead5b5ca:9f5397a2:3b488cbe:11eb8bdb
ARRAY /dev/md2 level=raid1 num-devices=2 
UUID=44efd14d:8bcd26d4:4d1fda9f:a4b5fe14

root [/]# mount
/dev/md2 on / type ext4 (rw,noatime,usrjquota=quota.user,jqfmt=vfsv0)
proc on /proc type proc (rw)
sysfs on /sys type sysfs (rw)
devpts on /dev/pts type devpts (rw,gid=5,mode=620)
tmpfs on /dev/shm type tmpfs (rw,rootcontext="system_u:object_r:tmpfs_t:s0")
/dev/md0 on /boot type ext4 (rw,noatime)
none on /proc/sys/fs/binfmt_misc type binfmt_misc (rw)
/usr/tmpDSK on /tmp type ext3 (rw,noexec,nosuid,loop=/dev/loop0)
/tmp on /var/tmp type none (rw,noexec,nosuid,bind)

And now the tests you indicated:

4.
root [/]# echo 3 > /proc/sys/vm/drop_caches
root [~]# time cp largefile.tar.gz test03.tmp; time sync;

(this is probably when the file is read into some swap/cache)
real    0m3.052s
user    0m0.010s
sys     0m0.612s

(this is probably when the file is actually written)
real    1m2.570s
user    0m0.000s
sys     0m0.011s

root [/]# echo 3 > /proc/sys/vm/drop_caches
root [~]# time cp largefile.tar.gz test04.tmp;

real    0m3.848s
user    0m0.004s
sys     0m0.634s

After about 15 seconds the server load started to increase from 1, 
spiked to 40 in about a minute and then it started decreasing.

5. The perf top -U output during a dd copy:

Samples: 2M of event 'cycles', Event count (approx.): 19505138470
   9.10%  [kernel]             [k] page_fault
   5.56%  [kernel]             [k] clear_page_c_e
   3.29%  [kernel]             [k] list_del
   2.51%  [kernel]             [k] unmap_vmas
   2.50%  [kernel]             [k] __mem_cgroup_commit_charge
   2.50%  [kernel]             [k] mem_cgroup_update_file_mapped
   2.26%  [kernel]             [k] port_inb
   1.89%  [kernel]             [k] shmem_getpage_gfp
   1.78%  [kernel]             [k] _spin_lock
   1.72%  [kernel]             [k] __alloc_pages_nodemask
   1.67%  [kernel]             [k] __mem_cgroup_uncharge_common
   1.61%  [kernel]             [k] free_pcppages_bulk
   1.59%  [kernel]             [k] get_page_from_freelist
   1.56%  [kernel]             [k] alloc_pages_vma
   1.37%  [kernel]             [k] get_page
   1.26%  [kernel]             [k] release_pages
   1.22%  [kernel]             [k] radix_tree_lookup_slot
   1.19%  [kernel]             [k] lookup_page_cgroup
   1.11%  [kernel]             [k] handle_mm_fault
   0.98%  [kernel]             [k] __wake_up_bit
   0.98%  [kernel]             [k] copy_page_c
   0.97%  [kernel]             [k] __d_lookup
   0.94%  [kernel]             [k] __do_fault
   0.92%  [kernel]             [k] free_hot_cold_page
   0.80%  [kernel]             [k] find_vma

6. iotop is very dynamic and I am afraid the data I am providing will be 
unclear but let me give a number of snapshots from during the large file 
copy and maybe you can make something of it (samples a few seconds apart):

Total DISK READ: 15.39 K/s | Total DISK WRITE: 169.29 M/s
   TID  PRIO  USER     DISK READ  DISK WRITE  SWAPIN      IO COMMAND
  4236 be/4 nobody      0.00 B/s    0.00 B/s  0.00 %  0.00 % [httpd]
  4662 be/4 nobody      0.00 B/s    0.00 B/s  0.00 %  0.00 % [httpd]
31126 be/4 mysql       0.00 B/s   46.17 K/s  0.00 %  0.00 % mysqld 
--basedir=/ --datadir=/var/lib/mysql --user=mysql 
--log-error=/var/lib/mysql/server.err --open-files-limit=50000 
--pid-file=/var/$
  4971 be/4 nobody      0.00 B/s   23.08 K/s  0.00 %  0.00 % [httpd]
  5284 be/4 nobody      0.00 B/s    7.69 K/s  0.00 %  0.00 % [httpd]
  9522 be/4 user    7.69 K/s   38.47 K/s  0.00 %  0.00 % spamd child
  5547 be/4 nobody      0.00 B/s    7.69 K/s  0.00 %  0.00 % [httpd]

!!!!!! 6085 be/4 root        7.69 K/s 1004.85 M/s  0.00 %  0.00 % dd 
if=largefile.tar.gz of=test10 oflag=sync bs=1G

Total DISK READ: 7.71 K/s | Total DISK WRITE: 29.91 M/s
   TID  PRIO  USER     DISK READ  DISK WRITE  SWAPIN      IO COMMAND
   506 be/4 root        0.00 B/s    0.00 B/s  0.00 % 99.99 % [md2_raid1]
30861 be/4 root        0.00 B/s    7.71 K/s  0.00 %  0.00 % httpd -k 
start -DSSL
31346 be/4 root        0.00 B/s    7.71 K/s  0.00 %  0.00 % tailwatchd
  1457 be/3 root        0.00 B/s    7.71 K/s  0.00 %  0.00 % auditd
  5914 be/4 root        7.71 K/s    0.00 B/s  0.00 %  0.00 % cpanellogd 
- scanning logs
  6085 be/4 root        0.00 B/s    7.71 K/s  0.00 %  0.00 % dd 
if=largefile.tar.gz of=test10 oflag=sync bs=1G

Total DISK READ: 0.00 B/s | Total DISK WRITE: 29.30 M/s
   TID  PRIO  USER     DISK READ  DISK WRITE  SWAPIN      IO COMMAND
  9522 be/4 user    0.00 B/s    0.00 B/s  0.00 % 99.99 % spamd child
   506 be/4 root        0.00 B/s    0.00 B/s  0.00 % 99.99 % [md2_raid1]
31346 be/4 root        0.00 B/s    7.73 K/s  0.00 %  0.00 % tailwatchd
  1397 be/4 root        0.00 B/s    7.73 K/s  0.00 %  0.00 % [flush-9:2]
  6085 be/4 root        0.00 B/s   15.45 K/s  0.00 %  0.00 % dd 
if=largefile.tar.gz of=test10 oflag=sync bs=1G

Total DISK READ: 12.43 K/s | Total DISK WRITE: 5.96 M/s
   TID  PRIO  USER     DISK READ  DISK WRITE  SWAPIN      IO COMMAND
  5914 be/4 root        0.00 B/s    0.00 B/s  0.00 % 99.99 % cpanellogd 
- setting up logs for promusic
  6101 be/4 mailnull    0.00 B/s  353.61 B/s  0.00 % 99.99 % exim -bd -q1h
  6107 be/4 user     0.00 B/s    0.00 B/s  0.00 % 99.99 % pop3
  6124 be/4 nobody      0.00 B/s  353.61 B/s  0.00 % 99.99 % httpd -k 
start -DSSL
  9522 be/4 user 1060.83 B/s  184.06 K/s  0.00 % 99.99 % spamd child
  1669 be/4 root        0.00 B/s    2.42 K/s  0.00 % 99.99 % rsyslogd -i 
/var/run/syslogd.pid -c 5
  1235 be/4 root        0.00 B/s    2.42 K/s  0.00 % 98.28 % [kjournald]
   506 be/4 root        0.00 B/s    0.00 B/s  0.00 % 28.46 % [md2_raid1]
   541 be/3 root        0.00 B/s   34.04 M/s  0.00 %  3.43 % [jbd2/md2-8]

Total DISK READ: 303.21 K/s | Total DISK WRITE: 60.64 M/s
   TID  PRIO  USER     DISK READ  DISK WRITE  SWAPIN      IO COMMAND
  1235 be/4 root        0.00 B/s   60.64 K/s  0.00 % 99.99 % [kjournald]
   541 be/3 root        0.00 B/s    0.00 B/s  0.00 % 96.16 % [jbd2/md2-8]
  1232 be/0 root        0.00 B/s    0.00 B/s  0.00 % 81.07 % [loop0]
11449 be/4 mysql     250.15 K/s    0.00 B/s  0.00 % 12.84 % mysqld 
--basedir=/ --datadir=/var/lib/mysql --user=mysql 
--log-error=/var/lib/mysql/server.err --open-files-limit=50000 
--pid-file=/var/$
  6085 be/4 root        7.58 K/s   30.32 K/s  0.00 %  5.24 % dd 
if=largefile.tar.gz of=test10 oflag=sync bs=1G

Total DISK READ: 2023.83 K/s | Total DISK WRITE: 82.31 M/s
   TID  PRIO  USER     DISK READ  DISK WRITE  SWAPIN      IO COMMAND
  6085 be/4 root        0.00 B/s   38.04 K/s  0.00 % 99.99 % dd 
if=largefile.tar.gz of=test10 oflag=sync bs=1G
  6267 be/4 user    0.00 B/s    0.00 B/s  0.00 % 99.99 % pop3
  6291 be/4 user     0.00 B/s    0.00 B/s  0.00 % 99.99 % pop3
   541 be/3 root        0.00 B/s  492.43 M/s  0.00 % 99.99 % [jbd2/md2-8]
  6282 be/4 nobody    730.40 K/s    0.00 B/s  0.00 % 99.99 % httpd -k 
start -DSSL
   506 be/4 root        0.00 B/s    0.00 B/s  0.00 % 52.39 % [md2_raid1]

Total DISK READ: 74.61 K/s | Total DISK WRITE: 8.66 M/s
   TID  PRIO  USER     DISK READ  DISK WRITE  SWAPIN      IO COMMAND
  6282 be/4 nobody     26.55 K/s    0.00 B/s  0.00 % 97.65 % httpd -k 
start -DSSL
   541 be/3 root        0.00 B/s    7.04 M/s  0.00 % 95.64 % [jbd2/md2-8]
  1235 be/4 root        0.00 B/s    0.00 B/s  0.00 % 94.07 % [kjournald]
  1394 be/4 root        0.00 B/s    0.00 B/s  0.00 % 89.26 % [flush-7:0]
   506 be/4 root        0.00 B/s    0.00 B/s  0.00 % 31.66 % [md2_raid1]

Total DISK READ: 544.44 K/s | Total DISK WRITE: 82.08 M/s
   TID  PRIO  USER     DISK READ  DISK WRITE  SWAPIN      IO COMMAND
  1235 be/4 root        0.00 B/s  129.31 K/s  0.00 % 99.99 % [kjournald]
   541 be/3 root        0.00 B/s   63.57 M/s  0.00 % 99.99 % [jbd2/md2-8]
31119 be/4 mysql       0.00 B/s   61.25 K/s  0.00 % 88.49 % mysqld 
--basedir=/ --datadir=/var/lib/mysql --user=mysql 
--log-error=/var/lib/mysql/server.err --open-files-limit=50000 
--pid-file=/var/$
   506 be/4 root        0.00 B/s    0.00 B/s  0.00 % 72.41 % [md2_raid1]
31346 be/4 root        0.00 B/s   20.42 K/s  0.00 % 69.36 % tailwatchd
  1232 be/0 root        0.00 B/s  183.75 K/s  0.00 % 54.04 % [loop0]
  6085 be/4 root        3.40 K/s   40.83 K/s  0.00 % 26.49 % dd 
if=largefile.tar.gz of=test10 oflag=sync bs=1G
11561 be/4 mysql       0.00 B/s   45.64 M/s  0.00 %  0.00 % mysqld 
--basedir=/ --datadir=/var/lib/mysql --user=mysql 
--log-error=/var/lib/mysql/server.err --open-files-limit=50000 
--pid-file=/var/$

I have also run it with the "-a" flag and there is something interesting 
(looong though heavily greped output below).
This is taken during the 'dd oflag=sync' copy. It seems it does 
something right at the beginning (writes about 250MB of that files) than 
it mostly idles through the end:

Total DISK READ: 333.35 K/s | Total DISK WRITE: 38.76 M/s
   PID  PRIO  USER     DISK READ  DISK WRITE  SWAPIN      IO    COMMAND
   541 be/3 root          0.00 B    332.00 K  0.00 %  0.49 % [jbd2/md2-8]
13467 be/4 root          0.00 B      4.00 K  0.00 %  0.00 % python /usr/bin/iotop -baoP -d 1
13479 be/4 root          4.00 K    250.12 M  0.00 %  0.00 % dd if=largefile.tar.gz of=test11 oflag=sync bs=1G

Total DISK READ: 4.84 M/s | Total DISK WRITE: 11.77 K/s
   PID  PRIO  USER     DISK READ  DISK WRITE  SWAPIN      IO    COMMAND
   541 be/3 root          0.00 B    332.00 K  0.00 %  0.37 % [jbd2/md2-8]
13467 be/4 root          0.00 B      4.00 K  0.00 %  0.00 % python /usr/bin/iotop -baoP -d 1
13479 be/4 root          4.00 K    250.12 M  0.00 %  0.00 % dd if=largefile.tar.gz of=test11 oflag=sync bs=1G

Total DISK READ: 0.00 B/s | Total DISK WRITE: 379.93 K/s
   PID  PRIO  USER     DISK READ  DISK WRITE  SWAPIN      IO    COMMAND
   541 be/3 root          0.00 B    332.00 K  0.00 %  0.30 % [jbd2/md2-8]
13467 be/4 root          0.00 B      8.00 K  0.00 %  0.00 % python /usr/bin/iotop -baoP -d 1
13479 be/4 root          4.00 K    250.12 M  0.00 %  0.00 % dd if=largefile.tar.gz of=test11 oflag=sync bs=1G
  1232 be/0 root          0.00 B    244.00 K  0.00 %  0.00 % [loop0]
  1397 be/4 root          0.00 B     24.00 K  0.00 %  0.00 % [flush-9:2]

Total DISK READ: 0.00 B/s | Total DISK WRITE: 69.69 M/s
   PID  PRIO  USER     DISK READ  DISK WRITE  SWAPIN      IO    COMMAND
13479 be/4 root          4.00 K    250.16 M  0.00 % 79.98 % dd if=largefile.tar.gz of=test11 oflag=sync bs=1G
   541 be/3 root          0.00 B    458.64 M  0.00 %  0.25 % [jbd2/md2-8]
13467 be/4 root          0.00 B      8.00 K  0.00 %  0.00 % python /usr/bin/iotop -baoP -d 1
  1232 be/0 root          0.00 B    244.00 K  0.00 %  0.00 % [loop0]
  1397 be/4 root          0.00 B     24.00 K  0.00 %  0.00 % [flush-9:2]

Total DISK READ: 20.81 K/s | Total DISK WRITE: 6.07 M/s
   PID  PRIO  USER     DISK READ  DISK WRITE  SWAPIN      IO    COMMAND
   541 be/3 root          0.00 B    765.19 M  0.00 % 83.17 % [jbd2/md2-8]
  1235 be/4 root          0.00 B      0.00 B  0.00 % 78.06 % [kjournald]
13479 be/4 root          8.00 K    250.24 M  0.00 % 60.66 % dd if=largefile.tar.gz of=test11 oflag=sync bs=1G
   506 be/4 root          0.00 B      0.00 B  0.00 % 35.01 % [md2_raid1]
  1394 be/4 root          0.00 B      0.00 B  0.00 % 11.25 % [flush-7:0]

Total DISK READ: 43.28 K/s | Total DISK WRITE: 34.09 M/s
   PID  PRIO  USER     DISK READ  DISK WRITE  SWAPIN      IO    COMMAND
   541 be/3 root          0.00 B    767.47 M  0.00 % 84.84 % [jbd2/md2-8]
  1235 be/4 root          0.00 B     28.00 K  0.00 % 70.65 % [kjournald]
13479 be/4 root         12.00 K    250.29 M  0.00 % 65.12 % dd if=largefile.tar.gz of=test11 oflag=sync bs=1G
   506 be/4 root          0.00 B      0.00 B  0.00 % 31.81 % [md2_raid1]
  1232 be/0 root          0.00 B   1568.00 K  0.00 % 14.57 % [loop0]
  1394 be/4 root          0.00 B      0.00 B  0.00 %  9.71 % [flush-7:0]
  1397 be/4 root          0.00 B      3.44 M  0.00 %  1.47 % [flush-9:2]
13467 be/4 root          0.00 B     12.00 K  0.00 %  0.00 % python /usr/bin/iotop -baoP -d 1

Total DISK READ: 3.85 K/s | Total DISK WRITE: 35.28 M/s
   PID  PRIO  USER     DISK READ  DISK WRITE  SWAPIN      IO    COMMAND
   541 be/3 root          0.00 B    768.32 M  0.00 % 84.36 % [jbd2/md2-8]
  1235 be/4 root          0.00 B     28.00 K  0.00 % 83.53 % [kjournald]
13479 be/4 root         12.00 K    250.30 M  0.00 % 65.05 % dd if=largefile.tar.gz of=test11 oflag=sync bs=1G
   506 be/4 root          0.00 B      0.00 B  0.00 % 32.55 % [md2_raid1]
  1232 be/0 root          0.00 B   1568.00 K  0.00 % 14.21 % [loop0]
  1394 be/4 root          0.00 B      0.00 B  0.00 %  9.46 % [flush-7:0]
  1397 be/4 root          0.00 B      3.45 M  0.00 %  1.48 % [flush-9:2]

Total DISK READ: 3.91 K/s | Total DISK WRITE: 3.91 K/s
   PID  PRIO  USER     DISK READ  DISK WRITE  SWAPIN      IO    COMMAND
   541 be/3 root          0.00 B    768.32 M  0.00 % 82.29 % [jbd2/md2-8]
  1235 be/4 root          0.00 B     28.00 K  0.00 % 81.48 % [kjournald]
13479 be/4 root         12.00 K    250.30 M  0.00 % 63.37 % dd if=largefile.tar.gz of=test11 oflag=sync bs=1G
   506 be/4 root          0.00 B      0.00 B  0.00 % 31.75 % [md2_raid1]
  1232 be/0 root          0.00 B   1568.00 K  0.00 % 13.86 % [loop0]
  1394 be/4 root          0.00 B      0.00 B  0.00 %  9.23 % [flush-7:0]
  1397 be/4 root          0.00 B      3.45 M  0.00 %  1.44 % [flush-9:2]
13467 be/4 root          0.00 B     28.00 K  0.00 %  0.00 % python /usr/bin/iotop -baoP -d 1

Total DISK READ: 15.64 K/s | Total DISK WRITE: 15.32 M/s
   PID  PRIO  USER     DISK READ  DISK WRITE  SWAPIN      IO    COMMAND
   541 be/3 root          0.00 B    768.71 M  0.00 % 85.51 % [jbd2/md2-8]
  1235 be/4 root          0.00 B     28.00 K  0.00 % 79.53 % [kjournald]
13479 be/4 root         12.00 K    250.31 M  0.00 % 61.78 % dd if=largefile.tar.gz of=test11 oflag=sync bs=1G
   506 be/4 root          0.00 B      0.00 B  0.00 % 36.15 % [md2_raid1]
  1232 be/0 root          0.00 B   1568.00 K  0.00 % 13.53 % [loop0]
  1394 be/4 root          0.00 B      0.00 B  0.00 %  9.01 % [flush-7:0]
  1397 be/4 root          0.00 B      3.45 M  0.00 %  6.60 % [flush-9:2]
13467 be/4 root          0.00 B     32.00 K  0.00 %  0.00 % python /usr/bin/iotop -baoP -d 1

Total DISK READ: 0.00 B/s | Total DISK WRITE: 0.00 B/s
   PID  PRIO  USER     DISK READ  DISK WRITE  SWAPIN      IO    COMMAND
   541 be/3 root          0.00 B    768.71 M  0.00 % 85.77 % [jbd2/md2-8]
  1235 be/4 root          0.00 B     28.00 K  0.00 % 75.90 % [kjournald]
13479 be/4 root         12.00 K    250.31 M  0.00 % 58.82 % dd if=largefile.tar.gz of=test11 oflag=sync bs=1G
   506 be/4 root          0.00 B      0.00 B  0.00 % 34.51 % [md2_raid1]
  1232 be/0 root          0.00 B   1568.00 K  0.00 % 12.91 % [loop0]
  1394 be/4 root          0.00 B      0.00 B  0.00 %  8.60 % [flush-7:0]
  1397 be/4 root          0.00 B      3.45 M  0.00 %  6.30 % [flush-9:2]
31346 be/4 root          0.00 B    120.00 K  0.00 %  3.42 % tailwatchd
13467 be/4 root          0.00 B     44.00 K  0.00 %  0.00 % python /usr/bin/iotop -baoP -d 1

Total DISK READ: 19.56 K/s | Total DISK WRITE: 10.12 M/s
   PID  PRIO  USER     DISK READ  DISK WRITE  SWAPIN      IO    COMMAND
   541 be/3 root          0.00 B    768.76 M  0.00 % 86.39 % [jbd2/md2-8]
  1235 be/4 root          0.00 B     28.00 K  0.00 % 74.21 % [kjournald]
13479 be/4 root         12.00 K    250.31 M  0.00 % 64.36 % dd if=largefile.tar.gz of=test11 oflag=sync bs=1G
   506 be/4 root          0.00 B      0.00 B  0.00 % 39.86 % [md2_raid1]
  1232 be/0 root          0.00 B   1568.00 K  0.00 % 12.62 % [loop0]
  1394 be/4 root          0.00 B      0.00 B  0.00 %  8.41 % [flush-7:0]
  1397 be/4 root          0.00 B      3.46 M  0.00 %  6.16 % [flush-9:2]
13467 be/4 root          0.00 B     48.00 K  0.00 %  0.00 % python /usr/bin/iotop -baoP -d 1

Total DISK READ: 0.00 B/s | Total DISK WRITE: 15.65 K/s
   PID  PRIO  USER     DISK READ  DISK WRITE  SWAPIN      IO    COMMAND
   541 be/3 root          0.00 B    768.76 M  0.00 % 87.13 % [jbd2/md2-8]
  1235 be/4 root          0.00 B     28.00 K  0.00 % 72.58 % [kjournald]
13479 be/4 root         12.00 K    250.31 M  0.00 % 65.64 % dd if=largefile.tar.gz of=test11 oflag=sync bs=1G
   506 be/4 root          0.00 B      0.00 B  0.00 % 38.98 % [md2_raid1]
  1232 be/0 root          0.00 B   1568.00 K  0.00 % 12.34 % [loop0]
  1394 be/4 root          0.00 B      0.00 B  0.00 %  8.22 % [flush-7:0]
  1397 be/4 root          0.00 B      3.46 M  0.00 %  6.03 % [flush-9:2]
13467 be/4 root          0.00 B     52.00 K  0.00 %  0.00 % python /usr/bin/iotop -baoP -d 1

Total DISK READ: 46.71 K/s | Total DISK WRITE: 38.92 K/s
   PID  PRIO  USER     DISK READ  DISK WRITE  SWAPIN      IO    COMMAND
   541 be/3 root          0.00 B    768.76 M  0.00 % 87.24 % [jbd2/md2-8]
  1235 be/4 root          0.00 B     28.00 K  0.00 % 71.03 % [kjournald]
13479 be/4 root         12.00 K    250.31 M  0.00 % 66.24 % dd if=largefile.tar.gz of=test11 oflag=sync bs=1G
   506 be/4 root          0.00 B      0.00 B  0.00 % 38.15 % [md2_raid1]
  1232 be/0 root          0.00 B   1568.00 K  0.00 % 12.08 % [loop0]
  1394 be/4 root          0.00 B      0.00 B  0.00 %  8.05 % [flush-7:0]
  1397 be/4 root          0.00 B      3.46 M  0.00 %  5.90 % [flush-9:2]
13467 be/4 root          0.00 B     56.00 K  0.00 %  0.00 % python /usr/bin/iotop -baoP -d 1

Total DISK READ: 0.00 B/s | Total DISK WRITE: 0.00 B/s
   PID  PRIO  USER     DISK READ  DISK WRITE  SWAPIN      IO    COMMAND
   541 be/3 root          0.00 B    768.76 M  0.00 % 87.63 % [jbd2/md2-8]
  1235 be/4 root          0.00 B     28.00 K  0.00 % 69.54 % [kjournald]
13479 be/4 root         12.00 K    250.31 M  0.00 % 67.10 % dd if=largefile.tar.gz of=test11 oflag=sync bs=1G
   506 be/4 root          0.00 B      0.00 B  0.00 % 42.88 % [md2_raid1]
  1232 be/0 root          0.00 B   1568.00 K  0.00 % 11.83 % [loop0]
  1394 be/4 root          0.00 B      0.00 B  0.00 %  7.88 % [flush-7:0]
  1397 be/4 root          0.00 B      3.46 M  0.00 %  5.78 % [flush-9:2]
13467 be/4 root          0.00 B     60.00 K  0.00 %  0.00 % python /usr/bin/iotop -baoP -d 1

Total DISK READ: 7.82 K/s | Total DISK WRITE: 0.00 B/s
   PID  PRIO  USER     DISK READ  DISK WRITE  SWAPIN      IO    COMMAND
   541 be/3 root          0.00 B    768.76 M  0.00 % 87.91 % [jbd2/md2-8]
  1235 be/4 root          0.00 B     28.00 K  0.00 % 68.12 % [kjournald]
13479 be/4 root         12.00 K    250.31 M  0.00 % 67.83 % dd if=largefile.tar.gz of=test11 oflag=sync bs=1G
   506 be/4 root          0.00 B      0.00 B  0.00 % 42.01 % [md2_raid1]
  1232 be/0 root          0.00 B   1568.00 K  0.00 % 11.59 % [loop0]
  1394 be/4 root          0.00 B      0.00 B  0.00 %  7.72 % [flush-7:0]
  1397 be/4 root          0.00 B      3.46 M  0.00 %  5.66 % [flush-9:2]
13467 be/4 root          0.00 B     68.00 K  0.00 %  0.00 % python /usr/bin/iotop -baoP -d 1

Total DISK READ: 0.00 B/s | Total DISK WRITE: 50.84 K/s
   PID  PRIO  USER     DISK READ  DISK WRITE  SWAPIN      IO    COMMAND
   541 be/3 root          0.00 B    768.76 M  0.00 % 88.16 % [jbd2/md2-8]
  1235 be/4 root          0.00 B     28.00 K  0.00 % 66.75 % [kjournald]
13479 be/4 root         12.00 K    250.31 M  0.00 % 68.51 % dd if=largefile.tar.gz of=test11 oflag=sync bs=1G
   506 be/4 root          0.00 B      0.00 B  0.00 % 41.16 % [md2_raid1]
  1232 be/0 root          0.00 B   1568.00 K  0.00 % 11.35 % [loop0]
  1394 be/4 root          0.00 B      0.00 B  0.00 %  7.56 % [flush-7:0]
  1397 be/4 root          0.00 B      3.46 M  0.00 %  5.54 % [flush-9:2]
13467 be/4 root          0.00 B     72.00 K  0.00 %  0.00 % python /usr/bin/iotop -baoP -d 1

Total DISK READ: 3.91 K/s | Total DISK WRITE: 93.83 K/s
   PID  PRIO  USER     DISK READ  DISK WRITE  SWAPIN      IO    COMMAND
   541 be/3 root          0.00 B    768.76 M  0.00 % 88.33 % [jbd2/md2-8]
13479 be/4 root         12.00 K    250.31 M  0.00 % 69.09 % dd if=largefile.tar.gz of=test11 oflag=sync bs=1G
  1235 be/4 root          0.00 B     28.00 K  0.00 % 65.44 % [kjournald]
   506 be/4 root          0.00 B      0.00 B  0.00 % 40.35 % [md2_raid1]
  1232 be/0 root          0.00 B   1568.00 K  0.00 % 11.13 % [loop0]
  1394 be/4 root          0.00 B      0.00 B  0.00 %  7.41 % [flush-7:0]
  1397 be/4 root          0.00 B      3.46 M  0.00 %  5.43 % [flush-9:2]
31346 be/4 root          0.00 B    120.00 K  0.00 %  2.95 % tailwatchd
13467 be/4 root          0.00 B     76.00 K  0.00 %  0.00 % python /usr/bin/iotop -baoP -d 1

Total DISK READ: 0.00 B/s | Total DISK WRITE: 0.00 B/s
   PID  PRIO  USER     DISK READ  DISK WRITE  SWAPIN      IO    COMMAND
   541 be/3 root          0.00 B    768.76 M  0.00 % 88.53 % [jbd2/md2-8]
13479 be/4 root         12.00 K    250.31 M  0.00 % 69.69 % dd if=largefile.tar.gz of=test11 oflag=sync bs=1G
  1235 be/4 root          0.00 B     28.00 K  0.00 % 64.18 % [kjournald]
   506 be/4 root          0.00 B      0.00 B  0.00 % 39.57 % [md2_raid1]
  1232 be/0 root          0.00 B   1568.00 K  0.00 % 10.91 % [loop0]
  1394 be/4 root          0.00 B      0.00 B  0.00 %  7.27 % [flush-7:0]
  1397 be/4 root          0.00 B      3.46 M  0.00 %  5.33 % [flush-9:2]
13467 be/4 root          0.00 B     80.00 K  0.00 %  0.00 % python /usr/bin/iotop -baoP -d 1

Total DISK READ: 0.00 B/s | Total DISK WRITE: 15.64 K/s
   PID  PRIO  USER     DISK READ  DISK WRITE  SWAPIN      IO    COMMAND
   541 be/3 root          0.00 B    768.76 M  0.00 % 88.20 % [jbd2/md2-8]
13479 be/4 root         12.00 K    250.31 M  0.00 % 69.72 % dd if=largefile.tar.gz of=test11 oflag=sync bs=1G
  1235 be/4 root          0.00 B     28.00 K  0.00 % 62.96 % [kjournald]
   506 be/4 root          0.00 B      0.00 B  0.00 % 38.82 % [md2_raid1]
  1232 be/0 root          0.00 B   1568.00 K  0.00 % 10.71 % [loop0]
  1394 be/4 root          0.00 B      0.00 B  0.00 %  7.13 % [flush-7:0]
  1397 be/4 root          0.00 B      3.46 M  0.00 %  5.23 % [flush-9:2]
13467 be/4 root          0.00 B     84.00 K  0.00 %  0.00 % python /usr/bin/iotop -baoP -d 1

Total DISK READ: 0.00 B/s | Total DISK WRITE: 0.00 B/s
   PID  PRIO  USER     DISK READ  DISK WRITE  SWAPIN      IO    COMMAND
   541 be/3 root          0.00 B    768.76 M  0.00 % 88.61 % [jbd2/md2-8]
13479 be/4 root         12.00 K    250.31 M  0.00 % 70.50 % dd if=largefile.tar.gz of=test11 oflag=sync bs=1G
  1235 be/4 root          0.00 B     28.00 K  0.00 % 61.79 % [kjournald]
   506 be/4 root          0.00 B      0.00 B  0.00 % 38.10 % [md2_raid1]
  1232 be/0 root          0.00 B   1568.00 K  0.00 % 10.51 % [loop0]
  1394 be/4 root          0.00 B      0.00 B  0.00 %  7.00 % [flush-7:0]
  1397 be/4 root          0.00 B      3.46 M  0.00 %  5.13 % [flush-9:2]
13467 be/4 root          0.00 B     92.00 K  0.00 %  0.00 % python /usr/bin/iotop -baoP -d 1

Total DISK READ: 258.12 K/s | Total DISK WRITE: 86.04 K/s
   PID  PRIO  USER     DISK READ  DISK WRITE  SWAPIN      IO    COMMAND
   541 be/3 root          0.00 B    768.76 M  0.00 % 89.19 % [jbd2/md2-8]
13479 be/4 root         12.00 K    250.31 M  0.00 % 71.45 % dd if=largefile.tar.gz of=test11 oflag=sync bs=1G
  1235 be/4 root          0.00 B     28.00 K  0.00 % 60.66 % [kjournald]
   506 be/4 root          0.00 B      0.00 B  0.00 % 37.40 % [md2_raid1]
  1232 be/0 root          0.00 B   1568.00 K  0.00 % 10.32 % [loop0]
  1394 be/4 root          0.00 B      0.00 B  0.00 %  6.87 % [flush-7:0]
  1397 be/4 root          0.00 B      3.46 M  0.00 %  5.04 % [flush-9:2]
13467 be/4 root          0.00 B     96.00 K  0.00 %  0.00 % python /usr/bin/iotop -baoP -d 1


I appologize for such a lengthy email!

Kind regards!
Andrei Banu
