From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: Upgrading a software RAID
Date: Sat, 30 May 2009 20:10:30 +0100
Message-ID: <20090530191030.GC23606@cthulhu.home.robinhill.me.uk>
References: <4A1EA095.9090406@usherbrooke.ca> <4A217BA8.1080208@tmr.com> <4A217C6C.7080301@usherbrooke.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="t0UkRYy7tHLRMCai"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4A217C6C.7080301@usherbrooke.ca>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--t0UkRYy7tHLRMCai
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat May 30, 2009 at 02:35:24PM -0400, Maxime Boissonneault wrote:

>
>>>
>>> I can not install more drives in the computer. It is a home theater=20
>>> computer in a small case. I was expecting to be able to let the raid=20
>>> manage the copies itself.
>>>
>>> If the / was on a RAID5, would it be able to boot with 2 disks ?
>>> If so, is it possible to convert my RAID0 to a RAID5 ?
>>> For example, I could boot on a CD, backup / onto /home, delete the RAID=
0=20
>>> array and recreate it as RAID5, then restore the backup. Would this wor=
k=20
>>> ?
>>
>> Based on my testing (somewhat old now) and regular use, I would say raid=
10=20
>> is probably your best bet. It's fast and secure, and with the -f2 option=
=20
>> for "far" copies it's able to give high transfer rates.
>
> Doesn't RAID10 means RAID 1+0, which requires 4 disks ?
>
Yes and no!  Linux software (md) raid implements RAID10 as a single
layer (rather than layering RAID0 and RAID1), allowing the number of
drives and the number of replicas to be pretty arbitrary.  The basic
principle holds though - you'll still have 2 (or more if specified)
replicas of each data block, and blocks are striped across the drives.

You can read the details on the md manual page.

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--t0UkRYy7tHLRMCai
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkohhKUACgkQShxCyD40xBI/bACgpzso57z9/l2jpSF6NVh0lyrC
wnMAoIrc8iDWiq6mHuHZo+uqRNqu+k4k
=qWdt
-----END PGP SIGNATURE-----

--t0UkRYy7tHLRMCai--
