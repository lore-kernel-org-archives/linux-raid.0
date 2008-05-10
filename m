From: Jeff Garzik <jeff@garzik.org>
Subject: Re: Has anyone compared SWRAID for (JBOD@HW-RAID) vs. (Regular Sata
 PCI-e cards)?
Date: Sat, 10 May 2008 13:14:02 -0400
Message-ID: <4825D7DA.2050608@garzik.org>
References: <181601c8b2a7$12fe0489$5209f40a@exchange.rackspace.com> <alpine.DEB.1.10.0805101014200.1844@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0805101014200.1844@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: David Lethe <david@santools.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Justin Piszcz wrote:
> .. What I meant was is JBOD using a single card with 16 ports faster than
> using JBOD with multiple PCI-e SATA cards?

JBOD on a HW RAID card is really wasting it's primary purpose, 
offloading RAID processing from the CPU, and consolidating large 
transactions.

Using HW RAID-1 means that, for example, _one_ copy of a 4k write to a 
RAID-1 device goes the card, which performs data replication to each 
device.  In SW RAID's case, $N copies cross the PCI bus, one copy for 
each device in the RAID-1 mirror.

In HW RAID-5, one 4k write can go to the card, which then performs the 
parity calculation and data replication.  In SW RAID-5, the parity 
calculation occurs on the host CPU, and $N copies go across the PCI bus.

Running HW RAID in JBOD mode eliminates all the efficiencies of HW RAID 
just listed.  You might as well run normal SATA at that point, because 
you gain additional flexibility and faster performance.

But unless you are maxing out PCI bus bandwidth -- highly unlikely for 
PCI Express unless you have 16 SSDs or so -- you likely won't even 
notice SW RAID's additional PCI bus use.


And of course, there are plenty of other factors to consider.  I wrote a 
bit on this topic at http://linux.yyz.us/why-software-raid.html

	Jeff


