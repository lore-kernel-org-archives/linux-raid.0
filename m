Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C1FCFBEB
	for <linux-raid@vger.kernel.org>; Fri, 16 Feb 2024 01:14:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708046083; cv=none; b=H/N5+PHcTJmr0F7suf43DiW2ZeifgLJ3ip7u2/JlG1UdL+rijohACfrlvmJQfVvMEzXSvCQUxxbHDh0uvcSPDprDKqr7Y2eIfrmtkIC8W4qhBkzpm9JTYgav0f52T9Ozzv357t2TNra5EucGLfSJ+Vw7AyaoYrOf9i9CPdTYpYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708046083; c=relaxed/simple;
	bh=HBhILMCbGBj9AZHa3YbQJ7H+3mGHctz2dD95/amuFJY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=hUuWgRr6Y2ykrUCzV0nNYKV/NQC+P3NAmiXtWDnoDKN0K+Dufh7P/YU+NweK79wyxdozaO3aAF1nF6xH9bXu1p2qqhOsGZh290OVS6zk260azmdBn2L8Oi3uwWcRSESP3RGZSwJdjzOxLIbMOu0RopoxoC2JLVFVAjBrbF0WxKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.net; spf=pass smtp.mailfrom=gmx.net; dkim=pass (2048-bit key) header.d=gmx.net header.i=dapmk@gmx.net header.b=JJ3kIF5k; arc=none smtp.client-ip=212.227.17.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.net header.i=dapmk@gmx.net header.b="JJ3kIF5k"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
	s=s31663417; t=1708046077; x=1708650877; i=dapmk@gmx.net;
	bh=HBhILMCbGBj9AZHa3YbQJ7H+3mGHctz2dD95/amuFJY=;
	h=X-UI-Sender-Class:References:In-Reply-To:From:Date:Subject:To;
	b=JJ3kIF5kr2gnsHOj9IndmvMGGWt0DHewp9XTrT+hml5FIhfd+nlSZGMLXL+SNYGe
	 BU/KP2fjFILBlmukBUgl8r4tH7iPQyCpjSa6a8cTmIMQWa81shBuvEUqqH89q4j8D
	 WFm8gkScCUxqXAPI8oK3FnEu5xD83kue8H/gYQvkl0mEWDIF89l7/p5VKH/MSYqkL
	 +MYOMUV/XFnMet83BeL5wB656deyfdJbwyfG/c8W0zk2GfCuauRzLWdo+5j9NjzzV
	 I8A/vqvSFQoL9jO1d5cPrUxn/Ztb8oWIhf/f1LQau/ecUKsBAB/k1iM54vUt/ps9V
	 bBYMzYOzmpIk6Ygd4Q==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from mail-io1-f41.google.com ([209.85.166.41]) by mail.gmx.net
 (mrgmx104 [212.227.17.168]) with ESMTPSA (Nemesis) id
 1M8ygY-1rdVpT2HvK-0067eb for <linux-raid@vger.kernel.org>; Fri, 16 Feb 2024
 02:14:37 +0100
Received: by mail-io1-f41.google.com with SMTP id ca18e2360f4ac-7c49c095eb3so37034239f.2
        for <linux-raid@vger.kernel.org>; Thu, 15 Feb 2024 17:14:37 -0800 (PST)
X-Gm-Message-State: AOJu0YwE1ETnn+k8c411JI5FyrrRCOY6zXfsnnZXphj5RjmcCrfZLV0+
	MoLvkIMW+vUuxsR8mq0b3U91NcsSPrHU8xcBL64cehamXmTpScOXKWANU6rAHrSZZJpNqjZfjJ+
	DCG0+MmRBZfDKdBHnTs8yorwA/9k=
