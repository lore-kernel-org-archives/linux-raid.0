Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B8B2C77B73
	for <linux-raid@archiver.kernel.org>; Fri,  5 May 2023 01:34:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229535AbjEEBeX (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 4 May 2023 21:34:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjEEBeW (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 4 May 2023 21:34:22 -0400
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70A2111B47
        for <linux-raid@vger.kernel.org>; Thu,  4 May 2023 18:34:20 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.169])
        by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4QCCs32lhzz4f3mJH
        for <linux-raid@vger.kernel.org>; Fri,  5 May 2023 09:34:15 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
        by APP3 (Coremail) with SMTP id _Ch0CgBH9CEXXVRkcWtOIA--.23844S3;
        Fri, 05 May 2023 09:34:17 +0800 (CST)
Subject: Re: Raid5 to raid6 grow interrupted, mdadm hangs on assemble command
To:     Jove <jovetoo@gmail.com>, Yu Kuai <yukuai1@huaweicloud.com>
Cc:     linux-raid@vger.kernel.org, "yukuai (C)" <yukuai3@huawei.com>
References: <CAFig2csUV2QiomUhj_t3dPOgV300dbQ6XtM9ygKPdXJFSH__Nw@mail.gmail.com>
 <63d92097-5299-2ae8-9697-768c52678578@huaweicloud.com>
 <CAFig2ct4BJZ0A9BKuXn8RM71+KrUzB8vKGQY0fSjNZiNenQZBg@mail.gmail.com>
From:   Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <c71c8381-f26e-f7de-c6f5-3c4411f08b15@huaweicloud.com>
Date:   Fri, 5 May 2023 09:34:15 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CAFig2ct4BJZ0A9BKuXn8RM71+KrUzB8vKGQY0fSjNZiNenQZBg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: _Ch0CgBH9CEXXVRkcWtOIA--.23844S3
X-Coremail-Antispam: 1UD129KBjvJXoW3AFyrGF1xGw18GFW8GFykXwb_yoW7GFW5pa
        48t3WDKr4DJw4jka1vkr1I9FyrKFWUJrW3Ww1fGw13Aw1qgFnYyFyfJryjkryay34fCF4U
        XrWUX347G3Z8taDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUkC14x267AKxVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
        JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
        CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
        2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
        W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7I2V7IY0VAS07AlzVAY
        IcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14
        v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkG
        c2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI
        0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6rW3Jr0E3s1lIxAIcVC2z280aVAFwI0_Jr0_
        Gr1lIxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjfU5WlkUU
        UUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi,

在 2023/05/05 2:02, Jove 写道:
> Hi Kuai,
> 
> the madm --assemble command also hangs in the kernel. It never completes.
> 
> root         142     112  1 19:01 tty1     00:00:00 mdadm --assemble
> /dev/md0 /dev/ubdb /dev/ubdc /dev/ubdd /dev/ubde --backup-file
> mdadm_raid6_backup.md0 --invalid-backup
> root         145       2  0 19:01 ?        00:00:00 [md0_raid6]
> 
> [root@LXCNAME ~]# cat /proc/142/stack
> [<0>] __switch_to+0x50/0x7f
> [<0>] __schedule+0x39c/0x3dd
> [<0>] schedule+0x78/0xb9
> [<0>] mddev_suspend+0x10b/0x1e8
mddev_suspend is wait for read io to be done, while read io is waiting
for reshape to progress.

So this is just based on if there is a read io beyond reshape position
while mdadm is executed.

> [<0>] suspend_lo_store+0x72/0xbb
> [<0>] md_attr_store+0x6c/0x8d
> [<0>] sysfs_kf_write+0x34/0x37
> [<0>] kernfs_fop_write_iter+0x167/0x1d0
> [<0>] new_sync_write+0x68/0xd8
> [<0>] vfs_write+0xe7/0x12b
> [<0>] ksys_write+0x6d/0xa6
> [<0>] sys_write+0x10/0x12
> [<0>] handle_syscall+0x81/0xb1
> [<0>] userspace+0x3db/0x598
> [<0>] fork_handler+0x94/0x96
> 
> [root@LXCNAME ~]# cat /proc/145/stack
> [<0>] __switch_to+0x50/0x7f
> [<0>] __schedule+0x39c/0x3dd
> [<0>] schedule+0x78/0xb9
> [<0>] schedule_timeout+0xd2/0xfb
> [<0>] md_thread+0x12c/0x18a
> [<0>] kthread+0x11d/0x122
> [<0>] new_thread_handler+0x81/0xb2
> 
> I have had one case in which mdadm didn't hang and in which the
> reshape continued. Sadly, I was using sparse overlay files and the
> filesystem could not handle the full 4x 4TB. I had to terminate the
> reshape.

