From: "Johnson Yan" <johnson_yan@usish.com>
Subject: RE: mdadm v3.1.3 spare group does not work
Date: Tue, 8 May 2012 11:05:04 +0800
Message-ID: <007301cd2cc7$5db3c930$191b5b90$@com>
References: <002b01cd2cbd$fd6ea3a0$f84beae0$@com> <20120508122029.62488da5@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120508122029.62488da5@notabene.brown>
Content-Language: zh-cn
Sender: linux-raid-owner@vger.kernel.org
To: 'NeilBrown' <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,
Thank you for your advice, I tried 3.2.3, it still failed.

Regards,
Johnson Yan

-----Original Message-----
=46rom: NeilBrown [mailto:neilb@suse.de]=20
Sent: Tuesday, May 08, 2012 10:20 AM
To: Johnson Yan
Cc: linux-raid@vger.kernel.org
Subject: Re: mdadm v3.1.3 spare group does not work

On Tue, 8 May 2012 09:57:57 +0800 "Johnson Yan" <johnson_yan@usish.com>=
 wrote:

> Hi,
> When I use mdadm v3.1.3, seems the spare group function can=E2=80=99t=
 work. As=20
> I remember, this function in mdadm 2.6.5 works well.

Can you try mdadm 3.2.3 please (or is that what you meant?).
Better still, try the current git version:

  git clone git://github.com/neilbrown/mdadm
  cd mdadm
  make
  make install

Thanks,
NeilBrown

>=20
>=20
> Here is some info from /etc/mdadm.conf =E2=80=A6 ARRAY /dev/md0 level=
=3Draid1=20
> spare-group=3Dtest11 ARRAY /dev/md1 level=3Draid1 spare-group=3Dtest1=
1 =E2=80=A6
>=20
>=20
> And mdmonitor service is in running status:
> [root@localhost tmp]# ps aux |grep mdadm root      1794  0.0  0.0  =20
> 6852   760 ?        Ss   16:52   0:00 mdadm -F -y -f -s -i=20
> /var/run/mdadm/mdadm.pid --delay=3D10
>=20
> There is one spare disk in md0, and no spare in md1, if I fail the=20
> member disk in md1, the spare in md0 won=E2=80=99t migrate into md1.
>=20
> Thank you very much.
>=20
> Regards,
> Johnson Yan
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
=20
> in the body of a message to majordomo@vger.kernel.org More majordomo=20
> info at  http://vger.kernel.org/majordomo-info.html


--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
