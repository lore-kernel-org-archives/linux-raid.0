Received: from mx-out.tlen.pl (mx-out.tlen.pl [193.222.135.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88FF24428
	for <linux-raid@vger.kernel.org>; Thu, 25 Jul 2024 07:16:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.222.135.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721891813; cv=none; b=kkoT6JzrCCqLoy18pppw8soqORPPyuXajLnotVaEEHarf2N0sYNZ8BhJQk7mm2VO5nQMcQ5XmhYyoqf8+x97CM+6FeRB9YfixyKFkVFhtFOPixaanG2RceJShMV2R+cclOllZSSjpUq5xsMD6cuxiAeNQIf7I9NxG7sVSq0b7+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721891813; c=relaxed/simple;
	bh=iRiZSjOVzyMj4SAUrdzoEmxUrieP5Mlht5w42sA7nZM=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=P6fLbFUiHWOYqC1+SzjZNAPyCBHH/GkyiWvbEJbXkjBLwGFPxfcd0XVRJzD/b5i9awbuSvXLG2RKK4qOrxBEZii7vGbbGwMsbiRJKwHW1wASM4N62wMTnz83wTFlBk+g0t+fqzqdqp7CajT0EKBo82bEwJp7k4MJ3hZouUVxkEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=o2.pl; spf=pass smtp.mailfrom=o2.pl; dkim=pass (1024-bit key) header.d=o2.pl header.i=@o2.pl header.b=nVyNd2J/; arc=none smtp.client-ip=193.222.135.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=o2.pl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=o2.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=o2.pl header.i=@o2.pl header.b="nVyNd2J/"
Received: (wp-smtpd smtp.tlen.pl 45789 invoked from network); 25 Jul 2024 09:16:41 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=o2.pl; s=1024a;
          t=1721891801; bh=vMfoJ6VDxLmxzRr6RMfJhEfVmXvH4xRv1RuIwr71CqI=;
          h=From:To:CC:Subject;
          b=nVyNd2J/rDnr47uvQ5yqBflH39CyAkkyCT8B0/SHBgZWBSxFEgBzIO70XLa3b8VE+
           KR12JvMAty6a1HSrPN5mQFkQ/1pk4a12aREdxKVY6CE9sqtShsIp7KjswYBJ1zIuLc
           R62O9KcyZYzQqSuDDFE6IJSHT3zQTXSDej7I7b1o=
Received: from 46.204.13.103.mobile.internet.t-mobile.pl (HELO [127.0.0.1]) (mat.jonczyk@o2.pl@[46.204.13.103])
          (envelope-sender <mat.jonczyk@o2.pl>)
          by smtp.tlen.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <paul.e.luse@linux.intel.com>; 25 Jul 2024 09:16:41 +0200
Date: Thu, 25 Jul 2024 09:15:40 +0200
From: =?UTF-8?Q?Mateusz_Jo=C5=84czyk?= <mat.jonczyk@o2.pl>
To: Paul E Luse <paul.e.luse@linux.intel.com>
CC: Yu Kuai <yukuai3@huawei.com>, linux-raid@vger.kernel.org,
 linux-kernel@vger.kernel.org, Song Liu <song@kernel.org>,
 regressions@lists.linux.dev
Subject: =?US-ASCII?Q?Re=3A_Filesystem_corruption_when_adding_a_new?=
 =?US-ASCII?Q?_RAID_device_=28delayed-resync=2C_write-mostly=29?=
User-Agent: K-9 Mail for Android
In-Reply-To: <20240724141906.10b4fc4e@peluse-desk5>
References: <9952f532-2554-44bf-b906-4880b2e88e3a@o2.pl> <ce95e64c-1a67-4a92-984a-c1eab0894857@o2.pl> <f28f9eec-d318-46e2-b2a1-430c9302ba43@o2.pl> <20240724141906.10b4fc4e@peluse-desk5>
Message-ID: <2123BF84-5F16-4938-915B-B1EE0931AC03@o2.pl>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-WP-MailID: a78301d0c9577853a67c75e05b3e30fe
X-WP-AV: skaner antywirusowy Poczty o2
X-WP-SPAM: NO 0000000 [MfPA]                               

Dnia 24 lipca 2024 23:19:06 CEST, Paul E Luse <paul=2Ee=2Eluse@linux=2Einte=
l=2Ecom> napisa=C5=82/a:
>On Wed, 24 Jul 2024 22:35:49 +0200
>Mateusz Jo=C5=84czyk <mat=2Ejonczyk@o2=2Epl> wrote:
>
>> W dniu 22=2E07=2E2024 o=C2=A007:39, Mateusz Jo=C5=84czyk pisze:
>> > W dniu 20=2E07=2E2024 o=C2=A016:47, Mateusz Jo=C5=84czyk pisze:
>> >> Hello,
>> >>
>> >> In my laptop, I used to have two RAID1 arrays on top of NVMe and
>> >> SATA SSD drives: /dev/md0 for /boot (not partitioned), /dev/md1
>> >> for remaining data (LUKS
>> >> + LVM + ext4)=2E For performance, I have marked the RAID component
>> >> device for /dev/md1 on the SATA SSD drive write-mostly, which
>> >> "means that the 'md' driver will avoid reading from these devices
>> >> if at all possible" (man mdadm)=2E
>> >>
>> >> Recently, the NVMe drive started having problems (PCI AER errors
>> >> and the controller disappearing), so I removed it from the arrays
>> >> and wiped it=2E However, I have reseated the drive in the M=2E2 sock=
et
>> >> and this apparently fixed it (verified with tests)=2E
>> >>
>> >> =C2=A0=C2=A0 =C2=A0$ cat /proc/mdstat
>> >> =C2=A0=C2=A0 =C2=A0Personalities : [raid1] [linear] [multipath] [rai=
d0] [raid6]
>> >> [raid5] [raid4] [raid10] md1 : active raid1 sdb5[1](W)
>> >> =C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 471727104 blocks s=
uper 1=2E2 [2/1] [_U]
>> >> =C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bitmap: 4/4 pages =
[16KB], 65536KB chunk
>> >>
>> >> =C2=A0=C2=A0 =C2=A0md2 : active (auto-read-only) raid1 sdb6[3](W) sd=
a1[2]
>> >> =C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 3142656 blocks sup=
er 1=2E2 [2/2] [UU]
>> >> =C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bitmap: 0/1 pages =
[0KB], 65536KB chunk
>> >>
>> >> =C2=A0=C2=A0 =C2=A0md0 : active raid1 sdb4[3]
>> >> =C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 2094080 blocks sup=
er 1=2E2 [2/1] [_U]
>> >> =C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0
>> >> =C2=A0=C2=A0 =C2=A0unused devices: <none>
>> >>
>> >> (md2 was used just for testing, ignore it)=2E
>> >>
>> >> Today, I have tried to add the drive back to the arrays by using a
>> >> script that executed in quick succession:
>> >>
>> >> =C2=A0=C2=A0 =C2=A0mdadm /dev/md0 --add --readwrite /dev/nvme0n1p2
>> >> =C2=A0=C2=A0 =C2=A0mdadm /dev/md1 --add --readwrite /dev/nvme0n1p3
>> >>
>> >> This was on Linux 6=2E10=2E0, patched with my previous patch:
>> >>
>> >> =C2=A0=C2=A0=C2=A0 https://lore=2Ekernel=2Eorg/linux-raid/2024071120=
2316=2E10775-1-mat=2Ejonczyk@o2=2Epl/
>> >>
>> >> (which fixed a regression in the kernel and allows it to start
>> >> /dev/md1 with a single drive in write-mostly mode)=2E
>> >> In the background, I was running "rdiff-backup --compare" that was
>> >> comparing data between my array contents and a backup attached via
>> >> USB=2E
>> >>
>> >> This, however resulted in mayhem - I was unable to start any
>> >> program with an input-output error, etc=2E I used SysRQ + C to save
>> >> a kernel log:
>> >>
>> > Hello,
>> >
>> > It is possible that my second SSD has some problems and high read
>> > activity during RAID resync triggered it=2E Reads from that drive are
>> > now very slow (between 10 - 30 MB/s) and this suggests that
>> > something is not OK=2E
>>=20
>> Hello,
>>=20
>> Unfortunately, hardware failure seems not to be the case=2E
>>=20
>> I did test it again on 6=2E10, twice, and in both cases I got
>> filesystem corruption (but not as severe)=2E
>>=20
>> On Linux 6=2E1=2E96 it seems to be working well (also did two tries)=2E
>>=20
>> Please note: in my tests, I was using a RAID component device with
>> a write-mostly bit set=2E This setup does not work on 6=2E9+ out of the
>> box and requires the following patch:
>>=20
>> commit 36a5c03f23271 ("md/raid1: set max_sectors during early return
>> from choose_slow_rdev()")
>>=20
>> that is in master now=2E
>>=20
>> It is also heading into stable, which I'm going to interrupt=2E
>
>Hi Mateusz,
>
>I'm pretty interested in what is happening here especially as it
>relates to write-mostly=2E  Couple of questions for you:
>
>1) Are you able to find a simpler reproduction for this, for example
>without mixing SATA and NVMe=2E  Maybe just using two known good NVMe
>SSDs and follow your steps to repro?

Hello,

Well, I have three drives in my laptop: NVMe, SATA SSD (in the DVD bay) an=
d SATA HDD (platter)=2E I could do tests on top of these two SATA drives=2E
But maybe it would be easier for me to bisect (or guess-bisect) in the cur=
rent setup, I haven't made up my mind yet=2E

>
>2) I don't fully understand your last two statements, maybe you can
>clarify?  With your max_sectors patch does it pass or fail?  If pass,
>what do mean by "I'm going to interrupt"? It sounds like you mean the
>patch doesn't work and you are trying to stop it??

Without this patch I wouldn't be able to do the tests=2E Without it, degra=
ded RAID1 with a single drive in write-mostly mode doesn=E2=80=99t start at=
 all=2E

With my last statement I meant that I was going to stop this patch from go=
ing to stable kernels=2E At this point, it doesn=E2=80=99t seem to me that =
my patch
is the direct cause of the problems, that I missed something=2E However, I=
 think that it is currently better to fail this setup outright rather than =
risk
somebody's data=2E

I have made further tests:

- vanilla 6=2E8=2E0 with a write-mostly drive works correctly,

- vanilla 6=2E10-rc6 without the write mostly bit set also works correctly=
=2E=20

So it seems that the problem happens only with the write-mostly mode and a=
fter 6=2E8=2E0=2E

Greetings,

Mateusz

