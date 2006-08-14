From: Luca Berra <bluca@comedia.it>
Subject: Re: Making bootable SATA RAID1 array in Mandriva 2006
Date: Mon, 14 Aug 2006 10:17:14 +0200
Message-ID: <20060814081714.GI19306@percy.comedia.it>
References: <44DFBB0E.90705@aol.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <44DFBB0E.90705@aol.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Aug 13, 2006 at 07:51:42PM -0400, andy liebman wrote:
>-- I copied the contents of /dev/sda1 (/ partition) and /dev/sda6 (/home 
>partition) to /dev/sdb1 and /dev/sdb6 using rsync.
this is not really important, but you should have used the raid devices
as a target.

>-- I edited fstab and lilo.conf on the the RAID1 "/" partition so that 
>they would refer to /dev/md1
>-- I ran chroot on the /dev/md1 partition
did you mount /dev, /proc and /sys before chrooting?
i.e
mount --bind /dev /newroot/dev
mount -t proc /proc /newroot/proc
mount -t sysfs /sys /newroot/sys

>-- I set up an /etc/mdadm.conf file (using mdadm --detail 
>--scan>>/etc/mdadm.conf   -- that's where Mandriva puts it)
>-- I added to lilo.conf "raid-extra-boot=  and tried both "mbr" and 
>"/dev/sda,/dev/sdb"
mbr should do

>-- I ran mkinitrd and created a new initrd in /boot on /dev/md1.  I got 
>an error about not finding the 3w_9xxx driver, but I don't need to load 
>that in the initrd anyway so I reran with --builtin=3w_9xxx so that 
>mkinitrd would skip that driver that I don't need.
>
>BUT, after all of this, I get a bunch of errors when I try to run lilo:
>     Fatal: Trying to map files from unnamed device 0x0000

Regards,
L.

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
