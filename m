From: NeilBrown <neilb@suse.de>
Subject: Re: RAID-10 explicitly defined drive pairs?
Date: Sat, 7 Jan 2012 07:55:26 +1100
Message-ID: <20120107075526.59ed433c@notabene.brown>
References: <20111212115459.GC20730@fi.muni.cz>
	<4EE61EAE.20101@anonymous.org.uk>
	<20120106150823.GX25976@fi.muni.cz>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/kXV5Ie.Js=BruJFXqRmqLlp"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120106150823.GX25976@fi.muni.cz>
Sender: linux-raid-owner@vger.kernel.org
To: Jan Kasprzak <kas@fi.muni.cz>
Cc: linux-raid <linux-raid@vger.kernel.org>, John Robinson <john.robinson@anonymous.org.uk>
List-Id: linux-raid.ids

--Sig_/kXV5Ie.Js=BruJFXqRmqLlp
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 6 Jan 2012 16:08:23 +0100 Jan Kasprzak <kas@fi.muni.cz> wrote:

> John Robinson wrote:
> : On 12/12/2011 11:54, Jan Kasprzak wrote:
> : >	Is there any way how to tell mdadm explicitly how to set up
> : >the pairs of mirrored drives inside a RAID-10 volume?
> :=20
> : If you're using RAID10,n2 (the default layout) then adjacent pairs
> : of drives in the create command will be mirrors, so your command
> : line should be something like:
> :=20
> : # mdadm --create /dev/mdX -l10 -pn2 -n44 /dev/shelf1drive1
> : /dev/shelf2drive1 /dev/shelf1drive2 ...
>=20
> 	OK, this works, thanks!
>=20
> : Having said that, if you think there's a real chance of a shelf
> : failing, you probably ought to think about adding more redundancy
> : within the shelves so that you can survive another drive failure or
> : two while you're running on just one shelf.
>=20
> 	I am aware of that. I don't think the whole shelf will fail,
> but who knows :-)
>=20
> : If you are sticking with RAID10, you can potentially get double the
> : read performance using the far layout - -pf2 - and with the same
> : order of drives you can still survive a shelf failure, though your
> : use of port multipliers may well limit your performance anyway.
>=20
> 	On the older hardware I have a majority of writes, so the far
> layout is probably not good for me (reads can be cached pretty well
> at the OS level).
>=20
> 	After some experiments with my new hardware, I have discovered
> one more serious problem: I have simulated an enclosure failure,
> so half of the disks forming the RAID-10 volume disappeared.
> After removing them using mdadm --remove, and adding them back,
> iostat reports that they are resynced one disk a time, not all
> just-added disks in parallel.
>=20
> 	Is there any way of adding more than one disk to the degraded
> RAID-10 volume, and get the volume restored as fast as the hardware permi=
ts?
> Otherwise, it would be better for us to discard RAID-10 altogether,
> and use several independent RAID-1 volumes joined together using LVM
> (which we will probably use on top of the RAID-10 volume anyway).
>=20
> 	I have tried mdadm --add /dev/mdN /dev/sd.. /dev/sd.. /dev/sd..,
> but it behaves the same way as issuing mdadm --add one drive at a time.

I would expect that to first recover just the first device added, then
recover all the rest at once.

If you:
  echo frozen > /sys/block/mdN/md/sync_action
  mdadm --add /dev/mdN /dev......
  echo recover > /sys/block/mdN/md/sync_action

it should do them all at once.

I should teach mdadm about this..

NeilBrown


--Sig_/kXV5Ie.Js=BruJFXqRmqLlp
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTwdfvjnsnt1WYoG5AQLUhBAAnXKTGpILmNW9p9+qkJIvXj4soOoBjDvg
HBXhPwxHacuKKS9nEfPzldVVGMrvLFWLNQlK8tp2uNgRLmBjLpc+quYu3/io1gP8
teTQTPOA758CkttO1853SWu2NxLwVlT2vL5v9RUJej52p2jM6eGFy6cV9tqJWZWF
A5KiUMTwzGk0WFZIdUJ0/VAVbWKpVtVYgQQ31Hns06Fdb0TQY1PxdV404cQkiWwq
VL0/5lpcyYEo+Ye1Qmd9EjvMTzLu6qvTE6SyJfH+W6gxcdgO2sUJyU8vLgL/TmfZ
5zLu2DYhhAi5BF7ONyfPrnUhf3l6uZ7qd9O/d6W5hsCRLpoRykTRGGaKUFWISKrP
otLN6MvjD0bqgqUKWdaQkxu1CtCK4qb+IY7qS3SiDUSEgJ5je14xwL0dGH3dlN4X
qTZYx8Q5phl1ouKQPhw1pjNBO5qkBGSLnqHf7rdvwXqbd2mc3s+ZPtDenvonK4d8
2tjpsYMGLZ+5KCFqBdPICyJu4t+G6I638x7woqqq+Eh8CQXe+5KbU71rtubRmcvN
ixOQn8M3MwolJGWYQlGgf+KsJqcypYcXjlhV2VtSzPKi184Mngb4tOntBzf3HTzl
2F6CNtOkPySDGa9sRzYeB/vP38od8Idq1yq17GbGqlID/vKqXt4lfbXbFIrNRKLv
sL961uM9IRg=
=FGqu
-----END PGP SIGNATURE-----

--Sig_/kXV5Ie.Js=BruJFXqRmqLlp--
