From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: [PATCH 03/18] md: occasionally checkpoint drive recovery to reduce
 duplicate effort after a crash
Date: Fri, 13 Feb 2009 11:20:24 -0500
Message-ID: <49959DC8.1000603@tmr.com>
References: <20090212031009.23983.14496.stgit@notabene.brown> <20090212031010.23983.74842.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090212031010.23983.74842.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

NeilBrown wrote:
> Version 1.x metadata has the ability to record the status of a
> partially completed drive recovery.
> However we only update that record on a clean shutdown.
> It would be nice to update it on unclean shutdowns too, particularly
> when using a bitmap that removes much to the 'sync' effort after an
> unclean shutdown.
>
> One complication with checkpointing recovery is that we only know
> where we are up to in terms of IO requests started, not which ones
> have completed.  And we need to know what has completed to record
> how much is recovered.  So occasionally pause the recovery until all
> submitted requests are completed, then update the record of where
> we are up to.
>
> When we have a bitmap, we already do that pause occasionally to keep
> the bitmap up-to-date.  So enhance that code to record the recovery
> offset and schedule a superblock update.
> And when there is no bitmap, just pause 16 times during the resync to
> do a checkpoint.
> '16' is a fairly arbitrary number.  But we don't really have any good
> way to judge how often is acceptable, and it seems like a reasonable
> number for now.
>   

Since the object of this code is to save time on shutdown and restart, 
16 has little relation to time. I would think that having this update on 
a time basis would more reasonably reflect this. I would like to see a 
fairly short time, say ten minutes, since the cost of a save is low, and 
ten minutes seems like a reasonable lower bound on "worth effort to 
save" recovery.

As arrays get larger even a 16th of the recovery time can be a pretty 
long time, particularly if the min recovery speed is set fairly low to 
avoid impact on a production server.

Thought for comment: I already move a lot of overhead to the 2-6am slot 
of low load, would changing the rebuild speeds during prime load be 
desirable? The con is longer degraded operation, the pro is less impact 
on performance.

-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


