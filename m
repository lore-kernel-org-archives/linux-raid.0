From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Fwd: Installing Linux directly onto RAID6 Array...........
Date: Sun, 24 May 2015 10:36:17 +0200 (CEST)
Message-ID: <alpine.DEB.2.02.1505241032210.9487@uplift.swm.pp.se>
References: <CAOS+5GFwGJouUfZ_RWhtRVXw7wnoP1Ry4doHTJmkruFoccmqRg@mail.gmail.com> <555294A0.6040703@websitemanagers.com.au> <CAOS+5GEP6+7OAHkqQjeyGHAB5u-_-Vq2JWGpcOemYHdCjmR5Lg@mail.gmail.com>
 <CAOS+5GHKwQRPfNAw0EpSjjDUt=9PmjjrkUg+dhGxFS+uOWWVug@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAOS+5GHKwQRPfNAw0EpSjjDUt=9PmjjrkUg+dhGxFS+uOWWVug@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Another Sillyname <anothersname@googlemail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 24 May 2015, Another Sillyname wrote:

> So I now have 5 partitions.
>
> a  -  bios_boot
> b  -  efi
> c  -  boot
> d  -  root
> e  -  swap
>
> I'll be adding one more when I'm happy this is working.
>
> f  -  home
>
> 3.  Using the methods above I have now created a bootable fedora
> system, on a single drive in preparation to now RAID the required
> partitions.  However my concern comes regarding the mdadm metadata,
> simplistically metadata=1.2 apparently writes it's superblock to 4k
> after the start of the device, this is exactly where my efi partition
> (b above) starts, so my concern is will this superblock overwrite or
> mess with my current partition table?
>
> 4.  If the next stage works then I think what I'll actually end up
> doing is......
>
> scrub what I have now.
>
> create the arrays before running the Fedora Live installer (this
> assumes the installer will see /md[x] devices and allow them to be
> used to install to). Then incorporate the mdadm.conf data into the
> initramfs and regenerate initramfs.
>
> Ideas/Thoughts/Criticisms?

You don't want to run MD on the entire drive in this case, you most likely 
want to create multiple RAID1 and RAID6 mirrors. RAID1 your boot, root and 
swap, then run RAID6 on your home partition. Use use superblock type that 
creates the superblock at the end for the RAID1 partitions.

Also, you don't want to refer to "sda" when booting, you want to use 
UUID=<uuid> in fstab, crypttab etc.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
