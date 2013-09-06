From: NeilBrown <neilb@suse.de>
Subject: Re: Problem halting raid 1
Date: Fri, 6 Sep 2013 22:19:05 +1000
Message-ID: <20130906221905.0eb57dc5@notabene.brown>
References: <CABcjxUOszUPsEJu_nCSRwzCCy5ijs9YUb0ia8HbZ6kzW-jCwWA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/NSW09vHBBEmp9_YNplF=JuH"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CABcjxUOszUPsEJu_nCSRwzCCy5ijs9YUb0ia8HbZ6kzW-jCwWA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Miguel =?UTF-8?B?Q29yYmVyw6Fu?= Ruiz <migcorrui@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/NSW09vHBBEmp9_YNplF=JuH
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, 6 Sep 2013 12:42:23 +0200 Miguel Corber=C3=A1n Ruiz <migcorrui@gmai=
l.com>
wrote:

> Hello,
> I am having a problem stopping an array. When I use the command "mdadm
> --stop /dev/md0" the array disappears completely. It does not even
> appear under /dev/m..
>=20
> Then, when I try "mdadm --remove /dev/md0" bash tells me that /dev/md0
> does not exist. So, after stopping the array with "mdadm --stop ..",
> "cat /proc/mdstat" says that there is no array running. From what I
> read the array should be visible but in a halted/stopped/deactivated
> state. And then one can proceed to remove it.
>=20
> What I want to do is to completely remove the array so I can mount the
> individual partitions anywhere else without the need of mdadm (and
> access the data created when the array was running).

If the array uses 0.90 or 1.0 metadata, then having stopped the array you c=
an
simply mount the component devices

If it uses 1.1 or 1.2 you can only access the data via md.

The version is listed at the top of "mdadm --examine /dev/sdXX" or "mdadm
--detail /dev/md0" output.

NeilBrown

>=20
> Any help will be appreciated. Thank you in advance,
> Miguel
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/NSW09vHBBEmp9_YNplF=JuH
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUinIOTnsnt1WYoG5AQLNMBAAhbrJC8F50Mph5neP0VlHdyJhu1p4Ekeq
9x2FdXufTUtt8Xyzqmm4bp+EWw4Zmpw65Lmxzt1IekaUGK9RvRwYgJUNowsWcw6t
XGcNks9amRw/auHAJAYu71h746y/sEFCQbCI0ZCqxZefRX6qrKkuQkJ9j8/5awAZ
jpJUH98jpTrzbabK9pdbaCTuBtmnJq8QArzBz2lvOEfqvmqy0F2LGVvfLY/ArCmg
OGT5yx8FCHYqDU5GcY7yzvNDV/5gBRblYcYeaMEZhJL5of6nCSG81ktZW7pFDkDQ
oCTU4jgP5daN02+ZLD7+siSa6krK4B0OYbuMg1MPVQFboAh8+QxFY1tDo2Kq0/U0
7WNq1lNu4GoIhfvkhMRcsQguCAxkpz39uGbowvH8KJ7UCjWuvliMmX1gfeps1wh/
0xaATRcsnwuGshEEEXr8DogI2HyspDmgQBXGvLsA1w+z8OJuDUl9OzE+694HXFgB
+4FQx0kizQcULAHdjqeSTNWSRMFi4Z1tqtB25ZrghdRwZgUlsEL3MuJz91GMa6rN
J3ragSHykh4Mj7+aXbf19OAm8F3H0T5uxMUsq7QFD4AqOWD5pFp7ETQ8cyppegLD
OPzWNLV4HkUcxMK4L1J8LTht1vDfKhzpsBxjTgJbzwDWEGomPDDUusb7jhhzBDL7
GRJfayaP4s8=
=6gYP
-----END PGP SIGNATURE-----

--Sig_/NSW09vHBBEmp9_YNplF=JuH--
