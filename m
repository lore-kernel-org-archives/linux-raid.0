From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: mdadm --create parameter ordering
Date: Mon, 13 Jul 2015 11:59:28 +0100
Message-ID: <20150713105928.GA19366@cthulhu.home.robinhill.me.uk>
References: <CAFcup8E3iKxb8H-Fz76bKJQhjmhq1FuVu11rEPb-k=g2U_nX=w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jI8keyz6grp/JLjh"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAFcup8E3iKxb8H-Fz76bKJQhjmhq1FuVu11rEPb-k=g2U_nX=w@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Steven Reddie <steven.reddie@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--jI8keyz6grp/JLjh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon Jul 13, 2015 at 08:26:48PM +1000, Steven Reddie wrote:

> Hi,
>=20
> Given the following command:
>=20
>     mdadm -Cf /dev/md3 -e1.2 -n5 -l6 /dev/sdga5 /dev/sdgb5 /dev/sdgc5
> /dev/sdgd5 /dev/sdge5 -u<uuid>
>=20
> Is the order that the disks are specified on the command-line significant?
>=20
Yes, it specifies the disks' position within the array.

> Somebody suggested this command to put the disks back in the correct
> order (though I believe he was mistaken about the correct order). It
> seems to me that if the order on the command-line is significant that
> this would have caused parity to get recalculated (based on the
> [incorrect] order of the disks) and the new parity to be written over
> actual data blocks. I see no evidence that this has occurred, which
> leads me to believe that the actual ordering within the array is
> detected and everything proceeds as it should, in which case issuing
> the command above likely was a very time-consuming no-op.
>=20
You're creating a new array, so there is no "actual ordering" to detect
- any old array will be ignored. If you are re-creating the array in
order to fix an issue (which you should only do as a very last resort,
and only after seeking help and advice here) then an incorrect order
will definitely cause new parity information to be written over data
blocks (which is why you should always leave "missing" disks, or use
--assume-clean,  to prevent parity calculation until after you've
verified the order is correct and the data is readable), If the
filesystem shows as readable (and error free) then the order specified
would appear to be correct.

> Also, it seems that I should be able to issue such a command without
> the full scan of the disks. Is that what the "--run" option is for? If
> so, does "--readonly" protect me from harm that improper use of
> "--run" may cause?
>=20
The --run option is to start an array which has been assembled but not
started. The udev auto-assemble rule, for example, will add disks into
the array as they're discovered but only start it once the array is
complete (or as complete as it was the last time it was assembled), so
in the case of a missing disk, a manual --run command may be required.

I'm not entirely sure what the --readonly option will do in the case of
a create command. Possibly just the metadata will be written and the
parity calculation will be paused.

The --assume-clean option will prevent parity calculation (as it assumes
that the parity on disk is already correct), which may be what you're
after. It should only be used it you're absolutely certain of the data
though, as it can lead to large-scale corruption otherwise.

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--jI8keyz6grp/JLjh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAlWjmhAACgkQShxCyD40xBKyYwCg0IO5zAnn7gwTscQiPN4E/hf+
MFQAn1K33bhWkBQp7niU0YIsFMONPu2F
=1xbE
-----END PGP SIGNATURE-----

--jI8keyz6grp/JLjh--
