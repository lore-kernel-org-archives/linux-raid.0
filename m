Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96364C7EE21
	for <linux-raid@archiver.kernel.org>; Thu,  4 May 2023 09:44:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230398AbjEDJoS (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 4 May 2023 05:44:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230350AbjEDJoQ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 4 May 2023 05:44:16 -0400
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.126.134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05F653C39
        for <linux-raid@vger.kernel.org>; Thu,  4 May 2023 02:44:13 -0700 (PDT)
Received: from [192.168.100.1] ([94.134.214.237]) by mrelayeu.kundenserver.de
 (mreue011 [212.227.15.167]) with ESMTPSA (Nemesis) id
 1M2NqA-1pxF3h0XV8-003x7c; Thu, 04 May 2023 11:43:51 +0200
Message-ID: <d9c432de-5261-07be-93a5-fcac82cb2655@online.de>
Date:   Thu, 4 May 2023 11:43:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.10.0
Content-Language: de-DE, en-US
From:   Peter Neuwirth <reddunur@online.de>
To:     Yu Kuai <yukuai1@huaweicloud.com>, linux-raid@vger.kernel.org,
        "yukuai (C)" <yukuai3@huawei.com>
Subject: Re: linux mdadm assembly error: md: cannot handle concurrent
 replacement and reshape. (reboot while reshaping)
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:s6HwKlb7dbvLvWkjYDidnTD/nJarqUrMbP8kqzCwYzGC+NUIhVV
 2QMzlQpdrjgp/QFKNMTzDS7aiWL40+ZTRQH/L1C5MDQqRZDOk46HVqoPEK0kWvBxLBxeu7T
 SyDvYSMaQjy4Vy6JlMeX0ryDHJPkz88YTSLudFaAA1x+hLtMTwrJDT3sRCxn8QwGKUDdFtI
 pSHCP3qvEE3nVXdTsx9sw==
UI-OutboundReport: notjunk:1;M01:P0:bvThReUPVeQ=;gaFsfn3YpWYJhRIdojLTz+UOUjj
 Msaeo28IZDBnt/JtUmeY3OEyBiQmgUQFkvJ+bXZlwcCNCKYDxqW2gDBPiYyFtrrkNGYARYaOJ
 Jo2LV6QnB6QovtP0zGJOeaR903vVcy2u9Ldt88KVk3ajQhmlNro/T0f4ljvVcFp8OCooAwjsM
 jqYw1kZtgZXgRRcWCaAjKLGUta4Owb0qmg3VapHdAAcqq4/oN4d2+DK6p2wTszA6bzOjvyl0A
 FXpFYFvSErabK84WRzNnMVGj75oj9TMg7FdS081KH+A9e/TkF/DVdcG6LrhG5QIYwdlLFYsre
 rnG2zZ7XcGFh/34v4lcmTbVxT5ATji+L2g6jHmk433ylXqrNu3mckUuAlBuQJ+P0EFl9k6Z0c
 FVAHChhiI2ktT3QyLERB7PcIPizSNtT7uOa4LLMygOMbMe3pWgBlE1MkLHl0p6mXc3yKuBAs2
 PUVBzx0+0bw/TDqCoTmcEFdRBBljyUB0i0sTKka2aKbt4UROq+jrrNnNTF24g/rvhvxVn+XUK
 nWAU67/HcHNUfN/dHviewOUH591XVd35QSPjK43nhXjCoD7huPEG7F/7DYUa0tMgpZejwPISS
 /+s+5SdVsTk6qkrbfFHwu4+eZUzPEomR/9fNEHqMJROY/LbD36GbV6VX1izPy66Fqd718NK8r
 LHTKR0eDkpoYmYz55W91qrWo0/DFEjA3d04mzL1BlA==
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hello Kuai,

thank you for testing and reproducing this.
I have tried your recreate scenario, but mdadm will not do it due to
some busy devices or maybe the partition tables, that it found on the
hdds..

I started it in the same manner as the initial creation was.

srv11:~# mdadm  --create -f --verbose /dev/md0 -c 256K --level=5 --raid-devices=6  /dev/sde /dev/sdc /dev/sdb /dev/sda /dev/sdi /dev/sdj --assume-clean

mdadm: layout defaults to left-symmetric
mdadm: layout defaults to left-symmetric
mdadm: /dev/sde appears to be part of a raid array:
       level=raid6 devices=7 ctime=Mon Mar  6 18:17:30 2023
mdadm: partition table exists on /dev/sde but will be lost or
       meaningless after creating array
mdadm: /dev/sdc appears to be part of a raid array:
       level=raid6 devices=7 ctime=Mon Mar  6 18:17:30 2023
mdadm: partition table exists on /dev/sdc but will be lost or
       meaningless after creating array
mdadm: /dev/sdb appears to be part of a raid array:
       level=raid6 devices=7 ctime=Mon Mar  6 18:17:30 2023
mdadm: partition table exists on /dev/sdb but will be lost or
       meaningless after creating array
mdadm: super1.x cannot open /dev/sda: Device or resource busy
mdadm: /dev/sda is not suitable for this array.
mdadm: /dev/sdi appears to be part of a raid array:
       level=raid6 devices=7 ctime=Mon Mar  6 18:17:30 2023
mdadm: partition table exists on /dev/sdi but will be lost or
       meaningless after creating array
mdadm: /dev/sdj appears to be part of a raid array:
       level=raid6 devices=7 ctime=Mon Mar  6 18:17:30 2023
mdadm: partition table exists on /dev/sdj but will be lost or
       meaningless after creating array
mdadm: create aborted


Did you disable the device mapper, or have you any idea how to
stopping my drives being busy?

Not sure if it is related with this but I could remember, that after
first reboot, the raid was yet reported as raid5 but I naively reissued
the commands that, prior to reboot, started the whole process

 > mdadm --add /dev/md0 /dev/sdg /dev/sdh
 > sudo mdadm --grow /dev/md0 --level=6

and the grow simply aborted with notice that there is a growh ongoing,
but from there on I think the raid set was seen as raid6 in my system.

regards

Peter


Am 04.05.23 um 11:08 schrieb Yu Kuai:
> Hi,
>
> 在 2023/05/04 16:36, Peter Neuwirth 写道:
>> Thank you, Kuai!
>> So my gut instinct was not that bad. Now as I could reassemble my raid set (it tried to recontinue the rebuild, I stopped it)
>> I have a /dev/md0 but it seems that no sensible data is stored on it. Not even a partition table could be found.
>>
>>  From your investigations, what would you say : is there hope I could rescue some of the data from the raidset with a tool
>> like testdisk, when I "recreate" my old gpt partition table ? Or is it likely that the restarted reshape/grow process made
>> minced meat out of my whole raid data ?
>> It seemed interesting to me, that the first grow/shape process seemed to not even touch the two added discs, shown as
>> spare now, their partition tables had not been touched. The process seems to deal only with my legacy raid 5 set with
>> six plates and seemed to move it to a transient raid5/6 architecture, therefore operating atleast on the disc (3) of legacy
>> set, that is now missing..
>> I'm not sure, how much time to spend in this data is sensible,
>> your advice could be very helpful.
>
> During my test, I'm able to recreat the md0 and mount, but it's just for
> reference only...
>
> Test procedure:
> mdadm --create --run --verbose /dev/md0 -c 256K --level=5 --raid-devices=6  /dev/sd[abcdef] --size=100M
> mdadm -W /dev/md0
> mkfs.xfs -f /dev/md0
> echo 1024 > /sys/block/md0/md/sync_speed_max
>
> mdadm --add /dev/md0 /dev/sdg /dev/sdh
> sudo mdadm --grow /dev/md0 --level=6
> sleep 2
>
> echo frozen > /sys/block/md0/md/sync_action
>
> echo system > /sys/block/md0/md/sync_speed_max
> echo reshape > /sys/block/md0/md/sync_action
> mdadm -W /dev/md0
>
> xfs_repair -n /dev/md0
>
> Above test will reporduce that md0 is corrupted, and this is just
> because layout is changed. If I recreated md0 with original disks
> with --assume-clean, xfs_repair won't complain and mount will succeed:
>
> [root@fedora ~]# mdadm --create --run --verbose /dev/md0 -c 256K --level=5 --raid-devices=6  /dev/sd[abcdef] --size=100M --assume-clean
> mdadm: layout defaults to left-symmetric
> mdadm: layout defaults to left-symmetric
> mdadm: /dev/sda appears to contain an ext2fs file system
>        size=10485760K  mtime=Mon Apr  3 06:18:17 2023
> mdadm: /dev/sda appears to be part of a raid array:
>        level=raid5 devices=6 ctime=Thu May  4 09:00:08 2023
> mdadm: /dev/sdb appears to be part of a raid array:
>        level=raid5 devices=6 ctime=Thu May  4 09:00:08 2023
> mdadm: /dev/sdc appears to be part of a raid array:
>        level=raid5 devices=6 ctime=Thu May  4 09:00:08 2023
> mdadm: /dev/sdd appears to be part of a raid array:
>        level=raid5 devices=6 ctime=Thu May  4 09:00:08 2023
> mdadm: /dev/sde appears to be part of a raid array:
>        level=raid5 devices=6 ctime=Thu May  4 09:00:08 2023
> mdadm: /dev/sdf appears to be part of a raid array:
>        level=raid5 devices=6 ctime=Thu May  4 09:00:08 2023
> mdadm: largest drive (/dev/sda) exceeds size (102400K) by more than 1%
> mdadm: creation continuing despite oddities due to --run
> mdadm: Defaulting to version 1.2 metadata
> mdadm: array /dev/md0 started.
> [root@fedora ~]# xfs_repair -n /dev/md0
> Phase 1 - find and verify superblock...
>         - reporting progress in intervals of 15 minutes
> Phase 2 - using internal log
>         - zero log...
>         - 09:05:33: zeroing log - 4608 of 4608 blocks done
>         - scan filesystem freespace and inode maps...
>         - 09:05:33: scanning filesystem freespace - 8 of 8 allocation groups done
>         - found root inode chunk
> Phase 3 - for each AG...
>         - scan (but don't clear) agi unlinked lists...
>         - 09:05:33: scanning agi unlinked lists - 8 of 8 allocation groups done
>         - process known inodes and perform inode discovery...
>         - agno = 7
>         - agno = 0
>         - agno = 1
>         - agno = 2
>         - agno = 3
>         - agno = 4
>         - agno = 5
>         - agno = 6
>         - 09:05:33: process known inodes and inode discovery - 64 of 64 inodes done
>         - process newly discovered inodes...
>         - 09:05:33: process newly discovered inodes - 8 of 8 allocation groups done
> Phase 4 - check for duplicate blocks...
>         - setting up duplicate extent list...
>         - 09:05:33: setting up duplicate extent list - 8 of 8 allocation groups done
>         - check for inodes claiming duplicate blocks...
>         - agno = 0
>         - agno = 1
>         - agno = 6
>         - agno = 4
>         - agno = 3
>         - agno = 7
>         - agno = 2
>         - agno = 5
>         - 09:05:33: check for inodes claiming duplicate blocks - 64 of 64 inodes done
> No modify flag set, skipping phase 5
> Phase 6 - check inode connectivity...
>         - traversing filesystem ...
>         - traversal finished ...
>         - moving disconnected inodes to lost+found ...
> Phase 7 - verify link counts...
>         - 09:05:33: verify and correct link counts - 8 of 8 allocation groups done
> No modify flag set, skipping filesystem flush and exiting.
>
> Thanks,
> Kuai
>>
>> regards
>>
>> Peter
>>
>>
>> Am 04.05.23 um 10:16 schrieb Yu Kuai:
>>> Hi,
>>>
>>> 在 2023/04/28 5:09, Peter Neuwirth 写道:
>>>> Hello linux-raid group.
>>>>
>>>> I have an issue with my linux raid setup and I hope somebody here
>>>> could help me get my raid active again without data loss.
>>>>
>>>> I have a debian 11 system with one raid array (6x 1TB hdd drives, raid level 5 )
>>>> that was active running till today, when I added two more 1TB hdd drives
>>>> and also changed the raid level to 6.
>>>>
>>>> Note: For completition:
>>>>
>>>> My raid setup month ago was
>>>>
>>>> mdadm --create --verbose /dev/md0 -c 256K --level=5 --raid-devices=6  /dev/sdd /dev/sdc /dev/sdb /dev/sda /dev/sdg /dev/sdf
>>>>
>>>> mkfs.xfs -d su=254k,sw=6 -l version=2,su=256k -s size=4k /dev/md0
>>>>
>>>> mdadm --detail --scan | tee -a /etc/mdadm/mdadm.conf
>>>>
>>>> update-initramfs -u
>>>>
>>>> echo '/dev/md0 /mnt/data ext4 defaults,nofail,discard 0 0' | sudo tee -a /etc/fstab
>>>>
>>>>
>>>> Today I did:
>>>>
>>>> mdadm --add /dev/md0 /dev/sdg /dev/sdh
>>>>
>>>> sudo mdadm --grow /dev/md0 --level=6
>>>>
>>>>
>>>> This started a growth process, I could observe with
>>>> watch -n 1 cat /proc/mdstat
>>>> and md0 was still usable all the day.
>>>> Due to speedy file access reasons I paused the grow and insertion
>>>> process today at about 50% by issue
>>>>
>>>> echo "frozen" > /sys/block/md0/md/sync_action
>>>>
>>>>
>>>> After the file access was done, I restarted the
>>>> process with
>>>>
>>>> echo reshape > /sys/block/md0/md/sync_action
>>>>
>>> After look into this problem, I figure out that this is how the problem
>>> (corrupted data) triggered in the first place, while the problem that
>>> kernel log about "md: cannot handle concurrent replacement and reshape"
>>> is not fatal.
>>>
>>> "echo reshape" will restart the whole process, while recorded reshape
>>> position should be used. This is a seriously kernel bug, I'll try to fix
>>> this soon.
>>>
>>> By the way, "echo idle" should avoid this problem.
>>>
>>> Thanks,
>>> Kuai
>>>>
>>>> but I saw in mdstat that it started form the scratch.
>>>> After about 5 min I noticed, that /dev/dm0 mount was gone with
>>>> an input/output error in syslog and I rebooted the computer, to see the
>>>> kernel would reassemble dm0 correctly. Maybe the this was a problem,
>>>> because the dm0 was still reshaping, I do not know..
>>>
>>
>>
>> .
>>
>

