Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F252125DA
	for <linux-raid@vger.kernel.org>; Sun, 21 Jan 2024 07:39:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705822791; cv=none; b=u1jBTpdCdmV+iJjtmwCw8bjvu4Uy4N2AOBBuv3K0i7lN6uNtmNvpN0fYhQnwQGL5MwFXAnMQI7s60iTE6Ly5syjKNScc2L5th0aW4XGAgCL7Wc8tVjgWoGGIRCmla7LnrZtNXlHAvQX0dLgnEMNw3CXe58PwcALnZ6lYG1Eihws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705822791; c=relaxed/simple;
	bh=5NshJktWihM8g2K8UYceuE8jW0z6vk96V643CtdH4f4=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=h7e9GrKf/zRdL9f9CxgitPclzhwEmYSdbTzPVPRstqmasTHRlRJKxLyBlFiNOWPJ6DvN6dCScvr3YGnsl+SnLT1JAeduDu3Es2qt6YP4Yl78i8foHtQrdtU8HdXABlAp98BBwvBj7MJ5JyEyaVmeWGlmKVda8QF1RVfHhUPmvms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.net; spf=pass smtp.mailfrom=gmx.net; dkim=pass (2048-bit key) header.d=gmx.net header.i=dapmk@gmx.net header.b=jPEU7mH6; arc=none smtp.client-ip=212.227.17.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.net header.i=dapmk@gmx.net header.b="jPEU7mH6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
	s=s31663417; t=1705822786; x=1706427586; i=dapmk@gmx.net;
	bh=5NshJktWihM8g2K8UYceuE8jW0z6vk96V643CtdH4f4=;
	h=X-UI-Sender-Class:From:Date:Subject:To;
	b=jPEU7mH6nSmX3QHNHJvEAMjc0+mwNdu2bmBKesQBCf6WoeU5qPK8wVTi2JBydMGc
	 g6tNwQ7UYvOKIWRfqfJTAe63BCjyg9LNeraA0ZEr7UmpFGcDJhzQCssS3dz+IWnYE
	 vj4ARt+UOGqpCb+GPUl1OOljWE0M7x0Z7ozPIAV9EDuWj1LcuIC8CLIQdn/8X5Jpk
	 +EYI4cqaGMZxZTp0edrNrD4U6hass+pWwb6KEGZmKC/xFzKEeVVgVwICfj+uQmRIB
	 MUZu3DmxVN9lHAnqlhYuGXSq+nkwtvk4pUfMB4T8rv9V4u5LmqY+0cjKzyJM8SYeu
	 ZjwpvrquUfu2B0RSWQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from mail-io1-f45.google.com ([209.85.166.45]) by mail.gmx.net
 (mrgmx104 [212.227.17.168]) with ESMTPSA (Nemesis) id
 1N2V4J-1qyPKo3PAt-013rcr for <linux-raid@vger.kernel.org>; Sun, 21 Jan 2024
 08:39:46 +0100
Received: by mail-io1-f45.google.com with SMTP id ca18e2360f4ac-7bed9c7d33fso93210239f.1
        for <linux-raid@vger.kernel.org>; Sat, 20 Jan 2024 23:39:45 -0800 (PST)
X-Gm-Message-State: AOJu0Yyt3/P1J0dH46jSF+uBsD7B4hCm5+s/LYZPf/Tl+NFTqv4jdWXk
	fXzqVRPVX/f22LJC4vO6jwMJ0qcLH6u8AEfnA5Hav37YwfpIF2kZ5MhiJOI/txtzsavYpzLHmZU
	8a+mdlgUK9T9EA1k3Un5nlGqVuuc=
X-Google-Smtp-Source: AGHT+IFunHieetXjDT5eLtfMHQlrLtJk6KZY32e2DuQy2JAia3Vvpg6ebLB4Sgn+N+rzr7avVjbLAaB7PUGN8S1tBio=
X-Received: by 2002:a5d:8e0c:0:b0:7bc:1bf9:fd83 with SMTP id
 e12-20020a5d8e0c000000b007bc1bf9fd83mr3305996iod.3.1705822784260; Sat, 20 Jan
 2024 23:39:44 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Matt Bader <dapmk@gmx.net>
Date: Sun, 21 Jan 2024 08:39:33 +0100
X-Gmail-Original-Message-ID: <CAAmYLeEbDGV4oVwjmU1DfT7P7hnHDBeCZHh7bMxUwmLnfWqWFA@mail.gmail.com>
Message-ID: <CAAmYLeEbDGV4oVwjmU1DfT7P7hnHDBeCZHh7bMxUwmLnfWqWFA@mail.gmail.com>
Subject: Growing mdadm RAID5 to RAID6 and simultaneously adding space makes
 data inaccessible during grow
