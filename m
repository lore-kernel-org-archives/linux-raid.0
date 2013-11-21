From: David Brown <david.brown@hesbynett.no>
Subject: Re: Triple parity and beyond
Date: Thu, 21 Nov 2013 11:13:29 +0100
Message-ID: <528DDCC9.7050701@hesbynett.no>
References: <CAGKKSfWO4qTZsbd-=10cKc7=O7hTCVceMVQvCTJcUh1Z_gW04Q@mail.gmail.com> <20131119181237.GA3666@lazy.lzy> <528C9297.9030801@hesbynett.no> <20131120215939.GA2622@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20131120215939.GA2622@lazy.lzy>
Sender: linux-btrfs-owner@vger.kernel.org
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Cc: Andrea Mazzoleni <amadvance@gmail.com>, linux-raid@vger.kernel.org, linux-btrfs@vger.kernel.org, hpa@zytor.com, creamyfish@gmail.com
List-Id: linux-raid.ids

On 20/11/13 22:59, Piergiorgio Sartor wrote:
> On Wed, Nov 20, 2013 at 11:44:39AM +0100, David Brown wrote:
> [...]
>>> In RAID-6 (as per raid6check) there is an easy way
>>> to verify where an HDD has incorrect data.
>>>
>>
>> I think the way to do that is just to generate the parity blocks fro=
m
>> the data blocks, and compare them to the existing parity blocks.
>=20
> Uhm, the generic RS decoder should try all
> the possible combination of erasure and so
> detect the error.
> This is unfeasible already with 3 parities,
> so there are faster algorithms, I believe:
>=20
> Peterson=E2=80=93Gorenstein=E2=80=93Zierler algorithm
> Berlekamp=E2=80=93Massey algorithm
>=20
> Nevertheless, I do not know too much about
> those, so I cannot state if they apply to
> the Cauchy matrix as explained here.
>=20
> bye,
>=20

Ah, you are trying to find which disk has incorrect data so that you ca=
n
change just that one disk?  There are dangers with that...

<http://neil.brown.name/blog/20100211050355>

If you disagree with this blog post (and I urge you to read it in full
first), then this is how I would do a "smart" stripe recovery:


=46irst calculate the parities from the data blocks, and compare these
with the existing parity blocks.

If they all match, the stripe is consistent.

Normal (detectable) disk errors and unrecoverable read errors get
flagged by the disk and the IO system, and you /know/ there is a proble=
m
with that block.  Whether it is a data block or a parity block, you
re-generate the correct data and store it - that's what your raid is fo=
r.

If you have no detected read errors, and there is one parity
inconsistency, then /probably/ that block has had an undetected read
error, or it simply has not been written completely before a crash.
Either way, just re-write the correct parity.

If there are two or more parity inconsistencies, but not all parities
are in error, then you either have multiple disk or block failures, or
you have a partly-written stripe.  Any attempts at "smart" correction
will almost certainly be worse than just re-writing the new parities an=
d
hoping that the filesystem's journal works.

If all the parities are inconsistent, then the "smart" thing is to look
for a single incorrect disk block.  Just step through the blocks one by
one - assume that block is wrong and replace it (in temporary memory,
not on disk!) with a recovered version from the other data blocks and
the parities (only the first parity is needed).  Re-calculate the other
parities and compare.  If the other parities now match, then you have
found a single inconsistent data block.  It /may/ be a good idea to
re-write this - or maybe not (see the blog post linked above).

If you don't find any single data blocks that can be "corrected" in thi=
s
way, then re-writing the parity blocks to match the disk data is
probably the least harmful fix.


Remember, this is not a general error detection and correction scheme -
it is a system targeted for a particular type of use, with particular
patterns of failure and failure causes, and particular mechanisms on to=
p
(journalled file systems) to consider.


--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
