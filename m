From: Gordon Henderson <gordon@drogon.net>
Subject: Re: RAID/Backup Strategies
Date: Wed, 3 Mar 2004 17:47:34 +0000 (GMT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.56.0403031741050.19423@unicorn.drogon.net>
References: <Pine.LNX.4.56.0403030912270.10347@zeus.rsc.raytheon.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.56.0403030912270.10347@zeus.rsc.raytheon.com>
To: Steve Witt <sawitt@electra.rsc.raytheon.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 3 Mar 2004, Steve Witt wrote:

> We are hoping (if funding is approved) to get a new server to replace an
> old server currently in use. The server is primarily an NIS/NFS server
> supporting a software development computing center. The current server has
> kind of a hodge-podge of IDE and SCSI disks (no RAID) and a SCSI
> multi-tape backup device, using amanda as the backup application. A
> previous sys admin set up the user disk partitions on this server to be
> around 20 GB to match a 20 GB holding partition for amanda.

If you only have one server, and one tape drive, you don't really need the
holding partition..

> The new server is planned to have a RAID 5 array with 4 disks plus 1
> spare. The software base for this would be Linux (Debian woody) using a
> recent 2.4.x kernel.  We plan to use the software RAID facilities in
> Linux, not a hardware RAID controller. My understanding of RAID is that
> this would result in a single, large device -- /dev/md0. This is great and
> I plan put all the user accounts on a filesystem on /dev/md0 and NFS serve
> those to all the client machines (mostly Linux, some Sun) we have.

You can split the disks and have smaller partitions - I've done this
myself in the past with good results. Eg. on the 5 disks, give each of
them an identical partition table of (eg)

  512MB		/
  1024MB	swap
  1024MB	/usr
  Rest of disk	/var

then make the raid5 arrays out of the same slices on each disk. (Although
/ can only be on RAID1, so you "waste" 3 partitions).

I have several servers similar to this and run amanda on them.

> The thing I am confused about is how this will affect our amanda backup
> strategy. The array size will be a little over 700 GB. To follow our
> current amanda setup it seems that the RAID device should be split into
> multiple partitions with one dedicated as a holding partition for amanda.
> But I'm not sure this is possible or desireable with a RAID array.

Amanda doesn't work very well when the disk partition is larger than your
tape size. If you don't have remote servers to backup, you don't need a
holding partition at all. (Although you need to specify one to keep it
happy, but then you can mark each data partition as "holding disk" to stop
them being copied to the holding partition which is just a waste of time
on the server).

You might need to split the partitions into ones just about the size of
your tapes. Get the biggest tape you can afford, and then work out how
much you realistically expect your data to compress. Do not belive the
tape makers claims of x2 compresion, in the real world, it just doesn't
work that way.

Gordon
