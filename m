From: Goswin von Brederlow <brederlo@informatik.uni-tuebingen.de>
Subject: Re: Strange CPU occupation...
Date: Wed, 07 Nov 2007 09:55:36 +0100
Message-ID: <87wssujuyf.fsf@informatik.uni-tuebingen.de>
References: <4728773C.7010802@systella.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4728773C.7010802@systella.fr> (BERTRAND Joel's message of "Wed,
	31 Oct 2007 13:38:20 +0100")
Sender: linux-raid-owner@vger.kernel.org
To: BERTRAND Joel <joel.bertrand@systella.fr>
Cc: sparclinux@vger.kernel.org, linux-raid@vger.kernel.org, iscsitarget-devel@lists.sourceforge.net
List-Id: linux-raid.ids

BERTRAND Jo=EBl <joel.bertrand@systella.fr> writes:

>   PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
>
>  5426 root      15  -5     0    0    0 R  100  0.0  46:32.54
> md_d0_raid5

=46irst: You can tune the stripe cache.

Secondly: You might want the raid speedup patches that implement
prioritized queueing. That reduces the number of incomplete stripes
written to disk and thus speeds up things a lot.

Thirdly: If you have multiple cores then you probably want patches to
multithread the raid5 code. With just one thread it is ultimately cpu
bound and just won't get faster. XORing and maintainance overhead
seems to be awfully cpu intensive.

=46ourth: Learn to live with it. Software Raid5/6 is expensive.

> and some process are in D state :
> Root gershwin:[/etc] > ps auwx | grep D
> USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMM=
AND
> root       270  0.0  0.0      0     0 ?        D    Oct27   1:17 [pdf=
lush]
> root      3676  0.9  0.0      0     0 ?        D    Oct27  56:03 [nfs=
d]
> root      5435  0.0  0.0      0     0 ?        D<   Oct27   3:16 [md7=
_raid1]
> root      5438  0.0  0.0      0     0 ?        D<   Oct27   1:01 [kjo=
urnald]
> root      5440  0.0  0.0      0     0 ?        D<   Oct27   0:33 [loo=
p0]
> root      5441  0.0  0.0      0     0 ?        D<   Oct27   0:05 [kjo=
urnald]
> root     16442  0.0  0.0  20032  1208 pts/2    D+   13:23   0:00 ifto=
p
> -i eth2
>
> 	Why md7_raid is in D state ? Same question about iftop ?

I would say it is just waiting for the underlying devices to finish
some I/O request. And iftop will be in some kernel call waiting for
something or other.

MfG
        Goswin
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
