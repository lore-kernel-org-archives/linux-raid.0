From: Guillaume Betous <guillaume.betous@gmail.com>
Subject: Re: Best practice for setting up "ordinary" RAID
Date: Fri, 11 Oct 2013 08:52:16 +0200
Message-ID: <CAPbD+Rc-EDpVvm=-Ge5nWJNgJRBVWseqJKwnfCdDLoBjzC4hzg@mail.gmail.com>
References: <CAPbD+RckkbYXF4Wpr_yzboJ0B+TBZayf0LbT3f4O3xQ-JN3gaA@mail.gmail.com>
	<alpine.DEB.2.02.1310110827350.20065@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.02.1310110827350.20065@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> I would recommend setting this to 180 seconds.

Yes, and that's what I've done ! Not 30 seconds, but 3 minutes, you're =
right.
Sorry :)

> RAID6, preferrably with a spare.

I'm not comfortable with RAID 6 setup. What is the minimal number of
hard drives for having a RAID 6 + spare ?

> Also save mdadm --examine and smartctl -a from all drives at each sta=
rt (or
> at least after every time you've done a change to the array)

Very good. I'll had this.

> I would also recommend having a recent enough kernel so you can do in=
-place
> replacement. I believe this is 3.3 and later.

Checked : 3.7, so that's OK.

gUI

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
