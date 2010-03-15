From: Joachim Otahal <Jou@gmx.net>
Subject: Re: RAID0 on disks with different sizes
Date: Mon, 15 Mar 2010 07:45:53 +0100
Message-ID: <4B9DD7A1.5060603@gmx.net>
References: <d19eda751003142326j7bfec447ne64cfa50e22f089c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <d19eda751003142326j7bfec447ne64cfa50e22f089c@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: rj <ratnadeep@gmail.com>
Cc: Mdadm <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

rj schrieb:
> Hi,
>
> How does MD RAID0 layer support disks with different sizes?
>    
All PARTITIONS to create a RAID0 device should be the same size, else 
the smallest is the one that counts.
If you have 250GB+500GB+750GB:
Create RAID0 with threee drive using the space from 0-250 GB, then a 
RAID1 with the space from 251 to 500, and the last one just normal (or 
linear). You can combine them with LVM.
You _could_ create 6 partitions with 250 GB and create a RAID0 across 
all of them, but that will hurt the performance a lot.
Best for all in one RAID is possible with "linear" = JBOD.

> 1. Does it take the size of smallest disk and do the striping
> accordingly?  This way there would be wastage of space in bigger
> disks.
> Or
> 2. Does it stripe across all the space of disks? This way, if striping
> is not possible for a disk because it has exhausted the space,
> striping will continue or remaining devices (although with
> compromising performance for these stripes because they have one disk
> less).
>
> What approach md chooses? Also, what approach is taken for RAID5 in such cases?
>    
md does not choose on it's own, you set it up. When using disks like the 
example above: RAID 5 across the spave of 0-250 GB.

> Thanks in advance.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>    

