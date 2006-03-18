From: Gordon Henderson <gordon@drogon.net>
Subject: Re: ex2fsck showing MANY errors on degraded RAID - out of luck?
Date: Sat, 18 Mar 2006 16:10:41 +0000 (GMT)
Message-ID: <Pine.LNX.4.56.0603181604390.31603@lion.drogon.net>
References: <6d5bedd80603180741s6b19ed53x929093fdac803d99@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <6d5bedd80603180741s6b19ed53x929093fdac803d99@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ewan Grantham <ewan.grantham@gmail.com>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sat, 18 Mar 2006, Ewan Grantham wrote:

> OK, managed to use assemble force to get the five remaining drives of
> the array up in degraded mode. But running ex2fsck (I had an ext3 fs
> on the RAID) is revealing a number of bad dtimes and invalid blocks.
> Trying to run ex2fsck with the -p option doesn't work for long, and
> having to hit enter after each line is testing my patience.
>
> So, am I likely to have any good data by the time I finish anyway, or
> am I wasting my time? Any quicker way to cleanup the filesystem to
> find out?

You might be able to mount it read-only and copy the data off, but who
knows what you might actually be copying.

There is a -y option to fsck which assumes a yes answer to all the
questions. It's never a good option, but sometimes the only option unless
you have an intimate knowledge of ext2/3 and an infinite amount of time to
sort it out.

I had to do this recently to a trashed 4-disk Raid-5 array - it had been
one disk down for some time and despite my telling them that they were
living on borrowed time, they didn't do anything about it, until a 2nd
disk died.  I managed to make it start in degraded mode, then fsck'd with
the -y option. 3 times. The array showed less than half the data it
originally had, but it seemed to keep them happy.... (and I saw some
messages from fsck I'd never seen before!) Fortunately they had a partial
backup that was only a day or 2 old, so they got most of the stuff back,
but I really suspect some of those file have holes in them and blocks of
bogus data.

A really quick way to clean up the filessystem is by use of the mkfs
command ;-)

Good luck!

Gordon
