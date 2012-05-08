From: NeilBrown <neilb@suse.de>
Subject: Re: mdadm v3.1.3 spare group does not work
Date: Tue, 8 May 2012 12:20:29 +1000
Message-ID: <20120508122029.62488da5@notabene.brown>
References: <002b01cd2cbd$fd6ea3a0$f84beae0$@com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/qMJd7jQrYc72tW2BPxf3=ZE"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <002b01cd2cbd$fd6ea3a0$f84beae0$@com>
Sender: linux-raid-owner@vger.kernel.org
To: Johnson Yan <johnson_yan@usish.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/qMJd7jQrYc72tW2BPxf3=ZE
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue, 8 May 2012 09:57:57 +0800 "Johnson Yan" <johnson_yan@usish.com> wro=
te:

> Hi,
> When I use mdadm v3.1.3, seems the spare group function can=E2=80=99t wor=
k. As I
> remember, this function in mdadm 2.6.5 works well.

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
> Here is some info from /etc/mdadm.conf
> =E2=80=A6
> ARRAY /dev/md0 level=3Draid1 spare-group=3Dtest11
> ARRAY /dev/md1 level=3Draid1 spare-group=3Dtest11
> =E2=80=A6
>=20
>=20
> And mdmonitor service is in running status:
> [root@localhost tmp]# ps aux |grep mdadm
> root=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 1794=C2=A0 0.0=C2=A0 0.0=C2=A0=C2=A0 6=
852=C2=A0=C2=A0 760 ?=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Ss=C2=A0=C2=
=A0 16:52=C2=A0=C2=A0 0:00 mdadm -F -y
> -f -s -i /var/run/mdadm/mdadm.pid --delay=3D10
>=20
> There is one spare disk in md0, and no spare in md1, if I fail the member
> disk in md1, the spare in md0 won=E2=80=99t migrate into md1.
>=20
> Thank you very much.
>=20
> Regards,
> Johnson Yan
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/qMJd7jQrYc72tW2BPxf3=ZE
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT6iC7Tnsnt1WYoG5AQILwhAAkQzaqpUsPYRHCTztwO6RmKhQmbHTDKoP
kl39k328VKI7TTcc7OP9oiuY9rfLQiHVJ6M4hxirYQViVqlRuLAW/MTzgTeXecrw
PIET2WgcaoY0fifPMq5gjjgW1ZCv4dOXbTQiGSAgK0w4uUPsyS3vSD47B01uHvYO
DFXEuO27CuqTInIxYOmoe50G2MiP9BEiUNZr36P7iR5cspmB4pWCI8JG+O+IffBo
e59fx93RTYuulwY5I4PKT/5HR9aLdbx5pla8fBdTNszNAzYGde6F8KCU+ETsoCfJ
gZqi0TleVUsnjEkosjieS+yr+p5isBRTlPFp5/XUfuwTilvwY05lLjqtuh8gK7ey
mYkw4D3R/o+qFaor/pZJerWSjz2ZE+cjKOqC7FR+VBuNPRfh3Dxc5/7XIIXvtQTn
AbnIh9jxqtv8S3TqVhcMui/3EPeORSwQC21C6mRpR9EJXxorfju/nl2gOIVPi2sN
/ihKsfEPuu0yRY0Dm2wYImLQ6sWVL92rhmzZrmI07qIWyBRNjsrYJgGZWSLUz94B
oMmtSfYglUn2LrCJHRqvTNDtgCp7m9QF3C7dSiaCLppYhTdyB3pbXU5/mg0/YUVK
TXewt12gBMEgen+Epc+Q9Wzuuqpxth/9rxa7oAqRjswllC7qVnRs726FtCvcEHYN
n9gpGbRw1b8=
=LYfq
-----END PGP SIGNATURE-----

--Sig_/qMJd7jQrYc72tW2BPxf3=ZE--
