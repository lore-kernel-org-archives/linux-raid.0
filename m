From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: mdadm raid 5 one disk overwritten file system failed
Date: Thu, 19 Feb 2015 15:23:44 +0100 (CET)
Message-ID: <alpine.DEB.2.02.1502191521450.4007@uplift.swm.pp.se>
References: <020601d04c17$08c10290$1a4307b0$@johnandre.net> <alpine.DEB.2.02.1502191218140.4007@uplift.swm.pp.se> <021f01d04c4c$5def1740$19cd45c0$@johnandre.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <021f01d04c4c$5def1740$19cd45c0$@johnandre.net>
Sender: linux-raid-owner@vger.kernel.org
To: John Andre Taule <post@johnandre.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 19 Feb 2015, John Andre Taule wrote:

> I'm a bit surprised that overwriting anything on the physical disk 
> should corrupt the file system on the raid. I would think that would be 
> similar to a disk crashing or failing in other ways.

Errr, in raid5 you have data blocks and parity blocks. WHen you overwrite 
one of the component drives with zeroes, you're effectively doing the same 
as writing 0:es to a non-raid drive every 3 $stripesize. You're zero:ing a 
lot of the filesystem information.

> What you say that Linux might not have seen the disk as failing is
> interesting. This could explain why the file system got corrupted.

Correct. There is no mechanism that periodically checks the contents of 
the superblock and fails the drive if it's not there anymore. So the drive 
is never failed.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
