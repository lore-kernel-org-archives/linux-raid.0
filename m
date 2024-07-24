Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70668139584;
	Wed, 24 Jul 2024 21:19:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721855949; cv=none; b=N7CXcgYHSWjOwVXDY0QDW648Djel9+C68RvHjLmugo/nZoILV02vTB1PBN31TSD9ixmRa2+iSogumoqusm5ljoDimioO7S8AYa3AhOG/kiriTgXl5zcwMr4z8rD4EaA0GGEJgfiWTYGbVE/3bDUIzu5sTQabGV9Tl1uIJrSXhrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721855949; c=relaxed/simple;
	bh=Rf3ofJ44AlVV1dPimKk0+4Py8+cmXRDlHMG27neCr7U=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=e92uiH/53gnCi5umyrI/Zm2eaPLyzZYEwa7y82FO+rf/wAc21wDNRisKjJmGGbVnblSViYWQ86Vc3wRisEMrzqrJbm7FWElTUxTq7Z3nS33pAAGph2LjmvzuVIPjait57evK4k23Rf4S65euzjpDV0EAIq3R0uF28X6CR6L26Kk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=korfD63c; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="korfD63c"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721855949; x=1753391949;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Rf3ofJ44AlVV1dPimKk0+4Py8+cmXRDlHMG27neCr7U=;
  b=korfD63cqrTXtiJcomf41tDGzdwMENfcZ5jCiA11koRUXtR23WdJwZdp
   z1V1Ur2LilXzrjQtI+JOsr3jv/X2vgEWwLgkUZifOxQ3SidR2f21TcVEt
   li46PDIMANKZZfeoAnhI0rfTryoQQ3MMcIVx5OhC62utPwYEptnQKHx5Q
   SH/8sPnsNU0l1AIKqBSOO54ITwZ+1z7gHo4SKLkpQIWHmXuz1QqlxPBo7
   25fk6tXBe/o5JqOjN3t2PJpqiL774EhDsWAN/0AlaTIZhzyvZOkwTeZk6
   01PrrphS+szqznlb5SDG+tqoLnZa7R8SZJev0TJBY7grZQPSSOtogtpsQ
   g==;
X-CSE-ConnectionGUID: 5AHSCSZCSEGAWPtuGzu9xQ==
X-CSE-MsgGUID: QgQhe6P+Qg2916sTbznuXg==
X-IronPort-AV: E=McAfee;i="6700,10204,11143"; a="30166462"
X-IronPort-AV: E=Sophos;i="6.09,233,1716274800"; 
   d="scan'208";a="30166462"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jul 2024 14:19:08 -0700
X-CSE-ConnectionGUID: D6nXxjbdS+CKaipP0Gibtg==
X-CSE-MsgGUID: aJivT/zMQHGia5vDZSidvA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,233,1716274800"; 
   d="scan'208";a="75940094"
Received: from srpatil1-mobl.amr.corp.intel.com (HELO peluse-desk5) ([10.212.62.180])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jul 2024 14:19:08 -0700
Date: Wed, 24 Jul 2024 14:19:06 -0700
From: Paul E Luse <paul.e.luse@linux.intel.com>
To: Mateusz =?UTF-8?B?Sm/FhGN6eWs=?= <mat.jonczyk@o2.pl>
Cc: Yu Kuai <yukuai3@huawei.com>, linux-raid@vger.kernel.org,
 linux-kernel@vger.kernel.org, Song Liu <song@kernel.org>,
 regressions@lists.linux.dev
Subject: Re: Filesystem corruption when adding a new RAID device
 (delayed-resync, write-mostly)
Message-ID: <20240724141906.10b4fc4e@peluse-desk5>
In-Reply-To: <f28f9eec-d318-46e2-b2a1-430c9302ba43@o2.pl>
References: <9952f532-2554-44bf-b906-4880b2e88e3a@o2.pl>
	<ce95e64c-1a67-4a92-984a-c1eab0894857@o2.pl>
	<f28f9eec-d318-46e2-b2a1-430c9302ba43@o2.pl>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.41; aarch64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed, 24 Jul 2024 22:35:49 +0200
Mateusz Jo=C5=84czyk <mat.jonczyk@o2.pl> wrote:

