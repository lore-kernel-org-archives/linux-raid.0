From: NeilBrown <neilb@suse.de>
Subject: Re: Data Offset
Date: Tue, 5 Jun 2012 15:44:27 +1000
Message-ID: <20120605154427.192566af@notabene.brown>
References: <CAFhY2CjOECFy4bWDL6zs9rtSkVGPR9Wv=1UX9vKgmdjwMsmBYg@mail.gmail.com>
	<20120602095237.3822e2c2@notabene.brown>
	<CAFhY2Cjwep5mZkYCfRn4UYmQpSyHU13dSCB8HF8F9wG8Rzx9Aw@mail.gmail.com>
	<20120604133526.6da3bf10@notabene.brown>
	<4FCCFDBB.201@pierre-beck.de>
	<20120605085728.7e922359@notabene.brown>
	<CAFhY2CjQAutSxzJ-7e+G-1Jw-U6JsFjBBHOmiqOxkhkZy6kd9g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/2tMPUpjpu/CZiKZB=Rrkyhh"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAFhY2CjQAutSxzJ-7e+G-1Jw-U6JsFjBBHOmiqOxkhkZy6kd9g@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: freeone3000 <freeone3000@gmail.com>
Cc: Pierre Beck <mail@pierre-beck.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/2tMPUpjpu/CZiKZB=Rrkyhh
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 5 Jun 2012 00:26:20 -0500 freeone3000 <freeone3000@gmail.com> wrote:
> =3D=3D3206=3D=3D    at 0x43C9B7: write_init_super1 (super1.c:1327)
> =3D=3D3206=3D=3D    by 0x41F1B9: Create (Create.c:951)
> =3D=3D3206=3D=3D    by 0x407231: main (mdadm.c:1464)
> =3D=3D3206=3D=3D  Address 0x8 is not stack'd, malloc'd or (recently) free=
'd

Ahhh.. I know that bug.  If you "git pull; make" it should go away.

However the bug happens when printing an error message, so it won't make
things actually work.

It seems that it is failing to write a superblock to /dev/sde3.
I wonder why.
Maybe if you run it under strace:
   strace -o /tmp/str ./mdadm -C .....

then post the "/tmp/str" file.

NeilBrown

--Sig_/2tMPUpjpu/CZiKZB=Rrkyhh
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT82cuznsnt1WYoG5AQIEbRAApyteWbvVvs/EdsrV3rBhM3L6BTOKJnzV
RKOkeY7yvFxAiL8bpnKb3EOUw+36a8ReJqVdjlj2DPS7gfo887I0QrykudIPGyo/
ss5wjt0Qew1cPbJfpu111QJJc6/pipvuV2zfUIGPTDqnfb0GsSTIbBtS2SM65BI4
HSnnLE7ujlZsHylZDXL1b8GYBiUxuBI5O1c9BwPyr5YtMixViDfue0lDThPpeKe7
2TpDxEmokQ6LGmTbvLx6bCWft8liDQRAzt7badfm8jISkmmVEcEqacglgaoK54QA
Dsu8SzC/wK93CKDEk4ideFKv+N67tsStSTmI0AN37TYVVpljMPHInG5DtjQKODBn
kUZe7kJNBbDbvtUgoeFWT5N1g6RQZMfcW6q74aBvrRKsMmYieoDQee2nG7OToRjQ
FE6F87DABUCSTFJIKfCBx5qY4CV5FWlHdNjQfjkumY6aH/pNf/5vmES+23AhuvlC
/w2p2dmt09iPcgW17A7CcHLsDER6xIQYHH3ufYq3IItFY4DQsjTpkjWDfvjXz8oQ
8may4N5W4j0viGRvR+DdsrlC84Bzi/T1k5EzzyrXyK0/I+z/JitJrQn/3omdIqPM
SZ0ZLWcnMPk9bknnKpewUeE/vYDotCNxVKhCaKfxCROZer6kyOfYqSvkZtE2w4aP
DAgkoz1zWU8=
=Dl9q
-----END PGP SIGNATURE-----

--Sig_/2tMPUpjpu/CZiKZB=Rrkyhh--
