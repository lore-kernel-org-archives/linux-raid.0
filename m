From: pg@lxra2.for.sabi.co.UK (Peter Grandi)
Subject: Re: SMART, RAID and real world experience of failures.
Date: Mon, 9 Jan 2012 14:50:50 +0000
Message-ID: <20234.65226.464692.42166@tree.ty.sabi.co.UK>
References: <4F063808.6040000@crc.id.au>
	<20230.55643.346235.891308@tree.ty.sabi.co.UK>
	<4F06DDAC.1050501@crc.id.au>
	<4F06F969.1010205@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F06F969.1010205@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

>>> I got a SMART error email yesterday from my home server with a 4
>>> x 1Tb RAID6. [ ... ]

>>> That's an (euphemism alert) imaginative setup. Why not a 4
>>> drive RAID10? In general there are vanishingly few cases in
>>> which RAID6 makes sense, and in the 4 drive case a RAID10
>>> makes even more sense than usual. Especially with the really
>>> cool setup options that MD RAID10 offers.

> In this case, the raid6 can suffer the loss of any two drives
> and continue operating.  Raid10 cannot, unless you give up
> more space for triple redundancy.

When I see arguments like this I am sometimes (euphemism alert)
enthused by their (euphemism alert) profundity. A defense of a
4-drive RAID6 is a particularly compelling example, and this
type of (euphemism alert) astute observation even more so.

In my shallowness I had thought that one goal of redundant RAID
setups like RAID10 and RAID6 is to take advantage of redundancy
to deliver greater realiability, a statistical property, related
also to expected probability (and correlation and cost) of
failure modes, not just to geometry.

But even as to geometrical arguments, there is:

* While RAID6 can =ABsuffer the loss of any two drives and
  continue operating=BB, RAID10 can "suffer the loss of any number
  of non paired drives and continue operating", which is not
  directly comparable, but is not necessarily a weaker property
  overall (it is weaker only in the paired case and much
  stronger on the non paired case).

This ''geometric'' property is of great advantage in engineering
terms because it allows putting drives in two mostly uncorrelated
sets, and lack of correlation is a very important property in
statistical redundancy work. In practice for example this allows
putting two shelves of drives in different racks, on different
power supplies, on different host adapters, or even (with DRBD
for example) on different computers on different networks.

But this is not the whole story, because let's look at further
probabilistic aspects:

* the failure of any two paired drives is a lot less likely than
  that of any two non-paired drives;

* the failure of any two paired drives is even less likely than
  the failure of any single drive, which is by far the single
  biggest problem likely to happen (unless there are huge
  environmental common modes, outside "geometric" arguments);

* The failure of any two paired drives at the same time (outside
  rebuild) is probably less likely than the failure of any other
  RAID setup component, like the host bus adapter, or power
  supplies.

* As mentioned above, the biggest problem with redundancy is
  correlation, that is common mode of failures, for example via
  environmental factors, and RAID10 affords simpletons like me
  the luxury of setting up two mostly uncorrelated sets, while
  RAID6 (like all parity RAID) effectively tangles all drives
  together.

As to the latter, in my naive thoughts before being exposed to
the (euphemism alert) superior wisdom of the fact that =ABraid6 can
suffer the loss of any two drives and continue operating=BB I
worried about what happens *after* a failure, in particular to
common modes:

* In the common case of a loss of a single drive, the only drive
  impacted in RAID10 is the paired one, and it involves a pretty
  simple linear mirroring, with very little extra activity. This
  means that both as to performance and to environmental factors
  like extra vibration, heat and power draw the impact is minimal.
  Similarly for the loss of any N non paired drives. In all
  cases the duration of the vulnerable rebuild period is limited
  to drive duplication.

* For RAID6 the loss of one or two drives involves a massive
  whole-array activity surge, with a lot of read-write cycles on
  each drive (all drives must be both read and written), which
  both interferes hugely with array performance, and may impact
  heavily vibration, heat and power draw levels, as usually the
  drives are contiguous (and the sort of people who like RAID6
  tend to make them of identical units pulled from the same
  carton...).
  Because of the massive extra activity, the vulnerable rebuild
  period is greatly lengthened, and in this period all drives are
  subject to new and largely identical stresses, which may well
  greatly raise the probability of further failures, including
  the failures of more than 1 extra drive.

There are other little problems with parity RAID rebuilds, as
described in the BAARF.com site for example.

But the above points seemed to me a pretty huge deal to me,
before I read the (euphemism alert) imaginative geometric point
that =ABraid6 can suffer the loss of any two drives and continue
operating=BB as that be all that matters.

> Basic trade-off: speed vs. safety.

I was previously unable to imagine why one would want to trade
off much lower speed to achieve lower safety as well... :-)
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
