From: Mark Keisler <grimm26@gmail.com>
Subject: Re: RAID10 failure(s)
Date: Mon, 14 Feb 2011 14:33:03 -0600
Message-ID: <AANLkTinfaYYcq1++_vx0nNMDftiv9Eqg_eDR2Q0QfoS7@mail.gmail.com>
References: <AANLkTimqZqjJuwmC+zX3Uyx_xrWC0i07y5idrnaQXyWF@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTimqZqjJuwmC+zX3Uyx_xrWC0i07y5idrnaQXyWF@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Sorry for the double-post on the original.
I realize that I also left out the fact that I rebooted since drive 0
also reported a fault and mdadm won't start the array at all.  I'm not
sure how to tell which members were the in two RAID0 groups.  I would
think that if I have a RAID0 pair left from the RAID10, I should be
able to recover somehow.  Not sure if that was drive 0 and 2, 1 and 3
or 0 and 1, 2 and 3.

Anyway, the drives do still show the correct array UUID when queried
with mdadm -E, but they disagree about the state of the array:
# mdadm -E /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1 | grep 'Array State'
   Array State : AAAA ('A' =3D=3D active, '.' =3D=3D missing)
   Array State : .AAA ('A' =3D=3D active, '.' =3D=3D missing)
   Array State : ..AA ('A' =3D=3D active, '.' =3D=3D missing)
   Array State : ..AA ('A' =3D=3D active, '.' =3D=3D missing)

sdc still shows a recovery offset, too:

/dev/sdb1:
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
/dev/sdc1:
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
Recovery Offset : 2 sectors
/dev/sdd1:
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
/dev/sde1:
    Data Offset : 2048 sectors
   Super Offset : 8 sectors

I did some searching on the "READ FPDMA QUEUED" error message that my
drive was reporting and have found that there seems to be a
correlation between that and having AHCI (NCQ in particular) enabled.
I've now set my BIOS back to Native IDE (which was the default anyway)
instead of AHCI for the SATA setting.  I'm hoping that was the issue.

Still wondering if there is some magic to be done to get at my data aga=
in :)

--
Mark
Tact is the ability to tell a man he has an open mind when he has a
hole in his head.



