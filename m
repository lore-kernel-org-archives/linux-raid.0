From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Raid over 48 disks
Date: Tue, 18 Dec 2007 15:25:53 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0712181523250.7823@p34.internal.lan>
References: <00EF99B2-3BCC-4D75-BC75-8F256B0A2476@gmail.com>
 <Pine.LNX.4.64.0712181325480.13538@p34.internal.lan> <476820B0.9010200@ph.tum.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <476820B0.9010200@ph.tum.de>
Sender: linux-raid-owner@vger.kernel.org
To: Thiemo Nagel <thiemo.nagel@ph.tum.de>
Cc: Norman Elton <normelton@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Tue, 18 Dec 2007, Thiemo Nagel wrote:

> Dear Norman,
>
>>> So... we're curious how Linux will handle such a beast. Has anyone run MD 
>>> software RAID over so many disks? Then piled LVM/ext3 on top of that? Any 
>>> suggestions?
>>> 
>>> Are we crazy to think this is even possible?
>
> I'm running 22x 500GB disks attached to RocketRaid2340 and NFORCE-MCP55
> onboard controllers on an Athlon DC 5000+ with 1GB RAM:
>
> 9746150400 blocks super 1.2 level 6, 256k chunk, algorithm 2 [22/22]
>
> Performance of the raw device is fair:
> # dd if=/dev/md2 of=/dev/zero bs=128k count=64k
> 65536+0 records in
> 65536+0 records out
> 8589934592 bytes (8.6 GB) copied, 15.6071 seconds, 550 MB/s
>
> Somewhat less through ext3 (created with -E stride=64):
> # dd if=largetestfile of=/dev/zero bs=128k count=64k
> 65536+0 records in
> 65536+0 records out
> 8589934592 bytes (8.6 GB) copied, 26.4103 seconds, 325 MB/s
>
> There were no problems up to now.  (mkfs.ext3 wants -F to create a filesystem 
> larger than 8TB.  The hard maximum is 16TB, so you will need to create 
> partitions, if your drives are larger than 350GB...)
>
> Kind regards,
>
> Thiemo Nagel
>
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Quite slow?

10 disks (raptors) raid 5 on regular sata controllers:

# dd if=/dev/md3 of=/dev/zero bs=128k count=64k
65536+0 records in
65536+0 records out
8589934592 bytes (8.6 GB) copied, 10.718 seconds, 801 MB/s

# dd if=bigfile of=/dev/zero bs=128k count=64k
27773+1 records in
27773+1 records out
3640379392 bytes (3.6 GB) copied, 6.58454 seconds, 553 MB/s


