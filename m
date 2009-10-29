From: Thomas Fjellstrom <tfjellstrom@shaw.ca>
Subject: Re: MD write performance issue - found Catalyst patches
Date: Thu, 29 Oct 2009 00:48:27 -0600
Message-ID: <200910290048.28045.tfjellstrom@shaw.ca>
References: <66781b10910180300j2006a4b7q21444bb27dd9434e@mail.gmail.com> <19177.14609.138378.581065@notabene.brown>
Reply-To: tfjellstrom@shaw.ca
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <19177.14609.138378.581065@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: mark delfman <markdelfman@googlemail.com>, Mattias =?iso-8859-1?q?Hellstr=F6m?= <hellstrom.mattias@gmail.com>, Linux RAID Mailing List <linux-raid@vger.kernel.org>, npiggin@suse.de
List-Id: linux-raid.ids

On Thu October 29 2009, Neil Brown wrote:
> On Sunday October 18, markdelfman@googlemail.com wrote:
> > We have tracked the performance drop to the attached two commits in
> > 2.6.28.6.    The performance never fully recovers in later kernels =
so
> > I presuming that the change in the write cache is still affecting M=
D
> > today.
> >
> > The problem for us is that although we have slowly tracked it down,=
 we
> > have no understanding of linux at this level and simply wouldn=92t =
know
> > where go from this point.
> >
> > Considering this seems to only effect MD and not hardware based RAI=
D
> > (in our tests) I thought that this would be an appropriate place to
> > post these patches and findings.
> >
> > There are 2 patches which impact MD performance via a filesystem:
> >
> > a) commit 66c85494570396661479ba51e17964b2c82b6f39 - write-back: fi=
x
> > nr_to_write counter
> > b) commit fa76ac6cbeb58256cf7de97a75d5d7f838a80b32 - Fix page
> > writeback thinko, causing Berkeley DB slowdown
>=20
> I've had a look at this and asked around and I'm afraid there doesn't
> seem to be an easy answer.
>=20
> The most likely difference between 'before' and 'after' those patches
> is that more pages are being written per call to generic_writepages i=
n
> the 'before' case.  This would generally improve throughput,
> particularly with RAID5 which would get more full stripes.
>=20
> However that is largely a guess as the bugs which were fixed by the
> patch could interact in interesting ways with XFS (which decrements
> ->nr_to_write itself) and it isn't immediately clear to me that more
> pages would be written...
>=20
> In any case, the 'after' code is clearly correct, so if throughput ca=
n
> really be increased, the change should be somewhere else.
>=20
> What might be useful would be to instrument write_cache_pages to coun=
t
> how many pages were written each time it calls.  You could either
> print this number out every time or, if that creates too much noise,
> print out an average ever 512 calls or similar.
>=20
> Seeing how this differs with and without the patches in question coul=
d
> help understand what is going one and provide hints for how to fix it=
=2E
>

I don't suppose this causes "bursty" writeout like I've been seeing lat=
ely?=20
=46or some reason writes go full speed for a short while and then just =
stop=20
for a short time, which averages out to 2-4x slower than what the array=
=20
should be capable of.

> NeilBrown
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--=20
Thomas Fjellstrom
tfjellstrom@shaw.ca
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
