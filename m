From: NeilBrown <neilb@suse.de>
Subject: Re: Upgrade from Ubuntu 10.04 to 12.04 broken raid6.
Date: Tue, 2 Oct 2012 12:15:20 +1000
Message-ID: <20121002121520.362564ef@notabene.brown>
References: <loom.20120930T105755-205@post.gmane.org>
	<alpine.DEB.2.00.1209301203060.13902@uplift.swm.pp.se>
	<50689B6C.8000307@ejane.org>
	<CADNH=7GbKAvciDoZ1gEBCBUjqdMHJohrBrxoZXpvnNHAW2vQ6g@mail.gmail.com>
	<50689C9B.1010603@ejane.org>
	<5068AB81.1060103@turmel.org>
	<5068D464.4030504@ejane.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Q9rvXoiB218BajpJ+aIP_UB"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5068D464.4030504@ejane.org>
Sender: linux-raid-owner@vger.kernel.org
To: EJ Vincent <ej@ejane.org>
Cc: Phil Turmel <philip@turmel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/Q9rvXoiB218BajpJ+aIP_UB
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Sun, 30 Sep 2012 19:23:16 -0400 EJ Vincent <ej@ejane.org> wrote:

> On 9/30/2012 4:28 PM, Phil Turmel wrote:
> > On 09/30/2012 03:25 PM, EJ Vincent wrote:
> >> On 9/30/2012 3:22 PM, Mathias Bur=C3=A9n wrote:
> >>> Can't you just boot off an older Ubuntu USB, install mdadm and scan /
> >>> assemble, see the device order?
> >> Hi Mathias,
> >>
> >> I'm under the impression that damage to the metadata has already been
> >> done by 12.04, making a recovery from an older version of Ubuntu
> >> (10.04), impossible.  Is this line of thinking, flawed?
> > Your impression is correct.  Permanent damage to the metadata was done.
> >   You *must* re-create your array.
> >
> > However, you *cannot* use your new version of mdadm, as it will get the
> > data offset wrong.  Your first report showed a data offset of 272.
> > Newer versions of mdadm default to 2048.  You *must* perform all of your
> > "mdadm --create --assume-clean" permutations with 10.04.
> >
> > Do you have *any* dmesg output from the old system?  Or dmesg from the
> > very first boot under 12.04?  That might have enough information to
> > shorten your search.
> >
> > In the future, you should record your setup by saving the output of
> > "mdadm -D" on each array, "mdadm -E" on each member device, and the
> > output of "ls -l /dev/disk/by-id/"
> >
> > Or try my documentation script "lsdrv". [1]
> >
> > HTH,
> >
> > Phil
> >
> > [1] http://github.com/pturmel/lsdrv
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20
> Hi Phil,
>=20
> Unfortunately I don't have any dmesg log from the old system or the=20
> first boot under 12.04.
>=20
> Getting my system to boot at all under 12.04 was chaotic enough, with=20
> the overly-aggressive /usr/share/initramfs-tools/scripts/mdadm-functions=
=20
> ravaging my array and then dropping me to a busybox shell over and over=20
> again.  I didn't think to record the very first error.
>=20
> Here's an observation of mine, disks: /dev/sdb1, /dev/sdi1, and=20
> /dev/sdj1 don't have the Raid level "-unknown-", neither are they=20
> labeled as spares.  They are in fact, labeled clean and appear=20
> *different* from the others.
>=20
> Could these disks still contain my metadata from 10.04?  I recall during=
=20
> my installation of 12.04 I had anywhere from 1 to 3 disks unpowered, so=20
> that I could drop in a SATA CD/DVDRW into the slot.
>=20
> I am downloading 10.04.4 LTS and will be ready to use it soon.  I fear=20
> having to do permutations-- 9! (factorial) would mean 362,880=20
> combinations.  *gasp*

You might be able to avoid the 9! combinations, which could take a while ...
4 days if you could test one per second.

