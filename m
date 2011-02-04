From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@keldix.com>
Subject: Re: What's the typical RAID10 setup?
Date: Fri, 4 Feb 2011 08:06:13 +0100
Message-ID: <20110204070613.GA3788@www2.open-std.org>
References: <AANLkTim_uQ7AQs_ZSyeYPJPYSLCJd6ChzzTBwBNk2qA9@mail.gmail.com> <20110131192858.GD27952@www2.open-std.org> <4D4718E1.9040607@hardwarefreak.com> <20110131203725.GB2283@www2.open-std.org> <AANLkTimxCkxkg6xuz8FgFf0=u4KY=0M=6+afnxLzT+Tu@mail.gmail.com> <AANLkTi=+rPzaNTKAjB=QUEGsbUcwfN8uijm96DoY_4FA@mail.gmail.com> <AANLkTinM6FkJtxL8dNpoy-haGqNsZVfLDwmvZcshTEYQ@mail.gmail.com> <4D475AB5.10600@hardwarefreak.com> <20110203110428.GA26762@www2.open-std.org> <4D4B3DAE.3070502@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4D4B3DAE.3070502@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@keldix.com>, Jon Nelson <jnelson-linux-raid@jamponi.net>, Mathias =?iso-8859-1?Q?Bur=E9n?= <mathias.buren@gmail.com>, Roberto Spadim <roberto@spadim.com.br>, Denis <denismpa@gmail.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, Feb 03, 2011 at 05:43:42PM -0600, Stan Hoeppner wrote:
> Keld J=F8rn Simonsen put forth on 2/3/2011 5:04 AM:
> > On Mon, Jan 31, 2011 at 06:58:29PM -0600, Stan Hoeppner wrote:
> >> Jon Nelson put forth on 1/31/2011 3:27 PM:
> >>> Before this goes any further, why not just reference the excellen=
t
> >>> Wikipedia article (actually, excellent applies to both Wikipedia =
*and*
> >>> the article):
> >>>
> >>> http://en.wikipedia.org/wiki/Non-standard_RAID_levels#Linux_MD_RA=
ID_10
> >>>
> >>> The only problem I have with the wikipedia article is the asserti=
on
> >>> that Linux MD RAID 10 is non-standard. It's as standard as anythi=
ng
> >>> else is in this world.
> >>
> >> Unfortunately there is no organization, no standards body, that de=
fines RAID
> >> levels.=20
> >=20
> > Well there is an organisation that does just that, namely SNIA.
>=20
> I should have qualified that with "defines RAID levels the entire ind=
ustry
> accepts/adopts".  Unfortunately SNIA is not a standards body or worki=
ng group,
> such as PCI-SIG, or IETF, whose specifications entire industries _do_=
 accept/adopt.

I don't know about SNIA, but I have vast experience with standardisatio=
n
bodies. I see SNIA as an industry standard standardisation body. I don'=
t
know how pervasive that organisation is, but their membership list is
impressive http://www.snia.org/member_com/member_directory/ -
Looks like everybody in the harddisk business is on board.

> Please note that the SNIA Disk Data Format document doesn't define RA=
ID 10 at
> all.  Yet there is a single mention of RAID 10 in the entire document=
:
>=20
> "RAID-1E 0x11 >2 disk RAID-1, similar to RAID-10 but with striping in=
tegrated
> into array"
>=20
> They don't define RAID 10, but they reference it.  Thus one can only =
assume that
> SNIA _assumes_ RAID 10 is already well defined in industry to referen=
ce it in
> such a manner without previously defining it in the document.
>=20
> Does anyone else find this reference to a RAID level omitted in their
> definitions a little more than interesting?  This RAID 10 omission is=
 especially
> interesting considering that RAID 10 dominates the storage back ends =
of Fortune
> 1000 companies, specifically beneath databases and high transaction l=
oad systems
> such as enterprise mail.
>=20
> They've omitted defining the one RAID level with the best combination=
 of high
> performance, most resilience, and greatest penetration of the "high e=
nd" of
> computing in the history of RAID.  This begs the question:  "Why?"

Well RAID1+0 is not the best combination available. I would argue that
raid10,f2 is significantly better in a number of areas.

> Something smells bad here.  Does one of the RAID companies own a pate=
nt or
> trademark on "RAID 10"?  I'll look into this.  It just doesn't make a=
ny sense
> for RAID 10 to be omitted from the SNIA DDF but to be referenced in t=
he manner
> it is.

It looks like they do define all major basic RAID disk layouts. (except
raid10,f2 of cause) . RAID1+0 is a derived format, maybe that is out of
scope of the DDF standard.

Best regards
keld
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
