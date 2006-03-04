From: Kasper Dupont
	<55666323303470176297@expires.05.sep.2006.kasperd.net>
Subject: Re: No syncing after crash. Is this a software raid bug?
Date: Sat, 4 Mar 2006 20:50:35 +0100
Message-ID: <20060304195032.GA12786@hactar.lan>
References: <20060301124432.GA3591@hactar.lan> <20060301215641.GA27042@hactar.lan> <20060303073016.GA662@hactar.lan> <20060303144824.GA15672@hactar.lan> <20060304131609.GA4064@erwin.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20060304131609.GA4064@erwin.lan>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> However, since "inconsistent parity information in raid[456] is equal
> to "different mirrors" in raid1, there is no real difference.

There is a major difference. Inconsistent parity information can
eventually lead to corruption in another sector in the stripe.
Assume there are two data disks and one parity disk, and two
different versions of sector A are used. Then after a write you
would end up with:

A  B  A'+B

on the three disks. This is a problem even if you are never
going to need the data from A again. If the disk holding B dies
it will be reconstructed as (A)+(A'+B), which does not give B
as it should. So after reconstruction sector B is corrupted.

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
