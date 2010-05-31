From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: Confused about reshape?
Date: Mon, 31 May 2010 00:25:17 -0500
Message-ID: <88.47.01646.B38430C4@cdptpa-omtalb.mail.rr.com>
References: <20100531145027.73d85ffe@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100531145027.73d85ffe@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: 'Neil Brown' <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> > 	I'm a little fuzzy on how the number of member disks can be
> > maintained while adding additional redundancy.  Must the file system(s)
> be
> > shrunk so that the total amount of free space on all the members is
> greater
> > than the member size?  In my situation, that won't work.  First of all,
> I am
> > using XFS, and I don't think XFS will allow shrinking of the file
> system.
> > In any case, however, the file system, which fills the entire array
> which in
> > turn uses the entire (unpartitioned) space of each member, is over 93%
> full.
> > It's an 8 x 1.5T disk RAID5 array with one spare drive.  Or does the --
> grow
> > command automatically create a RAID6 array with one missing member?
> Should
> > I remove the spare before issuing the command?  If so, should I add it
> along
> > with the command, something like:
> >
> > mdadm --grow /dev/md0 --level6 --raid-disk=9 --add /dev/sdi
> >
> > Or will mdadm automagically write the additional information to the 9th
> > spare / member disk without me doing anything?
> 
> I didn't say that the number of "member disks" is preserved, but the
> number
> of "data disks".
> Normally you would have a RAID5 with a spare when you convert to RAID6 so
> the
> spare gets incorporated.  This is the most efficient approach.
> But if you don't have a spare it will still work.

	Ah!  I see.

> Just tell mdadm what you want and it will do it, or report that it cannot.

	Apriori, I'm always a bit shy of issuing potentially "lethal"
commands.  Too many times, I've accidentally told a copmuter to
irretrievably do something other than what I had intended.  Indeed, only
last week I accidentally issued a command which wiped the files I meant to
move.  Nonetheless, you've done a great job of "goof-proofing" mdadm.
Still, when playing with 10T of data, I'm a bit skittish.  :-)

