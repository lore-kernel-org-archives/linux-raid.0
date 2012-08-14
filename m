From: Sam Clark <sclark_77@hotmail.com>
Subject: RE: RAID5 - Disk failed during re-shape
Date: Tue, 14 Aug 2012 15:40:50 +0200
Message-ID: <BLU153-ds7438ACF3B689B6D7DA9E294B70@phx.gbl>
References: <BLU153-ds1688A6A36A974526D12FDB94CC0@phx.gbl>	<50258CEA.10100@turmel.org>	<BLU401-EAS3343C9BB7296EA68990FF2294B20@phx.gbl>	<20120813093554.600d46c2@notabene.brown>	<BLU153-ds10943E39726EDC983C484594B00@phx.gbl> <20120814123829.23126b08@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120814123829.23126b08@notabene.brown>
Content-Language: en-gb
Sender: linux-raid-owner@vger.kernel.org
To: 'NeilBrown' <neilb@suse.de>
Cc: 'Phil Turmel' <philip@turmel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thanks Neil, 

Tried that and failed on the first attempt, so I tried shuffling around the
dev order.. unfortunately I don't know what they were previously, but I do
recall being surprised that sdd was first on the list when I was looking at
it previously, so perhaps a starting point.  Since there are some 120
different permutations of device order (assuming all 5 could be anywhere), I
modified the script to accept parameters and automated it a little further. 

I ended up with a few 'possible successes' but none that would mount (i.e.
fsck actually ran and found problems with the superblocks, group descriptor
checksums and Inode details, instead of failing with errorlevel 8).  The
most successful so far was the ones with SDD as device 1 and SDE as device
2.. one particular combination (sdd sde sdb sdc sdf) seems to report every
time "/dev/md_restore has been mounted 35 times without being checked, check
forced.".. does this mean we're on the right combination? 

In any case, that one produces a lot of output (some 54MB when fsck is piped
to a file) that looks bad and still fails to mount.  (I assume that "mount
-r /dev/md_restore /mnt/restore" I all I need to mount with?  I also tried
with "-t ext4", but that didn't seem to help either).

This is a summary of the errors that appear: 
Pass 1: Checking inodes, blocks, and sizes
(51 of these)
Inode 198574650 has an invalid extent node (blk 38369280, lblk 0)
Clear? no

(47 of these)
Inode 223871986, i_blocks is 2737216, should be 0.  Fix? no

Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
/lost+found not found.  Create? no

Pass 4: Checking reference counts
Pass 5: Checking group summary information
Block bitmap differences:  +(36700161--36700162) +36700164 +36700166
+(36700168--36700170) (this goes on like this for many pages.. in fact, most
of the 54 MB is here)

(and 492 of these) 
Free blocks count wrong for group #3760 (24544, counted=16439).
Fix? no

Free blocks count wrong for group #3761 (0, counted=16584).
Fix? no

/dev/md_restore: ********** WARNING: Filesystem still has errors **********
/dev/md_restore: 107033/274718720 files (5.6% non-contiguous),
976413581/1098853872 blocks


I also tried setting the reshape number to 1002152448 , 1002153984,
1002157056 , 1002158592 and 1002160128 (+/ - a couple of multiples) but
output didn't seem to change much in any case.. Not sure if there are many
different values worth testing there.

So, unless there's something else worth trying based on the above, it looks
to me that it's time to raise the white flag and start again... it's not too
bad, I'll recover most of the data.

Many thanks for your help so far, but if I may... 1 more question...
Hopefully I won't lose a disk during re-shape in the future, but just in
case I do, or for other unforeseen issues, what are good things to backup on
a system?  Is it enough to backup the /etc/mdadm/mdadm.conf and /proc/mdstat
on a regular basis?  Or should I also backup the device superblocks?  Or
something else?  

Ok, so that's actually 4 questions  ... sorry :-)

Thanks again for all your efforts. 
Sam


-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of NeilBrown
Sent: 14 August 2012 04:38
To: Sam Clark
Cc: Phil Turmel; linux-raid@vger.kernel.org
Subject: Re: RAID5 - Disk failed during re-shape

On Mon, 13 Aug 2012 18:14:30 +0200 "Sam Clark" <sclark_77@hotmail.com>
wrote:

> Thanks Neil, really appreciate the assistance.
> 
> Would love to give that a try - at least to catch the data that has
changed 
> since last backup, however I don't know the chunk size.  I created the
array 
> so long ago, and of course didn't document anything.  I would guess they
are 
> 64K, but not sure.  Is there any way to check from the disks themselves?
> 
> I've captured the 128K chunks as follows - hope it's correct:
> 
> I got the disk size in Bytes from fdisk -l, and subtracted 131072.. then 
> ran:
> sam@nas:~$ sudo dd if=/dev/sd[b-f] of=test.128k bs=1 skip=xxx count=128k,
> The 5 files are attached.
> 
> The disk sizes are as follows:
> sam@nas:~$ sudo blockdev --getsize /dev/sd[b-f]
> sdb: 2930277168
> sdc: 2930277168
> sdd: 2930277168
> sde: 2930277168
> sdf: 3907029168
> 

Unfortunately the metadata doesn't contain any trace of the the reshape
position, so we'll make do with 11.4%

The following script will assemble the array read-only.  You can then try
"fsck -n /dev/md_restore" to see if it is credible.  Then try to mount it.

Most of the details I'm confident of.

'chunk' is probably right, but there is no way to know for sure until you
have access to your data.  If you try changing it you'll need to also change
reshape to be an appropriate multiple of it.

'reshape' is approximately 11.4% of the array.  Maybe try other suitable
multiples.

'devs' is probably wrong.  I chose that order because the metadata seems to
suggest that order - yes, with sdf in the middle.  Maybe you know better.
You can try different orders until it seems to work.

Everything else should be correct.  component_size is definitely correct, I
found that in the metadata.  'layout' is the default and is hardly ever
changed.

As it assembles read-only, there is no risk in getting it wrong, changing
some values and trying again.  The script disassembles and old array before
creating the new.

good luck.

NeilBrown



# Script to try to assemble a RAID5 which got it's metadata corrupted
# in the middle of a reshape (ouch).
# We assemble as externally-managed-metadata in read-only mode
# by writing magic values to sysfs.

# devices in correct order.
devs='sdb sdd sdf sde sdc'

# number of devices, both before and after reshape
before=4
after=5

# reshape position as sectors per array.  It must be a multiple
# of one stripe, so chunk*old_data_disks*new_data_disks
# This number is 0.114 * 2930276992 * 3, rounded up to
# a multiple of 128*3*4.   Other multiples could be tried.
reshape=1002155520

# array parameters
level=raid5
chunk=65536
layout=2
component_size=2930276992

# always creates /dev/md_restore
mdadm -S /dev/md_restore
echo md_restore >  /sys/module/md_mod/parameters/new_array
cd /sys/class/block/md_restore/md

echo external:readonly > metadata_version
echo $level > level
echo $chunk > chunk_size
echo $component_size > component_size
echo 2 > layout
echo $before > raid_disks

echo $reshape > reshape_position
echo $after > raid_disks

slot=0
for i in $devs
do
 cat /sys/class/block/$i/dev > new_dev
 echo 0 > dev-$i/offset
 echo $component_size > dev-$i/size
 echo insync > dev-$i/state
 echo $slot > dev-$i/slot

 slot=$[slot+1]
done

echo readonly > array_state 

grep md_restore /proc/partitions

