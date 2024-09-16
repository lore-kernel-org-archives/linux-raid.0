Received: from mail-yw1-f180.google.com (mail-yw1-f180.google.com [209.85.128.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BA4EA94F
	for <linux-raid@vger.kernel.org>; Mon, 16 Sep 2024 02:48:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726454883; cv=none; b=sKRxOBSjtf25O49CNnr7cPJnk+/LatZ0QypI9sMZ2wiBrR8Fol3GZ9Oy51Ta+YvlgkllK2yaF3zf5lXAn7QJElzLWIrKh1nyoiHMQq3PXyUJ3GemijDG/M85vafmEkO2wBmLfZ28QkoEvl23EZZm6IIu6TDOF7hDiYbGMVscy0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726454883; c=relaxed/simple;
	bh=HhkS5V1UUxixoVuNFUsdfrOeeZ2MpZI3CwXlruUqYU4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=k5kxGOqVWst5ocqT6qbkEnSQR1QHHsiAYWXKZRae4kPeGwzX1KHFW2wAd9cXAJNV/Y5hSPK81lm8fZdxMmvQMHouKa8QrfCe8CjCpkD0NGq5RHjFIxgY3YdaLPnA/Ey3GBGMK6g/YHsCuAFtfFYkuZc+Z66uLjC6y17gDW0GZ3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=S/Z1aZyT; arc=none smtp.client-ip=209.85.128.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="S/Z1aZyT"
Received: by mail-yw1-f180.google.com with SMTP id 00721157ae682-6ddce91cab2so4038587b3.0
        for <linux-raid@vger.kernel.org>; Sun, 15 Sep 2024 19:48:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1726454881; x=1727059681; darn=vger.kernel.org;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b07S1XIFVeXWFuBjYMrfZxRSE08Fxkh8tOI+XJQE+HI=;
        b=S/Z1aZyT6dIR6nQ4wgQR8cUIbL6kRJY1hLAcNV/6o83yMr0wXo+CMbD/sUUA+8Gbcs
         UzeaE0n26TC5FZwT+z8xt2qxYzIKDJezl54BFGQTXcsJGeXEecGWahxK/9kLu8grEdL8
         XrmZtcyVX1J8/QyHIlysXppKLmsusVHIlxgutp+fyuBgvTjd6snhW+ByE4xFX44krkTQ
         FWDJyxi1g6n53m7N0ChBbTwszI6EZm1BcNkpAB5TaSWtFE2hiaWuDcRFazTxVZ27BQxT
         YM28jLoYpMrDNG4jrHXV/UOqjYKXiF48U1yrvGwfEgJ73B2lF3on02S8zU5efOu+KFl/
         oKow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726454881; x=1727059681;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=b07S1XIFVeXWFuBjYMrfZxRSE08Fxkh8tOI+XJQE+HI=;
        b=wAV+bTn6XhI/WRhfxry6SAcnrKsFxSutr7eJQ+GiwftgcpXM3e3gKnbZL1dEjPSsmi
         kflqQpmh5z4Zo+zjawOQTN8fxdOFwzhL/YMmppCvKNdIS8Z2SiBcCUDb3NbrJHAyGN+e
         pH3VigQ0699S9Um1YBvNcLXROizie2/yXwz/m77jOwAnKtStZs7IT/D94FQOh8pXllDz
         LIbHDOGRn+a83g/ih7P4eHNq1AKsVpCAyd8JEhLIXOt6/mDnV4ubBq/YARwaNEaSKXYp
         8q3sQXFcFUTNINCTtIbte3y4+B1FND0doe4cTLh+wed2cwdNl9/5v3HPzF8mKs1wcmwE
         dI6A==
X-Gm-Message-State: AOJu0YwNSuPaENSdtq8EOTEGDo8P0BfBffB+Q/+nsbWnkHSkY3+FWDv2
	Xc6D14J10do6Z4Fb9qGRhyRMsRPiIEjz/MfQu3O+9ThrlDYT6KBVS+IjE34Dle9Rv3dqR7rl8V+
	nc0Brglt8l14LQ9gNWHPfbnmEH1RBPClK
X-Google-Smtp-Source: AGHT+IF1ZvSiS39fuBCoM5OIHrNaW1cwCzna8foesjTUdJI9DvLoawQV2Yr72446T2roGyLaOGoSWazZjyFGSfnSlks=
X-Received: by 2002:a05:690c:4882:b0:6b0:2031:6414 with SMTP id
 00721157ae682-6dbb6b246f9mr128292837b3.24.1726454880775; Sun, 15 Sep 2024
 19:48:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CALc6PW6XU07kE7fyWzCnLXdDWs0UDGF6peg=kxxicATGB73wJw@mail.gmail.com>
In-Reply-To: <CALc6PW6XU07kE7fyWzCnLXdDWs0UDGF6peg=kxxicATGB73wJw@mail.gmail.com>
From: William Morgan <therealbrewer@gmail.com>
Date: Sun, 15 Sep 2024 21:47:49 -0500
Message-ID: <CALc6PW6XayCCkRHK=okVJs13Vy-XSFjBEixCvSVjYdYy6AK-gA@mail.gmail.com>
Subject: Re: RAID 10 reshape is stuck - please help
To: linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

A suggestion was made by Dragan Milivojevi=C4=87 to try booting a liveOS
with the same kernel and mdadm version from the time the array was
originally made. That would have been Ubuntu 21.10, with kernel 5.13,
and mdadm v4.2. (That conversation isn't archived here because we
forgot to hit reply all.)

I was able to complete this task but unfortunately I am afraid it made
no difference at all. Exactly the same behavior is seen.

I'm going to try to enable more verbose logging from my HBA controller.

On Sun, Sep 15, 2024 at 2:36=E2=80=AFPM William Morgan <therealbrewer@gmail=
.com> wrote:
>
> Hello,
>
> I posted about this problem several months ago and unfortunately I
> never received any suggestions. I haven't been able to fix the problem
> on my own, so I am hoping someone here can help.
>
> I have a raid10 array that originally consisted of 6x EXOS 16TB drives
> connected through an LSI 9601-16e (SAS2116). Needing more space, I
> added 4 more 16TB drives. I used the following commands to add and
> grow the array:
>
> [2024-06-24 19:38:12] sudo mdadm /dev/md2 --add /dev/sd[i-l]1
> [2024-06-24 19:39:27] sudo mdadm --grow /dev/md2 --raid-devices=3D10
>
> After 10-11 hours of reshaping (I knew it would take a long time), the
> reshape seemed to freeze at 22.1% completed.
>
> In dmesg I saw the following error:
>
> [260007.679410] md: md2: reshape interrupted.
> [260144.852441] INFO: task md2_reshape:242508 blocked for more than 122 s=
econds.
> [260144.852459]       Tainted: G           OE 6.9.3-060903-generic #20240=
5300957
> [260144.852466] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [260144.852471] task:md2_reshape     state:D stack:0     pid:242508
> tgid:242508 ppid:2      flags:0x00004000
> [260144.852484] Call Trace:
> [260144.852489]  <TASK>
> [260144.852496]  __schedule+0x279/0x6a0
> [260144.852512]  schedule+0x29/0xd0
> [260144.852523]  wait_barrier.part.0+0x180/0x1e0 [raid10]
> [260144.852544]  ? __pfx_autoremove_wake_function+0x10/0x10
> [260144.852560]  wait_barrier+0x70/0xc0 [raid10]
> [260144.852577]  raid10_sync_request+0x177e/0x19e3 [raid10]
> [260144.852595]  ? __schedule+0x281/0x6a0
> [260144.852605]  md_do_sync+0xa36/0x1390
> [260144.852615]  ? __pfx_autoremove_wake_function+0x10/0x10
> [260144.852628]  ? __pfx_md_thread+0x10/0x10
> [260144.852635]  md_thread+0xa5/0x1a0
> [260144.852643]  ? __pfx_md_thread+0x10/0x10
> [260144.852649]  kthread+0xe4/0x110
> [260144.852659]  ? __pfx_kthread+0x10/0x10
> [260144.852667]  ret_from_fork+0x47/0x70
> [260144.852675]  ? __pfx_kthread+0x10/0x10
> [260144.852683]  ret_from_fork_asm+0x1a/0x30
> [260144.852693]  </TASK>
>
> Some other info which may be helpful:
>
> bill@bill-desk:~$ mdadm --version
> mdadm - v4.3 - 2024-02-15 - Ubuntu 4.3-1ubuntu2
>
> bill@bill-desk:~$ uname -a
> Linux bill-desk 6.9.3-060903-generic #202405300957 SMP PREEMPT_DYNAMIC
> Thu May 30 11:39:13 UTC 2024 x86_64 x86_64 x86_64 GNU/Linux
>
> bill@bill-desk:~$ sudo mdadm -D /dev/md2
> /dev/md2:
>            Version : 1.2
>      Creation Time : Sat Nov 20 14:29:13 2021
>         Raid Level : raid10
>         Array Size : 46877236224 (43.66 TiB 48.00 TB)
>      Used Dev Size : 15625745408 (14.55 TiB 16.00 TB)
>       Raid Devices : 10
>      Total Devices : 10
>        Persistence : Superblock is persistent
>
>      Intent Bitmap : Internal
>
>        Update Time : Tue Jun 25 10:05:18 2024
>              State : clean, reshaping
>     Active Devices : 10
>    Working Devices : 10
>     Failed Devices : 0
>      Spare Devices : 0
>
>             Layout : near=3D2
>         Chunk Size : 512K
>
> Consistency Policy : bitmap
>
>     Reshape Status : 22% complete
>      Delta Devices : 4, (6->10)
>
>               Name : bill-desk:2  (local to host bill-desk)
>               UUID : 8a321996:5beb9c15:4c3fcf5b:6c8
> b6005
>             Events : 77923
>
>     Number   Major   Minor   RaidDevice State
>        0       8       65        0      active sync set-A   /dev/sde1
>        1       8       81        1      active sync set-B   /dev/sdf1
>        2       8       97        2      active sync set-A   /dev/sdg1
>        3       8      113        3      active sync set-B   /dev/sdh1
>        5       8      209        4      active sync set-A   /dev/sdn1
>        4       8      193        5      active sync set-B   /dev/sdm1
>        9       8      177        6      active sync set-A   /dev/sdl1
>        8       8      161        7      active sync set-B   /dev/sdk1
>        7       8      145        8      active sync set-A   /dev/sdj1
>        6       8      129        9      active sync set-B   /dev/sdi1
>
> bill@bill-desk:~$ cat /proc/mdstat
> Personalities : [raid10] [raid0] [raid1] [raid6] [raid5] [raid4]
> md1 : active raid10 sdd1[3] sdc1[2] sdb1[1] sda1[0]
>       15627786240 blocks super 1.2 512K chunks 2 near-copies [4/4] [UUUU]
>       bitmap: 0/117 pages [0KB], 65536KB chunk
>
> md2 : active raid10 sdl1[9] sdk1[8] sdj1[7] sdi1[6] sdn1[5] sdh1[3]
> sdf1[1] sde1[0] sdg1[2] sdm1[4]
>       46877236224 blocks super 1.2 512K chunks 2 near-copies [10/10]
> [UUUUUUUUUU]
>       [=3D=3D=3D=3D>................]  reshape =3D 22.1%
> (10380906624/46877236224) finish=3D2322382.1min speed=3D261K/sec
>       bitmap: 59/146 pages [236KB], 262144KB chunk
>
> unused devices: <none>
>
> In the meantime I have rebooted several times, done some system
> software updates, etc. Nothing has improved or fixed it.
>
> I just have no idea how to help this along. It won't finish the
> reshape, and i can't mount the array to copy the data off. I have
> enough spare disk space to copy the data to a temporary home if I
> could access it, but the array won't mount. Or, I don't know if it is
> safe to attempt to mount it. Recently one difference I've noticed is
> that upon rebooting, the array is called md127 instead of md2 as
> before.
>
> BTW, md1 is an unrelated array on the same system, and it's working
> fine. Upon reboot, the reshape begins, but 4 seconds later it is
> interrupted:
>
> [    2.451982] md/raid10:md1: active with 4 out of 4 devices
> [    2.471053] md1: detected capacity change from 0 to 31255572480
> [    2.517951] md/raid10:md127: not clean -- starting background reconstr=
uction
> [    2.517956] md/raid10:md127: active with 10 out of 10 devices
> [    2.541203] md127: detected capacity change from 0 to 93754472448
> [    2.928687] raid6: sse2x4   gen()  7064 MB/s
> [    2.945680] raid6: sse2x2   gen()  8468 MB/s
> [    2.962690] raid6: sse2x1   gen()  6369 MB/s
> [    2.962691] raid6: using algorithm sse2x2 gen() 8468 MB/s
> [    2.979680] raid6: .... xor() 7029 MB/s, rmw enabled
> [    2.979682] raid6: using ssse3x2 recovery algorithm
> [    5.946619] EXT4-fs (md1): mounted filesystem
> 8f645711-4d2b-42bf-877c-a8c993923a7c r/w with ordered data mode. Quota
> mode: none.
> [  401.676363] md: reshape of RAID array md127
> [  405.049914] md: md127: reshape interrupted.
> [  615.617649] INFO: task md127_reshape:5304 blocked for more than 122 se=
conds.
> [  615.617684] task:md127_reshape   state:D stack:0     pid:5304
> tgid:5304  ppid:2      flags:0x00004000
> [  615.617747]  wait_barrier.part.0+0x188/0x1e0 [raid10]
> [  615.617781]  wait_barrier+0x70/0xc0 [raid10]
> [  615.617798]  raid10_sync_request+0x1545/0x183d [raid10]
> [  615.617831]  md_do_sync.cold+0x609/0xa1f
> [  615.617862]  md_thread+0xa3/0x1a0
> [  615.617875]  ? __pfx_md_thread+0x10/0x10
>
> The portion of dmesg that starts with INFO: repeats several times
> every two minutes or so.
>
> I really don't know what to do here. I've been struggling for a few
> months trying to get it back to working with no success.
>
> If the reshape isn't ultimately going to be successful, can anyone
> explain how to at least mount the array safely so I can copy the data
> off?
>
> I can provide further info as needed.
>
> Thank you,
> Bill Morgan
