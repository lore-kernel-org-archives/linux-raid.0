From: Pallai Roland <dap@mail.index.hu>
Subject: Re: [PATCH] proactive raid5 disk replacement for 2.6.11, updated
Date: Fri, 19 Aug 2005 16:58:31 +0200
Message-ID: <1124463511.21362.211.camel@localhost.localdomain>
References: <1124322731.3810.77.camel@localhost.localdomain>
	 <17156.7305.638579.812295@cse.unsw.edu.au>
	 <1124372804.21362.92.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1124372804.21362.92.camel@localhost.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Neil Brown <neilb@cse.unsw.edu.au>
List-Id: linux-raid.ids


On Thu, 2005-08-18 at 15:46 +0200, Pallai Roland wrote:
> On Thu, 2005-08-18 at 15:28 +1000, Neil Brown wrote:
> > If we want to mirror a single drive in a raid5 array, I would really
> > like to do that using the raid1 personality.
> > [...]
>  the current hack allows too, but using the raid1 personality would be a
> clear solution, I agree. although, I have some doubt.. very simple task
> to mirror a drive (some lines of code in raid5.c in this master-slave
> method), but if we call raid1 into the game, the situation goes more
> difficult:
>  - we should transfer the badblock cache at the building of raid1
>  - the raid1.c should be hacked to make requests for data if the sync
> has stopped due to read error and the parent is a raid5 array

 It's harder than I though first, we must know a lot about the raid5
array (parity algorithm, position of the parity disk in that chunk, etc)
to rebuild an arbitary block of a disk if we have only the full stripe
data by make_request. a very ugly hack if I put it all into the raid1.c,
but if I don't, then a special callback is needed from raid1 to raid5
what asks the rebuilding of n-th chunk of a disk, and I don't know how
could I do it nicely.. maybe should I make a generic ioctl for this?
(what's less ugly, but ugly, too)

 in this minute, I can't believe that raid1 should be used for proactive
rebuilding.. it's too complex and no real advantage exclusive of
theory.. Neil, give me a hint please if you've see a good solution


 otherwise, I've done with a userspace error handler what's called when
a disk seems like failed (steps over badblock threshold) and that
handles the situation instead of error(). using a userspace error
handler was a good idea, thanks for this. that can make a decision (by
calling mdadm) based on SMART values or whatever:
 a., fail the drive and do nothing, the array becomes degraded
 b., fail the drive, add a spare, rebuild on the classic way
 c., don't fail the drive, add a spare and start proactive rebuilding
 d., don't fail the drive, schelude userspace badblock rewriting, raise
the badblock tolerance and everything goes on
 e., anything what you want..

 I'll release the patch with some new features (eg. userspace badblock
rewriter) after I cleaning up the code a little


-- 
 dap

