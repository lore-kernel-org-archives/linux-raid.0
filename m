Return-Path: <SRS0=H5I/=DN=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46E2CC41604
	for <linux-raid@archiver.kernel.org>; Tue,  6 Oct 2020 16:30:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A1D31206D4
	for <linux-raid@archiver.kernel.org>; Tue,  6 Oct 2020 16:30:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=zq3q.org header.i=@zq3q.org header.b="b94GsZsS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726073AbgJFQaz (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 6 Oct 2020 12:30:55 -0400
Received: from xklwu.xen.prgmr.com ([71.19.154.70]:53743 "EHLO
        xklwu.xen.prgmr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725769AbgJFQaz (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 6 Oct 2020 12:30:55 -0400
X-Greylist: delayed 1417 seconds by postgrey-1.27 at vger.kernel.org; Tue, 06 Oct 2020 12:30:54 EDT
Received: from epjdn.zq3q.org (epjdn.zq3q.org [71.19.149.160])
        by xklwu.xen.prgmr.com (8.14.5/8.14.5) with ESMTP id 096G7G2L015744
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=NO)
        for <linux-raid@vger.kernel.org>; Tue, 6 Oct 2020 11:07:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=zq3q.org;
        s=myselector; t=1602000436;
        bh=zUU1WG5Blz+GXYPi1MArkljSVKTy/f7f4J6PN+jJmC8=;
        h=From:To:Subject:Date;
        b=b94GsZsSUlJyP7QonWe7kPvJXBSz3jymA9+qxW1OscpPuBm41xlQ33810zMLq1qWe
         q35rTt0rcp9+fAjBmw79vhwer1c/9pyxSo7Zxv7eQ/doNhBZ2AWf5lcT69okJXMrai
         0/gO1SoAKGFpkbjawg4WgiAqhf+DxpsGnnuic/Yo=
Received: from epjdn.zq3q.org (localhost [127.0.0.1])
        by epjdn.zq3q.org (8.15.2/8.15.2) with ESMTP id 096G7CgT4052287
        for <linux-raid@vger.kernel.org>; Tue, 6 Oct 2020 11:07:12 -0500
Message-Id: <202010061607.096G7CgT4052287@epjdn.zq3q.org>
From:   linux-raid@zq3q.org
To:     Linux-RAID <linux-raid@vger.kernel.org>
Subject: pls help/review: fed 32 | LVM over raid1, on SSDs & spinning disks
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <4052284.1602000432.1@epjdn.zq3q.org>
Date:   Tue, 06 Oct 2020 11:07:12 -0500
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

I setup a crash&burn fedora 32 workstation using two 500GB SSD /dev/sd{a,b}; and two 4TB disks
/dev/sd{c,d}.

I'm effectively a raid and lvm newbie, since I only do this type of thing once every 5 years or so.

Through the blivot GUI, using trial and error I got a bootable system installed with
raid1 (and lvm) as hinted:

* GPT disk label wrote to both SSD disks /dev/sd{a,b}.

* on /dev/sd{a,b}1 created 2MiB "bios boot" partition. I assume only one is used? I could try clobbering /dev/sda1 ...

* on /dev/sd{a,b}2 created 1G "localhost-live:raid1_boot"  ext4 /boot filesystem under raid1.  

* on /dev/sd{a,b}3 created a 464.8G "localhost-live:raid1_os-main" using the remaining disk space, as LVM ( 464.63g VG named lv_os-main )

    * made 8 GiB swap partition over raid1 as /dev/mapper/lv_os--main-swap ( on the SSD )

    * made 370 GiB /  ext4 partition over raid1 as /dev/mapper/lv_os--main-root

* created a 3.65 TiB raid1 /dev/md125 array on /dev/sd{d,c} with the name ???? using the remaining disk space, as LVM ( 3.64t VG named lv_big )

    * /dev/mapper/lv_big-var on /var  type ext4
    * /dev/mapper/lv_big-00  on /home type ext4

I was able to install and boot fedora 32 OK.

----

Is it possible to get the 2MiB "bios boot" partition into raid1?
This seems to be the most vulnerable part of my setup.

Let me know additional commands you need to document my setup.
I do not know the depth of my ignorance -- any general advice is welcome.
I can redo all of this setup per your suggestions.  

--
thanks,
Tom

--------
[root@loki ~]# mdadm --version
mdadm - v4.1 - 2018-10-01
[root@loki ~]# uname -r
5.8.9-200.fc32.x86_64
[root@loki ~]# echo /dev/sd[a-d][0-9]
/dev/sda1 /dev/sda2 /dev/sda3 /dev/sdb1 /dev/sdb2 /dev/sdb3 /dev/sdc1 /dev/sdd1
[root@loki ~]# mount -t ext4
/dev/mapper/lv_os--main-root on / type ext4 (rw,relatime,seclabel)
/dev/md126 on /boot type ext4 (rw,relatime,seclabel)
/dev/mapper/lv_big-var on /var type ext4 (rw,relatime,seclabel)
/dev/mapper/lv_big-00 on /home type ext4 (rw,relatime,seclabel)
[root@loki ~]# ls /dev/md
raid1_boot  raid1_os-main  raid_big
[root@loki ~]# fdisk -l    # shows: mbr or gpt label,  'bios boot' partition, raid devices, and lvm devices
Disk /dev/sda: 465.78 GiB, 500107862016 bytes, 976773168 sectors
Disk model: Samsung SSD 850
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: gpt
Disk identifier: 7CD40013-ACFB-433A-B6A1-B5EF63934004

Device       Start       End   Sectors   Size Type
/dev/sda1     2048      6143      4096     2M BIOS boot
/dev/sda2     6144   2103295   2097152     1G Linux RAID
/dev/sda3  2103296 976773119 974669824 464.8G Linux RAID


Disk /dev/sdb: 465.78 GiB, 500107862016 bytes, 976773168 sectors
Disk model: Samsung SSD 850
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: gpt
Disk identifier: 68F51B2D-C077-46D2-96A3-116BAF835998

Device       Start       End   Sectors   Size Type
/dev/sdb1     2048      6143      4096     2M BIOS boot
/dev/sdb2     6144   2103295   2097152     1G Linux RAID
/dev/sdb3  2103296 976773119 974669824 464.8G Linux RAID


Disk /dev/sdc: 3.65 TiB, 4000787030016 bytes, 7814037168 sectors
Disk model: ST4000VN008-2DR1
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes
Disklabel type: gpt
Disk identifier: D263D0C0-2C37-4205-B505-BC3B6DD1DFDA

Device     Start        End    Sectors  Size Type
/dev/sdc1   2048 7814035491 7814033444  3.7T Linux RAID


Disk /dev/sdd: 3.65 TiB, 4000787030016 bytes, 7814037168 sectors
Disk model: ST4000VN008-2DR1
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes
Disklabel type: gpt
Disk identifier: 84D9D98B-0C27-4090-B639-AB48A0FA9B1E

Device     Start        End    Sectors  Size Type
/dev/sdd1   2048 7814035491 7814033444  3.7T Linux RAID


Disk /dev/md127: 464.65 GiB, 498895683584 bytes, 974405632 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes


Disk /dev/md126: 1022 MiB, 1071644672 bytes, 2093056 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes


Disk /dev/mapper/lv_os--main-root: 370 GiB, 397284474880 bytes, 775946240 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes


Disk /dev/mapper/lv_os--main-swap: 8 GiB, 8589934592 bytes, 16777216 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes




Disk /dev/md125: 3.65 TiB, 4000649838592 bytes, 7813769216 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes


Disk /dev/mapper/lv_big-00: 2.31 TiB, 2528880099328 bytes, 4939218944 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes


Disk /dev/mapper/lv_big-var: 400 GiB, 429496729600 bytes, 838860800 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes
[root@loki ~]# mdadm --examine /dev/sd[a-d][0-9]  ###
mdadm: No md superblock detected on /dev/sda1.
/dev/sda2:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : a90395cd:6297a553:d29f32cd:04f3054c
           Name : localhost-live:raid1_boot
  Creation Time : Sat Sep 19 07:54:55 2020
     Raid Level : raid1
   Raid Devices : 2

 Avail Dev Size : 2093056 (1022.00 MiB 1071.64 MB)
     Array Size : 1046528 (1022.00 MiB 1071.64 MB)
    Data Offset : 4096 sectors
   Super Offset : 8 sectors
   Unused Space : before=4016 sectors, after=0 sectors
          State : clean
    Device UUID : 3f3d4518:967ad3f5:99bdd519:5c7d079b

Internal Bitmap : 8 sectors from superblock
    Update Time : Fri Sep 25 07:57:18 2020
  Bad Block Log : 512 entries available at offset 16 sectors
       Checksum : b6fe8069 - correct
         Events : 83


   Device Role : Active device 0
   Array State : AA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sda3:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : 1ce0d10e:d281ceb8:a53a4dd4:b00d77b1
           Name : localhost-live:raid1_os-main
  Creation Time : Sat Sep 19 07:54:43 2020
     Raid Level : raid1
   Raid Devices : 2

 Avail Dev Size : 974405632 (464.63 GiB 498.90 GB)
     Array Size : 487202816 (464.63 GiB 498.90 GB)
    Data Offset : 264192 sectors
   Super Offset : 8 sectors
   Unused Space : before=264112 sectors, after=0 sectors
          State : clean
    Device UUID : 8317645e:e13b28c5:215484a7:a5505b5d

Internal Bitmap : 8 sectors from superblock
    Update Time : Sat Sep 26 05:40:38 2020
  Bad Block Log : 512 entries available at offset 16 sectors
       Checksum : cfc13cbc - correct
         Events : 894


   Device Role : Active device 0
   Array State : AA ('A' == active, '.' == missing, 'R' == replacing)
mdadm: No md superblock detected on /dev/sdb1.
/dev/sdb2:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : a90395cd:6297a553:d29f32cd:04f3054c
           Name : localhost-live:raid1_boot
  Creation Time : Sat Sep 19 07:54:55 2020
     Raid Level : raid1
   Raid Devices : 2

 Avail Dev Size : 2093056 (1022.00 MiB 1071.64 MB)
     Array Size : 1046528 (1022.00 MiB 1071.64 MB)
    Data Offset : 4096 sectors
   Super Offset : 8 sectors
   Unused Space : before=4016 sectors, after=0 sectors
          State : clean
    Device UUID : c2d52945:bf91d15c:36a8dca5:ac76b9ec

Internal Bitmap : 8 sectors from superblock
    Update Time : Fri Sep 25 07:57:18 2020
  Bad Block Log : 512 entries available at offset 16 sectors
       Checksum : 289a1404 - correct
         Events : 83


   Device Role : Active device 1
   Array State : AA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdb3:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : 1ce0d10e:d281ceb8:a53a4dd4:b00d77b1
           Name : localhost-live:raid1_os-main
  Creation Time : Sat Sep 19 07:54:43 2020
     Raid Level : raid1
   Raid Devices : 2

 Avail Dev Size : 974405632 (464.63 GiB 498.90 GB)
     Array Size : 487202816 (464.63 GiB 498.90 GB)
    Data Offset : 264192 sectors
   Super Offset : 8 sectors
   Unused Space : before=264112 sectors, after=0 sectors
          State : clean
    Device UUID : dab22a3f:5528d6e6:9da9ce74:a32cf0a6

Internal Bitmap : 8 sectors from superblock
    Update Time : Sat Sep 26 05:40:38 2020
  Bad Block Log : 512 entries available at offset 16 sectors
       Checksum : e914f602 - correct
         Events : 894


   Device Role : Active device 1
   Array State : AA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdc1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : 434db08c:6fdf4494:19a21b16:6e662faf
           Name : localhost-live:raid_big
  Creation Time : Sat Sep 19 07:54:00 2020
     Raid Level : raid1
   Raid Devices : 2

 Avail Dev Size : 7813769252 (3725.90 GiB 4000.65 GB)
     Array Size : 3906884608 (3725.90 GiB 4000.65 GB)
  Used Dev Size : 7813769216 (3725.90 GiB 4000.65 GB)
    Data Offset : 264192 sectors
   Super Offset : 8 sectors
   Unused Space : before=264112 sectors, after=36 sectors
          State : clean
    Device UUID : 050a5fc5:b39e6e60:98f3ffad:71e38d71

Internal Bitmap : 8 sectors from superblock
    Update Time : Sat Sep 26 06:09:58 2020
  Bad Block Log : 512 entries available at offset 24 sectors
       Checksum : 476865a4 - correct
         Events : 43615


   Device Role : Active device 0
   Array State : AA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdd1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : 434db08c:6fdf4494:19a21b16:6e662faf
           Name : localhost-live:raid_big
  Creation Time : Sat Sep 19 07:54:00 2020
     Raid Level : raid1
   Raid Devices : 2

 Avail Dev Size : 7813769252 (3725.90 GiB 4000.65 GB)
     Array Size : 3906884608 (3725.90 GiB 4000.65 GB)
  Used Dev Size : 7813769216 (3725.90 GiB 4000.65 GB)
    Data Offset : 264192 sectors
   Super Offset : 8 sectors
   Unused Space : before=264112 sectors, after=36 sectors
          State : clean
    Device UUID : ebb43ce0:bd684ff7:c8562ac6:8774a702

Internal Bitmap : 8 sectors from superblock
    Update Time : Sat Sep 26 06:09:58 2020
  Bad Block Log : 512 entries available at offset 24 sectors
       Checksum : a26acedb - correct
         Events : 43615


   Device Role : Active device 1
   Array State : AA ('A' == active, '.' == missing, 'R' == replacing)
[root@loki ~]# pvs
  PV         VG         Fmt  Attr PSize    PFree
  /dev/md125 lv_big     lvm2 a--    <3.64t 970.69g
  /dev/md127 lv_os-main lvm2 a--  <464.63g <86.63g







