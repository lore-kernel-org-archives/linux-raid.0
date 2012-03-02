From: Lars =?UTF-8?B?VMOkdWJlcg==?= <taeuber@bbaw.de>
Subject: Re: grub2/grub-pc install not possible on mdadm
Date: Fri, 2 Mar 2012 10:06:48 +0100
Message-ID: <20120302100648.fe4e725f2e98880c839357b0@bbaw.de>
References: <4F4C9A11.9060302@profihost.ag>
	<4F4F4B1D.4050000@redhat.com>
	<4F4F4EB3.6030909@profihost.ag>
	<4F4F519E.7040206@redhat.com>
	<4F508864.4050600@profihost.ag>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F508864.4050600@profihost.ag>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Stefan,

Am Fri, 02 Mar 2012 09:44:20 +0100
Stefan Priebe - Profihost AG <s.priebe@profihost.ag> schrieb:
>=20
> > Looking at your original mail again - you are running a raid with
> > metadata 1.2, which means your BIOS will not know how to read the d=
isks
> > as a raid device.
> > You should be able to install grub into the MBR of /dev/sda or /dev=
/sdb.
> > I believe that is possible with 1.2 metadata. 1.1 was totally broke=
n for
> > this if I remember correctly.
>=20
> Correct that's why i've also tried to install it on sda / sdb but the=
n
> grub complains about not finding any partition table.

do you have a partition table inside the raid?
This will not work I expect. The kernel might find the partition table =
but
grub?

Or do you have no partition table at all and a filesystem directly on t=
he
raid device?

Lars
--=20
                            Informationstechnologie
Berlin-Brandenburgische Akademie der Wissenschaften
J=C3=A4gerstrasse 22-23                     10117 Berlin
Tel.: +49 30 20370-352           http://www.bbaw.de
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
