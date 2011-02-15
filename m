From: Matt Garman <matthew.garman@gmail.com>
Subject: Re: high throughput storage server?
Date: Mon, 14 Feb 2011 22:44:34 -0600
Message-ID: <20110215044434.GA9186@septictank.raw-sewage.fake>
References: <AANLkTik5_Zx98rSbmpgUtG82qtFObANtCcbnn-a7MXcp@mail.gmail.com>
 <AANLkTimOjQDjoDMLSd1Z88GhOXoumtaQP4TyE=VpQmvQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <AANLkTimOjQDjoDMLSd1Z88GhOXoumtaQP4TyE=VpQmvQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Doug Dumitru <doug@easyco.com>
Cc: Mdadm <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, Feb 14, 2011 at 06:06:43PM -0800, Doug Dumitru wrote:
> You have a whole slew of questions to answer before you can decide
> on a design.  This is true if you build it yourself or decide to
> go with a vendor and buy a supported server.  If you do go with a
> vendor, the odds are actually quite good you will end up with
> Linux anyway.

I kind of assumed/wondered if the vendor-supplied systems didn't run
Linux behind the scenes anyway. 

> You state a need for 20TB of storage split among 40-50 "users".
> Your description implies that this space needs to be shared at the
> file level.  This means you are building a NAS (Network Attached
> Storage), not a SAN (Storage Area Network).  SANs typically export
> block devices over protocols like iSCSI.  These block devices are
> non-sharable (ie, only a single client can mount them (at least
> read/write) at a time.

Is that the only distinction between SAN and NAS?  (Honest
question, not rhetorical.)

> So, 20TB of NAS.  Not really that hard to build.  Next, you need
> to look at the space itself.  Is this all unique data, or is there
> an opportunity for "data deduplication".  Some filesystems (ZFS)
> and some block solutions can actively spot blocks that are
> duplicates and only store a single copy.  With some applications
> (like virtual servers all running the same OS), this can result in
> de-dupe ratios of 20:1.  If your application is like this, your
> 20TB might only be 1-2 TB.  I suspect this is not the case based
> on your description.

Unfortunately, no, there is no duplication.  Basically, we have a
bunch of files that are generated via another big collection of
servers scattered throughout different data centers.  These files
are "harvested" daily (i.e. copied back to the big store in our
office for the analysis I've mentioned).

> Next, is the space all the same.  Perhaps some of it is "active"
> and some of it is archival.  If you need 4TB of "fast" storage and
> ...
> well.  You can probably build this for around $5K (or maybe a bit
> less) including a 10GigE adapter and server class components.

The whole system needs to be "fast".

Actually, to give more detail, we currently have a simple system I
built for backup/slow access.  This is exactly what you described, a
bunch of big, slow disks.  Lots of space, lowsy I/O performance, but
plenty adequate for backup purposes.

As of right now, we actually have about a dozen "users", i.e.
compute servers.  The collection is basically a home-grown compute
farm.  Each server has a gigabit ethernet connection, and 1 TB of
RAID-1 spinning disk storage.  Each storage mounts every other
server via NFS, and the current data is distributed evenly across
all systems.

So, loosely speaking, right now we have roughly 10 TB of
"live"/"fast" data available at 1 to 10 gbps, depending on how you
look at it.

While we only have about a dozen servers now, we have definitely
identified growing this compute farm about 4x (to 40--50 servers)
within the next year.  But the storage capacity requirements
shouldn't change too terribly much.  The 20 TB number was basically
thrown out there as a "it would be nice to have 2x the live
storage".

I'll also add that this NAS needs to be optimized for *read*
throughput.  As I mentioned, the only real write process is the
daily "harvesting" of the data files.  Those are copied across
long-haul leased lines, and the copy process isn't really
performance sensitive.  In other words, in day-to-day use, those
40--50 client machines will do 100% reading from the NAS.

> If you need IOPS (IO Operations Per Second), you are looking at
> SSDs.  You can build 20TB of pure SSD space.  If you do it
> yourself raid-10, expect to pay around $6/GB or $120K just for
> drives.  18TB will fit in a 4U chassis (see the 72 drive
> SuperMicro double-sided 4U).  72 500GB drives later and you have
> 18,000 GB of space.  Not cheap, but if you quote a system from
> NetApp or EMC it will seem so.

Hmm.  That does seem high, but that would be a beast of a system.
And I have to add, I'd love to build something like that!

> If you can cut the "fast" size down to 2-4TBs, SSDs become a lot
> more realistic with commercial systems from new companies like
> WhipTail for way under $100K.
> 
> If you go with hard drives, you are trading speed for space.  With
> 600GB 10K drives would need 66 drives raid-10.  Multi-threaded, this
> would read at around 10K IOPS and write at around 7K for "small"
> blocks (4-8K).  Linear IO would be wicked fast but random OPs slow you
> down.  Conversly, large SSDs arrays can routinely hit > 400K reads and
> > 200K writes if built correctly.  Just the 66 hard drives will run
> you $30K.  These are SAS drives, not WD Velociraptors which would save
> you 30%.
> 
> If you opt for "lots of small drives" (ie, 72GB 15K SAS drives) or
> worse (short seek small drives), the SSDs are actually faster and
> cheaper per GB.  20TB of raid-10 72GB drives is 550 drives or $105K
> (just for the drives, not counting jbod enclosures, racks, etc).
> Short seeking would be 1000+ drives.  I highly expect you do not want
> to do this.

No.  :)  72 SSDs sounds like fun; 550 spinning disks sound dreadful.
I have a feeling I'd probably have to keep a significant number
on-hand as spares, as I predict drive failures would probably be a
weekly occurance.

Thank you for the detailed and thoughtful answers!  Definitely very
helpful.

Take care,
Matt

