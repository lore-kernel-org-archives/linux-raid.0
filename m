From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: RAID 5 array recovery - two drives errors in external enclosure
Date: Fri, 18 Sep 2009 16:41:36 +0100
Message-ID: <20090918154136.GG22909@cthulhu.home.robinhill.me.uk>
References: <2267211f0909171342g6ebf68a2y393daa587e59c714@mail.gmail.com>
 <20090917212252.GC19611@cthulhu.home.robinhill.me.uk>
 <2267211f0909171611m4b4a0d02p81b80bc882a0855@mail.gmail.com>
 <70ed7c3e0909171628w4040ae5cydf4335adb51f2b7d@mail.gmail.com>
 <2267211f0909171654v766e658fn620b23268a2393a6@mail.gmail.com>
 <0F9F69CA6B3942B1A44BC0B2D00AE139@m5>
 <2267211f0909172119w6de04e46m5fcfc5e6d35c0382@mail.gmail.com>
 <20090918080706.GB22909@cthulhu.home.robinhill.me.uk>
 <2267211f0909180827jbfa57acqadd308b4b889058c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Qf1oXS95uex85X0R"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <2267211f0909180827jbfa57acqadd308b4b889058c@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--Qf1oXS95uex85X0R
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri Sep 18, 2009 at 08:27:08AM -0700, Tim Bostrom wrote:

> Is there any mdadm command that would have given any info or metadata
> from the previous array?  I have almost 9 months of SSH logging on my
> laptop that I use to manage the array.  Maybe there's some useful info
> left in the log that might help.
>=20
Not directly, no.  The problem is that the mdadm commands report based
on drive/partition names as they are at the time (as that's what's
immediately useful).  Unless you have anything to tie those
drive/partition names to a unique identifier for the drive (e.g.
/dev/disk/by-id, /dev/disk/by-uuid) then it's not going to be possible
to map the old drive/partition names to the current ones.

It's worth having a look anyway - see if you've got anything providing
drive serial number (smartctl output, listing of /dev/disk/by-id or
by-uuid).  If the drives are different makes/models then the output of
lsscsi or /proc/scsi/scsi would also do.

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--Qf1oXS95uex85X0R
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkqzqi8ACgkQShxCyD40xBKAVgCeIlT5QeOka88zm5L2Chj3Pzv3
vYoAoMlsE9UZOI+YJvJ7BszwaAMV0wJC
=6PEY
-----END PGP SIGNATURE-----

--Qf1oXS95uex85X0R--
