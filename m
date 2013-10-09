From: Guillaume Betous <guillaume.betous@gmail.com>
Subject: Re: RAID 5 : recovery after failure
Date: Wed, 9 Oct 2013 10:20:40 +0200
Message-ID: <CAPbD+Rd2Ouvh0crZgujrkqTr2kCNPkQ25D3f7q96eQFDb__ddw@mail.gmail.com>
References: <CAPbD+Repm2SDpCGsR35QbW9Zq-MiCu1Fsdh4jjP_yESE3E3Exg@mail.gmail.com>
	<20131008210603.GA22876@cthulhu.home.robinhill.me.uk>
	<CAPbD+Re5TogdCTWabxoch77zzSRFfZhzuxAF=+UVn_ND2+R-3w@mail.gmail.com>
	<alpine.DEB.2.02.1310090853060.20065@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.02.1310090853060.20065@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Damn, you're right !

# cat /proc/mdstats
Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [raid=
4]
md127 : inactive sde1[2](S) sdd1[6](S) sdb1[5](S) sdf1[4](S)
      7814050144 blocks super 1.2

unused devices: <none>

=3D> I stopped my array (mdadm --stop), then restarted :

sam / # cat /proc/mdstat
Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [raid=
4]
md127 : active raid5 sdc1[0] sdf1[4] sde1[2]
      5860535808 blocks super 1.2 level 5, 512k chunk, algorithm 2 [4/3=
] [U_UU]

unused devices: <none>

It works !!!

Now, should I add the other drives ? How ?

Thanks a lot :)

gUI

2013/10/9 Mikael Abrahamsson <swmike@swm.pp.se>:
> On Wed, 9 Oct 2013, Guillaume Betous wrote:
>
>> I don't know where this "busy" message comes from : I have no mount =
nor
>> RAID service started.
>
>
> "cat /proc/mdstat" says no md volume is in any state at all? This is =
usually
> the case when these busy messages are shown.
>
> --
> Mikael Abrahamsson    email: swmike@swm.pp.se



--=20
Pour la sant=E9 de votre ordinateur, pr=E9f=E9rez les logiciels libres.
Lire son mail : http://www.mozilla-europe.org/fr/products/thunderbird/
Browser le web : http://www.mozilla-europe.org/fr/products/firefox/
Suite bureautique : http://www.libreoffice.org/download/
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
