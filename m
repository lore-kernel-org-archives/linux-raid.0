From: Adam Luter <luterac@bellsouth.net>
Subject: Re: AARGH! Please help. IDE controller fsckup
Date: Sat, 5 Oct 2002 11:51:43 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20021005165143.GD6874@smeagol>
References: <200210021516.46668.roy@karlsbakk.net> <200210031225.11283.roy@karlsbakk.net> <20021003114020.GD7350@unthought.net> <200210031513.28459.roy@karlsbakk.net> <20021003132349.GE7350@unthought.net> <3D9F084F.1020200@karlsbakk.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3D9F084F.1020200@karlsbakk.net>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Just picking a severly large number at random would be good enough.
But more useful ideas would be to keep the first two or three blocks
over the n-disks as a md5 sum or other kind of checksum as your id.

Yeah, that means the id can change, but that's not very important... it
just needs to be unique so that the automagic stops if something weird
happens (an out of sync disk, or a foreign disk).

Or at least, this makes sense to me, with no prior sleep for 20 hours.

-Gryn (Adam Luter)

On Sat, Oct 05, 2002 at 05:42:07PM +0200, Roy Sigurd Karlsbakk wrote:
> >>>>But ... with persistent superblock - is it possible to fsckup the raid?
> >>>You're root, it is indeed possible  :)
> >>er - yes. I more meant like 'automagically'
> >
> >It will only automagically screw up your arrays if you shuffle disks
> >between machines (mix several RAID arrays from other systems in one
> >system)  (you can of course move all your disks to one new machine, if
> >it has none of it's original RAIDed disks left).
> >
> >Just don't mix disks with persistent superblocks from multiple machines
> >into one single machine.  Unless you know exactly what you're doing.
> >
> Could it be some kind of idea to 'sign' the disks with some hash out of 
> hostname and  IP or something?