Try this:

 for i in /dev/sd?1; do echo -n $i '' ; dd 2> /dev/null if=3D$i bs=3D1 coun=
t=3D4 \
    skip=3D4256 | od -D | head -n1; done

This reads that 'dev_number' fields out of the metadata on each device.
This should not have been corrupted by the bug.
You might want some other pattern in place of "/dev/sd?1" - it needs to mat=
ch
all the devices in your array.

Then on one of the devices which doesn't have corrupted metadata, run

  dd 2> /dev/null if=3D/dev/sdXXX1 bs=3D2 count=3D$COUNT skip=3D2176 | od -d

where $COUNT is one more than the largest number that was reported in the
"dev_number" values reported above.

Now for each device, take the dev_number that was reported, use that as an
index into the list of numbers produced by the second command, and that
number if the role of the device in the array.  i.e. it's position in the
list.

So after making an array of 5 'loop' devices in a non-obvious order, and
failing a device and re-adding it:

# for i in /dev/loop[01234]; do echo -n $i '' ; dd 2> /dev/null if=3D$i bs=
=3D1 count=3D4 skip=3D4256 | od -D | head -n1; done
/dev/loop0 0000000          3
/dev/loop1 0000000          4
/dev/loop2 0000000          1
/dev/loop3 0000000          0
/dev/loop4 0000000          5

and=20

# dd 2> /dev/null if=3D/dev/loop0 bs=3D2 count=3D6 skip=3D2176 | od -d
0000000     0     1 65534     3     4     2
0000014

So /dev/loop0 has dev_number '3'. Look for entry '3' in the list and get '3'
/dev/loop1 has 'dev_number' 4, so is device 4
/dev/loop4 has dev_number '5', so is device 2
etc
So we can reconstruct the order of devices:

 /dev/loop3 /dev/loop2 /dev/loop4 /dev/loop0 /dev/loop1

Note the '65534' in the list means that there is no device with that
dev_number.  i.e. no device is number '2', and looking at the list confirms
that.

You should be able to perform the same steps to recover the correct order to
try creating the array.

NeilBrown


--Sig_/Q9rvXoiB218BajpJ+aIP_UB
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUGpOODnsnt1WYoG5AQI5tQ/8D/lP0CiOqIPPLwXsrgvNGdDkGF1LEeLi
H9lSfeU6VQjIvmuv380Sd56zFoSO6XQg2EzIQW7lCdCdqmgy1eJd7ooukVDuS9PO
yAVxz5fXslyT9U3ZQW9Nu0320rs1apGMX2hh1jOiIzdD+t/LGKIMdOvAQMJH/oPW
qirZMHFMftwI0a2i15DUwSzr5xMkHtZzIt59JTVv2zfk7LN6ChxnVLEh2t19q3LZ
MOHRRNTt/mWDobExBcobnMzXMxAtOMr2swAN24NAd9oMoZ1rKHeGKwEJFzppAi1W
g6yKPS55AVAWV0Z7dkPeXNQEBEsYxBilPhkI9pr5nHkILUoXNmV+xVvUdq357ljP
zsYyRrgm5jmXc4MVCpdd7Nui6VHNbuPLqf11dU6jdJ+9LIhdMXVouHm7pkIkn/aA
nW3lPrmtKbRw6rBUqlO6c09VMf4uD9mGrOWbc3uLkLZH3Q5c8iL56T0G0GYbtB0R
HFW3voIYBgQx9F+NUQKs9GWHmSP18b095e1MqaEYVOvDuCFPR3rgEBeUd1uOGAcm
GfeUgtZG+UuLI8cbMTdoiHoE5wCxINZBp+AQctg7AZuE0/TcB1tmPS29R9ZBqDVA
W3JfBWbZaFMwMuO/55/lJ7J0xiNDLYOXGtJoTDSSaRzEMibLUpO69D7cqwI/1Xjs
P+yfLDKpA9I=
=Cs9F
-----END PGP SIGNATURE-----

--Sig_/Q9rvXoiB218BajpJ+aIP_UB--
