From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Spare disk could not sleep / standby
Date: Tue, 8 Mar 2005 17:03:35 +1100
Message-ID: <16941.16439.595486.231598@cse.unsw.edu.au>
References: <422D327D.11718.F8DB3@localhost>
	<200503080414.j284EG510309@www.watkins-home.com>
	<16941.11443.107607.735855@cse.unsw.edu.au>
	<62b0912f0503072120776e0b56@mail.gmail.com>
	<16941.14813.465306.72004@cse.unsw.edu.au>
	<62b0912f05030721465e84e4da@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
In-Reply-To: message from Molle Bestefich on Tuesday March 8
Sender: linux-raid-owner@vger.kernel.org
To: Molle Bestefich <molle.bestefich@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday March 8, molle.bestefich@gmail.com wrote:
> Neil Brown wrote:
> > Then after 20ms with no write, they are all marked 'clean'.
> > Then before the next write they are all marked 'active'.
> > 
> > As the event count needs to be updated every time the superblock is
> > modified, the event count will be updated forever active->clean or
> > clean->active transition.
> 
> So..  Sorry if I'm a bit slow here.. But what you're saying is:
> 
> The kernel marks the partition clean when all writes have expired to disk.
> This change is propagated through MD, and when it is, it causes the
> event counter to rise, thus causing a write, thus marking the
> superblock active.  20 msecs later, the same scenario repeats itself.
> 
> Is my perception of the situation correct?

No.  Writing the superblock does not cause the array to be marked
active.
If the array is idle, the individual drives will be idle.


> 
> Seems like a design flaw to me, but then again, I'm biased towards
> hating this behaviour since I really like being able to put inactive
> RAIDs to sleep..

Hmmm... maybe I misunderstood your problem.  I thought you were just
talking about a spare not being idle when you thought it should be.
Are you saying that your whole array is idle, but still seeing writes?
That would have to be something non-md-specific I think.

NeilBrown

> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
