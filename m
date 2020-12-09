Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 622ACC433FE
	for <linux-raid@archiver.kernel.org>; Wed,  9 Dec 2020 03:47:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 300BD23975
	for <linux-raid@archiver.kernel.org>; Wed,  9 Dec 2020 03:47:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726288AbgLIDrD (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 8 Dec 2020 22:47:03 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:37865 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725283AbgLIDrD (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 8 Dec 2020 22:47:03 -0500
Received: from mail-pg1-f198.google.com ([209.85.215.198])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <matthew.ruffell@canonical.com>)
        id 1kmqQm-00060N-Bz
        for linux-raid@vger.kernel.org; Wed, 09 Dec 2020 03:46:20 +0000
Received: by mail-pg1-f198.google.com with SMTP id o128so267781pga.2
        for <linux-raid@vger.kernel.org>; Tue, 08 Dec 2020 19:46:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=LqsfjdpvRBrJPnLpBLMyDBgFdfBa9hHPug34fwUzfwc=;
        b=qkpGVF32WwG+n6E6Fdonvns1oFE5sZQ48nDOpPL9LvTrYC3YKTfMJDp9cNAH3XN3VA
         FCek2Bsz+45kd8768TdkNsK1rVvCDs7r9nnKz32a7J5lu2Q7TGDER+W071O/7pNZvKq5
         9fwGBpInUpkjjf7XwIUDpChqdYqToB/UrhWDx96OTQeSfJlH+ZPMAh3dBE1JQBy7VG5Q
         aEbN/v62DjQFgWxaJNy8IXcwuMGtwkqXT2McEqi8Jot3HIEM0aMjrhufAiOifR3X3EwR
         fr8F3SbprpVjAXLpxobVC9h/Bnkp+08rFFUIXh64aQlMoQNM132aQFFwQ5knyBqmhHUn
         wsOA==
X-Gm-Message-State: AOAM5327vOw5DwzmnHNd6cqwXgH4o5vyceJz4fAAjt+OXI0prRVxi/qV
        kTUgZ85J6QPeGgFx2oEEzfKLRQJFvkjlokJWa8U//OqlGCgLj1wBq17iGn86kGc1CkrJCzAiNRI
        vm+3Vq4ri+1c1KATdm2OcyeTD+DbPB86N4Gc5R0o=
X-Received: by 2002:a65:414d:: with SMTP id x13mr215037pgp.226.1607485578568;
        Tue, 08 Dec 2020 19:46:18 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw3iA2Op3W2abvcsx1yFM+J9B0Hqz9B8+s1CTmq5LiCD6qd4eM8vmhS3TmHfkHMS5rMWdqmWg==
X-Received: by 2002:a65:414d:: with SMTP id x13mr215015pgp.226.1607485578220;
        Tue, 08 Dec 2020 19:46:18 -0800 (PST)
Received: from [192.168.1.107] (222-152-178-139-fibre.sparkbb.co.nz. [222.152.178.139])
        by smtp.gmail.com with ESMTPSA id jz20sm291676pjb.4.2020.12.08.19.46.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Dec 2020 19:46:17 -0800 (PST)
To:     xni@redhat.com, linux-raid@vger.kernel.org
Cc:     song@kernel.org, linux-kernel@vger.kernel.org, colyli@suse.de,
        guoqing.jiang@cloud.ionos.com, songliubraving@fb.com,
        khalid.elmously@canonical.com, jay.vosburgh@canonical.com
From:   Matthew Ruffell <matthew.ruffell@canonical.com>
Subject: PROBLEM: Recent raid10 block discard patchset causes filesystem
 corruption on fstrim
Message-ID: <dbd2761e-cd7d-d60a-f769-ecc8c6335814@canonical.com>
Date:   Wed, 9 Dec 2020 16:46:11 +1300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hello,

I recently backported the following patches into the Ubuntu stable kernels:

md: add md_submit_discard_bio() for submitting discard bio
md/raid10: extend r10bio devs to raid disks
md/raid10: pull codes that wait for blocked dev into one function
md/raid10: improve raid10 discard request
md/raid10: improve discard request for far layout
dm raid: fix discard limits for raid1 and raid10
dm raid: remove unnecessary discard limits for raid10

and this morning, a user reported the following downstream bug:

https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1907262/

Their weekly cronjob that runs fstrim had run, and their raid10 array has
extensive data corruption. 

The issue is reproducible on the latest 5.10-rc7 mainline kernel, steps are
below.

I used a m5d.4xlarge instance on AWS to ultilise 2x 300GB SSDs that support
block discard. You will want to select small disks to lower the time needed
to reproduce.

$ uname -rv
5.10.0-rc7+ #1 SMP Wed Dec 9 01:15:27 UTC 2020

Create a raid10 array, with LVM:

$ lsblk
NAME        MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
nvme0n1     259:0    0     8G  0 disk 
└─nvme0n1p1 259:1    0     8G  0 part /
nvme1n1     259:2    0 279.4G  0 disk 
nvme2n1     259:3    0 279.4G  0 disk

$ sudo -s
# mdadm -C -v -l10 -n2 -N "lv-raid" -R /dev/md0 /dev/nvme1n1 /dev/nvme2n1
mdadm: layout defaults to n2
mdadm: layout defaults to n2
mdadm: chunk size defaults to 512K
mdadm: size set to 292836352K
mdadm: automatically enabling write-intent bitmap on large array
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md0 started.
# pvcreate -ff -y /dev/md0
  Physical volume "/dev/md0" successfully created.
# vgcreate -f -y VolGroup /dev/md0
  Volume group "VolGroup" successfully created
# lvcreate -n root -L 100G -ay -y VolGroup
  Logical volume "root" created.
# mkfs.ext4 /dev/VolGroup/root
mke2fs 1.44.1 (24-Mar-2018)
Discarding device blocks: done                            
Creating filesystem with 26214400 4k blocks and 6553600 inodes
Filesystem UUID: d7be2e14-fa4d-4489-884b-3bef63b1e1db
Superblock backups stored on blocks: 
	32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632, 2654208, 
	4096000, 7962624, 11239424, 20480000, 23887872

Allocating group tables: done                            
Writing inode tables: done                            
Creating journal (131072 blocks): done
Writing superblocks and filesystem accounting information: done
# mount /dev/VolGroup/root /mnt

Next, wait for the disk check to complete, 25 minutes on m5d.4xlarge instance.

# cat /proc/mdstat
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4] [raid10] 
md0 : active raid10 nvme2n1[1] nvme1n1[0]
      292836352 blocks super 1.2 2 near-copies [2/2] [UU]
      [==>..................]  resync = 12.0% (35211392/292836352) finish=21.4min speed=200340K/sec
      bitmap: 3/3 pages [12KB], 65536KB chunk

