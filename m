Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4992C6FA82
	for <linux-raid@archiver.kernel.org>; Mon, 12 Sep 2022 16:16:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbiILQQS (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 12 Sep 2022 12:16:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229929AbiILQQR (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 12 Sep 2022 12:16:17 -0400
X-Greylist: delayed 987 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 12 Sep 2022 09:16:11 PDT
Received: from xabean.com (xabean.com [139.177.207.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89D7713D6E
        for <linux-raid@vger.kernel.org>; Mon, 12 Sep 2022 09:16:11 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 xabean.com 28CFxhX51448168
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=richardharman.com;
        s=apr092020T0800Z; t=1662998383;
        bh=z9HWoi6knYB9g5ZOBR7uAGQTMhRW0w8FnbNGweEFKZo=;
        h=Date:To:From:Subject:From;
        b=S5syhX5AJUkVLGUUFUv1qIqb/GU7NGUmOinWQPexpYwact6U8RgPMEC41/F9nCAdS
         reDxomHNkRLhJ68qTgvA6m54vppM/XglMDCoZU3dBNlIctTOzfvgVEFBeyb2YJurFW
         UuQ0YUmdwob7v8e+Ydvm2bABehPyACqsozVZ9E54=
X-Client-Addr: 141.156.149.111
X-mtfnpy: !!MTFNPY!!
Received: from [192.168.2.115] (pool-141-156-149-111.res.east.verizon.net [141.156.149.111] (may be forged))
        (authenticated as=warewolf bits=0)
        by xabean.com (envelope-from richard+linux-raid@richardharman.com) (envelope-to ) (8.15.2/8.15.2) with ESMTPSA id 28CFxhX51448168
        (version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO)
        for <linux-raid@vger.kernel.org>; Mon, 12 Sep 2022 11:59:43 -0400
Message-ID: <21905603-8b17-43dc-d701-131dfab92ef1@richardharman.com>
Date:   Mon, 12 Sep 2022 11:59:43 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Content-Language: en-US
To:     linux-raid@vger.kernel.org
From:   Richard Harman <richard+linux-raid@richardharman.com>
Subject: 500G journal device for a 9T raid6 == hours and hours for mdadm
 assemble operation?
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Received-SPF: pass (xabean.com: 141.156.149.111 is authenticated by a trusted mechanism)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hey folks,

Question: I'm wondering if it's possible to force assemble a clean raid6 
array without it's journal, remove the journal, wipe the journal device, 
then add the journal device back and have the array state return to 
active?  I think my box is stuck replaying a 500G journal, slowly, 
pegging one CPU. :(

--- verbose detail below ---

In an effort to merge writes to a raid6 array w/ really slow spinning 
disks I recently added a write journal to my raid6 arrays at home - and 
from watching iostat -x 1 it showed exactly that, and was performing 
incredibly well.  99% of the requests to the spinning disks were 
merged.  The following weekend, I had a power outage at my house and did 
a "clean" shutdown, but I think the kernel / mdadm got stuck closing out 
the journal on one of my four raid6 arrays, while the OS was almost 
completely shut down, the UPS ran out.  And now as best I can tell when 
I try to assemble the array the kernel / mdadm is trying to replay many 
gigs of journal log on assemble of one of the arrays.

All six devices of the array that is having trouble (125) look like 
this, with the Events counter, and State all the same (560058, and clean):

    sh-5.1# mdadm --examine /dev/sde1
    /dev/sde1:
               Magic : a92b4efc
             Version : 1.2
         Feature Map : 0x200
          Array UUID : 9eb52e13:67e67192:2d118dbe:65e94436
                Name : sandbox.xabean.net:125  (local to host
    sandbox.xabean.net)
       Creation Time : Thu Nov 15 02:16:42 2018
          Raid Level : raid6
        Raid Devices : 5

      Avail Dev Size : 5860268032 sectors (2.73 TiB 3.00 TB)
          Array Size : 8790402048 KiB (8.19 TiB 9.00 TB)
         Data Offset : 262144 sectors
        Super Offset : 8 sectors
        Unused Space : before=262064 sectors, after=0 sectors
               State : clean
         Device UUID : 9b4e7de7:01b9ac3b:32bb2997:05b2e760

         Update Time : Sun Sep 11 11:52:46 2022
       Bad Block Log : 512 entries available at offset 24 sectors
            Checksum : 704688d7 - correct
              Events : 560058

              Layout : left-symmetric
          Chunk Size : 512K

        Device Role : Active device 4
        Array State : AAAAA ('A' == active, '.' == missing, 'R' ==
    replacing)


In a recovery shell over serial console, I started adding each disk 
individually:

    sh-5.1# mdadm --incremental /dev/sdm1
    mdadm: /dev/sdm1 attached to /dev/md/125, not enough to start (1).
    sh-5.1# mdadm --incremental /dev/sdy1
    mdadm: /dev/sdy1 attached to /dev/md/125, not enough to start (2).
    sh-5.1# mdadm --incremental /dev/sdi1
    mdadm: Journal device is missing, not safe to start yet.
    sh-5.1# mdadm --incremental /dev/sdq1
    mdadm: Journal device is missing, not safe to start yet.
    sh-5.1# mdadm --incremental /dev/sde1
    mdadm: Journal device is missing, not safe to start yet.
    sh-5.1# mdadm --incremental /dev/sdu1
    mdadm: Journal device is missing, not safe to start yet.
    sh-5.1# mdadm --incremental /dev/sdc2
    [  897.927170] async_tx: api initialized (async)
    [  898.063827] md/raid:md125: device sde1 operational as raid disk 4
    [  898.070013] md/raid:md125: device sdq1 operational as raid disk 3
    [  898.076179] md/raid:md125: device sdi1 operational as raid disk 2
    [  898.082346] md/raid:md125: device sdy1 operational as raid disk 1
    [  898.088505] md/raid:md125: device sdm1 operational as raid disk 0
    [  898.095380] md/raid:md125: raid level 6 active with 5 out of 5
    devices, algorithm 2


... and at this point, mdadm --incremental /dev/sdc2 doesn't return to 
the prompt.

Here's /proc/mdstat for md125 at this point:

    sh-5.1# cat /proc/mdstat
    Personalities : [raid1] [raid6] [raid5] [raid4]
    md125 : active raid6 sdc2[7](J) sdu1[3](S) sde1[5] sdq1[6] sdi1[2]
    sdy1[1] sdm1[0]
           8790402048 blocks super 1.2 level 6, 512k chunk, algorithm 2
    [5/5] [UUUUU]

If I sysrq-t to dump tasks, I think it's running through the journal?

    [ 2455.987827] task:mdadm           state:R  running task    
    stack:    0 pid: 1217 ppid:   954 flags:0x00004006
    [ 2455.997826] Call Trace:
    [ 2456.000348]  <TASK>
    [ 2456.002522]  ? __schedule+0x33d/0x1240
    [ 2456.006351]  ? _raw_spin_unlock+0x15/0x30
    [ 2456.010440]  ? __schedule+0x33d/0x1240
    [ 2456.014261]  ? schedule+0x67/0xe0
    [ 2456.017665]  ? schedule_timeout+0xf0/0x130
    [ 2456.021835]  ? chksum_update+0x13/0x20
    [ 2456.025674]  ? crc32c+0x2f/0x70
    [ 2456.028888]  ? get_page_from_freelist+0x578/0x1660
    [ 2456.033753]  ? sysvec_apic_timer_interrupt+0xab/0xc0
    [ 2456.038798]  ? asm_sysvec_apic_timer_interrupt+0x16/0x20
    [ 2456.044190]  ? r5l_start+0x5f1/0x1150 [raid456]
    [ 2456.048794]  ? md_start+0x3b/0x60
    [ 2456.052186]  ? do_md_run+0x5d/0x100
    [ 2456.055746]  ? md_ioctl+0x1073/0x1680
    [ 2456.059482]  ? syscall_exit_to_user_mode+0x17/0x40
    [ 2456.064346]  ? do_syscall_64+0x67/0x80
    [ 2456.068172]  ? syscall_exit_to_user_mode+0x17/0x40
    [ 2456.078510]  ? do_syscall_64+0x67/0x80
    [ 2456.082337]  ? blkdev_ioctl+0x118/0x270
    [ 2456.086251]  ? __x64_sys_ioctl+0x90/0xd0
    [ 2456.090243]  ? do_syscall_64+0x5b/0x80
    [ 2456.094064]  ? entry_SYSCALL_64_after_hwframe+0x63/0xcd
    [ 2456.099366]  </TASK>


Because the journal and each raid device are clean and have the same 
counters, I tried mdadm --fail'ing the journal device (the last mdadm 
--incremental that added the journal device still hadn't returned to the 
prompt) and /proc/mdstat now shows the device with the fail flag, but 
the mdadm --fail also hasn't returned to the prompt.

    sh-5.1# cat /proc/mdstat
    Personalities : [raid1] [raid6] [raid5] [raid4]
    md125 : active raid6 sdc2[7](J) sdu1[3](S) sde1[5] sdq1[6] sdi1[2]
    sdy1[1] sdm1[0]
           8790402048 blocks super 1.2 level 6, 512k chunk, algorithm 2
    [5/5] [UUUUU]

The array state in /sys/block/md125/md/array_state is inactive, and 
trying to set it active doesn't have any effect.

Here's mdadm --detail for the array:

    sh-5.1# /sbin/mdadm --detail /dev/md125
    /dev/md125:
                Version : 1.2
          Creation Time : Thu Nov 15 02:16:42 2018
             Raid Level : raid6
          Used Dev Size : 18446744073709551615
           Raid Devices : 5
          Total Devices : 7
            Persistence : Superblock is persistent

            Update Time : Mon Sep 12 04:03:21 2022
                  State : active, FAILED, Not Started
         Active Devices : 5
        Working Devices : 6
         Failed Devices : 1
          Spare Devices : 1

                 Layout : left-symmetric
             Chunk Size : 512K

    Consistency Policy : journal

                   Name : sandbox.xabean.net:125  (local to host
    sandbox.xabean.net)
                   UUID : 9eb52e13:67e67192:2d118dbe:65e94436
                 Events : 560059

         Number   Major   Minor   RaidDevice State
            -       0        0        0      removed
            -       0        0        1      removed
            -       0        0        2      removed
            -       0        0        3      removed
            -       0        0        4      removed

            -      65        1        3      sync   /dev/sdq1
            -       8       34        -      faulty   /dev/sdc2
            -       8      193        0      sync   /dev/sdm1
            -      65      129        1      sync   /dev/sdy1
            -       8      129        2      sync   /dev/sdi1
            -      65       65        -      spare   /dev/sdu1
            -       8       65        4      sync   /dev/sde1


iostat -x shows zero writes to the raid devices, but a whole lot of 
reads (but nowhere near pegging utilization of the journal SSD), so I'm 
wondering if it's possible to force assemble the raid6 array without the 
journal, remove the journal, then add it back and have the array state 
return to active?
