From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: Mismatches
Date: Sun, 2 Jan 2011 22:03:06 -0600
Message-ID: <0F.A5.07087.B7A412D4@cdptpa-omtalb.mail.rr.com>
References: <AANLkTiktpsFekCNFcnGcC1wu8_LD14w5WodvH8NiVc3A@mail.gmail.com>
Reply-To: <lrhorer@satx.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTiktpsFekCNFcnGcC1wu8_LD14w5WodvH8NiVc3A@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: 'Mark Knecht' <markknecht@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> -----Original Message-----
> From: Mark Knecht [mailto:markknecht@gmail.com]
> Sent: Sunday, January 02, 2011 7:58 PM
> To: lrhorer@satx.rr.com
> Cc: linux-raid@vger.kernel.org
> Subject: Re: Mismatches
>=20
> On Sun, Jan 2, 2011 at 5:53 PM, Leslie Rhorer <lrhorer@satx.rr.com> w=
rote:
> <SNIP>
> >
> >> It was my understanding when researching RAID6 last week that the =
two
> >> parity calculations are actually different. Only one of them is si=
mple
> >> parity. The the other is part of an advanced math degree. ;-)
> >> (According to Wikipedia, not a definitive source for sure...)
> >
> > =A0 =A0 =A0 =A0Well, that's encouraging, if true. =A0It doesn't exp=
lain how big
> > chunks of data in almost every large file got corrupted, though.
> >
> >
>=20
> If it's real and not some strange bug then it certainly doesn't.
>=20
> Neil had some very good responses.
>=20
> Also, what does
>=20
> smartctl -a /dev/sdX say for each drive? Any indication at all of
> _any_ drive having problems?

	Well, not exactly, no.  Some of the drives do have errors, but none
have any huge amount.  Most of the errors were accumulated when I had a=
 bad
RAID chassis a couple of years ago that caused all sorts of grief.  Mos=
t of
the drives have been quiet since then, with the exception of the Hitach=
i
drives.  All six Hitachi drives show an event 675 hours (28 days, 3 hou=
rs)
ago.  None of the other drives show anything in that time frame, and no=
ne of
the drives at all show anything since.  That must have been when the sy=
stem
croaked after starting the RAID reshape.  I don't see how that, in and =
of
itself, would cause all those mismatches.

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
