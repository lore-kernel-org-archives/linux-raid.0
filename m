From: AndyLiebman@aol.com
Subject: RE: Serial ATA Cards
Date: Tue, 4 May 2004 18:23:08 EDT
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <98.9f31412.2dc971cc@aol.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Got the 3ware card working. Simple as running 'modprobe 3w-xxxx' and then all 
the drives show up as SCSI devices. Works about the same as the Silicon Image 
ports on my motherboard. Getting around 175 MB/sec Software RAID 5 on 8 
drives according to Bonnie++.  Around 2x the speed of the 3ware "Hardware RAID 5" 
(also measured with Bonnie ++). 

But... I'd sure like to use that new Promise card instead. Half the price. 
133 Mhz instead of 66. No extra RAID hardware that I don't need. 

So, does anybody know how to use 'mknod' to create a home for the SATA 
drives? Apparently the drives won't show up as either SCSI or IDE drives under the 
new Promise driver that's included in the 2.6.5+ kernel. They need to have 
devices created for them. I know that the "major number" is supposed to be 160. 
But I have no idea how to find out what the "minor numbers" are supposed to be. 
I'm kind of in the dark here. 

Hopefully Promise will send me an installation script that will reveal what 
to do. But just in case, if anyone knows how to proceed I would appreciate some 
hints. 

Thanks 

Andy Liebman
