From: Mark Hahn <hahn@physics.mcmaster.ca>
Subject: RE: Good news / bad news - The joys of RAID
Date: Sun, 21 Nov 2004 16:58:04 -0500 (EST)
Message-ID: <Pine.LNX.4.44.0411211632510.19120-100000@coffee.psychology.mcmaster.ca>
References: <03c101c4d011$09b9a7c0$030a0a0a@musicroom>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <03c101c4d011$09b9a7c0$030a0a0a@musicroom>
Sender: linux-raid-owner@vger.kernel.org
To: Mark Klarzynski <mark.k@computer-design.co.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> practice and simple to achieve.  It is not achievable on sata..  I have

Linux certainly appears to be able to reset both pata and sata;
perhaps the drivers are just lying.

> are not stupid... sata solutions are probably 30% of the cost of the
> scsi..... there is a difference and we know it. the important thing is
> accepting the difference and using the right technology for the right
> application. 

sure.  it's basically only extremely high-end DBs (which require 
150 IOPS per disk, 24/7) that need SCSI/FC.  anyone designing
a storage system needs to actually profile their IO to see whether 
their workload actually falls into this very tiny niche.  do your 
seeks scale down as ndisks increases?  do you need bandwidth (which
is almost trivial to obtain with more disks)?  do you need reliability
(which is easy to achieve with raid)?  does your IO drop to near zero
once you run it through a battery-backed cache of a few GB?

the take-home message is that you need to actually find out whether
your workload requires that you pay the huge premium for SCSI/FC 
infrastructure ("enterprise-class storage").  almost none do, seriously.

