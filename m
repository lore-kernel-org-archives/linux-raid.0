Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFEAAC433ED
	for <linux-raid@archiver.kernel.org>; Mon, 17 May 2021 04:16:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9099560249
	for <linux-raid@archiver.kernel.org>; Mon, 17 May 2021 04:16:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231919AbhEQESB convert rfc822-to-8bit (ORCPT
        <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 17 May 2021 00:18:01 -0400
Received: from mail-il1-f181.google.com ([209.85.166.181]:46034 "EHLO
        mail-il1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231874AbhEQESA (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 17 May 2021 00:18:00 -0400
Received: by mail-il1-f181.google.com with SMTP id e14so4872321ils.12
        for <linux-raid@vger.kernel.org>; Sun, 16 May 2021 21:16:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=Qasv4pF1LOuCIt7/cKuwxlXfDqKAY/cc9r8m5rm6sEk=;
        b=TAYpFZEzNVdQKKdLacyI6FvKkROIZFcuzdXQ7ZZeIkzIOU9SgM43+A8e8xigVq4vj6
         zWJLK8fCcw6MZI/eW6A7XkvlcjWDHhXtRAShugSDnnXJllydc2yshwm2X7+4hUtn9FE7
         WQLhK57lmzjuKUkfqU/N8PNfKIlsXsD6ZkuxEVmPer2L171GjlHvweo02IC0l+ZvQBQ4
         fXxVZaa+kat0clDMb5wBVcK4XQaQPbQQOcIh+MSksNyrgJqzOSYosoGGd/IsjBsM1cnu
         JlGCYVat4DkBd9lIcX+F/m31peaEBdLOopRgsU8FcgLjY54N2rHcaLePvryXffzl7CI6
         vp2g==
X-Gm-Message-State: AOAM530Z8XB169+AYPyv7BKv0Ir1fhVFvDqMHpWt0vLblEavzhqZ2enm
        rmcPSR45Y/FvClnRa753UXyj8imokvSFV8vqnBxNCheczRc=
X-Google-Smtp-Source: ABdhPJxU/qMtMr/wuaZ3lHxml1y/f9cQxWGs2ZERchXP19Mo5FH1XnwXcgZhyDy1TcCEwu3yWJ9XbESZqx5sBbTejCc=
X-Received: by 2002:a92:6e01:: with SMTP id j1mr25366660ilc.160.1621224993583;
 Sun, 16 May 2021 21:16:33 -0700 (PDT)
MIME-Version: 1.0
From:   Christopher Thomas <youkai@earthlink.net>
Date:   Sun, 16 May 2021 21:16:22 -0700
Message-ID: <CA+o1gzBcQF_JeiC7Nv_zEBmJU2ypwQ_+RkbcZOOt0qOK1MkQww@mail.gmail.com>
Subject: My superblocks have gone missing, can't reassemble raid5
To:     linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi all,

I've updated my system & migrated my 3 raid5 component drives from the
old to the new, but now can't reassemble the array - mdadm just
doesn't recognize that these belong to an array at all.

The scenario:
For many years, I've run a raid5 array on a virtual Linux server
(Ubuntu 12.04) in VirtualBox on a Windows 10 host, with 3 2.7TB drives
attached to the virt in "Raw Disk" mode, and assembled into an array.
I recently upgraded to a completely different physical machine, but
still running Windows 10 and VirtualBox.  I'm reasonably sure that the
last time I shut it down, the array was clean.  Or at they very least,
the drives had superblocks.  I plugged the old drives into it,
migrated the virtual machine image to the new system, and attached
them as raw disks, just as in the old system.  And they show up as
/dev/sd[b-d], as before.  However, it's not recognized automatically
as an array at boot, and manual attempts to assemble & start the array
fail with 'no superblock'

The closest I've found online as a solution is to --create the array
again using the same parameters.  But it sounds like if I don't get
the drive order exactly the same, I'll lose the data.  Other solutions
hint at playing with the partition table, but I'm equally nervous
about that.  So I thought it was a good time to stop & ask for advice.

The details:

Here's my arrangement of disks now, where sd[bcd] are the components:

==========
chris@ursula:~$ lsblk
NAME   MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sda      8:0    0 20.1G  0 disk
├─sda1   8:1    0 19.2G  0 part /
├─sda2   8:2    0    1K  0 part
└─sda5   8:5    0  976M  0 part [SWAP]
sdb      8:16   0  2.7T  0 disk
└─sdb1   8:17   0  128M  0 part
sdc      8:32   0  2.7T  0 disk
└─sdc1   8:33   0  128M  0 part
sdd      8:48   0  2.7T  0 disk
└─sdd1   8:49   0  128M  0 part
sr0     11:0    1 1024M  0 rom

chris@ursula:~$ sudo /sbin/fdisk -l
Disk /dev/sda: 20.1 GiB, 21613379584 bytes, 42213632 sectors
Disk model: VBOX HARDDISK
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x4bbbafdf

Device     Boot    Start      End  Sectors  Size Id Type
/dev/sda1  *        2048 40212479 40210432 19.2G 83 Linux
/dev/sda2       40214526 42213375  1998850  976M  5 Extended
/dev/sda5       40214528 42213375  1998848  976M 82 Linux swap / Solaris


Disk /dev/sdb: 2.7 TiB, 3000592982016 bytes, 5860533168 sectors
Disk model: VBOX HARDDISK
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: gpt
Disk identifier: 6489224B-FAF8-45E2-AB3D-C0D280F8E91E

Device     Start    End Sectors  Size Type
/dev/sdb1     34 262177  262144  128M Microsoft reserved


Disk /dev/sdc: 2.7 TiB, 3000592982016 bytes, 5860533168 sectors
Disk model: VBOX HARDDISK
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: gpt
Disk identifier: 6497BDEB-A8D0-40D7-9CD2-D06018862F2B

Device     Start    End Sectors  Size Type
/dev/sdc1     34 262177  262144  128M Microsoft reserved


Disk /dev/sdd: 2.7 TiB, 3000592982016 bytes, 5860533168 sectors
Disk model: VBOX HARDDISK
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: gpt
Disk identifier: 9DB2C3F2-F93D-4A6D-AE0E-CE28A8B8C4A2

Device     Start    End Sectors  Size Type
/dev/sdd1     34 262177  262144  128M Microsoft reserved
==========

Note: I always intended to use the whole disk, so I don't know why I
would have created a single large partition on each, and I don't
recall doing so.  But it's been a while, so I just might not be
remembering.

Here's what happens when I try to do anything with it:

===========
chris@ursula:~$ sudo /sbin/mdadm --verbose --assemble /dev/md0
/dev/sdb /dev/sdc /dev/sdd
mdadm: looking for devices for /dev/md0
mdadm: Cannot assemble mbr metadata on /dev/sdb
mdadm: /dev/sdb has no superblock - assembly aborted

chris@ursula:~$ sudo /sbin/mdadm --examine /dev/sd[bcd]*
/dev/sdb:
   MBR Magic : aa55
Partition[0] :   4294967295 sectors at            1 (type ee)
mdadm: No md superblock detected on /dev/sdb1.
/dev/sdc:
   MBR Magic : aa55
Partition[0] :   4294967295 sectors at            1 (type ee)
mdadm: No md superblock detected on /dev/sdc1.
/dev/sdd:
   MBR Magic : aa55
Partition[0] :   4294967295 sectors at            1 (type ee)
mdadm: No md superblock detected on /dev/sdd1.
======

At some point on the old system, back when the array was still
working, I did dump the results of Examine, which looked like this:

==========
/dev/sdb:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 36205acf:993973ba:05712a13:ff75c031
           Name : ursula:0  (local to host ursula)
  Creation Time : Fri Apr 26 23:15:04 2013
     Raid Level : raid5
   Raid Devices : 3

 Avail Dev Size : 5860271024 (2794.40 GiB 3000.46 GB)
     Array Size : 5860270080 (5588.79 GiB 6000.92 GB)
  Used Dev Size : 5860270080 (2794.39 GiB 3000.46 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : 8841770a:f653d990:d5db60a0:fe2e4276

    Update Time : Sun Jul  5 12:36:19 2020
       Checksum : 3a671053 - correct
         Events : 76713

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 2
   Array State : AAA ('A' == active, '.' == missing)
/dev/sdc:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 36205acf:993973ba:05712a13:ff75c031
           Name : ursula:0  (local to host ursula)
  Creation Time : Fri Apr 26 23:15:04 2013
     Raid Level : raid5
   Raid Devices : 3

 Avail Dev Size : 5860271024 (2794.40 GiB 3000.46 GB)
     Array Size : 5860270080 (5588.79 GiB 6000.92 GB)
  Used Dev Size : 5860270080 (2794.39 GiB 3000.46 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 87fd8496:95c9cd5e:5caaa28a:25f6ab04

    Update Time : Sat May 30 02:02:45 2020
       Checksum : ce4cd20 - correct
         Events : 76711

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 0
   Array State : AAA ('A' == active, '.' == missing)
/dev/sdd:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 36205acf:993973ba:05712a13:ff75c031
           Name : ursula:0  (local to host ursula)
  Creation Time : Fri Apr 26 23:15:04 2013
     Raid Level : raid5
   Raid Devices : 3

 Avail Dev Size : 5860271024 (2794.40 GiB 3000.46 GB)
     Array Size : 5860270080 (5588.79 GiB 6000.92 GB)
  Used Dev Size : 5860270080 (2794.39 GiB 3000.46 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : c796e484:b4ed6813:a97e0ce9:66a56758

    Update Time : Sun Jul  5 12:36:19 2020
       Checksum : 6235188e - correct
         Events : 76713

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 1
   Array State : AAA ('A' == active, '.' == missing)
==========

Thank you for any ideas or guidance you can offer.
-Chris
