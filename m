From: Lars =?UTF-8?B?VMOkdWJlcg==?= <taeuber@bbaw.de>
Subject: Re: equal size not large enough for RAID1?
Date: Thu, 6 Mar 2008 10:11:57 +0100
Message-ID: <20080306101157.52d482b3.taeuber@bbaw.de>
References: <20080305100547.2634bd04.taeuber@bbaw.de>
	<18383.24086.165437.659336@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18383.24086.165437.659336@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,

Neil Brown <neilb@suse.de> schrieb:
> On Wednesday March 5, taeuber@bbaw.de wrote:
> > Hallo list,
>=20
> Hi.
>=20
> >=20
> > monosan# cat /proc/partitions:
> >    9     4 12697912448 md4
> >    9     9 12697912312 md9
> >  152  5632 12697912448 etherd/e22.0
> >=20
> >=20
> > monosan:~ # cat /proc/mdstat=20
> > Personalities : [raid1] [raid0] [raid6] [raid5] [raid4]=20
> > md9 : active raid1 md4[0]
> >       12697912312 blocks super 1.0 [2/1] [U_]
> >      =20
> > md4 : active raid6 dm-0[0] dm-8[14] dm-7[13] dm-6[12] dm-5[11] dm-4=
[10] dm-3[9] dm-2[8] dm-14[7] dm-13[6] dm-12[5] dm-11[4] dm-10[3] dm-9[=
2] dm-1[1]
> >       12697912448 blocks level 6, 64k chunk, algorithm 2 [15/15] [U=
UUUUUUUUUUUUUU]
> >=20
> >=20
> >=20
> > But then this:
> > monosan:~ # mdadm /dev/md9 -a /dev/etherd/e22.0=20
> > mdadm: /dev/etherd/e22.0 not large enough to join array
>=20
> This would be because mdadm is reserving a bit of space in case you
> want to add an internal bitmap one day.  And the version of mdadm you
> are now using is reserving more space than the version that was used
> to create the array does.

we are using SuSE 10.3 here. And I don't remember if mdadm was updated =
due to an online update. But I think it should be consistent/compatible=
 with the version shipped in the original distribution.

What is this internal bitmap good for? Is there a documentation somewhe=
re on the net about this?


>=20
> I should fix that...
>=20
> If you want a quick fix and are happy to compile your own mdadm, then
> edit super1.c and remove the line
>=20
> 	devsize -=3D choose_bm_space(devsize);
>=20
> in avail_size1().

I could compile, but on our productive server we don't compile anything=
 that is shipped with the distribution due to the possibility to have s=
ecurity updates from SuSE.

I just repeated the following:

monosan:~ # mdadm -C /dev/md9 -l1 -n2 -x0 /dev/md4 /dev/etherd/e22.0=20
mdadm: Defaulting to verion 1.0 metadata
mdadm: /dev/md4 appears to be part of a raid array:
    level=3Draid1 devices=3D2 ctime=3DThu Mar  6 09:39:37 2008
mdadm: /dev/etherd/e22.0 appears to be part of a raid array:
    level=3Draid1 devices=3D2 ctime=3DThu Mar  6 09:39:37 2008
Continue creating array? y
mdadm: array /dev/md9 started.

monosan:~ # mdadm -V
mdadm - v2.6.2 - 21st May 2007

monosan:~ # mdadm /dev/md9 -f /dev/etherd/e22.0=20
mdadm: set /dev/etherd/e22.0 faulty in /dev/md9

monosan:~ # mdadm /dev/md9 -r /dev/etherd/e22.0=20
mdadm: hot removed /dev/etherd/e22.0

monosan:~ # mdadm /dev/md9 -a /dev/etherd/e22.0=20
mdadm: /dev/etherd/e22.0 not large enough to join array

monosan:~ # cat /etc/SuSE-release=20
openSUSE 10.3 (X86-64)
VERSION =3D 10.3

How come?

Thanks
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
