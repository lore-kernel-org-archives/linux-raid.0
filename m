From: NeilBrown <neilb@suse.de>
Subject: Re: Raid1 where Event Count off my 1 cannot assemble --force
Date: Mon, 9 Dec 2013 12:00:40 +1100
Message-ID: <20131209120040.6464b91b@notabene.brown>
References: <52A44778.8040502@suddenlinkmail.com>
	<alpine.DEB.2.02.1312081157100.24602@uplift.swm.pp.se>
	<52A4B311.6040204@suddenlinkmail.com>
	<52A51122.3030604@suddenlinkmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/GhE/AnZHzQAB0+4i/YVr+XC"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52A51122.3030604@suddenlinkmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "David C. Rankin" <drankinatty@suddenlinkmail.com>
Cc: mdraid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/GhE/AnZHzQAB0+4i/YVr+XC
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 08 Dec 2013 18:38:58 -0600 "David C. Rankin"
<drankinatty@suddenlinkmail.com> wrote:

> On 12/08/2013 11:57 AM, David C. Rankin wrote:
> > On 12/08/2013 04:57 AM, Mikael Abrahamsson wrote:
> >> On Sun, 8 Dec 2013, David C. Rankin wrote:
> >>
> >>> Guys,
> >>>
> >>>  I have an older box that is a fax server where the Event Count for /=
dev/md1 is
> >>> off by 1, but the array cannot be reassembled with --assemble --force=
 /dev/dm1
> >>> /dev/sda5 /dev/sdb5.
> >>
> >> What are the messages displayed in "dmesg" when you try to use this co=
mmand?
> >>
> >=20
> > Mikael,
> >=20
> >   Following the commands:
> >=20
> > # mdadm --stop /dev/md1
> > # mdadm --assemble --force /dev/dm1 /dev/sd[ab]5
> >=20
> >   The messages captured in the logs are:
> >=20
> > Rescue Kernel: md: md1: stopped.
> > Rescue Kernel: md: unbind<sda5>
> > Rescue Kernel: md: export_rdev(sda5)
> > Rescue Kernel: md: unbind<sdb5>
> > Rescue Kernel: md: export_rdev(sdb5)
> > Rescue Kernel: md: md1: stopped.
> > Rescue Kernel: md: md1 raid array is not clean -- starting background r=
econstruction
> > Rescue Kernel: md: raid1: raid set md1 active with 2 out of 2 mirrors
> > Rescue Kernel: md1: bitmap file is out of date (148 < 149) -- forcing f=
ull recovery
> > Rescue Kernel: md1: bitmap file is out of date, doing full recovery
> > Rescue Kernel: md1: bitmap initialisation failed: -5
> > Rescue Kernel: md1: failed to create bitmap (-5)
> >=20
> >=20
> >   That's it for the log, then on the command line I have:
> >=20
> > mdadm: failed to RUN_ARRAY /dev/md1: Input/Output error
> >=20
> >   What should I try next? Don't hesitate to ask if you need any additio=
nal
> > information, I'll provide whatever is necessary. Thanks.
> >=20
>=20
> Here is additional information with --verbose given:
>=20
> nemtemp:~ # cat /proc/mdstat
> Personalities : [raid1]
> md2 : active raid1 sda7[0] sdb7[1]
>       221929772 blocks super 1.0 [2/2] [UU]
>       bitmap: 0/424 pages [0KB], 256KB chunk
>=20
> md1 : inactive sda5[0] sdb5[1]
>       41945504 blocks super 1.0
>=20
> md0 : active raid1 sda1[0] sdb1[1]
>       104376 blocks super 1.0 [2/2] [UU]
>       bitmap: 0/7 pages [0KB], 8KB chunk
>=20
> unused devices: <none>
>=20
> nemtemp:~ # mdadm --stop /dev/md1
> mdadm: stopped /dev/md1
>=20
> nemtemp:~ # cat /proc/mdstat
> Personalities : [raid1]
> md2 : active raid1 sda7[0] sdb7[1]
>       221929772 blocks super 1.0 [2/2] [UU]
>       bitmap: 0/424 pages [0KB], 256KB chunk
>=20
> md0 : active raid1 sda1[0] sdb1[1]
>       104376 blocks super 1.0 [2/2] [UU]
>       bitmap: 0/7 pages [0KB], 8KB chunk
>=20
> unused devices: <none>
>=20
> nemtemp:~ # mdadm --verbose --assemble --force /dev/md1 /dev/sd[ab]5
> mdadm: looking for devices for /dev/md1
> mdadm: /dev/sda5 is identified as a member of /dev/md1, slot 0.
> mdadm: /dev/sdb5 is identified as a member of /dev/md1, slot 1.
> mdadm: added /dev/sdb5 to /dev/md1 as 1
> mdadm: added /dev/sda5 to /dev/md1 as 0
> mdadm: failed to RUN_ARRAY /dev/md1: Input/output error
>=20
>   The log from the start attempt:
>=20
> Dec  9 00:16:11 Rescue kernel: md: md1 stopped.
> Dec  9 00:16:11 Rescue kernel: md: bind<sdb5>
> Dec  9 00:16:11 Rescue kernel: md: bind<sda5>
> Dec  9 00:16:11 Rescue kernel: md: md1: raid array is not clean -- starti=
ng
> background reconstruction
> Dec  9 00:16:11 Rescue kernel: raid1: raid set md1 active with 2 out of 2=
 mirrors
