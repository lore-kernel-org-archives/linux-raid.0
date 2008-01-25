From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: Error mounting a reiserfs on renamed raid1
Date: Fri, 25 Jan 2008 08:57:41 +0000
Message-ID: <20080125085741.GA581@cthulhu.home.robinhill.me.uk>
References: <479931E0.3020909@anagramm.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="huq684BweRXVnRxX"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <479931E0.3020909@anagramm.de>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--huq684BweRXVnRxX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri Jan 25, 2008 at 01:48:32AM +0100, Clemens Koller wrote:

> Hi there.
>
> I am new to this list, however didn't find this effect nor a
> solution to my problem in the archives or with google:
>
> short story:
> ------------
> A single raid1 as /dev/md0 containing a reiserfs (with important data)
> assembled during boot works just fine:
> $ cat /proc/mdstat
> Personalities : [linear] [raid0] [raid1]
> md0 : active raid1 hdg1[1] hde1[0]
>       293049600 blocks [2/2] [UU]
>
> The same raid1 moved to another machine as a fourth raid can be
> assembled manually as /dev/md3 (to work around naming conflicts),
> but it cannot be mounted anymore:
> $ mdadm --assemble /dev/md3 --update=3Dsuper-minor -m0 /dev/hde /dev/hdg
> does not complain. /dev/md3 is created. But
>
It looks like you should be assembling the partitions, not the disks.
Certainly the mdstat entry above shows the array being formed from the
disks.  Try:
  mdadm --assemble /dev/md3 --update=3Dsuper-minor -m0 /dev/hde1 /dev/hdg1

> $ mount /dev/md3 /raidmd3 gives:
>
> Jan 24 20:24:10 rio kernel: md: md3 stopped.
> Jan 24 20:24:10 rio kernel: md: bind<hdg>
> Jan 24 20:24:10 rio kernel: md: bind<hde>
> Jan 24 20:24:10 rio kernel: raid1: raid set md3 active with 2 out of 2=20
> mirrors
> Jan 24 20:24:12 rio kernel: ReiserFS: md3: warning: sh-2021:=20
> reiserfs_fill_super: can not find reiserfs on md3
>
> Adding  -t reiserfs doesn't work either.
>
Presumably the superblock for the file system cannot be found because
it's now offset due to the above issue.

HTH,
        Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--huq684BweRXVnRxX
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iD8DBQFHmaSFShxCyD40xBIRAkEfAKCIy+hrEJImLlWawchppyUCuNNLiQCeNJFP
1RgU//MjCx9tdQ4KDwEejlk=
=BIx6
-----END PGP SIGNATURE-----

--huq684BweRXVnRxX--