unused devices: <none>
# cat /sys/block/md0/md/mismatch_cnt
76918016

# cat /proc/mdstat
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4] [raid10] 
md0 : active raid10 nvme2n1[1] nvme1n1[0]
      292836352 blocks super 1.2 2 near-copies [2/2] [UU]
      bitmap: 0/3 pages [0KB], 65536KB chunk

unused devices: <none>
# cat /sys/block/md0/md/mismatch_cnt
582330240

Now that the check is complete, create a file, sync and delete it:

# dd if=/dev/zero of=/mnt/data.raw bs=4K count=1M
1048576+0 records in
1048576+0 records out
4294967296 bytes (4.3 GB, 4.0 GiB) copied, 3.95974 s, 1.1 GB/s
# sync
# rm /mnt/data.raw

Perform a check:

# echo check > /sys/block/md0/md/sync_action

Again, wait 25 minutes for it to complete:

# cat /proc/mdstat
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4] [raid10] 
md0 : active raid10 nvme1n1[1] nvme2n1[0]
      292836352 blocks super 1.2 2 near-copies [2/2] [UU]
      [==>..................]  check = 13.7% (40356224/292836352) finish=20.8min speed=201707K/sec
      bitmap: 0/3 pages [0KB], 65536KB chunk

unused devices: <none>
# cat /sys/block/md0/md/mismatch_cnt
1469696

