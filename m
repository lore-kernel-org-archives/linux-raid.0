From: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Subject: Re: AARGH! Please help. IDE controller fsckup
Date: Thu, 3 Oct 2002 15:13:28 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200210031513.28459.roy@karlsbakk.net>
References: <200210021516.46668.roy@karlsbakk.net> <200210031225.11283.roy@karlsbakk.net> <20021003114020.GD7350@unthought.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20021003114020.GD7350@unthought.net>
To: Jakob Oestergaard <jakob@unthought.net>
Cc: Kernel mailing list <linux-kernel@vger.kernel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> > I have used presistent superblocks, but md0,1,2,3 will be different=
ly
> > ordered if I change the disk order... At least I think so. It surel=
y
> > didn't work.
>
> No. md0 would stay md0.  This is another effect of using superblocks,
> and in fact this is also (ironically) more or less the only argument
> *against* using them   :)
>
> (Imagine inserting a disk which knows that it is disk 0 of md0 into s=
ome
> machine that already has a perfectly fine md0 running)

ok. so. theoretically - as long as the system finds all 16 drives, I sh=
ould be=20
able to shuffle them around and attach them to whichever controller the=
re is?=20
right?

ok.

now, I've replaced the faulty controller, and booting up. the new contr=
oller=20
is also (like the old one) a CMD649...

h=E6?

it works. but it surely didn't work last time...

thanks

> > But ... with persistent superblock - is it possible to fsckup the r=
aid?
>
> You're root, it is indeed possible  :)

er - yes. I more meant like 'automagically'

> But you would not need to perform any of the special operations that =
you
> need to now.
>
> Persistent superblocks saves you from a number of "bad" situations yo=
u
> can encounter with normal production systems (such as replacing a
> controller or moving disks around).
>
> One should be careful when moving disks with persistent superblocks
> between systems though. You don't want the kernel to autodetect the
> "wrong" md0 on boot   :)    I consider this problem nonexistent in th=
e
> production environment that I administer, but I know that some people
> feel differently about it.  You should consider these pros and cons i=
n
> relation to your environment and make a decision based on that.


--=20
Roy Sigurd Karlsbakk, Datavaktmester
ProntoTV AS - http://www.pronto.tv/
Tel: +47 9801 3356

Computers are like air conditioners.
They stop working when you open Windows.

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
