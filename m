From: NeilBrown <neilb@suse.de>
Subject: Re: resizing array devices not working?
Date: Tue, 26 Jun 2012 11:31:29 +1000
Message-ID: <20120626113129.09275333@notabene.brown>
References: <4FE33B89.40007@ubuntu.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/7jg_zw7z05SCfV34r+t3nMQ"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4FE33B89.40007@ubuntu.com>
Sender: linux-raid-owner@vger.kernel.org
To: Phillip Susi <psusi@ubuntu.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/7jg_zw7z05SCfV34r+t3nMQ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 21 Jun 2012 11:19:37 -0400 Phillip Susi <psusi@ubuntu.com> wrote:

> I was trying to do a little experiment with resizing devices.  I created=
=20
> two 1g logical volumes and built a raid1 array out of them, then=20
> lvresized the volumes to 2g, then ran:
>=20
> mdadm -G -z max /dev/md1
>=20
> That SHOULD expand the array to use the extra space right?  It keeps=20
> telling me that it set the size to just 1g.

Maybe you need a newer mdadm - 3.2.2 or newer might be required.  but you
didn't say which version you were using, or which kernel.

Or maybe you have 0.90 metadata and a kernel earlier than 3.1 that imposed
some limits, but I think that allows up-to 2GB, not upto 1, so that can't be
the problem.

Maybe you can just
 for i in /sys/block/md1/md/dev-*
 do echo 0 > $i/size
 done

and try again. '0' means 'max' in this context.

NeilBrown

--Sig_/7jg_zw7z05SCfV34r+t3nMQ
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT+kQ8Tnsnt1WYoG5AQJfjQ//fip1PmD9nRXxcCr7DBudeIDD9y7Bfki/
NeiNsCVlfIvBxArtmsgm0ioUHZcvMimaBJBAEbmyK5H9oSwJcQUpj9I1zIGp+t4M
t/M/IkuBmYsb+/XyfeUW1SsD88uxanujlMWP7Q/544WjvoSVPwXqpT/v0O9AsvGx
ajQlBzRbSI57gLH3da34kiUqraxwrgmYk9eBdDWQV44SacigYh6bZpHPLJV8q/bE
W2t2uiIpGsH6HM5NU3eq5ga7kwx4KKeCZWldyJWGODAv4ba7jbkqLopLfhdUzAQk
Ca2n3iJhBgL2PwM0AgMM2E6mrs8ylkdMntDyjcP87fu6x87outtruVRx7bWmP+n+
bkDmxgXCsytc1nzQaZ0LfUA90zYKuqcE9vzN499gob1xC1Wu44YVimtrwg9mN+4L
lbCLwIfea4mfDZhF2dMdT7ScVbK/F5qzZm3hEIWBoBKNHN+CFSg03cdgLL3Cyc4Q
xvNIxCAan2zLyT2hbTTTg/QGgdQbcQlL2vIL3uSjgoC2DmIyQArKN/kmB8VHLcUS
PB27f930muk+sK/3C6Fi0iZOWCIzDK+iO+gLjsOLk1Exzc0gW/u1ipfg17Y5jMua
xpfat2/ZGTN1bOHlpltf71aqXasdtoxuPXTSuJXBLNwvXa2QdEV1khCIgnE1Pyle
SJS2lzRHDK8=
=dbym
-----END PGP SIGNATURE-----

--Sig_/7jg_zw7z05SCfV34r+t3nMQ--
