From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Spare disk could not sleep / standby
Date: Tue, 8 Mar 2005 16:36:29 +1100
Message-ID: <16941.14813.465306.72004@cse.unsw.edu.au>
References: <422D327D.11718.F8DB3@localhost>
	<200503080414.j284EG510309@www.watkins-home.com>
	<16941.11443.107607.735855@cse.unsw.edu.au>
	<62b0912f0503072120776e0b56@mail.gmail.com>
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
> > It is writes, but don't be scared.  It is just super-block updates.
> > 
> > In 2.6, the superblock is marked 'clean' whenever there is a period of
> > about 20ms of no write activity.  This increases the chance on a
> > resync won't be needed after a crash.
> > (unfortunately) the superblocks on the spares need to be updated too.
> 
> Ack, one of the cool things that a linux md array can do that others
> can't is imho that the disks can spin down when inactive.  Granted,
> it's mostly for home users who want their desktop RAID to be quiet
> when it's not in use, and their basement multi-terabyte facility to
> use a minimum of power when idling, but anyway.
> 
> Is there any particular reason to update the superblocks every 20
> msecs when they're already marked clean?


It doesn't (well, shouldn't and I don't think it does).
Before the first write, they are all marked 'active'.
Then after 20ms with no write, they are all marked 'clean'.
Then before the next write they are all marked 'active'.

As the event count needs to be updated every time the superblock is
modified, the event count will be updated forever active->clean or
clean->active transition.  All the drives in an array must have the
same value for the event count, so the spares need to be updated even
though they, themselves, aren't exactly 'active' or 'clean'.

NeilBrown
