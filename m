From: pg@lxra2.for.sabi.co.UK (Peter Grandi)
Subject: Re: XFS on top RAID10 with odd drives count and 2 near copies
Date: Sun, 19 Feb 2012 14:46:39 +0000
Message-ID: <20289.2895.638940.48172@tree.ty.sabi.co.UK>
References: <CAGqmV7o7AQFY1K-1JLDk02Cv6GpAUQFjiSdM2Wbdbu6Zh_t0Wg@mail.gmail.com>
	<4F35E925.6000003@hardwarefreak.com>
	<CAGqmV7rBa39U-RWkzH-cTci1pNrrY1sfS=DkyK1wHE80bMt6qA@mail.gmail.com>
	<4F38FD5D.1010201@hardwarefreak.com>
	<CAGqmV7o6SNGV_A=iP2-uJXAJpPwh83GuqTZ-BzuY6vceMJJPVg@mail.gmail.com>
	<20120213230228.GA5822@www5.open-std.org>
	<4F39D9B2.3050305@hardwarefreak.com>
	<20120214113832.GA6157@www5.open-std.org>
	<4F3AEDEF.2000608@hardwarefreak.com>
	<20120215083058.GA8821@cthulhu.home.robinhill.me.uk>
	<4F3BB385.4000608@hardwarefreak.com>
	<4F3BD1F6.8080309@westcontrol.com>
	<4F3E5325.3060001@hardwarefreak.com>
	<4F3E6ADB.2040005@westcontrol.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F3E6ADB.2040005@westcontrol.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

[ ... ]

>> What is the stripe spindle width of a 7 drive mdraid near array?

> With "near" layout, it is basically 3.5 spindles. [ ... ]

[ ... ]

>> [ ... ] The n,r rotate the data and mirror data writes around
>> the 4 drives.  So it is possible, and I assume this is the
>> case, to write data and mirror data 4 times, making the
>> stripe width 4, even though this takes twice as many RAID IOs
>> compared to the standard RAID10 lyout. [ ... ]

> I think you are probably right here - it doesn't make sense to
> talk about a "3.5" spindle width.

As per my previous argument, the XFS stripe width here does not
matter, so the question here is really:

 "What is the IO transaction size that gives best sustained
  sequential single thread performance with 'O_DIRECT'?"

Note that the "with 'O_DIRECT'" qualification matters a great
deal because otherwise the page cache makes the application's IO
size largely irrelevant, making relevant the rate at which it
would issue read or write requests.

While I understand why a tempting answer is 3.5 *chunks*, the
best answer is 7 chunks because:

  * With a '2' layout the chunk pattern repeats every 14 chunks
    (more generally over the GCF of '2' and the number of
    devices in a stripe) so we need only consider two.

  * In the first stripe there are 3 pairs and at end one half
    pair, and in the second stripe there is one half pair and 3
    pairs.

  * It is pointless for *single threaded* access to read both
    chunks in a mirror pair. Without loss of generality, let's
    assume that we read just the first.

  * Then in the first stripe we can read 4 chunks in parallel,
    and in the second stripe 3, as the first chunk of that stripe
    is a copy of one we already read in the first row.

  * We don't need to choose between 3, 4 or 3.5 chunks; because
    if we read 7 chunks at a time we end up reading two full
    stripes, in the shortest time possible for two stripes.

  * The same argument applies to both reads and writes, even if
    writes have to write both members of each pair.

  * Stripe boundaries don't matter, but chunk boundaries matter
    to maximize the transfer per disk, if transfers have
    noticeable fixed costs that matters.

Thus in some way it is 3.5 chunks per stripe "on average".

> If you call it 7, then it should work well even though each
> write takes two operations.

The number is right, but per the argument above this applies to
both reads and writes (with the given qualifications), and the
"two operations" probably means "over two stripes".
