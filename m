From: Ming Zhang <mingz@ele.uri.edu>
Subject: Re: how to clone a disk
Date: Sat, 11 Mar 2006 19:36:07 -0500
Message-ID: <1142123767.27020.57.camel@localhost.localdomain>
References: <1142038562.20484.234.camel@localhost.localdomain>
	 <dd43dcfb0603110353g1a4d51f6y9fe4caa4007b6e9c@mail.gmail.com>
	 <1142114892.27020.7.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0603111608480.21574@twinlark.arctic.org>
	 <1142122974.27020.43.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0603111623520.21574@twinlark.arctic.org>
Reply-To: mingz@ele.uri.edu
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0603111623520.21574@twinlark.arctic.org>
Sender: linux-raid-owner@vger.kernel.org
To: dean gaudet <dean@arctic.org>
Cc: "Paul M." <paul@gpmidi.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, 2006-03-11 at 16:31 -0800, dean gaudet wrote:
> On Sat, 11 Mar 2006, Ming Zhang wrote:
> 
> > On Sat, 2006-03-11 at 16:15 -0800, dean gaudet wrote:
> > 
> > > you're planning to do this while the array is online?  that's not safe... 
> > > unless it's a read-only array...
> > 
> > what i plan to do is to pull out the disk (which is ok now but going to
> > die), so raid5 will degrade with 1 disk fail and no spare disk here,
> > then do ddresue to a new disk which will have same uuid and everything,
> > then put it back, then bitmap will shine here right?
> > 
> > so raid5 is still online while that disk is not part of raid5 now. and
> > no diskio on it at all. so do not think i need an atomic operation here.
> 
> if you fail the disk from the array, or boot without the failing disk, 
> then the event counter in the other superblocks will be updated... and the 
> removed/failed disk will no longer be considered an up to date 
> component... so after doing the ddrescue you'd need to reassemble the 
> raid5.  i'm not sure you can convince md to use the bitmap in this case -- 
> i'm just not familiar enough with it.

i am little confused here. then what the purpose of that bitmap for? is
not that bitmap is for a component temporarily out of place and thus out
of sync a bit?

> 
> > this raid5 over raid1 way sounds interesting. worthy trying.
> 
> let us know how it goes :)  i've considered doing this a few times 
> myself... but i've been too conservative and just taken the system down to 
> single user to do the ddrescue with the raid offline entirely.

sure. after we finish this discussion and sort out a stable plan. do not
want to risk my data. :P

> 
> -dean

