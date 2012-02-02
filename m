From: NeilBrown <neilb@suse.de>
Subject: Re: Some md/mdadm bugs
Date: Fri, 3 Feb 2012 08:17:17 +1100
Message-ID: <20120203081717.195bfec8@notabene.brown>
References: <4F2ADF45.4040103@shiftmail.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/g93czM45RogRwe6XbPHDGhU"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F2ADF45.4040103@shiftmail.org>
Sender: linux-raid-owner@vger.kernel.org
To: Asdo <asdo@shiftmail.org>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/g93czM45RogRwe6XbPHDGhU
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 02 Feb 2012 20:08:53 +0100 Asdo <asdo@shiftmail.org> wrote:

> Hello list
>=20
> I removed sda from the system and I confirmed /dev/sda did not exist any=
=20
> more.
> After some time an I/O was issued to the array and sda6 was failed by MD=
=20
> in /dev/md5:
>=20
> md5 : active raid1 sdb6[2] sda6[0](F)
>        10485688 blocks super 1.0 [2/1] [_U]
>        bitmap: 1/160 pages [4KB], 32KB chunk
>=20
> At this point I tried:
>=20
> mdadm /dev/md5 --remove detached
> --> no effect !
> mdadm /dev/md5 --remove failed
> --> no effect !

What version of mdadm? (mdadm --version).
These stopped working at one stage and were fixed in 3.1.5.


> mdadm /dev/md5 --remove /dev/sda6
> --> mdadm: cannot find /dev/sda6: No such file or directory  (!!!)
> mdadm /dev/md5 --remove sda6
> --> finally worked ! (I don't know how I had the idea to actually try=20
> this...)

Well done.

>=20
>=20
> Then here is another array:
>=20
> md1 : active raid1 sda2[0] sdb2[2]
>        10485688 blocks super 1.0 [2/2] [UU]
>        bitmap: 0/1 pages [0KB], 65536KB chunk
>=20
> This one did not even realize that sda was removed from the system long a=
go.

Nobody told it.

> Apparently only when an I/O is issued, mdadm realizes the drive is not=20
> there anymore.

Only when there is IO, or someone tells it.

> I am wondering (and this would be very serious) what happens if a new=20
> drives is inserted and it takes the /dev/sda identifier!? Would MD start=
=20
> writing or do any operation THERE!?

Wouldn't happen.  As long as md hold onto the shell of the old sda nothing
else will get the name 'sda'.

>=20
> There is another problem...
> I tried to make MD realize that the drive is detached:
>=20
> mdadm /dev/md1 --fail detached
> --> no effect !
> however:
> ls /dev/sda2
> --> ls: cannot access /dev/sda2: No such file or directory
> so "detached" also seems broken...

Before 3.1.5 it was.  If you are using a newer mdadm I'll need to look into
it.

>=20
>=20
>=20
> And here goes also a feature request:
>=20
> if a device is detached from the system, (echo 1 > device/delete or=20
> removing via hardware hot-swap + AHCI) MD should detect this situation=20
> and mark the device (and all its partitions) as failed in all arrays, or=
=20
> even remove the device completely from the RAID.

This needs to be done via a udev rule.
That is why --remove understands names like "sda6" (no /dev).

Then a device is removed, udev processes the remove notification.
The rule

ACTION=3D=3D"remove", RUN+=3D"/sbin/mdadm -If $name"

in /etc/udev/rules.d/something.rules

will make that happen.

> In my case I have verified that MD did not realize the device was=20
> removed from the system, and only much later when an I/O was issued to=20
> the disk, it would mark the device as failed in the RAID.
>=20
> After the above is implemented, it could be an idea to actually allow a=20
> new disk to take the place of a failed disk automatically if that would=20
> be a "re-add" (probably the same failed disk is being reinserted by the=20
> operator) and this even if the array is running, and especially if there=
=20
> is a bitmap.

It should so that, providing you have a udev rule like:
ACTION=3D=3D"add", RUN+=3D"/sbin/mdadm -I $tempnode"

You can even get it to add other devices as spares with e.g.
  policy action=3Dforce-spare

though you almost certainly don't want that general a policy.  You would
want to restrict that to certain ports (device paths).


> Now it doesn't happen:
> When I reinserted the disk, udev triggered the --incremental, to=20
> reinsert the device, but mdadm refused to do anything because the old=20
> slot was still occupied with a failed+detached device. I manually=20
> removed the device from the raid then I ran --incremental, but mdadm=20
> still refused to re-add the device to the RAID because the array was=20
> running. I think that if it is a re-add, and especially if the bitmap is=
=20
> active, I can't think of a situation in which the user would *not* want=20
> to do an incremental re-add even if the array is running.

Hmmm.. that doesn't seem right.  What version of mdadm are you running?
Maybe a newer one would get this right.

Thanks for the reports.

NeilBrown


>=20
> Thank you
> Asdo
>=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/g93czM45RogRwe6XbPHDGhU
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTyr9XTnsnt1WYoG5AQJsURAAtLsQ4g6NzJGchIqkwa4WGnw/eXWqHmdI
S5H9lZmcKm9kJ2ZKheMscieBWVx3K5mMO4ZNVu7kkpnRVhy1Hb4+Au1abIeCEqVs
EO+1vc9dZnsqoI1n42hHa8xGGAJlRZq/fMApAtVtt4Y0itUaYm3lEvbKGckjKgKr
7EWgrq8VxBROco7cyyedDNMiZuYDtCJdKWnEjDO6urm8tP2Yb9B+QIQLEIUXWV0W
kaoAdDEJIAPUE61OHd8ObcMm0tSSyy3SjteUItOhn2AIS0OTH3pRLHjs9nkJ+jq4
U4oImN4Lc6XgLJEeBfJ5cCQUrPcxHf1b6bwXzRIxV3Fp18fWut+rTbT/noWIKmfp
611ixsCZxAen9F66rIXeM/5ZQrLvELRcYIXeXVE3NvWqVMqwW/NjCBtrtcli4zfY
si1gIr7xXHUem+azIDgm1AHBIZ7A1oD4VgOo1D37GiDguY0TCzr5hOOItFJq12I1
sCHC98LU6TI4jqUZeypYHbvKUYRWN8F+Ed3jMbyE48SVMI9zc8LBneeVsYAoH8Le
+IiFBdLvVdON6X/4OgETQQVkE5no1bbXQpVlvWslPQUijzkjF5T0Pu/udslHT/QM
dFTj8o0cVm7cUhNBaC7HayeucwIH2pybjxEhMBdlYYP/ySCIi7B4FT3zb/vVfU9M
dyAiUk7DZxs=
=w5VX
-----END PGP SIGNATURE-----

--Sig_/g93czM45RogRwe6XbPHDGhU--
