Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 845E2C77B78
	for <linux-raid@archiver.kernel.org>; Thu,  4 May 2023 11:41:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230064AbjEDLlc (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 4 May 2023 07:41:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229873AbjEDLlb (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 4 May 2023 07:41:31 -0400
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D6B619A
        for <linux-raid@vger.kernel.org>; Thu,  4 May 2023 04:41:26 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.143])
        by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4QBsN12ltNz4f3nQc
        for <linux-raid@vger.kernel.org>; Thu,  4 May 2023 19:41:21 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
        by APP4 (Coremail) with SMTP id gCh0CgCnD7PhmVNk6372Ig--.17559S3;
        Thu, 04 May 2023 19:41:23 +0800 (CST)
Subject: Re: Raid5 to raid6 grow interrupted, mdadm hangs on assemble command
To:     Jove <jovetoo@gmail.com>, linux-raid@vger.kernel.org
References: <CAFig2csUV2QiomUhj_t3dPOgV300dbQ6XtM9ygKPdXJFSH__Nw@mail.gmail.com>
From:   Yu Kuai <yukuai1@huaweicloud.com>
Cc:     "yukuai (C)" <yukuai3@huawei.com>
Message-ID: <63d92097-5299-2ae8-9697-768c52678578@huaweicloud.com>
Date:   Thu, 4 May 2023 19:41:21 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CAFig2csUV2QiomUhj_t3dPOgV300dbQ6XtM9ygKPdXJFSH__Nw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: gCh0CgCnD7PhmVNk6372Ig--.17559S3
X-Coremail-Antispam: 1UD129KBjvJXoWxAr45CFy3KrWDury8KFWDtwb_yoW5AF4kp3
        y8GFn8K3ykJw40ka4kGryxWa4fCrWUAFW3Ga13G3WrAw4q9Fn2va4fGry5ta42yrZa9r4j
        qFW5ury3Kas5taDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUyKb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k2
        6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
        vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7Cj
        xVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxV
        AFwI0_GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2
        j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7x
        kEbVWUJVW8JwACjcxG0xvEwIxGrwCYjI0SjxkI62AI1cAE67vIY487MxAIw28IcxkI7VAK
        I48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7
        xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUXVWUAwCIc40Y0x0EwIxGrwCI42IY6xII
        jxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw2
        0EY4v20xvaj40_WFyUJVCq3wCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF
        7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUzsqWUUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi,

在 2023/04/24 3:09, Jove 写道:
> Hi,
> 
> I've added two drives to my raid5 array and tried to migrate
> it to raid6 with the following command:
> 
> mdadm --grow /dev/md0 --raid-devices 4 --level 6
> --backup-file=/root/mdadm_raid6_backup.md
> 
> This may have been my first mistake, as there are only 5
> drives. it should have been --raid-devices 3, I think.
> 
> As soon as I started this grow, the filesystems went
> unavailable. All processes trying to access files on it hung.
> I searched the web which said a reboot during a rebuild
> was not problematic if things shut down cleanly, so I
> rebooted. The reboot hung too. The drive activity
> continued so I let it run overnight. I did wake up to a
> rebooted system in emergency mode as it could not
> mount all the partitions on the raid array.
> 
> The OS tried to reassemble the array and succeeded.
> However the udev processes that try to create the dev
> entries hang.
> 
> I went back to Google and found out how i could reboot
> my system without this automatic assemble.
> I tried reassembling the array with:
> 
> mdadm --verbose --assemble --backup-file mdadm_raid6_backup.md0 /dev/md0
> 
> This failed with:
> No backup metadata on mdadm_raid6_backup.md0
> Failed to find final backup of critical section.
> Failed to restore critical section for reshape, sorry.
> 
>   I tried again wtih:
> 
> mdadm --verbose --assemble --backup-file mdadm_raid6_backup.md0
> --invalid-backup /dev/md0
> 
> Rhis said in addition to the lines above:
> 
> continuying without restoring backup
> 
> This seemed to have succeeded in reassembling the
> array but it also hangs indefinitely.
> 
> /proc/mdstat now shows:
> 
> md0 : active (read-only) raid6 sdc1[0] sde[4](S) sdf[5] sdd1[3] sdg1[1]
>        7813771264 blocks super 1.2 level 6, 512k chunk, algorithm 18 [4/3] [UUU_]
>        bitmap: 1/30 pages [4KB], 65536KB chunk

Read only can't continue reshape progress, see details in
md_check_recovery(), reshape can only start if md_is_rdwr(mddev) pass.
Do you know why this array is read-only?

> 
> Again the udev processes trying to access this device hung indefinitely
> 
> Eventually, the kernel dumps this in my journal:
> 
> Apr 23 19:17:22 atom kernel: task:systemd-udevd   state:D stack:    0
> pid: 8121 ppid:   706 flags:0x00000006
> Apr 23 19:17:22 atom kernel: Call Trace:
> Apr 23 19:17:22 atom kernel:  <TASK>
> Apr 23 19:17:22 atom kernel:  __schedule+0x20a/0x550
> Apr 23 19:17:22 atom kernel:  schedule+0x5a/0xc0
> Apr 23 19:17:22 atom kernel:  schedule_timeout+0x11f/0x160
> Apr 23 19:17:22 atom kernel:  ? make_stripe_request+0x284/0x490 [raid456]
> Apr 23 19:17:22 atom kernel:  wait_woken+0x50/0x70

Looks like this normal io is waiting for reshape to be done, that's why
it hanged indefinitely.

This really is a kernel bug, perhaps it can be bypassed if reshape can
be done, hopefully automatically if this array can be read/write. Noted
never echo reshape to sync_action, this will corrupt data in your case.

Thanks,
Kuai

