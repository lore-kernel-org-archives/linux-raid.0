Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC5FC1F8937
	for <linux-raid@vger.kernel.org>; Wed, 16 Apr 2025 20:41:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744836111; cv=none; b=QNC6yE//rBp61OEtn1MgnP8o4aaJbHAbYRIAhkguhsc45lTjy/YWnoIlB58gczBSmas8vVKpFGR4BGPkK4LZkb26BEDL5+meJoGd44NFESOX2Bwy7hXgd9eNmUdshPB4/QH0gGUKAhfH9crizz47NRX27QOjEftUuYUoGQSbpjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744836111; c=relaxed/simple;
	bh=i5V+g7WaEKVFJaLdyKyeTgbRQ4NXtfJ8nNRsosv5P5M=;
	h=From:Message-ID:Date:MIME-Version:Subject:To:Content-Type; b=fJ3ifhdhyf+VFLTnCOuhhjgtba7yuVooWKH93OR89vXQiYE/1srF77v4E7xYvx8DTLutYECcv536AjH/w5iNySTnmoqjMQCuhQlqWRsJeeJaNnQ+xP5fdLq6Vo+H4ed+z1lJB0+4Kmvl3Xk61DuhVsHJhVglL5ijFTPKbPYxxVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=O+CDkPw0; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="O+CDkPw0"
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-5f4c30f8570so179744a12.2
        for <linux-raid@vger.kernel.org>; Wed, 16 Apr 2025 13:41:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744836108; x=1745440908; darn=vger.kernel.org;
        h=content-transfer-encoding:to:subject:content-language:user-agent
         :mime-version:date:message-id:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=i5V+g7WaEKVFJaLdyKyeTgbRQ4NXtfJ8nNRsosv5P5M=;
        b=O+CDkPw0NupExHyfXNvygRX7S8vgzGfLTOhLmEWFix0sjVW7RkJNrHNkhi+JZVgBrC
         3DgJ6YUd2qZdRguYe6vog6dAY41BGdKi3eHotlswdeeNR22u6ZuHZ3Bm8/J3qQ2nhHHG
         /AyNXVVygjpoQpTvLF6vWRIvpVrQk5X44gr3C5/PhLcGID0QyJk4okhvKzyEtOSXFDAk
         ZoOOuKMV4xEingTsC3w7mgdXj0r4eRtou1u0wSdFzbKwDjcI1sgUGWSUc6zNwtK2mCss
         oTDm7SaSEQ7GX9WqrMrHh/gafZV4z6ABuRg7/dRkc/evdDuqd3d0sLtXk+j7nZx+96CF
         0APA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744836108; x=1745440908;
        h=content-transfer-encoding:to:subject:content-language:user-agent
         :mime-version:date:message-id:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=i5V+g7WaEKVFJaLdyKyeTgbRQ4NXtfJ8nNRsosv5P5M=;
        b=lsTZwD6LAWt2QR1oLiTu23XyReUInwWMAQJyBxMnl6ZeCYzB1SO+qFgkzgafYdTREs
         6HPCJwciIWQoXvu5XZSxeJe+btHQfwim0eB5KrqBmbYu4755PQBXumA1l7IiBt51n8XD
         b5WKUODMhfbahdc+XgcEnEZXEHTw3Qu1a4k9E8bWGIdf1OHOLIWZZTuvUZmETzTFwwA4
         Usl0moR67ND/aWuZH/jrJSqkqdoc9bNSJX2uAm5LCsg+l4WTrvB80yb1c0uK+2zKqkek
         a2pK3z3+49dFloZfx7wGy+u3k9U5907kkDLIF1kUNtnQEXazqHBYYUMMwxjXcjZjcf/P
         UWiw==
X-Gm-Message-State: AOJu0YzwR/pWNGXw6PYkfHU/3aMtcgwSRww2edwhffAi3akMjQbmeRIG
	tv8vNINKjMt6lRU7PiugJfBQTsL8VZU3owDReDMVdPvkX6TmboKwwxO/AQ==
