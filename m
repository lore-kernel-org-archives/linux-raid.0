From: "Cress, Andrew R" <andrew.r.cress@intel.com>
Subject: RE: Booting from a raid1 device ?
Date: Mon, 27 Oct 2003 16:14:36 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E5DA6395B8F9614EB7A784D628184B200E33DE@hdsmsx402.hd.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
content-class: urn:content-classes:message
To: donj@asaca.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Don,

Yes, it certainly can be done.  I do it all the time.

It's not hard with lilo, but grub doesn't support raid/md boot devices
yet.  This means that the grub boot record doesn't automatically get
written to the second disk.  In short, choose lilo for root mirroring if
possible.

The procedure is simplest if you use the distro installer to configure
it, but an existing installation can also be converted to root mirror
(raid1).  
See http://www.tldp.org/HOWTO/Software-RAID-HOWTO-4.html  (sections 4.11
thru 4.14)
or http://scsirastools.sourceforge.net/docs/UserGuide (section 4.0)

The md module MUST be staticly linked, not a module
(CONFIG_BLK_DEV_MD=y).  The other pieces (raid1.o, etc.) can be modules
if included in the initrd image.  The partitions should be marked as
raid autodetect type (0xfd).  

To be fully redundant, the '/boot', '/' and swap partitions should each
be mirrored.

Andy

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Paul Clements
Sent: Monday, October 27, 2003 11:01 AM
To: donj@asaca.com
Cc: linux-raid@vger.kernel.org
Subject: Re: Booting from a raid1 device ?


Don Jessup wrote:
> 
>   Is it possible to boot from a raid1 device with the md.o built as a
>  2.4.22 kernel module?

Yes, but it's tricky. You'd have to load md.o and raid1.o in your initrd
(or other early boot time initialization) and then use some, e.g.,
statically-linked mdadm tool on that initrd to start the array. You
cannot, however, use md's RAID autodetect to autostart arrays that have
their component partitions marked as RAID autodetect (0xfd), if md is a
module.

--
Paul


> =====
> Don Jessup
> Asaca/Shibasoku Corp. of America
> 400 Corporate Circle, Unit G
> Golden, CO  80401
> 303-278-1111 X232
> donj@asaca.com
> http://www.asaca.com
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid"
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
