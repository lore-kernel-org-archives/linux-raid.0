From: Arkadiusz =?utf-8?q?Mi=C5=9Bkiewicz?= <a.miskiewicz@gmail.com>
Subject: Re: invalid bitmap file superblock: bad magic
Date: Thu, 8 Mar 2012 17:55:50 +0100
Message-ID: <201203081755.51012.a.miskiewicz@gmail.com>
References: <201203081711.17836.a.miskiewicz@gmail.com> <CAOPY+weSBif2Lqwnu5wKMOCPqAf2ZApu1-sLxmuP5JU-M0GZsQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAOPY+weSBif2Lqwnu5wKMOCPqAf2ZApu1-sLxmuP5JU-M0GZsQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Kai Stian Olstad <kai.stian.olstad@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday 08 of March 2012, Kai Stian Olstad wrote:
> On Thu, Mar 8, 2012 at 5:11 PM, Arkadiusz Mi=C5=9Bkiewicz
>=20
> <a.miskiewicz@gmail.com> wrote:
> > I'm trying to create internal bitmap on freshly created
> > raid1 array on 3.2.6 kernel.
> >=20
> > What's going on and how to fix this problem?
> >=20
> > [root@setebos ~]# mdadm /dev/md3 --grow --bitmap=3Dinternal
>=20
> Wrong syntax, try:
> mdadm --grow /dev/md3 --bitmap=3Dinternal

Doesn't change anything. The same problem.

--=20
Arkadiusz Mi=C5=9Bkiewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
