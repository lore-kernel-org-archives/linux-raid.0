From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Best practice for large storage?
Date: Sat, 16 Feb 2013 01:09:40 -0600
Message-ID: <511F30B4.2070809@hardwarefreak.com>
References: <24358517.18.1360862926919.JavaMail.root@zimbra>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <24358517.18.1360862926919.JavaMail.root@zimbra>
Sender: linux-raid-owner@vger.kernel.org
To: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 2/14/2013 11:28 AM, Roy Sigurd Karlsbakk wrote:
> Hi all
> 
> It seems we may need some storage for video soon. This is a 20k studen college in Norway, with rather a few on media related studies. Since these students produce rather large amounts of raw material, typically to be stored during the semester, we may need some 50-100TiB, perhaps more. I have setup systems with these amounts of storage earlier on ZFS, but may be using Linux MD for this project. I'm aware of the lack of checksumming, snapshots etc with Linux, but may be using it because of more Linux knowledge amongst the sysadmins here. In such a setup, I guess nearline SAS drives on a SAS expander will be used, and with the amount of storage needed, I won't be using a single RAID-6 (too insecure) or RAID-10 (too expensive) for the lot. In ZFS-land I used smallish VDEVs (~10 drives each)
  in a large pool.
> 
>  - Would using LVM on top of RAID-6 give me something similar?

You would use LVM concatenation or md/linear to assemble the individual
RAID6 arrays into a single logical device which you'd format with XFS.

>  - If so, should I stripe the RAID sets, and again, if striping them, will it be as easy to add new RAID sets as we run out of space?

You *could* put a stripe over the RAID6s *IF* you build the system and
leave it as is, permanently, as you can never expand a stripe.  But even
then it's not recommended due to the complexity of determining the
proper chunk sizes for the nested stripes, and aligning the filesystem
to the resulting device.

It's better to create, say, 10+2 RAID6 arrays, and add them to an
md/linear array.  This linear array is nearly infinitely expandable by
adding more identical 10+2 RAID6 arrays.  Your chunk size and thus
stripe width stays the same as well.  The default RAID6 chunk of 512KB
is probably fine for large video files as that would yield a 5MB stripe
width.  When expanding with identical constituent RAID6 arrays, you
don't have to touch the XFS stripe alignment configuration, but simply
grow the filesystem after adding additional arrays to the md/linear array.

The reason I recommend the 10+2 is two fold.  First, large video file
ingestion works well with a wide RAID6 stripe.  Second, because you
could start with an LSI 9207-8e and two of something like this chassis:
http://www.newegg.com/Product/Product.aspx?Item=N82E16816133047

using 48x 3TB Seagate Constellation (enterprise) SATA drives:
http://www.newegg.com/Product/Product.aspx?Item=N82E16822178324

all of which are rather inexpensive compared to Dell, HP, IBM, Fujitsu
Siemens, etc, at least here in the US.  I know this chassis is available
in Switzerland and Germany, but I don't know about Norway.  Each chassis
holds 24 drives, allowing for two 10+2 RAID6 arrays per chassis, four
arrays total.  You'd put the four md/RAID6 arrays in one md/linear
array, and format it with XFS such as:

~$ mkfs.xfs -d su=512k,sw=10 /dev/md0

This will give you a filesystem with a little under 120TB of net free
space with 120 allocation groups evenly distributed over the 4 arrays.
All AGs can be written in parallel, yielding a high performance video
ingestion, and playback system.  Before mounting you would modify fstab
to include the inode64 option.  Don't even bother attempting to use
EXT3/4 on a 120TB filesystem--they'll fall over after some use.  JFS
will work, but it's not well maintained, hasn't seen meaningful updates
in many years, and is slower than XFS in most areas.  XFS is the one
*nix filesystem that was created and optimized specifically for large
files and concurrent high bandwidth streaming IO.

See 'man mdadm' 'man mkfs.xfs' 'man mount' and 'man xfs' for more
specific information, commands, options, etc.

This may be a little more detail than you wanted, but it should give a
rough idea of at least one possible way to achieve your goal.

-- 
Stan

