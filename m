Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B3A617C7BF
	for <linux-raid@vger.kernel.org>; Tue, 25 Jun 2024 22:08:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719353304; cv=none; b=NNVx8JtwJOT5GdwB0UFMvDoetxvC5axxg80p7HN10S2wlSGuuswWpD+W8ZAXVAf3RQwCHywwGj6eA0XCrMobZp41KB6eh4jIU5v2GxgJ51XT/SCsfN+n9K57I8VRy4FcF/CpD2vZao0AokyAOh0YFYNnbpoPNXUmFAHpslhk/gw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719353304; c=relaxed/simple;
	bh=5qUqjHTWbZfk78EvGKdNmxn0rQcTWNcwNsS7t/VODkc=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=rwNaEK8Q2qfbX13f0Tahf9ygQIvD4FftlnmqMzvCNanJ7VFAO55Zk2g3bZLj+0XcA5uPepo/zi0hcaRacqYnjwp+qQTKYF6NcemYLIWkYRTd425JN8yNQsN9RGBL5V8ELcPLoYCDPezShND4gkazZvCypar1C2IJYIXGkIQ655s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gM40vV8e; arc=none smtp.client-ip=209.85.222.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gM40vV8e"
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-79c05c19261so62631785a.0
        for <linux-raid@vger.kernel.org>; Tue, 25 Jun 2024 15:08:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1719353302; x=1719958102; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=OSupqonRSwzaGMIvZKOT6dPgB5BmDDdvjGsBd/foKNQ=;
        b=gM40vV8elrR9K/dMuwFDKvtp2Tdzdt+dm+qQHxcfSSpBzD/Q2CSIWv/N6Li9sq9HcA
         F8dTN4rJOvdtxJTKOtHI8XDXstXAItqB2RWFNfIAiqHpBpUHiRvGDrpJ4qloZ3n5T2kx
         5gBgtjyyv94ZjVsCgt5l507cYXLIzVAnyY6EzKSIm9NHDGU4BN+H5Wrf0V0acEqBe/7A
         7IG7rdYelcbThEZVCXojkkI3IVz3nnSSZMtDRcZMl3xM1xNb/Vysn1Y67AG4enboTDnx
         gLZDmJ8SiiyrsUeeHX9gx3ux4cRLdShAXizrq3W39oJphNv5xBxuppJ5uaykY7aem+zL
         1lvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719353302; x=1719958102;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OSupqonRSwzaGMIvZKOT6dPgB5BmDDdvjGsBd/foKNQ=;
        b=kCHzElx93IUvJo8S0kW1kNySBTIqAte8mbx568p8hBQi7fYBKUrrqlYVCQ8nn1hy0t
         ah/XoalkAYC8JHkXRrDV+37YHDIRyvENo42BTqxcfNGsxtIjFDKDaJPii5hGRqf8wFNL
         oYgBgFdXxrZx7KG19eVxga9Fw71G16Kne2vivyoF7O1fqLxo9l5EJOtt1CWCt+VQ8qBj
         6Ka7BtGn62La/Wc4ygQFhG24cyUWiW9PZR08tZkFMweNSLPgGCuWOxYx9sDQg/aDQJok
         WL5QMr9nu1hGLUWPX9UVN78QS6fwzyxWsmklhuGFz+D+Ztuj4GkhZlGx7Tvjh/HO53zw
         1MXQ==
X-Gm-Message-State: AOJu0Yy83tP/WRDY/HcODW4Y9Pd4SgrECYrNrNXKhZq0B16qrO0cTTDy
	Oy1uK+kBagMTQDAOFO02KRSCrOUCuw9eJAG22hjaFN5q7dRpNE6wgtJApSlHtkWFUouq3FEMF9E
	zklIo0s5XzsZ7u3/zSaDQXzSnOZOUeBMc
X-Google-Smtp-Source: AGHT+IHt5hSoBokX/kxgG8jiKzqa/3K05hVE329JzX1+6gzOdZTe8qOyrQSG7MTJCD37zy9IJp/qgVJbgeuSMfzlw7Q=
X-Received: by 2002:a05:6214:528d:b0:6b0:81f7:392c with SMTP id
 6a1803df08f44-6b53bbbe8b8mr134048226d6.13.1719353301817; Tue, 25 Jun 2024
 15:08:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: William Morgan <therealbrewer@gmail.com>
Date: Tue, 25 Jun 2024 17:08:11 -0500
Message-ID: <CALc6PW4A6Q4q3tU7AMA3MArpiRwkTwXrb__2k2Xwzy3=-XE+7A@mail.gmail.com>
Subject: reshape seems to have gotten stuck
To: linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Hello,

I have sought help here before, so I hope this is still the correct place.

I have an existing array of 6x Exos X16 drives in Raid10 connected
through an LSI 9601-16e (SAS2116). As free space was getting a bit
low, I added 4x Exos X18 drives of the same capacity. I started the
reshape which initially said roughly 2.5 days to finish, which I
expected and understood - not my first reshape rodeo. This morning I
checked after approximately 10 hours and the reshape was 20% completed
with a corresponding reduction in the time-to-finish estimate -
everything was looking good. This afternoon I checked again and
noticed that something has gone wrong. It has been ~8 more hours since
this mornings' check, but the reshape is only at 22% complete. And the
estimate of time to finish has gone through the roof. I checked dmesg
and I see 10 errors of this type:

[260007.679410] md: md2: reshape interrupted.
[260144.852441] INFO: task md2_reshape:242508 blocked for more than 122 seconds.
[260144.852459]       Tainted: G           OE
6.9.3-060903-generic #202405300957
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

Some other info:

bill@bill-desk:~$ mdadm --version
mdadm - v4.3 - 2024-02-15 - Ubuntu 4.3-1ubuntu2
md1: [UUUU]
md2: [UUUUUUUUUU]
bill@bill-desk:~$ uname -a
Linux bill-desk 6.9.3-060903-generic #202405300957 SMP PREEMPT_DYNAMIC
Thu May 30 11:39:13 UTC 2024 x86_64 x86_64 x86_64 GNU/Linux
md1: [UUUU]
md2: [UUUUUUUUUU]
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
              UUID : 8a321996:5beb9c15:4c3fcf5b:6c8b6005
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
md1: [UUUU]
md2: [UUUUUUUUUU]
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


So what I'd like to know is how to proceed. Should I interrupt the
reshape and start it again, or...? If I restart, will mdadm know how
to pick up where it left off? Is it OK to reboot before restarting?

Of course I can supply any additional info that may be needed.

Cheers and thanks,
Bill
