From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: A few remaining questions about installing to RAID-10
Date: Mon, 5 Oct 2009 13:03:13 -0500
Message-ID: <20091005180314705.BZYY22985@cdptpa-omta01.mail.rr.com>
References: <556491.46402.qm@web38805.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <556491.46402.qm@web38805.mail.mud.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of adfas asd
> Sent: Monday, October 05, 2009 10:31 AM
> To: linux-raid@vger.kernel.org
> Subject: RE: A few remaining questions about installing to RAID-10
> 
> WAT?!  How can I mount an unpartitioned/unformatted array?  This is more

	I didn't say "unformatted".  Mkfs does not require a partition, but
you're going to need a file system if you are going to have files.

> direct than using a filesystem, although there would be no journalling,
> right?

	Journaling is a facility of the file system, not the partition.  If
you install a journalled file system, then you will have a journal.  If you
install something like ext2, then you won't.  I happen to be using XFS,
which is a journalling file system, on my video server and the backup server
arrays.

>  If I were to mount my small disk for / and the unpartitioned array
> as /home for example.

	In your case it may not make too much difference, as I take it the
system is not logged into by anyone but you (or am I mistaken?), but I would
generally speaking shy away from putting /home in anything which might not
be available at login time, or which is likely to be taken offline when the
system is up and running.  It can be done, of course, but logins can be a
bit problematical for ordinary users when /home is not present.  That said,
yes, the small disk can be / and the array can be /home.  I don't recommend
running without swap, so if the small disk is the only other physical drive,
then it does need to be partitioned at a minimum into your main space and
some swap.  A separate /boot partition is not a terrible idea, either,
especially on a multi-boot system.  I have some systems with a separate
/boot partition and some without.  Sometimes there is a really good reason
to make /var a separate partition, but in your case I think not.

> Seems like journalling/crash recovery is pretty vital.  Could not
> partitioning be recommendable?

	Not for that purpose, no.  They have nothing to do with one another.
Partitioning allows a single disk to have multiple mount points, or to boot
more than one OS, or to allow multiple file systems serving different
purposes to all reside on a single physical disk.  Journalling creates a
cache for writes which allows a file system to better survive a dirty
shutdown without corrupting the file system.  The journal can be on the same
physical disk as the file system or a completely separate disk system.  It
can be on a separate partition, but it is not required.


