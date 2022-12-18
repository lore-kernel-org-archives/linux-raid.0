Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 144D8C4332F
	for <linux-raid@archiver.kernel.org>; Sun, 18 Dec 2022 18:31:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230511AbiLRSbt (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 18 Dec 2022 13:31:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230522AbiLRSa5 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 18 Dec 2022 13:30:57 -0500
X-Greylist: delayed 596 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 18 Dec 2022 10:28:25 PST
Received: from mail.aperture-lab.de (mail.aperture-lab.de [IPv6:2a01:4f8:c2c:665b::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2266FE9
        for <linux-raid@vger.kernel.org>; Sun, 18 Dec 2022 10:28:24 -0800 (PST)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 1C2A13F980
        for <linux-raid@vger.kernel.org>; Sun, 18 Dec 2022 19:18:25 +0100 (CET)
Date:   Sun, 18 Dec 2022 19:18:23 +0100
From:   Linus =?utf-8?Q?L=C3=BCssing?= <linus.luessing@c0d3.blue>
To:     linux-raid@vger.kernel.org
Subject: RAID6 recovery, event count mismatch
Message-ID: <Y59Zby6E3qvf7QVE@sellars>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Last-TLS-Session-Version: TLSv1.3
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi,

I recently had a disk failure in my Linux RAID6 array with 6
devices. The badblocks tool confirmed some broken sectors. I tried
to remove the faulty drive but that seems to have caused more
issues (2.5" inch "low power" drives connected via USB-SATA
adapters over an externally powered USB hub to a Pi 4... which
ran fine for more than a year now, but seems to be prone to
physical disk reconnects).

I removed the faulty drive, rebooted the whole system and the
RAID is now inactive. The event count is a little old on 3 of 5
disks, off by 3 to 7 events).


Question 1)

Is it safe and still recommended to use the command that is
suggested here?

https://raid.wiki.kernel.org/index.php/RAID_Recovery#Trying_to_assemble_using_--force
-> "mdadm /dev/mdX --assemble --force <list of devices>"

Or should I do a forced --re-add of the three devices that have
the lower even counts and a "Device Role : spare"?

Question 2)

If a forced re-add/assemble works and a RAID check / rebuilt runs
through fine, is everything fine again then? Or are there additional
steps I should follow to ensure the data and filesystems are
not corrupted? (below I'm using LVM with normal and thinly
provisioned volumes with LXD for containers, and other than that
volumes are formatted with ext4)

Question 3)

Would the "new" Linux RAID write journal feature with a dedicated
SSD have prevented such an inconsistency?

Question 4)

"mdadm -D /dev/md127" says "Raid Level : raid0", which is wrong
and luckily the disks themselves each individually still know
it's a raid6 according to mdadm. Is this just a displaying bug
of mdadm and nothing to worry about?

System/OS:

$ uname -a
Linux treehouse 5.18.9-v8+ #4 SMP PREEMPT Mon Jul 11 02:47:28 CEST 2022 aarch64 GNU/Linux
$ mdadm --version
mdadm - v4.1 - 2018-10-01
$ cat /etc/debian_version
11.5
-> Debian bullseye


More detailed mdadm output below.

Regards, Linus


==========

$ cat /proc/mdstat 
Personalities : [linear] [raid0] [raid1] [raid6] [raid5] [raid4] [raid10] 
md127 : inactive dm-13[6](S) dm-12[5](S) dm-11[3](S) dm-10[2](S) dm-9[0](S)
      9762371240 blocks super 1.2
       
unused devices: <none>

$ mdadm -D /dev/md127
/dev/md127:
           Version : 1.2
        Raid Level : raid0
     Total Devices : 5
       Persistence : Superblock is persistent

             State : inactive
   Working Devices : 5

              Name : treehouse:raid  (local to host treehouse)
              UUID : cc2852b8:aca4bdf8:761739d6:0ca5c3bb
            Events : 2554495

    Number   Major   Minor   RaidDevice

       -     254       13        -        /dev/dm-13
       -     254       11        -        /dev/dm-11
       -     254       12        -        /dev/dm-12
       -     254       10        -        /dev/dm-10
       -     254        9        -        /dev/dm-9

$ mdadm -E /dev/dm-9
/dev/dm-9:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : cc2852b8:aca4bdf8:761739d6:0ca5c3bb
           Name : treehouse:raid  (local to host treehouse)
  Creation Time : Mon Jan 29 02:48:26 2018
     Raid Level : raid6
   Raid Devices : 6

 Avail Dev Size : 3904948496 (1862.02 GiB 1999.33 GB)
     Array Size : 7809878016 (7448.08 GiB 7997.32 GB)
  Used Dev Size : 3904939008 (1862.02 GiB 1999.33 GB)
    Data Offset : 252928 sectors
   Super Offset : 8 sectors
   Unused Space : before=252840 sectors, after=9488 sectors
          State : clean
    Device UUID : 5fa00c38:e4069502:d4013eeb:08801a9b