This sounds like a dead end for now, normal io beyond reshape position
must wait:

raid5_make_request
  make_stripe_request
   ahead_of_reshape
    wait_woken

Thanks,
Kuai
> 
> Best regards,
> 
>      Johan
> 
> On Thu, May 4, 2023 at 1:41 PM Yu Kuai <yukuai1@huaweicloud.com> wrote:
>>
>> Hi,
>>
>> 在 2023/04/24 3:09, Jove 写道:
>>> Hi,
>>>
>>> I've added two drives to my raid5 array and tried to migrate
>>> it to raid6 with the following command:
>>>
>>> mdadm --grow /dev/md0 --raid-devices 4 --level 6
>>> --backup-file=/root/mdadm_raid6_backup.md
>>>
>>> This may have been my first mistake, as there are only 5
>>> drives. it should have been --raid-devices 3, I think.
>>>
>>> As soon as I started this grow, the filesystems went
>>> unavailable. All processes trying to access files on it hung.
>>> I searched the web which said a reboot during a rebuild
>>> was not problematic if things shut down cleanly, so I
>>> rebooted. The reboot hung too. The drive activity
>>> continued so I let it run overnight. I did wake up to a
>>> rebooted system in emergency mode as it could not
>>> mount all the partitions on the raid array.
>>>
>>> The OS tried to reassemble the array and succeeded.
>>> However the udev processes that try to create the dev
>>> entries hang.
>>>
>>> I went back to Google and found out how i could reboot
>>> my system without this automatic assemble.
>>> I tried reassembling the array with:
>>>
>>> mdadm --verbose --assemble --backup-file mdadm_raid6_backup.md0 /dev/md0
>>>
>>> This failed with:
>>> No backup metadata on mdadm_raid6_backup.md0
>>> Failed to find final backup of critical section.
>>> Failed to restore critical section for reshape, sorry.
>>>
>>>    I tried again wtih:
>>>
>>> mdadm --verbose --assemble --backup-file mdadm_raid6_backup.md0
>>> --invalid-backup /dev/md0
>>>
>>> Rhis said in addition to the lines above:
>>>
>>> continuying without restoring backup
>>>
>>> This seemed to have succeeded in reassembling the
>>> array but it also hangs indefinitely.
>>>
>>> /proc/mdstat now shows:
>>>
>>> md0 : active (read-only) raid6 sdc1[0] sde[4](S) sdf[5] sdd1[3] sdg1[1]
>>>         7813771264 blocks super 1.2 level 6, 512k chunk, algorithm 18 [4/3] [UUU_]
>>>         bitmap: 1/30 pages [4KB], 65536KB chunk
>>
>> Read only can't continue reshape progress, see details in
>> md_check_recovery(), reshape can only start if md_is_rdwr(mddev) pass.
>> Do you know why this array is read-only?
>>
>>>
>>> Again the udev processes trying to access this device hung indefinitely
>>>
>>> Eventually, the kernel dumps this in my journal:
>>>
>>> Apr 23 19:17:22 atom kernel: task:systemd-udevd   state:D stack:    0
>>> pid: 8121 ppid:   706 flags:0x00000006
>>> Apr 23 19:17:22 atom kernel: Call Trace:
>>> Apr 23 19:17:22 atom kernel:  <TASK>
>>> Apr 23 19:17:22 atom kernel:  __schedule+0x20a/0x550
>>> Apr 23 19:17:22 atom kernel:  schedule+0x5a/0xc0
>>> Apr 23 19:17:22 atom kernel:  schedule_timeout+0x11f/0x160
>>> Apr 23 19:17:22 atom kernel:  ? make_stripe_request+0x284/0x490 [raid456]
>>> Apr 23 19:17:22 atom kernel:  wait_woken+0x50/0x70
>>
>> Looks like this normal io is waiting for reshape to be done, that's why
>> it hanged indefinitely.
>>
>> This really is a kernel bug, perhaps it can be bypassed if reshape can
>> be done, hopefully automatically if this array can be read/write. Noted
>> never echo reshape to sync_action, this will corrupt data in your case.
>>
>> Thanks,
>> Kuai
>>
> .
> 

