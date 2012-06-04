From: NeilBrown <neilb@suse.de>
Subject: Re: Data Offset
Date: Mon, 4 Jun 2012 13:35:26 +1000
Message-ID: <20120604133526.6da3bf10@notabene.brown>
References: <CAFhY2CjOECFy4bWDL6zs9rtSkVGPR9Wv=1UX9vKgmdjwMsmBYg@mail.gmail.com>
	<20120602095237.3822e2c2@notabene.brown>
	<CAFhY2Cjwep5mZkYCfRn4UYmQpSyHU13dSCB8HF8F9wG8Rzx9Aw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/v1LdDiDbpTBTPDb/XPoybHb"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAFhY2Cjwep5mZkYCfRn4UYmQpSyHU13dSCB8HF8F9wG8Rzx9Aw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: freeone3000 <freeone3000@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/v1LdDiDbpTBTPDb/XPoybHb
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 1 Jun 2012 19:48:41 -0500 freeone3000 <freeone3000@gmail.com> wrote:

> Sorry.
>=20
> /dev/sde fell out of the array, so I replaced the physical drive with
> what is now /dev/sdf. udev may have relabelled the drive - smartctl
> states that the drive that is now /dev/sde works fine.
> /dev/sdf is a new drive. /dev/sdf has a single, whole-disk partition
> with type marked as raid. It is physically larger than the others.
>=20
> /dev/sdf1 doesn't have a mdadm superblock. /dev/sdf seems to, so I
> gave output of that device instead of /dev/sdf1, despite the
> partition. Whole-drive RAID is fine, if it gets it working.
>=20
> What I'm attempting to do is rebuild the RAID from the data from the
> other four drives, and bring the RAID back up without losing any of
> the data. /dev/sdb3, /dev/sdc3, /dev/sdd3, and what is now /dev/sde3
> should be used to rebuild the array, with /dev/sdf as a new drive. If
> I can get the array back up with all my data and all five drives in
> use, I'll be very happy.

You appear to have 3 devices that are happy:
  sdc3 is device 0   data-offset 2048
  sdb3 is device 1   data-offset 2048
  sdd3 is device 3   data-offset 1024

nothing claims to be device 2 or 4.

sde3 looks like it was last in the array on 23rd May, a little over
a week before your report.  Could that have been when "sde fell out of the
array" ??
Is it possible that you replaced the wrong device?
Or is it possible the the array was degraded when sde "fell out" resulting
in data loss?

I need more precise history to understand what happened, as I cannot suggest
a fixed until I have that understanding.

When did the array fail?
How certain are you that you replaced the correct device?
Can you examine the drive that you removed and see what it says?
Are you certain that the array wasn't already degraded?

NeilBrown



--Sig_/v1LdDiDbpTBTPDb/XPoybHb
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT8ws/jnsnt1WYoG5AQKEPw/+KKAl5LBtdMCPkoLgeu1VpCfIJFXvVInA
BTd6ol9WqNAtXaJ5t7CoXe9Cv2j8f4SLbnsoCjKMhmMOTCi1Kyw6yUsKZpK1I7ti
CHPzwteI1ZS2mC0Ujv0fgOV7Qm+dXVk7DJ/nzDajmFl2DtCM2b6BwE9QnR24ujGa
n1dtGES6qMd1WXkP1BMJPQ//FKg2oI/pjWQiN8fnyd0xnAjwyziDd6RuuTLlYkCR
O2VFczgquu4EuzwjiOYzfEv4rvEibtT1ilXlZn0or7KtZ71XMgfpsb2clBmIFlt2
4G1JJ2HGCZP6YCq5x+1RNYOn64lS7WXUh04VaBr3ZDXU5tiOL7twVr6pwttwojvN
0zarLRlH/4lZVip8oybQ1pltWFVCeugD3Xe8/g2+zxLcAM9H4bwDBkvu0A/rbr4R
HD0hknFEUo6PlR/EEZXDk2GyV6II+rKQK9i1stmTz8/tCNe0jkWeDYkyDz/w7H0q
WdORIQhyiWzb7/wNfZyJw62Atq0NZvexx839gPlbsANpFmEWMTcNmg9kvV8Qq8uA
K4fxFzWptQiC84w/aouTHrgf/U6Yoc59fpQ72s6LTnMN+lJKZbXxB5ETmQwrLvOc
ss9ATBM6cc9eWZxzg8Dze3P85y1EMu6Q57FENhE5r86vab5OWRDkFr/PJrCQ/jku
q6RackDElGY=
=W503
-----END PGP SIGNATURE-----

--Sig_/v1LdDiDbpTBTPDb/XPoybHb--
