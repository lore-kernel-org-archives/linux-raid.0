From: Douglas Siebert <douglas-siebert@uiowa.edu>
Subject: Re: LVM striping RAID volumes
Date: Wed, 25 Jan 2012 21:42:47 -0600
Message-ID: <1327549368.3474.361.camel@slacker>
References: <1327467050.3474.303.camel@slacker>
	 <jfok2p$6vg$1@dough.gmane.org> <20256.2521.77580.864903@tree.ty.sabi.co.UK>
	 <4F204231.6040701@hesbynett.no>
Reply-To: douglas-siebert@uiowa.edu
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F204231.6040701@hesbynett.no>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david.brown@hesbynett.no>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 2012-01-25 at 18:56 +0100, David Brown wrote:
> On 25/01/12 14:55, Peter Grandi wrote:
> >>> 2) must support passing TRIM commands through the RAID layer
> >>> (e.g. ext4->LVM->RAID->SSD) to avoid write amplification that
> >>> reduces SSD lifetime and performance
> >
> >> That's not really necessary with modern SSD's - TRIM is
> >> overrated. Garbage collection on current generations is so
> >> much better than on earlier models that you generally don't
> >> have to worry about TRIM.
> >
> > Unfortunately not necessarily just for write amplification, and
> > the "cleaner" (aka garbage collector) is really helped by TRIM.
> >
> > The really big deal is that the FTL in the flash SSD cannot
> > figure out which flash-pages are unused, and cannot use a simple
> > heuristic like "it is all zeroes" because filesystem code do not
> > zero unused logical sectors when they are released but writes
> > them only much later when they are allocated. TRIM is just a a
> > way to ''write'' a logical sector as unused without zero-filling
> > it (or other implicit marks).
> >
> >> Dropping TRIM makes your life /much/ easier with SSD's,
> >> especially when you want raid.  According to some benchmarks
> >> I've seen, it also makes the disk measurably faster.
> >
> > While something like TRIM is really important, there is a bad
> > reputation of TRIM, but it is due to SATA TRIM being specified
> > badly, as it is specified to be synchronous (or cache-flushing
> > or queue flushing).
> >
>=20
> I've read about this in a few places - there are several failing poin=
ts=20
> in SATA TRIM that make it difficult to implement and much less useful=
=20
> than it could be.
>=20
> One problem is that TRIM is synchronous, as you say.  That means if i=
t=20
> is used during deletes, it makes them much slower - potentially very=20
> much slower.  Secondly, there is no consistency as to what is read ba=
ck=20
> from a trimmed sector.  Had it always been read as zero, it would sui=
t=20
> much better for raid.


As far as Linux software RAID goes, end users would currently only care
about TRIM when using using RAID with a pair of SSDs.  So in that case,
require enabling the write intent bitmaps when enabling TRIM support.  =
I
believe this would eliminate the concern about what gets read back from
a trimmed sector.  I realize benchmarks show bitmaps to slow things dow=
n
a lot, but I'm assuming that's because writing them to hard drives is
the cause due to their slow seeks.  With SSDs no such concern would
exist.

Your point about TRIM potentially slowing things down due to the
synchronous nature of the ATA 3.0 spec is well taken, but you don't hav=
e
to mount your filesystems with -o discard.  You can just run fstrim out
of cron daily.  That's exactly what I'm planning to do, and I think mos=
t
people using TRIM are doing so until SSDs support the ATA 3.1 spec's
asynchronous TRIM.


