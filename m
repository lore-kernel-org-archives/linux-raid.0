From: Neil Brown <neilb@suse.de>
Subject: Re: mdadm options, and man page
Date: Thu, 19 Jan 2006 13:09:36 +1100
Message-ID: <17358.62688.202905.508607@cse.unsw.edu.au>
References: <026f01c61afc$54d40660$a400a8c0@dcccs>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from JaniD++ on Tuesday January 17
Sender: linux-raid-owner@vger.kernel.org
To: JaniD++ <djani22@dynamicweb.hu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday January 17, djani22@dynamicweb.hu wrote:
> Hello, Neil,
> 
> Some days before, i read the entire mdadm man page.

Excellent...

> 
> I have some ideas, and questions:
> 
> Ideas:
> 1. i think, it is neccessary, to make another one mode to mdadm like "nop"
> or similar, just for bitmaps, and another options, that only works with
> assemble, and create (or grow) modes.

This sounds like the 'misc' mode.  What exactly would you want to do
with it?

> 
> 2. i think the raid5 creation virtual spare drive technique necessary to be
> standalone option, to avoid more people to data lost, with re-creating the
> raid5 arrays, and who did'nt read carefully the entire man.

I don't see why this could cause loss of data.  Can you explain?

> 
> 3. i think it will be an usefull thing, set the recovery, resyncing
> order(eg. from the end of the drive to the beginning) of array, or set the
> "from" and "to" limits for it, or stop, restart(retry) this function, if it
> is possible again.
> (only experimental, it will be allow very easy to loose data.)
> This is useful in very big arrays, wich takes some days to resync.
> Yes, i know this caused to write the bitmap code, but i think the linux is
> beautiful because it is very configurable. :-)
> ... i did not like the automated things, what i cannot controll....

Why would you want to resync from the end to the beginning?

I am looking into make raid1 be usable on a cluster and that would
require better control of resyncing, but I'm not sure what exactly it
is that you want, or how it would be useful.

> 
> 
> Questions:
> 1. it will be possible to set/unset the --write-mostly, --write-behind
> options online?
> (i know, currently not.)

Hmmm... I'll look into that.

> 
> 2. it will be possible to create a bitmap in raid5 when it is resyncing, or
> recovering?

No.  You new to either wait for the resync/recovery to complete, or
abort it.

> 
> 3. it is possible to set unset the clean state of the array online? (useful
> for idea #3)

There are some new attributes in /sys/block/mdX/md/ which might be of
interest.
Read through Documentation/md.txt in 2.5.16-rc1.

> 
> 4. why the md did not support raid4,5 with non-persistent superblock?
> I think the non-persistent superblock raid4 is very useful thing to easy
> upgrade (protect) from one big legacy raid0 array to raid4 with an existing
> data! :-)
> At this time i need it too. :-)

You need metadata (superblock) to be able to track failure and
rebuilds and such.  Even raid1 with non-persistent superblock is
something you have to be careful with.  You wouldn't use it for a
long-lived array, only to copy data from one place to another but
still have the data live.

Hope that helps,

NeilBrown
