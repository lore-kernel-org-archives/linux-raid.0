From: Gordon Henderson <gordon@drogon.net>
Subject: Re: Slackware and RAID
Date: Sat, 16 Sep 2006 19:35:59 +0100 (BST)
Message-ID: <Pine.LNX.4.56.0609161934270.21474@lion.drogon.net>
References: <200609161230.22530.Dexter.Filmore@gmx.de> <450C33BA.2000208@tmr.com>
 <200609162032.07509.Dexter.Filmore@gmx.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200609162032.07509.Dexter.Filmore@gmx.de>
Sender: linux-raid-owner@vger.kernel.org
To: Dexter Filmore <Dexter.Filmore@gmx.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, 16 Sep 2006, Dexter Filmore wrote:

> Am Samstag, 16. September 2006 19:26 schrieb Bill Davidsen:
> > Dexter Filmore wrote:
> > >Is anyone here who runs a soft raid on Slackware?
> > >Out of the box there are no raid scripts, the ones I made myself seem a
> > > little rawish, barely more than mdadm --assemble/--stop.
> >
> > I'm pretty much off Slack now, but I have run, the scripts you describe
> > are about 2/3 of what you need, see the thread(s) here about monitoring.
> > mdadm doesn't need a lot of direction...
>
> What's the remaining third?
> I fumbled it into rc.S and rc.6, reason why I ask is that array degraded about
> 6 times in the few months I run it and I can't figure why. Only thing I know
> is that it degrades somewhere in the reboot process, so I suspect it might
> not properly shutdown.

Have you tried simply setting the partition types to 0xFD and relying on
the kernel auto-detect?

I read here that there seems to be some resistance to this method though,
but I've been using it for many years without any issues - however I'm not
doing any thing "clever" like LVM or RAID on RAID (RAID1+0, etc.)

Gordon