> Dec  9 00:16:11 Rescue kernel: md1: bitmap file is out of date (148 < 149=
) --
> forcing full recovery
> Dec  9 00:16:11 Rescue kernel: md1: bitmap file is out of date, doing ful=
l recovery
> Dec  9 00:16:12 Rescue kernel: md1: bitmap initialisation failed: -5
> Dec  9 00:16:12 Rescue kernel: md1: failed to create bitmap (-5)
> Dec  9 00:16:12 Rescue kernel: md: pers->run() failed ...
>=20
> nemtemp:~ # cat /proc/mdstat
> Personalities : [raid1]
> md2 : active raid1 sda7[0] sdb7[1]
>       221929772 blocks super 1.0 [2/2] [UU]
>       bitmap: 0/424 pages [0KB], 256KB chunk
>=20
> md1 : inactive sda5[0] sdb5[1]
>       41945504 blocks super 1.0
>=20
> md0 : active raid1 sda1[0] sdb1[1]
>       104376 blocks super 1.0 [2/2] [UU]
>       bitmap: 0/7 pages [0KB], 8KB chunk
>=20
> unused devices: <none>
>=20
>   I'm not sure how to proceed safely from here. Is there anything else I =
should
> try before attempting to --create the array again? If we do create the ar=
ray
> with 1 drive and "missing", should I then use --add or --re-add to add th=
e other
> drive? Also, since /dev/sda5 shows Events: 148 and /dev/sdb5 shows Events=
: 149,
> should I choose /dev/sdb5 as the one to preserve and let "missing" take t=
he
> place of /dev/sda5? If so, then does the following create statement look =
correct:
>=20
> mdadm --create --verbose --level=3D1 --metadata=3D1.0 --raid-devices=3D2 \
> /dev/md1 /dev/sdb5 missing
>=20
>   Should I also use --force?
>=20
>   If attempting to assemble with "missing" and the create command gives p=
roblems
> due to the unused device still having the same minor-number, is it better=
 to
> --zero-superblock the on the device not included as "missing" or is it be=
tter to
> just unplug it and preserve the superblock data in case it is needed?
>=20
>   Sorry for all the questions, but I just want to make sure I don't do so=
mething
> to compromise the data. With the information for both drives looking good=
 with
