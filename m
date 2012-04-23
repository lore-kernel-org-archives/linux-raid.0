From: NeilBrown <neilb@suse.de>
Subject: Re: md/bitmap: move some fields of 'struct bitmap' into a 'storage'
 substruct.
Date: Mon, 23 Apr 2012 10:10:49 +1000
Message-ID: <20120423101049.633d9be7@notabene.brown>
References: <20120420131336.GA26339@elgon.mountain>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/ue2f5X2Ilj=V06724yeX80j"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120420131336.GA26339@elgon.mountain>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@ORACLE.COM>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/ue2f5X2Ilj=V06724yeX80j
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 20 Apr 2012 16:13:36 +0300 Dan Carpenter <dan.carpenter@ORACLE.COM>
wrote:

> Hello NeilBrown,
>=20
> This is a semi-automatic email about new static checker warnings.
>=20
> The patch 9159d8a35d0a: "md/bitmap: move some fields of 'struct
> bitmap' into a 'storage' substruct." from Apr 19, 2012, leads to the
> following Smatch complaint:
>=20
> drivers/md/bitmap.c:1212 bitmap_daemon_work()
> 	error: we previously assumed 'bitmap->storage.filemap' could be
> 	       null (see line 1145)
>=20
> drivers/md/bitmap.c
>   1144			bitmap->need_sync =3D 0;
>   1145			if (bitmap->storage.filemap) {
>                             ^^^^^^^^^^^^^^^^^^^^^^^
> Renamed check.
>=20
>   1146				sb =3D kmap_atomic(bitmap->storage.sb_page);
>   1147				sb->events_cleared =3D
>   1148					cpu_to_le64(bitmap->events_cleared);
>   1149				kunmap_atomic(sb);
>   1150				set_page_attr(bitmap, 0,
>   1151					      BITMAP_PAGE_NEEDWRITE);
>   1152			}
>   1153		}
>=20
> [snip]
>=20
>   1210			if (test_and_clear_page_attr(bitmap, j,
>   1211						     BITMAP_PAGE_NEEDWRITE)) {
>   1212				write_page(bitmap, bitmap->storage.filemap[j], 0);
>                                                    ^^^^^^^^^^^^^^^^^^^^^^=
^^^^
> Renamed dereference.

There is a relationship between storage.filemap and storage.file_pages.
If the later is 0, the former must be non-NULL.

This dereference only happens if file_pages > 0...  Maybe I should check
file_pages up above so as not to confuse smatch??

>=20
>   1213				if (!bitmap->storage.filemap)
>                                      ^^^^^^^^^^^^^^^^^^^^^^^
> Another check.

Yes, that does look odd.  The check isn't needed any more and I have just
removed it.
Previously if write_page() got an error it would free the filemap.  At that
time there was locking here.
   spin_unlock
   write_page()
   spin_lock
   if (!bitmap->storage.filemap) ....

so it was more obvious that filemap could well change between the write_page
and the test.
When I change write_page to not free the filemap any more, I could remove t=
he
locking.  But I didn't notice that I could remove the test as well.

New code will be in my for-next shortly.

Thanks,
NeilBrown


>=20
>   1214					break;
>=20
> Really, this isn't a new warning, it's just shows up as a new warning
> because of the rename.  Still, I was curious about the check after the
> dereference.
>=20
> regards,
> dan carpenter


--Sig_/ue2f5X2Ilj=V06724yeX80j
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT5SeCTnsnt1WYoG5AQIbwQ/8DgN4wYtGQlSimrcq+uBIB1I0OLOzEjyK
1tCoEwcHa893X2t2cGRLIMsbXtEEKuI1/mpla+swur5yGpakY61+FMnpPBfdF/uQ
cMBON5DtqL3Y6YTR0P9EajKbSsMuJkQy0zTQUW+3NimvrCJd/7+7AvV5dErMuyw3
PmTINakuiH3BIhuiTOJZapQ97FsEHWxZBTF4cRpUKjQDyeVbHU3Sc8+yOZUbvg6W
NT8LgjPb8liQo73odJeY9wGeu8eUjCUH11qg1+BJavhiY1yUJgL46eKNOuqnVXt8
ZakwANyKvoeeDh1FKp4zbUF7zcKPBJ2LNYQwwgLvGPGWFv210su7tRu4gQuIQqLZ
SpfAZqmWZ9sYxPXTYl4q5v9G+TphPRIF3JD2FvHxQnuQykkYcpmoyOYkUOTM0VML
5TFtuHhs86ssDKC6mc60PBLeeYOHlnAsXNB1gXmjUXKjLdsoGIX0+5o/9ymSj5ot
w1cLKYJATgKhFt+UnYe62V/7AfkEmGb+ZkFZtNEbTtjtV8UNNXovNav5ED2ZE+2A
z+1UNdGfW8JWUmzfhBfEkJOaOaQi/RfNkWv+KRysVafP4+sOd9eXYlepd4kmYteK
fT43zFlGJhlZHTYu/DygX03UIr73Mwu2YoqILOU5j5ZypTxp6EXizeHRwxQ31XPS
SmLOWEHB++4=
=PVkd
-----END PGP SIGNATURE-----

--Sig_/ue2f5X2Ilj=V06724yeX80j--
