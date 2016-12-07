From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH v2 09/12] raid5-ppl: read PPL signature from IMSM metadata
Date: Wed, 07 Dec 2016 12:25:55 +1100
Message-ID: <871sxk4jj0.fsf@notabene.neil.brown.name>
References: <20161205153113.7268-1-artur.paszkiewicz@intel.com> <20161205153113.7268-10-artur.paszkiewicz@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161205153113.7268-10-artur.paszkiewicz@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Artur Paszkiewicz <artur.paszkiewicz@intel.com>, shli@kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Tue, Dec 06 2016, Artur Paszkiewicz wrote:

> The PPL signature is used to determine if the stored PPL is valid for a
> given array. With IMSM, the PPL signature should match the
> orig_family_num field of the superblock. To avoid passing this value
> from userspace, it can be read from the IMSM MPB when initializing the
> log.

It is up to mdadm to determine if the PPL is valid.  It would only tell
the kernel that a PPL exists if it is valid...

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlhHZSMACgkQOeye3VZi
gbmTjA/8CHrzKwrp3KeGwdFhD4nXocpTXdWFF6PYg5HaHCK53esCS3gMIdk9QpvX
/X9HtG5hliubZGefAw1jSgHyqAKdbDApsS9XsfFDb2QROohywUvt/i8yQd7W4nGA
mJ+SOhEkEEd07QGphoQHvrKTFJ/daa2oml6kqxX6Q1/Fg43kPljTEj0vIeudEfvB
pRYSek+ZqHZS8R/s+nOSnbkZEU55g2ZiGq3A6/RJWIRoULXyqLcUC3hjvsX0FGKr
NM4Ast4+vTbZLg/OKFH7BRuKCZhfu6y0Qb6Lr35kNs4agsjt56Qa7A/TGWC6hvuz
gRg66SBCQevjl11VrLguFXUdS2j3IZyABXdcjyf1ZoAmqz/1qUi08xfVqql31HwN
7k4mOIgZvh39w9oJXqnOL522f+4m1EGL99KkPzYLcqahTldwX9xx0Vk2AT2FpD+k
KQJ7bw2ByOZWp1ech4IkdAlpeyi7dNWvcqk2/nXViJrNAHYEv32xnH2D6njoUvHZ
E/cWUgYQ0wfKCvHDPSjiUJvkKTP8RXH4/ItAXwCMxn74SJixeocOMP8hbvDJV4D3
ifyozzUZMlTKbuVTnkGsX8kRfLfDkohs7zWEaDwVs/8PqBrrTqt3C4ntkfK2oYZZ
IMLcpfawSKlrLKrCPwXz0zFTF+dNN5HwOiJNMEG5/4YoVL18Vu4=
=m8+g
-----END PGP SIGNATURE-----
--=-=-=--