X-Google-Smtp-Source: AGHT+IEQ9AwxJNiSJCAveRQbm8u/57F5QmH9ZpkHHUXQY0uIasVn+Ue4VUvDe+vcehyWGJ80QionucC/eN5wv/4XEq8=
X-Received: by 2002:a05:6602:155:b0:7c4:4331:a9e8 with SMTP id
 v21-20020a056602015500b007c44331a9e8mr3803867iot.5.1708046076099; Thu, 15 Feb
 2024 17:14:36 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAAmYLeEbDGV4oVwjmU1DfT7P7hnHDBeCZHh7bMxUwmLnfWqWFA@mail.gmail.com>
In-Reply-To: <CAAmYLeEbDGV4oVwjmU1DfT7P7hnHDBeCZHh7bMxUwmLnfWqWFA@mail.gmail.com>
From: Matt Bader <dapmk@gmx.net>
Date: Fri, 16 Feb 2024 02:14:25 +0100
X-Gmail-Original-Message-ID: <CAAmYLeGDqB8vEhApctLewB3kByVDWfrtZnvwmR2Yq3AwOvFARw@mail.gmail.com>
Message-ID: <CAAmYLeGDqB8vEhApctLewB3kByVDWfrtZnvwmR2Yq3AwOvFARw@mail.gmail.com>
Subject: Re: Growing mdadm RAID5 to RAID6 and simultaneously adding space
 makes data inaccessible during grow
To: linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:T5oqfhCQ33gk5M/ybxlb4VvNCjf0rY215ExtTPuYggflgxxxK0u
 5xy9zCDcITTB4dVyHbtjyKvbii1Y/Z7aCEGAGd1wewW2tdU3i28tZIy/Pr3PIemdJcCXzu9
 g2NP/Zy5tpH8NI4yLwSTysHXQ4ESMiurTiYMqjyHLsdI2k7Qj7v46FvyeYQbCQysNVNDCCW
 Qw5yGQ2FlNMFLrr7f/M7g==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:QIrkkId1hAw=;QuF8eGPcJG0rVyPfHkhqjfhDNEq
 N9TPSrocMHLYPntUHdhgdV+rWP7+Mfle7ONqpp3KV4gVHbegbTxlXP/gygEBGiktLe2OWtvJB
 5arl3xuSYfroq4WTTKtQQzWvwhD+zRP5HBYG+/Y2L4j7JvmTd3eNnvtsVIXIIhrf1KOY2Tscd
 Vd1+uoRKC55KbwIGgtvJjv62Itj9ihqhYPv4WfK+l35YftFJs18c7OwDjeqfwXMSAvvG8Czno
 oOW1mdFsfyBkmHgqgogCAImwL/I7SuVanKSEy2vWMtQhecexcuODlqxs2O1EXVsDQ/EDngwDe
 eb1I23A8xcVkspzWaNmCg7LKlTFTmaoIBSUYCT5GFjLeNdIDrt0KSVWNxTKvJ80nQgWxFjpMs
 8WImqj12ZohVvcEjVG8i/+QMcvw4nYv9hj8XTjKGT0apdG9QXE9IHefOAMafQJQ7kvlMLTORF
 7GPQeOP6Q89xrYRFTzihWu9i0ZZA6+lfozw7ELNya5y2P2oO52vI1kZJJcAKCYsaTl+BDqxU+
 GerV/ahp3M2J81V3WdldKa4X+t/C0ouO4CiGMGe2InFz9ucAcDdkVQ84hQP0uNYJtw6Wrc/v0
 vtcjqNDDcjMuM5/zg4ei15UfewyatAwk5FtBewydiWd3bvjjvdVckdWAPYeQTEFdUzXQaPTlH
 xnAh1Oc722qQFz1wmoSq24tyJ4W9cMnZfYujVdOrkFuk0lI++JY08/QiOWAngTg98KYFNp5Im
 0jqRstg6KQ6KwzFVMkffgrZ7AzCH/euvD+BnutMbzOJA0Er8wOHjkKhI8IxbHdjQyShtSgxNH
 rgTJpTPgklbSYUCvdeVHRGctCArFzIJsJh5WPnnf6rhD0=

