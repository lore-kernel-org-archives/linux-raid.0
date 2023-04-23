Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16380C6FD18
	for <linux-raid@archiver.kernel.org>; Sun, 23 Apr 2023 19:10:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229625AbjDWTKO (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 23 Apr 2023 15:10:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbjDWTKM (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 23 Apr 2023 15:10:12 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 909CF10D0
        for <linux-raid@vger.kernel.org>; Sun, 23 Apr 2023 12:10:07 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id a640c23a62f3a-94f1a6e66c9so638213866b.2
        for <linux-raid@vger.kernel.org>; Sun, 23 Apr 2023 12:10:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682277006; x=1684869006;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=rVH4bUstsWNxrqyc++zTID8T4QXKLtgPBpgpd52KAe4=;
        b=iFku98BjBbjnUTgNnIMlZWdfjkX9fGwW1zB46x8+okm2zN9RdSnmTXKo2qpvAOZaTi
         O2wWlK69TqR+BLbIZaR8g+t3zCIp7N05Sc5JWKoi3S4GyjTtrOFVYzmod+cG4E8lIaqu
         ABnDm8xHhXSoytZBgsJWe5VeUmNvZezla2AWD2E2+g+510V2BMRxsywgq2w8FMtCfhk0
         rCSa+SMphNwlQ0mueIOoEdXZOlkCDh31xIB4qbu8B/IURncWT6vScRnqKOTY4uht5L4E
         NWYWAQDjSpRYieuYNOqcJQctT97G6xSep1sBTGaecUY+MPfHCWmERPnR342lGjhU5HnC
         jzmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682277006; x=1684869006;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rVH4bUstsWNxrqyc++zTID8T4QXKLtgPBpgpd52KAe4=;
        b=g1UjUR4YOmF3p1yv96LBPmUuRQOnPNuFf0fGJHKO8N6xFkIOu43vPmYHr8fEK/JXkM
         GFbB3zEDfGT3nivPwGmxn59aHgF423y4cc2FzCTLsI97aPEq4ZwMb5d4tetPCyuAH+Os
         33bfCcAKli1pR4ufkQL0ITup3gQtYQISuMNcQM1l/AfbFZCo5H51fCrBXcYfRdeQE9Rb
         zkUFVviIper6tSoxxxdHqluYmixZKjYHQo5euNp+iKrECHOv7zA92LS16u+Y0EddJz3t
         /SJ7qI3iUW1l2zoJv/PcoI0Wl4p9+W1AySsPTmSaYXzqaRJP1Z2nz6pw9cbq+DIoGfz7
         /gyA==
X-Gm-Message-State: AAQBX9fXCaMB3OjOZGI06ZjZxXJPzBnoUB8A9nZMj5QvbTuspLjCmStV
        E91Y5v/BMkw4YxgwmNKXiHQhsJa0n8e6/PKgYNPjBo8t0d+kaA==
X-Google-Smtp-Source: AKy350bPfaYWZl01loHIJrSYwkFlaY1aXreHDGzSCGjGDHVnWUyaLyBHdES6W0wYVERpkT9ruvLHrwZroa2iRyPXVn4=
X-Received: by 2002:a17:906:4a99:b0:959:af74:4cf7 with SMTP id
 x25-20020a1709064a9900b00959af744cf7mr130426eju.70.1682277005198; Sun, 23 Apr
 2023 12:10:05 -0700 (PDT)
MIME-Version: 1.0
From:   Jove <jovetoo@gmail.com>
Date:   Sun, 23 Apr 2023 21:09:54 +0200
Message-ID: <CAFig2csUV2QiomUhj_t3dPOgV300dbQ6XtM9ygKPdXJFSH__Nw@mail.gmail.com>
Subject: Raid5 to raid6 grow interrupted, mdadm hangs on assemble command
To:     linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi,

I've added two drives to my raid5 array and tried to migrate
it to raid6 with the following command:

mdadm --grow /dev/md0 --raid-devices 4 --level 6
--backup-file=/root/mdadm_raid6_backup.md

This may have been my first mistake, as there are only 5
drives. it should have been --raid-devices 3, I think.

As soon as I started this grow, the filesystems went
unavailable. All processes trying to access files on it hung.
I searched the web which said a reboot during a rebuild
was not problematic if things shut down cleanly, so I
rebooted. The reboot hung too. The drive activity
continued so I let it run overnight. I did wake up to a
rebooted system in emergency mode as it could not
mount all the partitions on the raid array.

The OS tried to reassemble the array and succeeded.
However the udev processes that try to create the dev
entries hang.

I went back to Google and found out how i could reboot
my system without this automatic assemble.
I tried reassembling the array with:

mdadm --verbose --assemble --backup-file mdadm_raid6_backup.md0 /dev/md0

This failed with:
No backup metadata on mdadm_raid6_backup.md0
Failed to find final backup of critical section.
Failed to restore critical section for reshape, sorry.

 I tried again wtih:

mdadm --verbose --assemble --backup-file mdadm_raid6_backup.md0
--invalid-backup /dev/md0

Rhis said in addition to the lines above:

continuying without restoring backup

This seemed to have succeeded in reassembling the
array but it also hangs indefinitely.

/proc/mdstat now shows:

md0 : active (read-only) raid6 sdc1[0] sde[4](S) sdf[5] sdd1[3] sdg1[1]
      7813771264 blocks super 1.2 level 6, 512k chunk, algorithm 18 [4/3] [UUU_]
      bitmap: 1/30 pages [4KB], 65536KB chunk

Again the udev processes trying to access this device hung indefinitely

Eventually, the kernel dumps this in my journal:

Apr 23 19:17:22 atom kernel: task:systemd-udevd   state:D stack:    0
pid: 8121 ppid:   706 flags:0x00000006
Apr 23 19:17:22 atom kernel: Call Trace:
Apr 23 19:17:22 atom kernel:  <TASK>
Apr 23 19:17:22 atom kernel:  __schedule+0x20a/0x550
Apr 23 19:17:22 atom kernel:  schedule+0x5a/0xc0
Apr 23 19:17:22 atom kernel:  schedule_timeout+0x11f/0x160
Apr 23 19:17:22 atom kernel:  ? make_stripe_request+0x284/0x490 [raid456]
Apr 23 19:17:22 atom kernel:  wait_woken+0x50/0x70
Apr 23 19:17:22 atom kernel:  raid5_make_request+0x2cb/0x3e0 [raid456]
Apr 23 19:17:22 atom kernel:  ? sched_show_numa+0xf0/0xf0
Apr 23 19:17:22 atom kernel:  md_handle_request+0x132/0x1e0
Apr 23 19:17:22 atom kernel:  ? do_mpage_readpage+0x282/0x6b0
Apr 23 19:17:22 atom kernel:  __submit_bio+0x86/0x130
Apr 23 19:17:22 atom kernel:  __submit_bio_noacct+0x81/0x1f0
Apr 23 19:17:22 atom kernel:  mpage_readahead+0x15c/0x1d0
Apr 23 19:17:22 atom kernel:  ? blkdev_write_begin+0x20/0x20
Apr 23 19:17:22 atom kernel:  read_pages+0x58/0x2f0
Apr 23 19:17:22 atom kernel:  page_cache_ra_unbounded+0x137/0x180
Apr 23 19:17:22 atom kernel:  force_page_cache_ra+0xc5/0xf0
Apr 23 19:17:22 atom kernel:  filemap_get_pages+0xe4/0x350
Apr 23 19:17:22 atom kernel:  filemap_read+0xbe/0x3c0
Apr 23 19:17:22 atom kernel:  ? make_kgid+0x13/0x20
Apr 23 19:17:22 atom kernel:  ? deactivate_locked_super+0x90/0xa0
Apr 23 19:17:22 atom kernel:  blkdev_read_iter+0xaf/0x170
Apr 23 19:17:22 atom kernel:  new_sync_read+0xf9/0x180
Apr 23 19:17:22 atom kernel:  vfs_read+0x13c/0x190
Apr 23 19:17:22 atom kernel:  ksys_read+0x5f/0xe0
Apr 23 19:17:22 atom kernel:  do_syscall_64+0x59/0x90
Apr 23 19:17:22 atom kernel:  ? do_user_addr_fault+0x1dd/0x6b0
Apr 23 19:17:22 atom kernel:  ? do_syscall_64+0x69/0x90
Apr 23 19:17:22 atom kernel:  ? exc_page_fault+0x62/0x150
Apr 23 19:17:22 atom kernel:  entry_SYSCALL_64_after_hwframe+0x63/0xcd
Apr 23 19:17:22 atom kernel: RIP: 0033:0x7fb20653eaf2
Apr 23 19:17:22 atom kernel: RSP: 002b:00007ffe1e3e8d28 EFLAGS:
00000246 ORIG_RAX: 0000000000000000
Apr 23 19:17:22 atom kernel: RAX: ffffffffffffffda RBX:
0000555888b0e0b8 RCX: 00007fb20653eaf2
Apr 23 19:17:22 atom kernel: RDX: 0000000000000040 RSI:
0000555888b0e0c8 RDI: 000000000000000d
Apr 23 19:17:22 atom kernel: RBP: 0000555888ad64e0 R08:
0000000000000000 R09: 0000000000000000
Apr 23 19:17:22 atom kernel: R10: 0000000000000010 R11:
0000000000000246 R12: 00000746f2bf0000
Apr 23 19:17:22 atom kernel: R13: 0000000000000040 R14:
0000555888b0e0a0 R15: 0000555888ad6530
Apr 23 19:17:22 atom kernel:  </TASK>

Any help to recover the data on my array would be much appreciated.

Additional system and drive information below.

Thank you for your attention,

    Johan

This is the hung mdadm command.
# cat /proc/8110/stack
[<0>] mddev_suspend+0x14f/0x180
[<0>] suspend_lo_store+0x60/0xb0
[<0>] md_attr_store+0x80/0xf0
[<0>] kernfs_fop_write_iter+0x121/0x1b0
[<0>] new_sync_write+0xfc/0x190
[<0>] vfs_write+0x1ef/0x280
[<0>] ksys_write+0x5f/0xe0
[<0>] do_syscall_64+0x59/0x90
[<0>] entry_SYSCALL_64_after_hwframe+0x63/0xcd

# cat /etc/centos-release
CentOS Stream release 9

# uname -a
Linux atom 5.14.0-299.el9.x86_64 #1 SMP PREEMPT_DYNAMIC Thu Apr 13
10:08:03 UTC 2023 x86_64 x86_64 x86_64 GNU/Linux

# mdadm --version
mdadm - v4.2 - 2021-12-30 - 8

# mdadm -D /dev/md0
/dev/md0:
           Version : 1.2
     Creation Time : Sat Oct 21 01:57:20 2017
        Raid Level : raid6
        Array Size : 7813771264 (7.28 TiB 8.00 TB)
     Used Dev Size : 3906885632 (3.64 TiB 4.00 TB)
      Raid Devices : 4
     Total Devices : 5
       Persistence : Superblock is persistent

     Intent Bitmap : Internal

       Update Time : Sun Apr 23 10:32:01 2023
             State : clean, degraded
    Active Devices : 3
   Working Devices : 5
    Failed Devices : 0
     Spare Devices : 2

            Layout : left-symmetric-6
        Chunk Size : 512K

Consistency Policy : bitmap

        New Layout : left-symmetric

              Name : atom:0  (local to host atom)
              UUID : 8c56384e:ba1a3cec:aaf34c17:d0cd9318
            Events : 669453

    Number   Major   Minor   RaidDevice State
       0       8       33        0      active sync   /dev/sdc1
       1       8       97        1      active sync   /dev/sdg1
       3       8       49        2      active sync   /dev/sdd1
       5       8       80        3      spare rebuilding   /dev/sdf

       4       8       64        -      spare   /dev/sde

# mdadm --examine /dev/sdc1
/dev/sdc1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x5
     Array UUID : 8c56384e:ba1a3cec:aaf34c17:d0cd9318
           Name : atom:0  (local to host atom)
  Creation Time : Sat Oct 21 01:57:20 2017
     Raid Level : raid6
   Raid Devices : 4

 Avail Dev Size : 7813771264 sectors (3.64 TiB 4.00 TB)
     Array Size : 7813771264 KiB (7.28 TiB 8.00 TB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262056 sectors, after=0 sectors
          State : clean
    Device UUID : e6cbce38:ce3a1997:254cd445:65a67d5d

Internal Bitmap : 8 sectors from superblock
  Reshape pos'n : 3473357824 (3.23 TiB 3.56 TB)
     New Layout : left-symmetric

    Update Time : Sun Apr 23 10:32:01 2023
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : f3ffb20c - correct
         Events : 669453

         Layout : left-symmetric-6
     Chunk Size : 512K

   Device Role : Active device 0
   Array State : AAAA ('A' == active, '.' == missing, 'R' == replacing)

# mdadm --examine /dev/sdg1
/dev/sdg1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x5
     Array UUID : 8c56384e:ba1a3cec:aaf34c17:d0cd9318
           Name : atom:0  (local to host atom)
  Creation Time : Sat Oct 21 01:57:20 2017
     Raid Level : raid6
   Raid Devices : 4

 Avail Dev Size : 7813771264 sectors (3.64 TiB 4.00 TB)
     Array Size : 7813771264 KiB (7.28 TiB 8.00 TB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262056 sectors, after=0 sectors
          State : clean
    Device UUID : 9c130a77:d12da8fa:ca8a2e59:4778168e

Internal Bitmap : 8 sectors from superblock
  Reshape pos'n : 3473357824 (3.23 TiB 3.56 TB)
     New Layout : left-symmetric

    Update Time : Sun Apr 23 10:32:01 2023
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : d9bcfd4e - correct
         Events : 669453

         Layout : left-symmetric-6
     Chunk Size : 512K

   Device Role : Active device 1
   Array State : AAAA ('A' == active, '.' == missing, 'R' == replacing)

# mdadm --examine /dev/sdd1
/dev/sdd1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x5
     Array UUID : 8c56384e:ba1a3cec:aaf34c17:d0cd9318
           Name : atom:0  (local to host atom)
  Creation Time : Sat Oct 21 01:57:20 2017
     Raid Level : raid6
   Raid Devices : 4

 Avail Dev Size : 7813771264 sectors (3.64 TiB 4.00 TB)
     Array Size : 7813771264 KiB (7.28 TiB 8.00 TB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262056 sectors, after=0 sectors
          State : clean
    Device UUID : c298e079:1f616f66:3e4c5df6:cb942253

Internal Bitmap : 8 sectors from superblock
  Reshape pos'n : 3473357824 (3.23 TiB 3.56 TB)
     New Layout : left-symmetric

    Update Time : Sun Apr 23 10:32:01 2023
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : aa9593c4 - correct
         Events : 669453

         Layout : left-symmetric-6
     Chunk Size : 512K

   Device Role : Active device 2
   Array State : AAAA ('A' == active, '.' == missing, 'R' == replacing)

# mdadm --examine /dev/sdf
/dev/sdf:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x7
     Array UUID : 8c56384e:ba1a3cec:aaf34c17:d0cd9318
           Name : atom:0  (local to host atom)
  Creation Time : Sat Oct 21 01:57:20 2017
     Raid Level : raid6
   Raid Devices : 4

 Avail Dev Size : 7813775024 sectors (3.64 TiB 4.00 TB)
     Array Size : 7813771264 KiB (7.28 TiB 8.00 TB)
  Used Dev Size : 7813771264 sectors (3.64 TiB 4.00 TB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
Recovery Offset : 3473357824 sectors
   Unused Space : before=262064 sectors, after=3760 sectors
          State : clean
    Device UUID : 277110b0:d174c17a:3bac9963:405bf18e

Internal Bitmap : 8 sectors from superblock
  Reshape pos'n : 3473357824 (3.23 TiB 3.56 TB)
     New Layout : left-symmetric

    Update Time : Sun Apr 23 10:32:01 2023
  Bad Block Log : 512 entries available at offset 24 sectors
       Checksum : 6d29f0ca - correct
         Events : 669453

         Layout : left-symmetric-6
     Chunk Size : 512K

   Device Role : Active device 3
   Array State : AAAA ('A' == active, '.' == missing, 'R' == replacing)

# mdadm --examine /dev/sde
/dev/sde:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x5
     Array UUID : 8c56384e:ba1a3cec:aaf34c17:d0cd9318
           Name : atom:0  (local to host atom)
  Creation Time : Sat Oct 21 01:57:20 2017
     Raid Level : raid6
   Raid Devices : 4

 Avail Dev Size : 7813775024 sectors (3.64 TiB 4.00 TB)
     Array Size : 7813771264 KiB (7.28 TiB 8.00 TB)
  Used Dev Size : 7813771264 sectors (3.64 TiB 4.00 TB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262064 sectors, after=3760 sectors
          State : clean
    Device UUID : 000ceb71:ab7291e6:5721b832:5003c849

Internal Bitmap : 8 sectors from superblock
  Reshape pos'n : 3473357824 (3.23 TiB 3.56 TB)
     New Layout : left-symmetric

    Update Time : Sun Apr 23 10:32:01 2023
  Bad Block Log : 512 entries available at offset 24 sectors
       Checksum : 55c26aa5 - correct
         Events : 669453

         Layout : left-symmetric-6
     Chunk Size : 512K

   Device Role : spare
   Array State : AAAA ('A' == active, '.' == missing, 'R' == replacing)

# smartctl --xall /dev/sdc1
smartctl 7.2 2020-12-30 r5155 [x86_64-linux-5.14.0-299.el9.x86_64] (local build)
Copyright (C) 2002-20, Bruce Allen, Christian Franke, www.smartmontools.org

=== START OF INFORMATION SECTION ===
Model Family:     Western Digital Red
Device Model:     WDC WD40EFRX-68N32N0
Serial Number:    WD-WCC7K6DNPVFP
LU WWN Device Id: 5 0014ee 20f133383
Firmware Version: 82.00A82
User Capacity:    4,000,787,030,016 bytes [4.00 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Rotation Rate:    5400 rpm
Form Factor:      3.5 inches
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ACS-3 T13/2161-D revision 5
SATA Version is:  SATA 3.1, 6.0 Gb/s (current: 6.0 Gb/s)
Local Time is:    Sun Apr 23 20:48:22 2023 CEST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled
AAM feature is:   Unavailable
APM feature is:   Unavailable
Rd look-ahead is: Enabled
Write cache is:   Enabled
DSN feature is:   Unavailable
ATA Security is:  Disabled, frozen [SEC2]
Wt Cache Reorder: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x00)    Offline data collection activity
                    was never started.
                    Auto Offline Data Collection: Disabled.
Self-test execution status:      (   0)    The previous self-test
routine completed
                    without error or no self-test has ever
                    been run.
Total time to complete Offline
data collection:         (43740) seconds.
Offline data collection
capabilities:              (0x7b) SMART execute Offline immediate.
                    Auto Offline data collection on/off support.
                    Suspend Offline collection upon new
                    command.
                    Offline surface scan supported.
                    Self-test supported.
                    Conveyance Self-test supported.
                    Selective Self-test supported.
SMART capabilities:            (0x0003)    Saves SMART data before entering
                    power-saving mode.
                    Supports SMART auto save timer.
Error logging capability:        (0x01)    Error logging supported.
                    General Purpose Logging supported.
Short self-test routine
recommended polling time:      (   2) minutes.
Extended self-test routine
recommended polling time:      ( 464) minutes.
Conveyance self-test routine
recommended polling time:      (   5) minutes.
SCT capabilities:            (0x303d)    SCT Status supported.
                    SCT Error Recovery Control supported.
                    SCT Feature Control supported.
                    SCT Data Table supported.

SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAGS    VALUE WORST THRESH FAIL RAW_VALUE
  1 Raw_Read_Error_Rate     POSR-K   200   200   051    -    0
  3 Spin_Up_Time            POS--K   192   162   021    -    5375
  4 Start_Stop_Count        -O--CK   100   100   000    -    83
  5 Reallocated_Sector_Ct   PO--CK   200   200   140    -    0
  7 Seek_Error_Rate         -OSR-K   200   200   000    -    0
  9 Power_On_Hours          -O--CK   041   041   000    -    43289
 10 Spin_Retry_Count        -O--CK   100   253   000    -    0
 11 Calibration_Retry_Count -O--CK   100   253   000    -    0
 12 Power_Cycle_Count       -O--CK   100   100   000    -    83
192 Power-Off_Retract_Count -O--CK   200   200   000    -    65
193 Load_Cycle_Count        -O--CK   200   200   000    -    193
194 Temperature_Celsius     -O---K   115   096   000    -    35
196 Reallocated_Event_Count -O--CK   200   200   000    -    0
197 Current_Pending_Sector  -O--CK   200   200   000    -    0
198 Offline_Uncorrectable   ----CK   100   253   000    -    0
199 UDMA_CRC_Error_Count    -O--CK   200   200   000    -    34
200 Multi_Zone_Error_Rate   ---R--   200   200   000    -    0
                            ||||||_ K auto-keep
                            |||||__ C event count
                            ||||___ R error rate
                            |||____ S speed/performance
                            ||_____ O updated online
                            |______ P prefailure warning

General Purpose Log Directory Version 1
SMART           Log Directory Version 1 [multi-sector log support]
Address    Access  R/W   Size  Description
0x00       GPL,SL  R/O      1  Log Directory
0x01           SL  R/O      1  Summary SMART error log
0x02           SL  R/O      5  Comprehensive SMART error log
0x03       GPL     R/O      6  Ext. Comprehensive SMART error log
0x04       GPL,SL  R/O      8  Device Statistics log
0x06           SL  R/O      1  SMART self-test log
0x07       GPL     R/O      1  Extended self-test log
0x09           SL  R/W      1  Selective self-test log
0x10       GPL     R/O      1  NCQ Command Error log
0x11       GPL     R/O      1  SATA Phy Event Counters log
0x30       GPL,SL  R/O      9  IDENTIFY DEVICE data log
0x80-0x9f  GPL,SL  R/W     16  Host vendor specific log
0xa0-0xa7  GPL,SL  VS      16  Device vendor specific log
0xa8-0xb6  GPL,SL  VS       1  Device vendor specific log
0xb7       GPL,SL  VS      56  Device vendor specific log
0xbd       GPL,SL  VS       1  Device vendor specific log
0xc0       GPL,SL  VS       1  Device vendor specific log
0xc1       GPL     VS      93  Device vendor specific log
0xe0       GPL,SL  R/W      1  SCT Command/Status
0xe1       GPL,SL  R/W      1  SCT Data Transfer

SMART Extended Comprehensive Error Log Version: 1 (6 sectors)
No Errors Logged

SMART Extended Self-test Log Version: 1 (1 sectors)
Num  Test_Description    Status                  Remaining
LifeTime(hours)  LBA_of_first_error
# 1  Short offline       Completed without error       00%     43107         -
# 2  Short offline       Completed without error       00%     42939         -
# 3  Short offline       Completed without error       00%     42771         -
# 4  Extended offline    Completed without error       00%     42760         -
# 5  Short offline       Completed without error       00%     42437         -
# 6  Short offline       Completed without error       00%     42269         -
# 7  Short offline       Completed without error       00%     42101         -
# 8  Extended offline    Completed without error       00%     42017         -
# 9  Short offline       Completed without error       00%     41933         -
#10  Short offline       Completed without error       00%     41765         -
#11  Short offline       Completed without error       00%     41598         -
#12  Short offline       Completed without error       00%     41430         -
#13  Extended offline    Completed without error       00%     41346         -
#14  Short offline       Completed without error       00%     41262         -
#15  Short offline       Completed without error       00%     41094         -
#16  Short offline       Completed without error       00%     40926         -
#17  Short offline       Completed without error       00%     40759         -
#18  Extended offline    Completed without error       00%     40602         -

SMART Selective self-test log data structure revision number 1
 SPAN  MIN_LBA  MAX_LBA  CURRENT_TEST_STATUS
    1        0        0  Not_testing
    2        0        0  Not_testing
    3        0        0  Not_testing
    4        0        0  Not_testing
    5        0        0  Not_testing
Selective self-test flags (0x0):
  After scanning selected spans, do NOT read-scan remainder of disk.
If Selective self-test is pending on power-up, resume after 0 minute delay.

SCT Status Version:                  3
SCT Version (vendor specific):       258 (0x0102)
Device State:                        Active (0)
Current Temperature:                    35 Celsius
Power Cycle Min/Max Temperature:     35/38 Celsius
Lifetime    Min/Max Temperature:     20/54 Celsius
Under/Over Temperature Limit Count:   0/0
Vendor specific:
01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

SCT Temperature History Version:     2
Temperature Sampling Period:         1 minute
Temperature Logging Interval:        1 minute
Min/Max recommended Temperature:      0/65 Celsius
Min/Max Temperature Limit:           -41/85 Celsius
Temperature History Size (Index):    478 (233)

Index    Estimated Time   Temperature Celsius
 234    2023-04-23 12:51    36  *****************
 ...    ..( 20 skipped).    ..  *****************
 255    2023-04-23 13:12    36  *****************
 256    2023-04-23 13:13    35  ****************
 ...    ..( 20 skipped).    ..  ****************
 277    2023-04-23 13:34    35  ****************
 278    2023-04-23 13:35    36  *****************
 ...    ..( 22 skipped).    ..  *****************
 301    2023-04-23 13:58    36  *****************
 302    2023-04-23 13:59    37  ******************
 ...    ..( 10 skipped).    ..  ******************
 313    2023-04-23 14:10    37  ******************
 314    2023-04-23 14:11    36  *****************
 315    2023-04-23 14:12    37  ******************
 ...    ..( 44 skipped).    ..  ******************
 360    2023-04-23 14:57    37  ******************
 361    2023-04-23 14:58    38  *******************
 ...    ..( 11 skipped).    ..  *******************
 373    2023-04-23 15:10    38  *******************
 374    2023-04-23 15:11    37  ******************
 ...    ..( 54 skipped).    ..  ******************
 429    2023-04-23 16:06    37  ******************
 430    2023-04-23 16:07    36  *****************
 ...    ..( 38 skipped).    ..  *****************
 469    2023-04-23 16:46    36  *****************
 470    2023-04-23 16:47    35  ****************
 ...    ..( 50 skipped).    ..  ****************
  43    2023-04-23 17:38    35  ****************
  44    2023-04-23 17:39    38  *******************
 ...    ..( 71 skipped).    ..  *******************
 116    2023-04-23 18:51    38  *******************
 117    2023-04-23 18:52    39  ********************
 ...    ..( 48 skipped).    ..  ********************
 166    2023-04-23 19:41    39  ********************
 167    2023-04-23 19:42    38  *******************
 ...    ..(  4 skipped).    ..  *******************
 172    2023-04-23 19:47    38  *******************
 173    2023-04-23 19:48    37  ******************
 ...    ..(  5 skipped).    ..  ******************
 179    2023-04-23 19:54    37  ******************
 180    2023-04-23 19:55    36  *****************
 ...    ..(  5 skipped).    ..  *****************
 186    2023-04-23 20:01    36  *****************
 187    2023-04-23 20:02     ?  -
 188    2023-04-23 20:03    33  **************
 ...    ..(  4 skipped).    ..  **************
 193    2023-04-23 20:08    33  **************
 194    2023-04-23 20:09     ?  -
 195    2023-04-23 20:10    34  ***************
 ...    ..(  8 skipped).    ..  ***************
 204    2023-04-23 20:19    34  ***************
 205    2023-04-23 20:20    35  ****************
 ...    ..( 15 skipped).    ..  ****************
 221    2023-04-23 20:36    35  ****************
 222    2023-04-23 20:37     ?  -
 223    2023-04-23 20:38    35  ****************
 224    2023-04-23 20:39     ?  -
 225    2023-04-23 20:40    35  ****************
 226    2023-04-23 20:41    35  ****************
 227    2023-04-23 20:42     ?  -
 228    2023-04-23 20:43    36  *****************
 ...    ..(  4 skipped).    ..  *****************
 233    2023-04-23 20:48    36  *****************

SCT Error Recovery Control:
           Read:     70 (7.0 seconds)
          Write:     70 (7.0 seconds)

Device Statistics (GP Log 0x04)
Page  Offset Size        Value Flags Description
0x01  =====  =               =  ===  == General Statistics (rev 1) ==
0x01  0x008  4              83  ---  Lifetime Power-On Resets
0x01  0x010  4           43289  ---  Power-on Hours
0x01  0x018  6     15614407059  ---  Logical Sectors Written
0x01  0x020  6       599311580  ---  Number of Write Commands
0x01  0x028  6    908162628478  ---  Logical Sectors Read
0x01  0x030  6      2826279430  ---  Number of Read Commands
0x01  0x038  6      1221577344  ---  Date and Time TimeStamp
0x03  =====  =               =  ===  == Rotating Media Statistics (rev 1) ==
0x03  0x008  4           47885  ---  Spindle Motor Power-on Hours
0x03  0x010  4           47296  ---  Head Flying Hours
0x03  0x018  4             259  ---  Head Load Events
0x03  0x020  4               0  ---  Number of Reallocated Logical Sectors
0x03  0x028  4               0  ---  Read Recovery Attempts
0x03  0x030  4               0  ---  Number of Mechanical Start Failures
0x03  0x038  4               0  ---  Number of Realloc. Candidate
Logical Sectors
0x03  0x040  4              65  ---  Number of High Priority Unload Events
0x04  =====  =               =  ===  == General Errors Statistics (rev 1) ==
0x04  0x008  4               0  ---  Number of Reported Uncorrectable Errors
0x04  0x010  4               1  ---  Resets Between Cmd Acceptance and
Completion
0x05  =====  =               =  ===  == Temperature Statistics (rev 1) ==
0x05  0x008  1              36  ---  Current Temperature
0x05  0x010  1              37  ---  Average Short Term Temperature
0x05  0x018  1              34  ---  Average Long Term Temperature
0x05  0x020  1              54  ---  Highest Temperature
0x05  0x028  1              23  ---  Lowest Temperature
0x05  0x030  1              52  ---  Highest Average Short Term Temperature
0x05  0x038  1              27  ---  Lowest Average Short Term Temperature
0x05  0x040  1              44  ---  Highest Average Long Term Temperature
0x05  0x048  1              31  ---  Lowest Average Long Term Temperature
0x05  0x050  4               0  ---  Time in Over-Temperature
0x05  0x058  1              65  ---  Specified Maximum Operating Temperature
0x05  0x060  4               0  ---  Time in Under-Temperature
0x05  0x068  1               0  ---  Specified Minimum Operating Temperature
0x06  =====  =               =  ===  == Transport Statistics (rev 1) ==
0x06  0x008  4             809  ---  Number of Hardware Resets
0x06  0x010  4             374  ---  Number of ASR Events
0x06  0x018  4               0  ---  Number of Interface CRC Errors
                                |||_ C monitored condition met
                                ||__ D supports DSN
                                |___ N normalized value

Pending Defects log (GP Log 0x0c) not supported

SATA Phy Event Counters (GP Log 0x11)
ID      Size     Value  Description
0x0001  2            0  Command failed due to ICRC error
0x0002  2            0  R_ERR response for data FIS
0x0003  2            0  R_ERR response for device-to-host data FIS
0x0004  2            0  R_ERR response for host-to-device data FIS
0x0005  2            0  R_ERR response for non-data FIS
0x0006  2            0  R_ERR response for device-to-host non-data FIS
0x0007  2            0  R_ERR response for host-to-device non-data FIS
0x0008  2            0  Device-to-host non-data FIS retries
0x0009  2           88  Transition from drive PhyRdy to drive PhyNRdy
0x000a  2           82  Device-to-host register FISes sent due to a COMRESET
0x000b  2            0  CRC errors within host-to-device FIS
0x000d  2            0  Non-CRC errors within host-to-device FIS
0x000f  2            0  R_ERR response for host-to-device data FIS, CRC
0x0012  2            0  R_ERR response for host-to-device non-data FIS, CRC
0x8000  4        18432  Vendor specific

# smartctl --xall /dev/sdg
smartctl 7.2 2020-12-30 r5155 [x86_64-linux-5.14.0-299.el9.x86_64] (local build)
Copyright (C) 2002-20, Bruce Allen, Christian Franke, www.smartmontools.org

=== START OF INFORMATION SECTION ===
Model Family:     Western Digital Red
Device Model:     WDC WD40EFRX-68N32N0
Serial Number:    WD-WCC7K3EXJ3S7
LU WWN Device Id: 5 0014ee 264687983
Firmware Version: 82.00A82
User Capacity:    4,000,787,030,016 bytes [4.00 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Rotation Rate:    5400 rpm
Form Factor:      3.5 inches
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ACS-3 T13/2161-D revision 5
SATA Version is:  SATA 3.1, 6.0 Gb/s (current: 3.0 Gb/s)
Local Time is:    Sun Apr 23 20:48:54 2023 CEST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled
AAM feature is:   Unavailable
APM feature is:   Unavailable
Rd look-ahead is: Enabled
Write cache is:   Enabled
DSN feature is:   Unavailable
ATA Security is:  Disabled, frozen [SEC2]
Wt Cache Reorder: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x00)    Offline data collection activity
                    was never started.
                    Auto Offline Data Collection: Disabled.
Self-test execution status:      (   0)    The previous self-test
routine completed
                    without error or no self-test has ever
                    been run.
Total time to complete Offline
data collection:         (43440) seconds.
Offline data collection
capabilities:              (0x7b) SMART execute Offline immediate.
                    Auto Offline data collection on/off support.
                    Suspend Offline collection upon new
                    command.
                    Offline surface scan supported.
                    Self-test supported.
                    Conveyance Self-test supported.
                    Selective Self-test supported.
SMART capabilities:            (0x0003)    Saves SMART data before entering
                    power-saving mode.
                    Supports SMART auto save timer.
Error logging capability:        (0x01)    Error logging supported.
                    General Purpose Logging supported.
Short self-test routine
recommended polling time:      (   2) minutes.
Extended self-test routine
recommended polling time:      ( 462) minutes.
Conveyance self-test routine
recommended polling time:      (   5) minutes.
SCT capabilities:            (0x303d)    SCT Status supported.
                    SCT Error Recovery Control supported.
                    SCT Feature Control supported.
                    SCT Data Table supported.

SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAGS    VALUE WORST THRESH FAIL RAW_VALUE
  1 Raw_Read_Error_Rate     POSR-K   200   200   051    -    0
  3 Spin_Up_Time            POS--K   185   156   021    -    5716
  4 Start_Stop_Count        -O--CK   100   100   000    -    83
  5 Reallocated_Sector_Ct   PO--CK   200   200   140    -    0
  7 Seek_Error_Rate         -OSR-K   100   253   000    -    0
  9 Power_On_Hours          -O--CK   043   043   000    -    42100
 10 Spin_Retry_Count        -O--CK   100   253   000    -    0
 11 Calibration_Retry_Count -O--CK   100   253   000    -    0
 12 Power_Cycle_Count       -O--CK   100   100   000    -    83
192 Power-Off_Retract_Count -O--CK   200   200   000    -    65
193 Load_Cycle_Count        -O--CK   200   200   000    -    199
194 Temperature_Celsius     -O---K   117   102   000    -    33
196 Reallocated_Event_Count -O--CK   200   200   000    -    0
197 Current_Pending_Sector  -O--CK   200   200   000    -    0
198 Offline_Uncorrectable   ----CK   100   253   000    -    0
199 UDMA_CRC_Error_Count    -O--CK   200   200   000    -    0
200 Multi_Zone_Error_Rate   ---R--   200   200   000    -    0
                            ||||||_ K auto-keep
                            |||||__ C event count
                            ||||___ R error rate
                            |||____ S speed/performance
                            ||_____ O updated online
                            |______ P prefailure warning

General Purpose Log Directory Version 1
SMART           Log Directory Version 1 [multi-sector log support]
Address    Access  R/W   Size  Description
0x00       GPL,SL  R/O      1  Log Directory
0x01           SL  R/O      1  Summary SMART error log
0x02           SL  R/O      5  Comprehensive SMART error log
0x03       GPL     R/O      6  Ext. Comprehensive SMART error log
0x04       GPL,SL  R/O      8  Device Statistics log
0x06           SL  R/O      1  SMART self-test log
0x07       GPL     R/O      1  Extended self-test log
0x09           SL  R/W      1  Selective self-test log
0x10       GPL     R/O      1  NCQ Command Error log
0x11       GPL     R/O      1  SATA Phy Event Counters log
0x30       GPL,SL  R/O      9  IDENTIFY DEVICE data log
0x80-0x9f  GPL,SL  R/W     16  Host vendor specific log
0xa0-0xa7  GPL,SL  VS      16  Device vendor specific log
0xa8-0xb6  GPL,SL  VS       1  Device vendor specific log
0xb7       GPL,SL  VS      56  Device vendor specific log
0xbd       GPL,SL  VS       1  Device vendor specific log
0xc0       GPL,SL  VS       1  Device vendor specific log
0xc1       GPL     VS      93  Device vendor specific log
0xe0       GPL,SL  R/W      1  SCT Command/Status
0xe1       GPL,SL  R/W      1  SCT Data Transfer

SMART Extended Comprehensive Error Log Version: 1 (6 sectors)
No Errors Logged

SMART Extended Self-test Log Version: 1 (1 sectors)
Num  Test_Description    Status                  Remaining
LifeTime(hours)  LBA_of_first_error
# 1  Short offline       Completed without error       00%     41918         -
# 2  Short offline       Completed without error       00%     41750         -
# 3  Short offline       Completed without error       00%     41582         -
# 4  Extended offline    Completed without error       00%     41570         -
# 5  Short offline       Completed without error       00%     41248         -
# 6  Short offline       Completed without error       00%     41080         -
# 7  Short offline       Completed without error       00%     40912         -
# 8  Extended offline    Completed without error       00%     40828         -
# 9  Short offline       Completed without error       00%     40744         -
#10  Short offline       Completed without error       00%     40576         -
#11  Short offline       Completed without error       00%     40408         -
#12  Short offline       Completed without error       00%     40241         -
#13  Extended offline    Completed without error       00%     40157         -
#14  Short offline       Completed without error       00%     40073         -
#15  Short offline       Completed without error       00%     41098         -
#16  Short offline       Completed without error       00%     40930         -
#17  Short offline       Completed without error       00%     40762         -
#18  Extended offline    Completed without error       00%     40606         -

SMART Selective self-test log data structure revision number 1
 SPAN  MIN_LBA  MAX_LBA  CURRENT_TEST_STATUS
    1        0        0  Not_testing
    2        0        0  Not_testing
    3        0        0  Not_testing
    4        0        0  Not_testing
    5        0        0  Not_testing
Selective self-test flags (0x0):
  After scanning selected spans, do NOT read-scan remainder of disk.
If Selective self-test is pending on power-up, resume after 0 minute delay.

SCT Status Version:                  3
SCT Version (vendor specific):       258 (0x0102)
Device State:                        Active (0)
Current Temperature:                    33 Celsius
Power Cycle Min/Max Temperature:     33/36 Celsius
Lifetime    Min/Max Temperature:     19/48 Celsius
Under/Over Temperature Limit Count:   0/0
Vendor specific:
01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

SCT Temperature History Version:     2
Temperature Sampling Period:         1 minute
Temperature Logging Interval:        1 minute
Min/Max recommended Temperature:      0/65 Celsius
Min/Max Temperature Limit:           -41/85 Celsius
Temperature History Size (Index):    478 (453)

Index    Estimated Time   Temperature Celsius
 454    2023-04-23 12:51    35  ****************
 ...    ..( 11 skipped).    ..  ****************
 466    2023-04-23 13:03    35  ****************
 467    2023-04-23 13:04    34  ***************
 ...    ..( 32 skipped).    ..  ***************
  22    2023-04-23 13:37    34  ***************
  23    2023-04-23 13:38    35  ****************
 ...    ..( 60 skipped).    ..  ****************
  84    2023-04-23 14:39    35  ****************
  85    2023-04-23 14:40    36  *****************
 ...    ..( 48 skipped).    ..  *****************
 134    2023-04-23 15:29    36  *****************
 135    2023-04-23 15:30    35  ****************
 ...    ..( 44 skipped).    ..  ****************
 180    2023-04-23 16:15    35  ****************
 181    2023-04-23 16:16    34  ***************
 ...    ..( 69 skipped).    ..  ***************
 251    2023-04-23 17:26    34  ***************
 252    2023-04-23 17:27    33  **************
 ...    ..( 10 skipped).    ..  **************
 263    2023-04-23 17:38    33  **************
 264    2023-04-23 17:39    36  *****************
 ...    ..(140 skipped).    ..  *****************
 405    2023-04-23 20:00    36  *****************
 406    2023-04-23 20:01     ?  -
 407    2023-04-23 20:02    31  ************
 ...    ..(  4 skipped).    ..  ************
 412    2023-04-23 20:07    31  ************
 413    2023-04-23 20:08     ?  -
 414    2023-04-23 20:09    32  *************
 ...    ..(  3 skipped).    ..  *************
 418    2023-04-23 20:13    32  *************
 419    2023-04-23 20:14    33  **************
 ...    ..(  8 skipped).    ..  **************
 428    2023-04-23 20:23    33  **************
 429    2023-04-23 20:24    34  ***************
 ...    ..( 10 skipped).    ..  ***************
 440    2023-04-23 20:35    34  ***************
 441    2023-04-23 20:36     ?  -
 442    2023-04-23 20:37    34  ***************
 443    2023-04-23 20:38     ?  -
 444    2023-04-23 20:39    34  ***************
 445    2023-04-23 20:40    34  ***************
 446    2023-04-23 20:41     ?  -
 447    2023-04-23 20:42    35  ****************
 ...    ..(  5 skipped).    ..  ****************
 453    2023-04-23 20:48    35  ****************

SCT Error Recovery Control:
           Read:     70 (7.0 seconds)
          Write:     70 (7.0 seconds)

Device Statistics (GP Log 0x04)
Page  Offset Size        Value Flags Description
0x01  =====  =               =  ===  == General Statistics (rev 1) ==
0x01  0x008  4              83  ---  Lifetime Power-On Resets
0x01  0x010  4           42100  ---  Power-on Hours
0x01  0x018  6     15407958681  ---  Logical Sectors Written
0x01  0x020  6       595027021  ---  Number of Write Commands
0x01  0x028  6    908203824645  ---  Logical Sectors Read
0x01  0x030  6      2834811358  ---  Number of Read Commands
0x01  0x038  6      1236144640  ---  Date and Time TimeStamp
0x03  =====  =               =  ===  == Rotating Media Statistics (rev 1) ==
0x03  0x008  4           47888  ---  Spindle Motor Power-on Hours
0x03  0x010  4           47298  ---  Head Flying Hours
0x03  0x018  4             265  ---  Head Load Events
0x03  0x020  4               0  ---  Number of Reallocated Logical Sectors
0x03  0x028  4              11  ---  Read Recovery Attempts
0x03  0x030  4               0  ---  Number of Mechanical Start Failures
0x03  0x038  4               0  ---  Number of Realloc. Candidate
Logical Sectors
0x03  0x040  4              65  ---  Number of High Priority Unload Events
0x04  =====  =               =  ===  == General Errors Statistics (rev 1) ==
0x04  0x008  4               0  ---  Number of Reported Uncorrectable Errors
0x04  0x010  4               0  ---  Resets Between Cmd Acceptance and
Completion
0x05  =====  =               =  ===  == Temperature Statistics (rev 1) ==
0x05  0x008  1              34  ---  Current Temperature
0x05  0x010  1              35  ---  Average Short Term Temperature
0x05  0x018  1              30  ---  Average Long Term Temperature
0x05  0x020  1              48  ---  Highest Temperature
0x05  0x028  1              22  ---  Lowest Temperature
0x05  0x030  1              46  ---  Highest Average Short Term Temperature
0x05  0x038  1              24  ---  Lowest Average Short Term Temperature
0x05  0x040  1              39  ---  Highest Average Long Term Temperature
0x05  0x048  1              26  ---  Lowest Average Long Term Temperature
0x05  0x050  4               0  ---  Time in Over-Temperature
0x05  0x058  1              65  ---  Specified Maximum Operating Temperature
0x05  0x060  4               0  ---  Time in Under-Temperature
0x05  0x068  1               0  ---  Specified Minimum Operating Temperature
0x06  =====  =               =  ===  == Transport Statistics (rev 1) ==
0x06  0x008  4             793  ---  Number of Hardware Resets
0x06  0x010  4             332  ---  Number of ASR Events
0x06  0x018  4               0  ---  Number of Interface CRC Errors
                                |||_ C monitored condition met
                                ||__ D supports DSN
                                |___ N normalized value

Pending Defects log (GP Log 0x0c) not supported

SATA Phy Event Counters (GP Log 0x11)
ID      Size     Value  Description
0x0001  2            0  Command failed due to ICRC error
0x0002  2            0  R_ERR response for data FIS
0x0003  2            0  R_ERR response for device-to-host data FIS
0x0004  2            0  R_ERR response for host-to-device data FIS
0x0005  2            0  R_ERR response for non-data FIS
0x0006  2            0  R_ERR response for device-to-host non-data FIS
0x0007  2            0  R_ERR response for host-to-device non-data FIS
0x0008  2            0  Device-to-host non-data FIS retries
0x0009  2           88  Transition from drive PhyRdy to drive PhyNRdy
0x000a  2           82  Device-to-host register FISes sent due to a COMRESET
0x000b  2            0  CRC errors within host-to-device FIS
0x000d  2            0  Non-CRC errors within host-to-device FIS
0x000f  2            0  R_ERR response for host-to-device data FIS, CRC
0x0012  2            0  R_ERR response for host-to-device non-data FIS, CRC
0x8000  4        18464  Vendor specific

# smartctl --xall /dev/sdd
smartctl 7.2 2020-12-30 r5155 [x86_64-linux-5.14.0-299.el9.x86_64] (local build)
Copyright (C) 2002-20, Bruce Allen, Christian Franke, www.smartmontools.org

=== START OF INFORMATION SECTION ===
Model Family:     Western Digital Red
Device Model:     WDC WD40EFRX-68WT0N0
Serial Number:    WD-WCC4E0645620
LU WWN Device Id: 5 0014ee 2b438eb78
Firmware Version: 80.00A80
User Capacity:    4,000,787,030,016 bytes [4.00 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Rotation Rate:    5400 rpm
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ACS-2 (minor revision not indicated)
SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 6.0 Gb/s)
Local Time is:    Sun Apr 23 20:49:30 2023 CEST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled
AAM feature is:   Unavailable
APM feature is:   Unavailable
Rd look-ahead is: Enabled
Write cache is:   Enabled
DSN feature is:   Unavailable
ATA Security is:  Disabled, frozen [SEC2]
Wt Cache Reorder: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x00)    Offline data collection activity
                    was never started.
                    Auto Offline Data Collection: Disabled.
Self-test execution status:      (   0)    The previous self-test
routine completed
                    without error or no self-test has ever
                    been run.
Total time to complete Offline
data collection:         (55560) seconds.
Offline data collection
capabilities:              (0x7b) SMART execute Offline immediate.
                    Auto Offline data collection on/off support.
                    Suspend Offline collection upon new
                    command.
                    Offline surface scan supported.
                    Self-test supported.
                    Conveyance Self-test supported.
                    Selective Self-test supported.
SMART capabilities:            (0x0003)    Saves SMART data before entering
                    power-saving mode.
                    Supports SMART auto save timer.
Error logging capability:        (0x01)    Error logging supported.
                    General Purpose Logging supported.
Short self-test routine
recommended polling time:      (   2) minutes.
Extended self-test routine
recommended polling time:      ( 555) minutes.
Conveyance self-test routine
recommended polling time:      (   5) minutes.
SCT capabilities:            (0x703d)    SCT Status supported.
                    SCT Error Recovery Control supported.
                    SCT Feature Control supported.
                    SCT Data Table supported.

SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAGS    VALUE WORST THRESH FAIL RAW_VALUE
  1 Raw_Read_Error_Rate     POSR-K   200   200   051    -    12
  3 Spin_Up_Time            POS--K   190   177   021    -    7458
  4 Start_Stop_Count        -O--CK   097   097   000    -    3213
  5 Reallocated_Sector_Ct   PO--CK   200   200   140    -    0
  7 Seek_Error_Rate         -OSR-K   100   253   000    -    0
  9 Power_On_Hours          -O--CK   014   014   000    -    62899
 10 Spin_Retry_Count        -O--CK   100   100   000    -    0
 11 Calibration_Retry_Count -O--CK   100   100   000    -    0
 12 Power_Cycle_Count       -O--CK   100   100   000    -    111
192 Power-Off_Retract_Count -O--CK   200   200   000    -    78
193 Load_Cycle_Count        -O--CK   198   198   000    -    6721
194 Temperature_Celsius     -O---K   117   097   000    -    35
196 Reallocated_Event_Count -O--CK   200   200   000    -    0
197 Current_Pending_Sector  -O--CK   200   200   000    -    0
198 Offline_Uncorrectable   ----CK   100   253   000    -    0
199 UDMA_CRC_Error_Count    -O--CK   200   200   000    -    0
200 Multi_Zone_Error_Rate   ---R--   200   200   000    -    0
                            ||||||_ K auto-keep
                            |||||__ C event count
                            ||||___ R error rate
                            |||____ S speed/performance
                            ||_____ O updated online
                            |______ P prefailure warning

General Purpose Log Directory Version 1
SMART           Log Directory Version 1 [multi-sector log support]
Address    Access  R/W   Size  Description
0x00       GPL,SL  R/O      1  Log Directory
0x01           SL  R/O      1  Summary SMART error log
0x02           SL  R/O      5  Comprehensive SMART error log
0x03       GPL     R/O      6  Ext. Comprehensive SMART error log
0x06           SL  R/O      1  SMART self-test log
0x07       GPL     R/O      1  Extended self-test log
0x09           SL  R/W      1  Selective self-test log
0x10       GPL     R/O      1  NCQ Command Error log
0x11       GPL     R/O      1  SATA Phy Event Counters log
0x21       GPL     R/O      1  Write stream error log
0x22       GPL     R/O      1  Read stream error log
0x80-0x9f  GPL,SL  R/W     16  Host vendor specific log
0xa0-0xa7  GPL,SL  VS      16  Device vendor specific log
0xa8-0xb7  GPL,SL  VS       1  Device vendor specific log
0xbd       GPL,SL  VS       1  Device vendor specific log
0xc0       GPL,SL  VS       1  Device vendor specific log
0xc1       GPL     VS      93  Device vendor specific log
0xe0       GPL,SL  R/W      1  SCT Command/Status
0xe1       GPL,SL  R/W      1  SCT Data Transfer

SMART Extended Comprehensive Error Log Version: 1 (6 sectors)
Device Error Count: 14
    CR     = Command Register
    FEATR  = Features Register
    COUNT  = Count (was: Sector Count) Register
    LBA_48 = Upper bytes of LBA High/Mid/Low Registers ]  ATA-8
    LH     = LBA High (was: Cylinder High) Register    ]   LBA
    LM     = LBA Mid (was: Cylinder Low) Register      ] Register
    LL     = LBA Low (was: Sector Number) Register     ]
    DV     = Device (was: Device/Head) Register
    DC     = Device Control Register
    ER     = Error register
    ST     = Status register
Powered_Up_Time is measured from power on, and printed as
DDd+hh:mm:SS.sss where DD=days, hh=hours, mm=minutes,
SS=sec, and sss=millisec. It "wraps" after 49.710 days.

Error 14 [13] occurred at disk power-on lifetime: 21182 hours (882
days + 14 hours)
  When the command that caused the error occurred, the device was
active or idle.

  After command completion occurred, registers were:
  ER -- ST COUNT  LBA_48  LH LM LL DV DC
  -- -- -- == -- == == == -- -- -- -- --
  40 -- 51 00 00 00 01 b7 3e 3a b8 40 00  Error: UNC at LBA =
0x1b73e3ab8 = 7369276088

  Commands leading to the command that caused the error were:
  CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time  Command/Feature_Name
  -- == -- == -- == == == -- -- -- -- --  ---------------  --------------------
  60 00 08 00 d8 00 01 b7 3e 3a f0 40 08  8d+09:09:02.085  READ FPDMA QUEUED
  60 00 08 00 d0 00 01 b7 3e 3b 10 40 08  8d+09:09:02.085  READ FPDMA QUEUED
  60 00 08 00 c8 00 01 b7 3e 3a e8 40 08  8d+09:09:02.085  READ FPDMA QUEUED
  60 00 08 00 c0 00 01 b7 3e 3a e0 40 08  8d+09:09:02.085  READ FPDMA QUEUED
  60 00 08 00 b8 00 01 b7 3e 3a d8 40 08  8d+09:09:02.084  READ FPDMA QUEUED

Error 13 [12] occurred at disk power-on lifetime: 21182 hours (882
days + 14 hours)
  When the command that caused the error occurred, the device was
active or idle.

  After command completion occurred, registers were:
  ER -- ST COUNT  LBA_48  LH LM LL DV DC
  -- -- -- == -- == == == -- -- -- -- --
  40 -- 51 00 00 00 01 b7 3e 3a b8 40 00  Error: UNC at LBA =
0x1b73e3ab8 = 7369276088

  Commands leading to the command that caused the error were:
  CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time  Command/Feature_Name
  -- == -- == -- == == == -- -- -- -- --  ---------------  --------------------
  60 00 08 00 d8 00 01 b7 3e 3b a8 40 08  8d+09:08:58.566  READ FPDMA QUEUED
  60 00 08 00 d0 00 01 b7 3e 3b a0 40 08  8d+09:08:58.566  READ FPDMA QUEUED
  60 00 08 00 c8 00 01 b7 3e 3b 98 40 08  8d+09:08:58.566  READ FPDMA QUEUED
  60 00 08 00 c0 00 01 b7 3e 3b 90 40 08  8d+09:08:58.566  READ FPDMA QUEUED
  60 00 08 00 b8 00 01 b7 3e 3b 88 40 08  8d+09:08:58.566  READ FPDMA QUEUED

Error 12 [11] occurred at disk power-on lifetime: 21182 hours (882
days + 14 hours)
  When the command that caused the error occurred, the device was
active or idle.

  After command completion occurred, registers were:
  ER -- ST COUNT  LBA_48  LH LM LL DV DC
  -- -- -- == -- == == == -- -- -- -- --
  40 -- 51 00 00 00 01 b7 3e 3a b8 40 00  Error: UNC at LBA =
0x1b73e3ab8 = 7369276088

  Commands leading to the command that caused the error were:
  CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time  Command/Feature_Name
  -- == -- == -- == == == -- -- -- -- --  ---------------  --------------------
  60 00 08 00 d8 00 01 b7 3e 3a f0 40 08  8d+09:08:55.047  READ FPDMA QUEUED
  60 00 08 00 d0 00 01 b7 3e 3b 10 40 08  8d+09:08:55.047  READ FPDMA QUEUED
  60 00 08 00 c8 00 01 b7 3e 3a e8 40 08  8d+09:08:55.047  READ FPDMA QUEUED
  60 00 08 00 c0 00 01 b7 3e 3a e0 40 08  8d+09:08:55.047  READ FPDMA QUEUED
  60 00 08 00 b8 00 01 b7 3e 3a d8 40 08  8d+09:08:55.047  READ FPDMA QUEUED

Error 11 [10] occurred at disk power-on lifetime: 21182 hours (882
days + 14 hours)
  When the command that caused the error occurred, the device was
active or idle.

  After command completion occurred, registers were:
  ER -- ST COUNT  LBA_48  LH LM LL DV DC
  -- -- -- == -- == == == -- -- -- -- --
  40 -- 51 00 00 00 01 b7 3e 3a b8 40 00  Error: UNC at LBA =
0x1b73e3ab8 = 7369276088

  Commands leading to the command that caused the error were:
  CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time  Command/Feature_Name
  -- == -- == -- == == == -- -- -- -- --  ---------------  --------------------
  60 00 08 00 d8 00 01 b7 3e 3b a8 40 08  8d+09:08:51.528  READ FPDMA QUEUED
  60 00 08 00 d0 00 01 b7 3e 3b a0 40 08  8d+09:08:51.528  READ FPDMA QUEUED
  60 00 08 00 c8 00 01 b7 3e 3b 98 40 08  8d+09:08:51.528  READ FPDMA QUEUED
  60 00 08 00 c0 00 01 b7 3e 3b 90 40 08  8d+09:08:51.528  READ FPDMA QUEUED
  60 00 08 00 b8 00 01 b7 3e 3b 88 40 08  8d+09:08:51.528  READ FPDMA QUEUED

Error 10 [9] occurred at disk power-on lifetime: 21182 hours (882 days
+ 14 hours)
  When the command that caused the error occurred, the device was
active or idle.

  After command completion occurred, registers were:
  ER -- ST COUNT  LBA_48  LH LM LL DV DC
  -- -- -- == -- == == == -- -- -- -- --
  40 -- 51 00 00 00 01 b7 3e 3a b8 40 00  Error: UNC at LBA =
0x1b73e3ab8 = 7369276088

  Commands leading to the command that caused the error were:
  CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time  Command/Feature_Name
  -- == -- == -- == == == -- -- -- -- --  ---------------  --------------------
  60 00 08 00 d8 00 01 b7 3e 3a f0 40 08  8d+09:08:48.010  READ FPDMA QUEUED
  60 00 08 00 d0 00 01 b7 3e 3b 10 40 08  8d+09:08:48.010  READ FPDMA QUEUED
  60 00 08 00 c8 00 01 b7 3e 3a e8 40 08  8d+09:08:48.010  READ FPDMA QUEUED
  60 00 08 00 c0 00 01 b7 3e 3a e0 40 08  8d+09:08:48.010  READ FPDMA QUEUED
  60 00 08 00 b8 00 01 b7 3e 3a d8 40 08  8d+09:08:48.010  READ FPDMA QUEUED

Error 9 [8] occurred at disk power-on lifetime: 21182 hours (882 days
+ 14 hours)
  When the command that caused the error occurred, the device was
active or idle.

  After command completion occurred, registers were:
  ER -- ST COUNT  LBA_48  LH LM LL DV DC
  -- -- -- == -- == == == -- -- -- -- --
  40 -- 51 00 00 00 01 b7 3e 3a b8 40 00  Error: UNC at LBA =
0x1b73e3ab8 = 7369276088

  Commands leading to the command that caused the error were:
  CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time  Command/Feature_Name
  -- == -- == -- == == == -- -- -- -- --  ---------------  --------------------
  60 00 08 00 d8 00 01 b7 3e 3b a8 40 08  8d+09:08:44.517  READ FPDMA QUEUED
  60 00 08 00 d0 00 01 b7 3e 3b a0 40 08  8d+09:08:44.516  READ FPDMA QUEUED
  60 00 08 00 c8 00 01 b7 3e 3b 98 40 08  8d+09:08:44.509  READ FPDMA QUEUED
  60 00 08 00 c0 00 01 b7 3e 3b 90 40 08  8d+09:08:44.502  READ FPDMA QUEUED
  60 00 08 00 b8 00 01 b7 3e 3b 88 40 08  8d+09:08:44.495  READ FPDMA QUEUED

Error 8 [7] occurred at disk power-on lifetime: 21182 hours (882 days
+ 14 hours)
  When the command that caused the error occurred, the device was
active or idle.

  After command completion occurred, registers were:
  ER -- ST COUNT  LBA_48  LH LM LL DV DC
  -- -- -- == -- == == == -- -- -- -- --
  40 -- 51 00 00 00 01 b7 3e 3a b8 40 00  Error: UNC at LBA =
0x1b73e3ab8 = 7369276088

  Commands leading to the command that caused the error were:
  CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time  Command/Feature_Name
  -- == -- == -- == == == -- -- -- -- --  ---------------  --------------------
  60 04 00 00 90 00 01 b7 3e 3e 08 40 08  8d+09:08:40.925  READ FPDMA QUEUED
  60 04 00 00 88 00 01 b7 3e 42 08 40 08  8d+09:08:40.925  READ FPDMA QUEUED
  60 04 00 00 80 00 01 b7 3e 46 08 40 08  8d+09:08:40.925  READ FPDMA QUEUED
  60 04 00 00 78 00 01 b7 3e 62 08 40 08  8d+09:08:40.925  READ FPDMA QUEUED
  60 04 00 00 70 00 01 b7 3e 66 08 40 08  8d+09:08:40.925  READ FPDMA QUEUED

Error 7 [6] occurred at disk power-on lifetime: 21182 hours (882 days
+ 14 hours)
  When the command that caused the error occurred, the device was
active or idle.

  After command completion occurred, registers were:
  ER -- ST COUNT  LBA_48  LH LM LL DV DC
  -- -- -- == -- == == == -- -- -- -- --
  40 -- 51 00 00 00 01 b7 3e 3a b8 40 00  Error: UNC at LBA =
0x1b73e3ab8 = 7369276088

  Commands leading to the command that caused the error were:
  CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time  Command/Feature_Name
  -- == -- == -- == == == -- -- -- -- --  ---------------  --------------------
  60 04 00 00 18 00 01 b7 3e 62 08 40 08  8d+09:08:37.429  READ FPDMA QUEUED
  60 04 00 00 10 00 01 b7 3e 46 08 40 08  8d+09:08:37.429  READ FPDMA QUEUED
  60 04 00 00 08 00 01 b7 3e 42 08 40 08  8d+09:08:37.429  READ FPDMA QUEUED
  60 04 00 00 00 00 01 b7 3e 3e 08 40 08  8d+09:08:37.429  READ FPDMA QUEUED
  60 04 00 00 f0 00 01 b7 3e 3a 08 40 08  8d+09:08:37.429  READ FPDMA QUEUED

SMART Extended Self-test Log Version: 1 (1 sectors)
Num  Test_Description    Status                  Remaining
LifeTime(hours)  LBA_of_first_error
# 1  Short offline       Completed without error       00%     62717         -
# 2  Short offline       Completed without error       00%     62549         -
# 3  Short offline       Completed without error       00%     62382         -
# 4  Extended offline    Completed without error       00%     62373         -
# 5  Short offline       Completed without error       00%     62047         -
# 6  Short offline       Completed without error       00%     61879         -
# 7  Short offline       Completed without error       00%     61711         -
# 8  Extended offline    Completed without error       00%     61631         -
# 9  Short offline       Completed without error       00%     61544         -
#10  Short offline       Completed without error       00%     61376         -
#11  Short offline       Completed without error       00%     61208         -
#12  Short offline       Completed without error       00%     61040         -
#13  Extended offline    Completed without error       00%     60959         -
#14  Short offline       Completed without error       00%     60872         -
#15  Short offline       Completed without error       00%     61897         -
#16  Short offline       Completed without error       00%     61730         -
#17  Short offline       Completed without error       00%     61562         -
#18  Extended offline    Completed without error       00%     61409         -

SMART Selective self-test log data structure revision number 1
 SPAN  MIN_LBA  MAX_LBA  CURRENT_TEST_STATUS
    1        0        0  Not_testing
    2        0        0  Not_testing
    3        0        0  Not_testing
    4        0        0  Not_testing
    5        0        0  Not_testing
Selective self-test flags (0x0):
  After scanning selected spans, do NOT read-scan remainder of disk.
If Selective self-test is pending on power-up, resume after 0 minute delay.

SCT Status Version:                  3
SCT Version (vendor specific):       258 (0x0102)
Device State:                        Active (0)
Current Temperature:                    35 Celsius
Power Cycle Min/Max Temperature:     35/38 Celsius
Lifetime    Min/Max Temperature:     16/55 Celsius
Under/Over Temperature Limit Count:   0/0
Vendor specific:
01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

SCT Temperature History Version:     2
Temperature Sampling Period:         1 minute
Temperature Logging Interval:        1 minute
Min/Max recommended Temperature:      0/60 Celsius
Min/Max Temperature Limit:           -41/85 Celsius
Temperature History Size (Index):    478 (211)

Index    Estimated Time   Temperature Celsius
 212    2023-04-23 12:52    36  *****************
 ...    ..( 17 skipped).    ..  *****************
 230    2023-04-23 13:10    36  *****************
 231    2023-04-23 13:11    37  ******************
 ...    ..( 61 skipped).    ..  ******************
 293    2023-04-23 14:13    37  ******************
 294    2023-04-23 14:14    38  *******************
 ...    ..( 22 skipped).    ..  *******************
 317    2023-04-23 14:37    38  *******************
 318    2023-04-23 14:38    37  ******************
 319    2023-04-23 14:39    37  ******************
 320    2023-04-23 14:40    38  *******************
 ...    ..(  9 skipped).    ..  *******************
 330    2023-04-23 14:50    38  *******************
 331    2023-04-23 14:51    37  ******************
 ...    ..( 52 skipped).    ..  ******************
 384    2023-04-23 15:44    37  ******************
 385    2023-04-23 15:45    36  *****************
 ...    ..( 57 skipped).    ..  *****************
 443    2023-04-23 16:43    36  *****************
 444    2023-04-23 16:44    35  ****************
 ...    ..( 20 skipped).    ..  ****************
 465    2023-04-23 17:05    35  ****************
 466    2023-04-23 17:06    38  *******************
 ...    ..(109 skipped).    ..  *******************
  98    2023-04-23 18:56    38  *******************
  99    2023-04-23 18:57    39  ********************
 ...    ..( 28 skipped).    ..  ********************
 128    2023-04-23 19:26    39  ********************
 129    2023-04-23 19:27    38  *******************
 130    2023-04-23 19:28     ?  -
 131    2023-04-23 19:29    33  **************
 ...    ..(  2 skipped).    ..  **************
 134    2023-04-23 19:32    33  **************
 135    2023-04-23 19:33     ?  -
 136    2023-04-23 19:34    34  ***************
 ...    ..(  3 skipped).    ..  ***************
 140    2023-04-23 19:38    34  ***************
 141    2023-04-23 19:39    35  ****************
 ...    ..(  8 skipped).    ..  ****************
 150    2023-04-23 19:48    35  ****************
 151    2023-04-23 19:49    36  *****************
 ...    ..( 12 skipped).    ..  *****************
 164    2023-04-23 20:02    36  *****************
 165    2023-04-23 20:03     ?  -
 166    2023-04-23 20:04    36  *****************
 167    2023-04-23 20:05     ?  -
 168    2023-04-23 20:06    36  *****************
 169    2023-04-23 20:07    36  *****************
 170    2023-04-23 20:08     ?  -
 171    2023-04-23 20:09    37  ******************
 172    2023-04-23 20:10    36  *****************
 ...    ..( 29 skipped).    ..  *****************
 202    2023-04-23 20:40    36  *****************
 203    2023-04-23 20:41    35  ****************
 ...    ..(  2 skipped).    ..  ****************
 206    2023-04-23 20:44    35  ****************
 207    2023-04-23 20:45    36  *****************
 ...    ..(  3 skipped).    ..  *****************
 211    2023-04-23 20:49    36  *****************

SCT Error Recovery Control:
           Read:     70 (7.0 seconds)
          Write:     70 (7.0 seconds)

Device Statistics (GP/SMART Log 0x04) not supported

Pending Defects log (GP Log 0x0c) not supported

SATA Phy Event Counters (GP Log 0x11)
ID      Size     Value  Description
0x0001  2            0  Command failed due to ICRC error
0x0002  2            0  R_ERR response for data FIS
0x0003  2            0  R_ERR response for device-to-host data FIS
0x0004  2            0  R_ERR response for host-to-device data FIS
0x0005  2            0  R_ERR response for non-data FIS
0x0006  2            0  R_ERR response for device-to-host non-data FIS
0x0007  2            0  R_ERR response for host-to-device non-data FIS
0x0008  2            0  Device-to-host non-data FIS retries
0x0009  2           87  Transition from drive PhyRdy to drive PhyNRdy
0x000a  2           73  Device-to-host register FISes sent due to a COMRESET
0x000b  2            0  CRC errors within host-to-device FIS
0x000f  2            0  R_ERR response for host-to-device data FIS, CRC
0x0012  2            0  R_ERR response for host-to-device non-data FIS, CRC
0x8000  4        18495  Vendor specific

# smartctl --xall /dev/sde
smartctl 7.2 2020-12-30 r5155 [x86_64-linux-5.14.0-299.el9.x86_64] (local build)
Copyright (C) 2002-20, Bruce Allen, Christian Franke, www.smartmontools.org

=== START OF INFORMATION SECTION ===
Device Model:     WDC WD40EFPX-68C6CN0
Serial Number:    WD-WXK2AA2HCDY2
LU WWN Device Id: 5 0014ee 26ada4de8
Firmware Version: 81.00A81
User Capacity:    4,000,787,030,016 bytes [4.00 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Rotation Rate:    5400 rpm
Form Factor:      3.5 inches
Device is:        Not in smartctl database [for details use: -P showall]
ATA Version is:   ACS-3 T13/2161-D revision 5
SATA Version is:  SATA 3.1, 6.0 Gb/s (current: 6.0 Gb/s)
Local Time is:    Sun Apr 23 20:51:17 2023 CEST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled
AAM feature is:   Unavailable
APM feature is:   Unavailable
Rd look-ahead is: Enabled
Write cache is:   Enabled
DSN feature is:   Unavailable
ATA Security is:  Disabled, frozen [SEC2]
Wt Cache Reorder: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x00)    Offline data collection activity
                    was never started.
                    Auto Offline Data Collection: Disabled.
Self-test execution status:      (   0)    The previous self-test
routine completed
                    without error or no self-test has ever
                    been run.
Total time to complete Offline
data collection:         (42000) seconds.
Offline data collection
capabilities:              (0x7b) SMART execute Offline immediate.
                    Auto Offline data collection on/off support.
                    Suspend Offline collection upon new
                    command.
                    Offline surface scan supported.
                    Self-test supported.
                    Conveyance Self-test supported.
                    Selective Self-test supported.
SMART capabilities:            (0x0003)    Saves SMART data before entering
                    power-saving mode.
                    Supports SMART auto save timer.
Error logging capability:        (0x01)    Error logging supported.
                    General Purpose Logging supported.
Short self-test routine
recommended polling time:      (   2) minutes.
Extended self-test routine
recommended polling time:      ( 437) minutes.
Conveyance self-test routine
recommended polling time:      (   5) minutes.
SCT capabilities:            (0x3039)    SCT Status supported.
                    SCT Error Recovery Control supported.
                    SCT Feature Control supported.
                    SCT Data Table supported.

SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAGS    VALUE WORST THRESH FAIL RAW_VALUE
  1 Raw_Read_Error_Rate     POSR-K   100   253   051    -    0
  3 Spin_Up_Time            POS--K   207   207   021    -    2625
  4 Start_Stop_Count        -O--CK   100   100   000    -    7
  5 Reallocated_Sector_Ct   PO--CK   200   200   140    -    0
  7 Seek_Error_Rate         -OSR-K   100   253   000    -    0
  9 Power_On_Hours          -O--CK   100   100   000    -    22
 10 Spin_Retry_Count        -O--CK   100   253   000    -    0
 11 Calibration_Retry_Count -O--CK   100   253   000    -    0
 12 Power_Cycle_Count       -O--CK   100   100   000    -    6
192 Power-Off_Retract_Count -O--CK   200   200   000    -    4
193 Load_Cycle_Count        -O--CK   200   200   000    -    15
194 Temperature_Celsius     -O---K   120   111   000    -    27
196 Reallocated_Event_Count -O--CK   200   200   000    -    0
197 Current_Pending_Sector  -O--CK   200   200   000    -    0
198 Offline_Uncorrectable   ----CK   100   253   000    -    0
199 UDMA_CRC_Error_Count    -O--CK   200   200   000    -    0
200 Multi_Zone_Error_Rate   ---R--   100   253   000    -    0
                            ||||||_ K auto-keep
                            |||||__ C event count
                            ||||___ R error rate
                            |||____ S speed/performance
                            ||_____ O updated online
                            |______ P prefailure warning

General Purpose Log Directory Version 1
SMART           Log Directory Version 1 [multi-sector log support]
Address    Access  R/W   Size  Description
0x00       GPL,SL  R/O      1  Log Directory
0x01           SL  R/O      1  Summary SMART error log
0x02           SL  R/O      5  Comprehensive SMART error log
0x03       GPL     R/O      6  Ext. Comprehensive SMART error log
0x04       GPL     R/O    256  Device Statistics log
0x04       SL      R/O    255  Device Statistics log
0x06           SL  R/O      1  SMART self-test log
0x07       GPL     R/O      1  Extended self-test log
0x09           SL  R/W      1  Selective self-test log
0x0c       GPL     R/O   2048  Pending Defects log
0x10       GPL     R/O      1  NCQ Command Error log
0x11       GPL     R/O      1  SATA Phy Event Counters log
0x24       GPL     R/O    307  Current Device Internal Status Data log
0x30       GPL,SL  R/O      9  IDENTIFY DEVICE data log
0x80-0x9f  GPL,SL  R/W     16  Host vendor specific log
0xa0-0xa7  GPL,SL  VS      16  Device vendor specific log
0xa8-0xb6  GPL,SL  VS       1  Device vendor specific log
0xb7       GPL,SL  VS      78  Device vendor specific log
0xbd       GPL,SL  VS       1  Device vendor specific log
0xc0       GPL,SL  VS       1  Device vendor specific log
0xc1       GPL     VS      93  Device vendor specific log
0xe0       GPL,SL  R/W      1  SCT Command/Status
0xe1       GPL,SL  R/W      1  SCT Data Transfer

SMART Extended Comprehensive Error Log Version: 1 (6 sectors)
No Errors Logged

SMART Extended Self-test Log Version: 1 (1 sectors)
No self-tests have been logged.  [To run self-tests, use: smartctl -t]

SMART Selective self-test log data structure revision number 1
 SPAN  MIN_LBA  MAX_LBA  CURRENT_TEST_STATUS
    1        0        0  Not_testing
    2        0        0  Not_testing
    3        0        0  Not_testing
    4        0        0  Not_testing
    5        0        0  Not_testing
Selective self-test flags (0x0):
  After scanning selected spans, do NOT read-scan remainder of disk.
If Selective self-test is pending on power-up, resume after 0 minute delay.

SCT Status Version:                  3
SCT Version (vendor specific):       258 (0x0102)
Device State:                        Active (0)
Current Temperature:                    27 Celsius
Power Cycle Min/Max Temperature:     27/29 Celsius
Lifetime    Min/Max Temperature:     20/29 Celsius
Under/Over Temperature Limit Count:   0/0
Vendor specific:
01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

SCT Temperature History Version:     2
Temperature Sampling Period:         1 minute
Temperature Logging Interval:        1 minute
Min/Max recommended Temperature:      0/65 Celsius
Min/Max Temperature Limit:           -41/85 Celsius
Temperature History Size (Index):    478 (361)

Index    Estimated Time   Temperature Celsius
 362    2023-04-23 12:54    26  *******
 ...    ..(146 skipped).    ..  *******
  31    2023-04-23 15:21    26  *******
  32    2023-04-23 15:22     ?  -
  33    2023-04-23 15:23    25  ******
  34    2023-04-23 15:24    24  *****
  35    2023-04-23 15:25    24  *****
  36    2023-04-23 15:26    25  ******
 ...    ..(  3 skipped).    ..  ******
  40    2023-04-23 15:30    25  ******
  41    2023-04-23 15:31     ?  -
  42    2023-04-23 15:32    26  *******
 ...    ..(  4 skipped).    ..  *******
  47    2023-04-23 15:37    26  *******
  48    2023-04-23 15:38    27  ********
 ...    ..(  5 skipped).    ..  ********
  54    2023-04-23 15:44    27  ********
  55    2023-04-23 15:45     ?  -
  56    2023-04-23 15:46    27  ********
  57    2023-04-23 15:47     ?  -
  58    2023-04-23 15:48    27  ********
 ...    ..(  4 skipped).    ..  ********
  63    2023-04-23 15:53    27  ********
  64    2023-04-23 15:54     ?  -
  65    2023-04-23 15:55    28  *********
  66    2023-04-23 15:56    27  ********
 ...    ..(  2 skipped).    ..  ********
  69    2023-04-23 15:59    27  ********
  70    2023-04-23 16:00    28  *********
 ...    ..( 13 skipped).    ..  *********
  84    2023-04-23 16:14    28  *********
  85    2023-04-23 16:15    27  ********
 ...    ..( 19 skipped).    ..  ********
 105    2023-04-23 16:35    27  ********
 106    2023-04-23 16:36    28  *********
 ...    ..(  3 skipped).    ..  *********
 110    2023-04-23 16:40    28  *********
 111    2023-04-23 16:41    27  ********
 112    2023-04-23 16:42    28  *********
 113    2023-04-23 16:43    27  ********
 ...    ..( 14 skipped).    ..  ********
 128    2023-04-23 16:58    27  ********
 129    2023-04-23 16:59    28  *********
 ...    ..(  3 skipped).    ..  *********
 133    2023-04-23 17:03    28  *********
 134    2023-04-23 17:04    27  ********
 135    2023-04-23 17:05    27  ********
 136    2023-04-23 17:06    27  ********
 137    2023-04-23 17:07    28  *********
 ...    ..( 16 skipped).    ..  *********
 154    2023-04-23 17:24    28  *********
 155    2023-04-23 17:25    27  ********
 ...    ..(  4 skipped).    ..  ********
 160    2023-04-23 17:30    27  ********
 161    2023-04-23 17:31    28  *********
 ...    ..( 15 skipped).    ..  *********
 177    2023-04-23 17:47    28  *********
 178    2023-04-23 17:48    29  **********
 179    2023-04-23 17:49    29  **********
 180    2023-04-23 17:50    28  *********
 ...    ..(  5 skipped).    ..  *********
 186    2023-04-23 17:56    28  *********
 187    2023-04-23 17:57    29  **********
 188    2023-04-23 17:58    28  *********
 ...    ..(  4 skipped).    ..  *********
 193    2023-04-23 18:03    28  *********
 194    2023-04-23 18:04    29  **********
 195    2023-04-23 18:05    29  **********
 196    2023-04-23 18:06    28  *********
 ...    ..(  3 skipped).    ..  *********
 200    2023-04-23 18:10    28  *********
 201    2023-04-23 18:11    29  **********
 ...    ..(  6 skipped).    ..  **********
 208    2023-04-23 18:18    29  **********
 209    2023-04-23 18:19    28  *********
 ...    ..(  9 skipped).    ..  *********
 219    2023-04-23 18:29    28  *********
 220    2023-04-23 18:30    29  **********
 221    2023-04-23 18:31    29  **********
 222    2023-04-23 18:32    29  **********
 223    2023-04-23 18:33    28  *********
 ...    ..( 21 skipped).    ..  *********
 245    2023-04-23 18:55    28  *********
 246    2023-04-23 18:56    29  **********
 247    2023-04-23 18:57    28  *********
 ...    ..( 31 skipped).    ..  *********
 279    2023-04-23 19:29    28  *********
 280    2023-04-23 19:30    27  ********
 281    2023-04-23 19:31    28  *********
 282    2023-04-23 19:32    28  *********
 283    2023-04-23 19:33    27  ********
 284    2023-04-23 19:34    28  *********
 285    2023-04-23 19:35    27  ********
 ...    ..( 75 skipped).    ..  ********
 361    2023-04-23 20:51    27  ********

SCT Error Recovery Control:
           Read:     70 (7.0 seconds)
          Write:     70 (7.0 seconds)

Device Statistics (GP Log 0x04)
Page  Offset Size        Value Flags Description
0x01  =====  =               =  ===  == General Statistics (rev 3) ==
0x01  0x008  4               6  ---  Lifetime Power-On Resets
0x01  0x010  4              22  ---  Power-on Hours
0x01  0x018  6            5438  ---  Logical Sectors Written
0x01  0x020  6            5429  ---  Number of Write Commands
0x01  0x028  6           25138  ---  Logical Sectors Read
0x01  0x030  6            1710  ---  Number of Read Commands
0x01  0x038  6        79200000  ---  Date and Time TimeStamp
0x02  =====  =               =  ===  == Free-Fall Statistics (rev 1) ==
0x02  0x010  4               0  ---  Overlimit Shock Events
0x03  =====  =               =  ===  == Rotating Media Statistics (rev 1) ==
0x03  0x008  4              21  ---  Spindle Motor Power-on Hours
0x03  0x010  4              18  ---  Head Flying Hours
0x03  0x018  4              20  ---  Head Load Events
0x03  0x020  4               0  ---  Number of Reallocated Logical Sectors
0x03  0x028  4               0  ---  Read Recovery Attempts
0x03  0x030  4               0  ---  Number of Mechanical Start Failures
0x03  0x038  4               0  ---  Number of Realloc. Candidate
Logical Sectors
0x03  0x040  4               4  ---  Number of High Priority Unload Events
0x04  =====  =               =  ===  == General Errors Statistics (rev 1) ==
0x04  0x008  4               0  ---  Number of Reported Uncorrectable Errors
0x04  0x010  4               0  ---  Resets Between Cmd Acceptance and
Completion
0x05  =====  =               =  ===  == Temperature Statistics (rev 1) ==
0x05  0x008  1              27  ---  Current Temperature
0x05  0x010  1               -  ---  Average Short Term Temperature
0x05  0x018  1               -  ---  Average Long Term Temperature
0x05  0x020  1              29  ---  Highest Temperature
0x05  0x028  1              24  ---  Lowest Temperature
0x05  0x030  1               -  ---  Highest Average Short Term Temperature
0x05  0x038  1               -  ---  Lowest Average Short Term Temperature
0x05  0x040  1               -  ---  Highest Average Long Term Temperature
0x05  0x048  1               -  ---  Lowest Average Long Term Temperature
0x05  0x050  4               0  ---  Time in Over-Temperature
0x05  0x058  1              65  ---  Specified Maximum Operating Temperature
0x05  0x060  4               0  ---  Time in Under-Temperature
0x05  0x068  1               0  ---  Specified Minimum Operating Temperature
0x06  =====  =               =  ===  == Transport Statistics (rev 1) ==
0x06  0x008  4             130  ---  Number of Hardware Resets
0x06  0x010  4              63  ---  Number of ASR Events
0x06  0x018  4               0  ---  Number of Interface CRC Errors
0xff  =====  =               =  ===  == Vendor Specific Statistics (rev 1) ==
0xff  0x008  7               0  ---  Vendor Specific
0xff  0x010  7               0  ---  Vendor Specific
0xff  0x018  7               0  ---  Vendor Specific
                                |||_ C monitored condition met
                                ||__ D supports DSN
                                |___ N normalized value

Pending Defects log (GP Log 0x0c)
No Defects Logged

SATA Phy Event Counters (GP Log 0x11)
ID      Size     Value  Description
0x0001  2            0  Command failed due to ICRC error
0x0002  2            0  R_ERR response for data FIS
0x0003  2            0  R_ERR response for device-to-host data FIS
0x0004  2            0  R_ERR response for host-to-device data FIS
0x0005  2            0  R_ERR response for non-data FIS
0x0006  2            0  R_ERR response for device-to-host non-data FIS
0x0007  2            0  R_ERR response for host-to-device non-data FIS
0x0008  2            0  Device-to-host non-data FIS retries
0x0009  2           88  Transition from drive PhyRdy to drive PhyNRdy
0x000a  2           89  Device-to-host register FISes sent due to a COMRESET
0x000b  2            0  CRC errors within host-to-device FIS
0x000d  2            0  Non-CRC errors within host-to-device FIS
0x000f  2            0  R_ERR response for host-to-device data FIS, CRC
0x0012  2            0  R_ERR response for host-to-device non-data FIS, CRC
0x8000  4        18606  Vendor specific

# smartctl --xall /dev/sdf
smartctl 7.2 2020-12-30 r5155 [x86_64-linux-5.14.0-299.el9.x86_64] (local build)
Copyright (C) 2002-20, Bruce Allen, Christian Franke, www.smartmontools.org

=== START OF INFORMATION SECTION ===
Device Model:     WDC WD40EFPX-68C6CN0
Serial Number:    WD-WX42A92A31RX
LU WWN Device Id: 5 0014ee 215825736
Firmware Version: 81.00A81
User Capacity:    4,000,787,030,016 bytes [4.00 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Rotation Rate:    5400 rpm
Form Factor:      3.5 inches
Device is:        Not in smartctl database [for details use: -P showall]
ATA Version is:   ACS-3 T13/2161-D revision 5
SATA Version is:  SATA 3.1, 6.0 Gb/s (current: 6.0 Gb/s)
Local Time is:    Sun Apr 23 20:51:46 2023 CEST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled
AAM feature is:   Unavailable
APM feature is:   Unavailable
Rd look-ahead is: Enabled
Write cache is:   Enabled
DSN feature is:   Unavailable
ATA Security is:  Disabled, frozen [SEC2]
Wt Cache Reorder: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x00)    Offline data collection activity
                    was never started.
                    Auto Offline Data Collection: Disabled.
Self-test execution status:      (   0)    The previous self-test
routine completed
                    without error or no self-test has ever
                    been run.
Total time to complete Offline
data collection:         (39060) seconds.
Offline data collection
capabilities:              (0x7b) SMART execute Offline immediate.
                    Auto Offline data collection on/off support.
                    Suspend Offline collection upon new
                    command.
                    Offline surface scan supported.
                    Self-test supported.
                    Conveyance Self-test supported.
                    Selective Self-test supported.
SMART capabilities:            (0x0003)    Saves SMART data before entering
                    power-saving mode.
                    Supports SMART auto save timer.
Error logging capability:        (0x01)    Error logging supported.
                    General Purpose Logging supported.
Short self-test routine
recommended polling time:      (   2) minutes.
Extended self-test routine
recommended polling time:      ( 407) minutes.
Conveyance self-test routine
recommended polling time:      (   5) minutes.
SCT capabilities:            (0x3039)    SCT Status supported.
                    SCT Error Recovery Control supported.
                    SCT Feature Control supported.
                    SCT Data Table supported.

SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAGS    VALUE WORST THRESH FAIL RAW_VALUE
  1 Raw_Read_Error_Rate     POSR-K   100   253   051    -    0
  3 Spin_Up_Time            POS--K   206   206   021    -    2658
  4 Start_Stop_Count        -O--CK   100   100   000    -    7
  5 Reallocated_Sector_Ct   PO--CK   200   200   140    -    0
  7 Seek_Error_Rate         -OSR-K   200   200   000    -    0
  9 Power_On_Hours          -O--CK   100   100   000    -    22
 10 Spin_Retry_Count        -O--CK   100   253   000    -    0
 11 Calibration_Retry_Count -O--CK   100   253   000    -    0
 12 Power_Cycle_Count       -O--CK   100   100   000    -    6
192 Power-Off_Retract_Count -O--CK   200   200   000    -    4
193 Load_Cycle_Count        -O--CK   200   200   000    -    19
194 Temperature_Celsius     -O---K   118   113   000    -    29
196 Reallocated_Event_Count -O--CK   200   200   000    -    0
197 Current_Pending_Sector  -O--CK   200   200   000    -    0
198 Offline_Uncorrectable   ----CK   100   253   000    -    0
199 UDMA_CRC_Error_Count    -O--CK   200   200   000    -    0
200 Multi_Zone_Error_Rate   ---R--   100   253   000    -    0
                            ||||||_ K auto-keep
                            |||||__ C event count
                            ||||___ R error rate
                            |||____ S speed/performance
                            ||_____ O updated online
                            |______ P prefailure warning

General Purpose Log Directory Version 1
SMART           Log Directory Version 1 [multi-sector log support]
Address    Access  R/W   Size  Description
0x00       GPL,SL  R/O      1  Log Directory
0x01           SL  R/O      1  Summary SMART error log
0x02           SL  R/O      5  Comprehensive SMART error log
0x03       GPL     R/O      6  Ext. Comprehensive SMART error log
0x04       GPL     R/O    256  Device Statistics log
0x04       SL      R/O    255  Device Statistics log
0x06           SL  R/O      1  SMART self-test log
0x07       GPL     R/O      1  Extended self-test log
0x09           SL  R/W      1  Selective self-test log
0x0c       GPL     R/O   2048  Pending Defects log
0x10       GPL     R/O      1  NCQ Command Error log
0x11       GPL     R/O      1  SATA Phy Event Counters log
0x24       GPL     R/O    307  Current Device Internal Status Data log
0x30       GPL,SL  R/O      9  IDENTIFY DEVICE data log
0x80-0x9f  GPL,SL  R/W     16  Host vendor specific log
0xa0-0xa7  GPL,SL  VS      16  Device vendor specific log
0xa8-0xb6  GPL,SL  VS       1  Device vendor specific log
0xb7       GPL,SL  VS      78  Device vendor specific log
0xbd       GPL,SL  VS       1  Device vendor specific log
0xc0       GPL,SL  VS       1  Device vendor specific log
0xc1       GPL     VS      93  Device vendor specific log
0xe0       GPL,SL  R/W      1  SCT Command/Status
0xe1       GPL,SL  R/W      1  SCT Data Transfer

SMART Extended Comprehensive Error Log Version: 1 (6 sectors)
No Errors Logged

SMART Extended Self-test Log Version: 1 (1 sectors)
No self-tests have been logged.  [To run self-tests, use: smartctl -t]

SMART Selective self-test log data structure revision number 1
 SPAN  MIN_LBA  MAX_LBA  CURRENT_TEST_STATUS
    1        0        0  Not_testing
    2        0        0  Not_testing
    3        0        0  Not_testing
    4        0        0  Not_testing
    5        0        0  Not_testing
Selective self-test flags (0x0):
  After scanning selected spans, do NOT read-scan remainder of disk.
If Selective self-test is pending on power-up, resume after 0 minute delay.

SCT Status Version:                  3
SCT Version (vendor specific):       258 (0x0102)
Device State:                        Active (0)
Current Temperature:                    29 Celsius
Power Cycle Min/Max Temperature:     29/31 Celsius
Lifetime    Min/Max Temperature:     20/31 Celsius
Under/Over Temperature Limit Count:   0/0
Vendor specific:
01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

SCT Temperature History Version:     2
Temperature Sampling Period:         1 minute
Temperature Logging Interval:        1 minute
Min/Max recommended Temperature:      0/65 Celsius
Min/Max Temperature Limit:           -41/85 Celsius
Temperature History Size (Index):    478 (376)

Index    Estimated Time   Temperature Celsius
 377    2023-04-23 12:54    29  **********
 ...    ..(132 skipped).    ..  **********
  32    2023-04-23 15:07    29  **********
  33    2023-04-23 15:08     ?  -
  34    2023-04-23 15:09    26  *******
 ...    ..(  2 skipped).    ..  *******
  37    2023-04-23 15:12    26  *******
  38    2023-04-23 15:13    27  ********
 ...    ..(  2 skipped).    ..  ********
  41    2023-04-23 15:16    27  ********
  42    2023-04-23 15:17     ?  -
  43    2023-04-23 15:18    28  *********
 ...    ..(  4 skipped).    ..  *********
  48    2023-04-23 15:23    28  *********
  49    2023-04-23 15:24    29  **********
 ...    ..(  7 skipped).    ..  **********
  57    2023-04-23 15:32    29  **********
  58    2023-04-23 15:33    30  ***********
 ...    ..(  9 skipped).    ..  ***********
  68    2023-04-23 15:43    30  ***********
  69    2023-04-23 15:44    29  **********
  70    2023-04-23 15:45     ?  -
  71    2023-04-23 15:46    29  **********
  72    2023-04-23 15:47     ?  -
  73    2023-04-23 15:48    29  **********
 ...    ..(  2 skipped).    ..  **********
  76    2023-04-23 15:51    29  **********
  77    2023-04-23 15:52    30  ***********
  78    2023-04-23 15:53    30  ***********
  79    2023-04-23 15:54     ?  -
  80    2023-04-23 15:55    30  ***********
 ...    ..(  5 skipped).    ..  ***********
  86    2023-04-23 16:01    30  ***********
  87    2023-04-23 16:02    31  ************
  88    2023-04-23 16:03    31  ************
  89    2023-04-23 16:04    30  ***********
 ...    ..( 15 skipped).    ..  ***********
 105    2023-04-23 16:20    30  ***********
 106    2023-04-23 16:21    29  **********
 107    2023-04-23 16:22    30  ***********
 108    2023-04-23 16:23    29  **********
 ...    ..( 11 skipped).    ..  **********
 120    2023-04-23 16:35    29  **********
 121    2023-04-23 16:36    30  ***********
 ...    ..(  6 skipped).    ..  ***********
 128    2023-04-23 16:43    30  ***********
 129    2023-04-23 16:44    29  **********
 ...    ..(  4 skipped).    ..  **********
 134    2023-04-23 16:49    29  **********
 135    2023-04-23 16:50    30  ***********
 ...    ..(  2 skipped).    ..  ***********
 138    2023-04-23 16:53    30  ***********
 139    2023-04-23 16:54    29  **********
 140    2023-04-23 16:55    29  **********
 141    2023-04-23 16:56    30  ***********
 ...    ..(  6 skipped).    ..  ***********
 148    2023-04-23 17:03    30  ***********
 149    2023-04-23 17:04    29  **********
 150    2023-04-23 17:05    29  **********
 151    2023-04-23 17:06    30  ***********
 ...    ..( 14 skipped).    ..  ***********
 166    2023-04-23 17:21    30  ***********
 167    2023-04-23 17:22    29  **********
 ...    ..(  3 skipped).    ..  **********
 171    2023-04-23 17:26    29  **********
 172    2023-04-23 17:27    30  ***********
 ...    ..( 19 skipped).    ..  ***********
 192    2023-04-23 17:47    30  ***********
 193    2023-04-23 17:48    31  ************
 194    2023-04-23 17:49    31  ************
 195    2023-04-23 17:50    31  ************
 196    2023-04-23 17:51    30  ***********
 ...    ..(  4 skipped).    ..  ***********
 201    2023-04-23 17:56    30  ***********
 202    2023-04-23 17:57    31  ************
 203    2023-04-23 17:58    30  ***********
 ...    ..(  4 skipped).    ..  ***********
 208    2023-04-23 18:03    30  ***********
 209    2023-04-23 18:04    31  ************
 210    2023-04-23 18:05    31  ************
 211    2023-04-23 18:06    30  ***********
 ...    ..(  4 skipped).    ..  ***********
 216    2023-04-23 18:11    30  ***********
 217    2023-04-23 18:12    31  ************
 ...    ..(  5 skipped).    ..  ************
 223    2023-04-23 18:18    31  ************
 224    2023-04-23 18:19    30  ***********
 ...    ..(  9 skipped).    ..  ***********
 234    2023-04-23 18:29    30  ***********
 235    2023-04-23 18:30    31  ************
 ...    ..(  2 skipped).    ..  ************
 238    2023-04-23 18:33    31  ************
 239    2023-04-23 18:34    30  ***********
 ...    ..( 12 skipped).    ..  ***********
 252    2023-04-23 18:47    30  ***********
 253    2023-04-23 18:48    29  **********
 254    2023-04-23 18:49    29  **********
 255    2023-04-23 18:50    30  ***********
 ...    ..( 30 skipped).    ..  ***********
 286    2023-04-23 19:21    30  ***********
 287    2023-04-23 19:22    29  **********
 ...    ..( 25 skipped).    ..  **********
 313    2023-04-23 19:48    29  **********
 314    2023-04-23 19:49    30  ***********
 ...    ..(  2 skipped).    ..  ***********
 317    2023-04-23 19:52    30  ***********
 318    2023-04-23 19:53    29  **********
 ...    ..( 57 skipped).    ..  **********
 376    2023-04-23 20:51    29  **********

SCT Error Recovery Control:
           Read:     70 (7.0 seconds)
          Write:     70 (7.0 seconds)

Device Statistics (GP Log 0x04)
Page  Offset Size        Value Flags Description
0x01  =====  =               =  ===  == General Statistics (rev 3) ==
0x01  0x008  4               6  ---  Lifetime Power-On Resets
0x01  0x010  4              22  ---  Power-on Hours
0x01  0x018  6      3474015532  ---  Logical Sectors Written
0x01  0x020  6        29684071  ---  Number of Write Commands
0x01  0x028  6           25060  ---  Logical Sectors Read
0x01  0x030  6            1639  ---  Number of Read Commands
0x01  0x038  6        79200000  ---  Date and Time TimeStamp
0x02  =====  =               =  ===  == Free-Fall Statistics (rev 1) ==
0x02  0x010  4               0  ---  Overlimit Shock Events
0x03  =====  =               =  ===  == Rotating Media Statistics (rev 1) ==
0x03  0x008  4              22  ---  Spindle Motor Power-on Hours
0x03  0x010  4              18  ---  Head Flying Hours
0x03  0x018  4              24  ---  Head Load Events
0x03  0x020  4               0  ---  Number of Reallocated Logical Sectors
0x03  0x028  4               0  ---  Read Recovery Attempts
0x03  0x030  4               0  ---  Number of Mechanical Start Failures
0x03  0x038  4               0  ---  Number of Realloc. Candidate
Logical Sectors
0x03  0x040  4               4  ---  Number of High Priority Unload Events
0x04  =====  =               =  ===  == General Errors Statistics (rev 1) ==
0x04  0x008  4               0  ---  Number of Reported Uncorrectable Errors
0x04  0x010  4               0  ---  Resets Between Cmd Acceptance and
Completion
0x05  =====  =               =  ===  == Temperature Statistics (rev 1) ==
0x05  0x008  1              29  ---  Current Temperature
0x05  0x010  1               -  ---  Average Short Term Temperature
0x05  0x018  1               -  ---  Average Long Term Temperature
0x05  0x020  1              31  ---  Highest Temperature
0x05  0x028  1              25  ---  Lowest Temperature
0x05  0x030  1               -  ---  Highest Average Short Term Temperature
0x05  0x038  1               -  ---  Lowest Average Short Term Temperature
0x05  0x040  1               -  ---  Highest Average Long Term Temperature
0x05  0x048  1               -  ---  Lowest Average Long Term Temperature
0x05  0x050  4               0  ---  Time in Over-Temperature
0x05  0x058  1              65  ---  Specified Maximum Operating Temperature
0x05  0x060  4               0  ---  Time in Under-Temperature
0x05  0x068  1               0  ---  Specified Minimum Operating Temperature
0x06  =====  =               =  ===  == Transport Statistics (rev 1) ==
0x06  0x008  4             130  ---  Number of Hardware Resets
0x06  0x010  4              66  ---  Number of ASR Events
0x06  0x018  4               0  ---  Number of Interface CRC Errors
0xff  =====  =               =  ===  == Vendor Specific Statistics (rev 1) ==
0xff  0x008  7               0  ---  Vendor Specific
0xff  0x010  7               0  ---  Vendor Specific
0xff  0x018  7               0  ---  Vendor Specific
                                |||_ C monitored condition met
                                ||__ D supports DSN
                                |___ N normalized value

Pending Defects log (GP Log 0x0c)
No Defects Logged

SATA Phy Event Counters (GP Log 0x11)
ID      Size     Value  Description
0x0001  2            0  Command failed due to ICRC error
0x0002  2            0  R_ERR response for data FIS
0x0003  2            0  R_ERR response for device-to-host data FIS
0x0004  2            0  R_ERR response for host-to-device data FIS
0x0005  2            0  R_ERR response for non-data FIS
0x0006  2            0  R_ERR response for device-to-host non-data FIS
0x0007  2            0  R_ERR response for host-to-device non-data FIS
0x0008  2            0  Device-to-host non-data FIS retries
0x0009  2           88  Transition from drive PhyRdy to drive PhyNRdy
0x000a  2           89  Device-to-host register FISes sent due to a COMRESET
0x000b  2            0  CRC errors within host-to-device FIS
0x000d  2            0  Non-CRC errors within host-to-device FIS
0x000f  2            0  R_ERR response for host-to-device data FIS, CRC
0x0012  2            0  R_ERR response for host-to-device non-data FIS, CRC
0x8000  4        18634  Vendor specific
