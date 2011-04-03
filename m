From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: Raid 5 Array
Date: Mon, 4 Apr 2011 01:57:08 +0600
Message-ID: <20110404015708.2404ae58@natsu>
References: <BANLkTim8620MUckc+EVCWo9FCTs=65_p8Q@mail.gmail.com>
	<4D977279.30107@gmail.com>
	<BANLkTimJfUhvkpkkAH=NLJOvLL-Jotrwqg@mail.gmail.com>
	<4D97828C.8050806@gmail.com>
	<6158157523854459259@unknownmsgid>
	<20110403040113.472838d4@natsu>
	<AANLkTikJtFb0JtS1-Je9NFXn-CRc4pi7pmYFNV7v2SEg@mail.gmail.com>
	<BANLkTi=wWAE79KOPhZ0OUWpicgcD7QNG-g@mail.gmail.com>
	<BANLkTimRSmSu2XOfQ8yUxn5r2Tsq53LCmQ@mail.gmail.com>
	<BANLkTikQai-ZwuEDQDinMcYi4ics_axd7Q@mail.gmail.com>
	<20110403174900.38de17e2@notabene.brown>
	<BANLkTi=yTeG5-E=R6wy0GZe_iyxC5_7-Fg@mail.gmail.com>
	<20110403210138.584c796c@notabene.brown>
	<BANLkTik7XHyOCK8SwhPTaWxQ+K=2FRowng@mail.gmail.com>
	<20110403235049.5c940295@natsu>
	<BANLkTinzOpR-pgR1GYxgxaJhNoOUxc0D_w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/6NxEwQ0Q7f7GivFySWZ0LZ9"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTinzOpR-pgR1GYxgxaJhNoOUxc0D_w@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Marcus <nexuslite@gmail.com>
Cc: NeilBrown <neilb@suse.de>, Roberto Spadim <roberto@spadim.com.br>, Simon Mcnair <simonmcnair@gmail.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/6NxEwQ0Q7f7GivFySWZ0LZ9
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Sun, 3 Apr 2011 11:56:29 -0700
Marcus <nexuslite@gmail.com> wrote:

> Thanks! resizing the partition first worked. I had to use fdisk
> instead of cfdisk though because my partition didn't start at the
> beginning of the drive it started 17 blocks in.

Use "Reply to all" properly in your client, don't just drop all "CC:" at
will, people who tried to help you might be interested to know that the
problem is solved and what was the solution.

>=20
> On Sun, Apr 3, 2011 at 10:50 AM, Roman Mamedov <rm@romanrm.ru> wrote:
> > On Sun, 3 Apr 2011 10:46:23 -0700
> > Marcus <nexuslite@gmail.com> wrote:
> >
> >> I provided you all relevant information if you payed attention to
> >> sizes and the fact that I stated that I can add a new partition to the
> >> device you would have realized that I have already applied grow to the
> >> raid.
> >>
> >> 1465159552 raid size
> >> 976767808 partition size
> >>
> >> See how partition is smaller than raid by about 500GB?
> >
> > Then why not run "cfdisk /dev/md2" (I recommend the version from "GNU
> > fdisk"), notice that you have a 900GB partition there and 500 GB of free
> > space, then resize the partition?
> >
> >> nexuslite@ubuntu:~$ resize2fs -p /dev/md2p1
> >> resize2fs 1.41.11 (14-Mar-2010)
> >> The filesystem is already 244191952 blocks long. =C2=A0Nothing to do!
> >>
> >> There is the exact message resize2fs is returning. 244191968 is the
> >> current end block of the partition. parted also shows 244191968 as the
> >> maximum block size for a partition. There are no related dmesg because
> >> it is not an error it is just undesired results.
> >
> > You don't seem to understand the difference between /dev/md2
> > and /dev/md2p1. And also that resize2fs will not resize md2p1, it will
> > only amend the ext* filesystem so that it takes all of md2p1.
> >
> > --
> > With respect,
> > Roman
> >


--=20
With respect,
Roman

--Sig_/6NxEwQ0Q7f7GivFySWZ0LZ9
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk2Y0RQACgkQTLKSvz+PZwg7uACeMA4rik9CSwpTnzTwBHYWMFAO
MuYAnjfIeKviZy/CfRAOw2JLWK58mMvY
=zidi
-----END PGP SIGNATURE-----

--Sig_/6NxEwQ0Q7f7GivFySWZ0LZ9--
