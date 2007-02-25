From: Mark Hahn <hahn@mcmaster.ca>
Subject: Re: Linux Software RAID a bit of a weakness?
Date: Sun, 25 Feb 2007 15:08:14 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0702251504090.21918@coffee.psychology.mcmaster.ca>
References: <1172258378.21648.51.camel@cowie>  <45DF46B7.3040707@maine.edu>
 <1172406243.3765.29.camel@cowie> <45E1E051.1020908@sauce.co.nz>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <45E1E051.1020908@sauce.co.nz>
Sender: linux-raid-owner@vger.kernel.org
To: Richard Scobie <richard@sauce.co.nz>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> You could configure smartd to do regular long selftests, which would notify 
> you on failures and allow you to take the drive offline and dd, replace etc.

is it known what a long self-test does?  for instance, ultimately you
want the disk to be scrubbed over some fairly lengthy period of time.
that is, not just read and checked, possibly with parity "fixed",
but all blocks read and rewritten (with verify, I suppose!)

this starts to get a bit hair-raising to have entirely in the kernel - 
I wonder if anyone is thinking about how to pull some such activity 
out into user-space.

regards, mark hahn.