> --examine, the (Update Time : Tue Nov 19 15:28:38 2013) being identical, =
and the
> Events being off by only 1, I can't see a reason the drives should not ju=
st
> assemble and run as it is. What say the experts?
>=20
>   Here is the --detail and --examine information for the drives for compl=
eteness:
>=20
> nemtemp:~ # mdadm --detail /dev/md1
> /dev/md1:
>         Version : 01.00.03
>   Creation Time : Thu Aug 21 06:43:22 2008
>      Raid Level : raid1
>   Used Dev Size : 20972752 (20.00 GiB 21.48 GB)
>    Raid Devices : 2
>   Total Devices : 2
> Preferred Minor : 1
>     Persistence : Superblock is persistent
>=20
>     Update Time : Tue Nov 19 15:28:38 2013
>           State : active, Not Started
>  Active Devices : 2
> Working Devices : 2
>  Failed Devices : 0
>   Spare Devices : 0
>=20
>            Name : 1
>            UUID : e45cfbeb:77c2b93b:43d3d214:390d0f25
>          Events : 148
>=20
>     Number   Major   Minor   RaidDevice State
>        0       8        5        0      active sync   /dev/sda5
>        1       8       21        1      active sync   /dev/sdb5
>=20
> nemtemp:/ # mdadm -E /dev/sda5
> /dev/sda5:
>           Magic : a92b4efc
>         Version : 1.0
>     Feature Map : 0x1
>      Array UUID : e45cfbeb:77c2b93b:43d3d214:390d0f25
>            Name : 1
>   Creation Time : Thu Aug 21 06:43:22 2008
>      Raid Level : raid1
>    Raid Devices : 2
>=20
>  Avail Dev Size : 41945504 (20.00 GiB 21.48 GB)
>      Array Size : 41945504 (20.00 GiB 21.48 GB)
>    Super Offset : 41945632 sectors
>           State : clean
>     Device UUID : e0c1c580:db4d853e:6fac1c8f:fb5399d7
>=20
> Internal Bitmap : -81 sectors from superblock
>     Update Time : Tue Nov 19 15:28:38 2013
>        Checksum : d37d1086 - correct
>          Events : 148
>=20
>=20
>     Array Slot : 0 (0, 1)
>    Array State : Uu
>=20
> nemtemp:/ # mdadm -E /dev/sdb5
> /dev/sdb5:
>           Magic : a92b4efc
>         Version : 1.0
>     Feature Map : 0x1
>      Array UUID : e45cfbeb:77c2b93b:43d3d214:390d0f25
>            Name : 1
>   Creation Time : Thu Aug 21 06:43:22 2008
>      Raid Level : raid1
>    Raid Devices : 2
>=20
>  Avail Dev Size : 41945504 (20.00 GiB 21.48 GB)
>      Array Size : 41945504 (20.00 GiB 21.48 GB)
>    Super Offset : 41945632 sectors
>           State : active
>     Device UUID : 6edfa3f8:c8c4316d:66c19315:5eda0911
>=20
> Internal Bitmap : -81 sectors from superblock
>     Update Time : Tue Nov 19 15:28:38 2013
>        Checksum : 39ef40a5 - correct
>          Events : 149
>=20
>=20
>     Array Slot : 1 (0, 1)
>    Array State : uU
>=20
>=20
>=20

What version of mdadm do you have?  It looks like it should be cleverer than
it is.

What if you add "--update=3Dno-bitmap" to the --assemble line?
As the bitmap seems to be causing problem, ignoring it might help.

NeilBrown


--Sig_/GhE/AnZHzQAB0+4i/YVr+XC
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBUqUWODnsnt1WYoG5AQLGRBAAqe4mq8n9YmniIVWDO4SPfReINc4tguYv
qz/ORcIrDX8YVzXam0fSs2CQuA19AlswGvs/plxSPNoCq90mWG4PAN8QKmTL4Dnq
ebtZzirXGzd6nQRXOjfHRdkPDGatRg7GBgxkOq9kurvOQ2fUJGAYrzYLheBbCtAF
hCmPTadk/12lNA3SPdGgWllwPSZcsOFp/e9240OxdvnnW/Oti3suMQvNQu4UwPCT
Q6CvLaI4ogZ5wLGoLpZQqDLess5KIeWivvtE4ZErjI+RaeYyaVzwQN/xnCFOu/LC
oUhaqf/vVgTbD0Sz9nZ3HArex1vyq/aqrkt7GAKa7JGTh66siPra0CFOlEooC+U0
vzdgS0Cdg3m2v2WfDaXoQm0wxToEWt4tJexbn2rG9s0OJXGtQZjH2oY5GxJF1Ti3
V0cZluDZY7KZepkihHiZGh4++eqx38FdxzjdAgS5SWsSiey5aAJE8hLq7UmrVjq3
fNKfWx0ec7ZkME3kJ3QeCK9EFYELfTH/htQTEhn23VsAoIqc4oakIa3kQO03geER
h0e8BBCVM0XqC237YYCjRg8FGOLcSijCDfACgmHwro1id1zhws/owAeh4F7+AMjG
JcfVHr3YCzWWTQyasYLY/2muSVgFPmy4bqHDgUD2+wfW+UVidaq8f3JJFMSGkKum
n7k3lDJhfIc=
=zqBd
-----END PGP SIGNATURE-----

--Sig_/GhE/AnZHzQAB0+4i/YVr+XC--
