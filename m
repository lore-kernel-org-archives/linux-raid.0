From: Drew <drew.kay@gmail.com>
Subject: Re: migrating from RAID5 to RAID10
Date: Thu, 10 Jun 2010 15:21:27 -0700
Message-ID: <AANLkTimW4IMO55vL-icTcpkcg9d10dK13yIGu4XZbrQQ@mail.gmail.com>
References: <20100609151132.GA10082@libra.CS.Berkeley.EDU>
	<20100611005231.401529c0@natsu> <20100610195851.GA8408@libra.CS.Berkeley.EDU>
	<AANLkTim3vrtAfgzY87IAmP6mY9PNiYiQZ1LyuqWHisiD@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTim3vrtAfgzY87IAmP6mY9PNiYiQZ1LyuqWHisiD@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>> No, it is not degraded, it's a clean 2-drive RAID5. I know it doesn'=
t
>> make much sense as it is ;-) =C2=A0the intent was to grow the array =
later,
>> relying on mdadm's grow feature. Right now, I'm guessing that it
>> operates like a RAID1 for all practical purposes.
>
> Actually No. If it is RAID-5 as you claim, then currently it is
> effectively a RAID-0.
>
> RAID-5 is Striping with Distributed Parity and requires a *minimum* o=
f
> 3 disks. Two disks, regardless of how you got there, is considered a
> degraded state.

Actually, I need to retract those statements. A clean two disk RAID-5
array can be created and is actually very similar to a RAID-1 array.

=46rom this thread: http://ubuntuforums.org/archive/index.php/t-566803.=
html
---
If you're using just 2 disks in a non-degraded setup, then you'll have
the following structure
Drive1 Drive2
Block1: A1 P1
Block2: P2 B1
Block3: C1 P3
Block4: P4 D1

In this case, you're parity blocks will actually be identical to your
non-parity blocks. This is because P1 is calculated as P1 =3D A1 XOR ??
Since there is no other block to XOR your bits with, md falls back to
?? =3D 0, and we all know that the XOR of 0 is the identity. That is, P=
1
=3D A1 XOR 0 =3D=3D A1
---

I stand corrected. :-)

--=20
Drew

"Nothing in life is to be feared. It is only to be understood."
--Marie Curie
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
