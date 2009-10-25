From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: Is My Data DESTROYED?!
Date: Sat, 24 Oct 2009 21:20:47 -0500
Message-ID: <20091025022051205.ZCDW12118@cdptpa-omta02.mail.rr.com>
References: <7bc80d500910241850o605a8178j247d266bf5fa7ea8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <7bc80d500910241850o605a8178j247d266bf5fa7ea8@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of Christopher Chen
> Sent: Saturday, October 24, 2009 8:51 PM
> To: Leslie Rhorer
> Cc: berk walker; Mattias Wadenstein; Christian Pernegger; linux-
> raid@vger.kernel.org; adfas asd
> Subject: Re: Is My Data DESTROYED?!
>=20
> On Sat, Oct 24, 2009 at 6:36 PM, Leslie Rhorer <lrhorer@satx.rr.com>
> wrote:
> >> Sir - Whereas Neil, et al, profess that RAID is NOT equal to BACKU=
P -
> >> Most of us know that tape backup is VERY costly, in several ways, =
in
> our
> >
> > =A0 =A0 =A0 =A0No one used the word "tape". =A0Tapes have not been =
a practical
> means
> > of backups for many systems for quite some years. =A0Today, for mos=
t large
> > systems, the most practical backup solution is hard drive based. =A0=
Since
> the
> > OP already has a RAID10 system he has enough or nearly enough drive=
s for
> a
> > hard drive based backup. =A0Since he is already talking about a rem=
ote NAS
> > system, his additional costs can be as low as $0, or at most the co=
st
> two or
> > three additional drives.
>=20
> I think that may be a point of contention. Places where I've worked,
> primary data stores, on the order of hundreds of terabytes have been
> backed up to tape, and were part of an offsite rotation. Does that

	True.  In the case of many, many terrabytes of data, and if
accessibility is not an issue, tapes can be the backup of choice.  That=
's
why I said, "for many systems".  If the cost of the drive subsystems is=
 in
excess of $100K, then spending $40K for a tape drive makes sense, rathe=
r
than spending another $100K - $20M for a drive based solution.  If the =
total
backup is less than 50T in size, or if availability is a concern, then =
tapes
are not a good solution.  Right now, at least, tapes cost a bit less th=
an
inexpensive disks, but the drive is quite costly.  It is only once the =
cost
of the tapoe drive is swamped by the cost of the main drive systems tha=
t the
tape is more attractive economically.

> mean everyone can? Maybe not. But if people can afford to purchase
> multi-million dollar SAN and NAS systems, they can certainly afford a
> tape library and some LTO tapes.

	Yeah, but this is a guy with a 4T MythTV server at his house.  If he
were General Motors searching for a backup solution, I would advise him
differently.  If he were a storage solutions company, I would advise hi=
m
differently again.  The solution needs to fit the application.

> Is it expensive? Certainly. But often
> disk-based backups can provide a false sense of economy--disks use
> power, take up rack space, generate heat--these are all things people
> should consider when building out a data center.

	This isn't for a data center.  For giant systems, these are all a
consideration.  For systems less than 100T in size, they really aren't.
What's more, cold drives don't use any more power than a tape.  For med=
ium
to large sized off-site backups, removable hard drives are a very attra=
ctive
solution.  At about $60 a terrabyte and less than $500 for the enclosur=
e,
it's hard to beat.

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
