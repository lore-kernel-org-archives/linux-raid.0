From: Guillaume Betous <guillaume.betous@gmail.com>
Subject: RAID 5 : recovery after failure
Date: Tue, 8 Oct 2013 21:19:44 +0200
Message-ID: <CAPbD+Repm2SDpCGsR35QbW9Zq-MiCu1Fsdh4jjP_yESE3E3Exg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

My RAID 5 has failed... After a first failure, the spare disk has
started its rebuild. During the rebuild process (60%), I received a
2nd email :(

The RAID became laggy and finally unusable.

Now I can't recover the RAID array. Even if there is no particular
precious data, I'm trying to recover it, only be to learn a little bit
:)

I've tried the procedures written in the wiki, and before trying the
last one (recreate), I write this mail, as said in the wiki :)

Trying to --force fails with the following message :
mdadm: /dev/sdf1 has no superblock - assembly aborted

Removing sdf1 from RAID array results in same error on sdd1 and so on..=
=2E

You'll find some command results here after :

mdadm --examine : http://pastie.org/8385891
timeouts : http://pastie.org/8385901
smartclt -x : http://pastebin.com/BXMHADZD

Thanks all for your help :)

Regards,

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