To: linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:g5Cz3UFBAh3jEQlTFLFHZFkbh2TR3+4kvVCc9xTPXx4up4iPtPa
 744T+CVewLHXVCoqj3q448fipY7jMCFJyk8+GYtwLJwWwL5PcOoGd/qn+jaiAZLkztjtjfO
 s0ugn8VcGdX0XQpcIlUnu+CBBFFCYcv5tN2Ck08nlpVODeV6I8OfOpxV3FF4YTin2kdPtDI
 8hkaO9/CyG9u2uUIy/BDQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:qaqOl4d59W4=;a0yiru3/OEPjVRJ1Bdcdd5Zv2wd
 o5/Ui5uR1XxeDm4WhtP7LKPuzKV7vmMSUUPqh8NeGA9eQbXLTEDMtIDgjj+L57tfHplBJ2J2Y
 d5l/krayDVtyGvQOxXqSt8+11KybwVSUT9IjoCeI/ZHlwHmy/yXHgSrfmsTeEbehvZi6K533K
 ZYb98Ppjxqfo0XyYbYx99Zs4N70rm7kt630RUm4otQ860CQmTS7yjbCxakgiQrFn7KfM+OmAT
 RrsHpn6O7oitJBzP9xdFtux70JdDi8kE7hxufh7wupfpbzo8SZdVKV7aAeaTkp/uDyrg9gykE
 QlToQTrzHRdFKLwHG+bJtSKEQIX45XAe///PBu3zoOTJ8xMJf6PaFenZKrpPiWggsaFjUsypm
 8CNM+ewGHvH2Ig/A6PiGiK7G0xx8VJFRrqceOtj+AzALzaBcWfGjWBT5i5BHSxxVf/6/VRANf
 IOpU+Kqj/ymrlbaFmrt5U44a/YJl/CgeH+fhFNZrgpFGZ+AxQoBnOqCFx5oN07eU3F7C0W9SK
 Na0Mnf7fjXMVcUlb2ZZcZyqs1Bv0+CmrZ6wN0BWNUPIDDZidcEcI2CmZR40Cd78iOGf4d8ozP
 llEAAKJJgX3mppOmQD92Vp1ODsdBLW7lEmSDH2wGrN7kI2kQv+Mcsmq2ffqA6gz6T6sPLsGvG
 afd0x3Rj/6nrGyrvYwUuF4oeZJ1yqTsoIHWdA3ie1bI9yRt1gEUvaAEKbTQj+4wSz32Eao7bH
 j3UeWzlOr9+r1850j/XNDY8qeMszonxfQl0yldMF4s7yCQcqwfAYpP19uLiMHKo9YYTL5OZQV
 YT0RXccrY1YhmC7Uyn7r3TqctczWTAZpkNzbk5aBrYqDLBFKgodh6qT9EsGIR/vVjN2jOoIGC
 Pg8Ec9DSELFcJmrnnFS//Jz5Xi+S64fsZcVBPYXAkp0Qsya0QkhCksl3O3fAnh2ZFVyy4gMKD
 /OIl/g==

Hello RAID folks -

I took a stab at growing a four-drive RAID5 to RAID6 and at the same
time adding another drive on mdadm 4.2, by issuing

$ sudo mdadm --grow --raid-devices=6 --level=6
--backup-file=/grow_md0.bak /dev/md0

Before that, two spare drives had been added to md0. All seemed to go
well, it passed the critical section and no errors were shown. After a
while, mdstat looked like this:

$ cat /proc/mdstat
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
[raid4] [raid10]
md0 : active raid6 sdc[0] sdg[5] sdh[6] sdd[4] sdb[3] sde[1]
      52734587904 blocks super 1.2 level 6, 512k chunk, algorithm 18
[6/5] [UUUU_U]
      [>....................]  reshape =  0.1% (17689088/17578195968)
finish=3749331.8min speed=77K/sec
      bitmap: 0/262 pages [0KB], 32768KB chunk, file:
/bitmapfile-ext-backups-md0

(By this time, I had manually throttled the reshape speed)

Access to the filesystem which was mounted from /dev/md0, however,
froze right after issuing the grow command.

Reading before the reshape position (just about 69GB into the array)
works well, but reads past that point block indefinitely and the
syslog shows messages like this one:

