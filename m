From: NeilBrown <neilb@suse.de>
Subject: Re: mismatches after growing raid1 and re-adding a failed drive
Date: Tue, 10 Jun 2014 10:21:05 +1000
Message-ID: <20140610102105.6e544fd7@notabene.brown>
References: <CAGRgLy6YHMe-CRB1h4WHC-1xtdy5nURecf51LWu9WRaCy8Nw6w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/LK8cKHZhnX6z41km9LHdO8v"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGRgLy6YHMe-CRB1h4WHC-1xtdy5nURecf51LWu9WRaCy8Nw6w@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alexander Lyakas <alex.bolshoy@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/LK8cKHZhnX6z41km9LHdO8v
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 6 Jun 2014 14:59:32 +0300 Alexander Lyakas <alex.bolshoy@gmail.com>
wrote:

> Hi Neil,
> testing the following scenario:
>=20
> 1) create a raid1 with drives A and B, wait for resync to complete
> (verify mismatch_cnt is 0)
> 2) drive B fails, array continues to operate as degraded, new data is
> written to array
> 3) add a fresh drive C to array (after zeroing any possible superblock on=
 C)
> 4) wait for C recovery to complete
>=20
> At this point, for some reason "bitmap->events_cleared" is not
> updated, it remains 0, although the bitmap is clear.

We should update events_cleared after the first write after the array became
optimal.  I assume you didn't write to the array while the array was
recovering or afterwards?

>=20
> 5) grow the array by one slot:
> mdadm --grow /dev/md1 --raid-devices=3D3 --forc
> 6) re-add drive B back
> mdadm --manage /dev/md1 --re-add /dev/sdb
>=20
> MD accepts this drive, because in super_1_validate:
>         /* If adding to array with a bitmap, then we can accept an
>          * older device, but not too old.
>          */
>         if (ev1 < mddev->bitmap->events_cleared)
>             return 0;
> Since events_cleared=3D=3D0, this condition DOES NOT hold, and drive B is=
 accepted

Yes, that is bad.  I guess we need to update events_cleared when recovery
completes because bits in the bitmap are cleared then too.

Either bitmap_end_sync or the two places that call it need to update
events_cleared just like bitmap_endwrite does.

>=20
> 7) recovery begins and completes immediately as the bitmap is clear
> 8) issuing "echo check > ..." yields in a lot of mismatched
> (naturally, as B's data was not synced)
>=20
> Is this a valid scenario? Any idea why events_cleared is not updated?

Yes, scenario is valid.  It is a bug and should be fixed.

Would you like to write and test a patch as discussed above?

Thanks,
NeilBrown



> Kernel is 3.8.13
>=20
> Thanks,
> Alex.


--Sig_/LK8cKHZhnX6z41km9LHdO8v
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU5ZPcTnsnt1WYoG5AQI+yA/+IhP+R+T00O6lY4e6evkCmqUSxkzGgHrI
82KmbGG14E6Xdp9saB3/TBTNcMu/oIp4NixiEhLvGLBg2rTisxvLcmQAm0XW7Qbe
tKHDAy00AU2wmwjxZvciB6xxe7aEFZa2T8X0eh7DI0YVjEE2swT/NuSSSX1EPplr
cFKv5/9y4LOGj8pUBLhUFllR/7o5IjaD+xbI7tRD9Rkt9WdMleshzJfHMQFgOG4d
PaK1UCPxWejVVf2HuLGBf3RyQ0Ch8ecKQw08uywNLFPl0USnMSD7MjIvrIORlG61
KnyRqpF/Dbt3MueFBD+5T4uuxQjtOvXfcjsSvA9kWFPk2/q6SiPUMVKdRY4f+C19
BZzCresKhTowtQNQsdjf0uQ5WIad6SskcKda+ktnFa8pLgtOb4M77YaE8S0QWmur
2BpvAyitcGrUbThr5voKASUf0xG92FrJ6FVWX81gZlDzZE4EhbKNA3GRj2dVCEg9
jzAo7MZojo9ygxQpWZK7J7Tb5GznUXa5i2r6SBC5lytcXosHL7AeXYY95mcSatuK
7fjhxpR1DBbrjJolE9fyA02sTi+pFD2yNPu5oN84zZZHi4ZMwffSBMz/V56aQoia
KQJkVWFLVgYKUr525bQS5zDoM8jtqTz+vvkAYaxe4rw17+lOvO5uQmN30qZ3WuUe
4JoKomqKRiI=
=udew
-----END PGP SIGNATURE-----

--Sig_/LK8cKHZhnX6z41km9LHdO8v--
