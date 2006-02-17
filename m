From: =?iso-8859-2?Q?Pawe=B3_Kowalski?= <pk@uop.pl>
Subject: a little bug in mkraid.
Date: Fri, 17 Feb 2006 14:11:23 +0100 (CET)
Message-ID: <Pine.LNX.4.53.0602171411080.22200@strefa.uop.pl>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hi,
I think I found a little bug in raidtools.
When I try to add some new md devices everything is correct, but when w=
e
have active some device /dev/md10 - md11 etc.... (above /dev/md10) mkra=
id
is unable to make /dev/md1
I think this situation is because something like "grep" taking patern m=
d1
from /proc/mdstat (it must do "grep -w" instead).

Please, inform me that I'm right or not. Thanks.

Best Regards,

----
Pawe=B3 Kowalski
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
