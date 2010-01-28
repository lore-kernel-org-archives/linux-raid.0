From: Neil Brown <neilb@suse.de>
Subject: Re: [md PATCH 05/22] md/raid5: don't complete make_request on
 barrieruntil writes are scheduled
Date: Thu, 28 Jan 2010 13:44:22 +1100
Message-ID: <20100128134422.5c7c947e@notabene>
References: <20091204064802.10264.6658.stgit@notabene.brown>
	<AC5E1C3367E37D44970B81A6ADD1DA2C08AE0A83@SDCEXCHANGE01.ad.amcc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AC5E1C3367E37D44970B81A6ADD1DA2C08AE0A83@SDCEXCHANGE01.ad.amcc.com>
Sender: linux-raid-owner@vger.kernel.org
To: Tirumala Reddy Marri <tmarri@amcc.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 21 Jan 2010 13:07:44 -0800
"Tirumala Reddy Marri" <tmarri@amcc.com> wrote:

> I tried these patches and I still don=E2=80=99t see barriers working.=
 Do I have to enable to device mapper to see the effect ?
>=20
> =20

You would need to be sure that the component devices of md0 honour barr=
iers.
So try the same test on each component.  If they all work but md0 doesn=
't,
then ask again and I will look into it.

You would need to give more details, like what sort of array md0 is, wh=
at it's
component are, and exactly what kernel you are using.

NeilBrown


>=20
> =20
>=20
> -------- log -----
>=20
> ~ #=20
>=20
> ~ # mount -o barrier=3D1 /dev/md0 /mnt/tmpmnt/
>=20
> kjournald starting.  Commit interval 5 seconds
>=20
> EXT3 FS on md0, internal journal
>=20
> EXT3-fs: mounted filesystem with writeback data mode.
>=20
> ~ # touch /mnt/tmpmnt/test
>=20
> ~ # sync
>=20
> JBD: barrier-based sync failed on md0 - disabling barriers
>=20
> ~ #
>=20
> =20
>=20
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
