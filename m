From: Neil Brown <neilb@suse.de>
Subject: Re: MD write performance issue - found Catalyst patches
Date: Thu, 29 Oct 2009 17:41:21 +1100
Message-ID: <19177.14609.138378.581065@notabene.brown>
References: <66781b10910180300j2006a4b7q21444bb27dd9434e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=unknown
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from mark delfman on Sunday October 18
Sender: linux-raid-owner@vger.kernel.org
To: mark delfman <markdelfman@googlemail.com>
Cc: =?ISO-8859-1?Q?Mattias_Hellstr=F6m?= <hellstrom.mattias@gmail.com>, Linux RAID Mailing List <linux-raid@vger.kernel.org>, npiggin@suse.de
List-Id: linux-raid.ids

On Sunday October 18, markdelfman@googlemail.com wrote:
> We have tracked the performance drop to the attached two commits in
> 2.6.28.6.    The performance never fully recovers in later kernels so
> I presuming that the change in the write cache is still affecting MD
> today.
>=20
> The problem for us is that although we have slowly tracked it down, w=
e
> have no understanding of linux at this level and simply wouldn=92t kn=
ow
> where go from this point.
>=20
> Considering this seems to only effect MD and not hardware based RAID
> (in our tests) I thought that this would be an appropriate place to
> post these patches and findings.
>=20
> There are 2 patches which impact MD performance via a filesystem:
>=20
> a) commit 66c85494570396661479ba51e17964b2c82b6f39 - write-back: fix
> nr_to_write counter
> b) commit fa76ac6cbeb58256cf7de97a75d5d7f838a80b32 - Fix page
> writeback thinko, causing Berkeley DB slowdown
>=20

I've had a look at this and asked around and I'm afraid there doesn't
seem to be an easy answer.

The most likely difference between 'before' and 'after' those patches
is that more pages are being written per call to generic_writepages in
the 'before' case.  This would generally improve throughput,
particularly with RAID5 which would get more full stripes.

However that is largely a guess as the bugs which were fixed by the
patch could interact in interesting ways with XFS (which decrements
->nr_to_write itself) and it isn't immediately clear to me that more
pages would be written...=20

In any case, the 'after' code is clearly correct, so if throughput can
really be increased, the change should be somewhere else.

What might be useful would be to instrument write_cache_pages to count
how many pages were written each time it calls.  You could either
print this number out every time or, if that creates too much noise,
print out an average ever 512 calls or similar.

Seeing how this differs with and without the patches in question could
help understand what is going one and provide hints for how to fix it.

NeilBrown
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
