Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC68D1CEE8D
	for <linux-raid@vger.kernel.org>; Thu, 10 Oct 2024 08:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728548763; cv=none; b=fLDjOmNoq2o5xrFHD/33pf9fh+Thxy+WW4EDiG7UAuJuwP7ma/zsF8WbAywyJraHaRodKeLtOogrC9Hvk2lM/OsfsekzYOBN5r3lQ5xkziv5fFVlEIhvF2XaYkOa7dPyxHxJW3nS1Ym1i7IdhrOxFzl77sL6IaSzMTopECfRhdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728548763; c=relaxed/simple;
	bh=QKKguWVsYT1uWC1n4wZUAUax1DsAkBLyj9Lv22xXKWo=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=XXXX+mAqfz0vUXzpoYWJE1hKCUlVCJYMm0rS/z1yI0m22Gz4besqS9KzuX3RqJ3B6IB987ZPqqg98g1TctlFrlDvm9RKrOp2s9t3lVeEobBLYkxvq4F0C6q9tBOBlR0LCB7jcQVA7wd46qR0b1VQEvj51GR9VASg+pk2rz7YRpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dZxqD7re; arc=none smtp.client-ip=209.85.167.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dZxqD7re"
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-5398e33155fso734437e87.3
        for <linux-raid@vger.kernel.org>; Thu, 10 Oct 2024 01:26:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728548760; x=1729153560; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:references
         :in-reply-to:user-agent:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=wPusLPIMRqlSkdfq1naMiU/nejRkMZaPSfAu75peylY=;
        b=dZxqD7reg4VlYbMYdDfzsrlXFXAXN07TzKT/cr8U7wjxO1jJVFK140q6jNoscgUnov
         asCMXbTlWbLNqQk9xfypIiAAixyiwrjRsDP6kyMk1Zor5zUGscUuQQnOnqL8aGj5Dpa8
         FlUH9okSt6SwrCV+zH0jz47AJi2PKVSoaWjyOUg1qXz5KRp57DhaisFqgWZBwxTCuR6O
         kYYz+ah2LwuLc5iTvJZdSjCWFvave1Uiyze0lZIrn47ngR3WfNLQov1uhK/29nCzFxRl
         d/NxCMoe9TcqTroU7k7i7w4Vxi6VP+x2KDCvOwjAuxYFpQsM7k88yo2kqge8oiABpaI9
         hG2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728548760; x=1729153560;
        h=content-transfer-encoding:mime-version:message-id:references
         :in-reply-to:user-agent:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wPusLPIMRqlSkdfq1naMiU/nejRkMZaPSfAu75peylY=;
        b=DH8mmbMttXUGc8Lfk5Xu5bwQT78ADhS/S21LtSzSBJHMRURUHFA9L1asE58CHUVhz7
         gZ5sPNJf3nic1j8Pb40Z9djy0Wgllxc4WlEl6Ve3b2TbgYD4+znywsPgxqtc4XLadetO
         tha/yjq+8UNnxoZKTGmjUYkWleqLw7fcKmWBGfhHmsYuOYtepVxX1BvTqmoeP4xfiLim
         f4PY65GxIefD9f5nW/GJqETmCefmbWrO87Tfd0NcxyiPT0YsdKrEZ2HH2pgDuPYh8kaK
         nYr7p8YkhoGcIbdOdBwKsb/fkb2CLqM+iiC8f2L1tZa6KTvo1aAC+oDpbOr9HoojEMkY
         bqdQ==
X-Gm-Message-State: AOJu0Yzvt1Qi7VE7qZmLOVsR5o5+rAK4N8Bzt44Mp1K6MSlssWoIQYFb
	OOzWHs9f4qj6v4SVO4aZ600XEp6yXHDN1v6isCx9ddM30fw1L+IXjkSnOg==
X-Google-Smtp-Source: AGHT+IES820/Wu57Py79mbCr3T8fc3dTM3wn3jG+bq/qox7Qd2zYCIB0rRPrniMRwKqd3KVnZygfUg==
X-Received: by 2002:a05:6512:2398:b0:539:945a:cb4a with SMTP id 2adb3069b0e04-539c48e12cdmr2830239e87.30.1728548759415;
        Thu, 10 Oct 2024 01:25:59 -0700 (PDT)
