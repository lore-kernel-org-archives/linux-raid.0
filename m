From: Andre Tomt <andre@tomt.net>
Subject: Re: Typical RAID5 transfer speeds
Date: Sun, 20 Dec 2009 16:25:56 +0100
Message-ID: <4B2E4204.5070608@tomt.net>
References: <B26AD6F5-45F6-4CC6-AE63-E4253E60076C@mac.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <B26AD6F5-45F6-4CC6-AE63-E4253E60076C@mac.com>
Sender: linux-raid-owner@vger.kernel.org
To: Matt Tehonica <matt.tehonica@mac.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 19.12.2009 01:37, Matt Tehonica wrote:
> I have a 4 disk RAID5 using a 2048K chunk size and using XFS filesystem.
>   Typical file size is about 2GB-5GB. I usually get around 50MB/sec
> transfer speed when writting files to the array. Is this typcial or is
> it below normal? A friend has a 20 disk RAID6 using the same filesystem
> and chunk size and gets around 150MB/sec. Any input on this??

Software RAID performance should not be that slow, unless the drives are 
connected to controller on 32bit/33Mhz PCI slots of course. There is a 
few things to keep in mind though.

Controllers and bus topology of the motherboard matters a great deal on 
I/O performance, but even on recent (up to around 3 years back, I think) 
desktop motherboards you should be able to go very fast when using the 
right slots and busses. PCI-Express was the game changer here, but you 
should try to get most SATA ports on a slot connected to the north 
bridge if you want to go REALLY fast.

Filesystem alignment and stripe size awareness helps quite a bit, and I 
guess even more on a machine that is already bus starved (if thats your 
problem) as it helps reduce "invisible" I/O - operations spanning 
multiple stripes when they could have spanned one, for example, and a 
reduction in read-modify-write cycles in general.

A bigger stripe_cache on the array might help, especially if things 
aren't aligned/aware, if you got the memory (check /sys/block/<md 
dev>/md/stripe_cache_active and _size.)

On a old Intel core 2 duo, with a MD RAID6 set using 128k chunks over 8 
1.5TB 7200rpm SATA drives I'm seeing about 600MB/s writes and 
700-750MB/s reads with sequential I/O - which is very near the maximum 
for the resulting stripe size with those drives. Changing to RAID5 would 
probably net me another ~100MB/s as the stripe would span one more drive.