>=20
> >
> > Anyhow, apart from write amplification, the really big deal is
> > maximum write latency (and relatedly read latency!). Consider
> > this scary comparison:
> >
> >    http://www.storagereview.com/images/samsung_830_raid_256gb_write=
_latency.png
> >
> > as discussed in one of my many recent flash SSD blog entries:
> >
> >    http://www.sabi.co.uk/blog/12-one.html#120115
> >
> > Since erasing a flash-block can take a long time, it is very
> > important for minimizing the highest write latency that the FTL
> > have available a pool of pre-erased flash-blocks, so they can be
> > written (OR'ed) to directly ("overprovisioning" in most flash
> > SSDs is done to allow this too).
> >
>=20
> Overprovisioning is the key here.  When the SSD has more flash space=20
> than is visible to the OS, then that space is always guaranteed free =
-=20
> though not necessarily in contiguous erase blocks.  The more such fre=
e=20
> space there is, the higher the chances of their being free full block=
s=20
> when they are needed, and the more flexibility the SSD firmware has i=
n=20
> combining partly-written blocks to free up full erase blocks.
>=20
> So if you have sufficient free space due to overprovisioning, you qui=
te=20
> simply do not need TRIM, as TRIM is just an expensive way of increasi=
ng=20
> this free space.
>=20
> How much overprovisioning you want depends on how much you want to=20
> reduce the risk of unexpected latencies, and how much extra space you=
=20
> are willing to pay for.  More expensive (or rather, higher quality)=20
> SSD's have more overprovisioning.  You can also make your own=20
> overprovisioning by simply not allocating all the disk when partition=
ing=20
> it (or using a smaller "size" when using the whole disk in an mdadm=20
> raid).  Since there is an area that is never written to, it is=20
> effectively extra overprovisioned space.


It sounds like you are saying TRIM is unnecessary because you can just
allocate less space than you have on the device.  That may be true, but
I can equally say that overprovisioning is unnecessary because you can
just use TRIM!  Overprovisioning should only be required where it
wouldn't happen naturally, such as using an SSD for raw volumes on a DB=
=2E

Overprovisioning happens as a matter of course when used for a
filesystem, since most filesystems maintain at least 5% free space, and
sometimes more, to avoid fragmentation problems.  Unfortunately even if
your filesystem always has 5% free space, after a while due to that
fragmentation it is likely that all blocks have been written to at leas=
t
once.  That's what TRIM fixes.  Overprovisioning beyond that is silly
and wasteful, when a perfectly good fix exists.  Your argument is rathe=
r
like saying that Linux shouldn't worry about being efficient in its
operation, because you can always buy more CPU and memory than you need=
=2E

One additional point.  TRIM is not just for SSDs.  SCSI/FC supports two
commands similar in meaning to TRIM (and to each other, don't get me
started...) that have usefulness way beyond SSDs.  EMC for example
supports them in their high end VMAX arrays on both thin provisioned AN=
D
traditional "thick" LUNs.  Why on thick LUNs?  Because knowing that a
block is no longer in use is very useful for stuff like copies,
snapshots and especially when sending data between arrays over WAN
links.  For exactly the same reasons, information about blocks no longe=
r
in use could be quite useful to the Linux device mapper layer.  It woul=
d
be a shame if Linux mdadm raid became marginalized in the future due to
lack of support for TRIM/discard semantics.


>=20
>=20
> > The problem is that the "cleaner" (aka garbage collector) can
> > only pack "used" flash-pages together, thus creating empty
> > flash-blocks, if it knows which logical sectors and thus
> > flash-pages are "unused".
> >
> > Since the TRIM command is synchronous it is often a bad idea to
> > use it on every logical sector deallocation in filesystem code,
> > but it or FITRIM should be used at least periodically (for
> > example during 'fsck') to tell the FTL which logical sectors are
> > unused so it can rebuild the pool of empty flash-blocks, and
> > doing it periodically would work around the synchronous nature
> > of SATA TRIM.
> >
> > Also TRIM and FITRIM are useful for any case of virtualization,
> > not just for flash SSD layers, for example for "sparse" (aka
> > thin provisioning) VM disk images.
> >
> > It would be nice if MD passed on TRIM or at least FITRIM, and I
> > have just done a search and there is a discussion of some issues
> > with that here:
> >
> > http://lkml.indiana.edu/hypermail/linux/kernel/1011.2/02184.html
> >
> >   =C2=ABthe only really complex part is sending something like that
> >    into MDraid, because that one set of ranges might explode into
> >    thousands of ranges and then have to be coalesced back down to
> >    a more manageable number of ranges.
> >
> >    ie. with a simple raid 0, each range will need to be broken
> >    into a bunch of stride sized ranges, then the contiguous
> >    strides on each spindle coalesced back into larger ranges.
> >
> >    But if MDraid can handle discards now with one range, it
> >    should not be that hard to teach it handle a group of ranges.=C2=
=BB
> >
> > This perplexes me because the logic should be identical to that
> > of writing: TRIM is in effect a variant of WRITE.
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rai=
d" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
>=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--=20
Douglas Siebert
douglas-siebert@uiowa.edu

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
