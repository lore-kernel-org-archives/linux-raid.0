From: Norman Schmidt <norman.schmidt@ratnet.stw.uni-erlangen.de>
Subject: partitions on md-devices - /dev-entries
Date: Fri, 12 Dec 2003 17:58:09 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3FD9F3A1.1010705@ratnet.stw.uni-erlangen.de>
Reply-To: schmidt@naa.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi raiders of the lost byte!

I just made some partitions on my new 740 GB md raid5. Unfortunately,=20
under suse8.2 no devices for the partitions (like /dev/md10p1) exist.

How do I generate them (i.e. which major/minor numbers should I invoke=20
mknod with)? Does somebody have a script to create them all at once?

By the way, the compilation and installation of the mdadm 1.4.0 source=20
on another (debian) machine didn=B4t generate them either.

Thanks, Norman.
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
