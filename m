From: NeilBrown <neilb@suse.de>
Subject: Re: raid10 issues after reorder of boot drives.
Date: Sat, 28 Apr 2012 08:03:55 +1000
Message-ID: <20120428080355.70585026@notabene.brown>
References: <4F9AFBC6.7070803@weboperative.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_//E0iCPk5Tqk_nemmQ9Yy6MY"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F9AFBC6.7070803@weboperative.com>
Sender: linux-raid-owner@vger.kernel.org
To: likewhoa <likewhoa@weboperative.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_//E0iCPk5Tqk_nemmQ9Yy6MY
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 27 Apr 2012 16:04:22 -0400 likewhoa <likewhoa@weboperative.com> wro=
te:

> I have a strange issue on my raid10 8x400GB array. I cannot assemble my
> array anymore and it's gotten to a point that I don't know what to do to
> recover my data. I was hoping I could get some advice on it. Below is
> some info which I hope will help troubleshoot this issue.
>=20
> > mdadm -Esv
> ARRAY /dev/md/1 metadata=3D1.0 num-devices=3D0
> UUID=3D828ed03d:0c28afda:4a636e88:7b29ec9f name=3DDarkside:1
>    spares=3D7 =20
> devices=3D/dev/sdg3,/dev/sdf3,/dev/sde3,/dev/sdd3,/dev/sdc3,/dev/sda3,/de=
v/sdb3
> ARRAY /dev/md/1 level=3Draid10 metadata=3D1.0 num-devices=3D8
> UUID=3D828ed03d:0c28afda:4a636e88:7b29ec9f name=3DDarkside:1
>    devices=3D8:131

I'm afraid you've been bitten by a rather nasty bug which is present in 3.3
and got back ported to some -stable kernel.  The fix has been submitted and
should be appearing in -stable kernels soon (maybe already).

The effect of this bug is to remove key data from the metadata.  It makes t=
he
devices look like a spare for an array of unknown level with no devices and
no chunk size.

It seems that you have one device which wasn't corrupted:  8:131 which shou=
ld
be /dev/sdi3.  The others are messed up.

What you will need to do is re-create the array.  You can look at /dev/sdi3
to see what the chunksize and layout is:
  mdadm --examine /dev/sdi3

and then run a command like:

  mdadm --stop /dev/md1
  mdadm --create /dev/md1 --metadata=3D1.0 -l10 -n8 --chunk=3DXXX --layout=
=3DYY \
  --assume-clean \
    /dev/sdg3 /dev/sda3 /dev/sdi3 /dev/sdb3 /dev/sdf3 /dev/sde3 /dev/sdc3 /=
dev/sdh3
(probably have some device names wrong)

Note that the order of the devices is *very* important, and that is
information that has been lost.  However some of it can be recovered.
If this is an 'n2' or 'near=3D2' array, which is the default, then adjacent
devices will be identical.  You can find identical pairs with:

 for i in a b c d e f g h i
 do for j in a b c d e f g h i
  do if [ $i =3D $j ] ; then continue fi
     if cmp -s -n 32768 /dev/sd${i}3 /dev/sd${j}3
     then echo /dev/sd${i}3 and /dev/sd${j}3 seem to match
     fi
  done
 done

That should help you find pairs.  Then you have at most 16 possible orderin=
gs
of those 4 pairs to test.

Note that the "--create" command  doesn't touch the data.  It just writes n=
ew
metadata and assembles the array.  Then you can run "fsck -n" to check if t=
he
array looks good.

Good luck, and please ask if anything here isn't clear.

NeilBrown


--Sig_//E0iCPk5Tqk_nemmQ9Yy6MY
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT5sXzDnsnt1WYoG5AQLKog//Snry8Wy66L784s/1ZQHrWC4M7sZsvGua
MS5QH+Jjs5Fh9gwKUe8z43JDoe/yL6zzOiruH9PyCLMR/KBkCeV5f4PLScEj5xp/
ejK+u2+Xp7rQLkxdF0m7oNQnHVZqvQdHCIMDRBq+7xsf4P5BFAn6YqPQUOmWMbqN
uuQYqRmGjpDDG0qwpc2pYCMli0Kz5bC8jo8zFVrgw8kKsZS0SmnASsHat7a+IZEr
5Jw5S4Xzb5jSOxtMIy8st86yxrHHoXlee/UiCszuBf/I1Y5o6PpJDngEjPuIOCYs
/9RtLGoP7gsDOJXm7DpAh/hihY7+mIS+f11qpeEz7OF+D7P2BqggNUgHaktHbTc3
wNbLD5ERpWCfP4W+Wfbkps3bwashbUO+2A6qPsk60P3cWk59doSxfsmriWpuwkVM
jSWatrd6PiUhc21O/5/Ly85ecxfEdy5ylxPTLtwPMCkGzcdOqU4sT9eO3tlUoEvs
f8wpf0atCcOaRW5n1nHStBrAf8xk4+3TD08+sg+pvS9VoCpWXkF6PzUQfv5jphTD
OPOt1XNM1EVfGWnlrXwCf5yUUrenGnNvgxZs46BSoZeY9Qz7ulXFqKe0UuNVNzba
vUQEsLWSbIMy0MCR5PPVpE78Qn2Nleg58ysGzT/IGz2j/1ZK1rJnAmoTG8OvZVWo
u9nKaNOmEwI=
=Y0zh
-----END PGP SIGNATURE-----

--Sig_//E0iCPk5Tqk_nemmQ9Yy6MY--