X-Gm-Gg: ASbGncu37e9BZTBQLIoydrphak0A/NUsm4M4dYjk2xFRErfE8YX7PjHLaI2dTASm1rJ
	JXDk/yAkP6VpUofunPcTwO2qOQT5vTMRB9pcCnePM1yLBLxREQeTqXM6uz+6D2DjcL5sffyB8WR
	Qg26t6FpHU6ZaWl+RBQNA6WXTmW5Jb0eO9KHa17Z1SO3WoGVWGIvco3Gmz5XarpTwMFTMPqj9eN
	0VVf1hsIXTZjhvDh5xYBqZJ+vcl79n9HfDrp5GkQEbpFxDCR0XghH0VH6szmbfkBHRjAYSyEWSi
	4ASh27SQP5uOebSwNhjXLUEZXYdC3VlnK8pcDj/ArA5jVtLhSbmH1QpULim4+psN6GRUd2dOrAR
	5NmGUzKzGarlFukyp/W42c/jAnBmpgV3erEN4437g13RjB5xllGu7RQ==
X-Google-Smtp-Source: AGHT+IHnLl4CpMxRdcnb40HFo+aHMybpIaAIBKIGCVXOihLKkR6nj5Ed8W4ifMIt+v2OYANb+ig/PQ==
X-Received: by 2002:a17:907:7da3:b0:ac3:b44b:de24 with SMTP id a640c23a62f3a-acb42883216mr246582566b.2.1744836107554;
        Wed, 16 Apr 2025 13:41:47 -0700 (PDT)
Received: from [10.13.37.142] (dslb-088-065-113-200.088.065.pools.vodafone-ip.de. [88.65.113.200])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-acb3ce59962sm186849466b.78.2025.04.16.13.41.46
        for <linux-raid@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Apr 2025 13:41:47 -0700 (PDT)
From: Philipp Steinhardt <steinhardt.philipp@gmail.com>
X-Google-Original-From: Philipp Steinhardt <steinhardt.philipp+vger@gmail.com>
Message-ID: <0aef13fe-0356-4803-9f44-182c327d2dbf@gmail.com>
Date: Wed, 16 Apr 2025 22:41:45 +0200
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
Subject: raid5-cache / log / journal hung task during log replay
To: linux-raid@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Linux RAID team,

I'm encountering an issue when assembling an existing raid6 md software raid array with consistency policy journal. The mdadm assemble process (the write to md/array_state) seems to hang indefinitely in kernel.

Setup:
    kernel: Linux version 6.13.9-061309-generic
    distro: ubuntu 24.04
    mdadm:  v4.3 - 2024-02-15 - Ubuntu 4.3-1ubuntu2.1
    raid disks: 10x 16TB spinning rust
    journal device: 100G lvm2 lv on md raid1 array

The issue occurs during incremental assembly by udev / systemd as well as when assembling the array manually after boot via:
mdadm --assemble /dev/md123 /dev/disk/by-partlabel/hdd-raid6-? /dev/disk/ssd_raid1/hdd-raid6-journal

