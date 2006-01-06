From: Simon Valiquette <v.simon@ieee.org>
Subject: Re: Fwd: Linux MD raid5 and reiser4... Any experience ?
Date: Fri, 06 Jan 2006 04:47:05 -0500
Message-ID: <43BE3C99.4050706@ieee.org>
References: <fd8d0180601050104x15079396h@mail.gmail.com>	 <fd8d0180601050106s5f5b4306o@mail.gmail.com>	 <87oe2r2d93.fsf@rimspace.net> <fd8d0180601050321k19f12f53r@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <fd8d0180601050321k19f12f53r@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

=46rancois Barre a =E9crit :
> 2006/1/5, Daniel Pittman <daniel@rimspace.net>:
>=20
>>Francois Barre <francois.barre@gmail.com> writes:
>>
>>>Well, I think everything is in the subject... I am looking at this
>>>solution for a 6*250GB raid5 data server, evolving in a 12*250 rai5 =
in
>>>the months to come... Performance is absolutely not a big issue for
>>>me, but I would not appreciate any data loss.
>=20
> Well, as far as I understood it (that is, not so far :-p), reiser4
> seemed to have a stronger and more efficient journal than ext3. That
> is not what everyone believes, but reiser4 was to be designed that wa=
y
> more or less... But I guess that ext3 and its very-heavily-tested
> journal can still be more trusted than any newcomer.
>=20
> Truth is, I would have been glad to play with reiser4 on a large
> amount of data, just because I was interrested on the theories behind
> it (including the database-filesystem strange wedding Hans tried to
> organize). Maybe it's too great a risk for a production system.
>=20
> Well, anyway, thanks for the advice. Guess I'll have to stay on ext3
> if I don't want to have nightmares...

  AFAIK, ext3 volume cannot be bigger than 4TB on a 32 bits system.
I think it is important you know that in case it could be a concern
for you.

  Personnally, I also don't like using ext2/3 on a array bigger than
2TB.  With 12x250GB, you are already well over 2TB, and maybe some day
you will realize that you needs more than 4TB.  If you have a 64 bits
computers, just forget what I said (16TB is the limit).

  On production server with large RAID array, I tends to like very
much XFS and trust it more than ReiserFS (I had some bad experience
with ReiserFS in the past).  You can also grow a XFS filesystem live,
which is really nice.

  XFS is finally much faster than EXT3 and self-defragmenting, but
that was not a concern for you anyway.

Simon Valiquette
http://gulus.USherbrooke.ca
http://www.gulus.org

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
