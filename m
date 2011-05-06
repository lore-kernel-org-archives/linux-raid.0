From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@keldix.com>
Subject: Re: wish for Linux MD mirrored raid types
Date: Fri, 6 May 2011 15:40:15 +0200
Message-ID: <20110506134015.GB22689@www2.open-std.org>
References: <20110506071752.GA22063@www2.open-std.org> <20110506133159.30c66519@natsu> <20110506090345.GA22245@www2.open-std.org> <4DC3BDD9.1060300@abpni.co.uk> <20110506094102.GC22245@www2.open-std.org> <20110506155059.6f82cbeb@natsu> <20110506123336.GC22617@www2.open-std.org> <alpine.DEB.2.00.1105061525520.20305@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1105061525520.20305@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@keldix.com>, Roman Mamedov <rm@romanrm.ru>, Jonathan Tripathy <jonnyt@abpni.co.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, May 06, 2011 at 03:26:52PM +0200, Mikael Abrahamsson wrote:
> On Fri, 6 May 2011, Keld J=F8rn Simonsen wrote:
>=20
> >I am proposing that we call our raid10 layout types for RAID1 - in=20
> >accordance with SNIA standards, and in accordance with the common=20
> >understanding as demonstrated by you and others, even here on the=20
> >linux-raid kernel mailing list.
>=20
> Just so we're clear, if I create a raid1 with 4 drives I want 4 ident=
ical=20
> copies of the same information, not RAID1+0.
>=20
> How should this be handled with your suggestion?

With parameters like the ones that we use today for raid10. Something
like

mdadm --create /dev/md0 --level=3D1 -n 4 --layout=3Dc4 /dev/sd[abcd]1=20

assuming a new layout type "classic" abbreviated as "c". "n4" could als=
o
do for the layout value.

best regards
keld
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
