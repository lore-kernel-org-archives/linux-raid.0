From: NeilBrown <neilb@suse.de>
Subject: Re: raid10 devices all marked as spares?!
Date: Tue, 29 May 2012 08:07:36 +1000
Message-ID: <20120529080736.03c62ae1@notabene.brown>
References: <4FC3E4FB.4010003@schinagl.nl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/OP3EnRnJqBt_VpUaEBxOhPp"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4FC3E4FB.4010003@schinagl.nl>
Sender: linux-raid-owner@vger.kernel.org
To: Oliver Schinagl <oliver+list@schinagl.nl>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/OP3EnRnJqBt_VpUaEBxOhPp
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 28 May 2012 22:50:03 +0200 Oliver Schinagl <oliver+list@schinagl.nl>
wrote:

> Hi list,
>=20
> I'm sorry if this is the wrong place to start, but I've been quite lost=20
> as to what is going wrong here.

No, you are in exactly the right place!

>=20
> I've been having some issues latly with my raid10 array. First some info.
>=20
> I have three raid10 arrays on my gentoo box on 2 drives using GPT.
> I was running 3.2.1 at the time but have 3.4.0 running at the moment.
> mdadm - v3.2.5 - 18th May 2012
>=20
>=20
> md0, a 2 far-copies, 1.2 metadata, raid10 array  consisting of /dev/sda4=
=20
> and sdb4.
> md1, a 2 offset-copies, 1.2 metadata, raid10 array consisting of=20
> /dev/sda5 and sdb5
> md2, a 2 offset-copies, 1.2 metadata, raid10 array consisting of=20
> /dev/sda6 and sdb6

I'm liking the level of detail you are providing - thanks.

>=20
> sd*1 is bios_grub data, sd*2 is 256mb fat for playing with uefi and sd*3=
=20
> is 8gigs of unused space, may have some version of ubuntu on it and sd*7=
=20
> for swap.
>=20
> For all of this, md0 has always worked normally. it is being assembled=20
> from initramfs where a static mdadm lives as such:
> /bin/mdadm -A /dev/md0 -R -a md /dev/sda4 /dev/sdb4 || exit 1

In general I wouldn't recommend this.  Names of sd devices change when
devices are removed or added, so this is fragile.  It may cause the actual
problems you have been experiencing currently.

