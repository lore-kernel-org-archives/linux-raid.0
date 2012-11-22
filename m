From: NeilBrown <neilb@suse.de>
Subject: Re: want-replacement got stuck?
Date: Thu, 22 Nov 2012 13:15:45 +1100
Message-ID: <20121122131545.5f31143f@notabene.brown>
References: <20121120221145.9905.qmail@science.horizon.com>
	<20121121163300.30697.qmail@science.horizon.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/a8BWxFN8Uw998deIUY6ezEW"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20121121163300.30697.qmail@science.horizon.com>
Sender: linux-raid-owner@vger.kernel.org
To: George Spelvin <linux@horizon.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/a8BWxFN8Uw998deIUY6ezEW
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On 21 Nov 2012 11:33:00 -0500 "George Spelvin" <linux@horizon.com> wrote:

> Just to follow up to that earlier complaint, ext4 is now noticing some er=
rors:
>=20
> Nov 21 06:21:53 science kernel: EXT4-fs error (device md5): ext4_find_ent=
ry:1234: inode #5881516: comm rsync: checksumming directory block 0
> Nov 21 07:57:03 science kernel: EXT4-fs error (device md5): ext4_validate=
_block_bitmap:353: comm flush-9:5: bg 4206: bad block bitmap checksum
> Nov 21 08:41:37 science kernel: EXT4-fs error (device md5): ext4_validate=
_block_bitmap:353: comm flush-9:5: bg 3960: bad block bitmap checksum
> Nov 21 08:45:18 science kernel: EXT4-fs error (device md5): ext4_validate=
_block_bitmap:353: comm flush-9:5: bg 4737: bad block bitmap checksum
> Nov 21 08:50:16 science kernel: EXT4-fs error (device md5): ext4_mb_gener=
ate_buddy:741: group 4206, 5621 clusters in bitmap, 6888 in gd
> Nov 21 08:50:16 science kernel: JBD2: Spotted dirty metadata buffer (dev =
=3D md5, blocknr =3D 0). There's a risk of filesystem corruption in case of=
 system crash.
> Nov 21 15:50:29 science kernel: EXT4-fs error (device md5): ext4_validate=
_block_bitmap:353: comm python: bg 4138: bad block bitmap checksum
> Nov 21 16:21:00 science kernel: UDP: bad checksum. From 187.194.52.187:65=
535 to 71.41.210.146:6881 ulen 70
>=20
> I also experienced transient corruption of the last few K of my incoming =
mailbox.  (I.e. the last
> couple of messages were overwritten with some other text file.  This morn=
ing, it's fine.)
>=20
> Something is definitely wonky here...  I'm leaving it in the "stuck" stat=
e for a while
> in case there's useful debugging info to be extracted, but I'm getting ve=
ry alarmed by these
> messages and want to reboot soon.


Yes.... this is a real worry.  Fortunately I know what is causing it.

The code for writing to a RAID10 naively assumes that if the 'main' device =
in
a slot is faulty, then there isn't any replacement device to write to eithe=
r.

This is normally the case as a faulty device will be promptly remove - or it
should be at least.  As you've already discovered, sometimes it isn't promp=
t.

But even if it were, there could be races so that the main device fails just
as we look at it, and then the replacement couldn't possibly have been moved
down yet.

Meanwhile you have a corrupted filesystem.  Sorry.
The nature of the corruption is that since the replacement finished no writ=
es
have gone to slot-3 at all.  So if md ever devices to read from slot 3 it
will get stale data.

I suggest you fail the sdd2, reboot, make sure one sda2, sb2,sde2 are in the
array, run fsck, and then if it seems happy enough, add sdc2 and/or sdd2 ba=
ck
in so they rebuild completely.

Thanks for helping to make md better by risking your data :-)

NeilBrown

--Sig_/a8BWxFN8Uw998deIUY6ezEW
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUK2K0Tnsnt1WYoG5AQIVBA/8CiP2n9yNLsxs0DZCt5UYGMCBfpZfhG2U
uyuPsXNOH0/NkvYLSnlGkh9oh809cfoBUCpNURxD0vAOWQrGz8grKbIwQbal/8sb
vXYqK1+ZLc22b4NaMhfzjgljfjoPZ6P/u1WQuU37WhCy0DE9exxN8m0rM5AnHst/
Tf73jpYfMO4LrqGIJE+WFPCZfmwD3D23cRDxAgBwBGH45RPhh8hyAdJ2uJ6YWMNd
JKUMFJh7K1ilkzB++lEjb1bkqGRkj7QwEi7Zg0RkKFoQXo1hM8xx27iDjRBB7F72
px5QHXwWilM//y/IZq5PToitS0Y05hgu/+oDWa21S3xr2WIN8WpVSYoQ0vTmO0GD
YyA4Qf3Fn/stcXxEKOk75ybQqLS2kmpzvYcRpkNaIKa2cIm7wmlqMtZDh9nvPVen
bo9eZqbnFs3rEQvJ6Yn8X0047W+HsfdQIOtmAzMei8cmq0ft3fGgxBjdV4x1LPd1
I3ig0ZEFxDwZzoJLV5Gl9fp6/gj6uogWGPGPCCcWRtAz6Ii6xOSHq2iB+5MPW4Ri
7Eb2UrvfN67PpEt6sgWaaA4yr3SwDQrVCmG4CRIbHixa3k+VYVghBBFeURYCjR39
TOuuwBJiSy7NwzqdFPlNUOi8IBgrIlfKI3nDmbWbUA3HELyE6VTvscCxW3ulrXfR
e9zI2kRIjWk=
=mDN1
-----END PGP SIGNATURE-----

--Sig_/a8BWxFN8Uw998deIUY6ezEW--
