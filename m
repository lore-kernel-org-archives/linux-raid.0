From: Drew <drew.kay@gmail.com>
Subject: Re: migrating from RAID5 to RAID10
Date: Thu, 10 Jun 2010 15:11:43 -0700
Message-ID: <AANLkTim3vrtAfgzY87IAmP6mY9PNiYiQZ1LyuqWHisiD@mail.gmail.com>
References: <20100609151132.GA10082@libra.CS.Berkeley.EDU>
	<20100611005231.401529c0@natsu> <20100610195851.GA8408@libra.CS.Berkeley.EDU>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100610195851.GA8408@libra.CS.Berkeley.EDU>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>> Do you currently run RAID5 with just 2 drives, in degraded mode, or
>> maybe you meant something else?
>
> No, it is not degraded, it's a clean 2-drive RAID5. I know it doesn't
> make much sense as it is ;-) =C2=A0the intent was to grow the array l=
ater,
> relying on mdadm's grow feature. Right now, I'm guessing that it
> operates like a RAID1 for all practical purposes.

Actually No. If it is RAID-5 as you claim, then currently it is
effectively a RAID-0.

RAID-5 is Striping with Distributed Parity and requires a *minimum* of
3 disks. Two disks, regardless of how you got there, is considered a
degraded state.


--=20
Drew

"Nothing in life is to be feared. It is only to be understood."
--Marie Curie
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
