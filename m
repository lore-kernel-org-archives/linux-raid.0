From: "Peter T. Breuer" <ptb@it.uc3m.es>
Subject: Re: raid1 bitmap code [Was: Re: Questions answered by Neil Brown]
Date: Thu, 27 Feb 2003 00:24:56 +0100 (MET)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200302262324.h1QNOu711769@oboe.it.uc3m.es>
References: <15965.15322.459068.818409@notabene.cse.unsw.edu.au>
Reply-To: ptb@it.uc3m.es
Mime-Version: 1.0
Content-Type: text/plain; charset=UNKNOWN-8BIT
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <15965.15322.459068.818409@notabene.cse.unsw.edu.au> from Neil Brown
 at "Feb 27, 2003 09:12:42 am"
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: ptb@it.uc3m.es, Paul Clements <Paul.Clements@SteelEye.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi!

"A month of sundays ago Neil Brown wrote:"
> 1/ You don't want or need very fine granularity.  The value of this i=
s
>    to speed up resync time.  Currently it is limited by drive

The map is also used to "journal" async writes. So I think that makes
it necessary to have granularity the same size as a write. Otherwise
we cannot meaningfully mark the map clean again when the async write
completes.

>    bandwidth.  If you have lots of little updates due to fine
>    granularity, you will be limited by seek time.

While your observation is undoubtedly correct, since the resync is
monotonic the seeks will all be in the same direction.  That cannot be
any slower than actually traversing while writing, can it?  And IF it i=
s
the case that it is slower, we can always do "writeahead" in the resync
- that is, when we see a block is marked dirty in the resync, resync it
AND some number of following blocks, then look again.

We can even look at the bitmap fairly carefully and decide what strateg=
y
to use in resync, part by part.  I've now (earlier this evening) altere=
d
the bitmap so that it accounts the number of dirty bits per bitmap page
(i.e.  how many dirty blocks per 4096 blocks at the moment) and if it's
more than some proportion we can write the whole lot.

>    such that it takes about as long to read or write a chunk and it
>    would to seek to the next one.  This probably means a few hundred
>    kilobytes.  i.e. one bit in the bitmap for every hundred K.
>    This would require a 125K bitmap for a 100Gig drive.
>=20
>    Another possibility would be a fixed size bitmap - say 4K or 8K.
>=20
>    An 8K bitmap used to map a 100Gig drive would be 1.5Meg per bit.
> =20
>    This may seem biggish, but if your bitmap were sparse, resync woul=
d
>    still be much much faster, and if it were dense,  having a finer
>    grain in the bitmap isn't going to speed things up much.

The objection that it couldn't be used for journalling holds, I think.

> 2/ You cannot allocate the bitmap on demand. =20
>    Demand happens where you are writing data out, and when writing

That was taken account of in the botmap code design.  If the kmalloc
fails for a bitmap page, it will write the address of the page as "1" i=
n
the page array which the bitmap will then understand as "all 4096 block=
s
dirty" during resync.

Ummm ... yes, it clears the whole thing correctly after the resync too.

>    data out due to high memory pressure, kmalloc *will* fail.
>    Relying on kmalloc in the write path is BAD.  That is why we have

I didn't :-)

>    mempools which pre-allocate.
>    For the bitmap, you simply need to pre-allocate everything.

I think we can breathe easy here - the bitmap code is designed to fail
correctly, so that the semantics is appropriate. It marks a page
that can't be obtained via kmalloc as all-dirty by setting its address
as 1.

Curiously enough, I'm slightly more nonplussed by the problem of
kfreeing the bitmap pages when their dirty count drops to zero.
I can foresee that when journalling we will go 0 1 0 1 0 1 in terms
of number of bits dirty in the map, and if we kfree after the
count drops to zero each time, and kmalloc when we should set
the count to 1, then we will be held up. And maybe sleep when we
shouldn't - the bitmap lock is held for some ops. Needs checking.

What should I do? Maintain a how-many-times-we-have-wanted-to-free-this
page count and only free it on the 10th attempt?


> 3/ Internally, you need to store a counter for each 'chunk' (need a
>    better word, this is different from the raid chunksize, this is th=
e
>    amount of space that each bit refers to).
>    The counter is needed so you know when the bit can be cleared.
>    This too must be pre-allocated and so further limits the size of
>    your bitmap.

I'm not sure what you mean here. At the moment (since earlier this
evening) there IS a counter for each page in the bitmap saying how many
bits in it are dirty.

Oh - I see, you are considering the case when there is more than one
block =FEer bit.=20

Really - I think it's too complicated to fly, at least for the moment.=20

I'm really not worried about the memory used by the bitmap! If you
would fix md so it could have 4K blocksize we'd probably gain more.
But that code has bs=3D1K and sectors/blk=3D2 assumptions all over!

Currently, the max blocks in a md device is 2^31. At one bit per
block and 8bits per byte that's 2^28 bytes of bitmap, or 256MB,
if it were to become completely full. I am sure that people who have
1TB of disk can afford 256MB of ram to service it with.

>    16 bit counters would use less ram and would allow 33553920 bytes=20
>    (65535 sectors) per 'chunk' which, with an 8K bitmap, puts an uppe=
r
>    limit of 2 terabytes per device, which I think is adequate. (that'=
s
>    per physical device, not per raid array).

The current counters (dirty bits per bitmap page) are 16 bit. SIgned.

>    Or you could just use 32 bit counters.
>=20
> 4/ I would use device plugging to help reduce the number of times you
>    have to write the intent bitmap.
>    When a write comes in, you set the bit in the bitmap, queue the
>    write on a list of 'plugged' requests, and mark the device as
>    'plugged'.  The device will eventually be unplugged, at which poin=
t
>    you write out the bitmap, then release all the requests to the
>    lower devices.

Hmmm .. that's interesting. But bitmap access was meant to be cheap.
Whether I succeeded is another question! If not someone else can
rewrite.

>    You could optimise this a bit, and not bother plugging the device
>    if it wasn't already plugged, and the request only affected bits
>    that were already set.

There are very good ideas indeed there. Thank you very much. I
appreciate it!

Peter
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
