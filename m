From: "Rechenberg, Andrew" <ARechenberg@sfg.com>
Subject: RE: Low perfomance of RAID0,RAID5, RAID+LVM on 2.6
Date: Thu, 19 Aug 2004 14:12:07 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <8075D5C3061B9441944E1373776451186488C7@cinshrexc03.shermfin.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
To: "Vladimir I. Umnov" <uvi@ezmail.ru>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Vladimir,

In the part of the message that was quoted to the linux-raid list the
performance of the RAID devices isn't specified.  All I see is you
testing /dev/sda1 and mentioning kernel modules, but no mention of
/dev/mdX or /dev/YourVG/YourLV.

What types of numbers are you seeing when using your RAID/LVM devices in
your dd test?  Also, you may want to try using bonnie++ to get some
representative numbers as this program tends to be a little more
representative of actual performance without involving the linux VM
cache.

I have yet to use 2.6 for RAID/LVM so I can't point you in a specific
direction, however I didn't see any performance numbers for RAID or LVM
devices.

Try running bonnie++ or /dev/mdX or /dev/YourVG/YourLV and seeing if
it's what you expect.

Good luck,
Andy.

> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org 
> [mailto:linux-raid-owner@vger.kernel.org] On Behalf Of David Greaves
> Sent: Thursday, August 19, 2004 11:53 AM
> To: Vladimir I. Umnov
> Cc: linux-raid@vger.kernel.org
> Subject: Re: Low perfomance of RAID0,RAID5, RAID+LVM on 2.6
> 
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Vladimir I. Umnov wrote:
> 
> |HW: chipset 875WPE, P4 2.4HT, 3 SATA WD 160JD, 1 ATA Samsung 80Gb.
> |SW: kernel 2.6.6, libata drivers for PROMISE S150 TX4.
> |CONFIG: 256K readahead on all drives.
> |    sda1,sdb1,sdc1->RAID0 (md0)
> |    sda2,sdb2,sdc2,hda1->RAID5 (md1)
> |    about 20 partitions on LVM2 with xfs,ext3,reiserfs
> |    chunksize on md0, md1 = 256k - this was optimal with 
> 2.6.0test3 about
> |    year ago.
> |
> |Theoretically RAID0 read speed should be nearly read speed 
> of one drive 
> |multiply to number of drives, but I have:
> |dd if=/dev/sda1 of=/dev/null gives about 44 Mb/s on all 
> drives (but  on
> |sii3112 ide driver with  WD 160JD about 55Mb/s and on libata the same
> |44)
> 
> I use my arrays for large video files so large readahead is good.
> 
> I use blockdev on the lvms:
> /sbin/blockdev --setra 4096 /dev/video_vg/video_lv 
> /sbin/blockdev --setra 4096 /dev/video_vg/huge_lv
> 
> the md device:
> /sbin/blockdev --setra 4096 /dev/md0
> 
> and the raw devices
> /sbin/blockdev --setra 4096 /dev/sda
> /sbin/blockdev --setra 4096 /dev/sdb
> /sbin/blockdev --setra 4096 /dev/sdc
> /sbin/blockdev --setra 4096 /dev/sdd
> /sbin/blockdev --setra 4096 /dev/hdb
> 
> HTH
> 
> David
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1.2.5 (GNU/Linux)
> Comment: Using GnuPG with Thunderbird - http://enigmail.mozdev.org
> 
> iD8DBQFBJMz08LvjTle4P1gRAkfpAJ9XA17vexSqmcN0LVFZOx0Dxik/BQCgjMk+
> oAslumzTWosxF9WqnDXln3k=
> =C3uO
> -----END PGP SIGNATURE-----
> 
> -
> To unsubscribe from this list: send the line "unsubscribe 
> linux-raid" in the body of a message to 
> majordomo@vger.kernel.org More majordomo info at  
> http://vger.kernel.org/majordomo-info.html
> 
