From: Robin Hill <robin.hill47@ntlworld.com>
Subject: Re: RAID1, changed disk, 2nd has errors ...
Date: Fri, 26 Aug 2011 13:56:53 +0100
Message-ID: <20110826125653.GA13709@cthulhu.home.robinhill.me.uk>
References: <4E5787A1.7080807@xunil.at>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="n8g4imXOkfNTN/H1"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4E5787A1.7080807@xunil.at>
Sender: linux-raid-owner@vger.kernel.org
To: "Stefan G. Weichinger" <lists@xunil.at>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--n8g4imXOkfNTN/H1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri Aug 26, 2011 at 01:46:41PM +0200, Stefan G. Weichinger wrote:

>=20
> Please help:
>=20
> Today I removed a defective hdd out of a RAID1-array and swapped in a
> new hdd instead.
>=20
> 3 arrays, to be true, md[012]
>=20
> 0 and 1 synced fine, in the process of syncing md2 the old sda threw
> errors (in sda4):
>=20
> md/raid1:md2: sda: unrecoverable I/O read error for block 643686144
> md: md2: recovery done.
>=20
> [...]
>=20
> md/raid1:md2: sda: unrecoverable I/O read error for block 643686272
>=20
> ----
>=20
> Did the system stop syncing or is "recovery done" the indication that
> md2 was fully recovered BEFORE the system threw sda4 out of the array??
>=20
> I hope for the second!
>=20
I think it just indicates that it stopped attempting recovery at this
point.

> # cat /proc/mdstat
> Personalities : [raid1]
> md1 : active raid1 sdb3[1] sda3[0]
>       13679232 blocks [2/2] [UU]
>=20
> md2 : active raid1 sdb4[2](S) sda4[0]
>       962454080 blocks [2/1] [U_]
>=20
> md0 : active raid1 sdb1[1] sda1[0]
>       128384 blocks [2/2] [UU]
>=20
This would indicate that sdb has been reset as a spare, suggesting that
the resync failed so it has left sda alone in the array (as failing it
would destroy the array).

I'd suggest stopping the array and using ddrescue to clone sda4
to sdb4. That'll copy everything possible, flagging up any read issues.
You'll then need to run a "fsck -f" on sdb4 to clear up any filesystem
damage. You may still be left with damaged/missing files, depending on
where any read errors occurred. How critical this is will depend on what
the filesystem is used for (and whether you have any backup).

If that all works okay, then get sda replaced and give it a thorough
badblocks and SMART test.

I'd also advise setting up regular array checks (echo check >
/sys/block/mdX/md/sync_action) to make sure the disks are checked and
any unreadable blocks repaired/mapped out _before_ they're needed for
recovery.

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--n8g4imXOkfNTN/H1
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iEYEARECAAYFAk5XmBUACgkQShxCyD40xBLg+ACghEsJN57XDspV01Hc2drdzgJK
pY0AoNzl+4zgvkqT9YH45C24NDyFM9EL
=hxrm
-----END PGP SIGNATURE-----

--n8g4imXOkfNTN/H1--