kernel: [ 1451.122942] INFO: task (udev-worker):2934 blocked for more
than 1087 seconds.
kernel: [ 1451.123010]       Tainted: P           O
6.5.0-14-generic #14-Ubuntu
kernel: [ 1451.123053] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
kernel: [ 1451.123096] task:(udev-worker)   state:D stack:0
pid:2934  ppid:535    flags:0x00004006
kernel: [ 1451.123112] Call Trace:
kernel: [ 1451.123118]  <TASK>
kernel: [ 1451.123128]  __schedule+0x2cc/0x770
kernel: [ 1451.123154]  schedule+0x63/0x110
kernel: [ 1451.123166]  schedule_timeout+0x157/0x170
kernel: [ 1451.123181]  wait_woken+0x5f/0x70
kernel: [ 1451.123196]  raid5_make_request+0x225/0x450 [raid456]
kernel: [ 1451.123240]  ? __pfx_woken_wake_function+0x10/0x10
kernel: [ 1451.123257]  md_handle_request+0x139/0x220
kernel: [ 1451.123272]  md_submit_bio+0x63/0xb0
kernel: [ 1451.123281]  __submit_bio+0xe4/0x1c0
kernel: [ 1451.123292]  __submit_bio_noacct+0x90/0x230
kernel: [ 1451.123304]  submit_bio_noacct_nocheck+0x1ac/0x1f0
kernel: [ 1451.123318]  submit_bio_noacct+0x17f/0x5e0
kernel: [ 1451.123329]  submit_bio+0x4d/0x80
kernel: [ 1451.123337]  submit_bh_wbc+0x124/0x150
kernel: [ 1451.123350]  block_read_full_folio+0x33a/0x450
kernel: [ 1451.123363]  ? __pfx_blkdev_get_block+0x10/0x10
kernel: [ 1451.123379]  ? __pfx_blkdev_read_folio+0x10/0x10
kernel: [ 1451.123391]  blkdev_read_folio+0x18/0x30
kernel: [ 1451.123401]  filemap_read_folio+0x42/0xf0
kernel: [ 1451.123416]  filemap_update_page+0x1b7/0x280
kernel: [ 1451.123431]  filemap_get_pages+0x24f/0x3b0
kernel: [ 1451.123450]  filemap_read+0xe4/0x420
kernel: [ 1451.123463]  ? filemap_read+0x3d5/0x420
kernel: [ 1451.123484]  blkdev_read_iter+0x6d/0x160
kernel: [ 1451.123497]  vfs_read+0x20a/0x360
kernel: [ 1451.123517]  ksys_read+0x73/0x100
kernel: [ 1451.123531]  __x64_sys_read+0x19/0x30
kernel: [ 1451.123543]  do_syscall_64+0x59/0x90
kernel: [ 1451.123550]  ? do_syscall_64+0x68/0x90
kernel: [ 1451.123556]  ? syscall_exit_to_user_mode+0x37/0x60
kernel: [ 1451.123567]  ? do_syscall_64+0x68/0x90
kernel: [ 1451.123574]  ? syscall_exit_to_user_mode+0x37/0x60
kernel: [ 1451.123583]  ? do_syscall_64+0x68/0x90
kernel: [ 1451.123589]  ? syscall_exit_to_user_mode+0x37/0x60
kernel: [ 1451.123597]  ? do_syscall_64+0x68/0x90
kernel: [ 1451.123603]  ? do_user_addr_fault+0x17a/0x6b0
kernel: [ 1451.123612]  ? exit_to_user_mode_prepare+0x30/0xb0
kernel: [ 1451.123626]  ? irqentry_exit_to_user_mode+0x17/0x20
kernel: [ 1451.123635]  ? irqentry_exit+0x43/0x50
kernel: [ 1451.123643]  ? exc_page_fault+0x94/0x1b0
kernel: [ 1451.123652]  entry_SYSCALL_64_after_hwframe+0x6e/0xd8
kernel: [ 1451.123663] RIP: 0033:0x7f89e931a721
kernel: [ 1451.123713] RSP: 002b:00007fff8641dc48 EFLAGS: 00000246
ORIG_RAX: 0000000000000000
kernel: [ 1451.123723] RAX: ffffffffffffffda RBX: 0000559b1ebd94a0
RCX: 00007f89e931a721
kernel: [ 1451.123729] RDX: 0000000000000040 RSI: 0000559b1ebf2418
RDI: 000000000000000d
kernel: [ 1451.123735] RBP: 0000311ce7cf0000 R08: fffffffffffffe18
R09: 0000000000000070
kernel: [ 1451.123741] R10: 0000559b1ebf2810 R11: 0000000000000246
R12: 0000559b1ebf23f0
kernel: [ 1451.123747] R13: 0000000000000040 R14: 0000559b1ebd94f8
R15: 0000559b1ebf2408
kernel: [ 1451.123762]  </TASK>

Reads from just before the reshape position go fast at first, then
progress at about the speed of the reshape times four. I verified that
the first two btrfs superblock copies on the partition (at the start
of the drive and at 64MB) are readable and intact. The last one, at
256GB, is still past the reshape position and inaccessible.

Rebooting and re-assembling the array led to exactly the same
situation: The reshape is running and the beginning of the array is
readable. Reads after the reshape point time out or block
indefinitely.

The array contains data that will be difficult or impossible to
recover otherwise, so I would like not to lose the array's contents,
but accessing the data during this operation would also be really
useful. Is there a way to stop the reshape and revert the array to a
3+1 drive RAID5 to restore access to my data before a lengthy reshape
runs its course?

Thanks.

Matt
