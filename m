From: Stephane Bunel <stephane.bunel@forumdesimages.fr>
Subject: Re: mdadm --detail showing annoying device
Date: Thu, 22 Oct 2009 13:22:52 +0200
Message-ID: <4AE0408C.3090500@forumdesimages.fr>
References: <alpine.DEB.2.00.0910171825270.16781@p34.internal.lan>	<alpine.DEB.2.00.0910181607040.27363@p34.internal.lan>	<20091019030456.GS9464@discord.disaster>	<alpine.DEB.2.00.0910190431180.23395@p34.internal.lan>	<20091020003358.GW9464@discord.disaster>	<alpine.DEB.2.00.0910200431290.21878@p34.internal.lan>	<alpine.DEB.2.00.0910210618210.10288@p34.internal.lan>	<4ADF17EC.6090606@forumdesimages.fr> <19167.33065.766493.889406@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <19167.33065.766493.889406@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown a =E9crit :
> On Wednesday October 21, stephane.bunel@forumdesimages.fr wrote:
>> Hi,
>>
>> I'm a newbie in the mdadm world. I defined some udev rules to make d=
isk=20
>> staticly named according to the bus/host/target. I.e. /dev/sda becom=
e=20
>> /dev/raid_disk0. So nothing very special with that, it's just a conv=
enient way=20
>> to assign disk name to it's physical location.
>>
>> #ls -la /dev/raid*
>> brw-rw---- 1 root disk 8,  0 2009-10-16 18:12 /dev/raid_disk0
>> brw-rw---- 1 root disk 8, 16 2009-10-16 18:12 /dev/raid_disk1
>>
>> A RAID1 (/dev/md0) is assembled over this two disk.
>> When looking for detailed information, mdadm show annoying device na=
me in=20
>> place of /dev/raid_disk*:
>>
> ....
>>      Number   Major   Minor   RaidDevice State
>>         0       8        0        0      active sync   /dev/char/21:=
0
>>         1       8       16        1      active sync   /dev/char/21:=
1
>=20
> What is a block device doing in /dev/char ???  There should only be
> character devices in there.
>=20
> If these are actually block device, then I think there is something
> wrong with your udev rules.

   I think my udev rules are not in cause because they just change /dev=
/sd* to=20
/dev/raid_disk*. For udev /dev/char/21:0 seems correspond to the generi=
c scsi=20
device driver (sg) wich is binded to scsi devices.

> If these are char devices, then mdadm is doing the wrong thing, but I
> cannot see that from the code.

   mdadm by choosing the shorter name without differentiate path (/dev/=
=2E../ )=20
and name (sda) choose /dev/char/21:0 just because it is shorter than=20
/dev/raid_disk0.

> Your proposal of choosing the highest rather than the shortest name
> has some merit, but I your current situation doesn't seem to justify
> it, and I particularly like the simplicity of the current heuristic.

  My proposal doesn't choose the highest name but does a selection base=
d on=20
the shortest path to the device name. I.e. my proposal choose:

/dev/raid_disk0 (1 directory level) over /dev/char/21:0 (2 directory le=
vel)
/dev/raid_disk0 (1 directory level) over /dev/block/8:0 (2 directory le=
vel)
/dev/sda1 (1 directory level) over /dev/disk/by-label/BOOT (3 directory=
 level)

   So in fact, my proposal doesn't change current situation but "adjust=
" the=20
heuristic to avoid seeing an annoying device name (char device) as a me=
mber of=20
raid just because it's fullname is shorter than a "semantically better"=
 name.

   Add a printf in map_dev() show that my proposal seems help the heuri=
stic to=20
be more robust in case of "advanced" device naming, without changing cu=
rrent=20
things.


#./mdadm --detail /dev/md0
(/dev/char/21:0)
(/dev/block/8:0)
(/dev/disk/by-id/ata-Hitachi_HDP725050GLA360_GEA534RJ37D3RA)
(/dev/disk/by-id/scsi-SATA_Hitachi_HDP7250_GEA534RJ37D3RA)
(/dev/raid_disk0)
(/dev/char/21:1)
(/dev/block/8:16)
(/dev/raid_disk1)
(/dev/disk/by-id/ata-Hitachi_HDP725050GLA360_GEA534RJ36T9VA)
(/dev/disk/by-id/scsi-SATA_Hitachi_HDP7250_GEA534RJ36T9VA)
/dev/md0:
         Version : 0.90
   Creation Time : Tue Oct 13 12:53:54 2009
      Raid Level : raid1
      Array Size : 488386496 (465.76 GiB 500.11 GB)
   Used Dev Size : 488386496 (465.76 GiB 500.11 GB)
    Raid Devices : 2
   Total Devices : 2
Preferred Minor : 0
     Persistence : Superblock is persistent

     Update Time : Thu Oct 22 12:42:44 2009
           State : clean
  Active Devices : 2
Working Devices : 2
  Failed Devices : 0
   Spare Devices : 0

            UUID : 3fea95a0:e1b8a341:3b119117:e416f62b
          Events : 0.1526

     Number   Major   Minor   RaidDevice State
        0       8        0        0      active sync(/dev/char/21:0)
(/dev/block/8:0)
(/dev/disk/by-id/ata-Hitachi_HDP725050GLA360_GEA534RJ37D3RA)
(/dev/disk/by-id/scsi-SATA_Hitachi_HDP7250_GEA534RJ37D3RA)
(/dev/raid_disk0)
    /dev/raid_disk0
        1       8       16        1      active sync(/dev/char/21:1)
(/dev/block/8:16)
(/dev/raid_disk1)
(/dev/disk/by-id/ata-Hitachi_HDP725050GLA360_GEA534RJ36T9VA)
(/dev/disk/by-id/scsi-SATA_Hitachi_HDP7250_GEA534RJ36T9VA)
    /dev/raid_disk1



Thanks,
St=E9phane Bunel.


--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
