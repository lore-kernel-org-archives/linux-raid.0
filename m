From: maarten van den Berg <maarten@ultratux.net>
Subject: Re: Call for RAID-6 users
Date: Fri, 30 Jul 2004 23:11:04 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200407302311.04942.maarten@ultratux.net>
References: <cds76e$ee7$1@terminus.zytor.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cds76e$ee7$1@terminus.zytor.com>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Saturday 24 July 2004 01:32, H. Peter Anvin wrote:
> I'm considering removing the "experimental" label from RAID-6.  It
> appears at this point to be just as stable as RAID-5 (since it's based
> on RAID-5 code that's obviously all that can be expected.)

This encouraged me to try it today...

> Thus, if you have used RAID-6 and have good or bad experiences, I'd
> like to know them as soon as possible.

I'm still early in the testing phase, so nothing to report as yet.  
But I have a question:  I tried to reproduce a reported issue when creating a 
degraded raid6 array.  But when I created a raid6 array with one disk 
missing, /proc/mdstat reported no resync going on.  Am I not correct in 
assuming that raid6 with 1 missing drive should at least start resyncing the 
other drive(s) ?  It would only be really degraded with two missing drives...

So instead, I defined a full raid6 array which it is now resyncing...
My resync speed is rather slow (6000K/sec). I'll have to compare it to 
resyncing a raid5 array though before concluding anything from that.  Cause 
this system is somewhat CPU challenged indeed: a lowly celeron 500.

I will try to run some script(s) provided on this list to see if I can 
reproduce anything.

System info:

SuSE 9.1 from DVD media, 
	(with all updates installed _PRIOR_ to creating the array)
Kernel 2.6.5-7.95
mdadm - v1.5.0 - 22 Jan 2004

Harddisks and/or controllers:
one 160 GB ATA off the onboard controller (hda)
two 160GB SATA off a promise 150TX2 (as sda and sdb)
two 160 GB SATA off a SiI 3112 controller (as hde and hdg)

Maarten

-- 
When I answered where I wanted to go today, they just hung up -- Unknown

