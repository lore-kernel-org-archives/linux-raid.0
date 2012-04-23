From: NeilBrown <neilb@suse.de>
Subject: Re: Intel fakeraid working?
Date: Mon, 23 Apr 2012 12:25:20 +1000
Message-ID: <20120423122520.289cad2f@notabene.brown>
References: <4F7CEDD0.9080904@ubuntu.com>
	<20120405111317.2a5227b1@notabene.brown>
	<4F7DE314.9040306@ubuntu.com>
	<20120406092428.1090e10b@notabene.brown>
	<4F7E426F.5000604@ubuntu.com>
	<20120410094330.00fb2477@notabene.brown>
	<4F843252.5090109@ubuntu.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/JCt6E/IlGNkU5wx7DzbNC3R"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F843252.5090109@ubuntu.com>
Sender: linux-raid-owner@vger.kernel.org
To: Phillip Susi <psusi@ubuntu.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/JCt6E/IlGNkU5wx7DzbNC3R
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 10 Apr 2012 09:14:58 -0400 Phillip Susi <psusi@ubuntu.com> wrote:

> On 4/9/2012 7:43 PM, NeilBrown wrote:
> > It will reject writes from user-space, and it will reject attempts to m=
ount a
> > filesystem unless the filesystem is mounted "read-only".
> > But if a read-only mounted filesystem decides to write anyway (XFS, ext=
3,
> > ext4...) then the block layer doesn't stop it.
>=20
> How does that work?  How does the block layer know or care what mount=20
> flags are used?  My understanding is that setting the block layer=20
> read-only flag with blockdev --setro actually causes the write bios to=20
> be rejected, thus preventing ext[34] from playing back the journal.=20
> Ubuntu has been using this to prevent accidental damage by read-only=20
> mounts since this abhorrent behavior was discovered.  I would think that=
=20
> md should work the same way.
>=20

It's actually a long time since I looked at this in detail, so I've had
another hunt around the code to see what the current state really is.
I've only looked at ext3, not other filesystems, but it should be fairly
representative.

ext3 does appear to take care not to write anything if the device is marked
readonly - so maybe I've been doing it a dis-service there.  However there
have been bugs.  The most recent was fixed about 18 months ago:

commit 31d710a7bd42f0d89e30d53bdaad427c5f191d0d
Author: Maciej 305273enczykowski <zenczykowski@gmail.com>
Date:   Sun Sep 26 12:38:28 2010 +0000

    ext3: don't update sb journal_devnum when RO dev
   =20
    An ext3 filesystem on a read-only device, with an external journal
    which is at a different device number then recorded in the superblock
    will fail to honor the read-only setting of the device and trigger
    a superblock update (write).
   =20
    For example:
      - ext3 on a software raid which is in read-only mode
      - external journal on a read-write device which has changed device num
      - attempt to mount with -o journal_dev=3D<new_number>
      - hits BUG_ON(mddev->ro =3D 1) in md.c
   =20
    Cc: Theodore Ts'o <tytso@mit.edu>
    Signed-off-by: Maciej 305273enczykowski <zenczykowski@gmail.com>
    Signed-off-by: Jan Kara <jack@suse.cz>

This fix was in 2.6.38.  I don't know if was backported at all.

The read-only flag does not cause the block-layer to do, or not do, anythin=
g.
It is merely information that is made available to the filesystem (or the
"block_dev" pseudo-filesystem that presents /dev/sda or whatever and maps
read/write requests directly to bios which get sent down).

It is up the the filesystem to honour the read-only setting.  Maybe this is
poor design: I haven't thought about it much.  But that is the way it is.

When ext3 sees that it needs to replay the journal it will check if the
device is read-only. If it is, it will failed with EROFS.  So you cannot
mount an inconsistent filesystem from a read-only device.

md does set the same flag that "blockdev --setro" sets.  If some filesystem
writes anyway, then it is definitely a bug and should be fixed.

So it looks like everybody is doing the "right" thing (allowing for
occasional bugs here and there), and your real problem is just that Ubuntu
didn't package mdmon.

NeilBrown

--Sig_/JCt6E/IlGNkU5wx7DzbNC3R
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT5S9kDnsnt1WYoG5AQLyiw/9F7Di8ft+a5sMgANmmGEfzHWH/53ryZue
1Xdgh+sI4KWDM91xcZzgeoNvOv0edRpJmf/qhIXhBFndo5IgI4qZvTQLxeqy6233
SiaDtGshodFYSmq0My1ts6pxdo++6ja9eBS2I4torM3zXYKQjfVcaRJjtZNbH176
Tw66m13Tkf2jqveSfkPIZb+jU43+CENTjKJUVLMRsHXEhwESKClHfFkqk0UgDskb
dz8aCovpwDeZpwmQ7JQqCohOq9goS2Pe7sLTlN/fQzS2qqWDxswML2RUuTzNfoXk
hIyU8deBmbfSAHhbZ/iJ9x1TO2n615XCV4CDMnkv7ylYZ1k0hzWQfsyJdEu7CR8z
Xa8k8AurNUqkACc5B892jC1YoRKQOw4vF8+4pRIDu2pJUEwmdbS+uSKcT2iyK+Pp
CHFOnReFv6Rrwz1q+v/ezLooWx+EqR0ZUSxoi4bTO3qUPYU7La3X2Fpk2eEnADAA
EvrgkNCqaiLXgfdxGEsinkAHqLXXfOFvInYAqN9uRyKg5eZYJ0T1N51vNPZPI8RD
/gYs9+LS6stnwm6fzyT/G2MbVUQbma/3deN/3tzsYxLwH11OEsW5gDRq7WFnhJPT
xWy/tWqCeY089tai4gn4/rxZdTjUk6muPxYxx5eGdrkQAjgxKTq7SKdavDuHqsR1
dYxwIM4HLjk=
=2kbR
-----END PGP SIGNATURE-----

--Sig_/JCt6E/IlGNkU5wx7DzbNC3R--
