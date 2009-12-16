From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: RAID5 / 6 Growth
Date: Wed, 16 Dec 2009 02:38:26 -0600
Message-ID: <15.40.01567.98C982B4@cdptpa-omtalb.mail.rr.com>
References: <4877c76c0912160012t3796247dg4dcf79c66e404528@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4877c76c0912160012t3796247dg4dcf79c66e404528@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> >> I interrupted an array resyncing a couple of times without issues.
> >> Only one time I interrupted an array during growth process and I h=
ad
> >> an old version of mdadm (2.6.3) which didn't support resuming that=
=2E I
> >> think Neil told me that 2.6.9 is the minimum requirement to resume=
=2E
> >
> > It's 2.6.7.2. =A0Debian does not admit new software into its distro=
 until
> they
> > are rock hard stable, unless it is a bug fix release. =A0I guess I'=
ll have
> to
> > wait a few more days.
> >
>=20
> You could seek out a testing version or compile it your self.  mdadm
> doesn't depend on that much...

	Yes, I could, butt these are servers, and one of the main reasons I
run Debian on them is stability.  'Not that I have a huge issue with
compiling from source, generally speaking, but I much prefer to keep
everything on these systems wholly in the stable release whenever possi=
ble.
With Debian, that's usually 9 months or so after a piece of software is
released as stable in the other distros.

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
