From: "Matthew - RAID" <RAID@lists.elvey.com>
Subject: Re: Call for RAID-6 users
Date: Mon, 26 Jul 2004 19:05:20 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1090893920.32728.201130124@webmail.messagingengine.com>
References: <20040726213811.GA17363@jim.sh>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20040726213811.GA17363@jim.sh>
To: Jim Paris <jim@jtan.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Mon, 26 Jul 2004 17:38:11 -0400, "Jim Paris" <jim@jtan.com> said:
> > Thus, if you have used RAID-6 and have good or bad experiences, I'd
> > like to know them as soon as possible.
> 
> Just tried setting up a RAID-6 on a new server, and I'm seeing
> complete filesystem corruption.
> # cd /mnt/root ; tar --one-file-system -cf - / | tar --preserve -xvf - ;
> cd /
> # umount /mnt/root
> # reiserfsck /dev/md1  # <-- many, many errors

My reading of things was that /proc and any in-use mount points needed
to be handled specially when using tar to do the copy.  Then again, the
--one-file-system argument could be taking care of that; I haven't heard
of using it.

Is it OK to use tar on / including /proc and /dev like this?

cpio, cp, tar - I've seen HOWTOs use all three to copy / !  
