From: NeilBrown <neilb@suse.de>
Subject: Re: Hi! Why having LSR's chunk size 2^n limitation?
Date: Wed, 19 Jan 2011 20:32:39 +1100
Message-ID: <20110119203239.0677bba6@notabene.brown>
References: <AANLkTi=Nk_4vNH5BpHj5fMJxOaSAGjuiSD8agbACdzaQ@mail.gmail.com>
	<20110119064457.5ab8bdd0@notabene.brown>
	<AANLkTi=C6Pn9qHXPXX0NCEtEwihb1rVPDM48RUDXD_Eh@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=C6Pn9qHXPXX0NCEtEwihb1rVPDM48RUDXD_Eh@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: for.poige+linux@gmail.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 19 Jan 2011 14:41:10 +0700 Igor Podlesny <for.poige+linux@gmail=
=2Ecom>
wrote:

> > =A0restriction was dropped for RAID0 a year or more ago. =A0The res=
triction
> > =A0could be dropped for RAID4/5/6 and RAID10 relatively easily. =A0=
It would just
> > =A0require a thorough code review and changing a few 'mask' and 'sh=
ift'
> > =A0operations to divisions.
> [...]
>=20
>    Would be really great. Really!
>=20

I'm happy to accept patches - after reviewing them of course.

NeilBrown

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