> W dniu 22.07.2024 o=C2=A007:39, Mateusz Jo=C5=84czyk pisze:
> > W dniu 20.07.2024 o=C2=A016:47, Mateusz Jo=C5=84czyk pisze:
> >> Hello,
> >>
> >> In my laptop, I used to have two RAID1 arrays on top of NVMe and
> >> SATA SSD drives: /dev/md0 for /boot (not partitioned), /dev/md1
> >> for remaining data (LUKS
> >> + LVM + ext4). For performance, I have marked the RAID component
> >> device for /dev/md1 on the SATA SSD drive write-mostly, which
> >> "means that the 'md' driver will avoid reading from these devices
> >> if at all possible" (man mdadm).
> >>
> >> Recently, the NVMe drive started having problems (PCI AER errors
> >> and the controller disappearing), so I removed it from the arrays
> >> and wiped it. However, I have reseated the drive in the M.2 socket
> >> and this apparently fixed it (verified with tests).
> >>
> >> =C2=A0=C2=A0 =C2=A0$ cat /proc/mdstat
> >> =C2=A0=C2=A0 =C2=A0Personalities : [raid1] [linear] [multipath] [raid0=
] [raid6]
> >> [raid5] [raid4] [raid10] md1 : active raid1 sdb5[1](W)
> >> =C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 471727104 blocks sup=
er 1.2 [2/1] [_U]
> >> =C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bitmap: 4/4 pages [1=
6KB], 65536KB chunk
> >>
> >> =C2=A0=C2=A0 =C2=A0md2 : active (auto-read-only) raid1 sdb6[3](W) sda1=
[2]
> >> =C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 3142656 blocks super=
 1.2 [2/2] [UU]
> >> =C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bitmap: 0/1 pages [0=
KB], 65536KB chunk
> >>
> >> =C2=A0=C2=A0 =C2=A0md0 : active raid1 sdb4[3]
> >> =C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 2094080 blocks super=
 1.2 [2/1] [_U]
> >> =C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0
> >> =C2=A0=C2=A0 =C2=A0unused devices: <none>
> >>
> >> (md2 was used just for testing, ignore it).
> >>
> >> Today, I have tried to add the drive back to the arrays by using a
> >> script that executed in quick succession:
> >>
> >> =C2=A0=C2=A0 =C2=A0mdadm /dev/md0 --add --readwrite /dev/nvme0n1p2
> >> =C2=A0=C2=A0 =C2=A0mdadm /dev/md1 --add --readwrite /dev/nvme0n1p3
> >>
> >> This was on Linux 6.10.0, patched with my previous patch:
> >>
> >> =C2=A0=C2=A0=C2=A0 https://lore.kernel.org/linux-raid/20240711202316.1=
0775-1-mat.jonczyk@o2.pl/
> >>
> >> (which fixed a regression in the kernel and allows it to start
> >> /dev/md1 with a single drive in write-mostly mode).
> >> In the background, I was running "rdiff-backup --compare" that was
> >> comparing data between my array contents and a backup attached via
> >> USB.
> >>
> >> This, however resulted in mayhem - I was unable to start any
> >> program with an input-output error, etc. I used SysRQ + C to save
> >> a kernel log:
> >>
> > Hello,
> >
> > It is possible that my second SSD has some problems and high read
> > activity during RAID resync triggered it. Reads from that drive are
> > now very slow (between 10 - 30 MB/s) and this suggests that
> > something is not OK.
>=20
> Hello,
>=20
> Unfortunately, hardware failure seems not to be the case.
>=20
> I did test it again on 6.10, twice, and in both cases I got
> filesystem corruption (but not as severe).
>=20
> On Linux 6.1.96 it seems to be working well (also did two tries).
>=20
> Please note: in my tests, I was using a RAID component device with
> a write-mostly bit set. This setup does not work on 6.9+ out of the
> box and requires the following patch:
>=20
> commit 36a5c03f23271 ("md/raid1: set max_sectors during early return
> from choose_slow_rdev()")
>=20
> that is in master now.
>=20
> It is also heading into stable, which I'm going to interrupt.

Hi Mateusz,

I'm pretty interested in what is happening here especially as it
relates to write-mostly.  Couple of questions for you:

1) Are you able to find a simpler reproduction for this, for example
without mixing SATA and NVMe.  Maybe just using two known good NVMe
SSDs and follow your steps to repro?

2) I don't fully understand your last two statements, maybe you can
clarify?  With your max_sectors patch does it pass or fail?  If pass,
what do mean by "I'm going to interrupt"? It sounds like you mean the
patch doesn't work and you are trying to stop it??

thanks
Paul

>=20
> Greetings,
> Mateusz
>=20
>=20

