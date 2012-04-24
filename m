From: Daniel Spannbauer <ds@marco.de>
Subject: Raid1: sdb has a lot mor work then sda
Date: Tue, 24 Apr 2012 16:46:33 +0200
Message-ID: <4F96BCC9.9080003@marco.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

at the moment I'm trying to find a bottleneck on my lamp-server with
opensuse 11.4 (Kernel 2.6.37.6)

Sometimes the system has a very poor performance because of a high io-w=
ait.
If I watch the systems disk-access with "atop -dD" I can see that sda i=
s
the most of the time at a load of 10%, sdb sometimes is at 100% or
higher at the same time.

In my opinion in a Raid1-System both disk should have nearly the same l=
oad.

Or may I wrong whis this?

Both harddisks where changed 3 Weeks ago, /proc/mdstat shows that the
rebuild was successfull and the array is functional. Today I've changed
th SATA-Cable and the Port on the Maindboard of sdb, but the behaviour
is still the same. Both disks passed the extended smart-self-test.

Any ideas about that?

Regards

Daniel



--=20
Daniel Spannbauer                         Software Entwicklung
marco Systemanalyse und Entwicklung GmbH  Tel   +49 8333 9233-27 Fax -1=
1
Rechbergstr. 4 - 6, D 87727 Babenhausen   Mobil +49 171 4033220
http://www.marco.de/                      Email ds@marco.de
Gesch=C3=A4ftsf=C3=BChrer Martin Reuter             HRB 171775 Amtsgeri=
cht M=C3=BCnchen
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
