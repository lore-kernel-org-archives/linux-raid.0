From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Has anyone compared SWRAID for (JBOD@HW-RAID) vs. (Regular Sata
 PCI-e cards)?
Date: Sat, 10 May 2008 05:23:14 -0400 (EDT)
Message-ID: <alpine.DEB.1.10.0805100520200.22366@p34.internal.lan>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I was curious if you have for example 5 PCI-e x8 slots:

1. 2x sata port card
2. 2x sata port card
3. 2x sata port card
4. 2x sata port card
5. 2x sata port card

Would that be faster than:

1. 16port 3ware (or) 16port areca
    drives -> jbod

Does anyone here use SW RAID on the second configuration with 10,000 rpm 
drives or more than ~10 drives in a RAID5?  If so what kind of read/write 
speed do you achieve?  I am curious if a single card with that many ports, 
even running jbod can really push the bandwidth you achieve by splitting 
the drives up over multiple PCI-e slots as shown in the first example.

Justin.
