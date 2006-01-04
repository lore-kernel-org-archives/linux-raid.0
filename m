From: Lorac Thelmwood <lorac.web@gmail.com>
Subject: Re: corrupt raid 5
Date: Tue, 3 Jan 2006 21:35:38 -0800
Message-ID: <5981e8c80601032135p312a37e0kf8c4e3d6edd05e53@mail.gmail.com>
References: <5981e8c80601031907l6d612bfcsf4a81826efc97f@mail.gmail.com>
	 <17339.20993.529499.281141@smtp.charter.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17339.20993.529499.281141@smtp.charter.net>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Seatools is a DOS based tool.  It doesn't matter what OS you have.  It
just examines the drives themselves, not the filesystem.  It is used
to check if your drives are bad.

>         echo 200000 > /proc/sys/dev/raid/speed_limit_max
>         echo 20000 > /proc/sys/dev/raid/speed_limit_min

The max is the same as above, but the min is set at 1000

On 1/3/06, John Stoffel <john@stoffel.org> wrote:
>
> Lorac> First I can't start the array because it complains about a bad
> Lorac> superblock.
>
> What's the exact error you get here?
I can't do an fsck on the filesystem.

debian:~# fsck.ext3 /dev/md1
e2fsck 1.37 (21-Mar-2005)
fsck.ext3: Invalid argument while trying to open /dev/md1

The superblock could not be read or does not describe a correct ext2
filesystem.  If the device is valid and it really contains an ext2
filesystem (and not swap or ufs or something else), then the superblock
is corrupt, and you might try running e2fsck with an alternate superblock:
    e2fsck -b 8193 <device>

And the version of mdadm that you're using?  1.9.0-4

What's the output of 'cat /proc/mdstat' and 'mdadm
> --detail /dev/md?' where ? is the number of your raid 5 array?

debian:~# cat /proc/mdstat
Personalities : [raid1] [raid5]
md1 : inactive hdh1[4] hdc1[0] hdg1[3] hdf1[2] hde1[1]
      976791680 blocks
md0 : active raid1 hda1[0] hdb1[1]
      18554944 blocks [2/2] [UU]

unused devices: <none>


debian:~# mdadm --detail /dev/md1
/dev/md1:
        Version : 00.90.01
  Creation Time : Sun Oct 23 15:29:36 2005
     Raid Level : raid5
    Device Size : 195358336 (186.31 GiB 200.05 GB)
   Raid Devices : 5
  Total Devices : 5
Preferred Minor : 1
    Persistence : Superblock is persistent

    Update Time : Thu Dec 29 18:40:51 2005
          State : active, degraded
 Active Devices : 4
Working Devices : 5
 Failed Devices : 0
  Spare Devices : 1

         Layout : left-symmetric
     Chunk Size : 64K

           UUID : a4e99793:d42bd2c0:21e04a88:09ff92c7
         Events : 0.2618509

    Number   Major   Minor   RaidDevice State
       0      22        1        0      active sync   /dev/hdc1
       1      33        1        1      active sync   /dev/hde1
       2      33       65        2      active sync   /dev/hdf1
       3      34        1        3      active sync   /dev/hdg1
       4      34       65        4      spare rebuilding   /dev/hdh1
>
> Lorac>  Secondly, one of the drives had a problem with losing its
> Lorac> interrupt, and that caused the system to hang a couple times.
>
> Ouch, not a good thing.  Which kernel and which controllers do you
> have on the system?  More details are better.

It is the debian sarge 2.6 stock kernel.  The drives are actually
split across 2 controllers.  The first drive (hdc) is connected to the
primary seconday ide controller on the mainboard.

The other 4 are connected to an onboard promise controller.  The
motherboard is a gibabyte board, almost 4 years old.
>
> Lorac> I have tested all the drives using seatools (I have 5 * 200GB
> Lorac> ATA drives) and they all report no problems.
>
> Is this a Windows only tool from Seagate to check disks?
>
> Lorac> If I ask mdadm for detail on the array, it tells me that the
> Lorac> array is active, but degraded (/dev/hdh1 is removed).  I try
> Lorac> adding the drive back into the array, and it says it is
> Lorac> rebuilding.  However, even after 12 hours it still says that.
>
> See what the output of /proc/mdstat says at that point.  You should
> just let it finish rebuilding until it's done.  You can tweak the
> rebuild speed by doing:
>
>         echo 200000 > /proc/sys/dev/raid/speed_limit_max
>         echo 20000 > /proc/sys/dev/raid/speed_limit_min
>
> This should help speed up things.  But before you do that, give us
> current values in there.
>
> Lorac> If i reboot, it just kicks the drive out of the array again.
>
> Of course, it hasn't marked it clean yet because it hasn't finished
> re-syncing it.
>
> Lorac> I could probably find room for the data elsewhere, and rebuild
> Lorac> the array; however I need to get at the actual data for that.
>
> You shouldn't need to do that.  Once you bring the array up, you
> should be able to do an fsck on the filesystem, even while it's
> re-syncing, and then mount hte filesystem and recover your data.
>
> Aren't you able to do that?
>
> John
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
