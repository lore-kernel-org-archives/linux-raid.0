From: Cameron Moore <lists@unbeatenpath.net>
Subject: Re: md: can not impport hdb1, has active inodes!
Date: Tue, 2 Mar 2004 17:24:35 -0600
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040302172434.A29144@unbeatenpath.net>
References: <404507E4.8552.25AC3E6@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <404507E4.8552.25AC3E6@localhost>; from chris1@psyctc.org on Tue, Mar 02, 2004 at 10:17:08PM -0000
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I've been battling the same problem using Debian testing/sarge with SCSI
devices.  I followed (mostly) the same howto and have subsequently tried
many other things with no success.  I'm willing to help debug this as
well if anyone has any advice.  Thanks

* chris1@psyctc.org (Chris Evans) [2004.03.02 16:17]:
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
> cp -ax / /mnt, tweak /etc/fstab ... /dev/md0 mounts fine, tweak lilo 
> conf to boot from /dev/md0, reboot -- fine, finally come to add 
> /dev/hdb1 into the array after resetting the partition type to 
> autodetect RAID ... 
> 
> .. no go, system complains that /dev/hdb1 is mounted or that an inode 
> 
> is active:
> md: can not impport hdb1, has active inodes!
> md: error, md_import_device() returned -16
> 
> I assume that's because the boot is still from /dev/hdb but if so, 
> how come the howto says this should work.  Seems that nothing I do 
> can shift this and if I set the partition back to linux I find I 
> can't mount the drive despite rebooting as I get:
> 
> mount: /dev/hdb1 already mounted or /mnt1 busy
> 
> /mnt1 isn't busy (I can create a completely new mount point: no 
> difference) and mount shows that /dev/hdb1 isn't mounted.
> 
> I've tried all sorts of tweaking with lilo.conf to remove any calls 
> to /dev/hdb but either these don't change anything, or else lilo 
> complains that it can't install to the target (e.g. /dev/md0).
> 
> I've read through the docs and man pages and done some 
> searching around but can't find any explanations.
> 
> Help of any sort, including direct pointers to what I've missed or 
> misread, desperately needed!
> 
> Chris
> 
> PSYCTC: Psychotherapy, Psychology, Psychiatry, Counselling
>    and Therapeutic Communities; practice, research, 
>    teaching and consultancy.
> Chris Evans & Jo-anne Carlyle
> http://psyctc.org/ Email: chris@psyctc.org
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Cameron Moore
/ The other day, I went to a tourist information booth and asked, \
\  "Tell me about some of the people who were here last year".    /
