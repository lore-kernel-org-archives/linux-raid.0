From: Andrew Burgess <aab@cichlid.com>
Subject: RE: RAID halting
Date: Fri, 24 Apr 2009 08:24:42 -0700
Message-ID: <1240586682.12986.38.camel@cichlid.com>
References: <20090424045222253.GZTS2063@cdptpa-omta04.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090424045222253.GZTS2063@cdptpa-omta04.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: lrhorer@satx.rr.com
Cc: 'Linux RAID' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, 2009-04-23 at 23:52 -0500, Leslie Rhorer wrote:

> Does anyone have any better suggestions or comments on creating the array
> with these options?  It is going to start as an 8T array and probably grow
> to 30T by the end of this year or early next year, increasing the number of
> drives to 12 and then swapping out the 1T drives for 3T drives, hopefully
> after the price of 3T drives has dropped considerably.
> 
> I intend to create an XFS file system 

The one disadvantage to XFS is you cannot shrink the filesystem. This is
handy when upgrading the array when you want to reuse some of the
smaller disks to save money. i.e:

Create a new 3T device array but one that only holds say half your data.
Copy half your data to the new array. Shrink the old array (fs and then
md). This frees up some 1T disks which you can make into 3T devices with
md, add to the new array, grow the fs. Repeat untill all the data is
transferred. Your data is protected against disk failure the whole time.

I did exactly this in the past with ext3 but talked myself into using
xfs for the new array so this time when I upgraded the array from 400G
devices to 750GB devices I had to buy enough 750's to hold everything. I
was still able to reuse some of the 400GB to give lots of extra space on
the new array after the copy.

> on the raw RAID device, which I am
> given to understand offers few if any disadvantages compared to
> partitioning the array, or partitioning the devices below the array, for
> that matter, given I am devoting each entire device to the array and the
> entire array to the single file system.  Does anyone strongly disagree?  I
> see no advantage to LVM in this application, either.  Again, are there any
> dissenting opinions?

I agree about LVM but am no expert

> 3.  The man page says "When a filesystem is created on a logical volume
> device, mkfs.xfs will automatically  query  the  logical  volume  for
> appropriate sunit and swidth values."  Does this mean it is best for me to
> simply not worry about setting these parameters and let mkfs.xfs do it, or
> is there a good reason for me to intervene?
> 
> 4.  My reading, including the statement in the mkfs.xfs man page which says,
> "The value [of the sw parameter] is expressed as a multiplier of the stripe
> unit, usually the same as the number of stripe members in the logical volume
> configuration, or data disks in a RAID device", suggests to me the optimal
> stripe size for an XFS file system will change when the number of member
> disks is increased.  Am I correct in this inference?  If so, I haven't seen
> anything suggesting the stripe size of the FXS file system can be modified
> after the file system is created.  Certainly the man page for xfs_growfs
> mentions nothing of it.  The researchers I read all suggested the
> performance of FXS is greatly enhanced if the file system stripe size
> matches the RAID stripe size.  I'm also a little puzzled why the stripe
> width of the XFS file system should be the same as the number of drives in a
> RAID 5 or RAID 6 array, since to the file system the stripe extent would
> seem to be defined by the data drives, because a payload which fits
> perfectly on N drive chunks is spread across N+2 drive chunks on a RAID 6
> array.  To put it another way, it seems to me the parity drives should be
> excluded from the calculation.

The mount man page says it can be changed at mount time which does seem
a little strange to me.

Quoting man mount:

       sunit=value and swidth=value

"Used  to  specify  the  stripe unit and width for a RAID device or a
stripe volume.  value must be specified in 512-byte block units.  If
this option is not specified and the filesystem was made on a stripe
volume or the stripe width or unit were specified for the RAID device at
mkfs time,  then  the  mount system call will restore the value from the
superblock.  For filesystems that are made directly on RAID devices,
these options can be used to override the information in the superblock
if the underlying disk layout changes after the filesystem has been
created. The swidth option is required if the sunit option has been
specified, and must be a multiple of the sunit value."

Maybe it means newly created files use the new sunit/swidth values?
There is also defrag available for xfs, perhaps this rearranges things
as well, I don't know.

Once you create the fs and examine the values in /proc/mounts you could
see if they change when you add a device to the array, grow the fs and
remount. Also, your argument about the number of data disks makes sense
to me. After you get some data you might ask on the xfs mailing list if
you see a discrepancy.

My 14 device 128K chunk raid6 xfs picked "sunit=256,swidth=1024"
according to /proc/mounts. I think the units are 512 byte sectors so the
sunit is the same as the chunk size. I don't know what these values were
before the last md grow.

> 5.  Finally, one other thing concerns me a bit.  The researchers I read
> suggested XFS has by far the worst file deletion performance of any of the
> journaling file systems

Single file deletes of ~10GB work fine on my system but several in a row
will bog things down. Make sure you measure whats important to you; your
example shows deleting a single 20GB file. Is that what needs to be fast
or do you delete several files like that at once? And benchmarking rm
without a final sync may not be valid (or at least will measure
different things).

Also, there is an alloc_size mount parameter which reduces fragmentation
and may speed deletes. 

HTH

PS I wish I could have helped you with oprofile but its been a while
since I used it - we'd be starting at the same place ;-)


