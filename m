From: "David Lethe" <david@santools.com>
Subject: Re: Has anyone compared SWRAID for (JBOD@HW-RAID) vs. (Regular Sata PCI-e cards)?
Date: Sat, 10 May 2008 9:06:00 -0500
Message-ID: <181601c8b2a7$12fe0489$5209f40a@exchange.rackspace.com>
Reply-To: <David@santools.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

You can't generalize whether HW RAID is faster or slower than SW RAID.
I/O mix, CPU speed, bus type, RAM, file system type/config, queue depth, specific RAID card, drivers, firmware all have significant impact. Even with info you supply, one can easily model config where either RAID architecture will outperform the other. 

if performance is vital for you on a certain pc config, then tune everything for HW RAID, test, rebuild for SW RAID, and compare.  Don't forget to yank power to a disk while testing both to see how each work under stress, as well as when consistency checks run.

-----Original Message-----

From:  "Justin Piszcz" <jpiszcz@lucidpixels.com>
Subj:  Has anyone compared SWRAID for (JBOD@HW-RAID) vs. (Regular Sata PCI-e cards)?
Date:  Sat May 10, 2008 4:23 am
Size:  844 bytes
To:  "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>

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
-- 
To unsubscribe from this list: send the line "unsubscribe linux-raid" in 
the body of a message to majordomo@vger.kernel.org 
More majordomo info at  http://vger.kernel.org/majordomo-info.html 
 


