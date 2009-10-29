From: Neil Brown <neilb@suse.de>
Subject: Re: mdadm --detail showing annoying device
Date: Thu, 29 Oct 2009 14:44:02 +1100
Message-ID: <19177.3970.674526.401872@notabene.brown>
References: <alpine.DEB.2.00.0910171825270.16781@p34.internal.lan>
	<alpine.DEB.2.00.0910181607040.27363@p34.internal.lan>
	<20091019030456.GS9464@discord.disaster>
	<alpine.DEB.2.00.0910190431180.23395@p34.internal.lan>
	<20091020003358.GW9464@discord.disaster>
	<alpine.DEB.2.00.0910200431290.21878@p34.internal.lan>
	<alpine.DEB.2.00.0910210618210.10288@p34.internal.lan>
	<4ADF17EC.6090606@forumdesimages.fr>
	<19167.33065.766493.889406@notabene.brown>
	<4AE0408C.3090500@forumdesimages.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Stephane Bunel on Thursday October 22
Sender: linux-raid-owner@vger.kernel.org
To: Stephane Bunel <stephane.bunel@forumdesimages.fr>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday October 22, stephane.bunel@forumdesimages.fr wrote:
> Neil Brown a =E9crit :
> > On Wednesday October 21, stephane.bunel@forumdesimages.fr wrote:
> >> Hi,
> >>
> >> I'm a newbie in the mdadm world. I defined some udev rules to make=
 disk=20
> >> staticly named according to the bus/host/target. I.e. /dev/sda bec=
ome=20
> >> /dev/raid_disk0. So nothing very special with that, it's just a co=
nvenient way=20
> >> to assign disk name to it's physical location.
> >>
> >> #ls -la /dev/raid*
> >> brw-rw---- 1 root disk 8,  0 2009-10-16 18:12 /dev/raid_disk0
> >> brw-rw---- 1 root disk 8, 16 2009-10-16 18:12 /dev/raid_disk1
> >>
> >> A RAID1 (/dev/md0) is assembled over this two disk.
> >> When looking for detailed information, mdadm show annoying device =
name in=20
> >> place of /dev/raid_disk*:
> >>
> > ....
> >>      Number   Major   Minor   RaidDevice State
> >>         0       8        0        0      active sync   /dev/char/2=
1:0
> >>         1       8       16        1      active sync   /dev/char/2=
1:1
> >=20
> > What is a block device doing in /dev/char ???  There should only be
> > character devices in there.
> >=20
> > If these are actually block device, then I think there is something
> > wrong with your udev rules.
>=20
>    I think my udev rules are not in cause because they just change /d=
ev/sd* to=20
> /dev/raid_disk*. For udev /dev/char/21:0 seems correspond to the gene=
ric scsi=20
> device driver (sg) wich is binded to scsi devices.

That doesn't answer the question of why a block device is appearing in
/dev/char/.
My guess (which is quite possibly wrong, but it is the best I can do)
is that whatever change to udev.rules that you made to get /dev/sdXX
to be renamed to /dev/raid_diskXX, also renamed the scsi-generic
devices to be /dev/raid_diskXX.
I think that would have the effect that you are seeing.


>=20
> > If these are char devices, then mdadm is doing the wrong thing, but=
 I
> > cannot see that from the code.
>=20
>    mdadm by choosing the shorter name without differentiate path (/de=
v/.../ )=20
> and name (sda) choose /dev/char/21:0 just because it is shorter than=20
> /dev/raid_disk0.
>=20
> > Your proposal of choosing the highest rather than the shortest name
> > has some merit, but I your current situation doesn't seem to justif=
y
> > it, and I particularly like the simplicity of the current heuristic=
=2E
>=20
>   My proposal doesn't choose the highest name but does a selection ba=
sed on=20
> the shortest path to the device name. I.e. my proposal choose:
>=20
> /dev/raid_disk0 (1 directory level) over /dev/char/21:0 (2 directory =
level)
> /dev/raid_disk0 (1 directory level) over /dev/block/8:0 (2 directory =
level)
> /dev/sda1 (1 directory level) over /dev/disk/by-label/BOOT (3 directo=
ry level)

This is what I meant by 'highest'.  highest up in the directory tree -
closest to the root (I guess some people might think that being close
to the root is 'low', not 'high :-)

>=20
>    So in fact, my proposal doesn't change current situation but "adju=
st" the=20
> heuristic to avoid seeing an annoying device name (char device) as a =
member of=20
> raid just because it's fullname is shorter than a "semantically bette=
r" name.

I appreciate that.  I am not against changing the heuristic if I find
a good reason ... particularly if I can find something that actually
measures "semantic goodness"!
But I don't think you have provided a good reason.
/dev/char/21:0 should be a char device, not a block device.  So mdadm
should ignore it.
On your system, /dev/char/21:0 is a block device (or a link to a block
device) so there is clearly some sort of configuration error.

If you still cannot find it, maybe you could show us the change you
made to udev.rules, and an 'ls -l' of '/dev/char'.  That might help
shed some light on your situation.

NeilBrown


>=20
>    Add a printf in map_dev() show that my proposal seems help the heu=
ristic to=20
> be more robust in case of "advanced" device naming, without changing =
current=20
> things.
>=20
>=20
> #./mdadm --detail /dev/md0
> (/dev/char/21:0)
> (/dev/block/8:0)
> (/dev/disk/by-id/ata-Hitachi_HDP725050GLA360_GEA534RJ37D3RA)
> (/dev/disk/by-id/scsi-SATA_Hitachi_HDP7250_GEA534RJ37D3RA)
> (/dev/raid_disk0)
> (/dev/char/21:1)
> (/dev/block/8:16)
> (/dev/raid_disk1)
> (/dev/disk/by-id/ata-Hitachi_HDP725050GLA360_GEA534RJ36T9VA)
> (/dev/disk/by-id/scsi-SATA_Hitachi_HDP7250_GEA534RJ36T9VA)
> /dev/md0:
>          Version : 0.90
>    Creation Time : Tue Oct 13 12:53:54 2009
>       Raid Level : raid1
>       Array Size : 488386496 (465.76 GiB 500.11 GB)
>    Used Dev Size : 488386496 (465.76 GiB 500.11 GB)
>     Raid Devices : 2
>    Total Devices : 2
> Preferred Minor : 0
>      Persistence : Superblock is persistent
>=20
>      Update Time : Thu Oct 22 12:42:44 2009
>            State : clean
>   Active Devices : 2
> Working Devices : 2
>   Failed Devices : 0
>    Spare Devices : 0
>=20
>             UUID : 3fea95a0:e1b8a341:3b119117:e416f62b
>           Events : 0.1526
>=20
>      Number   Major   Minor   RaidDevice State
>         0       8        0        0      active sync(/dev/char/21:0)
> (/dev/block/8:0)
> (/dev/disk/by-id/ata-Hitachi_HDP725050GLA360_GEA534RJ37D3RA)
> (/dev/disk/by-id/scsi-SATA_Hitachi_HDP7250_GEA534RJ37D3RA)
> (/dev/raid_disk0)
>     /dev/raid_disk0
>         1       8       16        1      active sync(/dev/char/21:1)
> (/dev/block/8:16)
> (/dev/raid_disk1)
> (/dev/disk/by-id/ata-Hitachi_HDP725050GLA360_GEA534RJ36T9VA)
> (/dev/disk/by-id/scsi-SATA_Hitachi_HDP7250_GEA534RJ36T9VA)
>     /dev/raid_disk1
>=20
>=20
>=20
> Thanks,
> St=E9phane Bunel.
>=20
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
