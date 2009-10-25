From: Christopher Chen <muffaleta@gmail.com>
Subject: Re: Is My Data DESTROYED?!
Date: Sat, 24 Oct 2009 18:50:56 -0700
Message-ID: <7bc80d500910241850o605a8178j247d266bf5fa7ea8@mail.gmail.com>
References: <4AE2410A.10603@panix.com>
	 <20091025013654947.PLSH17264@cdptpa-omta04.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091025013654947.PLSH17264@cdptpa-omta04.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Leslie Rhorer <lrhorer@satx.rr.com>
Cc: berk walker <berk@panix.com>, Mattias Wadenstein <maswan@acc.umu.se>, Christian Pernegger <pernegger@gmail.com>, linux-raid@vger.kernel.org, adfas asd <chimera_god@yahoo.com>
List-Id: linux-raid.ids

On Sat, Oct 24, 2009 at 6:36 PM, Leslie Rhorer <lrhorer@satx.rr.com> wr=
ote:
>> Sir - Whereas Neil, et al, profess that RAID is NOT equal to BACKUP =
-
>> Most of us know that tape backup is VERY costly, in several ways, in=
 our
>
> =A0 =A0 =A0 =A0No one used the word "tape". =A0Tapes have not been a =
practical means
> of backups for many systems for quite some years. =A0Today, for most =
large
> systems, the most practical backup solution is hard drive based. =A0S=
ince the
> OP already has a RAID10 system he has enough or nearly enough drives =
for a
> hard drive based backup. =A0Since he is already talking about a remot=
e NAS
> system, his additional costs can be as low as $0, or at most the cost=
 two or
> three additional drives.

I think that may be a point of contention. Places where I've worked,
primary data stores, on the order of hundreds of terabytes have been
backed up to tape, and were part of an offsite rotation. Does that
mean everyone can? Maybe not. But if people can afford to purchase
multi-million dollar SAN and NAS systems, they can certainly afford a
tape library and some LTO tapes. Is it expensive? Certainly. But often
disk-based backups can provide a false sense of economy--disks use
power, take up rack space, generate heat--these are all things people
should consider when building out a data center.

But, of course, he's not building out a data center, and he's probably
not going to buy LTO4 drives either.

Did we use disk-based backups? Certainly, and often as a part of a
snapshot system where you could go "yesterday" and pick up data. But
they were shipped to tape too.

But, like I said, data is only important if it's important, and for
some organizations, it's VERY important :)

cc

--=20
Chris Chen <muffaleta@gmail.com>
"The fact that yours is better than anyone else's
is not a guarantee that it's any good."
-- Seen on a wall
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
