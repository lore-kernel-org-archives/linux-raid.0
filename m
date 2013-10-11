From: Guillaume Betous <guillaume.betous@gmail.com>
Subject: Best practice for setting up "ordinary" RAID
Date: Fri, 11 Oct 2013 08:10:04 +0200
Message-ID: <CAPbD+RckkbYXF4Wpr_yzboJ0B+TBZayf0LbT3f4O3xQ-JN3gaA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi all,

Now my RAID is back thanks to all your precious advices, I want it to
be as reliable as possible, knowing that I own "ordinary" hadrware :
- standard PC (Atom based)
- standard hard drives (some WD Red, but also Green, and Seagate
without ERC capabilities)
- standard need : NAS service, which aims at reliabily serve files for
the whole local network (Gigabit).

So, here is my current setup :
- The RAID contains a spare disk
- I set timeouts to 30" at every boot
- The default SCT ERC value is 7" on my two Red disks
- I cron a check every week

What other advice could be done *before* the failure happens ?

Thanks to all,

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
