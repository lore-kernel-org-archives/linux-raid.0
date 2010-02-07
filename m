From: =?ISO-8859-15?Q?Stefan_H=FCbner?=
	<stefan.huebner@stud.tu-ilmenau.de>
Subject: recovery problems, might be driver-related
Date: Sun, 07 Feb 2010 14:38:18 +0100
Message-ID: <4B6EC24A.9040703@stud.tu-ilmenau.de>
Reply-To: stefan.huebner@stud.tu-ilmenau.de
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Everybody,

I've recently come across some RAID-Recovery problem that were kind of
not-so-easy-to-understand.  I was trying to recover damaged RAID5s,
where one
disk died and another dropped out (most likely due to read error recove=
ry
timeout / not reporting back while error recovery was active) during
resync with
a spare/new disk.  After taking double backups I tried to recreate the
raid with
the needed working disk images (to make the superblocks consistent).  D=
uring
that action mdadm told me that the last-dropped disk contained a valid =
ext3
filesystem and was obviously part of an md-array.

This happened with NAS-Devices from 2 different Vendors (namely Thecus =
and
Synology), which made me think it must be a md-raid thing.  Does md-rai=
d
create
a filesystem after a disk dropped out?  Or may something in the system
happen to
cause this strange behaviour?

All in all: after recreating the raids the filesystem contained on it w=
as
totally damaged (could not even be mounted).  fsck ran multiple days wi=
th
excessive data loss.

P.S.: the mdadm-lines to recreate the RAIDs were derived from mdadm -E =
-
outputs
of the original partitions, so I believe that it should have worked (on
other
recoveries I did before it also worked well).

Does anyone have an idea what is going on there?  Or may it have happen=
ed -
well, I don't want to say something that could get me sued.

All the best,
Stefan H=FCbner
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
