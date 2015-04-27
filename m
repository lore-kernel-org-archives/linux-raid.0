From: NeilBrown <neilb@suse.de>
Subject: Re: BUG?: RAID6 reshape hung in reshape_request
Date: Mon, 27 Apr 2015 16:59:26 +1000
Message-ID: <20150427165926.6128d59b@notabene.brown>
References: <CAGivzjGyifS3r0rypqM7n2P-fcA7NvPjJWa6kV_wfGx2biDrDg@mail.gmail.com>
	<20150427112056.7195d226@notabene.brown>
	<CAGivzjE4zVGpoUdGpgKR_e+EaiBE60R3Ta=o9mW+VFqO8McrrQ@mail.gmail.com>
	<CAGivzjHvk8pSUyWOMzNioNtgpQ7gRoL=hkTX0=m7Mi8KzgRWAg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/NwVfrKG5FCM19fLlO.Wv/7H"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGivzjHvk8pSUyWOMzNioNtgpQ7gRoL=hkTX0=m7Mi8KzgRWAg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Wahler <dwahler@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/NwVfrKG5FCM19fLlO.Wv/7H
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 26 Apr 2015 20:56:58 -0500 David Wahler <dwahler@gmail.com> wrote:

> [oops, forgot to cc the list]
>=20
> On Sun, Apr 26, 2015 at 8:20 PM, NeilBrown <neilb@suse.de> wrote:
> >> And the output of mdadm --detail/-E:
> >> https://gist.github.com/anonymous/0b090668b56ef54bb2f0
> >
> > What is wrong with simply including this directly in the email???
>=20
> My bad; I wasn't sure whether it was appropriate to paste such a long
> dump inline.
>=20
> > Anyway:
> >
> >   Bad Block Log : 512 entries available at offset 72 sectors - bad bloc=
ks present.
> >
> > that is the only thing that looks at all interesting.  Particularly the=
 last
> > 3 words.
> > What does
> >    mdadm --examine-badblocks /dev/sd[cde]1
> > show?
>=20
> root@ceres:~# mdadm --examine-badblocks /dev/sd[cde]1
> Bad-blocks on /dev/sdc1:
>           3699640928 for 32 sectors
> Bad-blocks on /dev/sdd1:
>           3699640928 for 32 sectors
> Bad-blocks on /dev/sde1:
>           3699640928 for 32 sectors
>=20
> Hmm, that seems kind of odd to me. For what it's worth, all four
> drives passed a SMART self-test, and "dd > /dev/null" completed
> without errors on all of them. I just read about the "badblocks" tool
> and I'm running it now.

The array is reshaping a RAID6 from 4->5 devices, so that is 2 data disks to
3 data disks.

Reshape pos'n : 5548735488 (5291.69 GiB 5681.91 GB)

so it is about 5.3TB through the array, so it has read about 2.6TB from the
devices and written about 1.7TB to the devices.

3699640928 sectors is about 1.8TB.  That seems a little too close to be a c=
o-incidence.=20

Maybe when reshape write to somewhere that is a bad-block, it gets confused.

On the other hand, when it copies from the 1.8TB address to the 1.2TB addre=
ss
it should have record that it was bad-blocks that were being copied.  It
doesn't seem like it did.

I'll have to look at the code and try to figure out what is happening.

I don't think there is anything useful you can do in the mean time...

NeilBrown


--Sig_/NwVfrKG5FCM19fLlO.Wv/7H
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVT3eTjnsnt1WYoG5AQJyBA//Zx/8giqrxHY2jEQOFNKvRIw0vwc7r8pC
nqvnFk3TnO3OcfQcsYFwIMqLDAr7SfUOYPpzFojXgfrFdYccf11TM4vq9pgJ42wi
ejm0/Gd27kNvQF37PNw40l5qy6+3c+qiAYnl0Sm5IpmKYakewfZ/P87y7tc5766x
GouOBcXG6aWMXA0ycmhMjrvnmI659+/4hfkhBiFtTDu17LEld0EoVYQD0JUFrlI9
s94GtoSVnEKgv3iyPKFVwDBSvfwPbWUOINGKT32/G7DVzoZZ8+UYEBF7Adly2sTH
OLDXbLDuE+Xe/xGTzSxn9syKZD7h8xQf2HsyfJO0DkAYiRug2xm3H0WaqCe91Rrs
4axsvxtgajwTH+Y25x44v3/trgG7bWM5M3pYDHvzDe/nh6c7pKM879NPxXmrbWYt
JLNToEGb6PO0qniMIhshG9nsieCEp/jxHgkZ4VVfLeEMQcGS7LGPDNwxVofui6JL
nKjiqOU4KxE8c/lo93Fxw1xoqvIsO4JeT8JmKf++6D0NVfPKLPNj6Saot9fK4uW9
tfi9WcvC+g49sDmiOcCeYT5pz68/N0/b/wW9NihsOluam2r3usps8BC/D+QJWFn4
XlYPTdBBt9JGr1DSHI2GG03Pijmw6pkwqWyAEVQg04zI0G8knDsswzXZFjaQ0rkP
wHGWdMKELYQ=
=uI3v
-----END PGP SIGNATURE-----

--Sig_/NwVfrKG5FCM19fLlO.Wv/7H--