>=20
> md1 and md2 are being brought up during boot, md0 holds root, /usr etc=20
> wheras md1 are just for home and data.
>=20
> The last few weeks md1 and md2 randomly fail to come up properly. md1 or=
=20
> md2 come up as inactive and one of the two drivers are marked as spares.=
=20
> (Why as spares? Why won't it try to run the array with a missing drive?)=
=20
> While this happens, it's completly abitrary whether sda or sdb is being=20
> used. so md1 can be sda5[2](S) and md2 can be sdb5[2](S).

The (S) is a bit misleading here.  When an array is 'inactive', all devices
are marked as '(S)', because they are not currently active (nothing is as t=
he
whole array is inactive).

When md1 has sda5[2](S), is sdb5 mentioned for md1 as well, or is it simply
absent.   I'm guessing the second.

This it most likely caused by "mdadm -I" being run by udev on device
discovery.  Possibly it is racing with an "mdadm -A" run from a boot script.
Have a look for a udev/rules.d script which run mdadm -I and maybe disable =
it
and see what happens.

>=20
> When this happens, I mdadm --stop /dev/md1 and /dev/md2, followed=20
> immediatly by mdadm -A /dev/md1 (using mdadm.conf which doesn't even=20
> list the devices. ARRAY /dev/md1 metadata=3D1.2 UUID=3Dnnn name=3Dhost:ho=
me).=20
> The arrays come up and work just fine.
>=20
> What happend today however, is that md2 again does not come up, and=20
> sda6[3](S) shows in /proc/mdadm. However re-assembly of the array fails=20
> and only using mdadm -A /dev/md2 /dev/sda6 /dev/sdb6 shows:
> mdadm: device 1 in /dev/md2 has wrong state in superblock, but /dev/sdb6=
=20
> seems ok
> mdadm: /dev/md2 assembled from 0 drives and 2 spares - not enough to=20
> start the array.
> /proc/mdadm shows as somewhat expected.
> md2 : inactive sda6[3](S) sdb6[2](S)
>=20
> Only using sdb6 however also fails. I guess because it does not want to=20
> use a spare.
> mdadm: failed to RUN_ARRAY /dev/md2: Invalid argument
> mdadm: Not enough devices to start the array.
>=20
> Now the really disturbing part comes from mdadm --examine.
> valexia oliver # mdadm --examine /dev/sda6
> /dev/sda6:
>            Magic : a92b4efc
>          Version : 1.2
>      Feature Map : 0x0
>       Array UUID : nnnn
>             Name : host:opt  (local to host host)
>    Creation Time : Sun Aug 28 17:46:27 2011
>       Raid Level : -unknown-
>     Raid Devices : 0
>=20
>   Avail Dev Size : 456165376 (217.52 GiB 233.56 GB)
>      Data Offset : 2048 sectors
>     Super Offset : 8 sectors
>            State : active
>      Device UUID : nnnn
>=20
>      Update Time : Mon May 28 20:52:35 2012
>         Checksum : ac17255 - correct
>           Events : 1
>=20
>=20
>     Device Role : spare
>     Array State :  ('A' =3D=3D active, '.' =3D=3D missing)
>=20
> sdb6 lists identical content only with the checksum's being correbt,=20
> albeit different and of coruse the Device UUID. Array UUID is of course=20
> identical as is creation time.
>=20
> Also to note, is that grub2 does mention an 'error: Unsupported RAID=20
> level: -1000000.' which probably relates to the 'Raid Level: -unknown-'.
>=20
> As to what may have caused this? I have absolutely no idea. I did a=20
> clean shutdown where the arrays get cleanly unmounted. Not 100% sure if=20
> the arrays get --stopped but I would be surprised if they did not.
>=20
> So I guess is this a md driver bug? Is there anything I can do to=20
> recover my data, which i cannot image it not being?

This is a known bug which has been fixed.  You are now running 3.4 so are
safe from it.
You can recover your data by re-creating the array.

  mdadm -C /dev/md2 -l10 -n2 --layout o2 --assume-clean \
  -e 1.2  /dev/sda6 /dev/sdb6

Check that I have that right - don't just assume :-)

when you have created the array, check that the 'Data Offset' is still
correct, then if it is "fsck -n" the array to ensure everything looks good.
Then you should be back in business.

NeilBrown



>=20
> Thanks in advance for reading this.
>=20
> Oliver
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/OP3EnRnJqBt_VpUaEBxOhPp
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT8P3KDnsnt1WYoG5AQJ7wBAAimLQMhbfvpYkIWiKWn/VAoBqe48ahmEd
IBr3u8fzGny3YNw7xKZ6CrrTTORhRmhx9drx69dcvKFgqKOucwzDjTJwaC3YjCTR
qOWi7jFsyOb4p5cDr05w+biky3LZ4Jp5xKEswMPWmH+xsutRwVjjDXIAcOobcpUV
2VpQ+cLO8rRxquvpC1Y1SqBkTx5axNR3WClFvztDoBoVdrfICokdlVnEgXAQ8snn
z+u+NQhSGd7F1h0eRIqlWrDmAf1fqv8pYlXObAdNM3MIY40yC4bxOhfQVYKWafBx
fGrzJCV6xMkBL6kqgS+v8AuayZf3j5d9zF2gXpo88SAo36xadypl8o1TBxdCPAQ3
u5RYsyosoPEVuQ11eD8zY1sZCW/du3l6cOux2as/TXIdBRxzjuEs1+N6nAbdS9CM
GITOu0j10XLu85Eo/O33XgIrqv2wKxaUlFUn1rQTXyPRy/4YHaJM4XuosAiRcAcJ
Pcq0Sp9r0Lpdld2AODLXUZE0CrunB06tKnPlGcpfIbBFJyjTFgm4vbnvajaJxAyC
ssqJ54Q+iY8XI2mWLbakx8e7Vf0V+pDIO8Bpc79hXrOWKddZ3ZWTEuLUn7KBIoFE
Cb1jwCKhN2DcCuBL/bszvmH/+c6PnwpRedkESqIh5oiJ9DH8WuuhV4lnQWZnC5i5
43HmuKLLzNQ=
=9HFY
-----END PGP SIGNATURE-----

--Sig_/OP3EnRnJqBt_VpUaEBxOhPp--
