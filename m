From: NeilBrown <neilb@suse.de>
Subject: Re: Spin down
Date: Mon, 5 Dec 2011 17:11:15 +1100
Message-ID: <20111205171115.044b1705@notabene.brown>
References: <CAF78GY0YdJ0c0WWpyDnnzitAec_7VZZnEsP_n_UHuec5JmVAng@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/2.eG2wmg.ty+12li=M/AApe"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAF78GY0YdJ0c0WWpyDnnzitAec_7VZZnEsP_n_UHuec5JmVAng@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Vincent Pelletier <plr.vincent@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/2.eG2wmg.ty+12li=M/AApe
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 3 Dec 2011 12:23:37 +0100 Vincent Pelletier <plr.vincent@gmail.com>
wrote:

> Hi.
>=20
> Short system description:
> up-to-date Debian sid, used on a NAS-ish machine (iscsi with
> open-iscsi's kernel module, nfs, dnsmask for netboot), ext4 FS over
> RAID1 on both system partition and exported data partitions.
>=20
> I would like disks containing raid arrays to spin down, but there are
> periodic disk writes which prevent this.
> They do not show up in iotop (although it does show a write activity
> in the topmost line).
> Enabling /proc/sys/vm/block_dump generates the following output:
>=20
> <7>[  918.078079] md0_raid1(304): WRITE block 8 on sda1 (2 sectors)
> <7>[  918.078169] md0_raid1(304): WRITE block 8 on sdc1 (2 sectors)
> <7>[  918.092124] md1_raid1(311): WRITE block 8 on sda5 (2 sectors)
> <7>[  918.092184] md1_raid1(311): WRITE block 8 on sdc5 (2 sectors)
> <7>[  918.292627] md0_raid1(304): WRITE block 8 on sda1 (2 sectors)
> <7>[  918.292714] md0_raid1(304): WRITE block 8 on sdc1 (2 sectors)
> <7>[  918.308500] md1_raid1(311): WRITE block 8 on sda5 (2 sectors)
> <7>[  918.308588] md1_raid1(311): WRITE block 8 on sdc5 (2 sectors)
> <7>[  923.113309] md0_raid1(304): WRITE block 8 on sda1 (2 sectors)
> <7>[  923.113397] md0_raid1(304): WRITE block 8 on sdc1 (2 sectors)
> <7>[  923.129330] md1_raid1(311): WRITE block 8 on sda5 (2 sectors)
> <7>[  923.129388] md1_raid1(311): WRITE block 8 on sdc5 (2 sectors)
> <7>[  923.332489] md0_raid1(304): WRITE block 8 on sda1 (2 sectors)
> <7>[  923.332545] md0_raid1(304): WRITE block 8 on sdc1 (2 sectors)
> <7>[  923.348507] md1_raid1(311): WRITE block 8 on sda5 (2 sectors)
> <7>[  923.348595] md1_raid1(311): WRITE block 8 on sdc5 (2 sectors)
>=20
> Note the 5-seconds pause between each half of this output.
> Block 8 seems to be the md superblock (dixit hexdump + description of
> md superblock), and "mdadm --examine" shows the "Update time" is being
> increased.
> Those arrays are in clean state, no synchronisation is happening and
> no checking that I know of (I would expect a lot of disk activity).
>=20
> Is there any reason why those writes are happening ?
> I can imagine a mechanism like filesystem superblock periodic
> flushing, but AFAIK it only happens when changes are happening (even
> if they are not flushed themselves), and I would expect the same to
> happen here.
> Is there any knob to control those writes ?
>=20
> Regards,

5 seconds suggests a bitmap update.  Do you have an internal bitmap?

Try to remove it
   mdadm --grow /dev/md0 --bitmap=3Dnone

and see if they stop.
Then try adding it back with a longer delay
  mdadm --grow /dev/md0 --bitmap=3Dinternal --delay=3D60

What kernel version are you running?

NeilBrown

--Sig_/2.eG2wmg.ty+12li=M/AApe
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTtxggznsnt1WYoG5AQJeaA/9GDOUk0cPrTQ31bfpSVhqI5NuuO2igS+G
W9nnAbe4kp9Tekik2VMTRGRrfBlOLYHNN5VeiUbIfvoY+OE6MZVVIw0ZisMTOQEg
6dPMgW8ggPncgptlbOLa/V+gSm+qKIq4W9JHSOspVK2QpHC8XF5arpoocK/FSi8Y
/ssKM+O+fWSX15XgFaV21MN/y2lo/+S69aWDaxQOEAYXh5D9Ni7u5RvFA6P5x4bS
Ql3sQ/3Jz+ti8d6GwXT6pn+BseJevjUZe7E7jlpMFNjaNKp4zcK7IZNn88cYV7pG
cDHVDSmDIoAUG63uQA2gic0R3TaLi9+EcbffytofS4qCJq8Sq1DLlDZmGmjoazlQ
oay/VvI+v+DgzJMpdokyJdrLTtftnQ7K89uuTgi0HGMfhBJlQvIK2dl6izoIY2Al
QfnlSnzymFW3cZe3otuqoWlA3Jzc8zLhBs1TVgeuARZocZQwGENeSYuxBr/6N3Qr
itmPgfNjf75pfyyykDQ6asaRV5r92Zt3U1zoYpXy7WLKY3oyy0uYqbgXlYJHV7J2
JIDZJZoBbupAI6ugjnFDmKgitVIWGU4XxoF1e2NGt8HQVeZgf4YdnNxcOVKBCEtj
AFDV9IlKr6BYNziTPNcktX9Rgpp8bD3qlqsfB3FqPLc1iv+8ITZSQ006toU4RuxR
iIQcuJjqRxs=
=zSEU
-----END PGP SIGNATURE-----

--Sig_/2.eG2wmg.ty+12li=M/AApe--
