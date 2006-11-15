From: Forrest Taylor <ftaylor@redhat.com>
Subject: Re: safest way to swap in a new physical disk
Date: Wed, 15 Nov 2006 11:45:40 -0700
Message-ID: <1163616340.3742.27.camel@x1-6-00-0d-60-fd-e8-4c>
References: <6D7E98FD-D24F-402D-A7F0-63179FA3C49E@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-spmOctL/v+fY1c3O3gW2"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <6D7E98FD-D24F-402D-A7F0-63179FA3C49E@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Will Sheffler <willsheffler@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-spmOctL/v+fY1c3O3gW2
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2006-11-14 at 00:06 -0800, Will Sheffler wrote:
> Hi.
>=20
> What is the safest way to switch out a disk in a software raid array =20
> created with mdadm? I'm not talking about replacing a failed disk, I =20
> want to take a healthy disk in the array and swap it for another =20
> physical disk. Specifically, I have an array made up of 10 250gb =20
> software-raid partitions on 8 300gb disks and 2 250gb disks, plus a =20
> hot spare. I want to switch the 250s to new 300gb disks so everything =20
> matches. Is there a way to do this without risking a rebuild? I can't =20
> back everything up, so I want to be as risk-free as possible.
>=20
> I guess what I want is to do something like this:
>=20
> (1) Unmount the array
> (2) Un-create the array
> (3) Somehow exactly duplicate partition X to a partition Y on a new disk
> (4) Re-create array with X gone and Y in it's place
> (5) Check if the array is OK without changing/activating it
> (6) If there is a problem, switch from Y back to X and have it as =20
> though nothing changed
>=20
> The part I'm worried about is (3), as I've tried duplicating =20
> partition images before and it never works right. Is there a way to =20
> do this with mdadm?

Is this a RAID 5 or RAID 6?  If so, you don't have to do steps 1 or 2.
Assuming that you have RAID 5 on /dev/md0, that your 250GB partition
is /dev/sda1, and that you have a fairly modern kernel/mdadm, here are
the steps:

1. Fail and remove the drive from the array:
   mdadm /dev/md0 -f /dev/sda1 -r /dev/sda1

2. Physically remove the drive and replace it with the 300GB drive.

3. Partition the new drive.  You can just make one partition that spans
the whole 300 GB.  Don't try to make it match the 250GB partition.

4. Add it to the array.
   mdadm /dev/md0 -a /dev/sda1
   (assuming /dev/sda1 is that new partition)

5. Repeat with the second drive.

6. If all went well, you could actually increase the devices of the
array (they are all using 250GB of the 300GB).
   mdadm -G /dev/md0 -z max
   WARNING:  once you increase the size of your usable partitions, you
will not be able to use those 250GB disks again.

--=20
Forrest


--=-spmOctL/v+fY1c3O3gW2
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.6 (GNU/Linux)

iD8DBQBFW2BUaUnzBifbsNQRAhqcAKCPZLAdqu+1stgE2x5IgzpJ8ZVdeACeJB66
wqgXRsu7xnOxm9yulGzm2zk=
=uyIC
-----END PGP SIGNATURE-----

--=-spmOctL/v+fY1c3O3gW2--

