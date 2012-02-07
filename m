From: NeilBrown <neilb@suse.de>
Subject: Re: Please Help! RAID5 -> 6 reshapre gone bad
Date: Tue, 7 Feb 2012 14:10:23 +1100
Message-ID: <20120207141023.22cce706@notabene.brown>
References: <CAOANJV-V8ZTXBvQxxMnEnv24p8A-fAas-6x65ifW5yp35ZqHnA@mail.gmail.com>
	<20120207133947.5c4b9a59@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/G7PThVnoA1zGWoeS8bE4sQH"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120207133947.5c4b9a59@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Richard Herd <2001oddity@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/G7PThVnoA1zGWoeS8bE4sQH
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 7 Feb 2012 13:39:47 +1100 NeilBrown <neilb@suse.de> wrote:
=20
> > I tried to assembe the array, to see if it would continue the reshape:
> >=20
> > root@raven:/# mdadm -Avv --backup-file=3D/usb/md0.backup /dev/md0
> > /dev/sda1 /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sdf1 /dev/sdg1
> >=20
> > Unfortunately mdadm had decided that the backup-file was out of date
> > (timestamps didn't match) and was erroring with: Failed to restore
> > critical section for reshape, sorry..
> >=20
> > Chances are things were in such a mess that backup file wasn't going
> > to be used anyway, so I blocked the timestamp check with: export
> > MDADM_GROW_ALLOW_OLD=3D1
> >=20
> > That allowed me to assemble the array, but not run it as there were
> > not enough disks to start it.
>=20
> You probably just need to add "--force" to the assemble line.
> So stop the array (mdamd -S /dev/md0) and assemble again with --force as =
well
> as the other options.... or maybe don't.
>=20
> I just tested that and I didn't do what it should.  I've hacked the code a
> bit and can see what the problem is and think I can fix it.
>=20
> So leave it a bit.  I'll let you know when you should  grab my latest code
> and try that.

Ok, that should work..
If you:

 git clone git://neil.brown.name/mdadm
 cd mdadm
 make
 export MDADM_GROW_ALLOW_OLD=3D1
 ./mdadm -Avv --backup-file=3D/usb/md0.backup /dev/md0 ..list.of.devices.. =
--force


it should restart the grow.  Once device will be left failed.  If you think
it is usable then when the grow completes you can add it back in.

If you get another failure it will die again and you'll have to restart it.

If you get a persistent failure, you might be out of luck.

Please let me know how it goes.

NeilBrown


--Sig_/G7PThVnoA1zGWoeS8bE4sQH
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTzCWHznsnt1WYoG5AQJDmA/+JzjvwG3j9VhKg+6RZqFChDPNswQmIq4T
JpekrR9fs0BP3fvu2pPDToeYtHRHkGCk+oF9bKZvNVjwZIMe8138AV2UgmSBYjOH
SjYWPH+bCixpPVN96DXrY5JXBbPUPbpMPsTdGfpvT0kT/lqvQxmAPV8xXo7n6I+G
gTs8YFuK1ImNHWPUKMMctjvUcK6D2h1N73EAlULF9HtlHaFxsnhbCSk3dFiiYn8y
Xx0NOHjX65dLsZecBJUtrKX32cBX+9g3FhIHrmpbuLmGXuz+Ayrg5AwOvfNpqy16
O9psh2HxhpeZfRB+sKQZlZGBtAB35Ov1VJXFrfoQcSIJZ1iQKQHcZVgp/0UDWxtn
yw2L6PNWIqvDK+H728sa/O65p/h8qORfLH3YwQT4jlGp2qRfVxyupBK7xHQLag+s
YeYUX/WYwrL7k/3qbBvdLptfQHqx10SvwoS1P1DuYonw8gzaJOOktdABtH1r0GH1
eIDWTRR8x0D+f+6liGskDROOM5nMU3jPD2X5uWL9kfb7ksKEznjcKoFJIguL2n2a
gZsmh0WtNLGEE0eSchld6priptDSNUoJSObrAsYmt20fESw9sbtjRnLij0K6+XRY
R88Gpcz8bI3IZNaqVNcKKoNYtus4U+vqxHFSybLoDzoL+dZ1HNyyEQtUoFew6Bau
MnCEgxyIyWs=
=e+vY
-----END PGP SIGNATURE-----

--Sig_/G7PThVnoA1zGWoeS8bE4sQH--
