Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A24CC4332F
	for <linux-raid@archiver.kernel.org>; Tue, 31 Oct 2023 21:44:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343844AbjJaVoz (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 31 Oct 2023 17:44:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbjJaVoy (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 31 Oct 2023 17:44:54 -0400
Received: from lists.tip.net.au (pasta.tip.net.au [203.10.76.2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B8EEE4
        for <linux-raid@vger.kernel.org>; Tue, 31 Oct 2023 14:44:51 -0700 (PDT)
Received: from lists.tip.net.au (pasta.tip.net.au [203.10.76.2])
        by mailhost.tip.net.au (Postfix) with ESMTP id 4SKkFF6zXgz9QVl
        for <linux-raid@vger.kernel.org>; Wed,  1 Nov 2023 08:44:49 +1100 (AEDT)
Received: from [IPV6:2405:6e00:494:92f5:21b:21ff:fe3a:5672] (unknown [IPv6:2405:6e00:494:92f5:21b:21ff:fe3a:5672])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by mailhost.tip.net.au (Postfix) with ESMTPSA id 4SKkFF2thzz9QVd
        for <linux-raid@vger.kernel.org>; Wed,  1 Nov 2023 08:44:49 +1100 (AEDT)
Message-ID: <a095b798-6bfc-4b41-9d1d-19b99a9279bf@eyal.emu.id.au>
Date:   Wed, 1 Nov 2023 08:44:45 +1100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From:   eyal@eyal.emu.id.au
Subject: Re: problem with recovered array [more details]
To:     linux-raid@vger.kernel.org
References: <87273fc6-9531-4072-ae6c-06306e9a269d@eyal.emu.id.au>
Content-Language: en-US
In-Reply-To: <87273fc6-9531-4072-ae6c-06306e9a269d@eyal.emu.id.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 31/10/2023 00.35, eyal@eyal.emu.id.au wrote:
> F38
> 
> I know this is a bit long but I wanted to provide as much detail as I thought needed.
> 
> I have a 7-member raid6. The other day I needed to send a disk for replacement.
> I have done this before and all looked well. The array is now degraded until I get the new disk.
> 
> At one point my system got into trouble and I am not sure why, but it started to have
> very slow response to open/close files, or even keystrokes. At the end I decided to reboot.
> It refused to complete the shutdown and after a while I used the sysrq feature for this.
> 
> On the restart it dropped into emergency shell, the array had all members listed as spares.
> I tried to '--run' the array but mdadm refused 'cannot start dirty degraded array'
> though the array was now listed in mdstat and looked as expected.
> 
> Since mdadm suggested I use --force', I did so
>      mdadm --assemble --force /dev/md127 /dev/sd{b,c,d,e,f,g}1
> 
> Q0) was I correct to use this command?
> 
> 2023-10-30T01:08:25+1100 kernel: md/raid:md127: raid level 6 active with 6 out of 7 devices, algorithm 2
> 2023-10-30T01:08:25+1100 kernel: md127: detected capacity change from 0 to 117187522560
> 2023-10-30T01:08:25+1100 kernel: md: requested-resync of RAID array md127
> 
> Q1) What does this last line mean?
> 
> Now that the array came up I still could not mount the fs (still in emergency shell).
> I rebooted and all came up, the array was there and the fs was mounted and so far
> I did not notice any issues with the fs.
> 
> However, it is not perfect. I tried to copy some data from an external (USB) disk to the array
> and it went very slowly (as in 10KB/s, the USB could do 120MB/s). The copy (rsync) was running
> at 100% CPU which is unexpected. I then stopped it. As a test, I rsync'ed the USB disk to another
> SATA disk on the server and it went fast, so the USB disk is OK.
> 
> I then noticed (in 'top') that there is a kworker running at 100% CPU:
> 
>      PID USER      PR  NI    VIRT    RES    SHR S  %CPU  %MEM     TIME+ COMMAND
>   944760 root      20   0       0      0      0 R 100.0   0.0 164:00.85 kworker/u16:3+flush-9:127
> 
> It did it for many hours and I do not know what it is doing.
> 
> Q2) what does this worker do?
> 
> I also noticed that mdstat shows a high bitmap usage:
> 
> Personalities : [raid6] [raid5] [raid4]
> md127 : active raid6 sde1[4] sdg1[6] sdf1[5] sdd1[7] sdb1[8] sdc1[9]
>        58593761280 blocks super 1.2 level 6, 512k chunk, algorithm 2 [7/6] [_UUUUUU]
>        bitmap: 87/88 pages [348KB], 65536KB chunk
> 
> Q3) Is this OK? Should the usage go down? It does not change at all.
> 
> While looking at everything, I started iostat on md127 and I see that there is a constant
> trickle of writes, about 5KB/s. There is no activity on this fs.
> Also, I see similar activity on all the members, at the same rate, so md127 does not show
> 6 times the members activity. I guess this is just how md works?
> 
> Q4) What is this write activity? Is it related to the abovementioned 'requested-resync'?
>      If this is a background thing, how can I monitor it?
> 
> Q5) Finally, will the array come up (degraded) if I reboot or will I need to coerse it to start?
>      What is the correct way to bring up a degraded array? What about the 'dirty' part?
> 'mdadm -D /dev/md127' mention'sync':
>      Number   Major   Minor   RaidDevice State
>         -       0        0        0      removed
>         8       8       17        1      active sync   /dev/sdb1
>         9       8       33        2      active sync   /dev/sdc1
>         7       8       49        3      active sync   /dev/sdd1
>         4       8       65        4      active sync   /dev/sde1
>         5       8       81        5      active sync   /dev/sdf1
>         6       8       97        6      active sync   /dev/sdg1
> Is this related?
> 
> BTW I plan to run a 'check' at some point.