On Mon, Feb 14, 2011 at 10:09 AM, Mark Keisler <grimm26@gmail.com> wrot=
e:
>
> Sorry in advance for the long email :)
>
>
> I had a RAID10 array set up using 4 WD 1TB caviar black drives (SATA3=
)
> on 64 bit on a 2.6.36 kernel using mdadm 3.1.4. =A0I noticed last nig=
ht
> that one drive had faulted out of the array. =A0It had a bunch of err=
ors
> like so:
>
> Feb =A08 03:39:48 samsara kernel: [41330.835285] ata3.00: exception
> Emask 0x0 SAct 0x1 SErr 0x0 action 0x0
> Feb =A08 03:39:48 samsara kernel: [41330.835288] ata3.00: irq_stat 0x=
40000008
> Feb =A08 03:39:48 samsara kernel: [41330.835292] ata3.00: failed
> command: READ FPDMA QUEUED
> Feb =A08 03:39:48 samsara kernel: [41330.835297] ata3.00: cmd
> 60/f8:00:f8:9a:45/00:00:04:00:00/40 tag 0 ncq 126976 in
> Feb =A08 03:39:48 samsara kernel: [41330.835297] =A0 =A0 =A0 =A0 =A0r=
es
> 41/40:00:70:9b:45/00:00:04:00:00/40 Emask 0x409 (media error) <F>
> Feb =A08 03:39:48 samsara kernel: [41330.835300] ata3.00: status: { D=
RDY ERR }
> Feb =A08 03:39:48 samsara kernel: [41330.835301] ata3.00: error: { UN=
C }
> Feb =A08 03:39:48 samsara kernel: [41330.839776] ata3.00: configured =
for UDMA/133
> Feb =A08 03:39:48 samsara kernel: [41330.839788] ata3: EH complete
> ....
>
> Feb =A08 03:39:58 samsara kernel: [41340.423236] sd 2:0:0:0: [sdc]
> Unhandled sense code
> Feb =A08 03:39:58 samsara kernel: [41340.423238] sd 2:0:0:0: [sdc]
> Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
> Feb =A08 03:39:58 samsara kernel: [41340.423240] sd 2:0:0:0: [sdc]
> Sense Key : Medium Error [current] [descriptor]
> Feb =A08 03:39:58 samsara kernel: [41340.423243] Descriptor sense dat=
a
> with sense descriptors (in hex):
> Feb =A08 03:39:58 samsara kernel: [41340.423244] =A0 =A0 =A0 =A0 72 0=
3 11 04 00
> 00 00 0c 00 0a 80 00 00 00 00 00
> Feb =A08 03:39:58 samsara kernel: [41340.423249] =A0 =A0 =A0 =A0 04 4=
5 9b 70
> Feb =A08 03:39:58 samsara kernel: [41340.423251] sd 2:0:0:0: [sdc] =A0=
Add.
> Sense: Unrecovered read error - auto reallocate failed
> Feb =A08 03:39:58 samsara kernel: [41340.423254] sd 2:0:0:0: [sdc] CD=
B:
> Read(10): 28 00 04 45 9a f8 00 00 f8 00
> Feb =A08 03:39:58 samsara kernel: [41340.423259] end_request: I/O err=
or,
> dev sdc, sector 71670640
> Feb =A08 03:39:58 samsara kernel: [41340.423262] md/raid10:md0: sdc1:
> rescheduling sector 143332600
> ....
> Feb =A08 03:40:10 samsara kernel: [41351.940796] md/raid10:md0: read
> error corrected (8 sectors at 2168 on sdc1)
> Feb =A08 03:40:10 samsara kernel: [41351.954972] md/raid10:md0: sdb1:
> redirecting sector 143332600 to another mirror
>
> and so on until:
> Feb =A08 03:55:01 samsara kernel: [42243.609414] md/raid10:md0: sdc1:
> Raid device exceeded read_error threshold [cur 21:max 20]
> Feb =A08 03:55:01 samsara kernel: [42243.609417] md/raid10:md0: sdc1:
> Failing raid device
> Feb =A08 03:55:01 samsara kernel: [42243.609419] md/raid10:md0: Disk
> failure on sdc1, disabling device.
> Feb =A08 03:55:01 samsara kernel: [42243.609420] <1>md/raid10:md0:
> Operation continuing on 3 devices.
> Feb =A08 03:55:01 samsara kernel: [42243.609423] md/raid10:md0: sdb1:
> redirecting sector 143163888 to another mirror
> Feb =A08 03:55:01 samsara kernel: [42243.609650] md/raid10:md0: sdb1:
> redirecting sector 143164416 to another mirror
> Feb =A08 03:55:01 samsara kernel: [42243.610095] md/raid10:md0: sdb1:
> redirecting sector 143164664 to another mirror
> Feb =A08 03:55:01 samsara kernel: [42243.633814] RAID10 conf printout=
:
> Feb =A08 03:55:01 samsara kernel: [42243.633817] =A0--- wd:3 rd:4
> Feb =A08 03:55:01 samsara kernel: [42243.633820] =A0disk 0, wo:0, o:1=
, dev:sdb1
> Feb =A08 03:55:01 samsara kernel: [42243.633821] =A0disk 1, wo:1, o:0=
, dev:sdc1
> Feb =A08 03:55:01 samsara kernel: [42243.633823] =A0disk 2, wo:0, o:1=
, dev:sdd1
> Feb =A08 03:55:01 samsara kernel: [42243.633824] =A0disk 3, wo:0, o:1=
, dev:sde1
> Feb =A08 03:55:01 samsara kernel: [42243.645880] RAID10 conf printout=
:
> Feb =A08 03:55:01 samsara kernel: [42243.645883] =A0--- wd:3 rd:4
> Feb =A08 03:55:01 samsara kernel: [42243.645885] =A0disk 0, wo:0, o:1=
, dev:sdb1
> Feb =A08 03:55:01 samsara kernel: [42243.645887] =A0disk 2, wo:0, o:1=
, dev:sdd1
> Feb =A08 03:55:01 samsara kernel: [42243.645888] =A0disk 3, wo:0, o:1=
, dev:sde1
>
>
> This seemed weird as the machine is only a week or two old. =A0I powe=
red
> down to open it up and get the serial number off the drive fro an RMA=
=2E
> =A0I powered back up and mdadm had automatically removed the drive fr=
om
> the RAID. =A0Fine. =A0The RAID had already been running on just 3 dis=
ks
> since the 8th. =A0For some reason, I thought to add the drive back in=
to
> the array to see if it failed out again thinking worst case scenario
> I'm back to a degraded RAID10 again. =A0So I added it back in and did=
 an
