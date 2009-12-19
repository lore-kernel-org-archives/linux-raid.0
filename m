From: Roger Heflin <rogerheflin@gmail.com>
Subject: Re: Typical RAID5 transfer speeds
Date: Sat, 19 Dec 2009 15:35:45 -0600
Message-ID: <4B2D4731.3090702@gmail.com>
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

Matt Tehonica wrote:
> I have a 4 disk RAID5 using a 2048K chunk size and using XFS 
> filesystem.  Typical file size is about 2GB-5GB. I usually get around 
> 50MB/sec transfer speed when writting files to the array. Is this 
> typcial or is it below normal?  A friend has a 20 disk RAID6 using the 
> same filesystem and chunk size and gets around 150MB/sec. Any input on 
> this??
> 
> Thanks,
> Matt

Speed depends on how the disks are connected to the system, and how 
many disks there are per connection, and what kind of disks they are.

If your friend had a 20 disk raid6 on one 4port sata pci-32bit/33mhz 
card with port multipliers his total throughput would be <110mb/second 
reads or writes, if your friend had 20 disks on 10+ port pcie-x16 
cards his total possible speed would be much much higher, reads would 
be expected to be 18x(rawdiskrate) if the machine could handle it.

Also newer disks are faster than older disks.

1.5tb disks read/write at 125-130+ MB/second on a fast port.
1.5tb disks read/write at 75-80 MB/second on a PCI-32bit/33mhz port.
500gb disks read/write at 75-80 MB/second on a PCI-32bit/33mhz port.
250gb disks read/write at 50-55 MB/second on a fast port.

And those PCI-32bit/33mhz ports are with only a single disk, put more 
than one on there, and the io rates drop...so 2 disk on 
pci-32bit/33mhz (old PCI) port will have <50MB/second each no matter 
how fast the disk is, put 3 on there and each disk is down to 33mhz, 4 
25MB/second or less.
