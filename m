From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: RAID-10 explicitly defined drive pairs?
Date: Thu, 12 Jan 2012 15:24:00 -0600
Message-ID: <4F0F4F70.6060708@hardwarefreak.com>
References: <20111212115459.GC20730@fi.muni.cz> <4EE61EAE.20101@anonymous.org.uk> <20120106150823.GX25976@fi.muni.cz> <20231.9177.523012.471046@tree.ty.sabi.co.UK> <20120106201150.GB13358@fi.muni.cz> <4F077BE1.4050408@hardwarefreak.com> <20232.21966.952905.343604@tree.ty.sabi.co.UK> <4F087211.5020000@hardwarefreak.com> <20238.54892.300019.414513@tree.ty.sabi.co.UK>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20238.54892.300019.414513@tree.ty.sabi.co.UK>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 1/12/2012 6:47 AM, Peter Grandi wrote:
> [ ... ]
> 
>>> That to me sounds a bit too fragile ; RAID0 is almost always
>>> preferable to "concat", even with AG multiplication, and I
>>> would be avoiding LVM more than avoiding MD.
> 
>> This wholly depends on the workload.  For something like
>> maildir RAID0 would give you no benefit as the mail files are
>> going to be smaller than a sane MDRAID chunk size for such an
>> array, so you get no striping performance benefit.
> 
> That seems to me unfortunate argument and example:
> 
> * As an example, putting a mail archive on a RAID0 or 'concat'
>   seems a bit at odd with the usual expectations of availability
>   for them. Unless a RAID0 or 'concat' over RAID1. Because anyhow
>   'maildir' mail archive is a horribly bad idea regardless
>   because it maps very badly on current storage technology.

WRT availability both are identical to textbook RAID10--half the drives
can fail as long as no two are in the same mirror pair.  In essence
RAID0 over mirrors _is_ RAID10.  I totally agree with your maildir
sentiments--far too much physical IO (metadata) needed for the same job
as mbox, Dovecot's mdbox, etc.  But, maildir is still extremely popular
and in wide use, and will be for quite some time.

> * The issue if chunk size is one of my pet peeves, as there is
>   very little case for it being larger than file system block
>   size. Sure there are many "benchmarks" that show that larger
>   chunk sizes correspond to higher transfer rates, but that is
>   because of unrealistic transaction size effects. Which don't
>   matter for a mostly random-access share mail archive, never
>   mind a maildir one.

I absolutely agree.  Which is why the concat makes sense for such
workloads.  From a 10,000 ft view, it is little different than having a
group of mirror pairs, putting a filesystem on each, and manually
spreading one's user mailboxen over those filesystems.  The XFS over
concat simply takes the manual spreading aspect out of this, and yields
pretty good transaction load distribution.

> * Regardless, an argument that there is no striping benefit in
>   that case is not an argument that 'concat' is better. I'd still
>   default to RAID0.

The issue with RAID0 or RAID10 here is tuning XFS.  With a striped array
XFS works best if sunit/swidth match the stripe block characteristics of
the array, as it attempts to pack a full stripe worth of writes before
pushing down the stack.  This works well with large files, but can be an
impediment to performance with lots of small writes.  Free space
fragmentation becomes a problem as XFS attempts to stripe align all
writes.  So with maildir you often end up with lots of partial stripe
writes, each being a different stripe.  Once an XFS filesystem ages
sufficiently (i.e. fills up) more head seeking is required to write
files into the fragmented free space.  At least, this is my
understanding from Dave's previous explanation.

Additionally, when using a striped array, all XFS AGs are striped down
the virtual cylinder that is the array.  So when searching a large
directory btree, you may generate seeks across all drives in the array
to find a single entry.  With a properly created XFS on concat, AGs are
aligned and wholly contained within a mirror pair.  And since all files
created within an AG have their metadata also within that AG, any btree
walking is done only on an AG within that mirror pair, reducing head
seeking to one drive vs all drives in a striped array.

The concat setup also has the advantage that per drive read-ahaead is
more likely to cache blocks that actually will be needed shortly, i.e.
the next file in an inbox, whereas with a striped array it's very likely
that the next few blocks contain a different user's email, a user who
may not even be logged in.

> * Consider the dubious joys of an 'fsck' or 'rsync' (and other
>   bulk maintenance operations, like indexing the archive), and
>   how RAID0 may help (even if not a lot) the scanning of metadata
>   with respect to 'concat' (unless one relies totally on
>   parallelism across multiple AGs).

