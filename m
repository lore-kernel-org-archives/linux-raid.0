From: "Francois Barre" <francois.barre@gmail.com>
Subject: Re: raid issues after power failure
Date: Fri, 30 Jun 2006 11:21:16 +0200
Message-ID: <fd8d0180606300221x2280e220qd6f5fcd1096ff37b@mail.gmail.com>
References: <49954.82.141.169.118.1151658773.squirrel@mail.tyrell.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <49954.82.141.169.118.1151658773.squirrel@mail.tyrell.hu>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?=C1kos_Mar=F3y?= <darkeye@tyrell.hu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

2006/6/30, =C1kos Mar=F3y <darkeye@tyrell.hu>:
> Hi,
Hi,

>
> I have some issues reviving my raid5 array after a power failure.
> [...]
> strange - why wouldn't it take all four disks (it's omitting /dev/sdb=
1)?

=46irst, what is your mdadm version ?

Then, could you please show us the result of :

mdadm -E /dev/sd[abcd]1

It would show whever sdb is accessible or not, and what the
superblocks look like...
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
