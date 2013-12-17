From: NeilBrown <neilb@suse.de>
Subject: Re: What can be used instead of /dev/disk/by-path/* symlinks?
Date: Tue, 17 Dec 2013 20:40:55 +1100
Message-ID: <20131217204055.353e5970@notabene.brown>
References: <D9FFE20C522965449E182ACE73889AEB1A69A1E3@IRSMSX105.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/CMCIk3_Q5=lg=tix+jP9jBl"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <D9FFE20C522965449E182ACE73889AEB1A69A1E3@IRSMSX105.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Dorau, Lukasz" <lukasz.dorau@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Baldysiak, Pawel" <pawel.baldysiak@intel.com>
List-Id: linux-raid.ids

--Sig_/CMCIk3_Q5=lg=tix+jP9jBl
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 17 Dec 2013 09:10:44 +0000 "Dorau, Lukasz" <lukasz.dorau@intel.com>
wrote:

> Hi Neil,

I'd really rather people addressed thing to the list, not just to me.  There
are many competent and interested people here other than me, and you
should expect them to have an opinion and ask for it.

Personally, I really don't care.  Does anyone know what udev changed?  Maybe
we should ask udev developers to change it back.

NeilBrown

>=20
> The /dev/disk/by-path/* symlinks are not created for ATA devices in syste=
ms using systemd v182+, so mdadm cannot use them in case of policies and ud=
ev rules (mdadm -If --path=3D...)
>=20
> What do you think - what should be used instead? The symlinks from /sys/b=
lock/* ?
>=20
> Regards,
> Lukasz
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/CMCIk3_Q5=lg=tix+jP9jBl
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBUrAcJznsnt1WYoG5AQJX4Q//euA1w80ah20MQUHM30jtaB5NhpR/lzT2
jphXwabqcpR8e2Vxhf+rUCIWERpWZ9IIenO1XmEHd46j2ALw/N2pBxKJdhsAGZE7
oRN+R7/WS7mMqPg0z8nv+eR8l+pDxzg3JSrbGHbD+P0ePgpy6AVgL2Y0iPgb3IHu
tSB14lKYAOMF44P0cM5XJt6W3awawkJyYUFu2pSuwQjQ8jOaM4FgFL/r43iSO83j
0xhwZitPLHxw1FL9TgucZHQFrWfvTsl3De4ZTSckDZRKBExDX7PdRT70yi1k9Evp
XtoimSMweFIfHPoaxI1Wox2cAp8xx3JVzwGi9wrhQonfF9MlH6LjecAlPp4HHomp
+Vn0FKWB6Jz45iBdVVLXkElOuRPnOi5ASxDuSOV8y8Q3TnmOUJXx/xPkqRviWFI3
j0HCKowxddMcG1JlHO8QGJCrehG62BlnA57cejNDCk1i18w5ie4lQfzNhBNImnta
orrZWqL5dtw/ZPOGdhCGsXankO7IGWWT5DmPWOSvL/eu4lxhGkjQplF4r8aXol1Y
qmDLTEL0V+hcGWzBEtBN4/jWTmoBIADtABeAzeN1kYa7X/yon6/DNL9PHt36rAW8
Zq48iaCtDGfEAEnVlD46awPzQeoRqJqhP1qbhIcqpsKD3BadKXioAr2ZR7TSgRCE
SWg06kKc34M=
=VJv8
-----END PGP SIGNATURE-----

--Sig_/CMCIk3_Q5=lg=tix+jP9jBl--
