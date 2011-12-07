From: NeilBrown <neilb@suse.de>
Subject: Re: system startup hangs
Date: Thu, 8 Dec 2011 10:00:33 +1100
Message-ID: <20111208100033.69c42b6c@notabene.brown>
References: <4EDFEACD.3010806@kinfolk.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Z2U+w9MDneS+D=mFW9fZiQB"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4EDFEACD.3010806@kinfolk.org>
Sender: linux-raid-owner@vger.kernel.org
To: "Richard B. Pyne" <rpyne@kinfolk.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/Z2U+w9MDneS+D=mFW9fZiQB
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 07 Dec 2011 15:38:05 -0700 "Richard B. Pyne" <rpyne@kinfolk.org>
wrote:

> Please forgive me if I ask stupid questions, I am fairly new to linux=20
> raid and most of the documentation I can find is severely outdated=20
> and/or written for someone who already understands linux raid.
>=20
> I have successfully built a set raid 6 array with 4 drives and have=20
> copied my system partitions onto the raid drives. I then reboot with=20
> root=3D/dev/md0.
>=20
> Everything looks like it is working right up through:
>=20
> md/raid:md0 raid level 6 active with 4 out of 4 devices, algorithm 2
> md0: detected capacity change from 0 to 1000131788
> md: autorun DONE.
> md0: unknown partition table
> EXT3-fs (md0): error: couldn't mount because of unsupported optional=20
> features
> EXT2-fs (md0): error: couldn't mount because of unsupported optional=20
> features
> EXT4-fs (md0): mounted filesystem with ordered data mode.  Opts: (null)
> VFS: Mounted root (ext4 filesystem) readonly on device 9:0.
> freeing unused kernel memory: 472k freed

It looks like the array got setup fine, the filesystem on it was mounted, a=
nd
then .... nothing.

I think at this point it should be running /sbin/init.

It doesn't seem like a RAID problem exactly.  Maybe something when wrong wh=
en
you copying the system partition into the RAID, but that is just a guess.

At this point we probably need to know at least what distro you are using.
There is probably some way to turn on tracing in the initrd and the boot
sequence, but it is different for different distros.

NeilBrown



>=20
>=20
> at which point it just hangs. No more disk access, no more messages.
>=20
>=20
> The system has 5 WD Caviar Black 500GB drives. I did the linux install=20
> on the first drive and built the other 4 drives into the raid system,=20
> planning to move everything (except the /boot partition) on to the raid=20
> array and then repartition everything except the /boot partition on the=20
> first drive and add it to the raid.
>=20
> I currently have md0 for / md1 for /home md2 for /usr md3 for /var and=20
> md4 on which I plan on running lvm to allocate to other system needs.
>=20
> Any advice, insights and/or direction will be greatly appreciated.
>=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/Z2U+w9MDneS+D=mFW9fZiQB
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTt/wETnsnt1WYoG5AQKqQg//Q0pbXdi6J1QlAykouzz94iD32rIXJQDj
w4TpRHxc7c3QJnX2XQEe7XhKvutzzHbeFHzZthLE+0CpA3e/Svj0+/5JhCguWyme
bEP9x7O253Ak5XeUT8MbeFoFeDyVneVxdxe/3cEh4XTzLzqfbXNR34sWY7AEAQ3v
Thnkoa3ct3OW1YIKNtO9DsyzE/ehqchzX9wdJL+48U/wU4EFzENiolSPb9fwSmNx
YMpXU/ToiyX+on/fmSQYuTKxZUBcGVDCCvVPnYVd3p2YWSnVsOziw3nJXS3AZb3z
ldBNlTNMabb6ntXY3PtHI5o/qiW2gi2EuQFE7w0sqgM3+S+qu4SDiGOFYrk0cqEt
sIEO0C5ABWpV5rZib5xWEN8OAdojbpI/q7FxoNkxwSyk3bMpcMyRFr3i03QB2nOf
rgFXSRGXU1dnXI1yXKIebMZr62YroRTgmu4FQ//25myT8M0lLjf5eLE1vjClAVbp
ZBmiMS4/z2/57g0VFArJjh7MBdl1sliCKIgHiKUmrXdIVoUHWA3f4zuqqbxcUHRr
c6W+Rg/VEeyjRCNrYtjspNbiG5mg79LfeiqEuqh4oqxgj8C31DCv/8QwkzIMd63G
uW2yQN+DqDESVdhcQxeKHxik8O0djpaqz5eJWDgpTpwvb/roIiuRihy2rntqLv5O
hRRkdnrpqv4=
=jZf0
-----END PGP SIGNATURE-----

--Sig_/Z2U+w9MDneS+D=mFW9fZiQB--