# cat /proc/mdstat
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4] [raid10] 
md0 : active raid10 nvme1n1[1] nvme2n1[0]
      292836352 blocks super 1.2 2 near-copies [2/2] [UU]
      bitmap: 0/3 pages [0KB], 65536KB chunk

unused devices: <none>
# cat /sys/block/md0/md/mismatch_cnt
1469696

Now, perform the fstrim:

# fstrim /mnt --verbose
/mnt: 97.9 GiB (105089236992 bytes) trimmed

Go for another check:

# echo check >/sys/block/md0/md/sync_action
# cat /proc/mdstat
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4] [raid10] 
md0 : active raid10 nvme1n1[1] nvme2n1[0]
      292836352 blocks super 1.2 2 near-copies [2/2] [UU]
      [========>............]  check = 40.3% (118270848/292836352) finish=14.4min speed=200963K/sec
      bitmap: 0/3 pages [0KB], 65536KB chunk

unused devices: <none>
# cat /sys/block/md0/md/mismatch_cnt
205324928

# cat /proc/mdstat
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4] [raid10] 
md0 : active raid10 nvme1n1[1] nvme2n1[0]
      292836352 blocks super 1.2 2 near-copies [2/2] [UU]
      bitmap: 0/3 pages [0KB], 65536KB chunk

unused devices: <none>
# cat /sys/block/md0/md/mismatch_cnt
205324928

Now, we need to take the raid10 array down, and perform a fsck on one disk at
a time:

# umount /mnt
# vgchange -a n /dev/VolGroup
  0 logical volume(s) in volume group "VolGroup" now active
# mdadm --stop /dev/md0
mdadm: stopped /dev/md0

Let's do first disk;

# mdadm --assemble /dev/md127 /dev/nvme1n1 
mdadm: /dev/md1 assembled from 1 drive - need all 2 to start it (use --run to insist).
# mdadm --run /dev/md127
mdadm: started array /dev/md/lv-raid
# vgchange -a y /dev/VolGroup
  1 logical volume(s) in volume group "VolGroup" now active
# fsck.ext4 -n -f /dev/VolGroup/root
e2fsck 1.44.1 (24-Mar-2018)
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
/dev/VolGroup/root: 11/6553600 files (0.0% non-contiguous), 557848/26214400 blocks
# vgchange -a n /dev/VolGroup
  0 logical volume(s) in volume group "VolGroup" now active
# mdadm --stop /dev/md127
mdadm: stopped /dev/md127

The second disk:

# mdadm --assemble /dev/md127 /dev/nvme2n1
mdadm: /dev/md1 assembled from 1 drive - need all 2 to start it (use --run to insist).
# mdadm --run /dev/md127
mdadm: started array /dev/md/lv-raid
# vgchange -a y /dev/VolGroup
  1 logical volume(s) in volume group "VolGroup" now active
# fsck.ext4 -n -f /dev/VolGroup/root
e2fsck 1.44.1 (24-Mar-2018)
Resize inode not valid.  Recreate? no

Pass 1: Checking inodes, blocks, and sizes
Inode 7 has illegal block(s).  Clear? no

Illegal indirect block (1714656753) in inode 7.  IGNORED.
Error while iterating over blocks in inode 7: Illegal indirect block found

/dev/VolGroup/root: ********** WARNING: Filesystem still has errors **********

e2fsck: aborted

/dev/VolGroup/root: ********** WARNING: Filesystem still has errors **********

# vgchange -a n /dev/VolGroup
  0 logical volume(s) in volume group "VolGroup" now active
# mdadm --stop /dev/md127
mdadm: stopped /dev/md127

There are no panics or anything in dmesg. The directory structure of the first
disk is intact, but the second disk only has Lost+Found present.

I can confirm it is the patches listed at the top of the email, but I have not
had an opportunity to bisect to find the exact root cause. I will do that once
we confirm what Ubuntu stable kernels are affected and begin reverting the
patches.

Let me know if you need any more details.

Thanks,
Matthew Ruffell
