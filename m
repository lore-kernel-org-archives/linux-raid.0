From: Brad Campbell <brad@wasp.net.au>
Subject: Re: making raid5 more robust against block errors
Date: Thu, 30 Mar 2006 11:27:13 +0400
Message-ID: <442B8851.6030409@wasp.net.au>
References: <Pine.LNX.4.62.0603300849110.30836@uplift.swm.pp.se> <17451.33928.930200.457912@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17451.33928.930200.457912@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Mikael Abrahamsson <swmike@swm.pp.se>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> On Thursday March 30, swmike@swm.pp.se wrote:
>> Is there any work going on to handle readerrors on a raid5 disk being 
>> handled by recreating the faulty block from the other disks and just 
>> rewriting the block, instead of kicking the disk out?
> 
> It's done. 2.6.15 I think, but definitely in 2.6.16.

And thanks to a dodgy drive, I can confirm it works for RAID-5 at least..

I wonder Neil, would it be possible to have a corrected error type message added somewhere to 
mdadm's monitor mode.. so you at least get an E-mail to let you know something dodgy happened and 
it's all good now, but perhaps you should take a periodic look at that drive to make sure it's not 
flaking out ?

Or have I just asked for another feature that's already there ?

I've been doing a cat `find /sys/block -name errors` periodically to make sure the counters are not 
incrementing.

Brad
-- 
"Human beings, who are almost unique in having the ability
to learn from the experience of others, are also remarkable
for their apparent disinclination to do so." -- Douglas Adams