I ran a 'check' of a few segment of the array, just to see if there is any wholesale issue, but is was clean.

> TIA

It is time to describe in more detail what happened, because it happened again yesterday and I kept notes.

The system became somewhat non responsive so I decided to reboot. The shutdown did not complete.
It took over 10m for the system to slowly give up on waiting for about 10 services, then stopping them hard.
The last line on the screen was
	systemd[1]: Stopped systemd-sysctl.service - Apply Kernel Variables.
After waiting for almost 15m with no activity I rebooted using sysrq e,i,s,u,b.

The restart dropped into emergency shell.
mdstat shows all array members are spare. Same as before.
I repeated what worked last time
	mdadm --assemble         /dev/md127 /dev/sd{b,c,d,e,f,g}1
failed, then:
	mdadm --stop md127
	mdadm --assemble --force /dev/md127 /dev/sd{b,c,d,e,f,g}1
Some messages, then /data1 was (automatically) mounted on md127. The log shows
	2023-10-31T23:54:02+1100 kernel: EXT4-fs (md127): recovery complete
	2023-10-31T23:54:02+1100 kernel: EXT4-fs (md127): mounted filesystem 378e74a6-e379-4bd5-ade5-f3cd85952099 r/w with ordered data mode. Quota mode: none.

There was also a message saying a recovery (maybe a different term was used?) is going.
mdstat shows the array is up and a recovery is running.

After waiting for a little while it was time to boot.
At this point I used 'exit' hoping for the boot to complete but it did not, there was no response at all.
Ctl-Alt-Del brought the system up. Looking at the system log suggests it was a proper restart.
On the fresh boot I do not see the recovery and the array looks like this:

$ cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md127 : active raid6 sde1[4] sdc1[9] sdf1[5] sdb1[8] sdd1[7] sdg1[6]
       58593761280 blocks super 1.2 level 6, 512k chunk, algorithm 2 [7/6] [_UUUUUU]
       bitmap: 88/88 pages [352KB], 65536KB chunk

It now shows the bitmap as full. I left the system alone overnight with iostat running and I see
some activity every few minutes. Nothing is running on the array.

01:02:07 Device             tps    kB_read/s    kB_wrtn/s    kB_dscd/s    kB_read    kB_wrtn    kB_dscd
01:02:07 md127            43.32      1098.67      3659.18         0.00    4257297   14179212          0
01:03:07 md127             0.00         0.00         0.00         0.00          0          0          0
01:04:07 md127             0.00         0.00         0.00         0.00          0          0          0
01:05:07 md127             0.00         0.00         0.00         0.00          0          0          0
01:06:07 md127             0.00         0.00         0.00         0.00          0          0          0
01:07:07 md127             0.00         0.00         0.00         0.00          0          0          0
01:08:07 md127             0.00         0.00         0.00         0.00          0          0          0
01:09:07 md127             0.02         0.00         0.07         0.00          0          4          0
01:10:07 md127             0.38         0.00         1.53         0.00          0         92          0
01:11:07 md127             0.00         0.00         0.00         0.00          0          0          0
01:12:07 md127             0.00         0.00         0.00         0.00          0          0          0
01:13:07 md127             0.00         0.00         0.00         0.00          0          0          0
01:14:07 md127             0.00         0.00         0.00         0.00          0          0          0
01:15:07 md127             0.02         0.00         1.60         0.00          0         96          0
01:16:07 md127             0.18         0.00         7.27         0.00          0        436          0
01:17:07 md127             0.00         0.00         0.00         0.00          0          0          0
01:18:07 md127             0.00         0.00         0.00         0.00          0          0          0
01:19:07 md127             0.02         0.00         0.07         0.00          0          4          0
01:20:07 md127             0.33         0.00         1.33         0.00          0         80          0
01:21:07 md127             0.00         0.00         0.00         0.00          0          0          0

Later, some mythtv recordings were done and I now checked and they play just fine.

This is what the relevant log messages are during this time:

