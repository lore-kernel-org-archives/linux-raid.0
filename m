From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 0/1] consistent return types from byteswap macros
Date: Wed, 16 Oct 2013 12:44:35 +1100
Message-ID: <20131016124435.0570f720@notabene.brown>
References: <1381390925-9033-1-git-send-email-Jes.Sorensen@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/PYCrU_/IpHxH7VX5RttGFhx"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1381390925-9033-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@redhat.com
Cc: linux-raid@vger.kernel.org, karsten@redhat.com
List-Id: linux-raid.ids

--Sig_/PYCrU_/IpHxH7VX5RttGFhx
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 10 Oct 2013 09:42:04 +0200 Jes.Sorensen@redhat.com wrote:

> From: Jes Sorensen <Jes.Sorensen@redhat.com>
>=20
> Hi,
>=20
> There are multiple ways to solve this one, but I think this is the
> least intrusive solution, even if not the prettiest.
>=20
> Problem is that current macros simply return the original value if cpu
> byteorder equals the converted type, leaking through the original
> type. This results in errors like this when building for PPC64, as an
> example:
>=20
> gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter -O2 -=
g -pipe -Wall -Wp,-D_FORTIFY_SOURCE=3D2 -fexceptions -fstack-protector-stro=
ng --param=3Dssp-buffer-size=3D4 -grecord-gcc-switches  -m64 -DSendmail=3D\=
""/usr/sbin/sendmail -t"\" -DCONFFILE=3D\"/etc/mdadm.conf\" -DCONFFILE2=3D\=
"/etc/mdadm/mdadm.conf\" -DMAP_DIR=3D\"/run/mdadm\" -DMAP_FILE=3D\"map\" -D=
MDMON_DIR=3D\"/run/mdadm\" -DFAILED_SLOTS_DIR=3D\"/run/mdadm/failed-slots\"=
   -DUSE_PTHREADS   -c -o super-intel.o super-intel.c
> super-ddf.c: In function 'examine_vd':
> super-ddf.c:1414:10: error: format '%llu' expects argument of type 'long =
long unsigned int', but argument 3 has type '__u64' [-Werror=3Dformat=3D]
>           be64_to_cpu(vc->blocks)/2);
>           ^
>=20
> We could force the macros to all return u16/u32/u64, which would be
> 'cleaner'. However I suspect that would make us chase a pile of build
> warnings converting all printf's to explicitly cast. So I made them
> return the same types as our byteswap macros default to (hence the
> unsigned int return type for the 16 bit swaps).
>=20
> Jes

Looks good.  Applied. Thanks.

NeilBrown

--Sig_/PYCrU_/IpHxH7VX5RttGFhx
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUl3vgznsnt1WYoG5AQJo9g/8CTWZbdNuP4QoNhdT6ehDMpXyHJ7boTuL
J0qWeIH1mkw063yPFjbX36l3tFfUSz5du5F96APgzZazrMsa4VpDltvNtAa8tXRS
wU2rKc2vE5PiZ3RWH1JP8Kjri1aDGFMwrBkmgRC4kDMNjjLZZ/6FW7pVoiKI2jfM
TLU/Gjp007gL3Z92epz7IFFVxG4kA0iM62HwPdrXYguL40vwiOj/GfO7kIIsyKd7
7Zxat8gm9GUPw8zknMkPC3+oNytr8tJs2LtqR8lcC6W/+ABz+Mi1/Stk9kLDcL+T
MOUqJYe336eit1tFwp8XNFFjGRc3b4Ggw9LWBMiuPQLb2b4M2n5wLrp58l+aTbr/
a/FffhAR8qM8i9Hgz6oeFwzXOenJv6JgDr0MDW02mG005784+rB1+h/DNljIkbKR
gFXTCoJOt3ZTlQnXL8Qi6eEJW7CP/rfFpxX+eo2Y4hztc4M1qe3GyT5oDVlhtKG4
7AF9CFOg4N/mH8frE6HvDtD+CyTgu478QYBDTHkbbUUqBaA8Hkfxu75WOwII0LJJ
TZ1kAytL2OApdNIkptslasbYUIwX62jMbLGpVKE37uRi0ts/bqz6jBI7Ira8yAfm
HB5SDim3CIzjNQTU6CX6ibx0VL4T9eP5Ai+bOiuQkM/neSdUdAhqPEHRFJRAl/S7
prx/Fjaq5+c=
=q/3d
-----END PGP SIGNATURE-----

--Sig_/PYCrU_/IpHxH7VX5RttGFhx--
