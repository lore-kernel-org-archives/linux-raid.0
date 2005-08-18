From: Pallai Roland <dap@mail.index.hu>
Subject: Re: [PATCH] proactive raid5 disk replacement for 2.6.11, updated
Date: Thu, 18 Aug 2005 15:46:44 +0200
Message-ID: <1124372804.21362.92.camel@localhost.localdomain>
References: <1124322731.3810.77.camel@localhost.localdomain>
	 <17156.7305.638579.812295@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17156.7305.638579.812295@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On Thu, 2005-08-18 at 15:28 +1000, Neil Brown wrote:
> However I think I would like to do it a little bit differently.
 thanks for your reply, interesting ideas!

> If we want to mirror a single drive in a raid5 array, I would really
> like to do that using the raid1 personality.
> e.g.
>    suspend io
>    remove the drive
>    build a raid1 (with no superblock) using the drive.
>    add that back into the array
>    resume io.
> 
> Then another drive can be added to the raid1 and synced.
> 
> This allows shuffling of drives even when they haven't actually
> failed.
 the current hack allows too, but using the raid1 personality would be a
clear solution, I agree. although, I have some doubt.. very simple task
to mirror a drive (some lines of code in raid5.c in this master-slave
method), but if we call raid1 into the game, the situation goes more
difficult:
 - we should transfer the badblock cache at the building of raid1
 - the raid1.c should be hacked to make requests for data if the sync
has stopped due to read error and the parent is a raid5 array
 - many steps needed to make the change, error handling become more complex

 anyway, I try to change my patch to use raid1 personality on this
weekend

> To handle read failures, I would like the first step to be to re-write
> the failed block.  I believe most (all?) drives will relocate the
> block if a write cannot succeed at the normal location, so this will
> often fix the problem.  
 I think it's an easy task, the question is, how can we check if
we have a point to do that. I mean, if we rewrote a bad stripe but
there's no auto reallocation or the drive is already using all of the spare
sectors our write will success due to drives cache but every time when
we reread it we will got back a bad sector and the rewrite over and
over is become pointless..
 currently, with my hack, a userspace program can issue a read-write
cycle based on bad sector list in /proc/mdstat and we can hope that
solves the problem. may be an another solution a table with recently
rewritten blocks, if something has appear too often, we put it on a
'total failed' list and never be touched again.. but I'm not sure that
the latest is better.. with badblock tolerance the 'timed rewrite from
userspace' sounds like a good solution, IMHO

> This possible doesn't handle the possibility of a write failing very
> well, but I'm not sure what your approach does in that case.  Could
> you explain that?
 I also can't do anything with that, if a write fails, the drive'll be
marked failed, immediately



-- 
 dap

