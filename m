From: Guillaume Betous <guillaume.betous@gmail.com>
Subject: Re: Best practice for setting up "ordinary" RAID
Date: Fri, 11 Oct 2013 10:57:50 +0200
Message-ID: <CAPbD+RcN-ze=+wP+46N_wkVWkhV_feNXtkyKAuxy-D4MQmRctQ@mail.gmail.com>
References: <CAPbD+RckkbYXF4Wpr_yzboJ0B+TBZayf0LbT3f4O3xQ-JN3gaA@mail.gmail.com>
	<alpine.DEB.2.02.1310110827350.20065@uplift.swm.pp.se>
	<CAPbD+Rc-EDpVvm=-Ge5nWJNgJRBVWseqJKwnfCdDLoBjzC4hzg@mail.gmail.com>
	<alpine.DEB.2.02.1310110900400.20065@uplift.swm.pp.se>
	<CAPbD+Rc81u=_VrK0VSNvOdfQxYK4CHse+DYa8-vS1r==b_AN_Q@mail.gmail.com>
	<20131011081508.GA4995@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20131011081508.GA4995@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Guillaume Betous <guillaume.betous@gmail.com>, Mikael Abrahamsson <swmike@swm.pp.se>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> Any read
> error or drive failure during the rebuild and you're in trouble.

That was exactly what happened to me ! A rebuild is of course a very
big load and another failure becomes more probable.

> With RAID 6 you can handle 2 drive failures at any time

Understood. I'll definitely switch to RAID 6 :)

> They are more complex, but not enough so to trouble any modern CPU - =
you
> might have issues on a 386/486, but I doubt you'll see any difference=
 on
> an Atom.

Ok. Maybe I should update French version of Wikipedia RAID article :)
I'll test by myself.
=46or now (RAID 5), on rebuild, it's about 30MB/s. On reading, it's
about 90MB/s (direct access to /dev/md127, not read from FS).

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