Hey RAID folks,

For reference, the RAID5 to RAID6 process which added a new drive at
the same time completed its reshape. I tried to add capacity and grow
a RAID5 to RAID6 in one go, adding two disks at the same time.

At the end of that lengthy initial reshape phase, the data in the RAID
became accessible again. In a second run, it cleared up its degraded
state with data being accessible throughout. No data was ultimately
lost, although service was denied for a few days while the reshape was
taking place.

I thought this might be useful for others who end up in the same situation.

Thanks,

Matt

>
> Hello RAID folks -
>
> I took a stab at growing a four-drive RAID5 to RAID6 and at the same
> time adding another drive on mdadm 4.2, by issuing
>
> $ sudo mdadm --grow --raid-devices=6 --level=6
> --backup-file=/grow_md0.bak /dev/md0
>
> Before that, two spare drives had been added to md0. All seemed to go
> well, it passed the critical section and no errors were shown. After a
> while, mdstat looked like this:
>
> $ cat /proc/mdstat
> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
> [raid4] [raid10]
> md0 : active raid6 sdc[0] sdg[5] sdh[6] sdd[4] sdb[3] sde[1]
>       52734587904 blocks super 1.2 level 6, 512k chunk, algorithm 18
> [6/5] [UUUU_U]
>       [>....................]  reshape =  0.1% (17689088/17578195968)
> finish=3749331.8min speed=77K/sec
>       bitmap: 0/262 pages [0KB], 32768KB chunk, file:
> /bitmapfile-ext-backups-md0
>
> (By this time, I had manually throttled the reshape speed)
>
> Access to the filesystem which was mounted from /dev/md0, however,
> froze right after issuing the grow command.
>
> Reading before the reshape position (just about 69GB into the array)
> works well, but reads past that point block indefinitely and the
> syslog shows messages like this one:
>
> kernel: [ 1451.122942] INFO: task (udev-worker):2934 blocked for more
> than 1087 seconds.
> kernel: [ 1451.123010]       Tainted: P           O
> 6.5.0-14-generic #14-Ubuntu
> kernel: [ 1451.123053] "echo 0 >
> /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> kernel: [ 1451.123096] task:(udev-worker)   state:D stack:0
> pid:2934  ppid:535    flags:0x00004006
> kernel: [ 1451.123112] Call Trace:
> kernel: [ 1451.123118]  <TASK>
> kernel: [ 1451.123128]  __schedule+0x2cc/0x770
> kernel: [ 1451.123154]  schedule+0x63/0x110
> kernel: [ 1451.123166]  schedule_timeout+0x157/0x170
> kernel: [ 1451.123181]  wait_woken+0x5f/0x70
> kernel: [ 1451.123196]  raid5_make_request+0x225/0x450 [raid456]
> kernel: [ 1451.123240]  ? __pfx_woken_wake_function+0x10/0x10
> kernel: [ 1451.123257]  md_handle_request+0x139/0x220
> kernel: [ 1451.123272]  md_submit_bio+0x63/0xb0
> kernel: [ 1451.123281]  __submit_bio+0xe4/0x1c0
> kernel: [ 1451.123292]  __submit_bio_noacct+0x90/0x230
> kernel: [ 1451.123304]  submit_bio_noacct_nocheck+0x1ac/0x1f0
> kernel: [ 1451.123318]  submit_bio_noacct+0x17f/0x5e0
> kernel: [ 1451.123329]  submit_bio+0x4d/0x80
> kernel: [ 1451.123337]  submit_bh_wbc+0x124/0x150
> kernel: [ 1451.123350]  block_read_full_folio+0x33a/0x450
> kernel: [ 1451.123363]  ? __pfx_blkdev_get_block+0x10/0x10
> kernel: [ 1451.123379]  ? __pfx_blkdev_read_folio+0x10/0x10
> kernel: [ 1451.123391]  blkdev_read_folio+0x18/0x30
> kernel: [ 1451.123401]  filemap_read_folio+0x42/0xf0
> kernel: [ 1451.123416]  filemap_update_page+0x1b7/0x280
> kernel: [ 1451.123431]  filemap_get_pages+0x24f/0x3b0
> kernel: [ 1451.123450]  filemap_read+0xe4/0x420
> kernel: [ 1451.123463]  ? filemap_read+0x3d5/0x420
> kernel: [ 1451.123484]  blkdev_read_iter+0x6d/0x160
> kernel: [ 1451.123497]  vfs_read+0x20a/0x360
> kernel: [ 1451.123517]  ksys_read+0x73/0x100
> kernel: [ 1451.123531]  __x64_sys_read+0x19/0x30
> kernel: [ 1451.123543]  do_syscall_64+0x59/0x90
> kernel: [ 1451.123550]  ? do_syscall_64+0x68/0x90
> kernel: [ 1451.123556]  ? syscall_exit_to_user_mode+0x37/0x60
> kernel: [ 1451.123567]  ? do_syscall_64+0x68/0x90
> kernel: [ 1451.123574]  ? syscall_exit_to_user_mode+0x37/0x60
> kernel: [ 1451.123583]  ? do_syscall_64+0x68/0x90
> kernel: [ 1451.123589]  ? syscall_exit_to_user_mode+0x37/0x60
> kernel: [ 1451.123597]  ? do_syscall_64+0x68/0x90
> kernel: [ 1451.123603]  ? do_user_addr_fault+0x17a/0x6b0
> kernel: [ 1451.123612]  ? exit_to_user_mode_prepare+0x30/0xb0
> kernel: [ 1451.123626]  ? irqentry_exit_to_user_mode+0x17/0x20
> kernel: [ 1451.123635]  ? irqentry_exit+0x43/0x50
> kernel: [ 1451.123643]  ? exc_page_fault+0x94/0x1b0
> kernel: [ 1451.123652]  entry_SYSCALL_64_after_hwframe+0x6e/0xd8
> kernel: [ 1451.123663] RIP: 0033:0x7f89e931a721
> kernel: [ 1451.123713] RSP: 002b:00007fff8641dc48 EFLAGS: 00000246
> ORIG_RAX: 0000000000000000
> kernel: [ 1451.123723] RAX: ffffffffffffffda RBX: 0000559b1ebd94a0
> RCX: 00007f89e931a721
> kernel: [ 1451.123729] RDX: 0000000000000040 RSI: 0000559b1ebf2418
> RDI: 000000000000000d
> kernel: [ 1451.123735] RBP: 0000311ce7cf0000 R08: fffffffffffffe18
> R09: 0000000000000070
> kernel: [ 1451.123741] R10: 0000559b1ebf2810 R11: 0000000000000246
> R12: 0000559b1ebf23f0
> kernel: [ 1451.123747] R13: 0000000000000040 R14: 0000559b1ebd94f8
> R15: 0000559b1ebf2408
> kernel: [ 1451.123762]  </TASK>
>
> Reads from just before the reshape position go fast at first, then
> progress at about the speed of the reshape times four. I verified that
> the first two btrfs superblock copies on the partition (at the start
> of the drive and at 64MB) are readable and intact. The last one, at
> 256GB, is still past the reshape position and inaccessible.
>
> Rebooting and re-assembling the array led to exactly the same
> situation: The reshape is running and the beginning of the array is
> readable. Reads after the reshape point time out or block
> indefinitely.
>
> The array contains data that will be difficult or impossible to
> recover otherwise, so I would like not to lose the array's contents,
> but accessing the data during this operation would also be really
> useful. Is there a way to stop the reshape and revert the array to a
> 3+1 drive RAID5 to restore access to my data before a lengthy reshape
> runs its course?
>
> Thanks.
>
> Matt
