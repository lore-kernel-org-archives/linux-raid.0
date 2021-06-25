Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E320C2B9F4
	for <linux-raid@archiver.kernel.org>; Fri, 25 Jun 2021 12:08:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5C7E561626
	for <linux-raid@archiver.kernel.org>; Fri, 25 Jun 2021 12:08:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229934AbhFYMKy (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 25 Jun 2021 08:10:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbhFYMKw (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 25 Jun 2021 08:10:52 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EB4EC061574
        for <linux-raid@vger.kernel.org>; Fri, 25 Jun 2021 05:08:30 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id h4so7420780pgp.5
        for <linux-raid@vger.kernel.org>; Fri, 25 Jun 2021 05:08:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding:content-language:thread-index;
        bh=35+LeOdyYmg0RK45n0wO4t8gfOveH7pjRwpVmVpc/8M=;
        b=Kgbf7VkojQeMNPHqGbQ5t7/IdibvZlmvNGMPh4/SlaRxlycFk6qlietsss2MgsMBl0
         j9vaPagP+YBZtbuuWf4ZDdjtylqHGiY/wp9COjO5ScXye5TEAX3bMZYjQaZJ53x7On9A
         o7ZINj3DRLkX9uYGFyxiviFfqyP5eeH6HgaVD/ikuVGKwky82GG6Ykh1VeU0PHmfEoLQ
         +DhZS/67ERu9qNQf6HNTJyceGMlk82qnQftquRUmALuN1szArCg4Ikp0nLua1+x7MjIY
         pp4vxx/mbsBLmeCCPyN0RvOQQinha9OQ2Rrkg1iUF6qxZuuvzOywHINx+EZ2T94AfUN6
         0ptA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding:content-language:thread-index;
        bh=35+LeOdyYmg0RK45n0wO4t8gfOveH7pjRwpVmVpc/8M=;
        b=S1EJMq2yQO4KBLUkqT3+apKCylbeoA3O5cBXlIYJMaYtd6AnbY3g+pb2Rqr7IWMusS
         0GX+xUPJ5Je211c03mNgaabNG6Zwx8Ke3yuNfISd3LqOtZ80GSQtys9HhBv2ZiENZ6p5
         hY7HYK/JmBDEh1zwh4/eOZIyHUVbgnkOPhni4Sm1YBrxc0wq9eBVo1/uXVZs32Z9DXrw
         XRD6FD2jB2qzS87am6PTCHbJpvejxWfjXAusP8/Sxv9rPjjlom8sE7IQGB3W90g8Fp70
         ujuAbQMpdxhEiNaIpTG0yjnFgZANIBFBIoyGwRxGhYWN92MqZ2VRwm9hu/H6A1hiCCLo
         Ga6Q==
X-Gm-Message-State: AOAM532ujF8z0allzv6XRFF+jDAYSj/v4YfQey/9thcxA0xa2hIvjjAn
        5clRThuWlrx8L9L+tRUUjrqYUJ51krcQOA==
X-Google-Smtp-Source: ABdhPJyHp76DuJv21xJg61EkGcLDu2lBOhXkOGIPvaqJ6KYjPQxYy1EtfANMhtWC0fwW+CMF/87Pww==
X-Received: by 2002:a63:e64a:: with SMTP id p10mr9292499pgj.424.1624622909502;
        Fri, 25 Jun 2021 05:08:29 -0700 (PDT)
Received: from EdgarII ([58.164.17.235])
        by smtp.gmail.com with ESMTPSA id n23sm5087518pgv.76.2021.06.25.05.08.28
        for <linux-raid@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 25 Jun 2021 05:08:29 -0700 (PDT)
From:   "Jason Flood" <3mu5555@gmail.com>
To:     <linux-raid@vger.kernel.org>
Subject: 4-disk RAID6 (non-standard layout) normalise hung, now all disks spare
Date:   Fri, 25 Jun 2021 22:08:25 +1000
Message-ID: <007601d769ba$ced0e870$6c72b950$@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="koi8-r"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Content-Language: en-au
Thread-Index: Addpuhipc7UTPpq2QtKUEUmq7gxigg==
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

I started with a 4x4TB disk RAID5 array and, over a few years changed all
the drives to 8TB (WD Red - I hadn't seen the warnings before now, but it
looks like these ones are OK). I then successfully migrated it to RAID6, but
it then had a non-standard layout, so I ran:
	sudo mdadm --grow /dev/md0 --raid-devices=4
--backup-file=/root/raid5backup --layout=normalize

After a few days it reached 99% complete, but then the "hours remaining"
counter started counting up. After a few days I had to power the system down
before I could get a backup of the non-critical data (Couldn't get hold of
enough storage quickly enough, but it wouldn't be catastrophic to lose it),
and now the four drives are in standby, with the array thinking it is RAID0.
Running:
	sudo mdadm --assemble /dev/md0 /dev/sd[bcde]
responds with:
	mdadm: /dev/md0 assembled from 4 drives - not enough to start the
array while not clean - consider --force.

It appears to be similar to https://marc.info/?t=155492912100004&r=1&w=2,
but before trying --force I was considering using overlay files as I'm not
sure of the risk of damage. The set-up process that is documented in the "
Recovering a damaged RAID" Wiki article is excellent, however the latter
part of the process isn't clear to me. If successful, are the overlay files
written to the disk like a virtual machine snapshot, or is the process
stopped, the overlays removed and the process repeated, knowing that it now
has a low risk of damage?

System details follow. Thanks for any help.

============================================================================
=====
user@host:~$ uname -a
Linux conan 5.4.0-74-generic #83-Ubuntu SMP Sat May 8 02:35:39 UTC 2021
x86_64 x86_64 x86_64 GNU/Linux

============================================================================
=====
user@host:~$ mdadm --version
mdadm - v4.1 - 2018-10-01

============================================================================
=====
user@host:~$ sudo smartctl -H -i -l scterc /dev/sda
smartctl 7.1 2019-12-30 r5022 [x86_64-linux-5.4.0-74-generic] (local build)
Copyright (C) 2002-19, Bruce Allen, Christian Franke, www.smartmontools.org

=== START OF INFORMATION SECTION ===
Model Family:     Samsung based SSDs
Device Model:     Samsung SSD 860 EVO M.2 250GB
Serial Number:    S413NX0K707647T
LU WWN Device Id: 5 002538 e40528ae8
Firmware Version: RVT21B6Q
User Capacity:    250,059,350,016 bytes [250 GB]
Sector Size:      512 bytes logical/physical
Rotation Rate:    Solid State Device
Form Factor:      M.2
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ACS-4 T13/BSR INCITS 529 revision 5
SATA Version is:  SATA 3.1, 6.0 Gb/s (current: 6.0 Gb/s)
Local Time is:    Sun Jun 20 10:44:10 2021 AEST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

SCT Error Recovery Control:
           Read: Disabled
          Write: Disabled

============================================================================
=====
user@host:~$ sudo smartctl -H -i -l scterc /dev/sdb
smartctl 7.1 2019-12-30 r5022 [x86_64-linux-5.4.0-74-generic] (local build)
Copyright (C) 2002-19, Bruce Allen, Christian Franke, www.smartmontools.org

=== START OF INFORMATION SECTION ===
Model Family:     Western Digital Red
Device Model:     WDC WD80EFAX-68KNBN0
Serial Number:    VGJM3NXK
LU WWN Device Id: 5 000cca 0bee4dfda
Firmware Version: 81.00A81
User Capacity:    8,001,563,222,016 bytes [8.00 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Rotation Rate:    5400 rpm
Form Factor:      3.5 inches
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ACS-2, ATA8-ACS T13/1699-D revision 4
SATA Version is:  SATA 3.2, 6.0 Gb/s (current: 6.0 Gb/s)
Local Time is:    Sun Jun 20 10:44:10 2021 AEST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

SCT Error Recovery Control:
           Read:     70 (7.0 seconds)
          Write:     70 (7.0 seconds)

============================================================================
=====
user@host:~$ sudo smartctl -H -i -l scterc /dev/sdc
smartctl 7.1 2019-12-30 r5022 [x86_64-linux-5.4.0-74-generic] (local build)
Copyright (C) 2002-19, Bruce Allen, Christian Franke, www.smartmontools.org

=== START OF INFORMATION SECTION ===
Device Model:     WDC WD80EFBX-68AZZN0
Serial Number:    VRG5YT4K
LU WWN Device Id: 5 000cca 0c2c2b5a4
Firmware Version: 85.00A85
User Capacity:    8,001,563,222,016 bytes [8.00 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Rotation Rate:    7200 rpm
Form Factor:      3.5 inches
Device is:        Not in smartctl database [for details use: -P showall]
ATA Version is:   ACS-2, ATA8-ACS T13/1699-D revision 4
SATA Version is:  SATA 3.2, 6.0 Gb/s (current: 6.0 Gb/s)
Local Time is:    Sun Jun 20 10:44:11 2021 AEST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

SCT Error Recovery Control:
           Read:     70 (7.0 seconds)
          Write:     70 (7.0 seconds)

============================================================================
=====
user@host:~$ sudo smartctl -H -i -l scterc /dev/sdd
smartctl 7.1 2019-12-30 r5022 [x86_64-linux-5.4.0-74-generic] (local build)
Copyright (C) 2002-19, Bruce Allen, Christian Franke, www.smartmontools.org

=== START OF INFORMATION SECTION ===
Model Family:     Western Digital Red
Device Model:     WDC WD80EFAX-68KNBN0
Serial Number:    VAGV1WLL
LU WWN Device Id: 5 000cca 099cbd8be
Firmware Version: 81.00A81
User Capacity:    8,001,563,222,016 bytes [8.00 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Rotation Rate:    5400 rpm
Form Factor:      3.5 inches
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ACS-2, ATA8-ACS T13/1699-D revision 4
SATA Version is:  SATA 3.2, 6.0 Gb/s (current: 6.0 Gb/s)
Local Time is:    Sun Jun 20 10:44:12 2021 AEST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

SCT Error Recovery Control:
           Read:     70 (7.0 seconds)
          Write:     70 (7.0 seconds)

============================================================================
=====
user@host:~$ sudo smartctl -H -i -l scterc /dev/sde
smartctl 7.1 2019-12-30 r5022 [x86_64-linux-5.4.0-74-generic] (local build)
Copyright (C) 2002-19, Bruce Allen, Christian Franke, www.smartmontools.org

=== START OF INFORMATION SECTION ===
Model Family:     Western Digital Red
Device Model:     WDC WD80EFAX-68LHPN0
Serial Number:    7SJ5W2KW
LU WWN Device Id: 5 000cca 252deda87
Firmware Version: 83.H0A83
User Capacity:    8,001,563,222,016 bytes [8.00 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Rotation Rate:    5400 rpm
Form Factor:      3.5 inches
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ACS-2, ATA8-ACS T13/1699-D revision 4
SATA Version is:  SATA 3.2, 6.0 Gb/s (current: 6.0 Gb/s)
Local Time is:    Sun Jun 20 10:44:12 2021 AEST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

SCT Error Recovery Control:
           Read:     70 (7.0 seconds)
          Write:     70 (7.0 seconds)
		  
============================================================================
=====		
user@host:~$ sudo mdadm --examine /dev/sdb
/dev/sdb:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0xd
     Array UUID : 3eee8746:8a3bf425:afb9b538:daa61b29
           Name : Universe:0
  Creation Time : Thu Jul 13 01:11:22 2017
     Raid Level : raid6
   Raid Devices : 4

 Avail Dev Size : 15627794096 (7451.91 GiB 8001.43 GB)
     Array Size : 15627793408 (14903.83 GiB 16002.86 GB)
  Used Dev Size : 15627793408 (7451.91 GiB 8001.43 GB)
    Data Offset : 259072 sectors
   Super Offset : 8 sectors
   Unused Space : before=258992 sectors, after=688 sectors
          State : active
    Device UUID : eee9201e:d9769906:b6dccda1:b1f35abe

Internal Bitmap : 8 sectors from superblock
  Reshape pos'n : 39006208 (37.20 GiB 39.94 GB)
  Delta Devices : -1 (5->4)
     New Layout : left-symmetric

    Update Time : Fri Jun 18 08:56:43 2021
  Bad Block Log : 512 entries available at offset 24 sectors - bad blocks
present.
       Checksum : de1db60e - correct
         Events : 184251

         Layout : left-symmetric-6
     Chunk Size : 512K

   Device Role : Active device 0
   Array State : AAAA. ('A' == active, '.' == missing, 'R' == replacing)

============================================================================
=====
user@host:~$ sudo mdadm --examine /dev/sdc
/dev/sdc:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0xd
     Array UUID : 3eee8746:8a3bf425:afb9b538:daa61b29
           Name : Universe:0
  Creation Time : Thu Jul 13 01:11:22 2017
     Raid Level : raid6
   Raid Devices : 4

 Avail Dev Size : 15627794096 (7451.91 GiB 8001.43 GB)
     Array Size : 15627793408 (14903.83 GiB 16002.86 GB)
  Used Dev Size : 15627793408 (7451.91 GiB 8001.43 GB)
    Data Offset : 259072 sectors
   Super Offset : 8 sectors
   Unused Space : before=258992 sectors, after=688 sectors
          State : active
    Device UUID : 7ed45d83:84db8f79:e3aadf4b:a88212d1

Internal Bitmap : 8 sectors from superblock
  Reshape pos'n : 39006208 (37.20 GiB 39.94 GB)
  Delta Devices : -1 (5->4)
     New Layout : left-symmetric

    Update Time : Fri Jun 18 08:56:43 2021
  Bad Block Log : 512 entries available at offset 24 sectors - bad blocks
present.
       Checksum : 731a6e9f - correct
         Events : 184251

         Layout : left-symmetric-6
     Chunk Size : 512K

   Device Role : Active device 1
   Array State : AAAA. ('A' == active, '.' == missing, 'R' == replacing)

============================================================================
=====
user@host:~$ sudo mdadm --examine /dev/sdd
/dev/sdd:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0xd
     Array UUID : 3eee8746:8a3bf425:afb9b538:daa61b29
           Name : Universe:0
  Creation Time : Thu Jul 13 01:11:22 2017
     Raid Level : raid6
   Raid Devices : 4

 Avail Dev Size : 15627794096 (7451.91 GiB 8001.43 GB)
     Array Size : 15627793408 (14903.83 GiB 16002.86 GB)
  Used Dev Size : 15627793408 (7451.91 GiB 8001.43 GB)
    Data Offset : 259072 sectors
   Super Offset : 8 sectors
   Unused Space : before=258992 sectors, after=688 sectors
          State : active
    Device UUID : 015b3ea0:9b3a38d2:a860f58a:34c19985

Internal Bitmap : 8 sectors from superblock
  Reshape pos'n : 39006208 (37.20 GiB 39.94 GB)
  Delta Devices : -1 (5->4)
     New Layout : left-symmetric

    Update Time : Fri Jun 18 08:56:43 2021
  Bad Block Log : 512 entries available at offset 24 sectors - bad blocks
present.
       Checksum : dc4048b8 - correct
         Events : 184251

         Layout : left-symmetric-6
     Chunk Size : 512K

   Device Role : Active device 2
   Array State : AAAA. ('A' == active, '.' == missing, 'R' == replacing)

============================================================================
=====
user@host:~$ sudo mdadm --examine /dev/sde
/dev/sde:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x5
     Array UUID : 3eee8746:8a3bf425:afb9b538:daa61b29
           Name : Universe:0
  Creation Time : Thu Jul 13 01:11:22 2017
     Raid Level : raid6
   Raid Devices : 4

 Avail Dev Size : 15627794096 (7451.91 GiB 8001.43 GB)
     Array Size : 15627793408 (14903.83 GiB 16002.86 GB)
  Used Dev Size : 15627793408 (7451.91 GiB 8001.43 GB)
    Data Offset : 259072 sectors
   Super Offset : 8 sectors
   Unused Space : before=258992 sectors, after=688 sectors
          State : active
    Device UUID : bf9e316b:5910c7ca:1fd799e3:41a349b3

Internal Bitmap : 8 sectors from superblock
  Reshape pos'n : 39006208 (37.20 GiB 39.94 GB)
  Delta Devices : -1 (5->4)
     New Layout : left-symmetric

    Update Time : Fri Jun 18 08:56:43 2021
  Bad Block Log : 512 entries available at offset 24 sectors
       Checksum : 2616ba80 - correct
         Events : 184251

         Layout : left-symmetric-6
     Chunk Size : 512K

   Device Role : Active device 3
   Array State : AAAA. ('A' == active, '.' == missing, 'R' == replacing)

============================================================================
=====
user@host:~$ sudo mdadm --detail /dev/md0
/dev/md0:
           Version : 1.2
        Raid Level : raid0
     Total Devices : 4
       Persistence : Superblock is persistent

             State : inactive
   Working Devices : 4

     Delta Devices : -1, (1->0)
         New Level : raid6
        New Layout : left-symmetric
     New Chunksize : 512K

              Name : Universe:0
              UUID : 3eee8746:8a3bf425:afb9b538:daa61b29
            Events : 184251

    Number   Major   Minor   RaidDevice

       -       8       64        -        /dev/sde
       -       8       32        -        /dev/sdc
       -       8       48        -        /dev/sdd
       -       8       16        -        /dev/sdb
	   
============================================================================
=====
user@host:~$ sudo lsblk
NAME   MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
loop0    7:0    0   9.1M  1 loop /snap/canonical-livepatch/98
loop1    7:1    0   9.1M  1 loop /snap/canonical-livepatch/99
loop2    7:2    0  99.4M  1 loop /snap/core/11187
loop3    7:3    0  99.2M  1 loop /snap/core/11167
loop4    7:4    0  55.4M  1 loop /snap/core18/2066
loop5    7:5    0  70.4M  1 loop /snap/lxd/19647
loop7    7:7    0 217.5M  1 loop /snap/nextcloud/28088
loop8    7:8    0  67.6M  1 loop /snap/lxd/20326
loop9    7:9    0 217.5M  1 loop /snap/nextcloud/27920
loop10   7:10   0  55.5M  1 loop /snap/core18/2074
sda      8:0    0 232.9G  0 disk
+-sda1   8:1    0   512M  0 part /boot/efi
L-sda2   8:2    0 232.4G  0 part /
sdb      8:16   0   7.3T  0 disk
sdc      8:32   0   7.3T  0 disk
sdd      8:48   0   7.3T  0 disk
sde      8:64   0   7.3T  0 disk

============================================================================
=====
user@host:~$ cat /proc/mdstat
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4]
[raid10]
md0 : inactive sdc[7](S) sdb[6](S) sde[4](S) sdd[5](S)
      31255588192 blocks super 1.2

============================================================================
=====
user@host:~$ sudo mdadm --stop /dev/md0
mdadm: stopped /dev/md0

user@host:~$ sudo mdadm --assemble /dev/md0 /dev/sd[bcde]
mdadm: /dev/md0 assembled from 4 drives - not enough to start the array
while not clean - consider --force.

