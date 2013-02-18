From: sk <sdk0084@yahoo.com>
Subject: Re: problems formatting raid5
Date: Mon, 18 Feb 2013 00:32:52 -0800 (PST)
Message-ID: <1361176372.31472.YahooMailNeo@web163005.mail.bf1.yahoo.com>
References: <1361174312.47911.YahooMailNeo@web163006.mail.bf1.yahoo.com> <alpine.DEB.2.00.1302180915080.32644@uplift.swm.pp.se>
Reply-To: sk <sdk0084@yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1302180915080.32644@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

i wait about 10 hours
and start after the resync process completed.=20
it was not mount so i don't think there were any activity.=20
sk




----- Original Message -----
=46rom: Mikael Abrahamsson <swmike@swm.pp.se>
To: sk <sdk0084@yahoo.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Sent: Monday, February 18, 2013 11:17 AM
Subject: Re: problems formatting raid5

On Sun, 17 Feb 2013, sk wrote:

> Hi There,
>=20
> I am trying to create file system on a software raid5 device but afte=
r while it hangs on:
>=20
> Writing superblocks and filesystem accounting information:
>=20
> i have tried with mkfs.ext4, and mke2fs as well but the result was th=
e same.
> any ideas what could be wrong ?

"iostat -x 5", check if there is activity going on. Start it before you=
 do the mkfs to make sure nothing is going on (for instance a resync) b=
efore you start creating the filesystem.

A large filesystem with ext3/ext4 takes quite a while to create. How lo=
ng did you wait until you decided it was "hung" ?

-- Mikael Abrahamsson=A0 =A0 email: swmike@swm.pp.se
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at=A0 http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
