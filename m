From: Luke Rosenthal <luke@luko.org>
Subject: Re: I'm about ready to do SW-Raid5 - pointers needed
Date: Tue, 28 Oct 2003 16:37:03 +1100 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0310281610290.11061-100000@gw.luko.org>
References: <200310280255.51504.maarten@vbvb.nl>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200310280255.51504.maarten@vbvb.nl>
To: maarten van den Berg <maarten@vbvb.nl>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 28 Oct 2003, maarten van den Berg wrote:

> One of the cheapest "backup" mediums right now are harddisks themselves
> (weird, isn't it?) so it stands to reason some people try to build
> something that is foolproof (at least against hardware failure) using
> that, just disks.

Ok, most folks would argue that hard disk failure is a byproduct of them
being run continuously.  Especially in the case of IDE disks, which are
usually cheaper than their SCSI counterparts on a cost-per-MB ratio, but
consequently have a much shorter MTBF.

So here's my question - would it be possible to use a very large IDE disk
in a system purely for backups, eg one of those new 300GB behemoths - but
with one caveat - leave it "asleep".  Ie. leave it "spun down", and only
activate it once a day at backup time, run the backup, verify it, then
unmount it, and put it to sleep in a cron job.  Feasible?

I know there's the appropriate commands to do it, but are they risky?  If
a drive's not mounted, but powered off, it should present no problems or
lock up the OS, correct?

> > PS: did I tell you about the importance of backups? ;)
> 
> Yea. I think you did.   ;-)

Everyone's got a horror story.. :)  and most people learn from it :)

Luke.

