From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@keldix.com>
Subject: Re: What's the typical RAID10 setup?
Date: Fri, 4 Feb 2011 21:35:23 +0100
Message-ID: <20110204203523.GA6603@www2.open-std.org>
References: <AANLkTimxCkxkg6xuz8FgFf0=u4KY=0M=6+afnxLzT+Tu@mail.gmail.com> <AANLkTi=+rPzaNTKAjB=QUEGsbUcwfN8uijm96DoY_4FA@mail.gmail.com> <AANLkTinM6FkJtxL8dNpoy-haGqNsZVfLDwmvZcshTEYQ@mail.gmail.com> <4D475AB5.10600@hardwarefreak.com> <20110203110428.GA26762@www2.open-std.org> <4D4B3DAE.3070502@hardwarefreak.com> <20110204070613.GA3788@www2.open-std.org> <4D4BB87A.30800@hardwarefreak.com> <20110204090602.GA4017@www2.open-std.org> <4D4BCF3A.1030809@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4D4BCF3A.1030809@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@keldix.com>, Jon Nelson <jnelson-linux-raid@jamponi.net>, Mathias =?iso-8859-1?Q?Bur=E9n?= <mathias.buren@gmail.com>, Roberto Spadim <roberto@spadim.com.br>, Denis <denismpa@gmail.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, Feb 04, 2011 at 04:04:42AM -0600, Stan Hoeppner wrote:
> Keld J=F8rn Simonsen put forth on 2/4/2011 3:06 AM:
>=20
> > For RAID1+0, I think it is covered by the DDF standard
>=20
> RAID 10 and RAID 1+0 are the same thing by two different names.  It's=
 not
> covered in the DDF.

I agree that it is not described in detail in DDF.=20

But it is covered, as I wrote. RAID 1+0 can be a number of things,
as RAID1 can be a number of things. It can be what we know in Linux-lan=
d
as a RAID0 of MD raid10,n2 or of md raid10,o2, or some other raid1
layout.

when you then move a set of RAID 1+0 disks from one RAID device to anot=
her,
then, using DDF, you can handle that correctly on the new raid device,
as you can see what kind of RAID1 that the disks are formatted with,
thanks to the DDF standard. And you can then also see that the RAID0=20
is a RAID0, according to the data stored in the RAID description
adhering to the DDF standard.

So you can safely move RAID 1+0 disks from one RAID device (say NAS box=
) to another.
Handy if a NAS box breaks down beyond repair, and you have to buy a new
one of another make.

> I just spent a paragraph explaining why it's not in the
> DDF, and you agreed with me for Pete's sake!  Now you say you think i=
t _is_ in
> the DDF?

Implicitely it is there, and for good reasons it is not spelled out.

The same story goes for RAID 5+0 and other nested RAID types.
It does not make sense to describe the combined nested type,
only the component data formats are described.

But one could have a brief description of the concepts, and why it
is not adequate terminology in the DDF standard.

best regards
keld
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
