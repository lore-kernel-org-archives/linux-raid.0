From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: Checksumming RAID? / SCSI SAS T10 PI and DIF/DIX / T13 SATA EPP
Date: Wed, 05 Dec 2012 14:05:43 -0500
Message-ID: <yq1vccgjp4o.fsf@sermon.lab.mkp.net>
References: <14319197.21.1353936449959.JavaMail.root@zimbra>
	<20121203122444.GV8912@reaktio.net>
	<20121203140946.GW8912@reaktio.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20121203140946.GW8912@reaktio.net> ("Pasi =?utf-8?Q?K=C3=A4r?=
 =?utf-8?Q?kk=C3=A4inen=22's?= message
	of "Mon, 3 Dec 2012 16:09:46 +0200")
Sender: linux-raid-owner@vger.kernel.org
To: Pasi =?utf-8?B?S8Okcmtrw6RpbmVu?= <pasik@iki.fi>
Cc: Roy Sigurd Karlsbakk <roy@karlsbakk.net>, Linux Raid <linux-raid@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-raid.ids

>>>>> "Pasi" =3D=3D Pasi K=C3=A4rkk=C3=A4inen <pasik@iki.fi> writes:

Pasi> Now I remember.. it's the SATA T13 "External Path Protection"
Pasi> (EPP).

EPP is dead. So is SATA. Not going to happen.


Pasi> (Added CC to Martin in the case he has some thoughts about generi=
c
Pasi> Linux checksumming RAID without T10 PI disks..)

There have been a few attempts at a checksumming DM target. However, I
think btrfs is a much better solution for this stuff.

--=20
Martin K. Petersen	Oracle Linux Engineering
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
