From: NeilBrown <neilb@suse.de>
Subject: Re: Mdadm, udev and fakeraid?
Date: Mon, 18 Apr 2011 10:38:52 +1000
Message-ID: <20110418103852.2ead1a69@notabene.brown>
References: <BANLkTinp3376PV3sJWARXtFnRfoMsg44wA@mail.gmail.com>
	<20110405162008.5f2c48fe@notabene.brown>
	<BANLkTik+xU6K7B9Xomj6+Q-S7_n18+aQqA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTik+xU6K7B9Xomj6+Q-S7_n18+aQqA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Seblu <seblu@seblu.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 15 Apr 2011 16:15:50 +0200 Seblu <seblu@seblu.net> wrote:

> On Tue, Apr 5, 2011 at 8:20 AM, NeilBrown <neilb@suse.de> wrote:
> > On Sun, 3 Apr 2011 18:03:50 +0200 Seblu <seblu@seblu.net> wrote:
> >
> >> Hello,
> >>
> >> In the following commit, udev rules load isw_raid (fakeraid). From=
 my
> >> test, this doesnt work. I have to call dmraid to have something
> >> working.
> >> http://neil.brown.name/git?p=3Dmdadm;a=3Dcommit;h=3D475a01b8bce857=
5dd1b2ab6495e65e854702ac0e
> >>
> >> isw_raid is only fakeraid devices? mdadm is able to mount fakeraid=
 partition?
> >>
> >
> > I'm sorry but I cannot parse those questions successfully so I'm no=
t sure
> > what you are asking.
>=20
> Hello Neil,
>=20
> in my previous mail, i used word fakeraid about raid created with
> dmraid and i used softraid about raid created with mdadm. it was not
> clear.
>=20
> So my question was about compatibily. Raids created by dmraid can be
> assembled with mdadm and vice versa?
>=20
> > Both dmraid and mdadm can manage some 'fakeraid' arrays. =A0dmraid =
supports a
> > wider variety. =A0mdadm supports raid1 and raid5 more completely th=
an dmraid
> > does.
> mdadm -> create soft raid for linux  (now there is new format: ddf an=
d imsm) ?
> dmraid -> create soft raid from industry raid card format  ?

No, it isn't that simple.

dmraid uses the 'dm' kernel module.  mdadm uses the 'md' kernel module.

As such dmraid doesn't support RAID5 (yet) and doesn't support RAID1 ve=
ry
well.
mdadm supports both of these well, but doesn't support the same range o=
f
"industry raid card formats".

There is a growing amount of overlap.

>=20
> > Both should support isw to some degree.
> > Intel are currently working with mdadm to make it provide full supp=
ort for
> > "IMSM" (Intel Matrix Storage Manager). =A0I don't know the exact re=
lationship
> > between 'isw' and 'IMSM' - maybe they are different names for the s=
ame thing.
> ok
>=20
> > If mdadm doesn't work for your isw arrays, and you want it to, then=
 I suggest
> > you report details about what is, or is not, happening.
> My purpose is to improve archlinux startup detection of fakeraids
> (mdadm + dmraid).
>=20
> With mdadm everything works correctly without call to "mdadm -As"
> With dmraid, no raid is created by udev rules, so we need to run
> "dmraid -i -ay" at startup.
>=20
> To test this kind of raid, i created a dmraid array in a vm. This
> created me a /dev/mapper/isw_bfbjdbadhb_testF device.
> call blkid on a disk member of this raid tell me this:
> /dev/sde: TYPE=3D"isw_raid_member"
> and on "mdadm" created raid:
> /dev/sdd: UUID=3D"a974b525-993a-1481-f860-6471f3f120e1"
> UUID_SUB=3D"eb22aee2-b2ee-e56d-1008-44d52c63564d" LABEL=3D"archipel:0=
"
> TYPE=3D"linux_raid_member"
>=20
> This misled me because mdadm udev rules uses the output of blkid to
> mount raids which have type "isw_raid_member".
> What disturbs me is that mdadm cannot mount raid created by dmraid
> with type isw_raid_member.
>=20
> About outputs:
> mdadm -I --verbose /dev/sde
> mdadm: no RAID superblock on /dev/sde.

As has been mentioned elsewhere, mdadm only recognised IMSM arrays on
machines with IMSM hardware.  I'm not entirely happy about this and may=
 well
change it.


>=20
> # mdadm --examine /dev/sde
> /dev/sde:
>           Magic : Intel Raid ISM Cfg Sig.
>         Version : 1.1.00
>     Orig Family : 5a8ed623
>          Family : 5a8ed623
>      Generation : 00000000
>            UUID : ae2e9cd8:7fa43248:47c694a1:24990cbc
>        Checksum : c23b6c88 correct
>     MPB Sectors : 1
>           Disks : 2
>    RAID Devices : 1
>=20
>   Disk00 Serial : 66faec8-9f5b237d
>           State : active
>              Id : 00040000
>     Usable Size : 1019486 (497.88 MiB 521.98 MB)
>=20
> [testF]:
>            UUID : 6640a4cc:5faa1ce3:c1bff2b3:1093ca7d
>      RAID Level : 1
>         Members : 2
>           Slots : [UU]
>     Failed disk : none
>       This Slot : 0
>      Array Size : 1014446 (495.42 MiB 519.40 MB)
>    Per Dev Size : 1014792 (495.59 MiB 519.57 MB)
>   Sector Offset : 0
>     Num Stripes : 3963
>      Chunk Size : 64 KiB
>        Reserved : 0
>   Migrate State : idle
>       Map State : normal
>     Dirty State : clean
>=20
>   Disk01 Serial : 0b540c6-4e527908
>           State : active
>              Id : 00050000
>     Usable Size : 1019486 (497.88 MiB 521.98 MB)
>=20
>=20
> Do not you think that dmraid should also ship an udev rules file to
> mount the raid which can handle?

I have no opinion about what dmraid should do.  I have enough trouble w=
orking
out what mdadm should do :-)

NeilBrown


>=20
> Regards,
>=20

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