Received: from [127.0.0.1] (cpc92300-haye23-2-0-cust581.17-4.cable.virginm.net. [86.22.42.70])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-431182d794asm8668615e9.1.2024.10.10.01.25.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Oct 2024 01:25:59 -0700 (PDT)
Date: Thu, 10 Oct 2024 09:25:58 +0100
From: 19 Devices <19devices@gmail.com>
To: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
CC: linux-raid@vger.kernel.org
Subject: Re: Can't replace drive in imsm RAID 5 array, spare not shown
User-Agent: K-9 Mail for Android
In-Reply-To: <20241009120940.000004fa@linux.intel.com>
References: <E656D988-48EF-4428-AEB6-2F6D8677612B@gmail.com> <20241009120940.000004fa@linux.intel.com>
Message-ID: <540353C4-C36F-4A89-8417-F36B6D22A20F@gmail.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable



On 9 October 2024 11:09:40 BST, Mariusz Tkaczyk <mariusz=2Etkaczyk@linux=
=2Eintel=2Ecom> wrote:
>On Sun, 06 Oct 2024 07:00:18 +0100
>19 Devices <19devices@gmail=2Ecom> wrote:
>
>> Hi, I have a 4 drive imsm RAID 5 array which is working fine=2E  I want=
 to
>> remove one of the drives, sda, and replace it with a spare, sdc=2E  Fro=
m man
>> mdadm I understand that add - fail - remove is the way to go but this d=
oes
>> not work=2E
>>=20
>> Before:
>> $ cat /proc/mdstat
>> Personalities : [raid6] [raid5] [raid4]
>> md124 : active raid5 sdd[3] sdb[2] sda[1] sde[0]
>>       2831155200 blocks super external:/md126/0 level 5,
>>  128k chunk, algorithm 0 [4/4] [UUUU]
>>=20
>> md125 : active raid5 sdd[3] sdb[2] sda[1] sde[0]
>>       99116032 blocks super external:/md126/1 level 5, 1
>> 28k chunk, algorithm 0 [4/4] [UUUU]
>>=20
>> md126 : inactive sda[3](S) sdb[2](S) sdd[1](S) sde[0](S)
>>       14681 blocks super external:imsm
>>=20
>> unused devices: <none>
>>=20
>>=20
>> I can add (or add-spare) which increases the size of the container and =
though
>> I can't see any spare drives listed by mdadm, it appears as SPARE DISK =
in the
>> Intel option ROM after a reboot=2E
>>=20
>> $ sudo mdadm --zero-superblock /dev/sdc
>>=20
>> $ sudo mdadm /dev/md/imsm1 --add-spare /de
>> v/sdc
>> mdadm: added /dev/sdc
>>=20
>> $ cat /proc/mdstat
>> Personalities : [raid6] [raid5] [raid4]
>> md124 : active raid5 sdd[3] sdb[2] sda[1] sde[0]
>>       2831155200 blocks super external:/md126/0 level 5,
>>  128k chunk, algorithm 0 [4/4] [UUUU]
>>=20
>> md125 : active raid5 sdd[3] sdb[2] sda[1] sde[0]
>>       99116032 blocks super external:/md126/1 level 5, 1
>> 28k chunk, algorithm 0 [4/4] [UUUU]
>>=20
>> md126 : inactive sdc[4](S) sda[3](S) sdb[2](S) sdd[1](S) sde[0](S)
>>       15786 blocks super external:imsm
>>=20
>> unused devices: <none>
>> $
>>=20
>>=20
>> No spare devices listed here:
>>=20
>> $ sudo mdadm -D /dev/md/imsm1
>> /dev/md/imsm1:
>>            Version : imsm
>>         Raid Level : container
>>      Total Devices : 5
>>=20
>>    Working Devices : 5
>>=20
>>=20
>>               UUID : bdb7f495:21b8c189:e496c216:6f2d6c4c
>>      Member Arrays : /dev/md/md1_0 /dev/md/md0_0
>>=20
>>     Number   Major   Minor   RaidDevice
>>=20
>>        -       8       64        -        /dev/sde
>>        -       8       32        -        /dev/sdc
>>        -       8        0        -        /dev/sda
>>        -       8       48        -        /dev/sdd
>>        -       8       16        -        /dev/sdb
>> $
>>=20
>Hello,
>
>I know=2E It is fine=2E From container point of view these all are spares=
=2E
>Nobody ever complained about that so we did not fixed it :)
>The most important is that all drives are here=2E
>
>To detect spares you must compare this list with list from #mdadm --detai=
l
>/dev/md124 (member array)=2E Drives that are not used in member array are=
 spares=2E
