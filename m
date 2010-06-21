From: =?ISO-8859-15?Q?Stefan_/*St0fF*/_H=FCbner?=
	<stefan.huebner@stud.tu-ilmenau.de>
Subject: Re: md lock issue, I suppose
Date: Mon, 21 Jun 2010 23:08:31 +0200
Message-ID: <4C1FD4CF.20109@stud.tu-ilmenau.de>
References: <20100621204208.GA29830@lazy.lzy>
Reply-To: st0ff@npl.de
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100621204208.GA29830@lazy.lzy>
Sender: linux-raid-owner@vger.kernel.org
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I don't think it's too aggressive locking.  If the disk wasn't locked,
you could also shrink or expand the raid partition.  That wouldn't be a
good idea (f.e. with 0.90 metadata shrinking or expanding would be
really bad!).  This could happen with one write to the partition table,
so writing to it should be locked.

The workaround is first grade programming: divide and conquer!  Make two
for-loops.  One collecting the information, the second to apply all
changes (first change the pt, then loop thru adding the partitions to
the different arrays).

Yes, as easy as that.

Am 21.06.2010 22:42, schrieb Piergiorgio Sartor:
> Hi all,
> 
> still playing with my wild bunch of RAID-6.
> 
> I'm more or less finished with a script adding
> an HDD to the different arrays.
> 
> The script, originally, was going thru the different
> arrays, collecting the partition size, creating the
> partition (on the new disk), adding the partition
> to the corresponding RAID volume.
> 
> Something like:
> 
> for v in raid_devices
>   find start end part
>   parted /dev/sdX mkpart part start end
>   mdadm --add $v /dev/sdXpart
> end
> 
> This works only for the first partition.
> 
> The issue seems to be that, after the "--add", the
> device is locked and the partition table *cannot*
> be updated (the kernel cannot).
> The consequence is that the successive "parted",
> while succeeding, report a failure (not a problem),
> and the /dev/sdXpart does not appear. This means
> it will not be added to the next device.
> 
> In other words, the script starts with /dev/sdX.
> It creates /dev/sdX1.
> It adds /dev/sdX1 to the RAID.
> It creates /dev/sdX2...
> /dev/sdX2 does not appear, the add fails...
> ...
> 
> Is this intended behaviour? Or a bit aggressive locking?
> 
> Any possible solution not involving stopping the RAIDs?
> 
> Thanks a lot, if you need more info, please let me know.
> 
> bye,
> 