This concat setup is specific to XFS and only XFS.  It is useless with
any other (Linux anyway) filesystem because no others use an allocation
group design nor can derive meaningful parallelism in the absence of
striping.

> Perhaps one could make a case that 'concat' is no worse than
> 'RAID0' if one has a very special case that is equivalent to
> painting oneself in a corner, but it is not a very interesting
> case.

It better than a RAID0/10 stripe for small file random IO workloads.
See reasons above.

>> And RAID0 is far more fragile here than a concat. If you lose
>> both drives in a mirror pair, say to controller, backplane,
>> cable, etc failure, you've lost your entire array, and your
>> XFS filesystem.
> 
> Uhm, sometimes it is not a good idea to structure mirror pairs so
> that they have blatant common modes of failure. But then most
> arrays I have seen were built out of drives of the same make and
> model and taken out of the same carton....

I was demonstrating the worst case scenario that could take down both
array types, and the fact that when using XFS on both, you lose
everything with RAID0, but can likely recover to a large degree with the
concat specifically because of the allocation group design and how the
AGs are physically laid down on the concat disks.

>> With a concat you can lose a mirror pair, run an xfs_repair and
>> very likely end up with a functioning filesystem, sans the
>> directories and files that resided on that pair. With RAID0
>> you're totally hosed. With a concat you're probably mostly
>> still in business.
> 
> That sounds (euphemism alert) rather optimistic to me, because it
> is based on the expectation that files, and files within the same
> directory, tend to be allocated entirely within a single segment
> of a 'concat'. 

This is exactly the case.  With 16x1TB drives in an mdraid linear concat
with XFS and 16 AGs, you get exactly 1 AG on each drive.  In practice in
this case one would probably want 2 AGs per drive, as files are
clustered around the directories.  With the small file random IO
workload this decreases head seeking between the directory write op and
the file write up, which typically occur in rapid succession.

> Even with distributing AGs around for file system
> types that support that, that's a bit wistful (as is the
> expectation that AGs are indeed wholly contained in specific
> segments of a 'concat').

No, it is not, and yes, they are.

> Usually if there is a case for a 'concat' there is a rather
> better case for separate, smaller filesystems mounted under a
> common location, as an alternative to RAID0.

Absolutely agreed, for the most part.  If the application itself has the
ability to spread the file transaction load across multiple directories
this is often better than relying on the filesystem to do it
automagically.  And if you lose one filesystem for any reason you've
only lost access to a portion of data, not all of it.  The minor
downside is managing multiple filesystems instead of one, but not a big
deal really, given the extra safety margin.

In the case of the maildir workload, Dovecot, for instance, allows
specifying a mailbox location on a per user basis.  I recall one Dovecot
OP who is doing this with 16 mirror pairs with 16 EXTx filesystems atop.
 IIRC he was bitten more than once by single large hardware RAID setups
going down--I don't recall the specifics.  Check the Dovecot list archives.

> It is often a better case because data is often partitionable,
> there is no large advantage to a single free space pool as most
> files are not that large, and one can do fully independent and
> parallel 'fsck', 'rsync' and other bulk maintenance operations
> (including restores).

Agreed.  If the data set can be partitioned, and if your application
permits doing so.  Some do not.

> Then we might as well get into distributed partitioned file
> systems with a single namespace like Lustre or DPM.

Lustre wasn't designed for, nor is suitable for, high IOPS low latency,
small file workloads, which is, or at least was, the topic we are
discussing.  I'm not familiar with DPM.  Most distributed filesystems
aren't suitable for this type of workload due to multiple types of latency.

> But your (euphemism alert) edgy recovery example above triggers a
> couple of my long standing pet peeves:
> 
> * The correct response to a damaged (in the sense of data loss)
>   storage system is not to ignore the hole, patch up the filetree
>   in it, and restart it, but to restore the filetree from backups.
>   Because in any case one would have to run a verification pass
>   aganst backups to see what has been lost and whether any
>   partial file losses have happened.

I believe you missed the point, and are making some incorrect
assumptions WRT SOP in this field, and the where-with-all of your
colleagues.  In my concat example you can likely be back up and running
"right now" with some loss _while_ you troubleshoot/fix/restore.  In the
RAID0 scenario, you're completely down _until_ you
troubleshoot/fix/restore.  Nobody is going to slap a bandaid on and
"ignore the hole".  I never stated nor implied that.  I operate on the
assumption my colleagues here know what they're doing for the most part,
so I don't expend extra unnecessary paragraphs on SOP minutia.

[snipped]

-- 
Stan
