From: Gregory Leblanc <gleblanc@linuxweasel.com>
Subject: Re: RAID-6 support in kernel?
Date: 03 Jun 2002 10:33:24 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1023125615.1051.1283.camel@peecee>
References: <Pine.GSO.4.21.0206030213510.23709-100000@gecko.roadtoad.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.GSO.4.21.0206030213510.23709-100000@gecko.roadtoad.net>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 2002-06-03 at 02:25, Derek Vadala wrote:
        On Mon, 3 Jun 2002, Roy Sigurd Karlsbakk wrote:
        
        > It'll waste 9 drives, giving me a total capacity of 7n instead of 14n. 
        > And, by definition, RAID-6 _can_ withstand _any_ two-drive failure.
        
        This is certainly not true. 
        
        Combining N RAID-5 into a stripe wastes on N disks. 

Hot spares are quite a nice way to increase the reliability of your
arrays, somewhat.  You can still be in trouble if a second disk fails
before the resync finishes, but at that point you're probably talking
about something of a more catastrophic failure, perhaps outside of the
machine itself.  
        

        > With a 1500MHz Athlon on a typical file server where there's not much 
        > writes, the CPU is sitting there chrunching RC5-64 som 99,95 % of the 
        > time. I don't think it'll make much differnce with today's CPUs
        
        It's up to you to decide if the performance trade-off is worthwhile. I
        merely trying to point out that system with 2 RAID-5 is likely to incur
        the same CPU hit as a single RAID-6, implemented in the kernel. 

The issue isn't so much CPU load, but latency.  I'm too lazy to go read
a summary on RAID 6, but with RAID 5, blocks to be written as part of a
stripe often need to be read from the disk in order to generate the
parity.  Parity calculations are pretty trivial on modern CPUs, but disk
latency certainly isn't.  HTH,
	Greg

-- 
Portland, Oregon, USA.
Please don't copy me on replies to the list.

