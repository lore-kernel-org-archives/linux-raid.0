From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: RAID6 r-m-w, op-journaled fs, SSDs
Date: Sat, 30 Apr 2011 18:02:13 +0200
Message-ID: <20110430180213.6dcfc41c@galadriel2.home>
References: <19900.10868.583555.849181@tree.ty.sabi.co.UK>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <19900.10868.583555.849181@tree.ty.sabi.co.UK>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Grandi <pg_xf2@xf2.for.sabi.co.UK>, Linux fs JFS <jfs-discussion@lists.SourceForge.net>
Cc: Linux RAID <linux-raid@vger.kernel.org>, Linux fs XFS <xfs@oss.sgi.com>
List-Id: linux-raid.ids

Le Sat, 30 Apr 2011 16:27:48 +0100 vous =C3=A9criviez:

> While I agree with BAARF.com arguments fully, I sometimes have
> to deal with legacy systems with wide RAID6 sets (for example 16
> drives, quite revolting)

Revolting for what? I manage hundreds of such systems, but 99% of them
are used for video storage (typical file size range is several to
hundred of GBs).

> Sometimes (but fortunately not that recently) I have had to deal
> with small-file filesystems setup on wide-stripe RAID6 setup

What do you call "wide stripe" exactly? Do you mean a 256K stripe, a
4MB stripe?

> by
> morons who don't understand the difference between a database
> and a filesystem (and I have strong doubts that RAID6 is
> remotely appropriate to databases).

RAID-6 isn't appropriate for databases, but work reasonably well if the
workflow is almost only reading. And creating hundreds of millions of
files in a filesystem works reasonably well, too.

> So I'd like to figure out how much effort I should invest in
> undoing cases of the above, that is how badly they are likely to
> be and degrade over time (usually very badly).

Well, actually my bet is that it's impossible to say without you
providing much more detail on the hardware, the file IO patterns...

>=20
>   * When reading or writing part of RAID[456] stripe for example
>     smaller than a sector, what is the minimum unit of transfer
>     with Linux MD? The full stripe, the chunk containing the
>     sector, or just the sector containing the bytes to be
>     written or updated (and potentially the parity sectors)? I
>     would expect reads to always read just the sector, but not
>     so sure about writing.
>=20
>   * What about popular HW RAID host adapter (e.g. LSI, Adaptec,
>     Areca, 3ware), where is the documentation if any on how they
>     behave in these cases?

I may be wrong but in my tests, both Linux RAID and 3Ware, LSI and
Adaptec controllers (didn't really tested Areca on that point) would
read the full stripe most of the time. At least, they'll read the full
stripe in a single thread environment. However, when using many
concurrent threads the behaviour changes and they seem to work at chunk
level.
=20
> Regardless, op-journaled file system designs like JFS and XFS
> write small records (way below a stripe set size, and usually
> way below a chunk size) to the journal when they queue
> operations, even if sometimes depending on design and options
> may "batch" the journal updates (potentially breaking safety
> semantics). Also they do small write when they dequeue the
> operations from the journal to the actual metadata records
> involved.
>=20
> How bad can this be when the journal is say internal for a
> filesystem that is held on wide-stride RAID6 set?

Not that bad because typically the journal is small enough to fit
entirely in the controller cache.

> I suspect very
> very bad, with apocalyptic read-modify-write storms, eating IOPS.

Not if you're using write-back cache.

--=20
-----------------------------------------------------------------------=
-
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
-----------------------------------------------------------------------=
-
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
