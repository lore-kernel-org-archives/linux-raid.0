From: Andy Smith <andy@strugglers.net>
Subject: Re: Shrinking number of devices on a RAID-10 (near 2) array
Date: Sun, 24 Aug 2014 14:39:44 +0000
Message-ID: <20140824143944.GC19874@bitfolk.com>
References: <20140823163110.GE11855@bitfolk.com>
 <20140824130939.461501b4@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140824130939.461501b4@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,

Thanks for the quick response!

On Sun, Aug 24, 2014 at 01:09:39PM +1000, NeilBrown wrote:
> raid10 reshape is only supported for v1.x metadata, and you have 0.90.
> This is because it needs to move the data_offset and 0.90 cannot do that.
> 
> I see you have already adjusted the --array-size correctly - good.
> 
> You can achieve your result by:
> 
>  1/ stop the array and assemble with --update=metadata.  This will convert the
>     array to v1.0

I've now done this, so:

$ sudo mdadm --detail /dev/md2
/dev/md2:
        Version : 1.0
  Creation Time : Sun Jun  4 08:18:59 2006
     Raid Level : raid10
     Array Size : 618726528 (590.06 GiB 633.58 GB)
  Used Dev Size : 309363264 (295.03 GiB 316.79 GB)
   Raid Devices : 6
  Total Devices : 6
    Persistence : Superblock is persistent

    Update Time : Sun Aug 24 14:29:15 2014
          State : active 
 Active Devices : 6
Working Devices : 6
 Failed Devices : 0
  Spare Devices : 0

         Layout : near=2
     Chunk Size : 64K

           Name : 2
           UUID : 3905b303:ca604b72:be5949c4:ab051b7a
         Events : 1

    Number   Major   Minor   RaidDevice State
       0       8       51        0      active sync   /dev/sdd3
       1       8       67        1      active sync   /dev/sde3
       2       8       83        2      active sync   /dev/sdf3
       3       8       19        3      active sync   /dev/sdb3
       4       8       35        4      active sync   /dev/sdc3
       5       8        3        5      active sync   /dev/sda3

I noticed something: The assemble with update re-set the array size
to 928089792 (885.10 GiB 950.36 GB).

(the above --detail is after all steps below)

>  2/ "mdadm /dev/md2 --grow --disks=4"  That should perform the reshape.

I assume that should have been --raid-devices; --disks seems to be a
syntax error. :)

Firstly it told me the array was too big, as expected.

$ sudo ./mdadm /dev/md2 --grow --raid-devices=4
mdadm: this change will reduce the size of the array.
       use --grow --array-size first to truncate array.
       e.g. mdadm --grow /dev/md2 --array-size 618726528
unfreeze

Okay.

$ sudo ./mdadm --grow /dev/md2 --array-size 618726528

But:

$ sudo ./mdadm /dev/md2 --grow --raid-devices=4
mdadm: Cannot set new_data_offset: RAID10 reshape not
       supported on this kernel

> I guess the error message could be better....

Will be happy to send the trivial patch once we get to the bottom of
this!

Cheers,
Andy
