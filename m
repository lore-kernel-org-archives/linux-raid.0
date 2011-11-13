From: NeilBrown <neilb@suse.de>
Subject: Re: raid 5 to raid 6 reshape gone bad
Date: Sun, 13 Nov 2011 14:55:56 +1100
Message-ID: <20111113145556.45b04397@notabene.brown>
References: <E427BB45-7AA7-422C-AAFE-9778286BF64C@jetcom.org>
	<4dq3p8xsef.ln2@goaway.wombat.san-francisco.ca.us>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/9iIP1g0SG5OVVJ35PdH1UI3"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4dq3p8xsef.ln2@goaway.wombat.san-francisco.ca.us>
Sender: linux-raid-owner@vger.kernel.org
To: Keith Keller <kkeller@wombat.san-francisco.ca.us>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/9iIP1g0SG5OVVJ35PdH1UI3
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 12 Nov 2011 19:33:24 -0800 Keith Keller
<kkeller@wombat.san-francisco.ca.us> wrote:

> On 2011-11-13, Travis Brown <teb@jetcom.org> wrote:
> > I was reshaping my 5 drive raid 5 with spare to a raid 6 array when the=
 drive I was using for my backup went offline.  If that's not murphy's law,=
 I don't know what is.  The array is still up and usable, but I'm afraid to=
 reboot or doing anything to it, really.  Suggestions on getting this thing=
 back to usable are very welcome.=20
>=20
> > Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [r=
aid4] [raid10]=20
> > md126 : active raid6 sde3[0] sdf3[3] sdb3[1] sdd3[4] sdc3[2]
> >       5856728064 blocks super 0.91 level 6, 512k chunk, algorithm 18 [5=
/4] [UUUU_]
>=20
> Do you have hot-swap drives?  If so, simply mark sdd3 as faulty with
> mdadm, remove it from the array, then physically remove and replace it
> and use mdadm to add the new drive.  The raid6 should start to rebuild
> automatically.

Not good advice.  This is about reshaping, not rebuilding.

I'm sorry, but I think you've completely missed the point.

NeilBrown


>=20
> If you don't have hot-swap drives, you should still be able to use mdadm
> to set faulty and remove sdd3, shut down, replace sdd, and reboot.  Make
> sure your /etc/mdadm.conf file is up to date and accurate before
> shutting down.  Alternatively, make sure mdadm *won't* probe for raid
> arrays, and instead assemble it manually after booting; that might be a
> more sure way to do it.  Either way, with four working disks your new
> raid6 can still suffer one more drive failure and still be usable.
>=20
> Of course, insert the standard disclaimer about RAID not being a
> replacement for backups.  :)  If it won't take too long, you might
> consider doing and/or refreshing your backups before attempting
> anything.  (The hot-swap method is reasonably safe as long as you're
> *positive* you're removing the correct disk.)
>=20
> --keith
>=20
>=20
>=20


--Sig_/9iIP1g0SG5OVVJ35PdH1UI3
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTr8/zDnsnt1WYoG5AQKSbA/+MzK/C2OOlUvOwMa0od3XdBQ43LwJyZWD
lFuwQzOoRbBSJVF4NIX1AzQXmkACAvKfQfRtfWYKtNa0LrBWvt+1NXoejx4RE3CK
/EeeMP/e2LBHP+uF5Z5AHNiNS6F+sf3usVZx1BvyjsvFzI1pe4YECcxGLEFWgMAZ
atbzUHd0AkzQVB7ndL9l88M5fHXu5zMWQvmAPRdwVHXrRog1zTinxFQq5ODHZfGE
hPqzxEqNKQBwh7H1zF8c7xdRwFQzhWYqZ7FlxDv7EqN7wDOyZkt8fxXgPM62r5A5
e3MU4v/bndwSvvicHkcK7zzHTrZmKBltr0caWpVmbjNQpAHMu024th6FLKsdDZFT
vi+RKLlPfTa6U6MimBMWmRYC6pvTyK5RLjri5+3QwN0uSzjWwdJ03b+8FoUGAWGG
ylaH7HgA9xEyxiJWueO75QYShpzvVYIoOz/DAkC/SIyTKbq6N2bZLUMseDL6sPsY
4MnBaWjfj7eZohzbkIubVkRGJSr0fMRTYLt7eogxqczRpfwoqfQ5doTTaSAMAFWQ
C6Pz9FrCQR+QoIMEUcCiFa9/hUv7+rSAxiiGir0QBAEtvlRqtoYYs6N20kU8IZ1P
W0R8xOBFoJJYV3MBtNfdf9C6Bmqm+byoZhVhfIrlIIfMyEItQWcT3AJVQR1pBRyM
mRxVV1S3EXc=
=bIH2
-----END PGP SIGNATURE-----

--Sig_/9iIP1g0SG5OVVJ35PdH1UI3--
