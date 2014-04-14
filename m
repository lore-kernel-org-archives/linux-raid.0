From: NeilBrown <neilb@suse.de>
Subject: Re: Nvidia Raid5 Failure
Date: Mon, 14 Apr 2014 19:50:35 +1000
Message-ID: <20140414195035.4adaa221@notabene.brown>
References: <DUB122-W521994A2683B8CBD327D3DA3550@phx.gbl>
	<CAK_KU4ZHZik=_=2=fMPW1c_y-xc0DW_9=ucsYQXU2e=eSOtYQg@mail.gmail.com>
	<CACJz6QtoddN1nOcfzeJeV-09j+t9fhT=E2a17Ppxq4gXpZDcVA@mail.gmail.com>
	<534B7CAD.3080908@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/cft6YJKXs.HEQJvGSg6fyBV"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <534B7CAD.3080908@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: Drew <drew.kay@gmail.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/cft6YJKXs.HEQJvGSg6fyBV
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 14 Apr 2014 01:14:05 -0500 Stan Hoeppner <stan@hardwarefreak.com>
wrote:

> Better classification for the current era:
>=20
> 1.  RAID controller - ASIC firmware, BBWC
> 2.  HBA w/RAID      - ASIC firmware, cache less
> 3.  Fake-RAID       - host software

Can we come up with a better adjective than "fake"?
It makes sense if you say "fake RAID controller", but people don't.  They
safe "fake RAID", which sounds like the RAID is fake, which it isn't.

How about "BIOS RAID" ??  or "host RAID" ??

NeilBrown

--Sig_/cft6YJKXs.HEQJvGSg6fyBV
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU0uvaznsnt1WYoG5AQICqA//VAfOf6C3PyT5AczXt+qBmpGy8UXxswRR
YeAX3eYRJAbQGRPiFEy+95YHWw6RF8D2tkz+yE9cHbYwUcxOWO+3zpXRBjNbeV+g
12I4AX0i3MD0qDObYUcNOJ9TcyBmHmR+NvsGgmptYDP6MbG7Gz6jXT0X5+Jjk/Bq
3p/8vhV22gGJNcWh/+4mH6Rl4dadjaZ8bMYFVORbSsIgKbjW51RWBchGdDvg4Qqd
qpL8t9kJL9tMxffXTSCh7F3XicFrIN1gRPaJIqNNYL0/CEnffkzSTdmvT6AEPin1
K1naUaUX2lipeHF0xrFX3Fw9oN93vpsCkCQDX+vC5bhh62VmWzalQ5PZhr5/pTnk
qWMOe4xJ486c4wc6P8c8/Hb5Hs+3kg0WTtiKJqtzROVsfvezghWAAG3cJn0O2KH4
EVvOCc6abSMka360GhOxL3pGTed+gTpRpGjmRYBzuXavMu12rlrNO0uAhwD4369L
XoR/l2mVNBOu8o6ki4IjDHc47MPtTqK8v/MhE2Dy3tMfvtaKQBCraWRVW2Hag7Jy
FBgp8gGAFAOpU12lvoZNMCG/+LGaR7Pr7qbaznbMWCDXhbEgkwDtYdugCfw8f8ZI
e07H/RaH0x/OfFllLm64ceWNHpdFutneIP7z1MAznvAP+IQaldG+NAtqsZPWn+fL
IqkDxrOqaXc=
=gXf9
-----END PGP SIGNATURE-----

--Sig_/cft6YJKXs.HEQJvGSg6fyBV--
