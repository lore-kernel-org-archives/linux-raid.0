From: Dan Stromberg <strombrg@dcs.nac.uci.edu>
Subject: Re: number of global spares?
Date: Fri, 26 Aug 2005 22:33:30 -0700
Message-ID: <1125120811.1055.16.camel@seki.nac.uci.edu>
References: <1125082848.25483.23.camel@seki.nac.uci.edu>
	 <200508262321.j7QNLuE03756@www.watkins-home.com>
	 <87u0hc55zn.fsf@rimspace.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87u0hc55zn.fsf@rimspace.net>
Sender: linux-raid-owner@vger.kernel.org
To: Daniel Pittman <daniel@rimspace.net>
Cc: linux-raid@vger.kernel.org, strombrg@dcs.nac.uci.edu
List-Id: linux-raid.ids

On Sat, 2005-08-27 at 15:00 +1000, Daniel Pittman wrote:
> "Guy" <bugzilla@watkins-home.com> writes:
> 
> [...]
> 
> >> I've been working on a RAID setup with dual RAID controllers and
> >> three expansion boxes - 48 disks in all, including data, parity and
> >> global spares.
> 
> [...]
> 
> >> They don't feel that the storage has to be blazing fast, and 100% uptime
> >> isn't paramount, however they very much do not want to lose their data.
> >> 
> >> The filesystem will not be backed up - we simply don't have anything large
> >> enough to back it up -to-, so if the some part of the storage solution
> >> goes kerflooey, we're totally...  er...  out of luck, and they'll probably
> >> be looking at me (the primary sysadmin on the storage configuration),
> >> wondering why their data is gone.
> >
> > RAID5, 6 or 1 is not data backup!  It is hardware redundancy!!
> > Data loss or corruption can still occur with a RAID solution.  RAID won't
> > help if someone fat fingers a "rm" command.
> > Corruption of the filesystem can also cause major data loss, without a
> > failed disk.
> >
> > If the data was lost, what would it cost to re-create it?
> > Enough to buy a backup system?
> 
> I absolutely agree with this.  When - and it is when, not if - the
> content of this filesystem goes away, you will be rightly blamed for it.
> 
> Invest the few thousand dollars in a good high capacity tape drive and
> pay someone to change the tapes.  This will be worth it when the system
> finally does fail in some nasty, unpredictable way!

I was on paternity leave when the solution was selected, but the guy
with the grant money has been disinterested in backups from the
beginning.

The policy is going to be "your homedir will be backed up.  Your files
under /data will not, unless you back them up yourself."

My job is to work within that restriction, and possibly advise for
backups, but nothing more.  The purchasing decision is not mine.


