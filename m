From: Yi Zhang <yizhan@redhat.com>
Subject: md127 auto created when use "-B" to build a legacy array without
 superblocks
Date: Mon, 7 Sep 2015 08:27:49 -0400 (EDT)
Message-ID: <597548646.22274436.1441628869039.JavaMail.zimbra@redhat.com>
References: <795255819.22273230.1441628546245.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <795255819.22273230.1441628546245.JavaMail.zimbra@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil

When testing 00raid1, found the md127 auto created when use "-B" to build a legacy array without superblocks, is it reasonable?
pls check below detailed info:

+ mdadm -CR /dev/md0 --level=raid1 -n3 /dev/loop0 /dev/loop1 /dev/loop2
mdadm: /dev/loop0 appears to contain an ext2fs file system
       size=58368K  mtime=Thu Jan  1 08:00:00 1970
mdadm: Note: this array has metadata at the start and
    may not be suitable as a boot device.  If you plan to
    store '/boot' on this device please ensure that
    your boot-loader understands md/v1.x metadata, or use
    --metadata=0.90
mdadm: /dev/loop1 appears to contain an ext2fs file system
       size=38912K  mtime=Thu Jan  1 08:00:00 1970
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md0 started.
+ mdadm --wait /dev/md0
+ cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4] [raid1] 
md0 : active raid1 loop2[2] loop1[1] loop0[0]
      19968 blocks super 1.2 [3/3] [UUU]
      
unused devices: <none>
+ mdadm -S /dev/md0
mdadm: stopped /dev/md0
+ mdadm -B /dev/md0 -l raid1 -n2 /dev/loop0 /dev/loop1
mdadm: array /dev/md0 built and started.
+ sleep 2
+ cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4] [raid1] 
md127 : inactive md0[0](S)
      19968 blocks super 1.2
       
md0 : active raid1 loop1[1] loop0[0]
      20000 blocks super non-persistent [2/2] [UU]
      
unused devices: <none>
[root@dhcp-12-171 bug]# uname -r
4.2.0
[root@dhcp-12-171 bug]# mdadm -D /dev/md0 
/dev/md0:
        Version : 
  Creation Time : Mon Sep  7 20:21:20 2015
     Raid Level : raid1
     Array Size : 20000 (19.53 MiB 20.48 MB)
  Used Dev Size : 20000 (19.53 MiB 20.48 MB)
   Raid Devices : 2
  Total Devices : 2

          State : clean 
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0

    Number   Major   Minor   RaidDevice State
       0       7        0        0      active sync   /dev/loop0
       1       7        1        1      active sync   /dev/loop1
[root@dhcp-12-171 bug]# mdadm -D /dev/md127 
/dev/md127:
        Version : 1.2
     Raid Level : raid0
  Total Devices : 1
    Persistence : Superblock is persistent

          State : inactive

           Name : dhcp-12-171.nay.redhat.com:0  (local to host dhcp-12-171.nay.redhat.com)
           UUID : 40ace956:a9dd0793:f4984d2b:8431b92b
         Events : 17

    Number   Major   Minor   RaidDevice

       -       9        0        -        /dev/md0 

Best Regards,
  Yi Zhang


