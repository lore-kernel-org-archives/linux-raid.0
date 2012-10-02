From: NeilBrown <neilb@suse.de>
Subject: Re: Upgrade from Ubuntu 10.04 to 12.04 broken raid6.
Date: Tue, 2 Oct 2012 15:04:48 +1000
Message-ID: <20121002150448.04349054@notabene.brown>
References: <loom.20120930T105755-205@post.gmane.org>
	<alpine.DEB.2.00.1209301203060.13902@uplift.swm.pp.se>
	<50689B6C.8000307@ejane.org>
	<CADNH=7GbKAvciDoZ1gEBCBUjqdMHJohrBrxoZXpvnNHAW2vQ6g@mail.gmail.com>
	<50689C9B.1010603@ejane.org>
	<5068AB81.1060103@turmel.org>
	<5068D464.4030504@ejane.org>
	<20121002121520.362564ef@notabene.brown>
	<506A6524.1030202@ejane.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/nyIIuix8JJoh9gRxHGCsbdM"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <506A6524.1030202@ejane.org>
Sender: linux-raid-owner@vger.kernel.org
To: EJ Vincent <ej@ejane.org>
Cc: Phil Turmel <philip@turmel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/nyIIuix8JJoh9gRxHGCsbdM
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, 01 Oct 2012 23:53:08 -0400 EJ Vincent <ej@ejane.org> wrote:

> On 10/1/2012 10:15 PM, NeilBrown wrote:
> > On Sun, 30 Sep 2012 19:23:16 -0400 EJ Vincent <ej@ejane.org> wrote:
> >
> >> On 9/30/2012 4:28 PM, Phil Turmel wrote:
> >>> On 09/30/2012 03:25 PM, EJ Vincent wrote:
> >>>> On 9/30/2012 3:22 PM, Mathias Bur=C3=A9n wrote:
> >>>>> Can't you just boot off an older Ubuntu USB, install mdadm and scan=
 /
> >>>>> assemble, see the device order?
> >>>> Hi Mathias,
> >>>>
> >>>> I'm under the impression that damage to the metadata has already been
> >>>> done by 12.04, making a recovery from an older version of Ubuntu
> >>>> (10.04), impossible.  Is this line of thinking, flawed?
> >>> Your impression is correct.  Permanent damage to the metadata was don=
e.
> >>>    You *must* re-create your array.
> >>>
> >>> However, you *cannot* use your new version of mdadm, as it will get t=
he
> >>> data offset wrong.  Your first report showed a data offset of 272.
> >>> Newer versions of mdadm default to 2048.  You *must* perform all of y=
our
> >>> "mdadm --create --assume-clean" permutations with 10.04.
> >>>
> >>> Do you have *any* dmesg output from the old system?  Or dmesg from the
> >>> very first boot under 12.04?  That might have enough information to
> >>> shorten your search.
> >>>
> >>> In the future, you should record your setup by saving the output of
> >>> "mdadm -D" on each array, "mdadm -E" on each member device, and the
> >>> output of "ls -l /dev/disk/by-id/"
> >>>
> >>> Or try my documentation script "lsdrv". [1]
> >>>
> >>> HTH,
> >>>
> >>> Phil
> >>>
> >>> [1] http://github.com/pturmel/lsdrv
> >>>
> >>> --
> >>> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> >>> the body of a message to majordomo@vger.kernel.org
> >>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >> Hi Phil,
> >>
> >> Unfortunately I don't have any dmesg log from the old system or the
> >> first boot under 12.04.
> >>
> >> Getting my system to boot at all under 12.04 was chaotic enough, with
> >> the overly-aggressive /usr/share/initramfs-tools/scripts/mdadm-functio=
ns
> >> ravaging my array and then dropping me to a busybox shell over and over
> >> again.  I didn't think to record the very first error.
> >>
> >> Here's an observation of mine, disks: /dev/sdb1, /dev/sdi1, and
> >> /dev/sdj1 don't have the Raid level "-unknown-", neither are they
> >> labeled as spares.  They are in fact, labeled clean and appear
> >> *different* from the others.
> >>
> >> Could these disks still contain my metadata from 10.04?  I recall duri=
ng
> >> my installation of 12.04 I had anywhere from 1 to 3 disks unpowered, so
> >> that I could drop in a SATA CD/DVDRW into the slot.
> >>
> >> I am downloading 10.04.4 LTS and will be ready to use it soon.  I fear
> >> having to do permutations-- 9! (factorial) would mean 362,880
> >> combinations.  *gasp*
> > You might be able to avoid the 9! combinations, which could take a whil=
e ...
> > 4 days if you could test one per second.
> >
> > Try this:
> >
> >   for i in /dev/sd?1; do echo -n $i '' ; dd 2> /dev/null if=3D$i bs=3D1=
 count=3D4 \
> >      skip=3D4256 | od -D | head -n1; done
> >
> > This reads that 'dev_number' fields out of the metadata on each device.
> > This should not have been corrupted by the bug.
> > You might want some other pattern in place of "/dev/sd?1" - it needs to=
 match
> > all the devices in your array.
> >
> > Then on one of the devices which doesn't have corrupted metadata, run
> >
> >    dd 2> /dev/null if=3D/dev/sdXXX1 bs=3D2 count=3D$COUNT skip=3D2176 |=
 od -d
> >
> > where $COUNT is one more than the largest number that was reported in t=
he
> > "dev_number" values reported above.
> >
> > Now for each device, take the dev_number that was reported, use that as=
 an
