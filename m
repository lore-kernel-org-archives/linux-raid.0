From: maarten van den Berg <maarten@ultratux.net>
Subject: Re: Really fucked up raid0 array
Date: Mon, 5 Jul 2004 20:29:48 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200407052029.48810.maarten@ultratux.net>
References: <40E93DFC.6070507@pulz.no> <200407051658.02492.maarten@ultratux.net> <40E96CA5.9030500@pulz.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <40E96CA5.9030500@pulz.no>
Content-Disposition: inline
To: Geir =?iso-8859-1?q?R=E5ness?= <post@pulz.no>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday 05 July 2004 16:58, you wrote:
> maarten van den Berg wrote:
> >On Monday 05 July 2004 13:39, Geir R=E5ness wrote:

> >Maybe you cannot umount it because it's still in use ?  In that case=
, run
> >'lsof | grep <mountpoint>' to see what resources use files on that
> > mountpoint, and terminate these processes first.

> Way ahead of you.
> lsof freeses to, so i arn't able to find out what is using the disk.
>
> All programs like:
> ps
> w
> finger
> who
> lsof
> ls
>
> and stuff like that freeses

Hm...  Sorry to hear that.  I've had those same effects happen to me=20
sometimes, and I always wondered if there isn't a way to get out of the=
=20
predicament...  But I have not found any other way than reset, yet.

I don't remember when this happened exactly, but one surefire way I kno=
w to=20
trigger it is doing a 'df' when you've mounted an NFS share (without "i=
ntr")=20
and you lost connectivity to that share. Not only the process hangs, bu=
t any=20
attempt to subsequentially kill that process hangs, too. Wash, rinse...=
  :-( =20

My guess is, this is a kernel in severe state of panic. Maybe swap was =
on that=20
missing array(?), but a host of other reasons could've led to this too.

> I also tried killing prorgrams that might be in the danger sone of us=
ing
> the disk, killall -9 blahblah
> and it freeses :)

I now the feeling.  At this point, the only thing I can suggest is eith=
er try=20
to salvage things with SYSREQ keys [if enabled], or else run shutdown a=
nd by=20
the time that shutdown hangs too (since it probably will hang, in my=20
experience), press reset when disk activity (seems to-) have stopped.

But maybe more enlightened people here have better suggestions...?=20

Maarten

--=20
When I answered where I wanted to go today, they just hung up -- Unknow=
n

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
