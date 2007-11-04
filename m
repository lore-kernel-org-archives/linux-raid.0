From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: switching root fs '/' to boot from RAID1 with grub
Date: Sun, 04 Nov 2007 10:02:15 -0800
Message-ID: <472E0927.4000701@zytor.com>
References: <20071030210721.386ca2fa@absurd> <1193781699.10336.585.camel@firewall.xsintricity.com> <472A0D7A.4040807@zytor.com> <472B51F0.3080605@panix.com> <472D3A1C.800@tmr.com> <472D402D.6040900@zytor.com> <472D4A86.3090700@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <472D4A86.3090700@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: berk walker <berk@panix.com>, Doug Ledford <dledford@redhat.com>, Janek Kozicki <janek_listy@wp.pl>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Bill Davidsen wrote:
> 
> I don't understand your point, unless there's a Linux bootloader in the 
> BIOS it will boot whatever 512 bytes are in sector 0. So if that's crap 
> it doesn't matter what it would do if it was valid, some other bytes 
> came off the drive instead. Maybe Windows, since there seems to be an 
> option in Windows to check the boot sector on boot and rewrite it if it 
> isn't the WinXP one.  One of my offspring has that problem, dual boot 
> system, every time he boots Windows he has to boot from rescue and 
> reinstall grub.
> 
> I think he could install grub in the partition, make that the active 
> partition, and the boot would work, but he tried and only type FAT or 
> VFAT seem to boot, active or not.
> 

The Grub-promoted practice of stuffing the Linux bootloader in the MBR 
is a bad idea, but that's not the issue here.

The issue here is that the bootloader itself is capable of making the 
decision to reject a corrupt image and boot the next device.  The Linux 
kernel, unfortunately, doesn't have a sane way to do that.

	-hpa
