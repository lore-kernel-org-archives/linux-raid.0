From: Jim Paris <jim@jtan.com>
Subject: Re: Call for RAID-6 users
Date: Mon, 26 Jul 2004 22:12:09 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040727021209.GA19205@jim.sh>
References: <20040726213811.GA17363@jim.sh> <1090893920.32728.201130124@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1090893920.32728.201130124@webmail.messagingengine.com>
To: Matthew - RAID <RAID@lists.elvey.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> > > Thus, if you have used RAID-6 and have good or bad experiences, I'd
> > > like to know them as soon as possible.
> > 
> > Just tried setting up a RAID-6 on a new server, and I'm seeing
> > complete filesystem corruption.
> > # cd /mnt/root ; tar --one-file-system -cf - / | tar --preserve -xvf - ;
> > cd /
> > # umount /mnt/root
> > # reiserfsck /dev/md1  # <-- many, many errors
> 
> My reading of things was that /proc and any in-use mount points needed
> to be handled specially when using tar to do the copy.  Then again, the
> --one-file-system argument could be taking care of that; I haven't heard
> of using it.
> 
> Is it OK to use tar on / including /proc and /dev like this?

I've done the same thing with setting up RAID-5 in the past, so the
procedure should be okay.  --one-file-system excludes /proc, and
tar handles special files in /dev properly.

I can do more specific tests (writing particular data to the disk and
reading it back), but I'm not sure what patterns would be useful.

-jim
