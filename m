From: NeilBrown <neilb@suse.de>
Subject: Re: Problem diagnosing rebuilding raid5 array
Date: Wed, 16 Oct 2013 17:11:57 +1100
Message-ID: <20131016171157.7655fe31@notabene.brown>
References: <20131014123104.77620e8uy2pe0214@phobos.elinuxservers.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/4CQvJtsPizYhbgwvmd/2ago"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20131014123104.77620e8uy2pe0214@phobos.elinuxservers.com>
Sender: linux-raid-owner@vger.kernel.org
To: peter@steinhoff.se
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/4CQvJtsPizYhbgwvmd/2ago
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 14 Oct 2013 12:31:04 -0400 peter@steinhoff.se wrote:

> Hi!
>=20
> I'm having some problems with a raid 5 array and I'm not sure how to =20
> diagnose the problem and how to proceed so I figured I need to ask the =20
> experts :-)
>=20
> I actually suspect I may have several problems at the same time.
>=20
> The machine has two raid arrays, one raid 1 (md0) and one raid 5 =20
> (md1). The raid 5 array consists of 5 x 2TB WD RE4-GP drives.
>=20
> I found some read errors in the log on /dev/sdh so I replaced it with =20
> a new RE4 GP drive and did mdadm --add /dev/md1 /dev/sdh.
>=20
> The array was rebuilding and I left it for the night.
>=20
> In the morning cat /proc/mdstat showed that 2 drives where down. I may =20
> remember incorrectly but I think that /dev/sdh showed up as a spare =20
> and another drive showed fail but the array showed up as active.
>=20
> Anyway, I'm not sure which drive showed fail but I disconnected the =20
> system for more diagnosis. This was a couple of days ago.
>=20
> I found that the CPU fan had stopped working and replaced it. The case =20
> have several fans and the heatsink seemed cool even without the fan =20
> (it's an i3-530 that does nothing more than samba so it's mostly =20
> idle). Possibly the hardrives has been running hotter than normal for =20
> a while though.
>=20
> Anyway, now when I reboot I get this:
>=20
> > cat /proc/mdstat
> Personalities : [raid1]
> md1 : inactive sdd[1](S) sdh[5](S) sdg[4](S) sdf[2](S) sde[0](S)
>        9767572480 blocks
>=20
> md0 : active raid1 sda[0] sdb[1]
>        1953514496 blocks [2/2] [UU]
>=20
> unused devices: <none>
>=20
>=20
> I'm not sure what is happening and what my next step is. I would =20
> appreciate any help on this so I don't screw up the system more than =20
> it already is :-)

We have no way of knowing how far recovery progressed onto sdh, so you need
to exclude it.  With v1.x metadata we would know ... but it wouldn't really
help the much.

Your only option is to do a --force assemble of the other devices.
sde is a little bit out of date, but it cannot be much out of date as the
array would have stopped handling writes as soon as it failed.

This will assemble the array degraded.  You should then 'fsck' and do
anything else to check that the data is OK.

