From: Andrew Farley <andrew@neonsurge.com>
Subject: Re: Booting off of RAID10 versus RAID1
Date: Thu, 8 May 2008 16:35:14 +0200
Message-ID: <F173803E-7982-4BE7-898C-0D2BB36A94A9@neonsurge.com>
References: <48230154.4000509@harddata.com>
Mime-Version: 1.0 (Apple Message framework v919.2)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <48230154.4000509@harddata.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I'm pretty sure you can't put the kernel on a raid 10, but you can  
have a 50-100MB RAID1 (or not raid) /boot partition (on each hdd if  
you wish) and then have root on raid 10 provided you compile in  
support for it or use a initrd.  I have used this setup successfully  
without the kernel raid 10 support (older linux distro).  I just have  
a raid 0 on top of three raid 1's that auto assemble the raid 1's upon  
boot but then have to manually assemble the raid 0 since the boot-up  
procedure only does one round of raid auto-detecting.

Just required this little hack in menu.lst

title  Default kernel - build2
root (hd0,0)
kernel /kernel-build2 root=/dev/md4 md=4,/dev/md1,/dev/md2,/dev/md3

Just a trick I used, makes some great vm and/or db servers.  Cheers,

  - A

On May 8, 2008, at 3:34 PM, Maurice Hilarius wrote:

> After recent issues discovered with RAID1 and failing disks, I am  
> contemplating alternatives to ensure more reliability.
>
> The question that arises: Is there any way to boot a system from a  
> RAID10 md?
