From: Gordon Henderson <gordon@drogon.net>
Subject: Re: Fwd: Linux MD raid5 and reiser4... Any experience ?
Date: Thu, 5 Jan 2006 11:43:29 +0000 (GMT)
Message-ID: <Pine.LNX.4.56.0601051142370.30112@lion.drogon.net>
References: <fd8d0180601050104x15079396h@mail.gmail.com>
 <fd8d0180601050106s5f5b4306o@mail.gmail.com>  <87oe2r2d93.fsf@rimspace.net>
 <43BD026C.4050705@panix.com> <fd8d0180601050335ob7b791cm@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <fd8d0180601050335ob7b791cm@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 5 Jan 2006, Francois Barre wrote:

> 2006/1/5, berk walker <berk@panix.com>:
> [...]
> > >
> > >
> > Ext3 does have a fine record.  Might I also suggest an added expense of
> > 18 1/2% and do RAID6 for better protection against data loss?
> > b-
> >
>
> Well, I guess so. I just hope I'll be given enough money for it, since
> it increases the cost per GB. Anyway I guess that it is preferable
> than a raid5 + 1 spare.

If you've got a spare, you might as well use it (IMO!)

> By the way, not really a raid-oriented question, but what is the exact
> robustness of ext3 resizing ? I mean : what happens if the box crashes
> while resizing an ext3 ?
> This implies, of course, resizing capabilities for raid6, which is not
> implement yet. Is it ?

No personal experience. I build servers for a purpose and when time comes
to expand it, I build another!

Gordon
