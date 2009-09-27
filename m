From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: Remote NAS
Date: Sun, 27 Sep 2009 14:39:35 -0500
Message-ID: <20090927193914952.FCRF6584@cdptpa-omta02.mail.rr.com>
References: <92388.79363.qm@web38807.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <92388.79363.qm@web38807.mail.mud.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of adfas asd
> Sent: Wednesday, September 16, 2009 11:22 AM
> To: linux-raid@vger.kernel.org
> Subject: Remote NAS
> 
> A couple questions about MD RAID10:
> 
> Right now I'm RAIDing two 2TB drives in RAID10offset2. Need to add some
> drives and maybe I'll remote them using NAS (GB ethernet), for fire and
> theft protection.
> 
> So could the BIOS actually boot this if 2 drives are in the machine and 2
> are in the garage? Is there a way to specify in mdadm that the two in the
> garage are mirrored from the two in the system?
> 
> Is GB ethernet NAS noticably slower than eSATA?  Is it reliable?
> 
> What if I use the mobo's e-SATA port to add 5 external drives locally.
> This would require a port multiplier. I presume it would not be bootable,
> since a port multiplier needs OS support? Or would something go in
> initrd.img?  Or would I need an individual boot drive to get things up?
> 
> Using the array to store MythTV recordings (very large files), but when it
> does commercial flagging (lots of writes) the array is so busy that GUI
> response is very slow.  I've set readahead cache to optimal (4096, after
> testing most sizes), so read should be OK.  I know far is optimized for
> read, so I chose offset in hopes it would bring up write speed.  Is there
> a way to speed up writes?

	I'm not running MythTv, but I faced similar challenges when building
my video server.  RAID10 and similar solutions are great for many purposes,
but there are some fundamental considerations when choosing an array setup
in this situation which I think you should review carefully.

	1. Clearly you are concerned about a loss of data should something
catastrophic happen to one site or the other.  RAID mirroring certainly
addresses such a concern.  However, no matter what the array topology, RAID
systems are not fault free.  They are fault tolerant.  Of course, no system
is perfectly fault free, but a RAID solution only addresses hardware
failures.  By far the most common cause of data loss is not hardware
failure, but human error.  A RAID system cannot prevent a user from
accidentally overwriting data on an array.  Maddeningly, I lost several
favorite programs on separate occasions due to such errors before I had a
good backup solution in place.  I have only lost 1 program as a result of
array issues - that after a RAID growth which went sour unknowingly and a
subsequent write was corrupted.  The point I am making here is to prevent
data loss, one really needs a backup solution in addition to whatever array
solution one chooses.  You haven't mentioned a backup method (although
perhaps you have one), so perhaps a better solution than mirroring on a NAS
with the write mostly option would be to create a backup system in your
garage and run an rsync on a regular basis in order to assure data
retention.  That way, you have some period of time after having made a nasty
error to easily correct it before it becomes etched in stone.  This also
circumvents any performance issues associated with more complex RAID
solutions.

	2.  The nature of your data is a consideration.  As others have
mentioned, you might want to break up your partition structure to
accommodate the data types.  In particular, video data is huge, but does not
need to be read or written very quickly.  MPEG-II data only streams
typically at about 10 - 15 Mbps for 1080i, or at most 40 Mbps for 1080p
video on average per stream.  MPEG-IV streams even more slowly.  Database
writes and reads, however, are much, much smaller but can potentially fill a
3000 Mbps pipe.  I really agree with others here that you need to carefully
consider a different type of partition - perhaps not a RAID array at all -
for your database.  I run a tarball task every day to backup all the
important system data which is not on the RAID array over to a file on the
array, which in turn gets backed up every morning at 04:00 via rsync to the
remote backup system.  The video server employs a RAID6 array, and the
backup a RAID5 array.  Both systems boot off small drives whose contents are
copied to cold drives sitting on a shelf in case of boot drive failure.  In
your case, I think I would personally employ the small boot drive plus an
extra drive - perhaps a high performance 120G to 250G drive - just for your
database.  If you really feel the need, you could mirror the database drive,
but unless I am wrong, I think in your case the database can be easily
rebuilt if it is reverted to an older copy, so I would think a daily rsync
to your array would work well for you also.  The drives for the arrays can
be very inexpensive low performance drives with as little power consumption
as possible.

