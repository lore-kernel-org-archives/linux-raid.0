From: Stephan van Hienen <raid@a2000.nu>
Subject: WD1800XX / WD2000XX raid
Date: Sat, 5 Apr 2003 13:36:56 +0200 (CEST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.53.0304051335110.2985@ddx.a2000.nu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

today found this article :

http://wdc.custhelp.com/cgi-bin/wdc.cfg/php/enduser/std_adp.php?p_admin=
=3D1&p_faqid=3D913&p_created=3D1047068027
(http://support.wdc.com/raid.asp)

Problem:
WD EIDE 180GB and 200GB drives are dropped from an IDE RAID configurati=
on
after several days or weeks of operation.

Solution:
The problem is a result of a feature that reduces idle acoustic noise i=
n
desktop drives. This feature can cause a timeout in a IDE RAID
environment. To disable the feature, you can run a simple Western Digit=
al
utility to turn off a single bit in the drive=92s run-time configuratio=
n.
Disabling of this feature will NOT impact normal system operations in a
RAID environment. No firmware or hardware changes are required.


can this 'single bit' also be set with an linux util ? (like hdparm?)
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
