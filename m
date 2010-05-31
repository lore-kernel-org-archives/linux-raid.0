From: Neil Brown <neilb@suse.de>
Subject: Re: Confused about reshape?
Date: Mon, 31 May 2010 14:50:27 +1000
Message-ID: <20100531145027.73d85ffe@notabene.brown>
References: <20100531125454.5e676440@notabene.brown>
	<84.8B.02347.4E6330C4@cdptpa-omtalb.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <84.8B.02347.4E6330C4@cdptpa-omtalb.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Leslie Rhorer <lrhorer@satx.rr.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 30 May 2010 23:11:17 -0500
"Leslie Rhorer" <lrhorer@satx.rr.com> wrote:

> > On Sun, 30 May 2010 18:29:16 -0500
> > "Leslie Rhorer" <lrhorer@satx.rr.com> wrote:
> > 
> > >
> > > 	Am I confused about reshaping a RAID5 to RAID6 array, or is there an
> > > error in the man page?  The distro I have on one of my servers - Debian
> > > "Squeeze" - employs mdadm 3.0.3, internally dated Oct. 22, 2009.  The
> > man
> > > page that comes with the software specifically says:
> > >
> > > -l, --level=
> > >
> > > <snip>
> > >
> > > 	Not yet supported with --grow.
> > 
> > Man page is wrong.  Thanks for reporting.  Fixed in current .git and will
> > be
> > in next release.
> 
> 	Oh, you're welcome.  Thanks to you for all the great work.
> 
> > The syntax for changing levels is simply:
> > 
> >   mdadm --grow /dev/mdX --level=6
> > 
> > This will preserve the number of data disks.  If you want to change that
> > (or
> > anything else) at the same time, you can:
> > 
> >  mdadm --grow /dev/mdX --level=6 --raid-disk=8 --chunk-size=1024 --
> > layout=left-asymetric
> 
> 	I'm a little fuzzy on how the number of member disks can be
> maintained while adding additional redundancy.  Must the file system(s) be
> shrunk so that the total amount of free space on all the members is greater
> than the member size?  In my situation, that won't work.  First of all, I am
> using XFS, and I don't think XFS will allow shrinking of the file system.
> In any case, however, the file system, which fills the entire array which in
> turn uses the entire (unpartitioned) space of each member, is over 93% full.
> It's an 8 x 1.5T disk RAID5 array with one spare drive.  Or does the --grow
> command automatically create a RAID6 array with one missing member?  Should
> I remove the spare before issuing the command?  If so, should I add it along
> with the command, something like:
> 
> mdadm --grow /dev/md0 --level6 --raid-disk=9 --add /dev/sdi
> 
> Or will mdadm automagically write the additional information to the 9th
> spare / member disk without me doing anything?

I didn't say that the number of "member disks" is preserved, but the number
of "data disks".
Normally you would have a RAID5 with a spare when you convert to RAID6 so the
spare gets incorporated.  This is the most efficient approach.
But if you don't have a spare it will still work.

Just tell mdadm what you want and it will do it, or report that it cannot.

NeilBrown
