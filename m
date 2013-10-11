From: Guillaume Betous <guillaume.betous@gmail.com>
Subject: Re: Best practice for setting up "ordinary" RAID
Date: Fri, 11 Oct 2013 09:14:24 +0200
Message-ID: <CAPbD+Rc81u=_VrK0VSNvOdfQxYK4CHse+DYa8-vS1r==b_AN_Q@mail.gmail.com>
References: <CAPbD+RckkbYXF4Wpr_yzboJ0B+TBZayf0LbT3f4O3xQ-JN3gaA@mail.gmail.com>
	<alpine.DEB.2.02.1310110827350.20065@uplift.swm.pp.se>
	<CAPbD+Rc-EDpVvm=-Ge5nWJNgJRBVWseqJKwnfCdDLoBjzC4hzg@mail.gmail.com>
	<alpine.DEB.2.02.1310110900400.20065@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.02.1310110900400.20065@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> What is it about RAID6 that you are not comfortable with?

I've never use it :)

Here the deal : I have 5 drives on my NAS, I can't have more in my
tower (1 drive for the system, 5 drives for the NAS). From Adam's
message, it should be enough for setting up a good RAID 6.

=46or now, I have a RAID 5 with a spare, meaning that I have 3x(drive
size) as available size. I can have 2 hard drive failures.
If I setup a RAID 6, if I understand well, I'll also have 3x(drive
size) as available size, I will also can have 2 drive failures.

As I read that algorithm on the RAID 6 are way more complex, and
rebuild time is longer, as I have only a Atom D510 as CPU, I consider
that RAID 5 is a better option.

But if you can explain that RAID 6 have pros I haven't seen, I'll
surely swith to RAID 6 (always want to learn :) ).

Thanks,

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