>>=20
>> Trying to remove sda fails=2E
>>=20
>> $ sudo mdadm --fail /dev/md126 /dev/sda
>> mdadm: Cannot remove /dev/sda from /dev/md126, array will be failed=2E
>
>It might be an issue in mdadm, we added this and later we added fixes:
>
>Commit:
>https://git=2Ekernel=2Eorg/pub/scm/utils/mdadm/mdadm=2Egit/commit/?id=3Df=
c6fd4063769f4194c3fb8f77b32b2819e140fb9
>
>Fixes:
>https://git=2Ekernel=2Eorg/pub/scm/utils/mdadm/mdadm=2Egit/commit/?id=3Db=
3e7b7eb1dfedd7cbd9a3800e884941f67d94c96
>https://git=2Ekernel=2Eorg/pub/scm/utils/mdadm/mdadm=2Egit/commit/?id=3D4=
61fae7e7809670d286cc19aac5bfa861c29f93a
>
>but your release is mdadm-4=2E3, all fixes should be there=2E It might be=
 a new bug=2E
>
>Try:
>#mdadm -If sda
>but please do not abuse it (just use it one time because it may fail your
>array)=2E According to mdstat it should be safe in this case=2E
>
>If you can do some investigation, I would be tankful, I expect issues
>in enough() function=2E
>
>Thanks,
>Mariusz
>
>>=20
>> sda is 2TB, the others are 1TB - is that a problem?
>>=20
>> smartctl shows 2 drives don't support  SCT and it's disabled on the oth=
er 3=2E
>>=20
>> There's a very similar question here from Edwin in 2017:
>> https://unix=2Estackexchange=2Ecom/questions/372908/add-hot-spare-drive=
-to-intel-rst-onboard-raid#372920
>>=20
>> The only reply points to an Intel doc which uses the standard command t=
o add
>> a drive but doesn't show the result=2E
>>=20
>> $ uname -a
>> Linux Intel 6=2E9=2E2-arch1-1 #1 SMP PREEMPT_DYNAMIC Sun, 26
>>  May 2024 01:30:29 +0000 x86_64 GNU/Linux
>>=20
>> $ mdadm --version
>> mdadm - v4=2E3 - 2024-02-15
>>=20
>

---------------------------------------

Thank you Mariusz, that (--incremental --fail) worked:


# mdadm -If sda
mdadm: set sda faulty in md124
mdadm: set sda faulty in md125
mdadm: hot removed sda from md126

# cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md124 : active raid5 sdc[4] sdd[3] sdb[2] sde[0]
      2831155200 blocks super external:/md126/0 level 5,
 128k chunk, algorithm 0 [4/3] [UU_U]
      [>=2E=2E=2E=2E=2E=2E=2E=2E=2E=2E=2E=2E=2E=2E=2E=2E=2E=2E=2E=2E]  rec=
overy =3D  0=2E2% (2275456
/943718400) finish=3D222=2E5min speed=3D70515K/sec

md125 : active raid5 sdc[4] sdd[3] sdb[2] sde[0]
      99116032 blocks super external:/md126/1 level 5, 1
28k chunk, algorithm 0 [4/3] [UU_U]
        resync=3DDELAYED

md126 : inactive sdc[4](S) sdb[2](S) sdd[1](S) sde[0](S)
      10585 blocks super external:imsm

unused devices: <none>
#


# journalctl -f
kernel: md/raid:md124: Disk failure on sda, disabling device=2E
kernel: md/raid:md124: Operation continuing on 3 devices=2E
kernel: md/raid:md125: Disk failure on sda, disabling device=2E
kernel: md/raid:md125: Operation continuing on 3 devices=2E
kernel: md: recovery of RAID array md124
kernel: md: delaying recovery of md125 until md124 has finished (they shar=
e one or more physical units)
mdadm[628]: mdadm: Fail event detected on md device /dev/md125, component =
device /dev/sda
mdadm[628]: mdadm: RebuildStarted event detected on md device /dev/md124
Intel mdadm[628]: mdadm: Fail event detected on md device /dev/md124, comp=
onent device /dev/sda

---------------------------------------

ps=2E Belated thanks too for your solution to my previous problem here on =
2021/08/02=2E  That fix showed no sign it had succeeded until reboot but af=
ter that all was fine=2E
