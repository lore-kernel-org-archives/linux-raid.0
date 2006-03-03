From: Kasper Dupont
	<70006427576745453539@expires.04.sep.2006.kasperd.net>
Subject: Re: No syncing after crash. Is this a software raid bug?
Date: Fri, 3 Mar 2006 08:30:18 +0100
Message-ID: <20060303073016.GA662@hactar.lan>
References: <20060301124432.GA3591@hactar.lan> <20060301215641.GA27042@hactar.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20060301215641.GA27042@hactar.lan>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> Do you have write-cache enabled on the mirrors?

How do I find out about that?

> Sometimes I have differences between RAID1 mirrors in 2.4, too.

I have not experienced this with 2.4. However the 2.4 and 2.6
machines are not exactly the same hardware. But AFAIR they both
use Promise controllers and Seagate disks.

> Even with clean shutdown or reboot sequences.

Actually I think some of the differences on the swap device have
happened on clean shutdowns.

> However, in my case, it turns out
> that this always affects areas which are "free" on the filesystem lay=
er.

Does the raid layer have any way to know if they are free and
treat them differently?

> that I have md5sums of all my files which don't show up any
> differences when I either copy the non-zero content over the zeros or=
 the
> other way around.

OK. Then it may very well be free areas. (Or perhaps journal)

> Especially I have never experienced such "normal" differences on my s=
wap
> RAID1 mirrors.

So far I have only seen it happen on swap. I thought that might
be because that machine swaps a lot.

(A copy of any replies to my email address will be appreciated).

--=20
Kasper Dupont -- Rigtige m=E6nd skriver deres egne backupprogrammer
#define _(_)"d.%.4s%."_"2s" /* This is my new email address */
char*_=3D"@2kaspner"_()"%03"_("4s%.")"t\n";printf(_+11,_+6,_,6,_+2,_+7,=
_+6);
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