> mdadm --detail to check on it after a little while and found this:
> samsara log # mdadm --detail /dev/md0
> /dev/md0:
> =A0 =A0 =A0 Version : 1.2
> =A0Creation Time : Sat Feb =A05 22:00:52 2011
> =A0 =A0Raid Level : raid10
> =A0 =A0Array Size : 1953519104 (1863.02 GiB 2000.40 GB)
> =A0Used Dev Size : 976759552 (931.51 GiB 1000.20 GB)
> =A0Raid Devices : 4
> =A0Total Devices : 4
> =A0 Persistence : Superblock is persistent
>
> =A0 Update Time : Mon Feb 14 00:04:46 2011
> =A0 =A0 =A0 =A0 State : clean, FAILED, recovering
> =A0Active Devices : 2
> Working Devices : 2
> =A0Failed Devices : 2
> =A0Spare Devices : 0
>
> =A0 =A0 =A0 =A0Layout : near=3D2
> =A0 =A0Chunk Size : 256K
>
> =A0Rebuild Status : 99% complete
>
> =A0 =A0 =A0 =A0 =A0Name : samsara:0 =A0(local to host samsara)
> =A0 =A0 =A0 =A0 =A0UUID : 26804ec8:a20a4365:bc7d5b4e:653ade03
> =A0 =A0 =A0 =A0Events : 30348
>
> =A0 Number =A0 Major =A0 Minor =A0 RaidDevice State
> =A0 =A0 =A00 =A0 =A0 =A0 8 =A0 =A0 =A0 17 =A0 =A0 =A0 =A00 =A0 =A0 =A0=
faulty spare rebuilding =A0 /dev/sdb1
> =A0 =A0 =A01 =A0 =A0 =A0 8 =A0 =A0 =A0 33 =A0 =A0 =A0 =A01 =A0 =A0 =A0=
faulty spare rebuilding =A0 /dev/sdc1
> =A0 =A0 =A02 =A0 =A0 =A0 8 =A0 =A0 =A0 49 =A0 =A0 =A0 =A02 =A0 =A0 =A0=
active sync =A0 /dev/sdd1
> =A0 =A0 =A03 =A0 =A0 =A0 8 =A0 =A0 =A0 65 =A0 =A0 =A0 =A03 =A0 =A0 =A0=
active sync =A0 /dev/sde1
> samsara log # exit
>
> It had faulted drive 0 also during the rebuild.
> [ 1177.064359] RAID10 conf printout:
> [ 1177.064362] =A0--- wd:2 rd:4
> [ 1177.064365] =A0disk 0, wo:1, o:0, dev:sdb1
> [ 1177.064367] =A0disk 1, wo:1, o:0, dev:sdc1
> [ 1177.064368] =A0disk 2, wo:0, o:1, dev:sdd1
> [ 1177.064370] =A0disk 3, wo:0, o:1, dev:sde1
> [ 1177.073325] RAID10 conf printout:
> [ 1177.073328] =A0--- wd:2 rd:4
> [ 1177.073330] =A0disk 0, wo:1, o:0, dev:sdb1
> [ 1177.073332] =A0disk 2, wo:0, o:1, dev:sdd1
> [ 1177.073333] =A0disk 3, wo:0, o:1, dev:sde1
> [ 1177.073340] RAID10 conf printout:
> [ 1177.073341] =A0--- wd:2 rd:4
> [ 1177.073342] =A0disk 0, wo:1, o:0, dev:sdb1
> [ 1177.073343] =A0disk 2, wo:0, o:1, dev:sdd1
> [ 1177.073344] =A0disk 3, wo:0, o:1, dev:sde1
> [ 1177.083323] RAID10 conf printout:
> [ 1177.083326] =A0--- wd:2 rd:4
> [ 1177.083329] =A0disk 2, wo:0, o:1, dev:sdd1
> [ 1177.083330] =A0disk 3, wo:0, o:1, dev:sde1
>
>
> So the RAID ended up being marked "clean, FAILED." =A0Gee, glad it is
> clean at least ;). =A0I'm wondering wtf went wrong and if it actually
> makes sense that I had a double disk failure like that. =A0I can't ev=
en
> force it to assemble the raid anymore:
> =A0# mdadm --assemble --verbose --force /dev/md0
> mdadm: looking for devices for /dev/md0
> mdadm: cannot open device /dev/sde1: Device or resource busy
> mdadm: /dev/sde1 has wrong uuid.
> mdadm: cannot open device /dev/sdd1: Device or resource busy
> mdadm: /dev/sdd1 has wrong uuid.
> mdadm: cannot open device /dev/sdc1: Device or resource busy
> mdadm: /dev/sdc1 has wrong uuid.
> mdadm: cannot open device /dev/sdb1: Device or resource busy
> mdadm: /dev/sdb1 has wrong uuid.
>
> Am I totally SOL? =A0Thanks for any suggestions or things to try.
>
> --
> Mark
> Tact is the ability to tell a man he has an open mind when he has a
> hole in his head.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
