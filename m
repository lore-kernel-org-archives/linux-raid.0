From: NeilBrown <neilb@suse.de>
Subject: Re: Please Help! RAID5 -> 6 reshapre gone bad
Date: Tue, 7 Feb 2012 14:39:41 +1100
Message-ID: <20120207143941.58c3ccb6@notabene.brown>
References: <CAOANJV-V8ZTXBvQxxMnEnv24p8A-fAas-6x65ifW5yp35ZqHnA@mail.gmail.com>
	<20120207133947.5c4b9a59@notabene.brown>
	<20120207141023.22cce706@notabene.brown>
	<CAOANJV_jC_jvUuNuB96ARwJDyg1KAR1ind6uvjTFb4pfuyaHag@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/o1hKw3UOL_atpm4yVhyreer"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAOANJV_jC_jvUuNuB96ARwJDyg1KAR1ind6uvjTFb4pfuyaHag@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Richard Herd <2001oddity@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/o1hKw3UOL_atpm4yVhyreer
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 7 Feb 2012 14:19:06 +1100 Richard Herd <2001oddity@gmail.com> wrote:

> Hi Neil,
>=20
> Thanks.
>=20
> FYI, I've cloned your git repo and compiled and tried using your code.
>  Unfortunately everything looks the same as below (exactly same
> output, exactly same dmesg - still wants to kick non-fresh sdc from
> the array at assemble).

Strange.

Please report output of=20
  git describe HEAD

and also run the 'mdadm --assemble --force ....' with -vvv as well, and
report all of the output.

Also I think some of you devices have changed named a bit.  Make sure you
list exactly the 6 devices that were recently in the array. i.e. exactly
those that report something sensible to "mdadm -E /dev/WHATEVER"

NeilBrown


--Sig_/o1hKw3UOL_atpm4yVhyreer
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTzCc/Tnsnt1WYoG5AQKX6xAAsmPZh4suJQZ5+8La3wxh5oEfc+kwz8Jw
JKeAbR0D7DMlELQ+m9Y3YvBrFlRbwI8qtFsu/z2J27QrHZhRkU7+SeGF2UqDXMWi
ZyNKeCk9Aw4aM4ip9YQ1HldVQCFO5jg590RIkUi2/m7E706egfeUCMQ/6ArGOAoZ
AMuvkK3H630VZ7+sIO9bSfwlcRS/ldEuCoTPSu8ZUdyB6FWiUlVVtrLOREP2pLW4
8BvLd2G94MTi8ZUh27slVozgrjEuRICs7RNB1CbDpueOT0gaLPp9RRW/D80kd+FI
59illYXx9w2rD0Ih3iMqeoBndajt4HVkOZnHfRGat1SO7kVF0l/cyNYJSygKONMc
tKP4eq7maffV+IlUMHOIFMU90cKdzSnCe2GDOM0wtQPxvloSDRw4T9bwHkNTthJc
U9peNgLG+99AO9KcxhDyXKxWhq+CxX+wzHRx4fDEVNcwMLBjJbO5WeA4Dl3bYHIS
zfx5mCI9wHWv8Nd0tdk6pPrEkHRs/MFxd8zsX13ndhslL1OjZinwHuzRHQa4AtSo
79GdRsCPqU6Dn02dui1kOegvdYitpkmADZSIVslJcXsqjXIHDDbjkoxt/wFLoei6
U23ThDb8TrnoM99Hbu6aAosper2p5RWC9DoM4YCYAvtt0gjybN2wCeeX9Jw83G3u
k3aZWXjmlco=
=7p1U
-----END PGP SIGNATURE-----

--Sig_/o1hKw3UOL_atpm4yVhyreer--
