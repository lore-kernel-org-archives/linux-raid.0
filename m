Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E218AC7EE21
	for <linux-raid@archiver.kernel.org>; Thu,  4 May 2023 09:08:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229914AbjEDJIT (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 4 May 2023 05:08:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229607AbjEDJIS (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 4 May 2023 05:08:18 -0400
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E03BBD7
        for <linux-raid@vger.kernel.org>; Thu,  4 May 2023 02:08:16 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.153])
        by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4QBnzJ03tTz4f3ppm
        for <linux-raid@vger.kernel.org>; Thu,  4 May 2023 17:08:12 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
        by APP4 (Coremail) with SMTP id gCh0CgCnD7P8dVNkjeXuIg--.7602S3;
        Thu, 04 May 2023 17:08:13 +0800 (CST)
Subject: Re: linux mdadm assembly error: md: cannot handle concurrent
 replacement and reshape. (reboot while reshaping)
To:     Peter Neuwirth <reddunur@online.de>,
        Yu Kuai <yukuai1@huaweicloud.com>, linux-raid@vger.kernel.org,
        "yukuai (C)" <yukuai3@huawei.com>
References: <4051438a-e476-061d-a635-06671996b90b@online.de>
From:   Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <30ec46a1-dda8-b507-1e16-bbc3549e6030@huaweicloud.com>
Date:   Thu, 4 May 2023 17:08:12 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <4051438a-e476-061d-a635-06671996b90b@online.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: gCh0CgCnD7P8dVNkjeXuIg--.7602S3
X-Coremail-Antispam: 1UD129KBjvJXoWxKrykurWUXF43trWrJF1fJFb_yoWxur45pa
        y7GFy5Kr4kWw1Sk34vvw1xWFyrKFy8XrZ8Wr15Gryjyws09r1SvryftF45WF4UKr1F9w4j
        vr1rJ3y7CFn09aDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUkE14x267AKxVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
        JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
        CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
        2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
        W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7I2V7IY0VAS07AlzVAY
        IcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14
        v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkG
        c2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI
        0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6rWUJVWrZr1UMIIF0xvEx4A2jsIE14v26r1j
        6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUywZ
        7UUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi,

在 2023/05/04 16:36, Peter Neuwirth 写道:
> Thank you, Kuai!
> So my gut instinct was not that bad. Now as I could reassemble my raid 
> set (it tried to recontinue the rebuild, I stopped it)
> I have a /dev/md0 but it seems that no sensible data is stored on it. 
> Not even a partition table could be found.
> 
>  From your investigations, what would you say : is there hope I could 
> rescue some of the data from the raidset with a tool
> like testdisk, when I "recreate" my old gpt partition table ? Or is it 
> likely that the restarted reshape/grow process made
> minced meat out of my whole raid data ?
> It seemed interesting to me, that the first grow/shape process seemed to 
> not even touch the two added discs, shown as
> spare now, their partition tables had not been touched. The process 
> seems to deal only with my legacy raid 5 set with
> six plates and seemed to move it to a transient raid5/6 architecture, 
> therefore operating atleast on the disc (3) of legacy
> set, that is now missing..
> I'm not sure, how much time to spend in this data is sensible,
> your advice could be very helpful.

During my test, I'm able to recreat the md0 and mount, but it's just for
reference only...

Test procedure:
mdadm --create --run --verbose /dev/md0 -c 256K --level=5 
--raid-devices=6  /dev/sd[abcdef] --size=100M
mdadm -W /dev/md0
mkfs.xfs -f /dev/md0
echo 1024 > /sys/block/md0/md/sync_speed_max

mdadm --add /dev/md0 /dev/sdg /dev/sdh
sudo mdadm --grow /dev/md0 --level=6
sleep 2

echo frozen > /sys/block/md0/md/sync_action

echo system > /sys/block/md0/md/sync_speed_max
echo reshape > /sys/block/md0/md/sync_action
mdadm -W /dev/md0

xfs_repair -n /dev/md0

Above test will reporduce that md0 is corrupted, and this is just
because layout is changed. If I recreated md0 with original disks
with --assume-clean, xfs_repair won't complain and mount will succeed:

[root@fedora ~]# mdadm --create --run --verbose /dev/md0 -c 256K 
--level=5 --raid-devices=6  /dev/sd[abcdef] --size=100M --assume-clean
mdadm: layout defaults to left-symmetric
mdadm: layout defaults to left-symmetric
mdadm: /dev/sda appears to contain an ext2fs file system
        size=10485760K  mtime=Mon Apr  3 06:18:17 2023
mdadm: /dev/sda appears to be part of a raid array:
        level=raid5 devices=6 ctime=Thu May  4 09:00:08 2023
mdadm: /dev/sdb appears to be part of a raid array:
        level=raid5 devices=6 ctime=Thu May  4 09:00:08 2023
mdadm: /dev/sdc appears to be part of a raid array:
        level=raid5 devices=6 ctime=Thu May  4 09:00:08 2023
mdadm: /dev/sdd appears to be part of a raid array:
        level=raid5 devices=6 ctime=Thu May  4 09:00:08 2023
