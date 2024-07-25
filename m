Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 695C319D07A;
	Thu, 25 Jul 2024 14:27:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721917667; cv=none; b=tmx50RLInPI/jMu1F91NAD66ULend79doQ/GtxBUgsrirK6X0ATcw7RlQjNjPzDbSD895I8EQD0Nv7mYJEHZjbJITTN184FqoOU2+abdIKX0QdvKRcFJFIJ406G7V4zvcwJ+J04Gzr7g/9ru6dQ3SL8OxRjEWMVunLwbA2iih0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721917667; c=relaxed/simple;
	bh=WOLZvX0Qyq2jPZ2Jjl/kIIVYwrmCNbXjYEvtIhkql3g=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RugRlDCbqdbwPgzHc/bYuDFZYoJrtqIgs3eIACxrdHaebss5+XMgK1gLNihE9MpZDeRZAGFmsZRB56hl5VKdv1y6ONOk0buP5eIYky3W01p/QM6XISbxZJLPPXWAT7airFIOwtthdCs4eLoCBWb5GVnMoG1sOp7hLpNSU1Z3e34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fKlaVjF9; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fKlaVjF9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721917665; x=1753453665;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=WOLZvX0Qyq2jPZ2Jjl/kIIVYwrmCNbXjYEvtIhkql3g=;
  b=fKlaVjF9SBBToBJOND8q7bQgds0sJPHj3dhdbaieUc2/tks7KmRq3zj/
   STxazMpZFMd/iyW3I9Zjc1DXF76aKjcOfDWe7nWJhAnr8ZfIfhCbkzT1z
   C8td5bBwibGCQc5bkR9LPYwPcIN+Gg/W5ude9XAKaOpI2IO1F7JO4oRiU
   1h+BhcVspcmbqF2GktEIXDcgpY61VTMgS9B3M4A2fwY3P875CspgoH+Xb
   7h6SiG5IfJBHlRUgI+1nHYJEH/qawk2UNxXrCpn5Yw+gb65N0NwLNaCky
   PHhyjDCKkMsXQVOlfZtGIiz8u7NJt7ZtTOhYRW9e8uUH0lU6lSCiA02B/
   A==;
X-CSE-ConnectionGUID: S8JOJ6GISJSMJ2Yj14o68g==
X-CSE-MsgGUID: TyjpZT16TF2YhFvX3kQWeA==
X-IronPort-AV: E=McAfee;i="6700,10204,11144"; a="23518509"
X-IronPort-AV: E=Sophos;i="6.09,236,1716274800"; 
   d="scan'208";a="23518509"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2024 07:27:45 -0700
X-CSE-ConnectionGUID: yutsUjsMR1i7hYICc73zIA==
X-CSE-MsgGUID: ///DwOGTTBeNrMRmBFBPew==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,236,1716274800"; 
   d="scan'208";a="57757055"
Received: from njczesak-mobl1.amr.corp.intel.com (HELO peluse-desk5) ([10.212.31.241])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2024 07:27:44 -0700
Date: Thu, 25 Jul 2024 07:27:42 -0700
From: Paul E Luse <paul.e.luse@linux.intel.com>
To: Mateusz =?UTF-8?B?Sm/FhGN6eWs=?= <mat.jonczyk@o2.pl>
Cc: Yu Kuai <yukuai3@huawei.com>, linux-raid@vger.kernel.org,
 linux-kernel@vger.kernel.org, Song Liu <song@kernel.org>,
 regressions@lists.linux.dev
Subject: Re: Filesystem corruption when adding a new RAID device
 (delayed-resync, write-mostly)
Message-ID: <20240725072742.1664beec@peluse-desk5>
In-Reply-To: <2123BF84-5F16-4938-915B-B1EE0931AC03@o2.pl>
References: <9952f532-2554-44bf-b906-4880b2e88e3a@o2.pl>
	<ce95e64c-1a67-4a92-984a-c1eab0894857@o2.pl>
	<f28f9eec-d318-46e2-b2a1-430c9302ba43@o2.pl>
	<20240724141906.10b4fc4e@peluse-desk5>
	<2123BF84-5F16-4938-915B-B1EE0931AC03@o2.pl>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.41; aarch64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu, 25 Jul 2024 09:15:40 +0200
Mateusz Jo=C5=84czyk <mat.jonczyk@o2.pl> wrote:

> Dnia 24 lipca 2024 23:19:06 CEST, Paul E Luse
> <paul.e.luse@linux.intel.com> napisa=C5=82/a:
> >On Wed, 24 Jul 2024 22:35:49 +0200
> >Mateusz Jo=C5=84czyk <mat.jonczyk@o2.pl> wrote:
> >
> >> W dniu 22.07.2024 o=C2=A007:39, Mateusz Jo=C5=84czyk pisze:
> >> > W dniu 20.07.2024 o=C2=A016:47, Mateusz Jo=C5=84czyk pisze:
> >> >> Hello,
> >> >>
> >> >> In my laptop, I used to have two RAID1 arrays on top of NVMe and
> >> >> SATA SSD drives: /dev/md0 for /boot (not partitioned), /dev/md1
> >> >> for remaining data (LUKS
> >> >> + LVM + ext4). For performance, I have marked the RAID component
> >> >> device for /dev/md1 on the SATA SSD drive write-mostly, which
> >> >> "means that the 'md' driver will avoid reading from these
> >> >> devices if at all possible" (man mdadm).
> >> >>
> >> >> Recently, the NVMe drive started having problems (PCI AER errors
> >> >> and the controller disappearing), so I removed it from the
> >> >> arrays and wiped it. However, I have reseated the drive in the
> >> >> M.2 socket and this apparently fixed it (verified with tests).
> >> >>
> >> >> =C2=A0=C2=A0 =C2=A0$ cat /proc/mdstat
> >> >> =C2=A0=C2=A0 =C2=A0Personalities : [raid1] [linear] [multipath] [ra=
id0] [raid6]
> >> >> [raid5] [raid4] [raid10] md1 : active raid1 sdb5[1](W)
> >> >> =C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 471727104 blocks =
super 1.2 [2/1] [_U]
> >> >> =C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bitmap: 4/4 pages=
 [16KB], 65536KB chunk
