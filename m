From: Michal Soltys <soltys@ziu.info>
Subject: Re: Linux RAID Partition Offset 63 cylinders / 30% performance hit?
Date: Wed, 19 Dec 2007 22:44:20 +0100
Message-ID: <476990B4.5050803@ziu.info>
References: <Pine.LNX.4.64.0712190926150.2468@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0712190926150.2468@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>
List-Id: linux-raid.ids

Justin Piszcz wrote:
> 
> Or is there a better way to do this, does parted handle this situation 
> better?
> 
> What is the best (and correct) way to calculate stripe-alignment on the 
> RAID5 device itself?
> 
> 
> Does this also apply to Linux/SW RAID5?  Or are there any caveats that 
> are not taken into account since it is based in SW vs. HW?
> 
> ---

In case of SW or HW raid, when you place raid aware filesystem directly on 
it, I don't see any potential poblems

Also, if md's superblock version/placement actually mattered, it'd be pretty 
strange. The space available for actual use - be it partitions or filesystem 
directly - should be always nicely aligned. I don't know that for sure though.

If you use SW partitionable raid, or HW raid with partitions, then you would
have to align it on a chunk boundary manually. Any selfrespecting os 
shouldn't complain a partition doesn't start on cylinder boundary these 
days. LVM can complicate life a bit too - if you want it's volumes to be 
chunk-aligned.

With NTFS the problem is, that it's not aware of underlaying raid in any 
way. It starts with 16 sectors long boot sector, somewhat compatible with 
ancient FAT. My blind guess would be to try to align the very first sector 
of $Mft with your chunk. Also, mentioned bootsector is also referenced as 
$Boot, thus I don't know if large cluster won't automatically extend it to 
full cluster size. Experiment, YMMV :)


