From: NeilBrown <neilb@suse.de>
Subject: Re: mdadm crash with lots of devs
Date: Tue, 10 Jul 2012 07:50:44 +1000
Message-ID: <20120710075044.6acebe1e@notabene.brown>
References: <alpine.LNX.2.01.1207091635040.1330@frira.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/.WV6Os5TsYSn1TNOEh214G5"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.01.1207091635040.1330@frira.zrqbmnf.qr>
Sender: linux-raid-owner@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/.WV6Os5TsYSn1TNOEh214G5
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 9 Jul 2012 16:38:47 +0200 (CEST) Jan Engelhardt <jengelh@inai.de>
wrote:

>=20
> Using mdadm-3.2.2 from openSUSE_12.1:
>=20
> # modprobe brd rd_size=3D1 rd_nr=3D4096
> # mdadm -C /dev/md9 -l 10 -n 384 /dev/ram{0..383}
> mdadm: Defaulting to version 1.2 metadata
> Segmentation fault (core dumped)
>=20
> #1  Create (st=3D0xb4c600, mddev=3D0x7fff3bda64c0 "/dev/md9", chunk=3D512=
, level=3D10,=20
>     layout=3D12593328, size=3D4, raiddisks=3D384, sparedisks=3D0,=20
>     name=3D0x7fff3bda64c7 "9", homehost=3D0x7fff3bda6fe0 "seven", uuid=3D=
0x0,=20
>     subdevs=3D384, devlist=3D0xb49030, runstop=3D0, verbose=3D0, force=3D=
0,=20
>     assume_clean=3D0, bitmap_file=3D0x0, bitmap_chunk=3D65534, write_behi=
nd=3D0,=20
>     delay=3D5, autof=3D0) at Create.c:899
> 899                                     fprintf(stderr,
> (gdb) l
> 894                                                info_new.uuid, chosen_=
name);
> 895                                     me =3D map_by_devnum(&map, st->co=
ntainer_dev);
> 896                             }
> 897
> 898                             if (st->ss->write_init_super(st)) {
> 899                                     fprintf(stderr,
> 900                                             Name ": Failed to write m=
etadata to %s\n",
> 901                                             dv->devname);
> 902                                     st->ss->free_super(st);
> 903                                     goto abort;
> (gdb) p dv
> $1 =3D <optimized out>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


This bug is fixed by=20
  http://neil.brown.name/git?p=3Dmdadm;a=3Dcommitdiff;h=3D401142133

It isn't specific to large numbers of devices.

If you would like an update for 12.1, I suggest opening a bug on
bugzilla.novell.com.
If you want to work with larger numbers of devices, I suggest getting the
mdadm from Factory - it has a number of fixes in this area.

Thanks,
NeilBrown

--Sig_/.WV6Os5TsYSn1TNOEh214G5
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT/tSNDnsnt1WYoG5AQK8IRAAsVGc995SVjJC0ALo1QW+Beclbfu4Lc5n
EWDpeVBB8xtREgaLAl/ljU2bVT/4uIbb/Wkd4vjSgDdegEHOOK+y2L5wXS51OXK+
lMbz+gPX+WKIKvcSIH2x0bfXby0DUHyyOAFg8+WaZP6PxatEzjVZE4g/cVQU/BzN
QH+GIdE48+pS8YOvkyhOb8nlaySKZvOsO9awvCTY0VE0mRx28lCvd1zcV8wbrASI
Dbqd2bYyxWgvDuYDZ+2qSPPLlCs035qEkEyhv9n7to4MUx4OHvJbnYeX9c2HUjFL
IehXLB2JiXO3QHkfH4YOo4hkJnofGvezqxUbu9xSwQ6upUK5IBvtUGkr3ZdUqdDu
+SAfYUYnylTR+4fYgP6Lr5EXDNhYdIAQjWCLbVPxApVVSQ1e3MkGP+x6rEiesBag
30BLnfSrb8XspnXzvl1B6FawOhaB0VwWTQ6tqCHfFj+HzNoyCiBqo1oq7tE4vvyN
7EYpFqHkbtwZG16+pKPRrNSlMNsosq6fSSpLCIjZsey79KRAK1dvZ1azwi8dCJGv
xHk7/X2BSk4GltSx1bbaXXj5lk0ffu+8ChVmRJcYFFu8AjqC8ee+sQH6cIdfZGQf
jip1Shhj3L4bIlqFRvxr/Vx1Ss1R4lH1NUG+COR4kazcoUnwIO+PdcAk7YCZ3M1O
z1NV8QQviNg=
=2TsE
-----END PGP SIGNATURE-----

--Sig_/.WV6Os5TsYSn1TNOEh214G5--
