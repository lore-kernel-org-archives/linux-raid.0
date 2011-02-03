From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: What's the typical RAID10 setup?
Date: Thu, 03 Feb 2011 17:43:42 -0600
Message-ID: <4D4B3DAE.3070502@hardwarefreak.com>
References: <AANLkTikvXk0gyXz6MBvhyzxXatk0FVeASPr8R8+74c_i@mail.gmail.com> <AANLkTinGSNmp6yUNfb9thnr3zKFTzw=fUFm+Gef3DAHw@mail.gmail.com> <AANLkTim_uQ7AQs_ZSyeYPJPYSLCJd6ChzzTBwBNk2qA9@mail.gmail.com> <20110131192858.GD27952@www2.open-std.org> <4D4718E1.9040607@hardwarefreak.com> <20110131203725.GB2283@www2.open-std.org> <AANLkTimxCkxkg6xuz8FgFf0=u4KY=0M=6+afnxLzT+Tu@mail.gmail.com> <AANLkTi=+rPzaNTKAjB=QUEGsbUcwfN8uijm96DoY_4FA@mail.gmail.com> <AANLkTinM6FkJtxL8dNpoy-haGqNsZVfLDwmvZcshTEYQ@mail.gmail.com> <4D475AB5.10600@hardwarefreak.com> <20110203110428.GA26762@www2.open-std.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110203110428.GA26762@www2.open-std.org>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Keld_J=F8rn_Simonsen?= <keld@keldix.com>
Cc: Jon Nelson <jnelson-linux-raid@jamponi.net>, =?ISO-8859-1?Q?Mathias_?= =?ISO-8859-1?Q?Bur=E9n?= <mathias.buren@gmail.com>, Roberto Spadim <roberto@spadim.com.br>, Denis <denismpa@gmail.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Keld J=F8rn Simonsen put forth on 2/3/2011 5:04 AM:
> On Mon, Jan 31, 2011 at 06:58:29PM -0600, Stan Hoeppner wrote:
>> Jon Nelson put forth on 1/31/2011 3:27 PM:
>>> Before this goes any further, why not just reference the excellent
>>> Wikipedia article (actually, excellent applies to both Wikipedia *a=
nd*
>>> the article):
>>>
>>> http://en.wikipedia.org/wiki/Non-standard_RAID_levels#Linux_MD_RAID=
_10
>>>
>>> The only problem I have with the wikipedia article is the assertion
>>> that Linux MD RAID 10 is non-standard. It's as standard as anything
>>> else is in this world.
>>
>> Unfortunately there is no organization, no standards body, that defi=
nes RAID
>> levels.=20
>=20
> Well there is an organisation that does just that, namely SNIA.

I should have qualified that with "defines RAID levels the entire indus=
try
accepts/adopts".  Unfortunately SNIA is not a standards body or working=
 group,
such as PCI-SIG, or IETF, whose specifications entire industries _do_ a=
ccept/adopt.

> http://www.snia.org
>=20
> The RAID levels are defined in DDF - a "SNIA" standard.

Exactly.  It's an SNIA standard.  Unfortunately SNIA doesn't carry suff=
icient
weight to drive full adoption.  I commend them for trying though.

> http://www.snia.org/tech_activities/standards/curr_standards/ddf/
>=20
> (Info courtesey of Neil Brown)

Please note that the SNIA Disk Data Format document doesn't define RAID=
 10 at
all.  Yet there is a single mention of RAID 10 in the entire document:

"RAID-1E 0x11 >2 disk RAID-1, similar to RAID-10 but with striping inte=
grated
into array"

They don't define RAID 10, but they reference it.  Thus one can only as=
sume that
SNIA _assumes_ RAID 10 is already well defined in industry to reference=
 it in
such a manner without previously defining it in the document.

Does anyone else find this reference to a RAID level omitted in their
definitions a little more than interesting?  This RAID 10 omission is e=
specially
interesting considering that RAID 10 dominates the storage back ends of=
 Fortune
1000 companies, specifically beneath databases and high transaction loa=
d systems
such as enterprise mail.

They've omitted defining the one RAID level with the best combination o=
f high
performance, most resilience, and greatest penetration of the "high end=
" of
computing in the history of RAID.  This begs the question:  "Why?"

Something smells bad here.  Does one of the RAID companies own a patent=
 or
trademark on "RAID 10"?  I'll look into this.  It just doesn't make any=
 sense
for RAID 10 to be omitted from the SNIA DDF but to be referenced in the=
 manner
it is.

--=20
Stan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
