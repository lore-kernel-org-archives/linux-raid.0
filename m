From: Gionatan Danti <g.danti@assyoma.it>
Subject: Network based (iSCSI) RAID1 setup
Date: Wed, 10 May 2017 10:42:54 +0200
Message-ID: <dc2c3583-14da-435b-0177-8cee749a1cd0@assyoma.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,
I'm trying to understand if, and how, mdadm can be used with network 
attached devices (iSCSI, in this case). I have a very simple setup with 
two 1 GB drives, the first being a local disk (a logical volume, really) 
and the second a remote iSCSI disk.

First question: even if in my preliminary tests this seems to work 
reasonably well, do you feel that such solution can be used for 
production workloads? Or something with a more specific focus, as DRBD, 
remains the preferred solution?

I'm using two CentOS 7.3 x86-64 boxes, with kernel version 
3.10.0-514.16.1.el7.x86_64 and mdadm v3.4 - 28th January 2016. Here you 
can find my current RAID1 setup, where /dev/sdb is the iSCSI disk:

[root@gdanti-laptop g.danti]# cat /proc/mdstat
Personalities : [raid1]
md200 : active raid1 sdb[1] dm-3[0]
       1047552 blocks super 1.2 [2/2] [UU]
       bitmap: 0/1 pages [0KB], 65536KB chunk

unused devices: <none>
[root@gdanti-laptop g.danti]# mdadm -D /dev/md200
/dev/md200:
         Version : 1.2
   Creation Time : Wed May 10 08:53:12 2017
      Raid Level : raid1
      Array Size : 1047552 (1023.00 MiB 1072.69 MB)
   Used Dev Size : 1047552 (1023.00 MiB 1072.69 MB)
    Raid Devices : 2
   Total Devices : 2
     Persistence : Superblock is persistent

   Intent Bitmap : Internal

     Update Time : Wed May 10 10:27:35 2017
           State : clean
  Active Devices : 2
Working Devices : 2
  Failed Devices : 0
   Spare Devices : 0

            Name : gdanti-laptop.assyoma.it:200  (local to host 
gdanti-laptop.assyoma.it)
            UUID : 9d6fb056:c1d49780:149f9391:68fc267f
          Events : 62

     Number   Major   Minor   RaidDevice State
        0     253        3        0      active sync   /dev/dm-3
        1       8       16        1      active sync   /dev/sdb

So far, so good: the array seems to work well, with good read/write 
speed. Now, suppose the remote disk become unavailable:

[root@gdanti-laptop g.danti]# iscsiadm -m node --targetname 
iqn.2008-09.com.example:server.target1 --portal 172.31.255.11 --logout
Logging out of session [sid: 6, target: 
iqn.2008-09.com.example:server.target1, portal: 172.31.255.11,3260]
Logout of [sid: 6, target: iqn.2008-09.com.example:server.target1, 
portal: 172.31.255.11,3260] successful.
[root@gdanti-laptop g.danti]# cat /proc/mdstat
Personalities : [raid1]
md200 : active (auto-read-only) raid1 dm-3[0]
       1047552 blocks super 1.2 [2/1] [U_]
       bitmap: 0/1 pages [0KB], 65536KB chunk

unused devices: <none>

The device is correctly kicked-off the array.
So, second question: how to enable auto re-add for the remote device 
when it become available again? For example:

[root@gdanti-laptop g.danti]# iscsiadm -m node --targetname 
iqn.2008-09.com.example:server.target1 --portal 172.31.255.11 --login
Logging in to [iface: default, target: 
iqn.2008-09.com.example:server.target1, portal: 172.31.255.11,3260] 
(multiple)
Login to [iface: default, target: 
iqn.2008-09.com.example:server.target1, portal: 172.31.255.11,3260] 
successful.
[root@gdanti-laptop g.danti]# cat /proc/mdstat
Personalities : [raid1]
md200 : active (auto-read-only) raid1 dm-3[0]
       1047552 blocks super 1.2 [2/1] [U_]
       bitmap: 0/1 pages [0KB], 65536KB chunk

unused devices: <none>

Even if /dev/sdb is now visible, it is not auto re-added to the array. 
If I run mdadm /dev/sdb --incremental --run I see the device added as a 
spare:

[root@gdanti-laptop g.danti]# cat /proc/mdstat
Personalities : [raid1]
md200 : active (auto-read-only) raid1 sdb[1](S) dm-3[0]
       1047552 blocks super 1.2 [2/1] [U_]
       bitmap: 0/1 pages [0KB], 65536KB chunk

unused devices: <none>

Third question: with --incremental adds device as a spare, rather than 
active?

I've looked at the POLICY directive in mdadm.conf, but I am unable to 
make it work by auto re-adding iSCSI devices when they become up again.

Sorry for the long post, I am really trying to learn something!
Thanks.

-- 
Danti Gionatan
Supporto Tecnico
Assyoma S.r.l. - www.assyoma.it
email: g.danti@assyoma.it - info@assyoma.it
GPG public key ID: FF5F32A8
