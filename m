From: Robert L Mathews <lists@tigertech.com>
Subject: Re: Use RAID-6!
Date: Tue, 16 Apr 2013 22:22:48 -0700
Message-ID: <516E31A8.9030607@tigertech.com>
References: <15345091.8.1366130671716.JavaMail.root@zimbra> <516DABF2.5050409@tigertech.com> <516DAF21.5040409@aei.mpg.de> <516DD433.50100@tigertech.com> <20130417102052.20c40887@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130417102052.20c40887@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 4/16/13 9:20 PM, Roman Mamedov wrote:

> You do know there is no "voting" system in md, right?

Yes, but the question was "What do you do if you do a through check and
both drives claim a data block is valid and intact, but data differs?"
The implication was that the array has failed and you need to manually
reconstruct data, perhaps sector-by-sector.

Having three sources for a manual reconstruction outside of md reduces
the "someone with two clocks never knows what time it is" problem. With
three, you can make an informed guess about which one is wrong.

I'm not saying that this is the primary reason to use three disks in
RAID 1, because it's not. I've never needed to do sector-level recovery
of an array. The primary reason is so that you can withstand two
simultaneous disk failures, just as with RAID 6 vs. RAID 5.


> In general, you seem to be WAY too concerned about losing your RAID array;
> this sounds like you are someone who doesn't make backups and tries to use
> RAID as a replacement for them.

No, that's definitely not the case. We have backup systems in multiple
data centers, and our disaster recovery planning includes plane crashes
that destroy live servers and so on.

Many businesses require 100% availability. Losing an array on a server
means downtime and telling paying customers "we lost the new data you
stored since the last backup". Neither is acceptable if it's in any way
avoidable, even if the last backup was minutes ago. Like you, I can
easily recover from losing a couple of hours work, but my customers who
run online stores are less sanguine about such things.

By the way, I think I'm going to pin "you seem to be WAY too concerned
about losing your RAID array" up on my wall. That's wonderful, because
it's exactly how concerned I want to be.  ;-)

-- 
Robert L Mathews, Tiger Technologies, http://www.tigertech.net/

