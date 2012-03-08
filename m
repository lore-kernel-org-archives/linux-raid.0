From: Arkadiusz =?utf-8?q?Mi=C5=9Bkiewicz?= <a.miskiewicz@gmail.com>
Subject: Re: invalid bitmap file superblock: bad magic
Date: Thu, 8 Mar 2012 21:24:21 +0100
Message-ID: <201203082124.21661.a.miskiewicz@gmail.com>
References: <201203081711.17836.a.miskiewicz@gmail.com> <20120309070041.558a4ca6@notabene.brown>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120309070041.558a4ca6@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday 08 of March 2012, NeilBrown wrote:
> On Thu, 8 Mar 2012 17:11:17 +0100 Arkadiusz Mi=C5=9Bkiewicz
>=20
> <a.miskiewicz@gmail.com> wrote:
> > Hello.
> >=20
> > I'm trying to create internal bitmap on freshly created
> > raid1 array on 3.2.6 kernel.
> >=20
> > What's going on and how to fix this problem?
>=20
> There is a bug in the latest mdadm which causes this.
> It is fixed in git,=20

Which commit is that?

--=20
Arkadiusz Mi=C5=9Bkiewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
