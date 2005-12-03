From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Booting from raid1 -- md: invalid raid superblock magic on sdb1
Date: Sat, 03 Dec 2005 09:02:29 -0500
Message-ID: <4391A575.8060707@tmr.com>
References: <050501c5f2a4$fe72c560$200a11ac@NCNF5131FTH>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <050501c5f2a4$fe72c560$200a11ac@NCNF5131FTH>
Sender: linux-raid-owner@vger.kernel.org
To: "David M. Strang" <dstrang@shellpower.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

David M. Strang wrote:

> I've read, and read, and read -- and I'm still not having ANY luck 
> booting completely from a raid1 device.
>
> This is my setup...
>
> sda1 is booting, working great. I'm attempting to transition to a 
> bootable raid1.
>
> sdb1 is a 400GB partition -- it is type FD.
>
> Disk /dev/sdb: 400.0 GB, 400088457216 bytes
> 2 heads, 4 sectors/track, 97677846 cylinders
> Units = cylinders of 8 * 512 = 4096 bytes
>
>   Device Boot      Start         End      Blocks   Id  System
> /dev/sdb1               1    97677846   390711382   fd  Linux raid 
> autodetect
>
> I have created my raid1 mirror with the following command:
>
> mdadm --create /dev/md_d0 -e1 -ap --level=1 --raid-devices=2 
> missing,/dev/sdb1
>
> The raid created correctly, I then partitioned md_d0 to match sda1. 

I hope that's a typo... you need to partition sdb, not the md_d0 raid 
device.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

