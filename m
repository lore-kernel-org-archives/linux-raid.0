From: Jakob Oestergaard <jakob@unthought.net>
Subject: Re: Can't boot from /dev/md0 (RAID-1)
Date: Sun, 30 Jun 2002 20:04:19 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20020630180419.GE8557@unthought.net>
References: <200206301537.44139.roy@karlsbakk.net> <20020630162225.GB2335@colombina.comedia.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20020630162225.GB2335@colombina.comedia.it>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Jun 30, 2002 at 06:22:25PM +0200, Luca Berra wrote:
> On Sun, Jun 30, 2002 at 03:37:44PM +0200, Roy Sigurd Karlsbakk wrote:
> > I hope this is not OT - didn't find any LILO mailing list. after tr=
ying=20
> > virtually everything - can anyone help me with a tip?
> >=20
> >=20
> > Running 2.4.19-pre10-ac2, RedHat 7.3 (LILO version 21.4-4), I have =
root on=20
> > /dev/md0 on RAID-1 on /dev/hda1 and /dev/hdb1. I've tried the howto=
 at=20
> > http://www.tldp.org/HOWTO/mini/Boot+Root+Raid+LILO-3.html#ss3.1, bu=
t it still=20
> please someone update that blasted howto, lilo has been supporting bo=
ot from md
> for ages.

This has been in the Software-RAID HOWTO since january 2000.

>=20
> use:
> boot=3D/dev/md0
> map=3D/boot/map
> install=3D/boot/boot.b

This is indeed the correct way to do things.

Actually, on a Debian box I set up recently I needed to do the
following:

  boot=3D/dev/md0
  raid-extra-boot=3D/dev/sda,/dev/sdb

This tells LILO exactly where to write the MBRs - this is not usually
needed though.

--=20
=2E...............................................................
:   jakob@unthought.net   : And I see the elder races,         :
:.........................: putrid forms of man                :
:   Jakob =D8stergaard      : See him rise and claim the earth,  :
:        OZ9ABN           : his downfall is at hand.           :
:.........................:............{Konkhra}...............:
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