> >> >>
> >> >> =C2=A0=C2=A0 =C2=A0md2 : active (auto-read-only) raid1 sdb6[3](W) s=
da1[2]
> >> >> =C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 3142656 blocks su=
per 1.2 [2/2] [UU]
> >> >> =C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bitmap: 0/1 pages=
 [0KB], 65536KB chunk
> >> >>
> >> >> =C2=A0=C2=A0 =C2=A0md0 : active raid1 sdb4[3]
> >> >> =C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 2094080 blocks su=
per 1.2 [2/1] [_U]
> >> >> =C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0
> >> >> =C2=A0=C2=A0 =C2=A0unused devices: <none>
> >> >>
> >> >> (md2 was used just for testing, ignore it).
> >> >>
> >> >> Today, I have tried to add the drive back to the arrays by
> >> >> using a script that executed in quick succession:
> >> >>
> >> >> =C2=A0=C2=A0 =C2=A0mdadm /dev/md0 --add --readwrite /dev/nvme0n1p2
> >> >> =C2=A0=C2=A0 =C2=A0mdadm /dev/md1 --add --readwrite /dev/nvme0n1p3
> >> >>
> >> >> This was on Linux 6.10.0, patched with my previous patch:
> >> >>
> >> >> =C2=A0=C2=A0=C2=A0 https://lore.kernel.org/linux-raid/2024071120231=
6.10775-1-mat.jonczyk@o2.pl/
> >> >>
> >> >> (which fixed a regression in the kernel and allows it to start
> >> >> /dev/md1 with a single drive in write-mostly mode).
> >> >> In the background, I was running "rdiff-backup --compare" that
> >> >> was comparing data between my array contents and a backup
> >> >> attached via USB.
> >> >>
> >> >> This, however resulted in mayhem - I was unable to start any
> >> >> program with an input-output error, etc. I used SysRQ + C to
> >> >> save a kernel log:
> >> >>
> >> > Hello,
> >> >
> >> > It is possible that my second SSD has some problems and high read
> >> > activity during RAID resync triggered it. Reads from that drive
> >> > are now very slow (between 10 - 30 MB/s) and this suggests that
> >> > something is not OK.
> >>=20
> >> Hello,
> >>=20
> >> Unfortunately, hardware failure seems not to be the case.
> >>=20
> >> I did test it again on 6.10, twice, and in both cases I got
> >> filesystem corruption (but not as severe).
> >>=20
> >> On Linux 6.1.96 it seems to be working well (also did two tries).
> >>=20
> >> Please note: in my tests, I was using a RAID component device with
> >> a write-mostly bit set. This setup does not work on 6.9+ out of the
> >> box and requires the following patch:
> >>=20
> >> commit 36a5c03f23271 ("md/raid1: set max_sectors during early
> >> return from choose_slow_rdev()")
> >>=20
> >> that is in master now.
> >>=20
> >> It is also heading into stable, which I'm going to interrupt.
> >
> >Hi Mateusz,
> >
> >I'm pretty interested in what is happening here especially as it
> >relates to write-mostly.  Couple of questions for you:
> >
> >1) Are you able to find a simpler reproduction for this, for example
> >without mixing SATA and NVMe.  Maybe just using two known good NVMe
> >SSDs and follow your steps to repro?
>=20
> Hello,
>=20
> Well, I have three drives in my laptop: NVMe, SATA SSD (in the DVD
> bay) and SATA HDD (platter). I could do tests on top of these two
> SATA drives. But maybe it would be easier for me to bisect (or
> guess-bisect) in the current setup, I haven't made up my mind yet.
>=20

OK, thanks.

> >
> >2) I don't fully understand your last two statements, maybe you can
> >clarify?  With your max_sectors patch does it pass or fail?  If pass,
> >what do mean by "I'm going to interrupt"? It sounds like you mean the
> >patch doesn't work and you are trying to stop it??
>=20
> Without this patch I wouldn't be able to do the tests. Without it,
> degraded RAID1 with a single drive in write-mostly mode doesn=E2=80=99t s=
tart
> at all.
>=20
> With my last statement I meant that I was going to stop this patch
> from going to stable kernels. At this point, it doesn=E2=80=99t seem to me
> that my patch is the direct cause of the problems, that I missed
> something. However, I think that it is currently better to fail this
> setup outright rather than risk somebody's data.
>=20

OK, I would say please do not try to stop the patch, it is a good fix
although maybe not completely solving your problem it should land.

Unless Kwai has another opinion.

-Paul

> I have made further tests:
>=20
> - vanilla 6.8.0 with a write-mostly drive works correctly,
>=20
> - vanilla 6.10-rc6 without the write mostly bit set also works
> correctly.=20
>=20
> So it seems that the problem happens only with the write-mostly mode
> and after 6.8.0.
>=20
> Greetings,
>=20
> Mateusz
>=20
>=20

