From: Guillaume Betous <guillaume.betous@gmail.com>
Subject: Re: Best practice for setting up "ordinary" RAID
Date: Fri, 11 Oct 2013 10:58:53 +0200
Message-ID: <CAPbD+Rf9ncgBGG+A_fVsD8uk4kOAQ4mgeG1-h8karCOi5sq-UQ@mail.gmail.com>
References: <CAPbD+RckkbYXF4Wpr_yzboJ0B+TBZayf0LbT3f4O3xQ-JN3gaA@mail.gmail.com>
	<alpine.DEB.2.02.1310110827350.20065@uplift.swm.pp.se>
	<CAPbD+Rc-EDpVvm=-Ge5nWJNgJRBVWseqJKwnfCdDLoBjzC4hzg@mail.gmail.com>
	<alpine.DEB.2.02.1310110900400.20065@uplift.swm.pp.se>
	<CAPbD+Rc81u=_VrK0VSNvOdfQxYK4CHse+DYa8-vS1r==b_AN_Q@mail.gmail.com>
	<alpine.DEB.2.02.1310110917550.20065@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.02.1310110917550.20065@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> RAID6 will help you with drive failure plus random read error. RAID5 =
doesn't
> do that.

Yes, very good point. Next step : switch to RAID 6 :)

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
