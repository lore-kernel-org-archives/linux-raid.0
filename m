From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: What's the typical RAID10 setup?
Date: Fri, 04 Feb 2011 02:27:38 -0600
Message-ID: <4D4BB87A.30800@hardwarefreak.com>
References: <AANLkTim_uQ7AQs_ZSyeYPJPYSLCJd6ChzzTBwBNk2qA9@mail.gmail.com> <20110131192858.GD27952@www2.open-std.org> <4D4718E1.9040607@hardwarefreak.com> <20110131203725.GB2283@www2.open-std.org> <AANLkTimxCkxkg6xuz8FgFf0=u4KY=0M=6+afnxLzT+Tu@mail.gmail.com> <AANLkTi=+rPzaNTKAjB=QUEGsbUcwfN8uijm96DoY_4FA@mail.gmail.com> <AANLkTinM6FkJtxL8dNpoy-haGqNsZVfLDwmvZcshTEYQ@mail.gmail.com> <4D475AB5.10600@hardwarefreak.com> <20110203110428.GA26762@www2.open-std.org> <4D4B3DAE.3070502@hardwarefreak.com> <20110204070613.GA3788@www2.open-std.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110204070613.GA3788@www2.open-std.org>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Keld_J=F8rn_Simonsen?= <keld@keldix.com>
Cc: Jon Nelson <jnelson-linux-raid@jamponi.net>, =?ISO-8859-1?Q?Mathias_?= =?ISO-8859-1?Q?Bur=E9n?= <mathias.buren@gmail.com>, Roberto Spadim <roberto@spadim.com.br>, Denis <denismpa@gmail.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Keld J=F8rn Simonsen put forth on 2/4/2011 1:06 AM:

> Well RAID1+0 is not the best combination available. I would argue tha=
t
> raid10,f2 is significantly better in a number of areas.

I'd guess Linux software RAID would be lucky to have 1% of RAID deploym=
ents
worldwide--very lucky.  The other 99%+ are HBA RAID or SAN/NAS "applian=
ces" most
often using custom embedded RTOS with the RAID code written in assemble=
r,
especially in the case of the HBAs.  For everything not Linux mdraid, R=
AID 10
(aka 1+0) is king of the hill, and has been for 15 years+

>> Something smells bad here.  Does one of the RAID companies own a pat=
ent or
>> trademark on "RAID 10"?  I'll look into this.  It just doesn't make =
any sense
>> for RAID 10 to be omitted from the SNIA DDF but to be referenced in =
the manner
>> it is.
>=20
> It looks like they do define all major basic RAID disk layouts. (exce=
pt
> raid10,f2 of cause) . RAID1+0 is a derived format, maybe that is out =
of
> scope of the DDF standard.

"A secondary virtual disk is a VD configured using hybrid RAID levels l=
ike
RAID10 or RAID50. Its elements are BVDs."

So apparently their Disk Data Format specification doesn't include hybr=
id RAID
levels.  This makes sense, as the _on disk_ layout of RAID 10 is identi=
cal to
RAID 1.

We apparently need to be looking for other SNIA documents to find their
definition of RAID 10.  That is what started us down this tunnel isn't =
it?
We're so deep now there's no light and I can't see the path behind me a=
nymore. ;)

--=20
Stan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
