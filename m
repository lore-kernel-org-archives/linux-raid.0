Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26250C433DB
	for <linux-raid@archiver.kernel.org>; Sat,  2 Jan 2021 12:56:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E38CD224B0
	for <linux-raid@archiver.kernel.org>; Sat,  2 Jan 2021 12:56:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726552AbhABM4E (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 2 Jan 2021 07:56:04 -0500
Received: from mailrelay1-3.pub.mailoutpod1-cph3.one.com ([46.30.212.10]:39462
        "EHLO mailrelay1-3.pub.mailoutpod1-cph3.one.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726524AbhABM4D (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 2 Jan 2021 07:56:03 -0500
X-Greylist: delayed 1043 seconds by postgrey-1.27 at vger.kernel.org; Sat, 02 Jan 2021 07:56:01 EST
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gizzy.co.uk; s=20191106;
        h=content-transfer-encoding:content-type:mime-version:date:message-id:subject:
         from:to:from;
        bh=jmdIQMBZtmCI2IzbF+1drQxKJEhygz1qoCXXvYB53Xw=;
        b=QnyXmtPrhUZJ1FeIBoH06TmABBHsdsBQUXkrSb7+5/B64N3ok617x1dzHbJkBwINkj2U62ObWin4f
         LVEQGxe2ovIQUFVDkE8stwB5MIGinqUXd0IIzNr83Cp/ch5E0c/lmHgmYi/pSzwCNuRVJ/Nbdu6/QM
         Ec+XOjSk+TPgmIFB+tb41WYKfMLJx2kLObKPceFMBQ70uLNTGybf+gUm0u4UG3rstfoXyWdRzsNEmX
         BZTD8K+Ry+fHAuAgQs9AQPSeEniUPZvzRxkDhzuKXqxPX3VU6TuoEKlir9UVS+vuGf9hD+Z7GZyQS9
         i314rdnhBNIo/ElNXsqa/uRJ79TqzMQ==
X-HalOne-Cookie: 5ca0a54bdeb601eef645e52034dc78199f2ba975
X-HalOne-ID: 568de3f7-4cf7-11eb-923a-d0431ea8a283
Received: from [192.168.87.166] (host-92-14-94-8.as43234.net [92.14.94.8])
        by mailrelay1.pub.mailoutpod1-cph3.one.com (Halon) with ESMTPSA
        id 568de3f7-4cf7-11eb-923a-d0431ea8a283;
        Sat, 02 Jan 2021 12:37:56 +0000 (UTC)
To:     linux-raid@vger.kernel.org
From:   Teejay <teejay@gizzy.co.uk>
Subject: Raid working but stuck at 99.9%
Message-ID: <11a6cdb6-ab69-ec4d-8ffb-b92d80d5b03f@gizzy.co.uk>
Date:   Sat, 2 Jan 2021 12:37:55 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi,

Firstly I should say I am very new to RAID and this is my first post, so 
please forgive naive questions and woolly thinking!

I have been running a RAID 0 array on three 4TB drives for some time 
with no issue. However, I have always been a little concerned that I had 
no redundancy so I purchased another two drives, same type and size, 
with the plan of growing the array from 12TB to 16TB and introducing 
RAID5. What seemed like a good idea turned out to be a bit of a nightmare!

To upgrade the array I used the following command:

sudo mdadm --grow /dev/md0 --level=5 --raid-devices=5 --add /dev/sde 
/dev/sdf --backup-file=/tmp/grow_md0.bak

To my surprise it returned almost instantly with no errors. So I had a 
look at the status:

less /proc/mdstat

and it came back as being a raid 5 array and stated that it was reshape 
= 0.01% and would take several million minutes to complete! Somewhat 
concerned, I left it for half an hour and tried again only to find that 
the number of complete blocks was the same and the time had grown to an 
even more crazy number. It was clear the process had stalled.

I tried to stop the array and the command just hang. After some time I 
forced a power down and rebooted (could not figure what else to do!)

When the machine came back up, it did not assemble (as I had not updated 
the mdadm.conf so I ran the following:

lounge@lounge:~$ sudo blkid
[sudo] password for lounge:
/dev/sda1: UUID="314a0be6-e180-4dc3-8439-b5a84ee7f4a5" TYPE="ext4" 
PARTUUID="e01c24f7-01"
/dev/loop0: TYPE="squashfs"
/dev/loop1: TYPE="squashfs"
/dev/loop2: TYPE="squashfs"
/dev/loop3: TYPE="squashfs"
/dev/loop4: TYPE="squashfs"
/dev/loop5: TYPE="squashfs"
/dev/loop6: TYPE="squashfs"
/dev/loop7: TYPE="squashfs"
/dev/sdc: UUID="5e89b9c4-dbdd-62a9-6bcc-20e02f58cdd2" 
UUID_SUB="7b17180b-6db1-675b-d208-84d43a3eb154" LABEL="lounge:0" 
TYPE="linux_raid_member"
/dev/sdb: UUID="5e89b9c4-dbdd-62a9-6bcc-20e02f58cdd2" 
UUID_SUB="c36a1dcd-e199-0ca5-3a89-7e6b298c9240" LABEL="lounge:0" 
TYPE="linux_raid_member"
/dev/sdd: UUID="5e89b9c4-dbdd-62a9-6bcc-20e02f58cdd2" 
UUID_SUB="2dc33f33-e2de-4c7d-d5e2-6006640b4e38" LABEL="lounge:0" 
TYPE="linux_raid_member"
/dev/sde: UUID="5e89b9c4-dbdd-62a9-6bcc-20e02f58cdd2" 
UUID_SUB="a41557e2-f35b-8acb-0203-281cafd5c18e" LABEL="lounge:0" 
TYPE="linux_raid_member"
/dev/sdf: UUID="5e89b9c4-dbdd-62a9-6bcc-20e02f58cdd2" 
UUID_SUB="7951f3fc-d111-65ef-dc28-11befcdc4769" LABEL="lounge:0" 
TYPE="linux_raid_member"

I then modified my config file as follows:

ARRAY /dev/md/0  level=raid5 metadata=1.2 num-devices=5: 
UUID=5e89b9c4:dbdd62a9:6bcc20e0:2f58cdd2 name=lounge:0
    devices=/dev/sdb,/dev/sdc,/dev/sdd,/dev/sde,/dev/sdf
MAILADDR root

and the ran the assemble command

sudo mdadm --assemble --verbose /dev/md0

It assembled fine, but the same thing happened, the reshape hang, so I 
hit google. Anyway to cut a long story short (post a lot of googling) I 
have determined that the drives that I am using are the dreaded SMR and 
that is probably why it all locked up (I wish I had found the wiki first!!!)

so I figured I needed to abort the reshape and following some advice 
posted on some forum I tried:

sudo mdadm --assemble --update=revert-reshape /dev/md0

It told me it had done it but needed a backup file name so I tried:

sudo mdadm --assemble --verbose --backup-file=/tmp/reshape.backup /dev/md0

The situation I am now is the array will assemble, but with one drive 
missing (not sure why) and the reshape is stuck at 99.9%

Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] 
[raid4] [raid10]
md0 : active raid5 sdf[4] sdb[2] sdd[1] sdc[0]
       11720658432 blocks super 1.2 level 5, 512k chunk, algorithm 2 
[4/3] [UUU_]
       [===================>.]  reshape = 99.9% (3906632192/3906886144) 
finish=1480857.6min speed=0K/sec

unused devices: <none>

The good news is that if I mount the array (read only) it seems to be 
intact, I tried watching a movie and it seems good. Also fsck reports 
that the filesystem is clean. I have not had the courage to force a full 
check as I do not wish to write anything to it while it is in this state.

This is the output of  sudo mdadm -D /dev/md0
/dev/md0:
            Version : 1.2
      Creation Time : Sun Aug 16 16:43:19 2020
         Raid Level : raid5
         Array Size : 11720658432 (11177.69 GiB 12001.95 GB)
      Used Dev Size : 3906886144 (3725.90 GiB 4000.65 GB)
       Raid Devices : 4
      Total Devices : 4
        Persistence : Superblock is persistent

        Update Time : Sat Jan  2 11:48:45 2021
              State : clean, degraded, reshaping
     Active Devices : 4
    Working Devices : 4
     Failed Devices : 0
      Spare Devices : 0

             Layout : left-symmetric
         Chunk Size : 512K

Consistency Policy : resync

     Reshape Status : 99% complete
      Delta Devices : -1, (5->4)
         New Layout : parity-last

               Name : lounge:0  (local to host lounge)
               UUID : 5e89b9c4:dbdd62a9:6bcc20e0:2f58cdd2
             Events : 876

     Number   Major   Minor   RaidDevice State
        0       8       32        0      active sync /dev/sdc
        1       8       48        1      active sync /dev/sdd
        2       8       16        2      active sync /dev/sdb
        -       0        0        3      removed

        4       8       80        4      active sync /dev/sdf


so it looks like it attempting to become a RAID 4 array (parity-last?) 
and had got stuck. It is not hung just in this state of limbo.

I am not sure what I can do. It would seem my drives are not any good 
for RAID, although everything seemed fine while at level 0 since the 
offset (Maybe I got lucky). I need to somehow get back to a useful 
state. If I could get back to level 0 with three drives that would be 
great. I could then delete some junk and then backup the data the other 
two drives using rsync or something.

So I guess my questions are

1 - Can I safely get back to a three drive level 0 RAID thereby freeing 
the two drives I added to allow me to make a backup of the data?
2 - Even if I can revert, should I move my data and no longer even use 
RAID 0 until I can get some decent hard drives?
3 - Any other cunning ideas, at the moment I think my only option, if I 
can't revert, which is to buy many TB's of storage to back up the read 
only file system, which I can ill afford to do!

Any advice would be great. Where I am now, I think my data is safe-ish 
(baring a drive failure!). I just need to make it safer the best way 
possible, while not valuable, it will take many hundreds of hours to 
rebuild from scratch. I also need to end up with a system I can write 
too and trust.

Regards


TeeJay




