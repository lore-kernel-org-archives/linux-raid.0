From: Kasper Sandberg <lkml@metanurb.dk>
Subject: Re: Sharing disks amoung multiple software RAIDs
Date: Fri, 02 May 2008 10:09:23 +0200
Message-ID: <1209715763.7827.2.camel@localhost>
References: <1209692359.16523.2.camel@localhost>
	 <73000.21239.qm@web50212.mail.re2.yahoo.com>
	 <A20315AE59B5C34585629E258D76A97C335477@34093-C3-EVS3.exchange.rackspace.com>
	 <1209696179.16523.13.camel@localhost>
	 <72dbd3150805020006p7f976a04o487389840f03b4a2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <72dbd3150805020006p7f976a04o487389840f03b4a2@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Rees <drees76@gmail.com>
Cc: David Lethe <david@santools.com>, alex14641@yahoo.com, Justin Piszcz <jpiszcz@lucidpixels.com>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 2008-05-02 at 00:06 -0700, David Rees wrote:
> On Thu, May 1, 2008 at 7:42 PM, Kasper Sandberg <lkml@metanurb.dk> wrote:
> >  in other words, would i be
> >  safer to run rsync every day to my other disk, and run in non-raid
> >  mode?!
> 
> What would be safer is to run rsync every day from one redundant array
> to another array - preferably on another machine that is located as
> far away as possible from the one that you are backing up.
> 
> RAID is not the same as a backup, though unfortunately, too many
> people treat it as such.
Im not treating it as a backup, what i want, is to make sure that if 1
disk dies, the data is still intact and ill hopefully be able to run
with 1 disk till the newly ordered one arrives - and while i naturally
will keep offsite backups of most important data, it is certainly far
easier to simply rip out a faulty disk, and put in another, instead of
restoring from backup from scratch..

So my question remains.. Is md raid1 not suited for this need? would it
be safer to run in non-raid1 mode and daily(maybe hourly) rsync
everything over to the second disk?

> 
> -Dave