> > index into the list of numbers produced by the second command, and that
> > number if the role of the device in the array.  i.e. it's position in t=
he
> > list.
> >
> > So after making an array of 5 'loop' devices in a non-obvious order, and
> > failing a device and re-adding it:
> >
> > # for i in /dev/loop[01234]; do echo -n $i '' ; dd 2> /dev/null if=3D$i=
 bs=3D1 count=3D4 skip=3D4256 | od -D | head -n1; done
> > /dev/loop0 0000000          3
> > /dev/loop1 0000000          4
> > /dev/loop2 0000000          1
> > /dev/loop3 0000000          0
> > /dev/loop4 0000000          5
> >
> > and
> >
> > # dd 2> /dev/null if=3D/dev/loop0 bs=3D2 count=3D6 skip=3D2176 | od -d
> > 0000000     0     1 65534     3     4     2
> > 0000014
> >
> > So /dev/loop0 has dev_number '3'. Look for entry '3' in the list and ge=
t '3'
> > /dev/loop1 has 'dev_number' 4, so is device 4
> > /dev/loop4 has dev_number '5', so is device 2
> > etc
> > So we can reconstruct the order of devices:
> >
> >   /dev/loop3 /dev/loop2 /dev/loop4 /dev/loop0 /dev/loop1
> >
> > Note the '65534' in the list means that there is no device with that
> > dev_number.  i.e. no device is number '2', and looking at the list conf=
irms
> > that.
> >
> > You should be able to perform the same steps to recover the correct ord=
er to
> > try creating the array.
> >
> > NeilBrown
> >
>=20
>=20
> Hi Neil,
>=20
> Thank you so much for taking the time to help me through this.
>=20
> Here's what I've come up with, per your instructions:
>=20
> /dev/sda1 0000000          4
> /dev/sdb1 0000000         11
> /dev/sdc1 0000000          7
> /dev/sde1 0000000          8
> /dev/sdf1 0000000          1
> /dev/sdg1 0000000          0
> /dev/sdh1 0000000          6
> /dev/sdi1 0000000         10
> /dev/sdj1 0000000          9
>=20
> dd 2> /dev/null if=3D/dev/sdc1 bs=3D2 count=3D12 skip=3D2176 | od -d
> 0000000     0     1 65534 65534     2 65534     4     5
> 0000020     6     7     8     3
> 0000030
>=20
> Mind doing a sanity check for me?
>=20
> Based on the above information, one such possible device order is:
>=20
> /dev/sdg1 /dev/sdf1 /dev/sdb1* /dev/sdi1* /dev/sda1 /dev/sdj1* /dev/sdh1=
=20
> /dev/sdc1 /dev/sde1
>=20
> where * represents the three unknown devices marked by 65534?

Nope.  The 65534 entries should never come into it.

 sdg1 sdf1 sda1 sdb1 sdh1 sdc1 sde1 sdj1 sdi1=20

e.g. sdi1 is device '10'.  Entry 10 in the array is 8, so sdi1 goes in
position 8.

>=20
> Once I have your blessing, would I then proceed to:
>=20
> mdadm --create /dev/md0 --assume-clean --level=3D6 --raid-devices=3D9=20
> --metadata=3D1.2 --chunk=3D512 /dev/sdg1 /dev/sdf1 /dev/sdb1* /dev/sdi1*=
=20
> /dev/sda1 /dev/sdj1* /dev/sdh1 /dev/sdc1 /dev/sde1
>=20
> and this is non-destructive, so I can attempt different orders?

Yes.  Well, it destroys the metadata so make sure you have a copy of the "-=
E"
for each device, and it wouldn't hurt to run that second 'dd' command on
every device and keep that just in case.

NeilBrown

>=20
> Again, thank you for the help.
>=20
> Best wishes,
>=20
> -EJ


--Sig_/nyIIuix8JJoh9gRxHGCsbdM
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUGp18Dnsnt1WYoG5AQLiQxAAqnUi2W8dbCtvmI3hs+m7bI8VVk/XKPuv
qkRgRfOmb9TZZz7HSY4oQu2tCk8D5i7tJaZSFTrvbE+rsHVOYMup+rgG5j9ity54
xvkKp9woYvRXbgSqkRxTxGtypgtYIc0RZk81O4scmVCN8O8w3rnHQEJJTXJ43/TB
lS8j3g96lXO9nayC5rPgLEhPeMaqql1rCGrm7QKgkBBwe04kcb0Xi50JQ8ffVj1Q
dOoz+GO6qFyVyWBqdRL2mKxskPMDbrDQcZr4CP33t51qVvqG6ATbDOSaf+zYiEJ4
+Z0yx8386bRX1FE9Rv4uKgWoTywKPib4OqhtaOPUzCPDFAzLd2qPIGMl4qrFAeev
OH6IoO62WgUbquCBgEmAIaHxQAN9WjI47EQyaT5tyfDToRPfTzOF6jlbYFu9WKW4
T2NENo1kHhqcU+KilqURoNS5P73XehNlDPrDwcfenwCmpvZi6Q9Ce4hqrxnPgMOw
13aF/AgYZs1XpcD2WUEsSCusY4oIXPzoZOLYBi20QT8mAYSCSUO1fj+eHl+LEcYE
qv2bhe396ct4lzfPPlyaDc6dcuQFduF/2/ul+JVFcV9sLfd3k0dcqUtf93CQAw7G
FvPxUflujGSOHc/qZDCOdByqiaO80OW7jm2/4b+WzorbZ5sslfAfioP3q9aC0xTY
NU5WSYLKIdw=
=0JRs
-----END PGP SIGNATURE-----

--Sig_/nyIIuix8JJoh9gRxHGCsbdM--
