From: NeilBrown <neilb@suse.com>
Subject: Re: Recovering a RAID6 after all disks were disconnected
Date: Sat, 24 Dec 2016 09:50:26 +1100
Message-ID: <87a8bmp8el.fsf@notabene.neil.brown.name>
References: <CAOxFTczhq3Gr4WW=-sMamaYDmAoMFGh7kkanwJzhXe5NBdMHHQ@mail.gmail.com> <22600.7486.444800.536687@quad.stoffel.home> <CAOxFTczn4Su6KwjDGS0S5BrUdirv9Tu_zCeo26iFMvL3378xpw@mail.gmail.com> <22601.44638.79418.124438@quad.stoffel.home> <CAOxFTcwYujHCHeiJiwUc4aA5RpN_9ocoBGfLS1kfgaz=sKSOSQ@mail.gmail.com> <87k2arpmvt.fsf@notabene.neil.brown.name> <CAOxFTcxaC1WOj7HeD5bRaPKV93fQZ6X-mBtHOFcQmPwWfjPxDQ@mail.gmail.com> <CAOxFTcwaDfK+gKX2d4L4DuX=pf273M8qKGGOo8G+iAVSxurHhA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAOxFTcwaDfK+gKX2d4L4DuX=pf273M8qKGGOo8G+iAVSxurHhA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Giuseppe Bilotta <giuseppe.bilotta@gmail.com>
Cc: John Stoffel <john@stoffel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Sat, Dec 24 2016, Giuseppe Bilotta wrote:
>
>
> So the array assembles, and raid6check reports no error, but the data
> is actually inaccessible .. am I missing other aspects of the metadata
> that need to be restored?

Presumably, yes.

If you provide "mdadm --examine" from devices in both the "working" and
the "not working" case, I might be able to point to the difference.

Alternately, use "mdadm --dump" to extract the metadata, then "tar
--sparse" to combine the (sparse) metadata files into a tar-archive, and
send that.  Then I would be able to experiment myself.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlhdqjIACgkQOeye3VZi
gbkCJhAAuuIcWvBqaadsTiihYb8UgFJTbVTfWKW/lDzkafAWTFGiRSYjLUA6qLd8
elULZN0VEBm6TT77uoe8yeksVPJ0awFEr8QKr6nCbihhIvbj7qbX3FBy0OmiOSpo
kYcWOpGXY0z8gT2VU2a5wZe8Eavac0XRqgjTlVzjQEBGu0DAMzUZt3r7bggApGPS
0s+3kXiRnViyIe0xLsWtBHdsUMpRZtYXXOiU2NnMFwvfPUOmQ8g460+88SR/ZHIl
rQ57lcFcHH9TqZ1T6IsAa6zrPfJ0FnG4p/zospfAqfeeAcmdb+9xtb585/SiNEnk
9hlddzCbcNojx+YuALd1Qo5j8zTVf3eDMVSlYuG7uMSJ3vPI9UtskkePGexcOKPB
mxCyCbvMV6Bdy7U/dd1xSEDXzYd28ZZ0wAw8TDjaEPjWo/vqlbh4XzQI2/99A76a
zJR1xWZsRAw6sDIsJ3uboJdpml282PzLM0MltMNQcku8aIXkX2LUXZJRUPocubc6
Q7XZR0MGGm8DFo+gXPgY9dYeoKZ4wWbB/28Qb4tQlxR+NEuc0IOsE1pKE86t8c6c
AhnW0ostVxDRIVBL3QZFCQsQywqsX0PISsjsMB/z1OQZBJg96d+VQGtJDiiddUS7
DLvvPU289iFEatOEm55Md9J0//qn0TmRfn8IYqJW+0eX2uS06nw=
=GRoi
-----END PGP SIGNATURE-----
--=-=-=--
