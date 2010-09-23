From: Roman Mamedov <roman@rm.pp.ru>
Subject: Re: mdadm raid5 array - 0 space available but usage is less than
 capacity
Date: Fri, 24 Sep 2010 02:18:45 +0600
Message-ID: <20100924021845.2c7ee01b@natsu>
References: <AANLkTi=XoxYmj8G5+GadCCTxQGJqpMttmU3NMH_vtKYM@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/cDYCY450sbKhnhtNoNOlteE"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=XoxYmj8G5+GadCCTxQGJqpMttmU3NMH_vtKYM@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Robin Doherty <rdoherty@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/cDYCY450sbKhnhtNoNOlteE
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 23 Sep 2010 20:43:44 +0100
Robin Doherty <rdoherty@gmail.com> wrote:

> So maybe this is a file system problem rather than an mdadm problem?

mkfs.ext3 says:

       -m reserved-blocks-percentage
              Specify the percentage of the filesystem blocks reserved for =
the
              super-user.   This  avoids  fragmentation, and allows root-ow=
ned
              daemons, such as syslogd(8), to continue to  function  correc=
tly
              after non-privileged processes are prevented from writing to =
the
              filesystem.  The default percentage is 5%.

this can be changed on an existing FS using tune2fs.

Also, this is not related to mdadm at all.

--=20
With respect,
Roman

--Sig_/cDYCY450sbKhnhtNoNOlteE
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkybtiUACgkQTLKSvz+PZwiFyACggGo68zHdH1tiokiYwKUQVs02
CjQAn1hlCK2VXPEbVJdIfuNPuwW8b2XX
=IikG
-----END PGP SIGNATURE-----

--Sig_/cDYCY450sbKhnhtNoNOlteE--
