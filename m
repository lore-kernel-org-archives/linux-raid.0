From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: md: can not impport hdb1, has active inodes!
Date: Wed, 3 Mar 2004 10:40:04 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16453.6996.215724.636242@notabene.cse.unsw.edu.au>
References: <404507E4.8552.25AC3E6@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Chris Evans on Tuesday March 2
To: Chris Evans <chris1@psyctc.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday March 2, chris1@psyctc.org wrote:
> Debian stable 2.4.19 kernel with RAID1 compiled in, VIA EPIA CL1000 
> motherboard, 2 Maxtor DiamondMax 9 7200rpm 80Gb drives as /dev/hdb 
> and /dev/hdc from onboard controller.
> 
> I've followed the guide at:
> http://www.cs.montana.edu/faq/faqw.admin.py?query=Convert+Root+System+
> to+Software+Raid&querytype=simple&casefold=yes&req=search
> 
> which had turned up on a debian list search to try to set up the 
> RAID1 mirror of the boot/root drive.  I installed to /dev/hdb1 
> (/dev/hda is the CDROM and perhaps I should have changed that first). 
> 
> Loaded 2.2.20, got 2.4.19 sources, compiled RAID1 support into the 
> kernel (still can't get rid of one complaint about a missing 
> character set module but don't think that's causing any real 
> problems), made the identical /dev/hdc1 into a somewhat smaller linux 
> 
> autodetect RAID format partition, mounted it as 2nd drive in a RAID1 
> drive using:
>   mdadm --create /dev/md0 --level=1 --raid-disks=2 missing /dev/hdc1
> which worked fine, mkfs -t ext3 /dev/hdc1, mount it to /mnt1, 

Wrong.
 mkfs -t ext3 /dev/md0
then mount /dev/md0. 
Once you have included /dev/hdc1 in an array, don't touch it again -
just access the array (/dev/md0).

> cp -ax / /mnt, tweak /etc/fstab ... /dev/md0 mounts fine, tweak lilo 
> conf to boot from /dev/md0, reboot -- fine, finally come to add 
> /dev/hdb1 into the array after resetting the partition type to 
> autodetect RAID ... 

You missed a step (step 9).  You have to reboot so that /dev/md0 is your root
device.
Once you have done that and are happy with it, you add in /dev/hdb1
and let it resync.

NeilBrown
