Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B1A0C83018
	for <linux-raid@archiver.kernel.org>; Tue,  1 Dec 2020 09:16:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3212220671
	for <linux-raid@archiver.kernel.org>; Tue,  1 Dec 2020 09:16:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390143AbgLAJOZ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 1 Dec 2020 04:14:25 -0500
Received: from mail.thelounge.net ([91.118.73.15]:44613 "EHLO
        mail.thelounge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389632AbgLAJNu (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 1 Dec 2020 04:13:50 -0500
Received: from srv-rhsoft.rhsoft.net (rh.vpn.thelounge.net [10.10.10.2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-256) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: h.reindl@thelounge.net)
        by mail.thelounge.net (THELOUNGE MTA) with ESMTPSA id 4Clbwy3ZXLzXVk;
        Tue,  1 Dec 2020 10:13:01 +0100 (CET)
To:     buhtz@posteo.de, David T-G <davidtg-robot@justpickone.org>
Cc:     linux-raid@vger.kernel.org
References: <e6b7a61d16a25c433438c670fa4c0b4f@posteo.de>
 <20201130200503.GV1415@justpickone.org>
 <8fa1ae68716e406423039419f10ec219@posteo.de>
From:   Reindl Harald <h.reindl@thelounge.net>
Organization: the lounge interactive design
Subject: Re: partitions & filesystems (was "Re: ???root account locked???
 after removing one RAID1 hard disc")
Message-ID: <d5de4b8b-5fff-0937-7e90-30ca100cab15@thelounge.net>
Date:   Tue, 1 Dec 2020 10:13:01 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <8fa1ae68716e406423039419f10ec219@posteo.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



Am 01.12.20 um 09:41 schrieb buhtz@posteo.de:
> Dear David and others,
> 
> thanks a lot for so much discussion and details. I learn a lot.
> Following your discussions I see there still is some basic knowledge 
> missing on my side.
> 
> Am 30.11.2020 21:05 schrieb David T-G:
>> You don't see any "filesystem" or, more correctly, partition in your
>>
>>   fdisk -l
> 
> I do not see the partition in the output of "fdisk -l".
> 
> But I can (when both discs are present) mount /dev/md127 (manualy via 
> mount and via fstab) to /Daten and create files on it.
> 
>> So the display isn't interesting, although the logic behind that approach
>> certainly is to me.
> 
> I plugged in the nacked hard discs and they appear as /dev/sdb and 
> /dev/sdc. After that
>    mdadm --create /dev/md/md0 --level=1 --raid-devices=2 /dev/sdb /dev/sdc
> Then I did
>   ls -l /dev/md/md0 and found out this is just a link to /dev/md127.
> I formated the raid with
>   mkdfs.ext4 /dev/md127
> Then I mounted (first manually via mount and after sucess via fstab) 
> /dev/md127 to /Daten
> 
> Is this unusual?

that's normal, the RAID itself is a virtual device backed by the 
underlying disks

you can place a filesystem or even LVM on top of the RAID device and 
then place the filesystem on the LVM-device to combine the redundancy on 
the lower layer with the flexibility of LVM (but it would create another 
layer of complexity)

what i would normally recommend is not adding /dev/sda and /dev/sdb 
directly but create a partition with identical size (and some free space 
at the end) on both of them and add that partitions to the raid


[root@srv-rhsoft:~]$ df -hT
Filesystem     Type  Size  Used Avail Use% Mounted on
/dev/md1       ext4   29G  7.8G   21G  28% /
/dev/md2       ext4  3.6T  1.2T  2.4T  34% /mnt/data
/dev/md0       ext4  485M   48M  433M  10% /boot


[root@srv-rhsoft:~]$ cat /proc/mdstat
Personalities : [raid10] [raid1]
md1 : active raid10 sdc2[6] sdd2[5] sdb2[7] sda2[4]
       30716928 blocks super 1.1 256K chunks 2 near-copies [4/4] [UUUU]
       bitmap: 0/1 pages [0KB], 65536KB chunk

md2 : active raid10 sdd3[5] sdb3[7] sdc3[6] sda3[4]
       3875222528 blocks super 1.1 512K chunks 2 near-copies [4/4] [UUUU]
       bitmap: 6/29 pages [24KB], 65536KB chunk

md0 : active raid1 sdc1[6] sdd1[5] sdb1[7] sda1[4]
       511988 blocks super 1.0 [4/4] [UUUU]


[root@srv-rhsoft:~]$ fdisk -l /dev/sda
Disk /dev/sda: 1.84 TiB, 2000398934016 bytes, 3907029168 sectors
Disk model: Samsung SSD 860
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x000d9ef2

Device     Boot    Start        End    Sectors  Size Id Type
/dev/sda1  *        2048    1026047    1024000  500M fd Linux raid 
autodetect
/dev/sda2        1026048   31746047   30720000 14.7G fd Linux raid 
autodetect
/dev/sda3       31746048 3906971647 3875225600  1.8T fd Linux raid 
autodetect


[root@srv-rhsoft:~]$ fdisk -l /dev/sdb
Disk /dev/sdb: 1.84 TiB, 2000398934016 bytes, 3907029168 sectors
Disk model: Samsung SSD 860
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x000d9ef2

Device     Boot    Start        End    Sectors  Size Id Type
/dev/sdb1  *        2048    1026047    1024000  500M fd Linux raid 
autodetect
/dev/sdb2        1026048   31746047   30720000 14.7G fd Linux raid 
autodetect
/dev/sdb3       31746048 3906971647 3875225600  1.8T fd Linux raid 
autodetect


[root@srv-rhsoft:~]$ fdisk -l /dev/sdc
Disk /dev/sdc: 1.84 TiB, 2000398934016 bytes, 3907029168 sectors
Disk model: Samsung SSD 850
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x000d9ef2

Device     Boot    Start        End    Sectors  Size Id Type
/dev/sdc1  *        2048    1026047    1024000  500M fd Linux raid 
autodetect
/dev/sdc2        1026048   31746047   30720000 14.7G fd Linux raid 
autodetect
/dev/sdc3       31746048 3906971647 3875225600  1.8T fd Linux raid 
autodetect


[root@srv-rhsoft:~]$ fdisk -l /dev/sdd
Disk /dev/sdd: 1.84 TiB, 2000398934016 bytes, 3907029168 sectors
Disk model: Samsung SSD 850
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x000d9ef2

Device     Boot    Start        End    Sectors  Size Id Type
/dev/sdd1  *        2048    1026047    1024000  500M fd Linux raid 
autodetect
/dev/sdd2        1026048   31746047   30720000 14.7G fd Linux raid 
autodetect
/dev/sdd3       31746048 3906971647 3875225600  1.8T fd Linux raid 
autodetect


