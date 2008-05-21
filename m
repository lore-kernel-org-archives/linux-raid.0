From: Cry <cry_regarder@yahoo.com>
Subject: Re: Two Drive Failure on RAID-5
Date: Wed, 21 May 2008 21:21:03 +0000 (UTC)
Message-ID: <loom.20080521T210407-628@post.gmane.org>
References: <loom.20080519T224713-779@post.gmane.org> <4832966A.3010707@dgreaves.com> <loom.20080521T140522-597@post.gmane.org> <483482E2.60300@dgreaves.com> <09ed01c8bb83$ec3f7230$9300a8c0@dcccs>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Janos Haar <janos.haar <at> netcenter.hu> writes:

> But let me note:
> With the default -b 64k, dd_rescue sometimes drop the entire soft block area 
> on the first error!
> If you want more precise result, run it again with -b 4096 and -B 1024, and 
> if you can, don't copy the drive to the partition! 

Since I kept the bad blocks file from the dd_rescue run, can I 
just use that to have dd_rescue try to copy exactly the right 
blocks out?  This would avoid over stressing the drive?  Would 
it be best to have dd_rescue copy the blocks to a file and then 
use dd to write them onto /dev/sdg1 in the right place?

>> [aside: It would be nice if we could take the output from ddrescue and 
>> friends
>> to determine what the lost blocks map to via the md stripes.]

Yes, because I also have /dev/sdc which failed several hours 
before /dev/sda.  Between the two, everything should be 
recoverable, modulo low probability of the same block failing 
on both.  Is there a procedure to rebuild the lost stripes 
leveraging the other failed drive?

>>> /dev/sdg1 is my replacement drive (750G) that I had tried to sync
>>> previously.

>> No. /dev/sdg1 is a *partition* on your old drive.

Nope.  /dev/sda is my old drive.  It has NO partitions because I was 
retarded 1 year ago:

Folks, I made a mistake when I created my original raid array 
(there is a note about it in the archives of this group) that 
I built the array on the raw drives, not on partitions.  
/dev/sda IS the drive.  There is no /dev/sda1.  However, the 
replacement drive is a 750Gig (not 500 like the originals) so 
I built a partition on the drive of the correct size: /dev/sdg1.

> >> How do I transfer the label from /dev/sda (no partitions) to /dev/sdg1?
> > Can anyone suggest anything.
> 
> Cry i only have this idea:
> dd_rescue -v -m 128k -r /dev/source -S 128k superblock.bin
> losetup /dev/loop0 superblock.bin
> mdadm --build -l linear --raid-devices=2 /dev/md1 /dev/sdg1 /dev/loop0
> 
> And the working raid member is /dev/md1. 
> But only for recovery!!!

Let me think about the above.  This will copy the information that mdadm -E gets
from the entire drive /dev/sda into the partition /dev/sdg1?

Also, I ordered:

SUPERMICRO CSE-M35T-1 Hot-Swapable SATA HDD Enclosure

and 5

Seagate Barracuda ES.2 ST31000340NS 1TB 7200 RPM SATA 3.0Gb/s Hard Drive

drives to build a RAID-6 replacement for my old array.  I'm 
planning on turning the old drives into a LVM or RAID-0 set 
to serve as a backup to the primary array.  Any suggestions 
for configuring the array (performance parameters etc.)?  
Given my constraints about getting this all working again, 
I can't go through a real performance testing loop.

Thanks,

Cry

