From: Sam Clark <sclark_77@hotmail.com>
Subject: RE: RAID5 - Disk failed during re-shape
Date: Wed, 15 Aug 2012 18:32:43 +0200
Message-ID: <BLU153-ds19E110068A838779FF3C294B60@phx.gbl>
References: <BLU153-ds1688A6A36A974526D12FDB94CC0@phx.gbl>	<50258CEA.10100@turmel.org>	<BLU401-EAS3343C9BB7296EA68990FF2294B20@phx.gbl>	<20120813093554.600d46c2@notabene.brown>	<BLU153-ds10943E39726EDC983C484594B00@phx.gbl>	<20120814123829.23126b08@notabene.brown>	<BLU153-ds7438ACF3B689B6D7DA9E294B70@phx.gbl> <20120815070533.5f7eb1e5@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120815070533.5f7eb1e5@notabene.brown>
Content-Language: en-gb
Sender: linux-raid-owner@vger.kernel.org
To: 'NeilBrown' <neilb@suse.de>
Cc: 'Phil Turmel' <philip@turmel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Unbelievable!  It mounted! 

With the -o noload, my array is mounted, and files are readable!

I've tested a few, and they look fine, but it's obviously hard to be sure on
a larger scale.

In any case, I'll certainly be able to recover more data now!

Thanks again Neil!
Sam

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of NeilBrown
Sent: 14 August 2012 23:06
To: Sam Clark
Cc: 'Phil Turmel'; linux-raid@vger.kernel.org
Subject: Re: RAID5 - Disk failed during re-shape

On Tue, 14 Aug 2012 15:40:50 +0200 Sam Clark <sclark_77@hotmail.com> wrote:

> Thanks Neil,
> 
> Tried that and failed on the first attempt, so I tried shuffling 
> around the dev order.. unfortunately I don't know what they were 
> previously, but I do recall being surprised that sdd was first on the 
> list when I was looking at it previously, so perhaps a starting point.  
> Since there are some 120 different permutations of device order 
> (assuming all 5 could be anywhere), I modified the script to accept
parameters and automated it a little further.
> 
> I ended up with a few 'possible successes' but none that would mount (i.e.
> fsck actually ran and found problems with the superblocks, group 
> descriptor checksums and Inode details, instead of failing with 
> errorlevel 8).  The most successful so far was the ones with SDD as 
> device 1 and SDE as device 2.. one particular combination (sdd sde sdb 
> sdc sdf) seems to report every time "/dev/md_restore has been mounted 
> 35 times without being checked, check forced.".. does this mean we're on
the right combination?

Certainly encouraging.  However it might just mean that the first device is
correct.  I think you only need to find the filesystem superblock to be able
to report that.

> 
> In any case, that one produces a lot of output (some 54MB when fsck is 
> piped to a file) that looks bad and still fails to mount.  (I assume 
> that "mount -r /dev/md_restore /mnt/restore" I all I need to mount 
> with?  I also tried with "-t ext4", but that didn't seem to help either).

54MB certainly seems like more that we were hoping for.
Yes, that mount command should be sufficient.  You could try adding "-o
noload".  I'm not sure what it does but from the code it looks like it tried
to be more forgiving of some stuff.


> 
> This is a summary of the errors that appear: 
> Pass 1: Checking inodes, blocks, and sizes
> (51 of these)
> Inode 198574650 has an invalid extent node (blk 38369280, lblk 0) 
> Clear? no
> 
> (47 of these)
> Inode 223871986, i_blocks is 2737216, should be 0.  Fix? no
> 
> Pass 2: Checking directory structure
> Pass 3: Checking directory connectivity /lost+found not found.  
> Create? no
> 
> Pass 4: Checking reference counts
> Pass 5: Checking group summary information Block bitmap differences:  
> +(36700161--36700162) +36700164 +36700166
> +(36700168--36700170) (this goes on like this for many pages.. in 
> +fact, most
> of the 54 MB is here)
> 
> (and 492 of these)
> Free blocks count wrong for group #3760 (24544, counted=16439).
> Fix? no
> 
> Free blocks count wrong for group #3761 (0, counted=16584).
> Fix? no
> 
> /dev/md_restore: ********** WARNING: Filesystem still has errors 
> **********
> /dev/md_restore: 107033/274718720 files (5.6% non-contiguous),
> 976413581/1098853872 blocks
> 
> 
> I also tried setting the reshape number to 1002152448 , 1002153984,
> 1002157056 , 1002158592 and 1002160128 (+/ - a couple of multiples) 
> but output didn't seem to change much in any case.. Not sure if there 
> are many different values worth testing there.

Probably not.

> 
> So, unless there's something else worth trying based on the above, it 
> looks to me that it's time to raise the white flag and start again... 
> it's not too bad, I'll recover most of the data.
> 
> Many thanks for your help so far, but if I may... 1 more question...
> Hopefully I won't lose a disk during re-shape in the future, but just 
> in case I do, or for other unforeseen issues, what are good things to 
> backup on a system?  Is it enough to backup the /etc/mdadm/mdadm.conf 
> and /proc/mdstat on a regular basis?  Or should I also backup the 
> device superblocks?  Or something else?

There isn't really any need to backup anything.  Just don't use a buggy
kernel (which unfortunately I let out into the wild and got into Ubuntu).
The most useful thing if things do go wrong is the "mdadm --examine" output
of all devices.


> 
> Ok, so that's actually 4 questions  ... sorry :-)
> 
> Thanks again for all your efforts. 
> Sam

Sorry we couldn't get your data back.

NeilBrown

