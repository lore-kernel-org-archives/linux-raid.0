From: "John Andre Taule" <post@johnandre.net>
Subject: SV: mdadm raid 5 one disk overwritten file system failed
Date: Wed, 15 Apr 2015 13:47:31 +0200
Message-ID: <00b901d07771$f56c0010$e0440030$@johnandre.net>
References: <020601d04c17$08c10290$1a4307b0$@johnandre.net> <alpine.DEB.2.02.1502191218140.4007@uplift.swm.pp.se> <021f01d04c4c$5def1740$19cd45c0$@johnandre.net> <alpine.DEB.2.02.1502191521450.4007@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.02.1502191521450.4007@uplift.swm.pp.se>
Content-Language: no
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

The guy that did this to us got 3 months jail. 

His argument was that we should have failed the system manually (removed the
disk that he targeted with "dd"), and the raid should have magically fixed
itself. Anyone think this would have worked? 
It was 5 hours of heavy write and deletes to the file system (ext4) and all
that time the dd command where running.

Later I also found this exact "test" of raid in mdadm documentation marking
it as not something you should do (will fail data integriy, eg corrupt
filesystem, period).

/regards

-----Opprinnelig melding-----
Fra: Mikael Abrahamsson [mailto:swmike@swm.pp.se] 
Sendt: 19. februar 2015 15:24
Til: John Andre Taule
Kopi: linux-raid@vger.kernel.org
Emne: Re: mdadm raid 5 one disk overwritten file system failed

On Thu, 19 Feb 2015, John Andre Taule wrote:

> I'm a bit surprised that overwriting anything on the physical disk 
> should corrupt the file system on the raid. I would think that would 
> be similar to a disk crashing or failing in other ways.

Errr, in raid5 you have data blocks and parity blocks. WHen you overwrite
one of the component drives with zeroes, you're effectively doing the same
as writing 0:es to a non-raid drive every 3 $stripesize. You're zero:ing a
lot of the filesystem information.

> What you say that Linux might not have seen the disk as failing is 
> interesting. This could explain why the file system got corrupted.

Correct. There is no mechanism that periodically checks the contents of the
superblock and fails the drive if it's not there anymore. So the drive is
never failed.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se

