From: Anugraha Sinha <asinha.mailinglist@gmail.com>
Subject: md raid sync and ext3 formatting on xen hvm guest causing kernel
 crash and device offline
Date: Wed, 30 Mar 2016 23:41:54 +0530
Message-ID: <56FC16EA.9050401@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, philip@turmel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Phil,

This problem is related to mirror raid resyncing when doing installation 
through anaconda of CentOS 6.6 systems as a xen hvm guest.

Base xen system - xen kernel version - 4.1.18-1.el6xen.x86_64
Guest System - CentOS 6.6 - kernel version -  2.6.32-504.16.2.el6

Drive exposed on host system, for hvm guest = /dev/sdb - 2TB
partitioned as
/dev/sdb1 - primary  - 1024MB    - 262144MB = 256GB
/dev/sdb2 - primary  - 262144MB  - 524288MB = 256GB
/dev/sdb3 - primary  - 524288MB  - 786432MB = 256GB
/dev/sda4 - extended - 786432MB  - (-1)
/dev/sda5 - logical  - 786432MB  - 1048576MB = 256GB
/dev/sda6 - logical  - 1048576MB - (-1)

The above partition layout was exposed to hvm guest as follows
-------------------
builder = "hvm"
name = "centos_md_sync"
memory = 2048
vcpus = 4
vif = ['bridge=xenbr0']
disk = 
['phy:/dev/sdb1,sda,w','phy:/dev/sdb2,sdb,w','phy:/dev/sdb3,sdc,w','phy:/dev/sdb5,sdd,w']
vnc = 1
boot="c"
---------------------

When anaconda installation started, I partitioned drives mentioned above 
as follows
Host System  ->  Guest System -> Partition layout
/dev/sdb1    -> /dev/sda      -> /dev/sda1, /dev/sda2 ..... /dev/sda12
/dev/sdb2    -> /dev/sdb      -> /dev/sdb1, /dev/sdb2 ..... /dev/sdb12
/dev/sdb3    -> /dev/sdc      -> /dev/sdc1, /dev/sdc2 ..... /dev/sdc12
/dev/sdb5    -> /dev/sdd      -> /dev/sdd1, /dev/sdd2 ..... /dev/sdd12

Now in the HVM guest OS we doing RAID 1 mirroring as follows (done 
during installation itself, from anaconda)
/dev/sd[ab]1 = /dev/md0
/dev/sd[ab]2 = /dev/md1
|.
|.
|.
/dev/sd[cd]1 = /dev/mdX
/dev/sd[cd]2 = /dev/mdY ....etc.

Now these md(s) get created properly, and as soon as the creation ends, 
resyncing starts. Now when /dev/md0 is resyncing, other partitions on 
/dev/sda & /dev/sdb go in DELAYED state, that is expected, I understand.
Similarly with /dev/sdc and /dev/sdd. However after sometime, the
/dev/sd[abcd] drives start to go offline and eventually kernel crashes.
I checked /sys/block/sda/device/state information on Guest OS while the 
installation was going on, and it says "offline"

I picked up some snapshots and they are kept here:

https://drive.google.com/folderview?id=0B3b5lkAlTOf9eGVFUTVOeWxoTms&usp=sharing

Some important points,
1. I installed a Linux CentOS 6.6, without having these SW RAID 
partitions being created from within anaconda.
2. When the Guest System came up, I created md raids from within a 
running system, and similar issue were seen. The problem was same as to 
what happened during installation, devices went offline, and then kernel 
crashed.

Everytime, a RAID1 sync starts for a large drive in Guest OS
(say > 20GB), after sometime, devices start to go offline and then 
kernel crashes. Whether during installation or else otherwise as well.

Could you please help in this.
If you want some more snapshots or error messages do let me know.

Regards
Anugraha Sinha
