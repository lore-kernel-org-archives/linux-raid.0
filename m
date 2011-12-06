From: NeilBrown <neilb@suse.de>
Subject: Re: Raid10 and page cache
Date: Wed, 7 Dec 2011 09:26:25 +1100
Message-ID: <20111207092625.7140c5dc@notabene.brown>
References: <CAJygYd16PWfKe8fK-b150N46CEwzBUqJn1N6dfsGR4yyTgGbTQ@mail.gmail.com>
	<CAJygYd3ofkHp9huD_Q1xoKVb_Q2LTDAnFHf-n+8xyG7ug3wC_Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/uRkqwVwIpiK2fUBxKVF38Z1"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJygYd3ofkHp9huD_Q1xoKVb_Q2LTDAnFHf-n+8xyG7ug3wC_Q@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Yucong Sun (=?UTF-8?B?5Y+26Zuo6aOe?=)" <sunyucong@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/uRkqwVwIpiK2fUBxKVF38Z1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue, 6 Dec 2011 14:01:14 -0800 Yucong Sun (=E5=8F=B6=E9=9B=A8=E9=A3=9E) =
<sunyucong@gmail.com>
wrote:

> Hi,
>=20
> I recently setup raid10 on 4 physical disk and have a iscsi serve it
> as a block device, and have been trying to tweak for performance.
>=20
> First thing I notice that MD seems to rely on page cache to flush
> changes to disk, =C2=A0is there any way to turn that off so changes are
> flushed to the disk? like O_FSYNC|O_DIRECT does? The reason I want to
> turn it off is to understand the performance difference, =C2=A0I want to =
be
> sure that page cache is truly acting as a write-back cache, I know one
> can tune the dirty_* to control the cache flush, but I want to make
> sure that it is actually doing what I think it does.

Why do you think this?

md/raid10 sends all request straight through to the relevant underlying
device(s).
reads are just passed straight down.
Writes are duplicated (the request structure, not the data) and queued to a
separate thread which does the actual write, but it is fairly direct.

>=20
> Then I notice in output of free, =C2=A0the number in Cache column is very
> low, however the Buffer is very high, my question is does Buffer here
> serves as a read cache? I couldn't find the answer anywhere else.

The best place to find the answer is in the source code.

Every page in the page cache is associated with some file.
If that file is a block device (e.g. /dev/sdX) then it is reported as
'Buffer' otherwise it is reported as 'Cache'.

Some filesystems like ext3 uses 'Buffer' memory for metadata but call use
'Cache' memory for files and directories.

>=20
> My last question is that since MD seems already doing the cache, =C2=A0wh=
at
> effect would it have if I want to setup a LO device in front of MD
> device, Is there going to be more caching, how is different than just
> plain MD device?

MD/raid10 does no caching.
A loop-back over the md device would not add extra caching.

NeilBrown


>=20
> Thanks.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/uRkqwVwIpiK2fUBxKVF38Z1
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTt6Wkjnsnt1WYoG5AQI2hRAAwjd+fcisgqdmS/e9kBOI3fuOGiYPTxSD
nXX7AgD1cEzpSlkFbXVlwS079ErRXNFTtRaw4sV/7+6+2wV3WOxab1mz6lEbiGzI
uXe8Q3QyQKLyJzUMlOmST/llQ2gy6rfA9DvaZaaIMcd6DP0LZ6ZFSruo0ZljtKXA
iwiHfEltkNI3T1ZSE1De7COHpeQshu8rvKFyYrCgRB6gL4wxyliHtaR7P5B172sp
Jxo0/4ASkcTPFnZGsRw2xPg16FRynpu85WC7Yru72fn7JfNp6d3JCo4IM/Qz3e+T
qNP/93woe4Q/GyKgYHvZh2m5FDW3PyLg5iQbwkcC9ZbTzChXixEG81JwXZrS7nvL
//fu+bt9Tj8/283oKmCuRm7/rbjIneADD7N+It/eFX6cxdl8nPNCrGO5eOgImvxt
osEG0kbbdCiXgPR4ZlHFEe0IazZlhHZbAt0PzlBEi2DJ4chnthed1X0SdEaEsVCq
YnnAxhynBqHNKbEtN/n8Kk9J7GJJPa/MtRgTlkUo06RjBjab6rE7fOepNtTbx79T
hWYazQlCgqKUS5DPjcs/3VofaXPq+2VMY9ZQv0FV7qEJH6rUZyF8+MwkDjbzRp0y
3Gikx4/WoWB/ThkAaQNKPHG4T3z2M17p5aE9pzBGAgktznmQjJ3wRXVDS6/KL798
/yn2Yww0peU=
=ueE6
-----END PGP SIGNATURE-----

--Sig_/uRkqwVwIpiK2fUBxKVF38Z1--
