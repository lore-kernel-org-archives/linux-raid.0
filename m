From: hpa@zytor.com (H. Peter Anvin)
Subject: Re: Call for RAID-6 users
Date: Thu, 5 Aug 2004 23:46:14 +0000 (UTC)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <ceugs6$rb3$1@terminus.zytor.com>
References: <cds76e$ee7$1@terminus.zytor.com> <200407302311.04942.maarten@ultratux.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Followup to:  <200407302311.04942.maarten@ultratux.net>
By author:    maarten van den Berg <maarten@ultratux.net>
In newsgroup: linux.dev.raid
> 
> I'm still early in the testing phase, so nothing to report as yet.  
> But I have a question:  I tried to reproduce a reported issue when creating a 
> degraded raid6 array.  But when I created a raid6 array with one disk 
> missing, /proc/mdstat reported no resync going on.  Am I not correct in 
> assuming that raid6 with 1 missing drive should at least start resyncing the 
> other drive(s) ?  It would only be really degraded with two missing drives...
> 

This is correct; when an array is first created it needs resync, and
with less than two drives missing this should happen.

> So instead, I defined a full raid6 array which it is now resyncing...
> My resync speed is rather slow (6000K/sec). I'll have to compare it to 
> resyncing a raid5 array though before concluding anything from that.  Cause 
> this system is somewhat CPU challenged indeed: a lowly celeron 500.

The RAID-6 computations on that system will be quite slow indeed.  At
least you have MMX.

	-hpa
