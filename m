From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: md software raid
Date: Tue, 27 Oct 2009 21:11:32 -0500
Message-ID: <20091028021139012.SPRI6016@cdptpa-omta03.mail.rr.com>
References: <70ed7c3e0910271810t368f3081g3db4411ab073b531@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <70ed7c3e0910271810t368f3081g3db4411ab073b531@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> Thank you Richard for the update!
> 
> Though with the recent performance drops of XFS on 2.6.3x kernels, and
> the fact that the XFS patches are fairly new (and probably buggy), I'd
> rather stay away from XFS for a while and look into other possible
> options. If any...

	I hear what you are saying, but reformatting an array to a new fs is
definitely a daunting prospect.  I have a minor coronary every time I think
of deliberately reducing the number of copies of my data from 2 to 1 while
the array is re-formatted and the data copied back to the main array.  This
process takes long enough that the odds of encountering two drive failures
on the RAID5 backup system during the copy are not infinitesimal...

	<sigh>

	I guess one of these days I am going to have to bite the bullet and
build a *SECOND* backup system.  I don't suppose I will ever breathe
perfectly easy until I can have two completely independent systems fail and
still not lose any data.  That, or maybe Blu-ray disks will become cheap
enough to create multi-terabyte backups on them.  Right now, the best price
I see is $112 a terabyte, and I can do substantially better than that using
hard drives.  Even if they do get cheaper than hard drives, the thought of
swapping out 400+ Blu-Ray discs over a period of several days doesn't really
thrill me.  Maybe a cold hard drive backup is the answer?  It eliminates
most of the pitfalls of a Blu-Ray backup, can easily be overwritten, only
requires a relative handful of discs, and costs less than $75 a terabyte.  

	Hmmm...

