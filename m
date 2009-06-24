From: Michael Ole Olsen <gnu@gmx.net>
Subject: Re: reshape raid5 to raid6
Date: Wed, 24 Jun 2009 15:32:45 +0200
Message-ID: <20090624133245.GA2828@rlogin.dk>
References: <20090624102729.GY2828@rlogin.dk> <972c997a386db1106868b3dc6b29ee21.squirrel@neil.brown.name>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wayzTnRSUXKNfBqd"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <972c997a386db1106868b3dc6b29ee21.squirrel@neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--wayzTnRSUXKNfBqd
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello I just compiled the 2.6.30 kernel from kernel.org
I was running 29.3 and 2.6.7.2 mdadm (Nov 08) Debian lenny, but kernel from
kernel.org.

I added the new device with echoing into /sys as you described

mfs:/home/michael# mdadm --zero-superblock /dev/sdc (It was an old disk from
the raid that was taken out long ago and not used - array was not degraded,
so I can just zero it)

mfs:/home/michael# mdadm --add /dev/md0 /dev/sdc

mfs:/home/michael# cat /proc/mdstat=20
Personalities : [raid6] [raid5] [raid4]=20
md0 : active raid6 sdc[10] sdi[0] sda[8] sdj[7] sdb[6] sde[5] sdg[4] sdd[3]
sdh[2] sdf[1]
      11721107968 blocks level 6, 64k chunk, algorithm 18 [10/9] [UUUUUUUUU=
_]
            [>....................]  recovery =3D  0.9% (14365824/146513849=
6)
    finish=3D414.1min speed=3D58382K/sec

the raid6 seems to be working, at least proc says so.

after stopping my reads and writes to the disk the reshape went=20
=66rom approximately 1000kB/s to 55000kB/s (i think i was only reading a bi=
t from it)

440 minutes till reshape, so seems to go just fine.

I will try to re-stripe (and of course backup data first) with the new mdad=
m=20
when it comes out, looking forward to it, thanks

/Michael Ole Olsen


NeilBrown schrieb am Wednesday, den 24. June 2009:

> On Wed, June 24, 2009 8:27 pm, Michael Ole Olsen wrote:
> > Is it possible to reshape my /dev/md0 raid5 into raid6?
>=20
> If you are are using Linux 2.6.30, then you can
>=20
>   echo raid6 > /sys/block/md0/md/level
>=20
> and it will instantly be sort-of-raid6.
> It is exactly like raid6 except that the Q blocks are all one
> the one drive, and drive that previously didn't exist.
> If you have a spare, it will start building the Q blocks
> on that drive and when it finishes you will have true raid6
> redundancy, though possibly a little less than raid6 performance,
> as a real raid6 has the Q block distributed.
>=20
> When mdadm-3.1 is released, you will be able to tell the raid6
> to re-stripe with a more traditional layout.  This will take quite
> a while, but you can continue to use the array (though a bit more
> slowly) will it progresses.
> Of course you don't need to do that step if you don't want to.
>=20
>=20
>=20
> >
> > I found the following recipe in the docs:
> > mdadm --create /dev/md0 -l6 -n4 /dev/sdb1 /dev/sdc1 /dev/sdd1 missing
> >
> > I have 9 disks in my raid5, would i then do:
> > [1] mdadm --create /dev/md0 -l6 -n10 /dev/sda /dev/sdb ... missing
>=20
> If you did this, an the drives contained raid5 data, then that data
> would not be available on /dev/md0.
>=20
> NeilBrown
>=20
>=20
> >
> > i.e. only the first 9 drives and then hot add a new device to get it to
> > reshape and add the extra parity to all drives?
> >
> > mdadm --add /dev/md0 /dev/sdk ?
> >
> > I would guess  command [1] would give problems as md0 is an active array
> > will it work if i --stop the array first so that i can reshape to raid6?
> >
> > I couldn't really find much information on this, some say it is impossi=
ble
> > without recreating the array? (So i ask here first before i try, as I d=
ont
> > want to risk my data, even though I have backups of the important
> > data)
> >
> > Any advice would be nice
> >
> > /Michael Ole Olsen
> >
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--wayzTnRSUXKNfBqd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iQIcBAEBAgAGBQJKQir8AAoJECXlragqp/ZIuQgP+wcnJzLh50rO5zrX0uOpazoI
paMzAL3GkNzK50+iM7rE39sZJ2gcyFgYnWEYleF2cAb9ZucoXidjWJdj5oXzWnak
DmGSObRVjXlPx4ALyqOFCof+3wEc9Y3wYYXgyNz2b6pvVegWhymSrXORpor7/STk
sgNkK6V9Uvi2kubRBSeyxQSWv/tzQ88F7+hVEMudFhnpAV8hsngE4n7EWsuEC7j3
ZJHQhbbYpL9/PpbKDHCdG0QDgLAPhlZ78bJtECwgNP55OtmRO1BzBm74IiXcsDma
dCb/jqaDqa+tdNPFdkjKh1rvPW1QWm9g9cWxECX1f5AAeNKqiCl0ySo6MfEEXbgu
fasA+2x0t+3O6a7M4sqbkGi+Tj48mhYCmqNmQu63SlRZgYuDgpvMB+gRkg3QqVwZ
ezC/KpKD5F0j1ke4h+6mZWhKVtrphU5/5IkaGTQjky7xqR7k4plWcArWS//jEvn/
HRMiuet/SQYsvcN5tkpBh2VAG0Ffgxh1Yn8K6CMcyPGTz2xj7w0Jbem8bt6T1uGc
TR/qyVXQxm3JT937vRWlWhTtzavPmsWAaxZ1fncphQ8Jy2qG5VLy6rJVMDfadvy6
bjgpVtpeufggAJCpROU80JwRCM1CvM2Vpfbj1CQ1cw6J7ZkM0LOA/PbfERfjw9ps
XSkbpOQFwTCTls0K/ymV
=e8Zz
-----END PGP SIGNATURE-----

--wayzTnRSUXKNfBqd--
