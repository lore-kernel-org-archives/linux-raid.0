From: "Cress, Andrew R" <andrew.r.cress@intel.com>
Subject: RE: Booting from a raid1 device ?
Date: Wed, 29 Oct 2003 10:50:43 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E5DA6395B8F9614EB7A784D628184B200E33E3@hdsmsx402.hd.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
content-class: urn:content-classes:message
To: Sandro Dentella <sandro.dentella@tin.it>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Sandro,

From within grub, you can do
> install (hd0,0)/grub/stage1 (hd1) (hd1,0)/grub/stage2
(hd0,0)/grub/menu.lst
to write the boot sector from hd0 to hd1 without a floppy.  

However, you will need to do this again to any replacement disks added
to the raid-1, and if the primary disk's boot info gets corrupted, grub
won't automatically switch to the mirror/secondary, you'll have to
physically remove the corrupted disk.  

Does anybody know if/when the grub project will add raid support?  

Andy

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Sandro Dentella
Sent: Tuesday, October 28, 2003 3:31 PM
To: linux-raid@vger.kernel.org
Subject: Re: Booting from a raid1 device ?


On Tue, Oct 28, 2003 at 11:56:44AM +0100, Lars Marowsky-Bree wrote:
> On 2003-10-27T23:11:19,
>    Hermann Himmelbauer <dusty@strike.wu-wien.ac.at> said:
> 
>>BTW, assuming I have md.o not as module but statically in the kernel,
which
>>bootloader would support RAID1? I heard LlLO does this job but does
also grub
>>- which I prefer - support Linux SW-RAID1?
> 
> grub doesn't yet afaik.

What does this exactly mean. I always use GRUB for Raid1 setup with boot
partition an md device, and I'm beginning to think I'm using it the
wrong
way!

What I do is I 'setup' the partitios from a floppy:

title Install GRUB into (hd0,0) the first disk
root    (hd0,0)
setup   (hd0)
 
title Install GRUB into (hd1,0) the second disk
root    (hd1,0)
setup   (hd1)


Both partitions (hd0,0) and (hd1,0) are part of /dev/md/0

At that point I'm able to start from both devices... BTW I've never been
able to do that w/o passing from a floppy. If I do that from the CD I
use to
install everithing seems OK but it doesn't boot.


-- 
Sandro Dentella  *:-)
e-mail: sandro.dentella@tin.it 
http://www.tksql.org                    TkSQL Home page - My GPL work
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
