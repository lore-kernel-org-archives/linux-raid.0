From: Doug Ledford <dledford@redhat.com>
Subject: Re: Propose of enhancement of raid1 driver
Date: Thu, 19 Oct 2006 12:06:35 -0400
Message-ID: <1161273995.2917.588.camel@fc6.xsintricity.com>
References: <45347D6E.3000600@mieszczak.com.pl>
	 <17718.61672.794099.425723@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-iT+gWVs0maHLxSZvCqHe"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17718.61672.794099.425723@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Miroslaw Mieszczak <mirek@mieszczak.com.pl>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-iT+gWVs0maHLxSZvCqHe
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2006-10-19 at 13:28 +1000, Neil Brown wrote:
> On Tuesday October 17, mirek@mieszczak.com.pl wrote:
> > I would like to propose an enhancement of raid 1 driver in linux kernel=
.
> > The enhancement would be speedup of data reading on mirrored partitions=
.
> > The idea is easy.
> > If we have mirrored partition over 2 disks, and these disk are in sync,=
 there is
> > possibility of simultaneous reading of the data from both disks on the =
same way
> > as in raid 0. So it would be chunk1 read from master, chunk2 read from =
slave at
> > the same time.=20
> > As result it would give significant speedup of read operation (comparab=
le with
> > speed of raid 0 disks).
>=20
> This is not as easy as it sounds.
> Skipping over blocks within a track is no faster than reading blocks
> in the track, so you would need to make sure that your chunk size is
> larger than one track - probably it would need to be several tracks.
>=20
> Raid1 already does some read-balancing, though it is possible (even
> likely) that it doesn't balance very effectively.  Working out how
> best to do the balancing in general in a non-trivial task, but would
> be worth spending time on.
>=20
> The raid10 module in linux supports a layout described as 'far=3D2'.
> In this layout, with two drives, the first half of the drives is used
> for a raid0, and the second half is used for a mirrored raid0 with the
> data on the other disk.
> In this layout reads should certainly go at raid0 speeds, though
> there is cost in the speed of writes.
>=20
> Maybe you would like to experiment.  Write a program that reads from
> two drives in parallel, reading all the 'odd' chunks from one drive
> and the 'even' chunks from the other, and find out how fast it is.
> Maybe you could get it to try lots of different chunk sizes and see
> which is the fastest.

Too artificial.  The results of this sort of test would not translate
well to real world usage.

> That might be quite helpful in understanding how to get read-balancing
> working well.

Doing *good* read balancing is hard, especially given things like FC
attached storage, iSCSI/iSER, etc.  If I wanted to do this right, I'd
start by teaching the md code to look more deeply into block devices,
possibly even with a self tuning series of reads at startup to test
things like close seek sequential operation times versus maximum seek
throughput which would clue you in as to whether the device you are
talking to might have more than 1 physical spindle which would impact
the cost you associate to seek requiring operations relative to
bandwidth heavy operations, I might even go so far as to look into the
SCSI transport classes for clues about data throughput at bus bandwidth
versus command startup/teardown costs on the bus so you have an accurate
idea if lots of outstanding small commands are likely to cause your
device to suffer bus starvation issues from overhead.  Then I'd use that
data to help me numerically quantify the load on a device, updated both
when a command is added to the block layer queue (the queued load) and
when the command is actually removed from the block queue and sent to
the device (the active load) and updated again when the command is
received back.  Then, I'd basically look at what an incoming command
*would* do to each constituent disk's load values to see whether it
should go to one or the other.  But, that's just off the top of my head
and I may be on crack...I didn't check what my wife handed me this
morning.

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
              http://people.redhat.com/dledford

Infiniband specific RPMs available at
              http://people.redhat.com/dledford/Infiniband

--=-iT+gWVs0maHLxSZvCqHe
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBFN6KLTzP9PM7pjw8RAoAlAJoDpDAIrtb/t+tkYIVbQHnRKWU4nQCfYtYm
XhFpKI2cIpf5Crp5L9ctizE=
=TkJV
-----END PGP SIGNATURE-----

--=-iT+gWVs0maHLxSZvCqHe--

