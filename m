From: Jean-Baptiste Thomas <cau2jeaf1honoq@laposte.net>
Subject: Re: Paranoid mode for RAID-1 ?
Date: Mon, 27 Apr 2015 12:52:03 +0200 (CEST)
Message-ID: <1670710921.23079769.1430131923662.JavaMail.zimbra@laposte.net>
References: <1610581828.22506051.1430116628556.JavaMail.zimbra@laposte.net> <972437107.22507366.1430116679975.JavaMail.zimbra@laposte.net> <20150427164924.2aee3831@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150427164924.2aee3831@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2015-04-27 16:49 +1000, NeilBrown wrote:
> On Mon, 27 Apr 2015 08:37:59 +0200 (CEST) Jean-Baptiste Thomas
> <cau2jeaf1honoq@laposte.net> wrote:
>=C2=B7
> > I'm looking for a way to get MD to operate in a mode in which
> > reading a sector from a RAID-1 device would not succeed until it
> > got matching data from at least two components.
>=C2=B7
> No, there is no such thing.

Thanks, now I can move on to working on plan B.
                                =20
> There "should" be no circumstance which would make it worth while.
> A drive may well report an error, but it should *never* report
> incorrect data as though it were correct.  That is horribly
> broken.

Isn't it. <g>

> The cost of running in a "safe" mode would be high, and the
> likely benefit extremely low.  So it is unlikely that anyone
> would use it for long.  So implementing it seems rather
> pointless.

How high would the cost be ?=20

Seems to me that a 4-component RAID-1 with a 2-component quorum
would incur no more I/O or CPU overhead than, say, a 4-component
RAID-6. Less, in fact, unless parity computation is faster than
memcmp().=20

Given the choice between that sort of cost and the possibility
of massive data corruption because one drive had a hiccup, I
would not even THINK about running without it.

> That said: if someone were to provide an implementation I=20
> would certainly consider reviewing it and adding it to md.

Great. Don't think it'll be me, though. :-/
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
