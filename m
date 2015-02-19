From: "John Andre Taule" <post@johnandre.net>
Subject: SV: mdadm raid 5 one disk overwritten file system failed
Date: Thu, 19 Feb 2015 15:00:06 +0100
Message-ID: <021f01d04c4c$5def1740$19cd45c0$@johnandre.net>
References: <020601d04c17$08c10290$1a4307b0$@johnandre.net> <alpine.DEB.2.02.1502191218140.4007@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.02.1502191218140.4007@uplift.swm.pp.se>
Content-Language: no
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

The array was not stopped before dd was running. The "hacker" logged on,
left the command running and logged of. It was discovered the next morning
about 5 hours later, and there was very high load on the server, I think
this is why the command where discovered at all. This is how that raid have
performed earlier when a drive have failed.

I'm a bit surprised that overwriting anything on the physical disk should
corrupt the file system on the raid. I would think that would be similar to
a disk crashing or failing in other ways.

What you say that Linux might not have seen the disk as failing is
interesting. This could explain why the file system got corrupted.

-----Opprinnelig melding-----
Fra: Mikael Abrahamsson [mailto:swmike@swm.pp.se] 
Sendt: 19. februar 2015 12:20
Til: John Andre Taule
Kopi: linux-raid@vger.kernel.org
Emne: Re: mdadm raid 5 one disk overwritten file system failed

On Thu, 19 Feb 2015, John Andre Taule wrote:

> Hi!
>
> Case: mdadm Raid 5 4 2TB disks. ext4 formatted spanning the raid.
> Attack: dd if=/dev/zero of=/dev/sdb bs=1M
>
> Expected result would be a raid that could be recovered without data loss.
>
> Result was that the file system failed and not possible to recover.
>
> As I understand it if this was a "hardware type fake" raid controller, 
> the outcome would be uncertain. However I'm a bit confused as to why 
> the raid (or more specifically the file system) would fail so horrible 
> when losing one disk. Is there perhaps critical information written 
> "outside" the raid on the physical disk, and this where overwritten in the
attack?

Did you stop the array before you did the dd command, or you just did it?

If you just did it, most likely you overwrote the superblock on the drive
(located near the beginning of the drive by recent default), plus part of
the file system.

> It would be nice to have an exact idea as to why it failed so hard, 
> and how obvious it should be that this attack would have more 
> consequence then a degraded raid.

Because if the drive was active then the operating system most likely didn't
notice that you overwrote part of the data on the disk and the drive wasn't
failed.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se

