From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: 2x6 or 3x4 raid10 arrays ?
Date: Sat, 1 Mar 2008 21:55:04 +0100
Message-ID: <20080301205504.GA17192@rap.rap.dk>
References: <1204195554.16924.16.camel@franck-gusty> <20080228192500.4d9110d9@absurd> <20080228215339.6674f29d@absurd> <47C9B79F.1050906@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <47C9B79F.1050906@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Janek Kozicki <janek_listy@wp.pl>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, Mar 01, 2008 at 03:07:59PM -0500, Bill Davidsen wrote:
> Janek Kozicki wrote:
> >Janek Kozicki said:     (by the date of Thu, 28 Feb 2008 19:25:00 +0100)
> >
> >sorry about replying to myself.
> >
> >* two 6 disks raid10 arrays : theoretical max speed 6 times single disc
> >* three 4 disks raid10 arrays : theoretical max speed 4 times single disc
> >* single raid10 far=2  : theoretical max speed 12 times single disc (!)
> >
> >isn't that true?
> >
> >  
> True for throughput, not for seek. Also, what I have seen and read 
> indicates that smaller chunks help a lot for database with lots of seeks.

Why not for seek? I would have thought that seeks are almost the same,
and actually smaller for raid10,n2 with more disks, as raid10,f2 limits
read searches to the first part of the disks, and head movement thus are
much smaller, say 1/12 of the whole disk in stead of 1/4 for each of the
disks in a 4 disk array.

Best regards
keld
