Received: from mail-yw1-f180.google.com (mail-yw1-f180.google.com [209.85.128.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3A673D551
	for <linux-raid@vger.kernel.org>; Sun, 15 Sep 2024 19:37:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726429026; cv=none; b=p+LZgwMiX4Opg9sqqb3ZSIcByfh6lqQ7dr0+eEbK6fj+li7f/23GNMht9WvEcJaNNNnzdi3ArA0hwZeOOt4aAvUw0U7cjNxsVJLE6HBckkQvNnsOJn8MVXalzBipExYWOyqg2jfxBwaKBpFFBQijCkUtFGHsh7PTXO+uJh0d8fc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726429026; c=relaxed/simple;
	bh=O+QImrbQ5FaP+8SIi6TUKotzetKTunF6kXHjKVtvLAg=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=Hokymnnkgh5NK1wMkdZxrW8feTtP+5kq+xTk6sM3L5WtykunhPS9NGlpY4VwNvBN7JLJwRNJbJqtie8/dqs49qSFKY5tlvULyaomk1X5WUpDTooWPGuX0HKnaakIG9cwzK2PeI6xpkIJLVfuoEqheH8lrmxI8AYgcnAW1D3FnhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SYsDJ52O; arc=none smtp.client-ip=209.85.128.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SYsDJ52O"
Received: by mail-yw1-f180.google.com with SMTP id 00721157ae682-6d6e2b2fbc4so29828557b3.0
        for <linux-raid@vger.kernel.org>; Sun, 15 Sep 2024 12:37:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1726429023; x=1727033823; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=K61halTlacFi+7vNkG8yphM44T1alEe9/3Bwbi7mPsU=;
        b=SYsDJ52OwSN1Fm4mSgcycrZhaaUwsEGK48s+mK26WFhhAbHBIMJRHSQ5uDxyH3U4E2
         sBUuk8RSu6Zvqd/LZbTgyVMh6a5hrq1oWQQzGSreSz7i4Nclmq9jNRHZtkiEncPo3/64
         ZNNWP3FUc26wu/pB9ENB7DvsHK7ozRbUx+7tOrSXErasNQ3+uhpnSU4J04oXDfgFuj72
         M0chZS5wAoO9tCTCVtagU7sFnqt7s1/FIO9Jr9xOPYUoccWmgOwo0dMXvdhEXpgir5Mg
         6szF39hMGpPrsuqOjh0MHdGeNnFN2tm8QTtlBfl3okPAiyOnOR1IX8J+cKzbGBn6h6TS
         Uj4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726429023; x=1727033823;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=K61halTlacFi+7vNkG8yphM44T1alEe9/3Bwbi7mPsU=;
        b=V7bFt1hCpJgmmzKR8SZKJcKtq/8CG5hwlwEFtRIHHjGYgQdD3hsyR5KWAMOC9Uqfwu
         wjh7aqmyDd853aKP03qSrRJ+LgjJvPvs8GIBOfP5jSm8BuV5zecOdbTCoDusFpMtFRIl
         BL4VkWueYmJn8s3bJnH4+RTSuO9dFaRd+lV2HgQeQvI68k6SDcsFLXmq8O4SEyK2D4YQ
         0UKqhZnDgVpXc3h4ZkB1a0YP6GYIMnf/bqZS8JINWqiGcZEr/BMDT0dGyfc+h+p0HnWr
         9q2ZaL/6MmKy1vL9lIKl65uOCv+TM4NwAKpUmBs8/fjrFva6R+EOkoCFeaxrr/DEx0oO
         WBdA==
X-Gm-Message-State: AOJu0YxnOBX+XkpPHuGDq1A64FBbhgJgM58DFRiu01WzDCM9MpOV+lM1
	0SIrpQK2j5uE4KnAGEdEDHGaV8muv6z3WkHEusY5Svu5KW+lnR7rtM/DG6mAW9rlmDeGh+D28qT
	QSJGzTiQk3HJQ2vs0Z7UQy4boURiBZ7nj
X-Google-Smtp-Source: AGHT+IGk2rrKa5tiGHYM84mBE8UVQpTTrgqqDMmqvBSDs8TRTXOhKw0l5TgIEGPlwflKNbajiS0q/c7IJSkKdHDlilA=
X-Received: by 2002:a05:690c:dd1:b0:6dd:cfb8:c7e3 with SMTP id
 00721157ae682-6ddcfb8ce8bmr6712047b3.5.1726429023324; Sun, 15 Sep 2024
 12:37:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: William Morgan <therealbrewer@gmail.com>
Date: Sun, 15 Sep 2024 14:36:52 -0500
Message-ID: <CALc6PW6XU07kE7fyWzCnLXdDWs0UDGF6peg=kxxicATGB73wJw@mail.gmail.com>
Subject: RAID 10 reshape is stuck - please help
To: linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Hello,

I posted about this problem several months ago and unfortunately I
never received any suggestions. I haven't been able to fix the problem
on my own, so I am hoping someone here can help.

I have a raid10 array that originally consisted of 6x EXOS 16TB drives
connected through an LSI 9601-16e (SAS2116). Needing more space, I
added 4 more 16TB drives. I used the following commands to add and
grow the array:

[2024-06-24 19:38:12] sudo mdadm /dev/md2 --add /dev/sd[i-l]1
[2024-06-24 19:39:27] sudo mdadm --grow /dev/md2 --raid-devices=10

After 10-11 hours of reshaping (I knew it would take a long time), the
reshape seemed to freeze at 22.1% completed.

In dmesg I saw the following error:

[260007.679410] md: md2: reshape interrupted.
[260144.852441] INFO: task md2_reshape:242508 blocked for more than 122 seconds.
[260144.852459]       Tainted: G           OE 6.9.3-060903-generic #202405300957
[260144.852466] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[260144.852471] task:md2_reshape     state:D stack:0     pid:242508
tgid:242508 ppid:2      flags:0x00004000
[260144.852484] Call Trace:
[260144.852489]  <TASK>
[260144.852496]  __schedule+0x279/0x6a0
[260144.852512]  schedule+0x29/0xd0
[260144.852523]  wait_barrier.part.0+0x180/0x1e0 [raid10]
[260144.852544]  ? __pfx_autoremove_wake_function+0x10/0x10
[260144.852560]  wait_barrier+0x70/0xc0 [raid10]
[260144.852577]  raid10_sync_request+0x177e/0x19e3 [raid10]
[260144.852595]  ? __schedule+0x281/0x6a0
[260144.852605]  md_do_sync+0xa36/0x1390
[260144.852615]  ? __pfx_autoremove_wake_function+0x10/0x10
[260144.852628]  ? __pfx_md_thread+0x10/0x10
[260144.852635]  md_thread+0xa5/0x1a0
[260144.852643]  ? __pfx_md_thread+0x10/0x10
[260144.852649]  kthread+0xe4/0x110
[260144.852659]  ? __pfx_kthread+0x10/0x10
[260144.852667]  ret_from_fork+0x47/0x70
[260144.852675]  ? __pfx_kthread+0x10/0x10
[260144.852683]  ret_from_fork_asm+0x1a/0x30
[260144.852693]  </TASK>

Some other info which may be helpful:

bill@bill-desk:~$ mdadm --version
mdadm - v4.3 - 2024-02-15 - Ubuntu 4.3-1ubuntu2

bill@bill-desk:~$ uname -a
Linux bill-desk 6.9.3-060903-generic #202405300957 SMP PREEMPT_DYNAMIC
Thu May 30 11:39:13 UTC 2024 x86_64 x86_64 x86_64 GNU/Linux

bill@bill-desk:~$ sudo mdadm -D /dev/md2
/dev/md2:
           Version : 1.2
     Creation Time : Sat Nov 20 14:29:13 2021
        Raid Level : raid10
        Array Size : 46877236224 (43.66 TiB 48.00 TB)
     Used Dev Size : 15625745408 (14.55 TiB 16.00 TB)
      Raid Devices : 10
     Total Devices : 10
       Persistence : Superblock is persistent

     Intent Bitmap : Internal

       Update Time : Tue Jun 25 10:05:18 2024
             State : clean, reshaping
    Active Devices : 10
   Working Devices : 10
    Failed Devices : 0
     Spare Devices : 0

            Layout : near=2
        Chunk Size : 512K

Consistency Policy : bitmap

    Reshape Status : 22% complete
     Delta Devices : 4, (6->10)

              Name : bill-desk:2  (local to host bill-desk)
              UUID : 8a321996:5beb9c15:4c3fcf5b:6c8
b6005
            Events : 77923

    Number   Major   Minor   RaidDevice State
       0       8       65        0      active sync set-A   /dev/sde1
       1       8       81        1      active sync set-B   /dev/sdf1
       2       8       97        2      active sync set-A   /dev/sdg1
       3       8      113        3      active sync set-B   /dev/sdh1
       5       8      209        4      active sync set-A   /dev/sdn1
       4       8      193        5      active sync set-B   /dev/sdm1
       9       8      177        6      active sync set-A   /dev/sdl1
       8       8      161        7      active sync set-B   /dev/sdk1
       7       8      145        8      active sync set-A   /dev/sdj1
       6       8      129        9      active sync set-B   /dev/sdi1

bill@bill-desk:~$ cat /proc/mdstat
Personalities : [raid10] [raid0] [raid1] [raid6] [raid5] [raid4]
md1 : active raid10 sdd1[3] sdc1[2] sdb1[1] sda1[0]
      15627786240 blocks super 1.2 512K chunks 2 near-copies [4/4] [UUUU]
      bitmap: 0/117 pages [0KB], 65536KB chunk

md2 : active raid10 sdl1[9] sdk1[8] sdj1[7] sdi1[6] sdn1[5] sdh1[3]
sdf1[1] sde1[0] sdg1[2] sdm1[4]
      46877236224 blocks super 1.2 512K chunks 2 near-copies [10/10]
[UUUUUUUUUU]
      [====>................]  reshape = 22.1%
(10380906624/46877236224) finish=2322382.1min speed=261K/sec
      bitmap: 59/146 pages [236KB], 262144KB chunk

unused devices: <none>

In the meantime I have rebooted several times, done some system
software updates, etc. Nothing has improved or fixed it.

I just have no idea how to help this along. It won't finish the
reshape, and i can't mount the array to copy the data off. I have
enough spare disk space to copy the data to a temporary home if I
could access it, but the array won't mount. Or, I don't know if it is
safe to attempt to mount it. Recently one difference I've noticed is
that upon rebooting, the array is called md127 instead of md2 as
before.

BTW, md1 is an unrelated array on the same system, and it's working
fine. Upon reboot, the reshape begins, but 4 seconds later it is
interrupted:

[    2.451982] md/raid10:md1: active with 4 out of 4 devices
[    2.471053] md1: detected capacity change from 0 to 31255572480
[    2.517951] md/raid10:md127: not clean -- starting background reconstruction
[    2.517956] md/raid10:md127: active with 10 out of 10 devices
[    2.541203] md127: detected capacity change from 0 to 93754472448
[    2.928687] raid6: sse2x4   gen()  7064 MB/s
[    2.945680] raid6: sse2x2   gen()  8468 MB/s
[    2.962690] raid6: sse2x1   gen()  6369 MB/s
[    2.962691] raid6: using algorithm sse2x2 gen() 8468 MB/s
[    2.979680] raid6: .... xor() 7029 MB/s, rmw enabled
[    2.979682] raid6: using ssse3x2 recovery algorithm
[    5.946619] EXT4-fs (md1): mounted filesystem
8f645711-4d2b-42bf-877c-a8c993923a7c r/w with ordered data mode. Quota
mode: none.
[  401.676363] md: reshape of RAID array md127
[  405.049914] md: md127: reshape interrupted.
[  615.617649] INFO: task md127_reshape:5304 blocked for more than 122 seconds.
[  615.617684] task:md127_reshape   state:D stack:0     pid:5304
tgid:5304  ppid:2      flags:0x00004000
[  615.617747]  wait_barrier.part.0+0x188/0x1e0 [raid10]
[  615.617781]  wait_barrier+0x70/0xc0 [raid10]
[  615.617798]  raid10_sync_request+0x1545/0x183d [raid10]
[  615.617831]  md_do_sync.cold+0x609/0xa1f
[  615.617862]  md_thread+0xa3/0x1a0
[  615.617875]  ? __pfx_md_thread+0x10/0x10

The portion of dmesg that starts with INFO: repeats several times
every two minutes or so.

I really don't know what to do here. I've been struggling for a few
months trying to get it back to working with no success.

If the reshape isn't ultimately going to be successful, can anyone
explain how to at least mount the array safely so I can copy the data
off?

I can provide further info as needed.

Thank you,
Bill Morgan
