From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: What's the typical RAID10 setup?
Date: Fri, 04 Feb 2011 15:15:39 -0600
Message-ID: <4D4C6C7B.2020304@hardwarefreak.com>
References: <20110131203725.GB2283@www2.open-std.org> <AANLkTimxCkxkg6xuz8FgFf0=u4KY=0M=6+afnxLzT+Tu@mail.gmail.com> <AANLkTi=+rPzaNTKAjB=QUEGsbUcwfN8uijm96DoY_4FA@mail.gmail.com> <AANLkTinM6FkJtxL8dNpoy-haGqNsZVfLDwmvZcshTEYQ@mail.gmail.com> <4D475AB5.10600@hardwarefreak.com> <20110203110428.GA26762@www2.open-std.org> <4D4B3DAE.3070502@hardwarefreak.com> <20110204070613.GA3788@www2.open-std.org> <4D4BB87A.30800@hardwarefreak.com> <20110204090602.GA4017@www2.open-std.org> <20110204204251.GB6603@www2.open-std.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110204204251.GB6603@www2.open-std.org>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Keld_J=F8rn_Simonsen?= <keld@keldix.com>
Cc: Jon Nelson <jnelson-linux-raid@jamponi.net>, =?ISO-8859-1?Q?Mathias_?= =?ISO-8859-1?Q?Bur=E9n?= <mathias.buren@gmail.com>, Roberto Spadim <roberto@spadim.com.br>, Denis <denismpa@gmail.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Keld J=F8rn Simonsen put forth on 2/4/2011 2:42 PM:

>>> So apparently their Disk Data Format specification doesn't include =
hybrid RAID
>>> levels.  This makes sense, as the _on disk_ layout of RAID 10 is id=
entical to
>>> RAID 1.
>=20
> I was puzzled here. I think you mean:
>=20
> "the _on disk_ layout of RAID 10 is identical to RAID 1 and RAID 0"
>=20
> If that is what you meant, I think we agree on most things here.

I set a trap for you, of sorts. ;)  If what you say is true, then RAID =
10 should
be covered in the DDF, as migration from one device to another isn't po=
ssible
without the RAID 10 on disk layout being defined in the DDF as with all=
 the
other RAID levels.  True?

--=20
Stan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