Internal Bitmap : 8 sectors from superblock
    Update Time : Sat Nov 26 09:59:17 2022
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : 1a214e3c - correct
         Events : 2554492

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : spare
   Array State : ...A.A ('A' == active, '.' == missing, 'R' == replacing)
$ mdadm -E /dev/dm-10
/dev/dm-10:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : cc2852b8:aca4bdf8:761739d6:0ca5c3bb
           Name : treehouse:raid  (local to host treehouse)
  Creation Time : Mon Jan 29 02:48:26 2018
     Raid Level : raid6
   Raid Devices : 6

 Avail Dev Size : 3904948496 (1862.02 GiB 1999.33 GB)
     Array Size : 7809878016 (7448.08 GiB 7997.32 GB)
  Used Dev Size : 3904939008 (1862.02 GiB 1999.33 GB)
    Data Offset : 252928 sectors
   Super Offset : 8 sectors
   Unused Space : before=252840 sectors, after=9488 sectors
          State : clean
    Device UUID : 7edd1414:e610975a:fbe4a253:7ff9d404

Internal Bitmap : 8 sectors from superblock
    Update Time : Sat Nov 26 09:35:16 2022
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : 204aec57 - correct
         Events : 2554488

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : spare
   Array State : ...A.A ('A' == active, '.' == missing, 'R' == replacing)
$ mdadm -E /dev/dm-11
/dev/dm-11:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : cc2852b8:aca4bdf8:761739d6:0ca5c3bb
           Name : treehouse:raid  (local to host treehouse)
  Creation Time : Mon Jan 29 02:48:26 2018
     Raid Level : raid6
   Raid Devices : 6

 Avail Dev Size : 3904948496 (1862.02 GiB 1999.33 GB)
     Array Size : 7809878016 (7448.08 GiB 7997.32 GB)
  Used Dev Size : 3904939008 (1862.02 GiB 1999.33 GB)
    Data Offset : 252928 sectors
   Super Offset : 8 sectors
   Unused Space : before=252840 sectors, after=9488 sectors
          State : clean
    Device UUID : e8620025:d7cfec3d:a580f07d:9b7b5e11

Internal Bitmap : 8 sectors from superblock
    Update Time : Sat Nov 26 09:47:17 2022
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : 4b64514b - correct
         Events : 2554490

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : spare
   Array State : ...A.A ('A' == active, '.' == missing, 'R' == replacing)
$ mdadm -E /dev/dm-12
/dev/dm-12:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : cc2852b8:aca4bdf8:761739d6:0ca5c3bb
           Name : treehouse:raid  (local to host treehouse)
  Creation Time : Mon Jan 29 02:48:26 2018
     Raid Level : raid6
   Raid Devices : 6

 Avail Dev Size : 3904948496 (1862.02 GiB 1999.33 GB)
     Array Size : 7809878016 (7448.08 GiB 7997.32 GB)
  Used Dev Size : 3904939008 (1862.02 GiB 1999.33 GB)
    Data Offset : 252928 sectors
   Super Offset : 8 sectors
   Unused Space : before=252840 sectors, after=9488 sectors
          State : clean
    Device UUID : 02cd8021:ece5f701:777c1d5e:1f19449a

Internal Bitmap : 8 sectors from superblock
    Update Time : Sun Dec  4 00:57:01 2022
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : 750b7a8f - correct
         Events : 2554495

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 3
   Array State : ...A.A ('A' == active, '.' == missing, 'R' == replacing)
$ mdadm -E /dev/dm-13
/dev/dm-13:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : cc2852b8:aca4bdf8:761739d6:0ca5c3bb
           Name : treehouse:raid  (local to host treehouse)
  Creation Time : Mon Jan 29 02:48:26 2018
     Raid Level : raid6
   Raid Devices : 6

 Avail Dev Size : 3904948496 (1862.02 GiB 1999.33 GB)
     Array Size : 7809878016 (7448.08 GiB 7997.32 GB)
  Used Dev Size : 3904939008 (1862.02 GiB 1999.33 GB)
    Data Offset : 252928 sectors
   Super Offset : 8 sectors
   Unused Space : before=252848 sectors, after=9488 sectors
          State : clean
    Device UUID : c7e94388:5d5020e9:51fe2079:9f6a989d

Internal Bitmap : 8 sectors from superblock
    Update Time : Sun Dec  4 00:57:01 2022
  Bad Block Log : 512 entries available at offset 16 sectors
       Checksum : e14ed4e9 - correct
         Events : 2554495

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 5
   Array State : ...A.A ('A' == active, '.' == missing, 'R' == replacing)
