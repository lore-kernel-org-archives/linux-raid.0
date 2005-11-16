From: Guillaume Filion <gfk@logidac.com>
Subject: Re: Crooked raid
Date: Wed, 16 Nov 2005 08:47:36 -0500
Message-ID: <437B3878.1080308@logidac.com>
References: <4379FCC8.5090903@logidac.com> <17274.27186.622362.978757@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17274.27186.622362.978757@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown a =E9crit :
> It's not entirely clear to me what is happening,  In particular, why
> md is tring to bind '..../disc,*' to an array. =20

It's not clear to me either! :-)

> Maybe something is
> running 'raidstart'.  Do you have an '/etc/raidtab'?? If so, remove
> it.

No I don't have a /etc/raidtab

> If md0 doesn't hold your root filesystem, try unmounting it, stopping
> it with
>   mdadm --stop /dev/md0
> and restarting with
>   mdadm --assemble /dev/md0 --update=3Dsummaries /dev/hd[gc]2

Unfortunately, it does hold my root filesystem. Maibe, I could boot fro=
m=20
a rescue floppy/CD with mdadm?

Thanks,
GFK's
--=20
Guillaume Filion, ing. jr
Logidac Tech., Beaumont, Qu=E9bec, Canada - http://logidac.com/
PGP Key and more: http://guillaume.filion.org/
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
