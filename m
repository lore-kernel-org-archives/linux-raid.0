From: NeilBrown <neilb@suse.de>
Subject: Re: Unable to reduce raid size.
Date: Fri, 18 Jul 2014 20:48:08 +1000
Message-ID: <20140718204808.5cbbe0cb@notabene.brown>
References: <53C8DFEE.7000000@megasoft.be>
	<20140718194043.1c938b2c@notabene.brown>
	<53C8EFC1.1050105@megasoft.be>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/siQWzY05VW8wtm8kAc60Yzm"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <53C8EFC1.1050105@megasoft.be>
Sender: linux-raid-owner@vger.kernel.org
To: Killian De Volder <killian.de.volder@megasoft.be>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/siQWzY05VW8wtm8kAc60Yzm
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 18 Jul 2014 11:58:25 +0200 Killian De Volder
<killian.de.volder@megasoft.be> wrote:

> Bytes are cheap, but screens are small (you'll have to scroll more).
>=20
> "This condition isn't treated as an error by mdadm, so it isn't the cause=
."
> This is not an error, but if the size isn't changed, the end result will =
be
> component size of /dev/md125 unchanged at 2858285568K (skimmed the source=
 code of mdadm, might have gotten it wrong though)
>=20
> Full Strace below

Thanks.   It doesn't actually contain any surprises, but having seen it I
easily found the bug..... hard to explain.

The "SET_ARRAY_INFO" ioctl can be used to set the 'size' of the array, but
only
if the size fits in a signed int as a positive number.
However mdadm tests if it fits in an *unsigned* int.
So any size between 2^31 and 2^32 K can not effectively be set by mdadm.

I think this patch to mdadm will fix it - can you test?

diff --git a/Grow.c b/Grow.c
index ea9cc60e1f18..af59347ca75e 100644
--- a/Grow.c
+++ b/Grow.c
@@ -1813,7 +1813,7 @@ int Grow_reshape(char *devname, int fd,
 		if (s->size =3D=3D MAX_SIZE)
 			s->size =3D 0;
 		array.size =3D s->size;
-		if ((unsigned)array.size !=3D s->size) {
+		if (array.size !=3D (signed long long)s->size) {
 			/* got truncated to 32bit, write to
 			 * component_size instead
 			 */


The code that is reporting an error is setting the used size of each
individual device.
If you make the devices in an array bigger (typically if they are LVM volum=
es
and you resize them), then you cannot make the array bigger without first
telling md that the devices have changed size.
So mdadm first tells the kernel that the devices are big enough.  If they
were already that big, the kernel will return EBUSY, and mdadm will ignore =
it.
If the aren't really that big, the kernel will round down to the real size.

In your case the underlying devices hadn't changed size so mdadm was doing
something unnecessary and got an error which it ignored.

Thanks,
NeilBrown


--Sig_/siQWzY05VW8wtm8kAc60Yzm
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU8j7aDnsnt1WYoG5AQKSGQ//VzaSr6yt/3taSw7NXvWJt6wyy1/H+qxH
TaAIuxZ1V/fFteurwPIMp6jdl+pApVYrYhVSceObCEgyov+7bFrm9hf2TfHt4Psx
wt5+Pfv3KAAK3UYfO1vDAIhgnizQ1o5OnA7nueL1Z5RJ3g6deeALm2uSoqgjsrIU
T05txH0roMlktwUyRMQRHtliPv16l/YkUY6zaFdreO1u4wsGeDL1PHFUfIF9Pugp
8x7zNwWEQcboGl4jow+rS1GwE+UxipVu25x4iNK0oc+776Wcu6N/BBLEji1n9S9p
ZmkZDYMaB/Z7hUSwTLDKXHG1W+EdWN1WivURpE32K6MTnsLy/z1UAlblpiQp85cZ
A7xxOSeCbRPm9DYk7QN2HLT1bR5giTbzAWXU0LoAO7mno6by0wsAlKChLxs71DTN
Cxk14cfO0vclb0ZDMP+xDhfkK1lUJ+h2Bm1f8SkX/m4kxktq2aajaAxH3vDwoPVP
ZufL5dwxLKRBsjVP5E58cM/dz6Ry/ieIlB3Cu8tpFJh7g7kqfxztplZMiOiM0z58
pHLk2ZYoKScwHscXFTq7m99LJE1ABVB8c70frhsxmvwp8z/s8rl/aNqCWHThgZQD
P54UQGX17gIywR8orLJMU8ETRlhs6ueOvSJdLcPfqHEcJIJhXmwmQ6Iv9IHjHQxQ
s5IDLfbFbmk=
=1jgO
-----END PGP SIGNATURE-----

--Sig_/siQWzY05VW8wtm8kAc60Yzm--
