From: "heming.zhao@suse.com" <heming.zhao@suse.com>
Subject: mdadm: Does "mdadm --grow -n" need to do racing protecting in some
 conditions
Date: Wed, 22 Jul 2020 01:00:08 +0800
Message-ID: <b28b91be-0663-d71f-9e10-9469d411a7fd@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
Cc: NeilBrown <neilb@suse.com>, Guoqing Jiang <guoqing.jiang@cloud.ionos.com>, jes@trained-monkey.org
List-Id: linux-raid.ids

Hello list, Neil & Guoqing,

One of SUSE customer met fs crash when doing cluster-md reshape action.

the key steps is user does twice "mdadm --grow -n X /dev/md0" in a very sho=
t time.
the rootcause is the second --grow cmd stop/destory first --grow reshape ac=
tion.
in kernel side, second --grow will trigger action_store which set_bit MD_RE=
COVERY_INTR & md_reap_sync_thread(). the result is to interrupt undergoing =
reshape action.

These is a workaround to avoid this issue:
- To execute "mdadm --wait /dev/md0" before second --grow command.
  like: mdadm -a /dev/md0 /dev/sdc && mdadm -G -n 3 /dev/md0 && mdadm /dev/=
md0 --fail /dev/sda && mdadm /dev/md0 --remove /dev/sda && mdadm --wait /de=
v/md0 && mdadm -G -n 2 /dev/md0=20

But in most of time, end user very likely forget (or never in mind) to exec=
ute wait action. So I plan to file a patch for mdadm, plan to modify Grow_r=
eshape(), add racing condition check before send reshape cmd to kernel. =20
I want to know, if I create a patch to fix this issue, it makes sense or no=
t?

I summary the reproducible steps:
(all below steps executing in single node)
```
node1 # for i in {a,b,c};do dd if=3D/dev/zero of=3D/dev/sd$i; done
node1 # mdadm -C /dev/md0 -b clustered -e 1.2 -n 2 -l mirror /dev/sda /dev/=
sdb --bitmap-chunk=3D1M
node1 # mkfs.xfs /dev/md0 && mount /dev/md0 /root/mnt
node1 # cp mdadm.git.tar /root/mnt/a1 && cp /root/mnt/a1 /root/mnt/a2 && sy=
nc && echo 3 > /proc/sys/vm/drop_caches
node1 # lsblk
NAME   MAJ:MIN RM SIZE RO TYPE  MOUNTPOINT
sda      8:0    0  64M  0 disk
=E2=94=94=E2=94=80md0    9:0    0  63M  0 raid1 /root/mnt
sdb      8:16   0  64M  0 disk
=E2=94=94=E2=94=80md0    9:0    0  63M  0 raid1 /root/mnt
sdc      8:32   0  64M  0 disk
/****** wait some time for resyncing between sda & sdb ******/
node1 # mdadm -X /dev/sdb
        Filename : /dev/sdb
           Magic : 6d746962
         Version : 5
            UUID : b5de5efb:3b95a168:9302bf2f:edcecd85
       Chunksize : 1 MB
          Daemon : 5s flush period
      Write Mode : Normal
       Sync Size : 64512 (63.00 MiB 66.06 MB)
   Cluster nodes : 4
    Cluster name : hacluster
       Node Slot : 0
          Events : 20
  Events Cleared : 20
           State : OK
          Bitmap : 63 bits (chunks), 0 dirty (0.0%)
       Node Slot : 1
          Events : 0
  Events Cleared : 0
           State : OK
          Bitmap : 63 bits (chunks), 0 dirty (0.0%)
       Node Slot : 2
          Events : 0
  Events Cleared : 0
           State : OK
          Bitmap : 63 bits (chunks), 0 dirty (0.0%)
       Node Slot : 3
          Events : 0
  Events Cleared : 0
           State : OK
          Bitmap : 63 bits (chunks), 0 dirty (0.0%)
node1 # echo 100 > /proc/sys/dev/raid/speed_limit_min
node1 # echo 200 > /proc/sys/dev/raid/speed_limit_max
node1 # mdadm -a /dev/md0 /dev/sdc && mdadm -G -n 3 /dev/md0 && mdadm /dev/=
md0 --fail /dev/sda && mdadm /dev/md0 --remove /dev/sda && mdadm -G -n 2 /d=
ev/md0
node1 # echo 9000 > /proc/sys/dev/raid/speed_limit_max
node1 # cat /proc/mdstat
Personalities : [raid1]
md0 : active raid1 sdc[2] sdb[1]
      64512 blocks super 1.2 [2/2] [UU]
      bitmap: 1/1 pages [4KB], 1024KB chunk

unused devices: <none>
node1 # mdadm -X /dev/sdc
        Filename : /dev/sdc
           Magic : 6d746962
         Version : 5
            UUID : b5de5efb:3b95a168:9302bf2f:edcecd85
       Chunksize : 1 MB
          Daemon : 5s flush period
      Write Mode : Normal
       Sync Size : 64512 (63.00 MiB 66.06 MB)
   Cluster nodes : 4
    Cluster name : hacluster
       Node Slot : 0
          Events : 34
  Events Cleared : 20
           State : OK
          Bitmap : 63 bits (chunks), 0 dirty (0.0%)
mdadm: invalid bitmap magic 0x0, the bitmap file appears to be corrupted
       Node Slot : 1
          Events : 0
  Events Cleared : 0
           State : OK
          Bitmap : 0 bits (chunks), 0 dirty (0.0%)
```


Thanks
heming
