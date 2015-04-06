From: NeilBrown <neilb@suse.de>
Subject: Re: Recovery of RAID 6 after three rapid disk events (disks are
 still working)
Date: Tue, 7 Apr 2015 09:33:19 +1000
Message-ID: <20150407093319.29f7909e@notabene.brown>
References: <104310d53affd63c6e13088daa8dd5f2@zeus.bigmiketrading.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/MjPZX7HoCua7sTzAjkzSPAf"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <104310d53affd63c6e13088daa8dd5f2@zeus.bigmiketrading.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mike <mboulter@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/MjPZX7HoCua7sTzAjkzSPAf
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 06 Apr 2015 18:28:55 -0500 Mike <mboulter@gmail.com> wrote:

> Hi guys,
>=20
> mdadm 3.2.5, 14 disk RAID 6
>=20
> Had a drive failure Friday.  Two more today in rapid succession.  All=20
> drives seem fully operational.
>=20
> This is roughly 40TB array, I could use your help please to rescue the=20
> array.
>=20
> All members are on partition 2 of each physical disk.
>=20
> # mdadm --assemble --scan

Add "--force" to that line, and it will work.

In this context, "--force" means "yes, I know that some devices are a bit o=
ut
of date and that that if there was a write happening while one of the devic=
es
appeared to fail then there could be some corruption of a few blocks in the
array, but I want all the rest of the data and I promise to be careful and I
won't assume that everything is perfect and I won't blame you if a few files
are lost - just do what you can.  Please."

NeilBrown

--Sig_/MjPZX7HoCua7sTzAjkzSPAf
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVSMXvznsnt1WYoG5AQLtKg//bHmdMjzAlsnKQ7tvQI0BYurRCEEPC9Z2
oOs0AWFFkLlYOL2/2eXYXQkGz4xq88naEDxmjgJXagvS9xiw65oeqx9A2mKocHnY
hblmK7EBLcCytUyGx52R+hxar8qUqRb2DjlR3rxzY99lHpIZcgEOzhd7wtSYc8FA
qVPL3UOBYPNdvKDSEMNmvn+6mrBC07Wcd/gjqOpExwjoowml2fmos+cD0GXwLlm9
bnMOkqvpiwyDmsHHWUEZYugobQpebuwCy0ADlVn/j1PH5dxbHqPON4IGKjbcxbQm
sqLIcRNSUuxJCtJ6YdmMl4ZW3wkW2DVLzkXRqldDXo+oSo0/4RmozqBnLaTAtw3L
r0M8GgR543Li5Nhdu5SyEj82jvNz0kDOC8tn1rtCExwNn28Dwx3K2aRDjP5vmsQ9
njihx++WCycZik0+kW6Bu8TfZC2dK8/is0RLFZrZeATec2pSeKUx533h51hXkTa4
XtdJvnq/u/M2GRSRcTF3RSe24qc6AXSPciTEELP66iKyGZhVcByaGK4uCvSlbjwC
BBf9aJs9jNpda2XXRGQOxo8fR7brwhrpaLB93qOMCV29qo52OigVBqijVKuuqlr/
F1DTETBBz/bcWxV5E8MVgHp106X1tYfnuszAcS9umGU0AqiaA/8jgY27zupq5JLQ
7CzMqESOyB8=
=3BSt
-----END PGP SIGNATURE-----

--Sig_/MjPZX7HoCua7sTzAjkzSPAf--