Then you need to check that all your drives and are your system are good (if
you haven't already), then add a good drive as a spare and let it rebuild.

NeilBrown


>=20
> Below is the ouput of "mdadm --examine" for the drives in the raid 5 arra=
y.
>=20
> BTW, don't know if it matters but the system is running an older =20
> debian (lenny?) with a 2.6.32 backport kernel, mdadm version is 2.6.7.2.
>=20
> Best Regards,
> Peter
>=20
>=20
> > mdadm --examine /dev/sd?
>=20
> /dev/sdd:
>            Magic : a92b4efc
>          Version : 00.90.00
>             UUID : 61a6a879:adb7ac7b:86c7b55e:eb5cc2b6
>    Creation Time : Thu Jun 24 15:12:41 2010
>       Raid Level : raid5
>    Used Dev Size : 1953514496 (1863.02 GiB 2000.40 GB)
>       Array Size : 7814057984 (7452.07 GiB 8001.60 GB)
>     Raid Devices : 5
>    Total Devices : 5
> Preferred Minor : 1
>=20
>      Update Time : Wed Oct  9 20:29:41 2013
>            State : clean
>   Active Devices : 3
> Working Devices : 4
>   Failed Devices : 1
>    Spare Devices : 1
>         Checksum : 3dc0af1a - correct
>           Events : 1288444
>=20
>           Layout : left-symmetric
>       Chunk Size : 128K
>=20
>        Number   Major   Minor   RaidDevice State
> this     1       8       48        1      active sync   /dev/sdd
>=20
>     0     0       0        0        0      removed
>     1     1       8       48        1      active sync   /dev/sdd
>     2     2       8       80        2      active sync   /dev/sdf
>     3     3       0        0        3      faulty removed
>     4     4       8       96        4      active sync   /dev/sdg
>     5     5       8      112        5      spare   /dev/sdh
>=20
>=20
> /dev/sde:
>            Magic : a92b4efc
>          Version : 00.90.00
>             UUID : 61a6a879:adb7ac7b:86c7b55e:eb5cc2b6
>    Creation Time : Thu Jun 24 15:12:41 2010
>       Raid Level : raid5
>    Used Dev Size : 1953514496 (1863.02 GiB 2000.40 GB)
>       Array Size : 7814057984 (7452.07 GiB 8001.60 GB)
>     Raid Devices : 5
>    Total Devices : 5
> Preferred Minor : 1
>=20
>      Update Time : Tue Oct  8 03:26:05 2013
>            State : clean
>   Active Devices : 4
> Working Devices : 5
>   Failed Devices : 1
>    Spare Devices : 1
>         Checksum : 3dbe6d93 - correct
>           Events : 1288428
>=20
>           Layout : left-symmetric
>       Chunk Size : 128K
>=20
>        Number   Major   Minor   RaidDevice State
> this     0       8       64        0      active sync   /dev/sde
>=20
>     0     0       8       64        0      active sync   /dev/sde
>     1     1       8       48        1      active sync   /dev/sdd
>     2     2       8       80        2      active sync   /dev/sdf
>     3     3       0        0        3      faulty removed
>     4     4       8       96        4      active sync   /dev/sdg
>     5     5       8      112        5      spare   /dev/sdh
>=20
>=20
> /dev/sdf:
>            Magic : a92b4efc
>          Version : 00.90.00
>             UUID : 61a6a879:adb7ac7b:86c7b55e:eb5cc2b6
>    Creation Time : Thu Jun 24 15:12:41 2010
>       Raid Level : raid5
>    Used Dev Size : 1953514496 (1863.02 GiB 2000.40 GB)
>       Array Size : 7814057984 (7452.07 GiB 8001.60 GB)
>     Raid Devices : 5
>    Total Devices : 5
> Preferred Minor : 1
>=20
>      Update Time : Wed Oct  9 20:29:41 2013
>            State : clean
>   Active Devices : 3
> Working Devices : 4
>   Failed Devices : 1
>    Spare Devices : 1
>         Checksum : 3dc0af3c - correct
>           Events : 1288444
>=20
>           Layout : left-symmetric
>       Chunk Size : 128K
>=20
>        Number   Major   Minor   RaidDevice State
> this     2       8       80        2      active sync   /dev/sdf
>=20
>     0     0       0        0        0      removed
>     1     1       8       48        1      active sync   /dev/sdd
>     2     2       8       80        2      active sync   /dev/sdf
>     3     3       0        0        3      faulty removed
>     4     4       8       96        4      active sync   /dev/sdg
>     5     5       8      112        5      spare   /dev/sdh
>=20
>=20
> /dev/sdg:
>            Magic : a92b4efc
>          Version : 00.90.00
>             UUID : 61a6a879:adb7ac7b:86c7b55e:eb5cc2b6
>    Creation Time : Thu Jun 24 15:12:41 2010
>       Raid Level : raid5
>    Used Dev Size : 1953514496 (1863.02 GiB 2000.40 GB)
>       Array Size : 7814057984 (7452.07 GiB 8001.60 GB)
>     Raid Devices : 5
>    Total Devices : 5
> Preferred Minor : 1
>=20
>      Update Time : Wed Oct  9 20:29:41 2013
>            State : clean
>   Active Devices : 3
> Working Devices : 4
>   Failed Devices : 1
>    Spare Devices : 1
>         Checksum : 3dc0af50 - correct
>           Events : 1288444
>=20
>           Layout : left-symmetric
>       Chunk Size : 128K
>=20
>        Number   Major   Minor   RaidDevice State
> this     4       8       96        4      active sync   /dev/sdg
>=20
>     0     0       0        0        0      removed
>     1     1       8       48        1      active sync   /dev/sdd
>     2     2       8       80        2      active sync   /dev/sdf
>     3     3       0        0        3      faulty removed
>     4     4       8       96        4      active sync   /dev/sdg
>     5     5       8      112        5      spare   /dev/sdh
>=20
>=20
> /dev/sdh:
>            Magic : a92b4efc
>          Version : 00.90.00
>             UUID : 61a6a879:adb7ac7b:86c7b55e:eb5cc2b6
>    Creation Time : Thu Jun 24 15:12:41 2010
>       Raid Level : raid5
>    Used Dev Size : 1953514496 (1863.02 GiB 2000.40 GB)
>       Array Size : 7814057984 (7452.07 GiB 8001.60 GB)
>     Raid Devices : 5
>    Total Devices : 5
> Preferred Minor : 1
>=20
>      Update Time : Wed Oct  9 20:29:41 2013
>            State : clean
>   Active Devices : 3
> Working Devices : 4
>   Failed Devices : 1
>    Spare Devices : 1
>         Checksum : 3dc0af5c - correct
>           Events : 1288444
>=20
>           Layout : left-symmetric
>       Chunk Size : 128K
>=20
>        Number   Major   Minor   RaidDevice State
> this     5       8      112        5      spare   /dev/sdh
>=20
>     0     0       0        0        0      removed
>     1     1       8       48        1      active sync   /dev/sdd
>     2     2       8       80        2      active sync   /dev/sdf
>     3     3       0        0        3      faulty removed
>     4     4       8       96        4      active sync   /dev/sdg
>     5     5       8      112        5      spare   /dev/sdh
>=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/4CQvJtsPizYhbgwvmd/2ago
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUl4uLTnsnt1WYoG5AQKQAw//SZ/dN2MvPTllwFXZVgsl0QpifgNTb4WQ
WFHMr+paIA9xx3CA5QZDC97Wfql41BiBuP45fyBO6qN7iGU2JXTsycXsHa9XqaA/
Bmmy17X7qSgoXn5IXzWPxguUmK2wmMhpcRP+fTYjt/DtQSC/VKvYe0+Kdpvlm91y
MXbH1BlLyq0HxY7Bu9EH0h0u2uO3ctrwVElJ6vVRI4g/wL3caN/7IQYD43gcX6o4
u60IPS72YIyi2+F/6P8OqLyZSDSvLmy3JPI3eMXPC3yB1HuglLcTIi22CX38OKxb
BVzqu7dONfrxQQb+HY4MdLrziQj/Z2jSwC+iC68m0a5xkbZSE3wYrfmu1BrAO28B
RIiQi4AF5k68m7phEXKJsIAlsAc1GL2JUoF8Ll86GUwz8qNwo1m4bXpdwd43r5RN
U2A0QYs3m1eB1ZcL6iORot9PBo+70pkb570m3ctWsE6YTJKy4gPRhSbjwPcoW8JK
lJol7jptwosE3y4o2c69ZjFTeKGhXiXASXmYu6JC/CfmYe8+tY/3gpRFUvOiDna5
0McSunKs8v4mPUZzLt7CfR1o6ir0Obon8bmqiIJyL9M6zcpXhDWd9nlUaE6+2GGl
hK4EXTeKv+0TtTUXpgruNQeWFpbmbb/eA5+TlWnqgklYHwStFQ1VoorOzCylGGUQ
a/hT/50m0CU=
=7j6+
-----END PGP SIGNATURE-----

--Sig_/4CQvJtsPizYhbgwvmd/2ago--
