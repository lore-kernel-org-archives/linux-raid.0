From: "L.M.J" <linuxmasterjedi@free.fr>
Subject: Re: Corrupted ext4 filesystem after mdadm manipulation error
Date: Fri, 25 Apr 2014 16:43:56 +0200
Message-ID: <20140425164356.368e9026@netstation>
References: <20140424070548.445497dd@netstation>
	<20140424194832.2d0a867f@netstation>
	<CAK_KU4a+Ep7=F=NSbb-hqN6Rvayx4QPWm-M2403OHn5-LVaNZw@mail.gmail.com>
	<20140424203506.5fdee0d3@netstation>
	<CAK_KU4Zh-azXEEzW4f1m=boCZDKevqaSHxW0XoAgRdrCbm2PkA@mail.gmail.com>
	<CAK_KU4aDDaUSGgcGBwCeO+yE0Qa_pUmMdAHMu7pqO7dqEEC71g@mail.gmail.com>
	<20140424215654.0447d300@netstation>
	<CAK_KU4YUejncX9yQk4HM5HE=1-qPPxOibuRauFheo3jaBc8SaQ@mail.gmail.com>
	<20140425071340.1ac35ded@netstation>
	<alpine.DEB.2.02.1404250802070.19744@uplift.swm.pp.se>
	<2ecef7f1-fde7-48c9-87bf-47ff617956b3@email.android.com>
	<CAK_KU4a0FCwG2fjAQYX4jM2xC9SbMc=qp_7T_v4hC5eztDFqOA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAK_KU4a0FCwG2fjAQYX4jM2xC9SbMc=qp_7T_v4hC5eztDFqOA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Scott D'Vileskis <sdvileskis@gmail.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Le Fri, 25 Apr 2014 09:36:12 -0400,
"Scott D'Vileskis" <sdvileskis@gmail.com> a =E9crit :

> As a last ditch effort, try the --create again but with the two
> potentially good disks in the right order:
>=20
> mdadm --create /dev/md0 --level=3D5 --raid-devices=3D3 missing /dev/s=
dc1 /dev/sdd1


root@gateway:~# mdadm --create /dev/md0 --level=3D5 --raid-devices=3D3 =
missing /dev/sdc1 /dev/sdd1
mdadm: /dev/sdc1 appears to be part of a raid array:
    level=3Draid5 devices=3D3 ctime=3DFri Apr 25 16:20:32 2014
mdadm: /dev/sdd1 appears to be part of a raid array:
    level=3Draid5 devices=3D3 ctime=3DFri Apr 25 16:20:32 2014
Continue creating array? y
mdadm: array /dev/md0 started.


root@gateway:~# ls -l /dev/md*
brw-rw---- 1 root disk   9, 0 2014-04-25 16:34 /dev/md0
brw-rw---- 1 root disk 254, 0 2014-04-25 16:19 /dev/md_d0
lrwxrwxrwx 1 root root      7 2014-04-25 16:04 /dev/md_d0p1 -> md/d0p1
lrwxrwxrwx 1 root root      7 2014-04-25 16:04 /dev/md_d0p2 -> md/d0p2
lrwxrwxrwx 1 root root      7 2014-04-25 16:04 /dev/md_d0p3 -> md/d0p3
lrwxrwxrwx 1 root root      7 2014-04-25 16:04 /dev/md_d0p4 -> md/d0p4

/dev/md:
total 0
brw------- 1 root root 254, 0 2014-04-25 16:04 d0
brw------- 1 root root 254, 1 2014-04-25 16:04 d0p1
brw------- 1 root root 254, 2 2014-04-25 16:04 d0p2
brw------- 1 root root 254, 3 2014-04-25 16:04 d0p3
brw------- 1 root root 254, 4 2014-04-25 16:04 d0p4


root@gateway:~# cat /proc/mdstat=20
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [r=
aid4] [raid10]=20
md0 : active raid5 sdd1[2] sdc1[1]
      3907023872 blocks level 5, 64k chunk, algorithm 2 [3/2] [_UU]
     =20
unused devices: <none>


root@gateway:~# pvscan=20
  No matching physical volumes found


root@gateway:~# pvdisplay=20



root@gateway:~# dd if=3D/dev/md0 of=3D/tmp/md0.dd count=3D10 bs=3D1M
10+0 enregistrements lus
10+0 enregistrements =E9crits
10485760 octets (10 MB) copi=E9s, 0,271947 s, 38,6 MB/s


I can see in /tmp/md0.dd a lot of binary stuff, and sometimes, text :

physical_volumes {

pv0 {
id =3D "5DZit9-6o5V-a1vu-1D1q-fnc0-syEj-kVwAnW"
device =3D "/dev/md0"

status =3D ["ALLOCATABLE"]
flags =3D []
dev_size =3D 7814047360
pe_start =3D 384
pe_count =3D 953863
}
}

logical_volumes {

lvdata {
id =3D "JiwAjc-qkvI-58Ru-RO8n-r63Z-ll3E-SJazO7"
status =3D ["READ", "WRITE", "VISIBLE"]
flags =3D []
segment_count =3D 1

segment1 {
start_extent =3D 0
extent_count =3D 115200

type =3D "striped"
stripe_count =3D 1        # linear

stripes =3D [

[...]

lvdata_snapshot_J5 {
id =3D "Mcvgul-Qo2L-1sPB-LvtI-KuME-fiiM-6DXeph"
status =3D ["READ"]
flags =3D []
segment_count =3D 1

segment1 {
start_extent =3D 0
extent_count =3D 25600

type =3D "striped"
stripe_count =3D 1        # linear

stripes =3D [
"pv0", 284160
]
}
}


[...]

lvdata_snapshot_J5 is a snap I've created a few days before my mdadm ch=
aos, so i'm pretty sure some datas are
still on the drives... Am I wrong ?

Thanks




--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
