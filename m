From: Brian Pontius <linuxboy123@mindspring.com>
Subject: Re: Md cache?
Date: Thu, 3 Jun 2004 14:13:48 -0400 (GMT-04:00)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <27086862.1086286428997.JavaMail.root@wamui09.slb.atl.earthlink.net>
Reply-To: Brian Pontius <linuxboy123@mindspring.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I apologze for being unclear.

As I did comparisons between software and hardware raid,  one of the advantage
s that I noticed with hardware raid was cache (both read and write). With hard
ware it is usually larger giving some increase in performance.  I was looking
for a way to allocate more system memory specifically to be the md cache area
to give that extra feature of that hardware raid. This would especially be ben
efitial for a NAS that has a dedicated purpose to fast reliable storage.


Thanks for your time.
Brian Pontius


-----Original Message-----
From: Neil Brown <neilb@cse.unsw.edu.au>
Sent: Jun 2, 2004 10:10 PM
To: Brian Pontius <linuxboy123@mindspring.com>
Cc: linux-raid@vger.kernel.org
Subject: Re: Md cache?

On Wednesday June 2, linuxboy123@mindspring.com wrote:
> to all,
> 
> Is anyone aware of a way to cause the md devices to use some system memory as a write cache? (maybe through mdadm?).  I have looked everywhere and cannot seem to find anything about such a feature.
> 
> If not, anyone  know if this is a possibility for the future, Neil?

What is it exactly that you want.

All device IO is cached in memory before being written to the device.
The only real value of a cache with a RAID array is if it we a
non-volatile cache.  Is that what you were thinking of.

NeilBrown

