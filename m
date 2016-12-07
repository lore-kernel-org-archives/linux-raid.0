From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH v2 11/12] raid5-ppl: support disk add/remove with distributed PPL
Date: Wed, 07 Dec 2016 12:29:52 +1100
Message-ID: <87wpfc34rz.fsf@notabene.neil.brown.name>
References: <20161205153113.7268-1-artur.paszkiewicz@intel.com> <20161205153113.7268-12-artur.paszkiewicz@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161205153113.7268-12-artur.paszkiewicz@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Artur Paszkiewicz <artur.paszkiewicz@intel.com>, shli@kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Tue, Dec 06 2016, Artur Paszkiewicz wrote:

> Add a function to modify the log by adding or removing an rdev when a
> drive fails or is added as a spare.
>
> Adding a drive to the log is as simple as initializing and adding a new
> child log, removing a drive is more complicated because it requires
> stopping the child log and freeing all of its resources. In order to do
> that, we busy wait for any submitted log bios to complete and then
> manually finish and free the io_units. No new log requests will happen
> at this point. A new list is added to struct r5l_io_unit to have access
> to stripes that have been written to the log but are not completely
> processed yet.

Busy-wait for IO to finish?  Seriously?

At the very very least you need to cond_resched() in there, but an
actual wait would be much better.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlhHZhAACgkQOeye3VZi
gbnXog/9FoTh7rj6m0qmzksbi2tq6A3zzEe6X+Pkka/uNoqvnB1D5PMgOW4CJ1i1
2S+eufABsH3O53FOsnFFQiDQ2/ZmdWs6FDDSJy6kZFSJ37AFIVezDJjXOgNwF77T
/qi4P8THshYSKoig84uHAVsPyD0l0JCelaIEfLmgC5kBwdhxO3jU55hBEtuMCzZs
SqgZhM+MhfPxensXg2vauCLTWyRJNzJ+Nav1EjuEV+ZvuVY9S7agDGBN+1ma1a5G
K3WJFzcg61pd2xULMkFWdNcA2cWYyXpkQFnKdy+vXY7fxJL7mRiVS5tEkXApzh2+
UeuhnIqATA+BgWnTvFC8nYvwkeOmSIhZcW+Ud9e6T/Yyk0jwKbLRi0u0bWyvhOcQ
kTV1vmH/Rd8scGu2mjEylm8dZKqDZwOBRgTCiXJRz3cbEB4KEXOQSvCCHp5yGKH4
7D2gOGdoVgdDQ7lGkANCLODBnpO7f1bwrVyn2Gj9DTmxoWo3za4sxA0RFL0/QeeT
iDC7HeqXA6LzEayXGijqVNKypz2KLCfy6p7G0FDqVWXEh1glbkppsWxFDi8ecbgT
zicWGmyeulFWZjz77NMwGNP3TD7NRStMTO1cTA5DaBpgxZ/QLyYWjJ5M6TPf2VZ+
4DD2o5VAd5Lsx7p1B37x2o4Nb9m2C7ah0/qA+kKbO+41TL0LdEs=
=4dpa
-----END PGP SIGNATURE-----
--=-=-=--
