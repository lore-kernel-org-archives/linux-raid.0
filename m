From: maarten van den Berg <maarten@ultratux.net>
Subject: Re: Call for RAID-6 users
Date: Fri, 30 Jul 2004 23:38:33 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200407302338.33823.maarten@ultratux.net>
References: <cds76e$ee7$1@terminus.zytor.com> <200407302311.04942.maarten@ultratux.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200407302311.04942.maarten@ultratux.net>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday 30 July 2004 23:11, maarten van den Berg wrote:
> On Saturday 24 July 2004 01:32, H. Peter Anvin wrote:

> I'm still early in the testing phase, so nothing to report as yet.
> But I have a question:  I tried to reproduce a reported issue when creating
> a degraded raid6 array.  But when I created a raid6 array with one disk
> missing, /proc/mdstat reported no resync going on.  Am I not correct in
> assuming that raid6 with 1 missing drive should at least start resyncing
> the other drive(s) ?  It would only be really degraded with two missing
> drives...
>
> So instead, I defined a full raid6 array which it is now resyncing...
> My resync speed is rather slow (6000K/sec). I'll have to compare it to
> resyncing a raid5 array though before concluding anything from that.  Cause
> this system is somewhat CPU challenged indeed: a lowly celeron 500.

To confirm, after stopping the raid6 array (didn't want to wait this long) I 
created a raid5 array on the same machine and it resyncs at 14000K/sec.
Is this expected behaviour, the 6M/sec for raid6 vs 14M/sec for raid5 ?
I suppose raid6 has to sync two drives, which would maybe explain the speed 
difference(?)   In any case, hdparm -tT report 50M/sec on each single drive. 
Is this discrepancy in speed normal ?
(yes yes, I played with the /proc/sys/dev/raid/ speed settings (to no avail))

Maarten

-- 
When I answered where I wanted to go today, they just hung up -- Unknown

