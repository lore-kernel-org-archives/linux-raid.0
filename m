From: Daniel Spannbauer <ds@marco.de>
Subject: Re: Raid1: sdb has a lot mor work then sda
Date: Tue, 24 Apr 2012 17:02:49 +0200
Message-ID: <4F96C099.6000506@marco.de>
References: <4F96BCC9.9080003@marco.de> <CABYL=To=tK8a0DVjvYeyuA2K4xChE3hv7Ppx+VvBTYfeZGgsjQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CABYL=To=tK8a0DVjvYeyuA2K4xChE3hv7Ppx+VvBTYfeZGgsjQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

here is a screendump of a atop -dD in such a situation.

Regards

Daniel




Am 04/24/2012 05:00 PM, schrieb Roberto Spadim:
> it=B4s a read, a write, or both operation?
> about load i think it=B4s a very big read (sdb) with a very low write=
 (sda)
> the disk balance on raid1 is based on nearest (current position - nex=
t
> read position) disk
> on a sequencial read only one disk is better used
>=20
> i checked that raid1 'have this problem' but it=B4s a hardware limit,=
 i
> didn=B4t found a solution, maybe others friends can found
>=20
> Em 24 de abril de 2012 11:46, Daniel Spannbauer <ds@marco.de
> <mailto:ds@marco.de>> escreveu:
>=20
>     Hello,
>=20
>     at the moment I'm trying to find a bottleneck on my lamp-server w=
ith
>     opensuse 11.4 (Kernel 2.6.37.6)
>=20
>     Sometimes the system has a very poor performance because of a hig=
h
>     io-wait.
>     If I watch the systems disk-access with "atop -dD" I can see that=
 sda is
>     the most of the time at a load of 10%, sdb sometimes is at 100% o=
r
>     higher at the same time.
>=20
>     In my opinion in a Raid1-System both disk should have nearly the
>     same load.
>=20
>     Or may I wrong whis this?
>=20
>     Both harddisks where changed 3 Weeks ago, /proc/mdstat shows that=
 the
>     rebuild was successfull and the array is functional. Today I've c=
hanged
>     th SATA-Cable and the Port on the Maindboard of sdb, but the beha=
viour
>     is still the same. Both disks passed the extended smart-self-test=
=2E
>=20
>     Any ideas about that?
>=20
>     Regards
>=20
>     Daniel
>=20
>=20
>=20
>     --
>     Daniel Spannbauer                         Software Entwicklung
>     marco Systemanalyse und Entwicklung GmbH  Tel   +49 8333 9233-27
>     <tel:%2B49%208333%209233-27> Fax -11
>     Rechbergstr. 4 - 6, D 87727 Babenhausen   Mobil +49 171 4033220
>     <tel:%2B49%20171%204033220>
>     http://www.marco.de/                      Email ds@marco.de
>     <mailto:ds@marco.de>
>     Gesch=E4ftsf=FChrer Martin Reuter             HRB 171775 Amtsgeri=
cht M=FCnchen
>     --
>     To unsubscribe from this list: send the line "unsubscribe linux-r=
aid" in
>     the body of a message to majordomo@vger.kernel.org
>     <mailto:majordomo@vger.kernel.org>
>     More majordomo info at  http://vger.kernel.org/majordomo-info.htm=
l
>=20
>=20
>=20
>=20
> --=20
> Roberto Spadim
> Spadim Technology / SPAEmpresarial


--=20
Daniel Spannbauer                         Software Entwicklung
marco Systemanalyse und Entwicklung GmbH  Tel   +49 8333 9233-27 Fax -1=
1
Rechbergstr. 4 - 6, D 87727 Babenhausen   Mobil +49 171 4033220
http://www.marco.de/                      Email ds@marco.de
Gesch=E4ftsf=FChrer Martin Reuter             HRB 171775 Amtsgericht M=FC=
nchen
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