2023-10-31T23:47:41+1100 kernel: EXT4-fs (nvme0n1p3): mounted filesystem 62fbafb4-86ba-497d-ae82-77b4d386b708 ro with ordered data mode. Quota mode: none.
2023-10-31T23:47:47+1100 kernel: EXT4-fs (nvme0n1p3): re-mounted 62fbafb4-86ba-497d-ae82-77b4d386b708 r/w. Quota mode: none.
2023-10-31T23:47:48+1100 kernel: EXT4-fs (nvme0n1p1): mounted filesystem 43e95102-07d4-4012-9d69-cf5e4100e682 r/w with ordered data mode. Quota mode: none.
2023-10-31T23:47:48+1100 kernel: EXT4-fs (nvme0n1p4): mounted filesystem f415fb92-0a9c-49cc-b4b9-48d9135acd70 r/w with ordered data mode. Quota mode: none.
2023-10-31T23:47:49+1100 kernel: EXT4-fs (sda1): mounted filesystem c7b4b181-a62e-4e66-96e1-dfa249049f70 r/w with ordered data mode. Quota mode: none.
2023-10-31T23:48:32+1100 systemd[1]: Dependency failed for data1.mount - /data1.
2023-10-31T23:48:32+1100 systemd[1]: data1.mount: Job data1.mount/start failed with result 'dependency'.
2023-10-31T23:50:50+1100 kernel: md/raid:md127: not clean -- starting background reconstruction
2023-10-31T23:50:50+1100 kernel: md/raid:md127: device sdf1 operational as raid disk 5
2023-10-31T23:50:50+1100 kernel: md/raid:md127: device sde1 operational as raid disk 4
2023-10-31T23:50:50+1100 kernel: md/raid:md127: device sdg1 operational as raid disk 6
2023-10-31T23:50:50+1100 kernel: md/raid:md127: device sdb1 operational as raid disk 1
2023-10-31T23:50:50+1100 kernel: md/raid:md127: device sdd1 operational as raid disk 3
2023-10-31T23:50:50+1100 kernel: md/raid:md127: device sdc1 operational as raid disk 2
2023-10-31T23:50:50+1100 kernel: md/raid:md127: cannot start dirty degraded array.
2023-10-31T23:50:50+1100 kernel: md/raid:md127: failed to run raid set.
2023-10-31T23:50:50+1100 kernel: md: pers->run() failed ...
2023-10-31T23:52:58+1100 kernel: md: md127 stopped.
2023-10-31T23:53:55+1100 kernel: md: md127 stopped.
2023-10-31T23:53:55+1100 kernel: md/raid:md127: device sdb1 operational as raid disk 1
2023-10-31T23:53:55+1100 kernel: md/raid:md127: device sdg1 operational as raid disk 6
2023-10-31T23:53:55+1100 kernel: md/raid:md127: device sdf1 operational as raid disk 5
2023-10-31T23:53:55+1100 kernel: md/raid:md127: device sde1 operational as raid disk 4
2023-10-31T23:53:55+1100 kernel: md/raid:md127: device sdd1 operational as raid disk 3
2023-10-31T23:53:55+1100 kernel: md/raid:md127: device sdc1 operational as raid disk 2
2023-10-31T23:53:55+1100 kernel: md/raid:md127: raid level 6 active with 6 out of 7 devices, algorithm 2
2023-10-31T23:53:55+1100 kernel: md127: detected capacity change from 0 to 117187522560
2023-10-31T23:53:55+1100 kernel: md: requested-resync of RAID array md127
2023-10-31T23:53:56+1100 systemd[1]: Mounting data1.mount - /data1...
2023-10-31T23:54:02+1100 kernel: EXT4-fs (md127): recovery complete
2023-10-31T23:54:02+1100 kernel: EXT4-fs (md127): mounted filesystem 378e74a6-e379-4bd5-ade5-f3cd85952099 r/w with ordered data mode. Quota mode: none.
2023-10-31T23:54:02+1100 systemd[1]: Mounted data1.mount - /data1.
2023-10-31T23:54:02+1100 mdadm[1286]: DeviceDisappeared event detected on md device /dev/md/md127
2023-10-31T23:54:02+1100 mdadm[1286]: NewArray event detected on md device /dev/md127
2023-10-31T23:54:02+1100 mdadm[1286]: DegradedArray event detected on md device /dev/md127
2023-10-31T23:54:02+1100 mdadm[1286]: RebuildStarted event detected on md device /dev/md127

Of note:

Starting the array without --force fails
	md/raid:md127: not clean -- starting background reconstruction
	md/raid:md127: cannot start dirty degraded array.
	md/raid:md127: failed to run raid set.

Then with --force it starts, /data1 is (automatically) mounted but says
	kernel: EXT4-fs (md127): recovery complete
so the shutdown was not clean.

Soon after
	mdadm[1286]: RebuildStarted event detected on md device /dev/md127

What I do not understand is, what does this mean, is there something going on that does not show in mdstat?
	starting background reconstruction
	RebuildStarted event detected

-- 
Eyal at Home (eyal@eyal.emu.id.au)

