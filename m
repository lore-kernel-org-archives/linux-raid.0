From: pg@lxra2.for.sabi.co.UK (Peter Grandi)
Subject: Re: RAID-10 explicitly defined drive pairs?
Date: Thu, 12 Jan 2012 12:47:40 +0000
Message-ID: <20238.54892.300019.414513@tree.ty.sabi.co.UK>
References: <20111212115459.GC20730@fi.muni.cz>
	<4EE61EAE.20101@anonymous.org.uk>
	<20120106150823.GX25976@fi.muni.cz>
	<20231.9177.523012.471046@tree.ty.sabi.co.UK>
	<20120106201150.GB13358@fi.muni.cz>
	<4F077BE1.4050408@hardwarefreak.com>
	<20232.21966.952905.343604@tree.ty.sabi.co.UK>
	<4F087211.5020000@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F087211.5020000@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

[ ... ]

>> That to me sounds a bit too fragile ; RAID0 is almost always
>> preferable to "concat", even with AG multiplication, and I
>> would be avoiding LVM more than avoiding MD.

> This wholly depends on the workload.  For something like
> maildir RAID0 would give you no benefit as the mail files are
> going to be smaller than a sane MDRAID chunk size for such an
> array, so you get no striping performance benefit.

That seems to me unfortunate argument and example:

* As an example, putting a mail archive on a RAID0 or 'concat'
  seems a bit at odd with the usual expectations of availability
  for them. Unless a RAID0 or 'concat' over RAID1. Because anyhow
  'maildir' mail archive is a horribly bad idea regardless
  because it maps very badly on current storage technology.

* The issue if chunk size is one of my pet peeves, as there is
  very little case for it being larger than file system block
  size. Sure there are many "benchmarks" that show that larger
  chunk sizes correspond to higher transfer rates, but that is
  because of unrealistic transaction size effects. Which don't
  matter for a mostly random-access share mail archive, never
  mind a maildir one.

* Regardless, an argument that there is no striping benefit in
  that case is not an argument that 'concat' is better. I'd still
  default to RAID0.

* Consider the dubious joys of an 'fsck' or 'rsync' (and other
  bulk maintenance operations, like indexing the archive), and
  how RAID0 may help (even if not a lot) the scanning of metadata
  with respect to 'concat' (unless one relies totally on
  parallelism across multiple AGs).

Perhaps one could make a case that 'concat' is no worse than
'RAID0' if one has a very special case that is equivalent to
painting oneself in a corner, but it is not a very interesting
case.

> And RAID0 is far more fragile here than a concat. If you lose
> both drives in a mirror pair, say to controller, backplane,
> cable, etc failure, you've lost your entire array, and your
> XFS filesystem.

Uhm, sometimes it is not a good idea to structure mirror pairs so
that they have blatant common modes of failure. But then most
arrays I have seen were built out of drives of the same make and
model and taken out of the same carton....

> With a concat you can lose a mirror pair, run an xfs_repair and
> very likely end up with a functioning filesystem, sans the
> directories and files that resided on that pair. With RAID0
> you're totally hosed. With a concat you're probably mostly
> still in business.

That sounds (euphemism alert) rather optimistic to me, because it
is based on the expectation that files, and files within the same
directory, tend to be allocated entirely within a single segment
of a 'concat'. Even with distributing AGs around for file system
types that support that, that's a bit wistful (as is the
expectation that AGs are indeed wholly contained in specific
segments of a 'concat').

Usually if there is a case for a 'concat' there is a rather
better case for separate, smaller filesystems mounted under a
common location, as an alternative to RAID0.

It is often a better case because data is often partitionable,
there is no large advantage to a single free space pool as most
files are not that large, and one can do fully independent and
parallel 'fsck', 'rsync' and other bulk maintenance operations
(including restores).

Then we might as well get into distributed partitioned file
systems with a single namespace like Lustre or DPM.

But your (euphemism alert) edgy recovery example above triggers a
couple of my long standing pet peeves:

* The correct response to a damaged (in the sense of data loss)
  storage system is not to ignore the hole, patch up the filetree
  in it, and restart it, but to restore the filetree from backups.
  Because in any case one would have to run a verification pass
  aganst backups to see what has been lost and whether any
  partial file losses have happened.

* If availability requirement are so exigent that a restore from
  backup is not acceptable to the customer, and random data loss
  is better accepted, we have a strange situation. Which is that
  the customer really wants a Very Large DataBase (a database so
  large that it cannot be taken offline for maintenance, such as
  backups or recovery) style storage system, but they don't want
  to pay for it. A sysadm may then look good by playing to these
  politics by pretending they have done one on the cheap, by
  tacitly dropping data integrity, but these are scary politics.

[ ... ]
