From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: Growing a RAID array
Date: Fri, 13 May 2011 00:57:41 -0500
Message-ID: <6C.05.28813.F48CCCD4@cdptpa-omtalb.mail.rr.com>
References: <20110513112313.54fbb717@notabene.brown>
Reply-To: <lrhorer@satx.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110513112313.54fbb717@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: 'NeilBrown' <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



> -----Original Message-----
> From: NeilBrown [mailto:neilb@suse.de]
> Sent: Thursday, May 12, 2011 8:23 PM
> To: lrhorer@satx.rr.com
> Cc: linux-raid@vger.kernel.org
> Subject: Re: Growing a RAID array
> 
> On Thu, 12 May 2011 20:02:01 -0500 "Leslie Rhorer" <lrhorer@satx.rr.com>
> wrote:
> 
> >
> > 	I am shortly going to be growing a 10 drive RAID6 array with two
> > additional drives.  Can this be done in a single grow operation by
> setting
> > n=12, or do I have to grow it 1 drive at a time?
> >
> 
> Experiment with loop-back devices created on modest sized files.
> 
> 
> (but yes, you can grow by any number you like.  You should test the drives
> fairly heavily first, because if they both die during the reshape, you
> lose
> your data).

	Actually, the "drives" won't be physical drives, but RAID0 volumes
made of 2 drives each.  'Ugly, I know, but I really have little choice for
the time being.  As to losing the data, this is a backup system in the first
place, and all its data is backed up to offline storage, as well, so a loss
of data would not be the most hideous thing ever.  All four drives have been
operating continuously without error for over a year, having been completely
read and written over several times, so I'm pretty confidant of their
reliability, enough so I don't think any additional testing is worth the
time and effort.

