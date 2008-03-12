From: pg_lxra@lxra.for.to.sabi.co.UK (Peter Grandi)
Subject: Re: LVM performance
Date: Wed, 12 Mar 2008 19:54:07 +0000
Message-ID: <18392.13535.918902.104947@tree.ty.sabi.co.uk>
References: <18389.41592.494811.875055@tree.ty.sabi.co.uk>
	<5e44228294f0aabe036fd15b051d2e57@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5e44228294f0aabe036fd15b051d2e57@localhost>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

[ ... poor dead horse of alignment  :-) ... ]

mike> Right now I have my trusty 4 DISK RAID-5 with a CHUNKSIZE
mike> of 256KB, thus having a stripe-size of 1MB.

A largish chunk size with a largish stripe size may not be a
particularly good idea for sequential IO, more for multithreaded
access or for random access perhaps.

mike> Version  1.03c      ------Sequential Output------ [ ... ]
mike>                     -Per Chr- --Block-- -Rewrite- [ ... ]
mike> Machine        Size K/sec %CP K/sec %CP K/sec %CP [ ... ]
mike> xfs              8G           49398  43 26252  21 [ ... ]
mike> lvm-chunkaligned 8G           45937  42 23711  24 [ ... ]
mike> lvm-stripealigne 8G           49271  43 24401  25 [ ... ]

mike> As you can see it apparently does make a difference if you
mike> stripe align or not, [ ... ]

But it should make a *much* bigger difference, and a 3+1 RAID5
should perform *a lot* better. As in 100-150MB/s (factor of 2-3
over a single disk) reading and (if aligned) writing.

Perhaps there is some problem with your IO subsystem (USB drives?
4 ATA drives attached to only 2 channels?  5-10 year old disks?).

BTW, Bonnie 1.03 or Bonnie++ or Iozone are not necessarily the
best way to check things, I recommend Bonnie 1.14 with the
options '-u -y -o_direct'.
