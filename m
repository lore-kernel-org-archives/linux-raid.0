From: Eric Mei <meijia@gmail.com>
Subject: [PATCH] [md] raid5: check faulty flag for array status during recovery.
Date: Tue, 6 Jan 2015 15:24:24 -0700
Message-ID: <94BC57C5-6223-435B-96FD-7DA2F6B4E561@gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 8.1 \(1993\))
Content-Type: multipart/mixed; boundary="Apple-Mail=_F689EEE3-6439-4151-8650-5AF4883CDF5C"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, eric.mei@seagate.com
List-Id: linux-raid.ids


--Apple-Mail=_F689EEE3-6439-4151-8650-5AF4883CDF5C
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8

Hi Neil,

In a MDRAID derived work we found and fixed a data corruption bug. We =
think this also affect vanilla MDRAID, but we didn=E2=80=99t directly =
prove that by constructing a test to show the corruption. Following is =
the theoretical analysis, please kindly review and see if I missed =
something.

To rebuild a stripe, MD checks whether array will be optimal after =
rebuild complete, if that=E2=80=99s true, we=E2=80=99ll mark the WIB bit =
to be cleared, the purpose is to enable =E2=80=9Cincremental rebuild=E2=80=
=9D. The code section is like this:

	/* Need to check if array will still be degraded after =
recovery/resync
	 * We don't need to check the 'failed' flag as when that gets =
set,
	 * recovery aborts.
	 */
	for (i =3D 0; i < conf->raid_disks; i++)
		if (conf->disks[i].rdev =3D=3D NULL)
			still_degraded =3D 1;

The problem is that only checking rdev =3D=3D NULL might not be enough. =
Suppose both 2 drives D0 and D1 failed and marked as Faulty; We =
immediately removed D0 from array, but because some lingering IO on D1, =
it remains in array with Faulty flags on. A new drive pulled in, rebuild =
against D0 starts. Now because no rdev is NULL, MD thinks array will be =
optimal. If some writes happened before rebuild reaches the region, =
their dirty bits in WIB will be cleared. When later add D1 back into =
array, we=E2=80=99ll skip rebuilding those stripes, thus data =
corruption.

The attached patch (against 3.18.0-rc6) is supposed to fix this issue.

Thanks
Eric


--Apple-Mail=_F689EEE3-6439-4151-8650-5AF4883CDF5C
Content-Disposition: attachment;
	filename=0001-md-raid5-check-faulty-flag-for-array-status-during-r.patch
Content-Type: application/octet-stream;
	name="0001-md-raid5-check-faulty-flag-for-array-status-during-r.patch"
Content-Transfer-Encoding: quoted-printable

=46rom=206e569429d9deac31df3c7023a59c93ac862b10e5=20Mon=20Sep=2017=20=
00:00:00=202001=0AFrom:=20Eric=20Mei=20<eric.mei@seagate.com>=0ADate:=20=
Tue,=206=20Jan=202015=2009:35:02=20-0800=0ASubject:=20[PATCH]=20[md]=20=
raid5:=20check=20faulty=20flag=20for=20array=20status=20during=20=
recovery.=0A=0AWhen=20we=20have=20more=20than=201=20drive=20failure,=20=
it's=20possible=20we=20start=0Arebuild=20one=20drive=20while=20leaving=20=
another=20faulty=20drive=20in=20array.=0ATo=20determine=20whether=20=
array=20will=20be=20optimal=20after=20building,=20current=0Acode=20only=20=
check=20whether=20a=20drive=20is=20missing,=20which=20could=20=
potentially=0Alead=20to=20data=20corruption.=20This=20patch=20is=20to=20=
add=20checking=20Faulty=20flag.=0A---=0A=20drivers/md/raid5.c=20|=20=20=20=
=207=20++++---=0A=201=20files=20changed,=204=20insertions(+),=203=20=
deletions(-)=0A=0Adiff=20--git=20a/drivers/md/raid5.c=20=
b/drivers/md/raid5.c=0Aindex=209c66e59..a01a25e=20100644=0A---=20=
a/drivers/md/raid5.c=0A+++=20b/drivers/md/raid5.c=0A@@=20-5054,11=20=
+5054,12=20@@=20static=20inline=20sector_t=20sync_request(struct=20mddev=20=
*mddev,=20sector_t=20sector_nr,=20int=0A=20=09=09=
schedule_timeout_uninterruptible(1);=0A=20=09}=0A=20=09/*=20Need=20to=20=
check=20if=20array=20will=20still=20be=20degraded=20after=20=
recovery/resync=0A-=09=20*=20We=20don't=20need=20to=20check=20the=20=
'failed'=20flag=20as=20when=20that=20gets=20set,=0A-=09=20*=20recovery=20=
aborts.=0A+=09=20*=20Note=20in=20case=20of=20>=201=20drive=20failures=20=
it's=20possible=20we're=20rebuilding=0A+=09=20*=20one=20drive=20while=20=
leaving=20another=20faulty=20drive=20in=20array.=0A=20=09=20*/=0A=20=09=
for=20(i=20=3D=200;=20i=20<=20conf->raid_disks;=20i++)=0A-=09=09if=20=
(conf->disks[i].rdev=20=3D=3D=20NULL)=0A+=09=09if=20(conf->disks[i].rdev=20=
=3D=3D=20NULL=20||=0A+=09=09=20=20=20=20test_bit(Faulty,=20=
&conf->disks[i].rdev->flags))=0A=20=09=09=09still_degraded=20=3D=201;=0A=20=
=0A=20=09bitmap_start_sync(mddev->bitmap,=20sector_nr,=20&sync_blocks,=20=
still_degraded);=0A--=20=0A1.7.1=0A=0A=

--Apple-Mail=_F689EEE3-6439-4151-8650-5AF4883CDF5C--
