From: Norman Schmidt <norman.schmidt@ratnet.stw.uni-erlangen.de>
Subject: partitions on software-raid
Date: Tue, 16 Dec 2003 16:44:29 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3FDF285D.806@ratnet.stw.uni-erlangen.de>
Reply-To: schmidt@naa.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi!

Since noone has answered my last question yet:

Has anyone ever used partitions on a md device? It is possible to make=20
them with fdisk, and fdisk shows their names as /dev/md0p1 (eg.). They=20
are also shown in the partition table. But there are no /dev entries.

There are very few google hits, but no successful tries are documented.

Is this functionality implemented yet? I do not understand much C, so I=
=20
gave up on understanding md.c in the kernel source tree. In the=20
up-to-date list of major and minor numbers, there are no entries=20
concerning partitions on md devices.

I think Neil Brown stated somewhere on this list that there could be up=
=20
to 15 partitions for up to 16 md devices, but I don=B4t remember, could=
n=B4t=20
find it, and I don=B4t know wether he told how to make the devices or=20
mount those partitions.

I am willing to test if this functionality exists, if not, I am forced=20
to partition the underlying drives.

Thank you for the help, Norman Schmidt.

--=20
--

Norman Schmidt          Institut fuer Physikal. u. Theoret. Chemie
Dipl.-Chem.             Friedrich-Alexander-Universitaet
schmidt@naa.net         Erlangen-Nuernberg

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
