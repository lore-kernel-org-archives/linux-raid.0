From: Molle Bestefich <molle.bestefich@gmail.com>
Subject: Re: Spare disk could not sleep / standby
Date: Tue, 8 Mar 2005 06:46:32 +0100
Message-ID: <62b0912f05030721465e84e4da@mail.gmail.com>
References: <422D327D.11718.F8DB3@localhost>
	 <200503080414.j284EG510309@www.watkins-home.com>
	 <16941.11443.107607.735855@cse.unsw.edu.au>
	 <62b0912f0503072120776e0b56@mail.gmail.com>
	 <16941.14813.465306.72004@cse.unsw.edu.au>
Reply-To: Molle Bestefich <molle.bestefich@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
In-Reply-To: <16941.14813.465306.72004@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> Then after 20ms with no write, they are all marked 'clean'.
> Then before the next write they are all marked 'active'.
> 
> As the event count needs to be updated every time the superblock is
> modified, the event count will be updated forever active->clean or
> clean->active transition.

So..  Sorry if I'm a bit slow here.. But what you're saying is:

The kernel marks the partition clean when all writes have expired to disk.
This change is propagated through MD, and when it is, it causes the
event counter to rise, thus causing a write, thus marking the
superblock active.  20 msecs later, the same scenario repeats itself.

Is my perception of the situation correct?

Seems like a design flaw to me, but then again, I'm biased towards
hating this behaviour since I really like being able to put inactive
RAIDs to sleep..
