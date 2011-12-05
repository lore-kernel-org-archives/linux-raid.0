From: NeilBrown <neilb@suse.de>
Subject: Re: RAID6 - repeated hot-pulls issue
Date: Mon, 5 Dec 2011 17:15:40 +1100
Message-ID: <20111205171540.4fe659e2@notabene.brown>
References: <CALwOXvL6avy3f76TcpMdMxqObCRY-SphRErjo-j1=iun-etBpA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/GLthw8zXgR+y=LqoEdzTiX+"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CALwOXvL6avy3f76TcpMdMxqObCRY-SphRErjo-j1=iun-etBpA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: John Gehring <john.gehring@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/GLthw8zXgR+y=LqoEdzTiX+
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Fri, 2 Dec 2011 09:34:40 -0700 John Gehring <john.gehring@gmail.com> wro=
te:

> I am having trouble with a hot-pull scenario.
>=20
> - linux 2.6.38.8
> - LSI 2008 sas
> - RAID6 via md
> - 8 drives (2 TB each)
>=20
> Suspect sequence:
>=20
> 1 - Create Raid6 array using all 8 drives (/dev/md1). Each drive is
> partitioned identically with two partitions. The second partition of
> each drive is used for the raid set. The size of the partition varies,
> but I have been using a 4GB partition for testing in order to have
> quick re-sync times.
> 2 - Wait for raid re-sync to complete.
> 3 - Start read-only IO against /dev/md1 via following command:=A0 dd
> if=3D/dev/md1 of=3D/dev/null bs=3D1=A0 This step insures that pulled driv=
es
> are detected by the md.
> 4 - Physically pull a drive from the array.
> 5 - Verify that the md has removed the drive/device from the array.
> mdadm --detail /dev/md1 should show it as faulty and removed from the
> array.
> 6 - Remove the device from the raid array:=A0 mdadm /dev/md1 -r /dev/sd[?=
]2
> 7 - Re-insert the drive back into the slot.
> 8 - Take a look at dmesg to see what device name has been assigned.
> Typically has the same letter assigned as before.
> 9 - Add the drive back into the raid array: mdadm /dev/md1 -a
> /dev/sd[?]2=A0=A0 Now some folks might say that I should use --re-add, but
> the mdadm documentation states that re-add will be used anyway if the
> system detects that a drive has been 're-inserted'. Additionally, the
> mdadm response to this command shows that an 'add' or 'readd' was
> executed depending on the state of the disk inserted.
> --All is apparently going fine at this point. The add command succeeds
> and cat /proc/mdstat shows the re-sync in progress and it eventually
> finishes.
> --Now for the interesting part.
> 10 - Verify that the dd command is still running.
> 11 - Pull the same drive again.
>=20
> This time, the device is not removed from the array, although it is
> marked as faulty in the /proc/mdstat report.
>=20
> In mdadm --detail /dev/md1, the device is still in the raid set and is
> marked as "faulty spare rebuilding". I have not found a command that
> will remove drive from the raid set at this point. There were a couple
> of instances/tests where after 10+ minutes, the device came out of the
> array and was simply marked faulty, at which point I could add a new
> drive, but that has been the exception. Usually, it remains in the
> 'faulty spare rebuilding' mode.
>=20
> I don't understand why there is different behavior the second time the
> drive is pulled. I tried zeroing out both partitions on the drive,
> re-partitioning, mdadm --zero-superblock, but still the same behavior.
> If I pull a drive and replace it, I am able to do a subsequent pull of
> the new drive without trouble, albeit only once.
>=20
> Comments? Suggestions? I'm glad to provide more info.
>

Yes, strange.

The only think that should stop you being able to remove the device is if
there are outstanding IO requests.

Maybe the driver is being slow in aborting requests the second time.  Could
be a driver bug on the LSI.

You could try using blktrace to watch all the requests and make sure every
request that starts also completes....

NeilBrown


--Sig_/GLthw8zXgR+y=LqoEdzTiX+
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTtxhjDnsnt1WYoG5AQIYZRAArOtV6qaRAGgEucGuWRsFboLSOapMbiU4
JVLlfPALXgXi+em7rsmRkfqHe3uTK763Yi66YWBQuytiffM8MEIMrdy4jyAu7V37
qhqMDJlUe7VG7b0f3ql4EkKKX2b6FnSC5BcC+eYJS5RzsnRURSC9o21ny6bgS84a
EsZ9AdVF4I7QwSn9bjDZu67pq07Qp7jF0PzvDagWqd6Pt5c1j8VdUMjLno1fnD84
3FmvF2PFB4cuZ0xgyeEZ2QrNCc4KG1mgGAfrDnI9EF3VRWkA8NwsIqYNpD4igx4P
NDALxhiKeQwmWku7xhTDPMqG5JJDv1FXBWJyMX8tjofHB1bjVFGKfU9aFFdC04N5
ZHm948pAU18a0Cl6QG+gO5ywBIvXouO+eQlztFm2sVMLjWP5+meTvG6t2ULF7Yfu
rQcI6J97UqN0yixWvXvrPHjccGCSffO47l/Z8BRHDE3cbHuDXPiQ6vZzVBa4Dusv
Wf9eXU0Kd/Dl8Z3/9Y13OrHMv2JpByO/qfGxxM79n/WvRPQcM1qjZZsT82k41rWD
INxD9fV5eneGo0Lk4UUDy6hZD0RWA2uV6G4Wo8cRxufWCYzC4LAfKf5bCMrN+u4+
6cW60yjhQjjfeBSLlw++zxgNApJvfpVRB0pc5RXUKJ4WTzKIIkGxFUG99fuzC63x
tKuzqMuEyGs=
=Jrj5
-----END PGP SIGNATURE-----

--Sig_/GLthw8zXgR+y=LqoEdzTiX+--
