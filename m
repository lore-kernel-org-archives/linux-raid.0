From: Markus Hochholdinger <Markus@hochholdinger.net>
Subject: Re: Is it possilble to be "delay tolerant" or have "slow dropout" of unavailable components?
Date: Tue, 8 Apr 2008 19:48:37 +0200
Message-ID: <200804081948.41959.Markus@hochholdinger.net>
References: <47FBA3BB.2030007@nrel.colostate.edu>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1231424.LoVdVrWrnt";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <47FBA3BB.2030007@nrel.colostate.edu>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--nextPart1231424.LoVdVrWrnt
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

hi,

Am Dienstag, 8. April 2008 18:56 schrieb Ty! Boyack:
> I'm curious if there is a way to have a raid set (raid5 in my case, but
> this could apply to any raid level) that could tolerate a component
> device being unavailable for a period of time.

for RAID1 there is "--write-mostly" and "--write-behind=3D". Don't know if =
this=20
is already available for RAID5.

There's also the option "--bitmap=3D" which can speedup a resync when=20
temporarily disconnecting one device.


=2D-=20
greetings

eMHa

--nextPart1231424.LoVdVrWrnt
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBH+6/5XT3LE+AjWCsRAsiSAKDedcKFMfEPLLFx7i6dHpVEN4G+SACdFoK8
AI9N7kXui55V+CwbyrirFg0=
=TzMg
-----END PGP SIGNATURE-----

--nextPart1231424.LoVdVrWrnt--
