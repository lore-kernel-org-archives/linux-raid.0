From: "bart@ardistech.com" <bart@ardistech.com>
Subject: Re: RAID5 attempt rebuilding despite being incomplete
Date: Thu, 23 Jun 2005 15:45:01 +0200
Message-ID: <42BABCDD.F4D0191E@ardistech.com>
References: <42BA9D87.B6808FFC@ardistech.com> <17082.46466.985928.971926@cse.unsw.edu.au>
Reply-To: bart@ardistech.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,

> > I have the problem that my RAID5 (created with 4 drives) array is resyning
> > despite the fact I removed one drive. Any Idea what it is doing?
> 
> Sound's familar.  Thought I had fixed it.  What kernel are you
> running?
> 
I'm running on a 2.6.11 kernel, it should be pretty up to date.

I forgot to mention that it only occurs if the drive is removed from the
RAID5 set before it is 'synced' for the first time.

Could it be the mddev->curr_resync or mddev->recovery_cp are handled wrong
in this case? I saw the prints:

..
Jun 23 12:26:10 172 kernel: md: checkpointing recovery of md3.
..
Jun 23 12:26:15 172 kernel: md: resuming recovery of md3 from checkpoint.
..

in the error situation, while there is no state to recover at all at that
point (the array is incomplete/degraded).

Cheers,
	Bart
