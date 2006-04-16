From: Neil Brown <neilb@suse.de>
Subject: Re: help wanted - 6-disk raid5 borked: _ _ U U U U
Date: Mon, 17 Apr 2006 09:30:32 +1000
Message-ID: <17474.54168.331725.412456@cse.unsw.edu.au>
References: <62b0912f0604161419udee8ff2tf0861bc2f6e8e304@mail.gmail.com>
	<17474.51121.178492.61143@cse.unsw.edu.au>
	<62b0912f0604161617k31eedfaev8778b299e4a65b4b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Molle Bestefich on Monday April 17
Sender: linux-raid-owner@vger.kernel.org
To: Molle Bestefich <molle.bestefich@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday April 17, molle.bestefich@gmail.com wrote:
> Neil Brown wrote:
> > You shouldn't need to upgrade kernel
> 
> Ok.
> I had a crazy idea that 2 devices down in a RAID5 was an MD bug.
> 
> I didn't expect MD to kick that last disk - I would have thought that
> it would just pass on the read error in that situation.  If you've got
> the time to explain I'd like to be wiser - why not?

The easiest thing to do when you get an error on a drive is to kick
the drive from the array, so that is what the code always did, and
still does in many cases.
It is arguable that for a read error on a degraded raid5, that may not
be the best thing to do, but I'm not completely convinced.  A read
error will mean that a write to the same stripe will have to fail, so
at the very least we would want to switch the array read-only.

So as you see, finding the 'correct' way to handle a read on a
degraded raid5 is no straight forward.  For now it just kill the
array, and mdadm can put it back together for you if you really think
it should (as you do on this case).

NeilBrown