mdadm: /dev/sde appears to be part of a raid array:
        level=raid5 devices=6 ctime=Thu May  4 09:00:08 2023
mdadm: /dev/sdf appears to be part of a raid array:
        level=raid5 devices=6 ctime=Thu May  4 09:00:08 2023
mdadm: largest drive (/dev/sda) exceeds size (102400K) by more than 1%
mdadm: creation continuing despite oddities due to --run
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md0 started.
[root@fedora ~]# xfs_repair -n /dev/md0
Phase 1 - find and verify superblock...
         - reporting progress in intervals of 15 minutes
Phase 2 - using internal log
         - zero log...
         - 09:05:33: zeroing log - 4608 of 4608 blocks done
         - scan filesystem freespace and inode maps...
         - 09:05:33: scanning filesystem freespace - 8 of 8 allocation 
groups done
         - found root inode chunk
Phase 3 - for each AG...
         - scan (but don't clear) agi unlinked lists...
         - 09:05:33: scanning agi unlinked lists - 8 of 8 allocation 
groups done
         - process known inodes and perform inode discovery...
         - agno = 7
         - agno = 0
         - agno = 1
         - agno = 2
         - agno = 3
         - agno = 4
         - agno = 5
         - agno = 6
         - 09:05:33: process known inodes and inode discovery - 64 of 64 
inodes done
         - process newly discovered inodes...
         - 09:05:33: process newly discovered inodes - 8 of 8 allocation 
groups done
Phase 4 - check for duplicate blocks...
         - setting up duplicate extent list...
         - 09:05:33: setting up duplicate extent list - 8 of 8 
allocation groups done
         - check for inodes claiming duplicate blocks...
         - agno = 0
         - agno = 1
         - agno = 6
         - agno = 4
         - agno = 3
         - agno = 7
         - agno = 2
         - agno = 5
         - 09:05:33: check for inodes claiming duplicate blocks - 64 of 
64 inodes done
No modify flag set, skipping phase 5
Phase 6 - check inode connectivity...
         - traversing filesystem ...
         - traversal finished ...
         - moving disconnected inodes to lost+found ...
Phase 7 - verify link counts...
         - 09:05:33: verify and correct link counts - 8 of 8 allocation 
groups done
No modify flag set, skipping filesystem flush and exiting.

Thanks,
Kuai
> 
> regards
> 
> Peter
> 
> 
> Am 04.05.23 um 10:16 schrieb Yu Kuai:
>> Hi,
>>
>> 在 2023/04/28 5:09, Peter Neuwirth 写道:
>>> Hello linux-raid group.
>>>
>>> I have an issue with my linux raid setup and I hope somebody here
>>> could help me get my raid active again without data loss.
>>>
>>> I have a debian 11 system with one raid array (6x 1TB hdd drives, 
>>> raid level 5 )
>>> that was active running till today, when I added two more 1TB hdd drives
>>> and also changed the raid level to 6.
>>>
>>> Note: For completition:
>>>
>>> My raid setup month ago was
>>>
>>> mdadm --create --verbose /dev/md0 -c 256K --level=5 --raid-devices=6  
>>> /dev/sdd /dev/sdc /dev/sdb /dev/sda /dev/sdg /dev/sdf
>>>
>>> mkfs.xfs -d su=254k,sw=6 -l version=2,su=256k -s size=4k /dev/md0
>>>
>>> mdadm --detail --scan | tee -a /etc/mdadm/mdadm.conf
>>>
>>> update-initramfs -u
>>>
>>> echo '/dev/md0 /mnt/data ext4 defaults,nofail,discard 0 0' | sudo tee 
>>> -a /etc/fstab
>>>
>>>
>>> Today I did:
>>>
>>> mdadm --add /dev/md0 /dev/sdg /dev/sdh
>>>
>>> sudo mdadm --grow /dev/md0 --level=6
>>>
>>>
>>> This started a growth process, I could observe with
>>> watch -n 1 cat /proc/mdstat
>>> and md0 was still usable all the day.
>>> Due to speedy file access reasons I paused the grow and insertion
>>> process today at about 50% by issue
>>>
>>> echo "frozen" > /sys/block/md0/md/sync_action
>>>
>>>
>>> After the file access was done, I restarted the
>>> process with
>>>
>>> echo reshape > /sys/block/md0/md/sync_action
>>>
>> After look into this problem, I figure out that this is how the problem
>> (corrupted data) triggered in the first place, while the problem that
>> kernel log about "md: cannot handle concurrent replacement and reshape"
>> is not fatal.
>>
>> "echo reshape" will restart the whole process, while recorded reshape
>> position should be used. This is a seriously kernel bug, I'll try to fix
>> this soon.
>>
>> By the way, "echo idle" should avoid this problem.
>>
>> Thanks,
>> Kuai
>>>
>>> but I saw in mdstat that it started form the scratch.
>>> After about 5 min I noticed, that /dev/dm0 mount was gone with
>>> an input/output error in syslog and I rebooted the computer, to see the
>>> kernel would reassemble dm0 correctly. Maybe the this was a problem,
>>> because the dm0 was still reshaping, I do not know..
>>
> 
> 
> .
> 

