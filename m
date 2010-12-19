From: =?ISO-8859-1?Q?Bj=F8rn_Eikeland?= <beikeland@gmail.com>
Subject: Re: best way to try recovering inactive raid6
Date: Sun, 19 Dec 2010 17:44:21 +0100
Message-ID: <AANLkTimavOiEqjd9Qba5xc5sgqiqxHaGFPNQhyP=rJaK@mail.gmail.com>
References: <AANLkTin71JrpmKJC6df+ZX7jsm7P8RwCzUSfV8CMWk2v@mail.gmail.com>
	<alpine.DEB.1.10.1012191559010.27193@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.1012191559010.27193@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

2010/12/19 Mikael Abrahamsson <swmike@swm.pp.se>:
> On Sun, 19 Dec 2010, Bj=F8rn Eikeland wrote:
>
>> Hope you guys can help me out with some input here!
>
> What mdadm and kernel version are you using?
>
> If you're not using the latest mdadm version (3.1.4 afaik) then try
> --assemble --force with that one first. It does a better job than mos=
t of
> the versions that come with most distributions today.
>
> Recreating the array is highly dangerous and it's definitely a last r=
esort.
>
> --
> Mikael Abrahamsson =A0 =A0email: swmike@swm.pp.se

$ uname -a
Linux filebear 2.6.32-26-generic #48-Ubuntu SMP Wed Nov 24 09:00:03
UTC 2010 i686 GNU/Linux

$ mdadm -V
mdadm - v3.1.4 - 31st August 2010
$ sudo mdadm --assemble --force /dev/md6
mdadm: /dev/md6 assembled from 2 drives and 2 spares - not enough to
start the array.

$ cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md6 : inactive sdc1[0](S) sdd1[6](S) sdh1[5](S) sda1[3](S)
     3906236416 blocks

unused devices: <none>

mdadm was older, but same behavior with 3.1.14. It was a new ubuntu
install a few days ago so didn't think of updating mdadm, kernel is
fairly recent at least.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
