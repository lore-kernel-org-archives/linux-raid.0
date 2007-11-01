From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: switching root fs '/' to boot from RAID1 with grub
Date: Thu, 01 Nov 2007 10:31:38 -0700
Message-ID: <472A0D7A.4040807@zytor.com>
References: <20071030210721.386ca2fa@absurd> <1193781699.10336.585.camel@firewall.xsintricity.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1193781699.10336.585.camel@firewall.xsintricity.com>
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Janek Kozicki <janek_listy@wp.pl>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Doug Ledford wrote:
> 
> device /dev/sda (hd0)
> root (hd0,0)
> install --stage2=/boot/grub/stage2 /boot/grub/stage1 (hd0) /boot/grub/e2fs_stage1_5 p /boot/grub/stage2 /boot/grub/menu.lst
> device /dev/hdc (hd0)
> root (hd0,0)
> install --stage2=/boot/grub/stage2 /boot/grub/stage1 (hd0) /boot/grub/e2fs_stage1_5 p /boot/grub/stage2 /boot/grub/menu.lst
> 
> That will install grub on the master boot record of hdc and sda, and in
> both cases grub will look to whatever drive it is running on for the
> files to boot instead of going to a specific drive.
> 

No, it won't... it'll look for the first drive in the system (BIOS drive 
80h).  This means that if the BIOS can see the bad drive, but it doesn't 
work, you're still screwed.

	-hpa
