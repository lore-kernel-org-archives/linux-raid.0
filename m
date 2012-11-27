From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: a question about how to repair raid5
Date: Tue, 27 Nov 2012 08:58:05 +0000
Message-ID: <20121127085805.GA2836@cthulhu.home.robinhill.me.uk>
References: <201211262032343900581@meganovo.com>
 <20121126125055.GA29049@cthulhu.home.robinhill.me.uk>
 <201211271020210628374@meganovo.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FCuugMFkClbJLl1L"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <201211271020210628374@meganovo.com>
Sender: linux-raid-owner@vger.kernel.org
To: hanguozhong <hanguozhong@meganovo.com>
Cc: Robin Hill <robin@robinhill.me.uk>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--FCuugMFkClbJLl1L
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue Nov 27, 2012 at 10:20:25AM +0800, hanguozhong wrote:

> >>From: Robin Hill
> >>Date: 2012-11-26 20:50
> >>To: hanguozhong
> >>CC: linux-raid
> >>Subject: Re: a question about how to repair raid5
> >>On Mon Nov 26, 2012 at 08:32:38 +0800, hanguozhong wrote:
>=20
> > Hi, every one:
> > I have a question about how to repair raid5.
> > Days ago, I received a email from the monitor of mdadm.=20
> > The email told me that there were lots of mismatch_cnt in the array.=20
> > Then I tried to find the solution of this problem on Google. Most
> > solutions were as the following:
> >=20
> > #echo repair /sys/block/md0/md/sync_action
> > #echo "check" > /sys/block/md0/md/sync_action
> > #cat /sys/block/md0/md/mismatch_cnt
> >=20
> > I did repair the array like the above.=20
> > But I found that it took lots of time to "repair" and "check" the array=
=2E=20
> > Why there was a "check" after "repair"I did not know. And it spent
> > as much time as "repair".
> > Is it redundant? Anyone can help me?
>=20
> >>That's the correct process, yes. The "check" will verify whether the
> >>parity block for each stripe is correct, whereas the "repair" will also
> >>rewrite any parity blocks which don't match. You rerun the "check" after
> >>the "repair" to ensure that everything has been repaired correctly (if
> >>there's still mismatches then it would point towards a problem with your
> >>setup somewhere). Both are doing a full read of all disks, so will take
> >>about the same time (the number of additional writes that the "repair"
> >>needs to do should not impact on the time significantly).
>=20
> Hmm, I know what you mean. But there is a question I still do not quit
> understand.
> Why "repair" action does not record the blocks that not be repaired,
> and then the "check" action will do a full read of all disks again? I
> do not understand.
> =20
As far as md knows, there are no blocks which could not be repaired by
"repair". If the rewrite of the parity block reports an error then the
appropriate disk would be failed from the array, the same as it would
for a write error during normal operation. After a "repair", the
array should be in sync, unless there's something wrong with the
disk/controller/memory/processor/etc. and the data failed to write
without reporting an error, or the incorrect checksum was generated, or
the data written to disk was corrupted in transit, or whatever.=20

Any parity mismatches on a RAID5/6 array indicate that something has
gone wrong either in the process of writing data to disk or in the disk
retaining the data (mismatches on RAID1 array can occur during normal
operation though), but in most cases these are transient problems
(cosmic rays flipping bits, etc), so a check/repair on a regular basis
will pick up and/or deal with any of these. The check afterwards will
help to pick up any issues which are not transient.

HTH,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--FCuugMFkClbJLl1L
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAlC0gJwACgkQShxCyD40xBLpwwCg2zr+EtsSHGseFJgSH3LrfEjz
g9UAoL9FlHbGrD95lfqgKCgXoctySNXi
=Cblz
-----END PGP SIGNATURE-----

--FCuugMFkClbJLl1L--
