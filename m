From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: md RAID5: Disk wrongly marked "spare", need to force re-add it
Date: Thu, 18 Apr 2013 15:38:05 +0100
Message-ID: <20130418143805.GA6558@cthulhu.home.robinhill.me.uk>
References: <516869D2.9030506@bucksch.org>
 <516B3077.9020507@schinagl.nl>
 <516B590C.5060807@bucksch.org>
 <516AE7A0.4070504@schinagl.nl>
 <516BD5E0.4040007@bucksch.org>
 <516FF25B.4000907@bucksch.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IS0zKkzwUGydFO0o"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <516FF25B.4000907@bucksch.org>
Sender: linux-raid-owner@vger.kernel.org
To: Ben Bucksch <linux.news@bucksch.org>
Cc: Oliver Schinagl <oliver+list@schinagl.nl>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--IS0zKkzwUGydFO0o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu Apr 18, 2013 at 03:17:15PM +0200, Ben Bucksch wrote:

> To re-summarize (for full info, see first post of thread):
> * There are 2 RAID5 arrays in the machine, each have 8 disks.
> * I upgraded Ubuntu 10.04 to 12.04.
> * After reboot, both arrays had each ejected one disk.
>    The ejected disks are working fine (at least now).
> * During the resync mandated by above ejection,
>     one other drive failed, this one fatally with a real hardware failure.
> * The second array resynced fine, further proving that the
>     disks ejected during upgrade were working.
> * Now I am left with: originally 8-disk RAID5, 6 disks are healthy,
>    1 disk with hardware failure, and 1 disk that was ejected, but is=20
> working.
> * The latter is currently marked "spare" by md and has an event count
>    (only) 2 events lower than the other 6 disks.
> * My task is to get the latter disk back online *with* its data, without=
=20
> resync.
>=20
> I desperately need help, please.
>=20
> Based on suggestions here by Oliver and on forums, I did (and the result=
=20
> is):
>=20
> > # mdadm --stop /dev/md0
> > mdadm: stopped /dev/md0
> > # mdadm --assemble --run --force /dev/md0 /dev/sd[jlmnopq]
> > mdadm: failed to RUN_ARRAY /dev/md0: Input/output error
> > mdadm: Not enough devices to start the array.
> > # cat /proc/mdstat
> > md0 : inactive sdj[0] sdq[7] sdn[6] sdp[5] sdo[4] sdm[3]
> >       5860574976 blocks
> > (Note that sdl is not even listed)
> > # mdadm --re-add /dev/md0 /dev/sdl
> > mdadm: re-added /dev/sdl
> > # cat /proc/mdstat
> > md0 : inactive sdl[8](S) sdj[0] sdq[7] sdn[6] sdp[5] sdo[4] sdm[3]
> >       6837337472 blocks
> >
That won't work here as sdl was being rebuilt at the time of the
failure. md therefore 'knows' that it doesn't have the correct data on
and can't be used to assemble the array (I think the array position of
the disk is only written to the metadata when recovery completes).

> > Now, sdl is listed, but as spare. I need it to be treated not as=20
> > spare, but as good drive with correct data (well, almost, 2 events off=
=20
> > only). How do I do that?
> >
I can see two options here:

- Image the known faulty disk to a new one and then use that to force
  assemble the array (with the possibility of some data loss, depending
  on how much can be read from the faulty disk).
- Modify the metadata on sdl so that it shows as being a valid member of
  the array. This will require either manual editing of the superblock,
  or rerunning the "mdadm --create" command with the correct mdadm
  version (so data offsets match), disk order and parameters (chunk
  size, etc). If done correctly then there should be no data loss
  (providing that sdl, when re-added to the array, used the same data
  offset as it originally had), but get anything wrong any you'll be
  even further up the creek.

Personally I'd look into option one first. Despite the probability of
some data loss, I think it's a lower risk option overall.

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--IS0zKkzwUGydFO0o
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAlFwBUwACgkQShxCyD40xBKrmgCgkUG+JUWaD00fkrA+IwVzqeUE
C70AnRhIOAKxkGL8eE6M7X158p8z2Elc
=B+Fn
-----END PGP SIGNATURE-----

--IS0zKkzwUGydFO0o--
