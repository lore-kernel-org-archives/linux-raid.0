From: AndyLiebman@aol.com
Subject: blockdev tuning
Date: Mon, 24 May 2004 20:33:55 EDT
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <6d.2a6fa829.2de3ee73@aol.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Question about tuning blockdev settings under Linux 2.6 kernel. 

3ware tech support (and white papers on their web site) suggest tuning linux 
blockdev settings to get better read speads on their hardware raid5. 3ware 
suggests using 'blockdev --setra 16384 /dev/sdX' (where sdX is the device 
corresponding to the hardware raid). 

My question is, might there be -- or is there -- an advantage to doing 
similar tuning for Linux software raid5? 

Today, I tried using the 3ware blockdev setting on my mdX device. Before 
tuning, I checked the default readahead value with 'blockdev --getra /dev/md1' and 
it returned a value of 1709 or 1907. Something kind of low. 

I tried using the 3ware suggested value for their hardware raid -- 16384. 
With Bonnie++, (on an 18GB read/write) my read throughput increased from about 
175 MB/sec to about 205MB/sec. 

Does anybody know if there's a logical way to go about tuning blockdev 
settings? And is it worth it? 

I can see a 10 percent increase in reading throughput -- and a 100 percent 
increase in the case of hardware raid5. But do these benchmark increases 
translate into real world improvements? 

Regards, 
Andy Liebman
