From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: Paranoid mode for RAID-1 ?
Date: Mon, 27 Apr 2015 17:15:51 +0100
Message-ID: <553E60B7.2060706@youngman.org.uk>
References: <1610581828.22506051.1430116628556.JavaMail.zimbra@laposte.net> <972437107.22507366.1430116679975.JavaMail.zimbra@laposte.net> <20150427164924.2aee3831@notabene.brown> <1670710921.23079769.1430131923662.JavaMail.zimbra@laposte.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1670710921.23079769.1430131923662.JavaMail.zimbra@laposte.net>
Sender: linux-raid-owner@vger.kernel.org
To: Jean-Baptiste Thomas <cau2jeaf1honoq@laposte.net>
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 27/04/15 11:52, Jean-Baptiste Thomas wrote:
> On 2015-04-27 16:49 +1000, NeilBrown wrote:
>> On Mon, 27 Apr 2015 08:37:59 +0200 (CEST) Jean-Baptiste Thomas
>> <cau2jeaf1honoq@laposte.net> wrote:
>> =C2=B7
>>> I'm looking for a way to get MD to operate in a mode in which
>>> reading a sector from a RAID-1 device would not succeed until it
>>> got matching data from at least two components.
>> =C2=B7
>> No, there is no such thing.
>=20
> Thanks, now I can move on to working on plan B.
>                                 =20
>> There "should" be no circumstance which would make it worth while.
>> A drive may well report an error, but it should *never* report
>> incorrect data as though it were correct.  That is horribly
>> broken.
>=20
> Isn't it. <g>
>=20
>> The cost of running in a "safe" mode would be high, and the
>> likely benefit extremely low.  So it is unlikely that anyone
>> would use it for long.  So implementing it seems rather
>> pointless.
>=20
> How high would the cost be ?=20
>=20
> Seems to me that a 4-component RAID-1 with a 2-component quorum
> would incur no more I/O or CPU overhead than, say, a 4-component
> RAID-6. Less, in fact, unless parity computation is faster than
> memcmp().=20
>=20
> Given the choice between that sort of cost and the possibility
> of massive data corruption because one drive had a hiccup, I
> would not even THINK about running without it.

Well, I've already mentioned the Pr1me technique, but imho that belongs
in the layer that actually writes to the disk. Snag is, it doubles the
required disk space so I don't know how it would fit ...

And I don't remember the maths so I can't tell you *how* it did it, but
for each byte of data it created a parity byte (which is why it doubles
the disk requirement). From that, a single-bit error was guaranteed to
tell you whether the data byte or the parity byte was wrong. If the dat=
a
was wrong, you could reconstruct it from the parity. If there was a
two-bit error, you stood a 95% chance or thereabouts of recovery.

So this isn't raid, it won't protect you against disk failure (unless
you put data and parity on separate disks, which then costs a
double-read instead), but at least a read can then return e_data_error
if something goes wrong. But you're looking at only 25% of your disk
space being "usable" for a fast mirror if you do this.
>=20
>> That said: if someone were to provide an implementation I=20
>> would certainly consider reviewing it and adding it to md.
>=20
> Great. Don't think it'll be me, though. :-/

Nor me neither. I'd love to try, but time is not my friend at the momen=
t.

Cheers,
Wol

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
