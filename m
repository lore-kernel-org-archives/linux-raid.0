From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: RAID 5 re-add of removed drive? (failed drive replacement)
Date: Tue, 2 Jun 2009 14:10:37 +0100
Message-ID: <20090602131037.GB15172@cthulhu.home.robinhill.me.uk>
References: <20090602111729.GA15172@cthulhu.home.robinhill.me.uk> <C840D176-51A0-4AFD-8AD0-1F1D2CAA830D@hispeed.ch>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XF85m9dhOBO43t/C"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <C840D176-51A0-4AFD-8AD0-1F1D2CAA830D@hispeed.ch>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--XF85m9dhOBO43t/C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue Jun 02, 2009 at 02:00:15PM +0200, Alexander Rietsch wrote:

>>
>> AFAIK, the only solution at this stage is to recreate the array.
>>
>> You need to use the "--assume-clean" flag (or replace one of the drives
>> with "missing"), along with _exactly_ the same parameters & drive order
>> as when you originally created the array (you should be able to get most
>> of this from mdadm -D).  This will rewrite the RAID metadata, but leave
>> the filesystem untouched.
>
> A glimpse of hope. Thank you! Didn't know about this --assume-clean flag.=
=20
> So just to double-check:
>
> The array to create would be:
> disc 0: sdi1 <- is now disc 7 and SPARE due to failed replacement operati=
on
> disc 1: sdl1
> disc 2: sdh1
> disc 3: sdj1
> disc 4: sdk1
> disc 5: sdg1
> disc 6: sda1 <- is now faulty removed
>
> So I just create an incomplete array without sda1 in the same order which=
=20
> would be:
>
> mdadm --create /dev/md0 --assume-clean --level=3D5 --chunk=3D64=20
> --raid-devices=3D7 /dev/sdi1 /dev/sdl1 /dev/sdh1 /dev/sdj1 /dev/sdk1=20
> /dev/sdg1
>
Almost - you'll also need to specify "missing" for disc 6 (and the
--assume-clean isn't actually needed in this case, as the array can't do
any reconstruction with a missing drive), so:

    mdadm --create /dev/md0 --level=3D5 --chunk=3D64 --raid-devices=3D7
    /dev/sdi1 /dev/sdl1 /dev/sdh1 /dev/sdj1 /dev/sdk1 /dev/sdg1 missing

> I'm not sure about the drive oder in the mdadm command: is it correct to=
=20
> assume <drive 0> <drive 1> <drive 2> in order or is it mirrored like <dri=
ve=20
> 2> <drive 1> <drive 0> ?
> I also hope the command doesn't trigger any recovery actions or filesyste=
m=20
> changes..

This should be safe, yes - the numbers are also given in the output from
"mdadm -D /dev/md0" or "mdadm -E /dev/sdl1".  The array creation doesn't
trigger any changes at all to the filesystem (though mounting it might,
even in read-only mode) so is perfectly safe to do.  You can also try
"fsck -n" on the filesystem before mounting to verify that the array
order is correct - this may fail on filesystems with unflushed journal
data though.

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--XF85m9dhOBO43t/C
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkolJM0ACgkQShxCyD40xBLomACbBDW8R7lXMcX52na+AoTKQ4PG
fHUAn2bp8n6f6In6aY0oCtL9omxciOe5
=Ft7t
-----END PGP SIGNATURE-----

--XF85m9dhOBO43t/C--
