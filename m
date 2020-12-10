Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17FDFC4361B
	for <linux-raid@archiver.kernel.org>; Thu, 10 Dec 2020 01:38:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CC03D23BE5
	for <linux-raid@archiver.kernel.org>; Thu, 10 Dec 2020 01:38:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726162AbgLJBhX (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 9 Dec 2020 20:37:23 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:39835 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725829AbgLJBhX (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 9 Dec 2020 20:37:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607564156;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fJ91IrOn62+1TtRC9bPcseBt+zy20zXjbZevUvoS6S0=;
        b=aX0IoP1Lh7VbvvAsb3kE2iMW6nVmV1AjHYaruO3qWj2pKaqoIvv8J0zOeUaOgFCHthoR6+
        D2zKzw+dFzoL0vdRPqCCPicppM99/yaiZQTf1zmiWaJDSwHJz2pnapEIDQZ3uI3saZPwqZ
        TpVlIpHybs3JiHrEQ/sO1iuSaLJXWEM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-470-SnyL43vmOxCma51YwBAk_A-1; Wed, 09 Dec 2020 20:35:51 -0500
X-MC-Unique: SnyL43vmOxCma51YwBAk_A-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0F76059;
        Thu, 10 Dec 2020 01:35:50 +0000 (UTC)
Received: from localhost.localdomain (ovpn-8-22.pek2.redhat.com [10.72.8.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9994F5C1D1;
        Thu, 10 Dec 2020 01:35:44 +0000 (UTC)
Subject: Re: PROBLEM: Recent raid10 block discard patchset causes filesystem
 corruption on fstrim
To:     Song Liu <songliubraving@fb.com>,
        Matthew Ruffell <matthew.ruffell@canonical.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>,
        Song Liu <song@kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, Coly Li <colyli@suse.de>,
        Guoqing Jiang <guoqing.jiang@cloud.ionos.com>,
        "khalid.elmously@canonical.com" <khalid.elmously@canonical.com>,
        Jay Vosburgh <jay.vosburgh@canonical.com>
References: <dbd2761e-cd7d-d60a-f769-ecc8c6335814@canonical.com>
 <EA47EF7A-06D8-4B37-BED7-F04753D70DF5@fb.com>
From:   Xiao Ni <xni@redhat.com>
Message-ID: <a8e1db0b-5785-f80f-33ae-f68de22e1525@redhat.com>
Date:   Thu, 10 Dec 2020 09:35:42 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
In-Reply-To: <EA47EF7A-06D8-4B37-BED7-F04753D70DF5@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 12/09/2020 12:17 PM, Song Liu wrote:
> Hi Matthew,
>
>> On Dec 8, 2020, at 7:46 PM, Matthew Ruffell <matthew.ruffell@canonical.com> wrote:
>>
>> Hello,
>>
>> I recently backported the following patches into the Ubuntu stable kernels:
>>
>> md: add md_submit_discard_bio() for submitting discard bio
>> md/raid10: extend r10bio devs to raid disks
>> md/raid10: pull codes that wait for blocked dev into one function
>> md/raid10: improve raid10 discard request
>> md/raid10: improve discard request for far layout
>> dm raid: fix discard limits for raid1 and raid10
>> dm raid: remove unnecessary discard limits for raid10
> Thanks for the report!
>
> Hi Xiao,
>
> Could you please take a look at this and let me know soon? We need to fix
> this before 5.10 official release.
>
> Thanks,
> Song

Hi all

Sorry for the trouble. But I'm in pto with no test machines. I'll have a 
look at this problem
next week.
>
>> and this morning, a user reported the following downstream bug:
>>
>> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1907262/
>>
>> Their weekly cronjob that runs fstrim had run, and their raid10 array has
>> extensive data corruption.
>>
>> The issue is reproducible on the latest 5.10-rc7 mainline kernel, steps are
>> below.
>>
>> I used a m5d.4xlarge instance on AWS to ultilise 2x 300GB SSDs that support
>> block discard. You will want to select small disks to lower the time needed
>> to reproduce.
>>
>> $ uname -rv
>> 5.10.0-rc7+ #1 SMP Wed Dec 9 01:15:27 UTC 2020
>>
>> Create a raid10 array, with LVM:
>>
>> $ lsblk
>> NAME        MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
>> nvme0n1     259:0    0     8G  0 disk
>> └─nvme0n1p1 259:1    0     8G  0 part /
>> nvme1n1     259:2    0 279.4G  0 disk
>> nvme2n1     259:3    0 279.4G  0 disk
>>
>> $ sudo -s
>> # mdadm -C -v -l10 -n2 -N "lv-raid" -R /dev/md0 /dev/nvme1n1 /dev/nvme2n1
>> mdadm: layout defaults to n2
>> mdadm: layout defaults to n2
>> mdadm: chunk size defaults to 512K
>> mdadm: size set to 292836352K
>> mdadm: automatically enabling write-intent bitmap on large array
>> mdadm: Defaulting to version 1.2 metadata
>> mdadm: array /dev/md0 started.
>> # pvcreate -ff -y /dev/md0
>>   Physical volume "/dev/md0" successfully created.
>> # vgcreate -f -y VolGroup /dev/md0
>>   Volume group "VolGroup" successfully created
>> # lvcreate -n root -L 100G -ay -y VolGroup
>>   Logical volume "root" created.
>> # mkfs.ext4 /dev/VolGroup/root
>> mke2fs 1.44.1 (24-Mar-2018)
>> Discarding device blocks: done
>> Creating filesystem with 26214400 4k blocks and 6553600 inodes
>> Filesystem UUID: d7be2e14-fa4d-4489-884b-3bef63b1e1db
>> Superblock backups stored on blocks:
>> 	32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632, 2654208,
>> 	4096000, 7962624, 11239424, 20480000, 23887872
>>
>> Allocating group tables: done
>> Writing inode tables: done
>> Creating journal (131072 blocks): done
>> Writing superblocks and filesystem accounting information: done
>> # mount /dev/VolGroup/root /mnt
>>
>> Next, wait for the disk check to complete, 25 minutes on m5d.4xlarge instance.
>>
>> # cat /proc/mdstat
>> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4] [raid10]
>> md0 : active raid10 nvme2n1[1] nvme1n1[0]
>>       292836352 blocks super 1.2 2 near-copies [2/2] [UU]
>>       [==>..................]  resync = 12.0% (35211392/292836352) finish=21.4min speed=200340K/sec
>>       bitmap: 3/3 pages [12KB], 65536KB chunk
>>
>> unused devices: <none>
>> # cat /sys/block/md0/md/mismatch_cnt
>> 76918016
>>
>> # cat /proc/mdstat
>> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4] [raid10]
>> md0 : active raid10 nvme2n1[1] nvme1n1[0]
>>       292836352 blocks super 1.2 2 near-copies [2/2] [UU]
>>       bitmap: 0/3 pages [0KB], 65536KB chunk
>>
>> unused devices: <none>
>> # cat /sys/block/md0/md/mismatch_cnt
>> 582330240
>>
>> Now that the check is complete, create a file, sync and delete it:
>>
>> # dd if=/dev/zero of=/mnt/data.raw bs=4K count=1M
>> 1048576+0 records in
>> 1048576+0 records out
>> 4294967296 bytes (4.3 GB, 4.0 GiB) copied, 3.95974 s, 1.1 GB/s
>> # sync
>> # rm /mnt/data.raw
>>
>> Perform a check:
>>
>> # echo check > /sys/block/md0/md/sync_action
>>
>> Again, wait 25 minutes for it to complete:
>>
>> # cat /proc/mdstat
>> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4] [raid10]
>> md0 : active raid10 nvme1n1[1] nvme2n1[0]
>>       292836352 blocks super 1.2 2 near-copies [2/2] [UU]
>>       [==>..................]  check = 13.7% (40356224/292836352) finish=20.8min speed=201707K/sec
>>       bitmap: 0/3 pages [0KB], 65536KB chunk
>>
>> unused devices: <none>
>> # cat /sys/block/md0/md/mismatch_cnt
>> 1469696
>>
>> # cat /proc/mdstat
>> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4] [raid10]
>> md0 : active raid10 nvme1n1[1] nvme2n1[0]
>>       292836352 blocks super 1.2 2 near-copies [2/2] [UU]
>>       bitmap: 0/3 pages [0KB], 65536KB chunk
>>
>> unused devices: <none>
>> # cat /sys/block/md0/md/mismatch_cnt
>> 1469696
>>
>> Now, perform the fstrim:
>>
>> # fstrim /mnt --verbose
>> /mnt: 97.9 GiB (105089236992 bytes) trimmed
>>
>> Go for another check:
>>
>> # echo check >/sys/block/md0/md/sync_action
>> # cat /proc/mdstat
>> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4] [raid10]
>> md0 : active raid10 nvme1n1[1] nvme2n1[0]
>>       292836352 blocks super 1.2 2 near-copies [2/2] [UU]
>>       [========>............]  check = 40.3% (118270848/292836352) finish=14.4min speed=200963K/sec
>>       bitmap: 0/3 pages [0KB], 65536KB chunk
>>
>> unused devices: <none>
>> # cat /sys/block/md0/md/mismatch_cnt
>> 205324928
>>
>> # cat /proc/mdstat
>> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4] [raid10]
>> md0 : active raid10 nvme1n1[1] nvme2n1[0]
>>       292836352 blocks super 1.2 2 near-copies [2/2] [UU]
>>       bitmap: 0/3 pages [0KB], 65536KB chunk
>>
>> unused devices: <none>
>> # cat /sys/block/md0/md/mismatch_cnt
>> 205324928
>>
>> Now, we need to take the raid10 array down, and perform a fsck on one disk at
>> a time:
>>
>> # umount /mnt
>> # vgchange -a n /dev/VolGroup
>>   0 logical volume(s) in volume group "VolGroup" now active
>> # mdadm --stop /dev/md0
>> mdadm: stopped /dev/md0
>>
>> Let's do first disk;
>>
>> # mdadm --assemble /dev/md127 /dev/nvme1n1
>> mdadm: /dev/md1 assembled from 1 drive - need all 2 to start it (use --run to insist).
>> # mdadm --run /dev/md127
>> mdadm: started array /dev/md/lv-raid
>> # vgchange -a y /dev/VolGroup
>>   1 logical volume(s) in volume group "VolGroup" now active
>> # fsck.ext4 -n -f /dev/VolGroup/root
>> e2fsck 1.44.1 (24-Mar-2018)
>> Pass 1: Checking inodes, blocks, and sizes
>> Pass 2: Checking directory structure
>> Pass 3: Checking directory connectivity
>> Pass 4: Checking reference counts
>> Pass 5: Checking group summary information
>> /dev/VolGroup/root: 11/6553600 files (0.0% non-contiguous), 557848/26214400 blocks
>> # vgchange -a n /dev/VolGroup
>>   0 logical volume(s) in volume group "VolGroup" now active
>> # mdadm --stop /dev/md127
>> mdadm: stopped /dev/md127
>>
>> The second disk:
>>
>> # mdadm --assemble /dev/md127 /dev/nvme2n1
>> mdadm: /dev/md1 assembled from 1 drive - need all 2 to start it (use --run to insist).
>> # mdadm --run /dev/md127
>> mdadm: started array /dev/md/lv-raid
>> # vgchange -a y /dev/VolGroup
>>   1 logical volume(s) in volume group "VolGroup" now active
>> # fsck.ext4 -n -f /dev/VolGroup/root
>> e2fsck 1.44.1 (24-Mar-2018)
>> Resize inode not valid.  Recreate? no
>>
>> Pass 1: Checking inodes, blocks, and sizes
>> Inode 7 has illegal block(s).  Clear? no
>>
>> Illegal indirect block (1714656753) in inode 7.  IGNORED.
>> Error while iterating over blocks in inode 7: Illegal indirect block found
>>
>> /dev/VolGroup/root: ********** WARNING: Filesystem still has errors **********
>>
>> e2fsck: aborted
>>
>> /dev/VolGroup/root: ********** WARNING: Filesystem still has errors **********
>>
>> # vgchange -a n /dev/VolGroup
>>   0 logical volume(s) in volume group "VolGroup" now active
>> # mdadm --stop /dev/md127
>> mdadm: stopped /dev/md127
>>
>> There are no panics or anything in dmesg. The directory structure of the first
>> disk is intact, but the second disk only has Lost+Found present.
>>
>> I can confirm it is the patches listed at the top of the email, but I have not
>> had an opportunity to bisect to find the exact root cause. I will do that once
>> we confirm what Ubuntu stable kernels are affected and begin reverting the
>> patches.
>>
>> Let me know if you need any more details.
>>
>> Thanks,
>> Matthew Ruffell

