From: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
Subject: Re: I/O errors without erros from underlying device
Date: Tue, 8 Dec 2015 12:05:48 +0100
Message-ID: <201512081205.48777.a.miskiewicz@gmail.com>
References: <201512071705.27177.a.miskiewicz@gmail.com> <22117.49283.546268.719858@quad.stoffel.home> <201512072146.28378.a.miskiewicz@gmail.com>
Reply-To: arekm@maven.pl
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201512072146.28378.a.miskiewicz@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday 07 of December 2015, Arkadiusz Miskiewicz wrote:

> Anyway I would expect my problem to be related to badblock lists whic=
h
> numbers are close to dmesg error message: [  848.988518] Buffer I/O e=
rror
> on dev md7, logical block 3907148544, async page read
>=20
> > >> http://sprunge.us/XSWI
>=20
> But how to repair these if write() also fails and
> http://www.spinics.net/lists/raid/msg49325.html suggests that write s=
hould
> "fix" these (by using replacement blocks I guess) ?

Tried to get rid of badblock lists (well, corruption in that area is be=
tter=20
than no access at all):

mdadm --assemble /dev/md7 --force --update=3Dno-bbl
mdadm: Cannot remove active bbl from /dev/sdae1
mdadm: Cannot remove active bbl from /dev/sdag1
mdadm: Cannot remove active bbl from /dev/sdai1
mdadm: Cannot remove active bbl from /dev/sdn1
mdadm: Cannot remove active bbl from /dev/sdg
mdadm: Cannot remove active bbl from /dev/sdad1
mdadm: /dev/md7 has been started with 10 drives.

Is there a way to archieve that anyway?

--=20
Arkadiusz Mi=B6kiewicz, arekm / ( maven.pl | pld-linux.org )
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
