From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: RAID5 attempt rebuilding despite being incomplete
Date: Fri, 24 Jun 2005 11:40:55 +1000
Message-ID: <17083.25767.665831.24231@cse.unsw.edu.au>
References: <42BA9D87.B6808FFC@ardistech.com>
	<17082.46466.985928.971926@cse.unsw.edu.au>
	<42BABCDD.F4D0191E@ardistech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from bart@ardistech.com on Thursday June 23
Sender: linux-raid-owner@vger.kernel.org
To: bart@ardistech.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday June 23, bart@ardistech.com wrote:
> Hi Neil,
> 
> > > I have the problem that my RAID5 (created with 4 drives) array is resyning
> > > despite the fact I removed one drive. Any Idea what it is doing?
> > 
> > Sound's familar.  Thought I had fixed it.  What kernel are you
> > running?
> > 
> I'm running on a 2.6.11 kernel, it should be pretty up to date.

I cannot find the patch I was thinking of to check when it went in,
but I have just tested various failure scenarios on 2.6.12-rc3-mm3 and
it handles them all properly.

If you could try 2.6.12 and confirm, I would appreciate it.


> 
> I forgot to mention that it only occurs if the drive is removed from the
> RAID5 set before it is 'synced' for the first time.
> 
> Could it be the mddev->curr_resync or mddev->recovery_cp are handled wrong
> in this case? I saw the prints:
> 
> ..
> Jun 23 12:26:10 172 kernel: md: checkpointing recovery of md3.
> ..
> Jun 23 12:26:15 172 kernel: md: resuming recovery of md3 from checkpoint.
> ..
> 
> in the error situation, while there is no state to recover at all at that
> point (the array is incomplete/degraded).

Yes, that shouldn't happen if there is an error, and it doesn't for
me.


I noticed that the raid5 was resyncing rather than recovering.
Normally when you create a raid5 with mdadm it will recover as this is
faster than resync.  Did you create the array with '-f' ??

NeilBrown
