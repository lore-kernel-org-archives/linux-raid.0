From: Laurent Lesage <laurent@lesagepono.be>
Subject: Re: Making bootable SATA RAID1 array in Mandriva 2006
Date: Mon, 14 Aug 2006 15:39:15 +0200
Message-ID: <44E07D03.9020802@lesagepono.be>
References: <44DFBB0E.90705@aol.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <44DFBB0E.90705@aol.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: andy liebman <andyliebman@aol.com>
List-Id: linux-raid.ids

Hi Andy,

I did the same a few times (!) with a Debian stable. I found two pages 
with "recipes" that were convenient to me. For what could be related to 
you, I had to modify the "/etc/mkinirtd/mkinitrd.conf" file :
>
> If you are using a SATA drive you pay attention!
>
> edit /etc/mkinitrd/mkinitrd.conf and change:
>
>     MODULES=most
>
> to
>
>     ###MODULES=most
>     MODULES=dep
>
> and
>
>     ROOT=probe
>
> to
>
>     ###ROOT=probe
>     ROOT="/dev/md2 jfs"
>
> This tells init to use what it takes to boot off of a raid device not 
> the /dev/sda device currently used. 
(modify according to your specs) The first part (mo=dep) is not 
mandatory (it just makes a smaller image), but the second is!

I took this form this page :
http://www.xtronics.com/reference/SATA-RAID-debian-for-2.6.html

this other page is useful if you want to use grub instead of lilo (but 
part of it is about IDE drive, which is not useful here) :
http://www.epimetrics.com/topics/one-page?page_id=421&topic=Bit-head%20Stuff&page_topic_id=120

hope that helps.

Laurent


andy liebman wrote:
> Hi,
>
> I have spent the better part of this weekend struggling to get a SATA 
> RAID1 array to boot in Mandriva 2006. I have read EVERYTHING I can 
> find that's related. I'm stuck. Maybe somebody can point me in the 
> right direction.
>
> First, let me say it's not practical for me to compile all necessary 
> drivers into the kernel. I realize that might make like easier.
>
> So, here's the story in summary:
>
> -- I have a motherboard with an ICH5 SATA chipset
> -- My normal Mandriva installation boots off of SATA (in real SATA 
> mode, not pretending to be IDE).
> -- A while back, when I installed the bootloader on the single SATA 
> drive, I chose to put it in the MBR and NOT on the first partition (I 
> fear that might be part of the problem)
> -- I added a second SATA drive, /dev/sdb, which came up fine.
> -- I copied the partition layout from /dev/sda with sfdisk
> -- I created two RAID1 devices from /dev/sdb1 and /dev/sdb6, with 
> their counterparts "missing" (using mdadm)
> -- I formated the two md devices with ext3
> -- I rebooted with a LIVE CD version of Mandriva
> -- I copied the contents of /dev/sda1 (/ partition) and /dev/sda6 
> (/home partition) to /dev/sdb1 and /dev/sdb6 using rsync.
> -- I edited fstab and lilo.conf on the the RAID1 "/" partition so that 
> they would refer to /dev/md1
> -- I ran chroot on the /dev/md1 partition
> -- I set up an /etc/mdadm.conf file (using mdadm --detail 
> --scan>>/etc/mdadm.conf   -- that's where Mandriva puts it)
> -- I added to lilo.conf "raid-extra-boot=  and tried both "mbr" and 
> "/dev/sda,/dev/sdb"
> -- I ran mkinitrd and created a new initrd in /boot on /dev/md1.  I 
> got an error about not finding the 3w_9xxx driver, but I don't need to 
> load that in the initrd anyway so I reran with --builtin=3w_9xxx so 
> that mkinitrd would skip that driver that I don't need.
>
> BUT, after all of this, I get a bunch of errors when I try to run lilo:
>     Fatal: Trying to map files from unnamed device 0x0000
>
> or
>
>     trying map files unnamed
>
>
> I tried putting an MBR on /dev/sdb with:
> lilo -M /dev/sdb
>
> I tried booting without /dev/sda and of course there's no bootloader 
> on /dev/sdb so nothing happens.
>
> Does anybody see a solution or see what I'm missing? Help would be 
> appreciated. I can't believe this is so complicated! :(
>
> Regards,
> Andy Liebman
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>