The problem initially occured after rebooting (from kernel 6.8.0-57-generic (ubuntu) to kernel 6.11 (ubuntu 24.04.2 hwe). Before the reboot the array was running for weeks with stripe_cache_size=32768 and journal_mode=writeback. The shutdown may have hung during the initial shutdown as well, but I do not have any logs for the shutdown,

On assemble the array seems to be written to for a while 10-20 seconds (I am guessing the journal is replayed) and than activity completely stops. During the replay the arrays stripe_cache_size is automatically raised to 32768.
Afterwards its not possibly to create any new md arrays (only tried mdadm create for now) even on unrelated backing devices. /proc/mdadm / mdadm --detail show the array in failed state with 10 spare devices. Superblocks seem to still be consistent and not updated and show the array with 10 active devices + journal.

When the hang occurs the state of the journal is as follows:

    * 160525 valid journal metablocks including journal tail (currently pointed to by superblock)
    * containing 2,347,779 4k data blocks
    * 313,931 2*4k parity blocks
    * 307,281 flushes

May be able to test on 6.14.2 on snapshots of the disks tomorrow and should be able provide the device superblocks and the part of the journal device currently pointed to by journal_tail (or any other missing information) if requested.

Same problem occurs on 6.8.0-57-generic (ubuntu), 6.11.0-21-generic (ubuntu) as well as 6.13.9-061309-generic (mainline). Dmesg / stacktrace for the latter is attached below:

> mdadm --assemble /dev/md123 /dev/disk/by-partlabel/hdd-raid6-? /dev/disk/ssd_raid1/hdd-raid6-journal
[ 2260.913878] kernel: md: md123 stopped.
[ 2261.229345] kernel: md/raid:md123: device sdd1 operational as raid disk 0
[ 2261.229351] kernel: md/raid:md123: device sdf1 operational as raid disk 9
[ 2261.229354] kernel: md/raid:md123: device sdl1 operational as raid disk 8
[ 2261.229356] kernel: md/raid:md123: device sdk1 operational as raid disk 7
[ 2261.229358] kernel: md/raid:md123: device sdi1 operational as raid disk 6
[ 2261.229360] kernel: md/raid:md123: device sdj1 operational as raid disk 5
[ 2261.229362] kernel: md/raid:md123: device sdc1 operational as raid disk 4
[ 2261.229364] kernel: md/raid:md123: device sdg1 operational as raid disk 3
[ 2261.229366] kernel: md/raid:md123: device sdh1 operational as raid disk 2
[ 2261.229368] kernel: md/raid:md123: device sde1 operational as raid disk 1
[ 2261.230770] kernel: md/raid:md123: raid level 6 active with 10 out of 10 devices, algorithm 2
[ 2459.072115] kernel: INFO: task mdadm:11089 blocked for more than 122 seconds.
[ 2459.072514] kernel:       Not tainted 6.13.9-061309-generic #202503282144
[ 2459.072526] kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 2459.072538] kernel: task:mdadm           state:D stack:0     pid:11089 tgid:11089 ppid:11088  flags:0x00004002
[ 2459.072544] kernel: Call Trace:
[ 2459.072546] kernel:  <TASK>
[ 2459.072551] kernel:  __schedule+0x2b8/0x630
[ 2459.072558] kernel:  schedule+0x29/0xd0
[ 2459.072562] kernel:  raid5_get_active_stripe+0x277/0x300 [raid456]
[ 2459.072571] kernel:  ? __pfx_autoremove_wake_function+0x10/0x10
[ 2459.072575] kernel:  r5c_recovery_analyze_meta_block+0x5e6/0x690 [raid456]
[ 2459.072583] kernel:  r5c_recovery_flush_log+0xc5/0x250 [raid456]
[ 2459.072589] kernel:  r5l_recovery_log+0x118/0x260 [raid456]
[ 2459.072594] kernel:  ? srso_alias_return_thunk+0x5/0xfbef5
[ 2459.072600] kernel:  r5l_load_log+0x1dd/0x240 [raid456]
[ 2459.072606] kernel:  r5l_start+0x1d/0x90 [raid456]
[ 2459.072612] kernel:  raid5_start+0x18/0x20 [raid456]
[ 2459.072617] kernel:  md_start+0x32/0x60
[ 2459.072620] kernel:  do_md_run+0x7c/0x120
[ 2459.072624] kernel:  array_state_store+0x3e8/0x470
[ 2459.072628] kernel:  md_attr_store+0x8e/0x100
[ 2459.072633] kernel:  sysfs_kf_write+0x3e/0x60
[ 2459.072636] kernel:  kernfs_fop_write_iter+0x14c/0x1f0
[ 2459.072640] kernel:  vfs_write+0x29c/0x460
[ 2459.072647] kernel:  ksys_write+0x70/0xf0
[ 2459.072651] kernel:  __x64_sys_write+0x19/0x30
[ 2459.072654] kernel:  x64_sys_call+0x2a3/0x2310
[ 2459.072659] kernel:  do_syscall_64+0x7e/0x170
[ 2459.072664] kernel:  ? srso_alias_return_thunk+0x5/0xfbef5
[ 2459.072667] kernel:  ? putname+0x60/0x80
[ 2459.072671] kernel:  ? srso_alias_return_thunk+0x5/0xfbef5
[ 2459.072674] kernel:  ? do_sys_openat2+0xa4/0xf0
[ 2459.072678] kernel:  ? srso_alias_return_thunk+0x5/0xfbef5
[ 2459.072682] kernel:  ? arch_exit_to_user_mode_prepare.isra.0+0x22/0xd0
[ 2459.072685] kernel:  ? srso_alias_return_thunk+0x5/0xfbef5
[ 2459.072689] kernel:  ? syscall_exit_to_user_mode+0x38/0x1d0
[ 2459.072692] kernel:  ? srso_alias_return_thunk+0x5/0xfbef5
[ 2459.072695] kernel:  ? do_syscall_64+0x8a/0x170
[ 2459.072699] kernel:  ? srso_alias_return_thunk+0x5/0xfbef5
[ 2459.072702] kernel:  ? arch_exit_to_user_mode_prepare.isra.0+0x22/0xd0
[ 2459.072705] kernel:  ? srso_alias_return_thunk+0x5/0xfbef5
[ 2459.072708] kernel:  ? syscall_exit_to_user_mode+0x38/0x1d0
[ 2459.072711] kernel:  ? srso_alias_return_thunk+0x5/0xfbef5
[ 2459.072715] kernel:  ? do_syscall_64+0x8a/0x170
[ 2459.072717] kernel:  ? srso_alias_return_thunk+0x5/0xfbef5
[ 2459.072720] kernel:  ? __wake_up+0x45/0x70
[ 2459.072724] kernel:  ? srso_alias_return_thunk+0x5/0xfbef5
[ 2459.072727] kernel:  ? md_wakeup_thread+0x54/0x90
[ 2459.072730] kernel:  ? srso_alias_return_thunk+0x5/0xfbef5
[ 2459.072733] kernel:  ? __mddev_resume+0x7f/0xa0
[ 2459.072736] kernel:  ? srso_alias_return_thunk+0x5/0xfbef5
[ 2459.072739] kernel:  ? md_ioctl+0x488/0x9e0
[ 2459.072743] kernel:  ? srso_alias_return_thunk+0x5/0xfbef5
[ 2459.072746] kernel:  ? rseq_get_rseq_cs+0x22/0x240
[ 2459.072750] kernel:  ? srso_alias_return_thunk+0x5/0xfbef5
[ 2459.072753] kernel:  ? rseq_ip_fixup+0x8d/0x1e0
[ 2459.072757] kernel:  ? srso_alias_return_thunk+0x5/0xfbef5
[ 2459.072760] kernel:  ? restore_fpregs_from_fpstate+0x3d/0xd0
[ 2459.072764] kernel:  ? srso_alias_return_thunk+0x5/0xfbef5
[ 2459.072767] kernel:  ? switch_fpu_return+0x4f/0xe0
[ 2459.072770] kernel:  ? srso_alias_return_thunk+0x5/0xfbef5
[ 2459.072773] kernel:  ? arch_exit_to_user_mode_prepare.isra.0+0xc8/0xd0
[ 2459.072776] kernel:  ? srso_alias_return_thunk+0x5/0xfbef5
[ 2459.072779] kernel:  ? syscall_exit_to_user_mode+0x38/0x1d0
[ 2459.072782] kernel:  ? srso_alias_return_thunk+0x5/0xfbef5
[ 2459.072785] kernel:  ? do_syscall_64+0x8a/0x170
[ 2459.072788] kernel:  ? srso_alias_return_thunk+0x5/0xfbef5
[ 2459.072791] kernel:  ? do_syscall_64+0x8a/0x170
[ 2459.072793] kernel:  ? srso_alias_return_thunk+0x5/0xfbef5
[ 2459.072796] kernel:  ? do_syscall_64+0x8a/0x170
[ 2459.072799] kernel:  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[ 2459.072802] kernel: RIP: 0033:0x77220111c574
[ 2459.072806] kernel: RSP: 002b:00007fff30657198 EFLAGS: 00000202 ORIG_RAX: 0000000000000001
[ 2459.072810] kernel: RAX: ffffffffffffffda RBX: 0000000000000005 RCX: 000077220111c574
[ 2459.072812] kernel: RDX: 0000000000000008 RSI: 000055fd6e331b8d RDI: 0000000000000005
[ 2459.072814] kernel: RBP: 00007fff30657240 R08: 0000000000000073 R09: 0000000000000000
[ 2459.072815] kernel: R10: 0000000000000000 R11: 0000000000000202 R12: 000055fd6e331b8d
[ 2459.072817] kernel: R13: 000055fda6505040 R14: 0000000000000000 R15: 000055fda6504c70
[ 2459.072823] kernel:  </TASK>

