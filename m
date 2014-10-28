From: NeilBrown <neilb@suse.de>
Subject: Re: Raid1 element stuck in (S) state
Date: Wed, 29 Oct 2014 08:42:24 +1100
Message-ID: <20141029084224.6d92d8be@notabene.brown>
References: <87k33lwq7s.fsf@muck.riseup.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/+q63m2Dholfp9u/.10G79kk"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87k33lwq7s.fsf@muck.riseup.net>
Sender: linux-raid-owner@vger.kernel.org
To: micah anderson <micah@debian.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/+q63m2Dholfp9u/.10G79kk
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 27 Oct 2014 10:18:47 -0400 micah anderson <micah@debian.org> wrote:

>=20
> Hi,
>=20
> i've got a raid1 setup, where one drive died, it was replaced with a new
> one, but its stuck in a (S) state and I can't seem to get it added into
> the array, /proc/mdstat looks like this:
>=20
> md3 : active raid1 sdc1[2](S) sdd1[1]
>       976759672 blocks super 1.2 [2/1] [_U]
>=20
> where sdc1 is the replaced drive.
>=20
> What is the right way to get this added back?
>

I've a feeling this bug might have been fixed.
What versions of mdadm and Linux are you using?

Are there any errors in the kernel logs when you --add the device?

NeilBrown

--Sig_/+q63m2Dholfp9u/.10G79kk
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBVFANwTnsnt1WYoG5AQLh6A/9GRH4BuSX29X5OhDy0l1/atJqQBLlcI/e
FBDkEyn2qfN7zlV9lkEhCBQvUP21zjUpRpSGAWSKOM4ZsEWAecD0rmZuZXA+ZvrE
R0Hme1C6ZD+ktBNpOeZgvu+5Ljlze15gyS66kZXMGhobRQ1/0A8wjVZaq1UeKYge
5AnHstpr6pw8ErLsa0ZnDbyZyP5NDGsysSfXy2OBg5fef5HekYKCJMPfhGxWLYjr
ivUDldYEe9DbAwO2saEBsSS1DJBydwTxLLvrLwndWtqIDco+68XdAPY8c+lnpAUN
1OUcFkQiYIpudvAPBsk3Wt1KCTz+lb3W4ziXClIKm5+WTKPA8FGn4dF5e+lFW+B6
Oi6+e5zF8lvWnVQjEG5CtMeW+6ROHAkpMwQmerfhcK373lqeq6EGopd4d9d2O+/r
pFnryCj4k01IScjcHSE79D55nF6j/iIGzV+09lVG6+ZamwHDwh26JnDKzmRuQiti
s0znVNsczPPMSB20Ms2GJiQRiMR5ZESCOnkqt5Y8oUhr4WpPTlG0c4FhQebLvFrO
e7BuWXOHE1drU3RCK1+GyRDi4WPkhaL6JxvN1ANszn5EzueUDtHsybMDjPmrxe5N
o0LlRpYne3cyceXel+fcxbEZOU+cDBU7dAAAOISnU8S7TEDWIbx1A0YWRCFkbWzr
IaC/Y5VlgO8=
=gTsM
-----END PGP SIGNATURE-----

--Sig_/+q63m2Dholfp9u/.10G79kk--
