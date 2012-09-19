From: =?ISO-8859-1?Q?G=FCnther_J=2E?= Niederwimmer <gjn@gjn.priv.at>
Subject: GPT Table broken on a Raid1
Date: Wed, 19 Sep 2012 13:03:44 +0200
Message-ID: <4961154.0TR9MeFlIq@techz>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

can any tell me, why the GPT Table is broken by a linux installation

I have a dual boot system, the GPT Table is created with Win "diskpart"=
 This=20
is a (U)EFI installation.

With linux kernel 3.5.x, I have always this message in the log

Sep 17 09:54:27 techz kernel: [    1.204681] GPT:Primary header thinks =
Alt.=20
header is not at the end of the disk.
Sep 17 09:54:27 techz kernel: [    1.204685] GPT:625137663 !=3D 6251424=
47
Sep 17 09:54:27 techz kernel: [    1.204687] GPT:Alternate GPT header n=
ot at=20
the end of the disk.
Sep 17 09:54:27 techz kernel: [    1.204689] GPT:625137663 !=3D 6251424=
47
Sep 17 09:54:27 techz kernel: [    1.204691] GPT: Use GNU Parted to cor=
rect=20
GPT errors.
Sep 17 09:54:27 techz kernel: [    1.204710]  sdb: sdb1 sdb2 sdb3 sdb4 =
sdb5=20
sdb6
Sep 17 09:54:27 techz kernel: [    1.205613] sd 1:0:0:0: [sdb] Attached=
 SCSI=20
disk
Sep 17 09:54:27 techz kernel: [    1.212374] GPT:Primary header thinks =
Alt.=20
header is not at the end of the disk.
Sep 17 09:54:27 techz kernel: [    1.212377] GPT:625137663 !=3D 6251424=
47
Sep 17 09:54:27 techz kernel: [    1.212379] GPT:Alternate GPT header n=
ot at=20
the end of the disk.
Sep 17 09:54:27 techz kernel: [    1.212381] GPT:625137663 !=3D 6251424=
47
Sep 17 09:54:27 techz kernel: [    1.212382] GPT: Use GNU Parted to cor=
rect=20
GPT errors.
Sep 17 09:54:27 techz kernel: [    1.212404]  sda: sda1 sda2 sda3 sda4 =
sda5=20
sda6


When I like to repair this with parted the system is not booting and th=
e Raid1=20
is destroyed.=20

--=20
mit freundlichen Gr=FC=DFen / best Regards.

  G=FCnther J. Niederwimmer
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
