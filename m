From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: Best Practice for Raid1 Root
Date: Thu, 15 Jan 2004 03:32:12 +0300
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <4005DF8C.7080206@tls.msk.ru>
References: <NMEHJKFGFEGJPIPOLFFECEMHDEAA.valo@valo.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <NMEHJKFGFEGJPIPOLFFECEMHDEAA.valo@valo.at>
To: Christian Kivalo <valo@valo.at>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Christian Kivalo wrote:
>>Hi,
>>
> 
> [snip]
> 
>>The boot loader is grub and I want both /boot and / raided.
>>
>>In the event of a failure of hda I would like the system to switch to
>>hdc. This works fine. However what I have had problems with is if the
>>system reboots. If /dev/hda is unavailable I no longer have a disk with
>>a boot sector set up correctly. Unless I have a floppy or CDROM with a
>>boot loader the system will not come up.
[]
> one possible solution would be to use lilo. lilo is capable of booting
> from md raid1 arrays. look at lilo.conf(5) manpage for 'raid-extra-boot'
> in 'GLOBAL OPTIONS'. i use it on most of my maschines. AFAIK grub is not
> able to boot from /dev/mdX.

When using raid-extra-boot, lilo treats second disk as bios #0x81,
3rd disk as bios #0x82 and so on.  That to say - if your first disk
fails and BIOS will substitute second disk in place of first, making
it 0x80 instead of 0x81, lilo will not boot too, exactly in a way
why grub installed into /dev/hdb (that was e.g. temporarily plugged
into another machine just to make it bootable etc) does not want to
boot from it when it will be /dev/hda again (when returned back into
it's own machine).

Instead of using raid-extra-boot, IMHO, it is more safe to install
lilo into the raid array instead of the MBR, and use standard MBR
to boot from active partition.  But granted, lilo's raid-extra-boot
will work around different disk layouts, while lilo on raid with
standard MBR will not.

/mjt

