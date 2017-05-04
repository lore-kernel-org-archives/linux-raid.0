From: NeilBrown <neilb@suse.com>
Subject: Re: RAID creation resync behaviors
Date: Thu, 04 May 2017 11:07:01 +1000
Message-ID: <87inlhpgzu.fsf@notabene.neil.brown.name>
References: <20170503202748.7r243wj5h4polt6y@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170503202748.7r243wj5h4polt6y@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org
Cc: jes.sorensen@gmail.com, neilb@suse.de
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Wed, May 03 2017, Shaohua Li wrote:

> Hi,
>
> Currently we have different resync behaviors in array creation.
>
> - raid1: copy data from disk 0 to disk 1 (overwrite)
> - raid10: read both disks, compare and write if there is difference (compare-write)
> - raid4/5: read first n-1 disks, calculate parity and then write parity to the last disk (overwrite)
> - raid6: read all disks, calculate parity and compare, and write if there is difference (compare-write)

The approach taken for raid1 and raid4/5 provides the fastest sync for
an array built on uninitialised spinning devices.
RAID6 could use the same approach but would involve more CPU and so
the original author of the RAID6 code (hpa) chose to go for the low-CPU
cost option.  I don't know if tests were done, or if they would still be
valid on new hardware.
The raid10 approach comes from "it is too hard to optimize in general
because different RAID10 layouts have different trade-offs, so just
take the easy way out."

>
> Write whole disk is very unfriendly for SSD, because it reduces lifetime. And
> if user already does a trim before creation, the unncessary write could make
> SSD slower in the future. Could we prefer compare-write to overwrite if mdadm
> detects the disks are SSD? Surely sometimes compare-write is slower than
> overwrite, so maybe add new option in mdadm. An option to let mdadm trim SSD
> before creation sounds reasonable too.

An option to ask mdadm to trim the data space and then --assume-clean
certainly sounds reasonable.

One possible approach would be to use compare-write until some
threshold of writes were crossed, then switch to over-write.  That could
work well for RAID1, but could be awkward to manage for RAID5.
Possibly mdadm could read the first few megas of each device in RAID5
and try to guess if many writes will be needed.  If they will, the
current approach is best.  If not, assemble the array so that
compare-write is used.

I'm in favour of providing options and making the defaults "not
terrible".  I think they currently are "not terrible", but maybe they
can be better in some cases.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlkKfrUACgkQOeye3VZi
gbnDPQ/6A/SEG+L/wyBIT28Mo789PXJFW0BCT0GNV2LROMFqhwcS7Hv3bNUBBabm
SuQo1VMDQQxBJNSEZxG2hL3RAf0LWRNXZkJFl8DHnlAworRISVabdUD+vb0LWzBQ
MPy9bFvrlE7cOeQtxzuXbNq0jGxx/wQROcCEfNLfizTtc/pipZQcetpP1KPiBpE5
JVfr1AqW3G86JS8n0iFS/1iY9o92VfQ5Wa+Ph0EQEYaGL0O88qAd6So1EzSBOslv
E8wtWr7EZw0yu4FC2NOEeGEGajg8cH+AaVWL/my9iYlsfgc+nzo6InEZ5FJj4jlF
9c+fsNOQZr5CeYAvF911jqyw/XzYT2mZD+udPPKf65TyMmho+ut0vtc1Z+yVCZ0a
YXWYv98J46R4aMSmdNINcQhjWWdy4nDGowsGVIEosthYX19cZmBbn5Z9YgScLEd9
YKYYc5iOwFWPdgFNRteiO1qHsRGlLJ+J/aInsgKs+70KjLNgyUl0ej8w9VRkbCNM
rzaXbYB29JHZJwc7rFfWG2jG4691dThNIi+D7Vt4tre0XGdeIlhwicUuqkxgIdb/
ihPsj8EqRTHLxWpeh5aHAS//qYcsTPEHQjUNxMTUBRyL3fCUC94wEMEgTitVvF7X
nPTYSq6E3XrF+h9KpI0zl0khRT2I83vgDMJu5fZwzY7I/vP4ZJA=
=GdLL
-----END PGP SIGNATURE-----
--=-=-=--
