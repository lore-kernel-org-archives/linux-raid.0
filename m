From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: What's the typical RAID10 setup?
Date: Fri, 04 Feb 2011 04:04:42 -0600
Message-ID: <4D4BCF3A.1030809@hardwarefreak.com>
References: <4D4718E1.9040607@hardwarefreak.com> <20110131203725.GB2283@www2.open-std.org> <AANLkTimxCkxkg6xuz8FgFf0=u4KY=0M=6+afnxLzT+Tu@mail.gmail.com> <AANLkTi=+rPzaNTKAjB=QUEGsbUcwfN8uijm96DoY_4FA@mail.gmail.com> <AANLkTinM6FkJtxL8dNpoy-haGqNsZVfLDwmvZcshTEYQ@mail.gmail.com> <4D475AB5.10600@hardwarefreak.com> <20110203110428.GA26762@www2.open-std.org> <4D4B3DAE.3070502@hardwarefreak.com> <20110204070613.GA3788@www2.open-std.org> <4D4BB87A.30800@hardwarefreak.com> <20110204090602.GA4017@www2.open-std.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110204090602.GA4017@www2.open-std.org>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Keld_J=F8rn_Simonsen?= <keld@keldix.com>
Cc: Jon Nelson <jnelson-linux-raid@jamponi.net>, =?ISO-8859-1?Q?Mathias_?= =?ISO-8859-1?Q?Bur=E9n?= <mathias.buren@gmail.com>, Roberto Spadim <roberto@spadim.com.br>, Denis <denismpa@gmail.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Keld J=F8rn Simonsen put forth on 2/4/2011 3:06 AM:

>> We apparently need to be looking for other SNIA documents to find th=
eir
>> definition of RAID 10.  That is what started us down this tunnel isn=
't it?
>> We're so deep now there's no light and I can't see the path behind m=
e anymore. ;)
>=20
> I dont think SNIA defines RAID 10, which is a specific Linux MD thing=
=2E

Either you're very young, or don't read what I type, maybe both. ;)  RA=
ID 10 has
been around for 15+ years.  It is not unique to Linux mdraid.  The "alt=
ernate
layouts" of mdraid are unique to Linux/mdraid, but RAID 10 is not uniqu=
e to mdraid.

> For RAID1+0, I think it is covered by the DDF standard

RAID 10 and RAID 1+0 are the same thing by two different names.  It's n=
ot
covered in the DDF.  I just spent a paragraph explaining why it's not i=
n the
DDF, and you agreed with me for Pete's sake!  Now you say you think it =
_is_ in
the DDF?

I'm getting dizzy from the running in circles...

I suggest you actually read the DDF and other documents available on th=
e SNIA
website, as I have.

--=20
Stan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
