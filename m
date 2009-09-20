From: Matthias Urlichs <matthias@urlichs.de>
Subject: Re: RAID 16?
Date: Sun, 20 Sep 2009 19:44:00 +0000 (UTC)
Message-ID: <h960lv$n8p$7@ger.gmane.org>
References: <43E19FAB.4000603@cogweb.net>
	<Pine.LNX.4.44.0602022119380.12829-100000@firewall2.tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 02 Feb 2006 21:32:44 -0500, Bill Davidsen wrote:

>> Would this work? Would it be better than RAID 15? We're looking for a
>> very high redundancy system.
> 
> You only get the size of two drives with that! I think you would get the
> same reliability and better performance with four RAID-1 mirror arrays
> and RAID-5 over that. You still have to lose four drives to lose data,
> but you get the size of three instead of two.

But in his case, the loss of any four disks is not a problem.

Personally, in this case I'd build a simple RAID6 with two spares. You 
can lose four disks (just not at the same time :-P ) and you still have 
four disks' capacity.

Of course, if you're worried about controller failure, a RAID1 built from 
two RAID6 (one on each controller) is your only high-reliability option.

-- 

