From: Mario Mendeni <htrafmb@yahoo.it>
Subject: Force raid5 assemble at boot kernel
Date: Mon, 18 Oct 2004 10:37:44 +0200 (CEST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20041018083744.48600.qmail@web51708.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
Cc: Neil Brown <neilb@cse.unsw.edu.au>
List-Id: linux-raid.ids

Hi all,
  i've got a / over a failed raid5. i mean, three
disks: one broken (a), one good (b), one failed (c).
the last one was kicked out of the array because a
read error. anyway, no trouble because i've got backup
and so on. Well, if I boot from another disk and force
assembly it restarts, but I would like to know if I
can force the assembly of md0 for device (b) and (c)
from kernel command line (grub/lilo).

Thanks a lot for your time and your work,
andrea (a happy software raid user)


	=09
___________________________________=20
Nuovo Yahoo! Messenger: E' molto pi=F9 divertente: Audibles, Avatar, We=
bcam, Giochi, Rubrica=85 Scaricalo ora!=20
http://it.messenger.yahoo.it
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
