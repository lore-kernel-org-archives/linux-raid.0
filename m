From: Chris Birkinshaw <chris@postbox.org.uk>
Subject: Moving drives around
Date: Wed, 7 Jul 2004 16:45:32 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <AE41CC0B-D02C-11D8-8EC3-000A959A30DC@postbox.org.uk>
Mime-Version: 1.0 (Apple Message framework v618)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



Hi,

I currently have a software RAID 5 setup using the master and slaves of 
each controller port, which I know is bad practice. I have got a new 
motherboard with built in RAID which gives me enough channels to sort 
this problem out, and also the ability to build a new much bigger RAID. 
After I have built the new RAID I want to transfer the contents of the 
old RAID onto it, then remove the disks of the old RAID and shift the 
disks of the new RAID around so they all have an IDE channel to 
themselves. At this stage though I would imagine that the disk names 
would change - e.g. hdh on the new RAID might become hdb after the old 
RAID is removed and the drives are moved.

What I wanted to know is if it matters to the RAID what the drives are 
called - e.g. if the first disk becomes named hdd rather than hda will 
the RAID have a problem? Does the RAID even care about the linux names 
for the drives?

Cheers,

Chris

