From: Neil Brown <neilb@suse.de>
Subject: Re: smal mdadm 1.5  bug
Date: Tue, 22 Aug 2006 16:33:37 +1000
Message-ID: <17642.42305.746250.714032@cse.unsw.edu.au>
References: <20060821141801.AD67.JWILLEM@stads.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from jwillem on Monday August 21
Sender: linux-raid-owner@vger.kernel.org
To: jwillem <jwillem@stads.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday August 21, jwillem@stads.net wrote:
> 
> 
> 
> We have had a raidsystem running for several years 
> Created by the Fedora Core 2 installscript. 
> 
> Is has bit bigger raidsystem of more than 11 TB
> It was installed on 32 bit Fedora Core 2  linux 2.6.10 with mdadm 1.50
> 
> After a failure we had one disk that was out sync. 
> Couldn't assemble raidset, even with --force -> "Cannot write superblock"
> 
> After looking at the sourcecode in the file util.c  from mdadm-1.5.0 we
> found out that variable "size" was negative
> We changed variable size from "long size" into "unsigned long size" wich
> fixed this problem.
> 
> Seems that 1.9 already fixed the problem, perhaps even earlyer
> But also that 
> > Changes Prior to 1.5.0 release
> >     -   Fix compiling error with BLKGETSIZE64 and some signed/unsigned 
> > comparison warnings.
> 
> This was the version we were working on, so something went wrong there. 
> 
> Greetings Jan-Willem Michels ( Boy Kentrop working at our company fixed
> our problem) 

I'm a little confused..

Are you just telling us that you found a bug in an old version of
mdadm that was fixed in a newer version of mdadm?  Or are you telling
us that there is still a bug in a current version of mdadm?

If so, which version?
mdadm-1.5.0 is very old, and even mdadm-1.9.0 is fairly old.

NeilBrown
