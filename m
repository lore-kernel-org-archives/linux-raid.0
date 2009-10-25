From: adfas asd <chimera_god@yahoo.com>
Subject: Re: Is My Data DESTROYED?!
Date: Sun, 25 Oct 2009 05:46:04 -0700 (PDT)
Message-ID: <903282.80364.qm@web38803.mail.mud.yahoo.com>
References: <7bc80d500910240759x443e7a00n4fdcb41f60ec9d73@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <7bc80d500910240759x443e7a00n4fdcb41f60ec9d73@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--- On Sat, 10/24/09, Christopher Chen <muffaleta@gmail.com> wrote:
> Part of this sounds like you're looking for best practices.
> I imagine
> that's why you made a raid 10, and why you're using JFS.
> It's probably
> why you've been fiddling around with blockdev --setra and
> all that
> too

Exactly.

> The issue is, you're shooting in the dark unless you really
> understand
> what you want to do and why. You also said HTPC. Is this
> basically a
> large bucket for videos and other media?

Yes it's my video collection which I've worked long and hard to gather.  Your point is taken that it doesn't have to be hot online, but if it can why not?  I hate tape, and claim that it's obsolete.

I am shocked at all who think that human error is so prevalent, and in fact obviates the case for RAID as backup.  I've run Debian for 12 years on all my personal servers and remember literally only 3 or 4 cases in that time where I muggered something up and had to go to backup.  There must be alot of fsckups out there...

That said, I am now considering making the storage server in the garage a backup rather than a RAID.  This means I'll want it to go to sleep most of the time, and I'll need a mobo that does wake-on-LAN successfully and automatically.

Now a backup by cron is nice and all, but what if it silently fails in some obscure way?  This is one thing I like about RAID or ZFS, it lets you know when anything's wrong.  I can imagine setting up a fancy-pants backup system then going about my life, and some quirk happens on the next update which subtlely hoses my exotic backup system.  It is desirable to have bolt-tight assurance of backed-up data.  (And please don't bore us with 'nothing is for sure')  

Seems like a sync process, and then a checksum process to compare drives and email a result, although minor files are changing all the time and I wouldn't want to be notified if /tmp has changed.

Also I've noticed rsync mentioned several times.  This seems to have facilities for incremental backups, but I've also read that it is non-secure over networks and that we should use scp instead.  But scp doesn't seem to have incremental attributes.  Yes, this is my home LAN, but I have a thing about security in and out.  Isn't there another way of syncing two disks (over a network)?




      
