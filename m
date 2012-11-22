From: NeilBrown <neilb@suse.de>
Subject: Re: System runs with RAID but fails to reboot
Date: Thu, 22 Nov 2012 15:52:36 +1100
Message-ID: <20121122155236.0e7689c6@notabene.brown>
References: <1353517137.5795.55.camel@corn.betterworld.us>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/cB6o0.sEW9M75jA5PUw0mRW"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1353517137.5795.55.camel@corn.betterworld.us>
Sender: linux-raid-owner@vger.kernel.org
To: Ross Boylan <ross@biostat.ucsf.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/cB6o0.sEW9M75jA5PUw0mRW
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 21 Nov 2012 08:58:57 -0800 Ross Boylan <ross@biostat.ucsf.edu> wrot=
e:

> I spent most of yesterday dealing with the failure of my (md) RAID
> arrays to come up on reboot.  If anyone can explain what happened or
> what I can do to avoid it, I'd appreciate it.  Also, I'd like to know if
> the failure of one device in a RAID 1 can contaminate the other with bad
> data (I think the answer must be yes, in general, but I can hope).
>=20
> In particular, I'll need to reinsert the disks I removed (described
> below) without getting everything screwed up.
>=20
> Linux 2.6.32 amd64 kernel.
>=20
> I'll describe what I did for md1 first:
>=20
> 1. At the start, system has 3 physically identical disks. sda and sdc
> are twins and sdb is unused, though partitioned. md1 is a raid1 of sda3
> and sdc3.  Disks have DOS partitions.
> 2. Add 2 larger drives to the system.  They become sdd and sde.  These 2
> are physically identical to each other, and bigger than the first batch
> of drives.
> 3. GPT format the drives with larger partitions than sda.
> 4. mdadm --fail /dev/md1 /dev/sdc3
> 5. mdadm --add /dev/md1 /dev/sdd4.  Wait for sync.
> 6. madadm --add /dev/md1 /dev/sde4.
> 7. mdadm --grow /dev/md1 -n 3.  Wait for sync.
>=20
> md0 was same story except I only added sdd (and I used partitions sda1
> and sdd2).
>=20
> This all seemed to be working fine.
>=20
> Reboot.
>=20
> System came up with md0 as sda1 and sdd2, as expected.
> But md1 was the failed sdc3 only.  Note I did not remove the partition
> from md1; maybe I needed to?
>=20
> Shutdown, removed disk sdc for the computer.  Reboot.
> /md0 is reassembled to but md1 is not, and so the system can not not
> come up (since root is on md0).  BTW, md1 is used as a PV for LVM; md0
> is /boot.
>=20
> In at least some kernels the GPT partitions were not recognized in the
> initrd of the boot process (Knoppix 6--same version of the kernel,
> 2.6.32, as my system, though I'm not sure the kernel modules are same as
> for Debian).  I'm not sure if the GPT partitions were recognized under
> Debian in the initrd, though they obviously were in the running system
> at the start.

Well if your initrd doesn't recognise GPT, then that would explain your
problems.

>=20
> After much trashing, I pulled all drives but sda and sdb.  This was
> still not sufficient to boot because the md's wouldn't come up. md0 was
> reported as assembled, but was not readable.  I'm pretty sure that was
> because it wasn't activated (--run) since md was waiting for the
> expected number of disks (2).  md1, as before, wasn't assembled at all.=20
>=20
> >From knoppix  (v7, 32 bit) I activated both md's and shrunk them to size
> 1 (--grow --force -n 1).  In retrospect this probably could have been
> done from the initrd.
>=20
> Then I was able to boot.
>=20
> I repartitioned sdb and added it to the RAID arrays.  This led to hard
> disk failures on sdb, though the arrays eventually were assembled.  I
> failed and removed the sdb partitions from the arrays and shrunk them.
> I hope the bad sdb has not screwed up the good  sda.

Its not entirely impossible (I've seen it happen) but it is very unlikely
that hardware errors on one device will "infect" the other.

>=20
> Thanks for any assistance you can offer.

What sort of assistance are you after?

first questions is: does the initrd handle GPT.  If not, fix that first.

NeilBrown

> Ross
>=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/cB6o0.sEW9M75jA5PUw0mRW
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUK2vlDnsnt1WYoG5AQLM0xAAgD69zqFfcBFHciZme4QQlNxSNW4VTrzz
UPOedeEEGhoZYn3p/oLRZ4/r8ncUTC2vtSQody+l5YFcOeGlRrCtj6cC0YgZwg4+
0SnD1C6VVEP6887Dgg1Zr3PWmys3duSOAozSSxMxNqMQM+Ug3Pjml+bG0KL4J/oa
KiN+bT6YEjGtzqgdJZsJKBJPHq9NGZAYXDjCYQvbJlZtTQaMZcSWaxubUIIRVNOL
fgBEbrw6XTquITzT3+0kvT/RBKWSlxT2E8UGdPqa5nTFl9YVhKFyHEfePuLXD6Rj
8zU5uHHUi96yEGTOgPvBeoShCrkkgarlrDLxzj2H+rLeWgI7hfis84YFJHdcK1/j
lbkssMyN0TFe+yg+2Y/CkzPXT3UYT+o8h3LB5VqhIR1votNzSCqt62QEHV9vux1s
urUa/7A/s9HmL5qhnRqVA9XkbHEsatK8RqcEODwRYh1vatpC9tBcHRxS67LrI33d
cFzSkUDHCf1XQu8ZxGK/gLTXyh+L/JPYarBsbfZZs7U4/moFFT+HIC3bmbQLEXUw
Gxq4B0tIWziUG32mnDO1Tw64uquEzPiGGksA+QbH0j5uNcwPmm16Av49mz4Ia8uA
ZoWpW78nF8q98uNtfyujuhuYSwuyX2R4w/guHm0qOItTM3LkLCJOV7Jq1vTbIOp2
KuXDrxkjwgE=
=9hr/
-----END PGP SIGNATURE-----

--Sig_/cB6o0.sEW9M75jA5PUw0mRW--
