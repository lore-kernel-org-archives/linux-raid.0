From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: The huge different performance of sequential read between
 RAID0 and RAID5
Date: Thu, 28 Jan 2010 15:27:55 +0000
Message-ID: <20100128152755.GA23933@cthulhu.home.robinhill.me.uk>
References: <100eff551001271916y116de081la77982f4b5a03c73@mail.gmail.com>
 <20100128070606.GD3098@boogie.lpds.sztaki.hu>
 <100eff551001280631h7de01ba6n52d79fdfcea9445e@mail.gmail.com>
 <20100128144118.GB17369@twister.selfip.org>
 <100eff551001280655r2e173286nfca3dbf688609571@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YZ5djTAD1cGYuMQK"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <100eff551001280655r2e173286nfca3dbf688609571@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--YZ5djTAD1cGYuMQK
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu Jan 28, 2010 at 09:55:05AM -0500, Yuehai Xu wrote:

> 2010/1/28 Gabor Gombas <gombasg@sztaki.hu>:
> > On Thu, Jan 28, 2010 at 09:31:23AM -0500, Yuehai Xu wrote:
> >
> >> >> md0 : active raid5 sdh1[7] sdg1[5] sdf1[4] sde1[3] sdd1[2] sdc1[1] =
sdb1[0]
> >> >> =A0 =A0 =A0 631353600 blocks level 5, 64k chunk, algorithm 2 [7/6] =
[UUUUUU_]
> > [...]
> >
> >> I don't think any of my drive fail because there is no "F" in my
> >> /proc/mdstat output
> >
> > It's not failed, it's simply missing. Either it was unavailable when the
> > array was assembled, or you've explicitely created/assembled the array
> > with a missing drive.
>=20
> I noticed that, thanks! Is it usual that at the beginning of each
> setup, there is one missing drive?
>=20
Yes - in order to make the array available as quickly as possible, it is
initially created as a degraded array.  The recovery is then run to
add in the extra disk.  Otherwise all disks would need to be written
before the array became available.

> >
> >> How do you know my RAID5 array has one drive missing?
> >
> > Look at the above output: there are just 6 of the 7 drives available,
> > and the underscore also means a missing drive.
> >
> >> I tried to setup RAID5 with 5 disks, 3 disks, after each setup,
> >> recovery has always been done.
> >
> > Of course.
> >
> >> However, if I format my md0 with such command:
> >> mkfs.ext3 -b 4096 -E stride=3D16 -E stripe-width=3D*** /dev/XXXX, the
> >> performance for RAID5 becomes usual, at about 200~300M/s.
> >
> > I suppose in that case you had all the disks present in the array.
>=20
> Yes, I did my test after the recovery, in that case, does the "missing
> drive" hurt the performance?
>=20
If you had a missing drive in the array when running the test, then this
would definitely affect the performance (as the array would need to do
parity calculations for most stripes).  However, as you've not actually
given the /proc/mdstat output for the array post-recovery then I don't
know whether or not this was the case.

Generally, I wouldn't expect the RAID5 array to be that much slower than
a RAID0.  You'd best check that the various parameters (chunk size,
stripe cache size, readahead, etc) are the same for both arrays, as
these can have a major impact on performance.

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--YZ5djTAD1cGYuMQK
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkthrPsACgkQShxCyD40xBK09gCgoEAY6X1+9Q9hUgX3JMokXYSx
7ksAoNlkJPywe6rb4qhcZPxAlQi+Xx2n
=XFk2
-----END PGP SIGNATURE-----

--YZ5djTAD1cGYuMQK--
