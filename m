From: Richard Scobie <richard@sauce.co.nz>
Subject: Re: RAID 1 and grub
Date: Thu, 31 Jan 2008 15:33:29 +1300
Message-ID: <47A13379.50703@sauce.co.nz>
References: <47A0F4DC.9030005@sauce.co.nz> <72dbd3150801301641n2801846cgc2f3bc04aa842baf@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <72dbd3150801301641n2801846cgc2f3bc04aa842baf@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

A followup for the archives:

I found this document very useful:

http://lists.us.dell.com/pipermail/linux-poweredge/2003-July/008898.html

After modifying my grub.conf to refer to (hd0,0), reinstalling grub on 
hdc with:

grub> device (hd0) /dev/hdc

grub> root (hd0,0)

grub> (hd0)

and rebooting with the bios set to boot off hdc, everything burst back 
into life.

I shall now be checking all my Fedora/Centos RAID1 installs for grub 
installed on both drives.

Regards,

Richard
