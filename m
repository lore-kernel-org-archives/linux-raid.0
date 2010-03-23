From: Michael Evans <mjevans1983@gmail.com>
Subject: Re: Failed --grow. Recovery possible?
Date: Tue, 23 Mar 2010 14:07:30 -0700
Message-ID: <4877c76c1003231407s4d52c98dw528919cff7cc6c8c@mail.gmail.com>
References: <959332b61003181836jea0d170jf6163e4ab81376f8@mail.gmail.com>
	 <959332b61003181852s538d9c74sa7dad6d3150c9e71@mail.gmail.com>
	 <20100319150257.0acd2ad8@notabene.brown>
	 <959332b61003231253m587b3d6haf2f683a1c6f4b8a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <959332b61003231253m587b3d6haf2f683a1c6f4b8a@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Stephan Stachurski <ses1984@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Mar 23, 2010 at 12:53 PM, Stephan Stachurski <ses1984@gmail.com=
> wrote:
> Sorry, it looks like I sent two replies directly to NeilBrown instead
> of the mailing list. Here they are:
>
> First reply:
>
> Before I checked this email, I upgraded to the newest version of mdad=
m
> on advice I got from #linux on freenode. The array is no longer
> segfaults when it's assembled. Instead it picks up exactly where it
> left off trying to grow the array but not actually progressing. In th=
e
> new version of mdadm, however, after a short while the drives on the
> mv_sas controller are dropped and mdstat reports that a resync is
> pending.
>
> This looks like an improvement to me. I am going to try to test out
> the controller and drives to see if I can find out what's going on.
>
> ----------------------
>
> Second reply:
>
> I hope I haven't screwed up my disks beyond saving. I was using this
> earlier question on the mailing list as a reference
> http://www.mail-archive.com/linux-raid@vger.kernel.org/msg08907.html =
=2E
> If I could re-assemble the original array, I would feel a lot more
> comfortable proceeding. In the above referenced thread, Greg Nicholso=
n
> mentions that order matters when it comes to assembling arrays, so I
> wrote a perl script (full of terrible hacks) that took the list of th=
e
> 6 original devices and iterated over the permutations of the order of
> those devices, assembled the array with --assume-clean and attempt to
> mount the file system.
>
> This failed for all 720 permutations. It was probably a stupid idea, =
anyway...
>
> I also tried plugging in a known working disk into the mv_sas
> controller that may have had an issue and it looked like everything
> was working OK.
>
> Now I'm really not sure what to do. I'm completely lost.
>
> Thanks again for your help.
>
> On Fri, Mar 19, 2010 at 12:02 AM, Neil Brown <neilb@suse.de> wrote:
>> On Thu, 18 Mar 2010 21:52:54 -0400
>> Stephan Stachurski <ses1984@gmail.com> wrote:
>>
>>> I have had a RAID5 up for quite a while with 6 disks. I recently ad=
ded
>>> 4 and attempted to grow the array to span all 10 devices.
>>>
>>> For an hour after starting the grow command, the speed of the
>>> operation was 0K/s the entire time. I thought something must be wro=
ng,
>>> and the best course of action would be to reboot and start over fro=
m a
>>> clean boot. I'm not a linux expert so I thought that if I rebooted
>>> everything would try to exit gracefully.
>>>
>>> After one hour, the system still had not finished shutting down. I
>>> then did alt-sysreq RSEISUB waiting over one minute between each
>>> command. I've included the syslog of what happened up until the nex=
t
>>> start up, but put it last because it's by far the longest.
>>
>> I think you will be able to get your data back. =A0It won't be trivi=
al, but it
>> should be possible.
>>
>> I looks like the driver for the mv_sas controller has issues. =A0Whe=
n md/raid5
>> started writing data on to them to reshape the array something went =
wrong and
>> the writes didn't complete, so nothing else happened.
>>
>> I don't know why mdadm is getting a segmentation fault. =A0Possibly =
this is
>> fixed in a newer version of mdadm. =A0However it is possibly good th=
at it
>> didn't manage to restart the array fully as it would probably has ju=
st failed
>> again and might have made more of a mess.
>>
>> To get you data back we need to understand exactly what happened.
>> What should happen when you run "mdadm --grow ... " is that it sets
>> up for a reshape but doesn't let it progress.
>> Then it prints:
>>
>> mdadm: Need to backup 1152K of critical section..
>>
>> It then copies the first 1152K (in the case of 6->10 with 256K chunk=
)
>> from the start of the array to near the end of each of the 'spares'.
>> Then it allows the reshape to proceed.
>> Once the reshape has progressed past that 1152K it removes the
>> copy that it made (erases some metadata for it) and prints
>>
>> mdadm: ... critical section passed.
>>
>>
>> I presume that it didn't successfully pass the critical section, els=
e
>> the Reshape Position would be greater than 0.
>>
>> It is possible that the reshape didn't start at all and your data is=
 exactly
>> where you left it, but we cannot be sure without looking...
>>
>> What I suggest you do is:
>> 1/ find the backup of the first 1152K
>> 2/ re-create the array as the original 6-drive raid5
>> 3/ Check if the backup needs to be restored and possibly restore it
>> 4/ Don't use the new drives until you are really sure they will work=
=2E
>>
>> 1 is the hardest. =A0I have a vague plan of giving mdadm the ability=
 to do this
>> but I haven't yet. =A0I could possibly do it next week some time if =
you can
>> wait.
>> You would need to look at the code in Grow.c to see where it is writ=
ten. I
>> think there is a block of metadata near the end of the device - just=
 before
>> the md metadata - which records what has been backed up where. =A0On=
ce you find
>> and decode that from one of the spares you can easily use 'dd' to ex=
tract the
>> backup.
>>
>> 2 is quite easy:
>>
>> =A0mdadm -C /dev/md0 -e 0.90 -l 5 -n 6 -c 256 \
>> =A0--assume-clean /dev/sdb /dev/sdg /dev/sdh /dev/sdd /dev/sda /dev/=
sdc
>>
>> Make sure you have the devices if the right order. =A0If you aren't =
sure, then
>> =A0mdadm -E list..of..devices | grep this
>> should give you an ascending series in columns 2 and 5.
>>
>> 3 is simply a 'cmp' between /dev/md0 and the backup that you restore=
d. or
>> maybe just 'fsck' of /dev/md0.
>> If you decide to restore (be sure before you do), just dd the backup=
 to the
>> start of /dev/md0
>>
>> I don't know how you can make yourself sure that the drives really d=
o work.
>> Lots of testing of the new devices by themselves in an array ???
>>
>> Good luck.
>>
>> NeilBrown
>>
>>>
>>> When I rebooted, the array seemed to be up, but mounting it resulte=
d
>>> in a bad FS type error, even when I tried to specify it (ext4). Aft=
er
>>> stopping the inactive array, and trying to reassemble it, mdadm
>>> crashed to segmentation fault.
>>> Is it possible to recover the data? We have backups, but they're
>>> spread out over 1500 DVDs.
>>>
>>> When I examine the drives, the output looks pretty much like this f=
or
>>> each drive (6 drives say active and 4 say clean, corresponding to t=
he
>>> 6 original and 4 added drives):
>>> $ mdadm --examine /dev/sda
>>> /dev/sda:
>>> =A0=A0 =A0 =A0 =A0 =A0Magic : a92b4efc
>>> =A0=A0 =A0 =A0 =A0Version : 00.91.00
>>> =A0=A0 =A0 =A0 =A0 =A0 UUID : 56c16545:07db76d6:e368bf24:bd0fce41
>>> =A0=A0Creation Time : Tue Feb =A02 09:58:58 2010
>>> =A0=A0 =A0 Raid Level : raid5
>>> =A0=A0Used Dev Size : 976762368 (931.51 GiB 1000.20 GB)
>>> =A0=A0 =A0 Array Size : 8790861312 (8383.62 GiB 9001.84 GB)
>>> =A0=A0 Raid Devices : 10
>>> =A0=A0Total Devices : 10
>>> Preferred Minor : 0
>>> =A0=A0Reshape pos'n : 0
>>> =A0=A0Delta Devices : 4 (6->10)
>>> =A0=A0 =A0Update Time : Thu Mar 18 23:33:40 2010
>>> =A0=A0 =A0 =A0 =A0 =A0State : active
>>> =A0Active Devices : 10
>>> Working Devices : 10
>>> =A0Failed Devices : 0
>>> =A0=A0Spare Devices : 0
>>> =A0=A0 =A0 =A0 Checksum : 79904299 - correct
>>> =A0=A0 =A0 =A0 =A0 Events : 270611
>>> =A0=A0 =A0 =A0 =A0 Layout : left-symmetric
>>> =A0=A0 =A0 Chunk Size : 256K
>>> =A0=A0 =A0 =A0Number =A0 Major =A0 Minor =A0 RaidDevice State
>>> this =A0 =A0 4 =A0 =A0 =A0 8 =A0 =A0 =A0 =A00 =A0 =A0 =A0 =A04 =A0 =
=A0 =A0active sync =A0 /dev/sda
>>> =A0=A0 0 =A0 =A0 0 =A0 =A0 =A0 8 =A0 =A0 =A0 16 =A0 =A0 =A0 =A00 =A0=
 =A0 =A0active sync =A0 /dev/sdb
>>> =A0=A0 1 =A0 =A0 1 =A0 =A0 =A0 8 =A0 =A0 =A0 96 =A0 =A0 =A0 =A01 =A0=
 =A0 =A0active sync =A0 /dev/sdg
>>> =A0=A0 2 =A0 =A0 2 =A0 =A0 =A0 8 =A0 =A0 =A0112 =A0 =A0 =A0 =A02 =A0=
 =A0 =A0active sync =A0 /dev/sdh
>>> =A0=A0 3 =A0 =A0 3 =A0 =A0 =A0 8 =A0 =A0 =A0 48 =A0 =A0 =A0 =A03 =A0=
 =A0 =A0active sync =A0 /dev/sdd
>>> =A0=A0 4 =A0 =A0 4 =A0 =A0 =A0 8 =A0 =A0 =A0 =A00 =A0 =A0 =A0 =A04 =
=A0 =A0 =A0active sync =A0 /dev/sda
>>> =A0=A0 5 =A0 =A0 5 =A0 =A0 =A0 8 =A0 =A0 =A0 32 =A0 =A0 =A0 =A05 =A0=
 =A0 =A0active sync =A0 /dev/sdc
>>> =A0=A0 6 =A0 =A0 6 =A0 =A0 =A0 8 =A0 =A0 =A0160 =A0 =A0 =A0 =A06 =A0=
 =A0 =A0active sync =A0 /dev/sdk
>>> =A0=A0 7 =A0 =A0 7 =A0 =A0 =A0 8 =A0 =A0 =A0144 =A0 =A0 =A0 =A07 =A0=
 =A0 =A0active sync =A0 /dev/sdj
>>> =A0=A0 8 =A0 =A0 8 =A0 =A0 =A0 8 =A0 =A0 =A0128 =A0 =A0 =A0 =A08 =A0=
 =A0 =A0active sync =A0 /dev/sdi
>>> =A0=A0 9 =A0 =A0 9 =A0 =A0 =A0 8 =A0 =A0 =A0 80 =A0 =A0 =A0 =A09 =A0=
 =A0 =A0active sync =A0 /dev/sdf
>>>
>>> #syslog showing how mdadm detects the bad 10-drive array on boot
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 =A02.178393] md: bind<sdc>
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 =A02.193132] md: bind<sdd>
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 =A02.211906] md: bind<sdb>
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 =A02.220062] md: bind<sda>
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 =A02.230062] ohci1394: fw-=
host0:
>>> OHCI-1394 1.1 (PCI): IRQ=3D[22] =A0MMIO=3D[fd6ff000-fd6ff7ff] =A0Ma=
x
>>> Packet=3D[2048] =A0IR/IT contexts=3D[4/8]
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 =A03.551483] ieee1394: Hos=
t
>>> added: ID:BUS[0-00:1023] =A0GUID[003635c7006cf049]
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 =A06.579349]
>>> /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c 1214:port 0
>>> attach dev info is 0
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 =A06.579353]
>>> /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c 1216:port 0
>>> attach sas addr is 0
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 =A06.780038]
>>> /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c 1214:port 1
>>> attach dev info is 0
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 =A06.780041]
>>> /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c 1216:port 1
>>> attach sas addr is 1
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 =A06.990054]
>>> /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c 1214:port 2
>>> attach dev info is 0
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 =A06.990057]
>>> /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c 1216:port 2
>>> attach sas addr is 2
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 =A07.200052]
>>> /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c 1214:port 3
>>> attach dev info is 0
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 =A07.200055]
>>> /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c 1216:port 3
>>> attach sas addr is 3
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 =A07.310035]
>>> /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c 1214:port 4
>>> attach dev info is 0
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 =A07.310038]
>>> /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c 1216:port 4
>>> attach sas addr is 0
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 =A07.420035]
>>> /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c 1214:port 5
>>> attach dev info is 0
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 =A07.420038]
>>> /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c 1216:port 5
>>> attach sas addr is 0
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 =A07.630052]
>>> /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c 1214:port 6
>>> attach dev info is 2000000
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 =A07.630055]
>>> /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c 1216:port 6
>>> attach sas addr is 6
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 =A07.840053]
>>> /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c 1214:port 7
>>> attach dev info is 0
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 =A07.840056]
>>> /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c 1216:port 7
>>> attach sas addr is 7
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 =A07.840062] scsi8 : mvsas
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 =A07.840605]
>>> /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c 380:phy 0 by=
te
>>> dmaded.
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 =A07.840610]
>>> /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c 380:phy 1 by=
te
>>> dmaded.
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 =A07.840614]
>>> /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c 380:phy 2 by=
te
>>> dmaded.
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 =A07.840617]
>>> /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c 380:phy 3 by=
te
>>> dmaded.
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 =A07.840621]
>>> /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c 380:phy 6 by=
te
>>> dmaded.
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 =A07.840624]
>>> /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c 380:phy 7 by=
te
>>> dmaded.
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 =A07.840871] mvsas 0000:03=
:00.0:
>>> mvsas: driver version 0.8.2
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 =A07.840885] mvsas 0000:03=
:00.0:
>>> PCI INT A -> GSI 16 (level, low) -> IRQ 16
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 =A07.840891] mvsas 0000:03=
:00.0:
>>> setting latency timer to 64
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 =A07.841965]
>>> /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c 1365:found
>>> dev[0:5] is gone.
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 =A07.843312] ata9.00: ATA-=
8: WDC
>>> WD10EARS-00Y5B1, 80.00A80, max UDMA/133
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 =A07.843316] ata9.00: 1953=
525168
>>> sectors, multi 0: LBA48 NCQ (depth 31/32)
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 =A07.843480] mvsas 0000:03=
:00.0:
>>> mvsas: PCI-E x4, Bandwidth Usage: 2.5 Gbps
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 =A07.845117] ata9.00: conf=
igured
>>> for UDMA/133
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 =A07.845182] scsi 8:0:0:0:
>>> Direct-Access =A0 =A0 ATA =A0 =A0 =A0WDC WD10EARS-00Y 80.0 PQ: 0 AN=
SI: 5
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 =A07.845801]
>>> /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c 1365:found
>>> dev[1:5] is gone.
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 =A07.846588] ata10.00: ATA=
-8: WDC
>>> WD10EADS-00L5B1, 01.01A01, max UDMA/133
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 =A07.846591] ata10.00: 195=
3525168
>>> sectors, multi 0: LBA48 NCQ (depth 31/32)
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 =A07.847419] ata10.00: con=
figured
>>> for UDMA/133
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 =A07.847455] scsi 8:0:1:0:
>>> Direct-Access =A0 =A0 ATA =A0 =A0 =A0WDC WD10EADS-00L 01.0 PQ: 0 AN=
SI: 5
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 =A07.848069]
>>> /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c 1365:found
>>> dev[2:5] is gone.
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 =A07.848894] ata11.00: ATA=
-8: WDC
>>> WD10EACS-00D6B1, 01.01A01, max UDMA/133
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 =A07.848897] ata11.00: 195=
3525168
>>> sectors, multi 0: LBA48 NCQ (depth 31/32)
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 =A07.849713] ata11.00: con=
figured
>>> for UDMA/133
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 =A07.849751] scsi 8:0:2:0:
>>> Direct-Access =A0 =A0 ATA =A0 =A0 =A0WDC WD10EACS-00D 01.0 PQ: 0 AN=
SI: 5
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 =A07.850909]
>>> /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c 1365:found
>>> dev[3:5] is gone.
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 =A07.852188] ata12.00: ATA=
-8: WDC
>>> WD10EARS-00Y5B1, 80.00A80, max UDMA/133
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 =A07.852192] ata12.00: 195=
3525168
>>> sectors, multi 0: LBA48 NCQ (depth 31/32)
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 =A07.853488] ata12.00: con=
figured
>>> for UDMA/133
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 =A07.853524] scsi 8:0:3:0:
>>> Direct-Access =A0 =A0 ATA =A0 =A0 =A0WDC WD10EARS-00Y 80.0 PQ: 0 AN=
SI: 5
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 =A07.854665]
>>> /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c 1365:found
>>> dev[4:5] is gone.
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 =A07.855955] ata13.00: ATA=
-8: WDC
>>> WD10EARS-00Y5B1, 80.00A80, max UDMA/133
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 =A07.855959] ata13.00: 195=
3525168
>>> sectors, multi 0: LBA48 NCQ (depth 31/32)
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 =A07.857258] ata13.00: con=
figured
>>> for UDMA/133
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 =A07.857293] scsi 8:0:4:0:
>>> Direct-Access =A0 =A0 ATA =A0 =A0 =A0WDC WD10EARS-00Y 80.0 PQ: 0 AN=
SI: 5
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 =A07.858437]
>>> /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c 1365:found
>>> dev[5:5] is gone.
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 =A07.859713] ata14.00: ATA=
-8: WDC
>>> WD10EARS-00Y5B1, 80.00A80, max UDMA/133
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 =A07.859716] ata14.00: 195=
3525168
>>> sectors, multi 0: LBA48 NCQ (depth 31/32)
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 =A07.861014] ata14.00: con=
figured
>>> for UDMA/133
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 =A07.861051] scsi 8:0:5:0:
>>> Direct-Access =A0 =A0 ATA =A0 =A0 =A0WDC WD10EARS-00Y 80.0 PQ: 0 AN=
SI: 5
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 =A08.831403] sd 8:0:0:0: A=
ttached
>>> scsi generic sg5 type 0
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 =A08.831507] sd 8:0:1:0: A=
ttached
>>> scsi generic sg6 type 0
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 =A08.831610] sd 8:0:2:0: A=
ttached
>>> scsi generic sg7 type 0
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 =A08.831713] sd 8:0:3:0: A=
ttached
>>> scsi generic sg8 type 0
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 =A08.831823] sd 8:0:4:0: A=
ttached
>>> scsi generic sg9 type 0
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 =A08.831927] sd 8:0:5:0: A=
ttached
>>> scsi generic sg10 type 0
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 =A08.832481] sd 8:0:0:0: [=
sdf]
>>> 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 =A08.832485] sd 8:0:1:0: [=
sdg]
>>> 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 =A08.832547] sd 8:0:1:0: [=
sdg]
>>> Write Protect is off
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 =A08.832551] sd 8:0:0:0: [=
sdf]
>>> Write Protect is off
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 =A08.832555] sd 8:0:0:0: [=
sdf]
>>> Mode Sense: 00 3a 00 00
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 =A08.832559] sd 8:0:1:0: [=
sdg]
>>> Mode Sense: 00 3a 00 00
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 =A08.832586] sd 8:0:0:0: [=
sdf]
>>> Write cache: enabled, read cache: enabled, doesn't support DPO or F=
UA
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 =A08.832590] sd 8:0:1:0: [=
sdg]
>>> Write cache: enabled, read cache: enabled, doesn't support DPO or F=
UA
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 =A08.832806] =A0sdg:
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 =A08.832853] =A0sdf:
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 =A08.832914] sd 8:0:2:0: [=
sdh]
>>> 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 =A08.832953] sd 8:0:2:0: [=
sdh]
>>> Write Protect is off
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 =A08.832956] sd 8:0:2:0: [=
sdh]
>>> Mode Sense: 00 3a 00 00
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 =A08.832976] sd 8:0:2:0: [=
sdh]
>>> Write cache: enabled, read cache: enabled, doesn't support DPO or F=
UA
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 =A08.833087] =A0sdh:
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 =A08.833182] sd 8:0:3:0: [=
sdi]
>>> 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 =A08.833197] sd 8:0:4:0: [=
sdj]
>>> 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 =A08.833238] sd 8:0:3:0: [=
sdi]
>>> Write Protect is off
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 =A08.833241] sd 8:0:3:0: [=
sdi]
>>> Mode Sense: 00 3a 00 00
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 =A08.833250] sd 8:0:4:0: [=
sdj]
>>> Write Protect is off
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 =A08.833252] sd 8:0:4:0: [=
sdj]
>>> Mode Sense: 00 3a 00 00
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 =A08.833270] sd 8:0:3:0: [=
sdi]
>>> Write cache: enabled, read cache: enabled, doesn't support DPO or F=
UA
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 =A08.833279] sd 8:0:4:0: [=
sdj]
>>> Write cache: enabled, read cache: enabled, doesn't support DPO or F=
UA
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 =A08.833442] =A0sdi:
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 =A08.833467] =A0sdj:
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 =A08.833553] sd 8:0:5:0: [=
sdk]
>>> 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 =A08.833593] sd 8:0:5:0: [=
sdk]
>>> Write Protect is off
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 =A08.833596] sd 8:0:5:0: [=
sdk]
>>> Mode Sense: 00 3a 00 00
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 =A08.833617] sd 8:0:5:0: [=
sdk]
>>> Write cache: enabled, read cache: enabled, doesn't support DPO or F=
UA
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 =A08.833734] =A0sdk: unkno=
wn partition table
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 =A08.846211] sd 8:0:2:0: [=
sdh]
>>> Attached SCSI disk
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 =A08.846599] =A0unknown pa=
rtition table
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 =A08.846759] sd 8:0:1:0: [=
sdg]
>>> Attached SCSI disk
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 =A09.316040] =A0unknown pa=
rtition table
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 =A09.316243] sd 8:0:3:0: [=
sdi]
>>> Attached SCSI disk
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 =A09.316249] =A0unknown pa=
rtition table
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 =A09.316404] sd 8:0:0:0: [=
sdf]
>>> Attached SCSI disk
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 =A09.317860] =A0unknown pa=
rtition table
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 =A09.318033] sd 8:0:4:0: [=
sdj]
>>> Attached SCSI disk
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 =A09.321964] =A0unknown pa=
rtition table
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 =A09.322127] sd 8:0:5:0: [=
sdk]
>>> Attached SCSI disk
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 12.220036]
>>> /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c 1214:port 0
>>> attach dev info is 0
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 12.220039]
>>> /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c 1216:port 0
>>> attach sas addr is 0
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 12.330034]
>>> /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c 1214:port 1
>>> attach dev info is 0
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 12.330037]
>>> /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c 1216:port 1
>>> attach sas addr is 0
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 12.440035]
>>> /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c 1214:port 2
>>> attach dev info is 0
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 12.440037]
>>> /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c 1216:port 2
>>> attach sas addr is 0
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 12.550034]
>>> /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c 1214:port 3
>>> attach dev info is 0
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 12.550038]
>>> /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c 1216:port 3
>>> attach sas addr is 0
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 12.660035]
>>> /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c 1214:port 4
>>> attach dev info is 0
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 12.660038]
>>> /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c 1216:port 4
>>> attach sas addr is 0
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 12.770035]
>>> /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c 1214:port 5
>>> attach dev info is 0
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 12.770037]
>>> /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c 1216:port 5
>>> attach sas addr is 0
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 12.880035]
>>> /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c 1214:port 6
>>> attach dev info is 0
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 12.880037]
>>> /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c 1216:port 6
>>> attach sas addr is 0
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 12.990034]
>>> /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c 1214:port 7
>>> attach dev info is 0
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 12.990037]
>>> /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c 1216:port 7
>>> attach sas addr is 0
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 12.990043] scsi9 : mvsas
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 13.595116] md: bind<sdi>
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 13.651656] md: bind<sdf>
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 13.653928] md: bind<sdj>
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 13.854601] md: bind<sdk>
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 14.055322] md: bind<sdh>
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 14.255683] md: bind<sdg>
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 14.259239] xor: automatica=
lly
>>> using best checksumming function: generic_sse
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 14.300015] =A0 =A0generic_=
sse:
>>> 6593.600 MB/sec
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 14.300018] xor: using func=
tion:
>>> generic_sse (6593.600 MB/sec)
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 14.300599] async_tx: api
>>> initialized (async)
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 14.470026] raid6: int64x1 =
=A0 1711 MB/s
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 14.640019] raid6: int64x2 =
=A0 2392 MB/s
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 14.810046] raid6: int64x4 =
=A0 1567 MB/s
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 14.980047] raid6: int64x8 =
=A0 1540 MB/s
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 15.150016] raid6: sse2x1 =A0=
 =A02931 MB/s
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 15.320030] raid6: sse2x2 =A0=
 =A03916 MB/s
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 15.490023] raid6: sse2x4 =A0=
 =A04088 MB/s
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 15.490025] raid6: using
>>> algorithm sse2x4 (4088 MB/s)
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 15.493236] md: raid6
>>> personality registered for level 6
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 15.493240] md: raid5
>>> personality registered for level 5
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 15.493242] md: raid4
>>> personality registered for level 4
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 15.493642] raid5: md0 is n=
ot
>>> clean -- starting background reconstruction
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 15.493645] raid5:
>>> reshape_position too early for auto-recovery - aborting.
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 15.493647] md: pers->run()=
 failed ...
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 15.931347] md: linear
>>> personality registered for level -1
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 15.934321] md: multipath
>>> personality registered for level -4
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 15.936772] md: raid0
>>> personality registered for level 0
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 15.940395] md: raid1
>>> personality registered for level 1
>>> Mar 18 23:47:35 raidserver kernel: [ =A0 15.949846] md: raid10
>>> personality registered for level 10
>>> #syslog of the segfault
>>>
>>> Mar 18 23:41:47 raidserver kernel: [ =A0155.028406] md: md0 stopped=
=2E
>>> Mar 18 23:41:47 raidserver kernel: [ =A0155.028443] md: unbind<sdg>
>>> Mar 18 23:41:47 raidserver kernel: [ =A0155.051309] md: export_rdev=
(sdg)
>>> Mar 18 23:41:47 raidserver kernel: [ =A0155.051464] md: unbind<sdk>
>>> Mar 18 23:41:47 raidserver kernel: [ =A0155.091288] md: export_rdev=
(sdk)
>>> Mar 18 23:41:47 raidserver kernel: [ =A0155.091418] md: unbind<sdj>
>>> Mar 18 23:41:47 raidserver kernel: [ =A0155.131274] md: export_rdev=
(sdj)
>>> Mar 18 23:41:47 raidserver kernel: [ =A0155.131407] md: unbind<sdi>
>>> Mar 18 23:41:47 raidserver kernel: [ =A0155.161277] md: export_rdev=
(sdi)
>>> Mar 18 23:41:47 raidserver kernel: [ =A0155.161421] md: unbind<sdl>
>>> Mar 18 23:41:47 raidserver kernel: [ =A0155.191275] md: export_rdev=
(sdl)
>>> Mar 18 23:41:47 raidserver kernel: [ =A0155.191400] md: unbind<sdh>
>>> Mar 18 23:41:47 raidserver kernel: [ =A0155.221276] md: export_rdev=
(sdh)
>>> Mar 18 23:41:47 raidserver kernel: [ =A0155.221403] md: unbind<sda>
>>> Mar 18 23:41:47 raidserver kernel: [ =A0155.251276] md: export_rdev=
(sda)
>>> Mar 18 23:41:47 raidserver kernel: [ =A0155.251385] md: unbind<sdb>
>>> Mar 18 23:41:47 raidserver kernel: [ =A0155.281277] md: export_rdev=
(sdb)
>>> Mar 18 23:41:47 raidserver kernel: [ =A0155.281379] md: unbind<sdc>
>>> Mar 18 23:41:47 raidserver kernel: [ =A0155.311276] md: export_rdev=
(sdc)
>>> Mar 18 23:41:47 raidserver kernel: [ =A0155.311377] md: unbind<sdd>
>>> Mar 18 23:41:47 raidserver mdadm[1738]: DeviceDisappeared event
>>> detected on md device /dev/md0
>>> Mar 18 23:41:47 raidserver kernel: [ =A0155.341274] md: export_rdev=
(sdd)
>>> Mar 18 23:43:46 raidserver kernel: [ =A0274.246878] md: md0 stopped=
=2E
>>> Mar 18 23:45:17 raidserver kernel: [ =A0365.227246] md: md0 stopped=
=2E
>>> Mar 18 23:45:18 raidserver kernel: [ =A0365.828455] __ratelimit: 30
>>> callbacks suppressed
>>> Mar 18 23:45:18 raidserver kernel: [ =A0365.828466] mdadm[2874]:
>>> segfault at 38 ip 00000000004184ff sp 00007fffc2aa6bd0 error 4 in
>>> mdadm[400000+2a000]
>>>
>>> #syslog of the grow and subsequent reboot
>>>
>>> Mar 18 23:27:41 raidserver kernel: [ =A0861.411806] md: bind<sdf>
>>> Mar 18 23:27:42 raidserver ata_id[2638]: HDIO_GET_IDENTITY failed f=
or '/dev/sdi'
>>> Mar 18 23:27:42 raidserver kernel: [ =A0862.024028] md: bind<sdi>
>>> Mar 18 23:27:43 raidserver ata_id[2650]: HDIO_GET_IDENTITY failed f=
or '/dev/sdj'
>>> Mar 18 23:27:43 raidserver kernel: [ =A0863.133531] md: bind<sdj>
>>> Mar 18 23:27:43 raidserver ata_id[2658]: HDIO_GET_IDENTITY failed f=
or '/dev/sdk'
>>> Mar 18 23:27:43 raidserver kernel: [ =A0863.285276] md: bind<sdk>
>>> Mar 18 23:28:35 raidserver kernel: [ =A0914.792375] RAID5 conf prin=
tout:
>>> Mar 18 23:28:35 raidserver kernel: [ =A0914.792385] =A0--- rd:10 wd=
:10
>>> Mar 18 23:28:35 raidserver kernel: [ =A0914.792393] =A0disk 0, o:1,=
 dev:sdb
>>> Mar 18 23:28:35 raidserver kernel: [ =A0914.792398] =A0disk 1, o:1,=
 dev:sdg
>>> Mar 18 23:28:35 raidserver kernel: [ =A0914.792402] =A0disk 2, o:1,=
 dev:sdh
>>> Mar 18 23:28:35 raidserver kernel: [ =A0914.792406] =A0disk 3, o:1,=
 dev:sdd
>>> Mar 18 23:28:35 raidserver kernel: [ =A0914.792410] =A0disk 4, o:1,=
 dev:sda
>>> Mar 18 23:28:35 raidserver kernel: [ =A0914.792415] =A0disk 5, o:1,=
 dev:sdc
>>> Mar 18 23:28:35 raidserver kernel: [ =A0914.792419] =A0disk 6, o:1,=
 dev:sdk
>>> Mar 18 23:28:35 raidserver kernel: [ =A0914.792443] RAID5 conf prin=
tout:
>>> Mar 18 23:28:35 raidserver kernel: [ =A0914.792447] =A0--- rd:10 wd=
:10
>>> Mar 18 23:28:35 raidserver kernel: [ =A0914.792450] =A0disk 0, o:1,=
 dev:sdb
>>> Mar 18 23:28:35 raidserver kernel: [ =A0914.792454] =A0disk 1, o:1,=
 dev:sdg
>>> Mar 18 23:28:35 raidserver kernel: [ =A0914.792457] =A0disk 2, o:1,=
 dev:sdh
>>> Mar 18 23:28:35 raidserver kernel: [ =A0914.792461] =A0disk 3, o:1,=
 dev:sdd
>>> Mar 18 23:28:35 raidserver kernel: [ =A0914.792465] =A0disk 4, o:1,=
 dev:sda
>>> Mar 18 23:28:35 raidserver kernel: [ =A0914.792469] =A0disk 5, o:1,=
 dev:sdc
>>> Mar 18 23:28:35 raidserver kernel: [ =A0914.792472] =A0disk 6, o:1,=
 dev:sdk
>>> Mar 18 23:28:35 raidserver kernel: [ =A0914.792476] =A0disk 7, o:1,=
 dev:sdj
>>> Mar 18 23:28:35 raidserver kernel: [ =A0914.792484] RAID5 conf prin=
tout:
>>> Mar 18 23:28:35 raidserver kernel: [ =A0914.792487] =A0--- rd:10 wd=
:10
>>> Mar 18 23:28:35 raidserver kernel: [ =A0914.792491] =A0disk 0, o:1,=
 dev:sdb
>>> Mar 18 23:28:35 raidserver kernel: [ =A0914.792494] =A0disk 1, o:1,=
 dev:sdg
>>> Mar 18 23:28:35 raidserver kernel: [ =A0914.792498] =A0disk 2, o:1,=
 dev:sdh
>>> Mar 18 23:28:35 raidserver kernel: [ =A0914.792502] =A0disk 3, o:1,=
 dev:sdd
>>> Mar 18 23:28:35 raidserver kernel: [ =A0914.792506] =A0disk 4, o:1,=
 dev:sda
>>> Mar 18 23:28:35 raidserver kernel: [ =A0914.792509] =A0disk 5, o:1,=
 dev:sdc
>>> Mar 18 23:28:35 raidserver kernel: [ =A0914.792513] =A0disk 6, o:1,=
 dev:sdk
>>> Mar 18 23:28:35 raidserver kernel: [ =A0914.792517] =A0disk 7, o:1,=
 dev:sdj
>>> Mar 18 23:28:35 raidserver kernel: [ =A0914.792520] =A0disk 8, o:1,=
 dev:sdi
>>> Mar 18 23:28:35 raidserver kernel: [ =A0914.792528] RAID5 conf prin=
tout:
>>> Mar 18 23:28:35 raidserver kernel: [ =A0914.792531] =A0--- rd:10 wd=
:10
>>> Mar 18 23:28:35 raidserver kernel: [ =A0914.792535] =A0disk 0, o:1,=
 dev:sdb
>>> Mar 18 23:28:35 raidserver kernel: [ =A0914.792538] =A0disk 1, o:1,=
 dev:sdg
>>> Mar 18 23:28:35 raidserver kernel: [ =A0914.792542] =A0disk 2, o:1,=
 dev:sdh
>>> Mar 18 23:28:35 raidserver kernel: [ =A0914.792545] =A0disk 3, o:1,=
 dev:sdd
>>> Mar 18 23:28:35 raidserver kernel: [ =A0914.792549] =A0disk 4, o:1,=
 dev:sda
>>> Mar 18 23:28:35 raidserver kernel: [ =A0914.792552] =A0disk 5, o:1,=
 dev:sdc
>>> Mar 18 23:28:35 raidserver kernel: [ =A0914.792556] =A0disk 6, o:1,=
 dev:sdk
>>> Mar 18 23:28:35 raidserver kernel: [ =A0914.792559] =A0disk 7, o:1,=
 dev:sdj
>>> Mar 18 23:28:35 raidserver kernel: [ =A0914.792563] =A0disk 8, o:1,=
 dev:sdi
>>> Mar 18 23:28:35 raidserver kernel: [ =A0914.792567] =A0disk 9, o:1,=
 dev:sdf
>>> Mar 18 23:28:35 raidserver kernel: [ =A0914.792713] md: reshape of =
RAID array md0
>>> Mar 18 23:28:35 raidserver kernel: [ =A0914.792722] md: minimum
>>> _guaranteed_ =A0speed: 1000 KB/sec/disk.
>>> Mar 18 23:28:35 raidserver kernel: [ =A0914.792728] md: using maxim=
um
>>> available idle IO bandwidth (but not more than 200000 KB/sec) for
>>> reshape.
>>> Mar 18 23:28:35 raidserver kernel: [ =A0914.792746] md: using 128k
>>> window, over a total of 976762368 blocks.
>>> Mar 18 23:28:35 raidserver mdadm[1627]: RebuildStarted event detect=
ed
>>> on md device /dev/md0
>>> Mar 18 23:28:35 raidserver mdadm[1627]: SpareActive event detected =
on
>>> md device /dev/md0, component device /dev/sdk
>>> Mar 18 23:28:35 raidserver mdadm[1627]: SpareActive event detected =
on
>>> md device /dev/md0, component device /dev/sdj
>>> Mar 18 23:28:35 raidserver mdadm[1627]: SpareActive event detected =
on
>>> md device /dev/md0, component device /dev/sdi
>>> Mar 18 23:28:35 raidserver mdadm[1627]: SpareActive event detected =
on
>>> md device /dev/md0, component device /dev/sdf
>>> Mar 18 23:29:05 raidserver kernel: [ =A0945.010492]
>>> /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c
>>> 1669:mvs_abort_task:rc=3D 5
>>> Mar 18 23:29:05 raidserver kernel: [ =A0945.010501]
>>> /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c
>>> 1608:mvs_query_task:rc=3D 5
>>> Mar 18 23:29:05 raidserver kernel: [ =A0945.010517]
>>> /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c
>>> 1669:mvs_abort_task:rc=3D 5
>>> Mar 18 23:29:05 raidserver kernel: [ =A0945.010523]
>>> /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c
>>> 1608:mvs_query_task:rc=3D 5
>>> Mar 18 23:29:36 raidserver kernel: [ =A0976.010049]
>>> /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c
>>> 1669:mvs_abort_task:rc=3D 5
>>> Mar 18 23:29:36 raidserver kernel: [ =A0976.010058]
>>> /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c
>>> 1608:mvs_query_task:rc=3D 5
>>> Mar 18 23:29:36 raidserver kernel: [ =A0976.010071]
>>> /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c
>>> 1669:mvs_abort_task:rc=3D 5
>>> Mar 18 23:29:36 raidserver kernel: [ =A0976.010077]
>>> /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c
>>> 1608:mvs_query_task:rc=3D 5
>>> Mar 18 23:30:07 raidserver kernel: [ 1007.010495]
>>> /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c
>>> 1669:mvs_abort_task:rc=3D 5
>>> Mar 18 23:30:07 raidserver kernel: [ 1007.010504]
>>> /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c
>>> 1608:mvs_query_task:rc=3D 5
>>> Mar 18 23:30:07 raidserver kernel: [ 1007.010518]
>>> /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c
>>> 1669:mvs_abort_task:rc=3D 5
>>> Mar 18 23:30:07 raidserver kernel: [ 1007.010525]
>>> /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c
>>> 1608:mvs_query_task:rc=3D 5
>>> Mar 18 23:30:38 raidserver kernel: [ 1038.010051]
>>> /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c
>>> 1669:mvs_abort_task:rc=3D 5
>>> Mar 18 23:30:38 raidserver kernel: [ 1038.010060]
>>> /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c
>>> 1608:mvs_query_task:rc=3D 5
>>> Mar 18 23:30:38 raidserver kernel: [ 1038.010075]
>>> /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c
>>> 1669:mvs_abort_task:rc=3D 5
>>> Mar 18 23:30:38 raidserver kernel: [ 1038.010081]
>>> /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c
>>> 1608:mvs_query_task:rc=3D 5
>>> Mar 18 23:31:09 raidserver kernel: [ 1069.010493]
>>> /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c
>>> 1669:mvs_abort_task:rc=3D 5
>>> Mar 18 23:31:09 raidserver kernel: [ 1069.010503]
>>> /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c
>>> 1608:mvs_query_task:rc=3D 5
>>> Mar 18 23:31:09 raidserver kernel: [ 1069.010517]
>>> /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c
>>> 1669:mvs_abort_task:rc=3D 5
>>> Mar 18 23:31:09 raidserver kernel: [ 1069.010523]
>>> /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c
>>> 1608:mvs_query_task:rc=3D 5
>>> Mar 18 23:31:20 raidserver kernel: [ 1080.620078] INFO: task
>>> md0_reshape:2679 blocked for more than 120 seconds.
>>> Mar 18 23:31:20 raidserver kernel: [ 1080.620086] "echo 0 >
>>> /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>>> Mar 18 23:31:20 raidserver kernel: [ 1080.620092] md0_reshape =A0 D
>>> 00000000ffffffff =A0 =A0 0 =A02679 =A0 =A0 =A02 0x00000000
>>> Mar 18 23:31:20 raidserver kernel: [ 1080.620103] =A0ffff8800441e1a=
d0
>>> 0000000000000046 ffff8800441e1a80 0000000000015880
>>> Mar 18 23:31:20 raidserver kernel: [ 1080.620113] =A0ffff880068199a=
60
>>> 0000000000015880 0000000000015880 0000000000015880
>>> Mar 18 23:31:20 raidserver kernel: [ 1080.620122] =A000000000000158=
80
>>> ffff880068199a60 0000000000015880 0000000000015880
>>> Mar 18 23:31:20 raidserver kernel: [ 1080.620131] Call Trace:
>>> Mar 18 23:31:20 raidserver kernel: [ 1080.620169]
>>> [<ffffffffa01d6ce1>] get_active_stripe+0x2a1/0x360 [raid456]
>>> Mar 18 23:31:20 raidserver kernel: [ 1080.620185]
>>> [<ffffffff81053d60>] ? default_wake_function+0x0/0x10
>>> Mar 18 23:31:20 raidserver kernel: [ 1080.620197]
>>> [<ffffffffa01d92e0>] reshape_request+0x4a0/0x980 [raid456]
>>> Mar 18 23:31:20 raidserver kernel: [ 1080.620210]
>>> [<ffffffffa01d9ada>] sync_request+0x31a/0x3a0 [raid456]
>>> Mar 18 23:31:20 raidserver kernel: [ 1080.620221]
>>> [<ffffffffa01d69ae>] ? raid5_unplug_device+0x7e/0x110 [raid456]
>>> Mar 18 23:31:20 raidserver kernel: [ 1080.620233]
>>> [<ffffffff813daa1e>] md_do_sync+0x5fe/0xba0
>>> Mar 18 23:31:20 raidserver kernel: [ 1080.620242]
>>> [<ffffffff813db774>] md_thread+0x44/0x120
>>> Mar 18 23:31:20 raidserver kernel: [ 1080.620249]
>>> [<ffffffff813db730>] ? md_thread+0x0/0x120
>>> Mar 18 23:31:20 raidserver kernel: [ 1080.620257]
>>> [<ffffffff81078746>] kthread+0xa6/0xb0
>>> Mar 18 23:31:20 raidserver kernel: [ 1080.620266]
>>> [<ffffffff810130ea>] child_rip+0xa/0x20
>>> Mar 18 23:31:20 raidserver kernel: [ 1080.620273]
>>> [<ffffffff810786a0>] ? kthread+0x0/0xb0
>>> Mar 18 23:31:20 raidserver kernel: [ 1080.620279]
>>> [<ffffffff810130e0>] ? child_rip+0x0/0x20
>>> Mar 18 23:31:40 raidserver kernel: [ 1100.010040]
>>> /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c
>>> 1669:mvs_abort_task:rc=3D 5
>>> Mar 18 23:31:40 raidserver kernel: [ 1100.010049]
>>> /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c
>>> 1608:mvs_query_task:rc=3D 5
>>> Mar 18 23:31:40 raidserver kernel: [ 1100.010065]
>>> /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c
>>> 1669:mvs_abort_task:rc=3D 5
>>> Mar 18 23:31:40 raidserver kernel: [ 1100.010072]
>>> /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c
>>> 1608:mvs_query_task:rc=3D 5
>>> Mar 18 23:31:40 raidserver kernel: [ 1100.010127] sd 8:0:1:0: [sdg]
>>> Unhandled error code
>>> Mar 18 23:31:40 raidserver kernel: [ 1100.010132] sd 8:0:1:0: [sdg]
>>> Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_TIMEOUT
>>> Mar 18 23:31:40 raidserver kernel: [ 1100.010141] end_request: I/O
>>> error, dev sdg, sector 0
>>> Mar 18 23:31:40 raidserver kernel: [ 1100.010310] sd 8:0:2:0: [sdh]
>>> Unhandled error code
>>> Mar 18 23:31:40 raidserver kernel: [ 1100.010314] sd 8:0:2:0: [sdh]
>>> Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_TIMEOUT
>>> Mar 18 23:31:40 raidserver kernel: [ 1100.010321] end_request: I/O
>>> error, dev sdh, sector 8
>>> Mar 18 23:32:11 raidserver kernel: [ 1131.010514]
>>> /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c
>>> 1669:mvs_abort_task:rc=3D 5
>>> Mar 18 23:32:11 raidserver kernel: [ 1131.010523]
>>> /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c
>>> 1608:mvs_query_task:rc=3D 5
>>> Mar 18 23:32:11 raidserver kernel: [ 1131.010545]
>>> /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c
>>> 1669:mvs_abort_task:rc=3D 5
>>> Mar 18 23:32:11 raidserver kernel: [ 1131.010551]
>>> /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c
>>> 1608:mvs_query_task:rc=3D 5
>>> Mar 18 23:32:11 raidserver kernel: [ 1131.010562]
>>> /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c
>>> 1669:mvs_abort_task:rc=3D 5
>>> Mar 18 23:32:11 raidserver kernel: [ 1131.010567]
>>> /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c
>>> 1608:mvs_query_task:rc=3D 5
>>> Mar 18 23:32:11 raidserver kernel: [ 1131.010580]
>>> /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c
>>> 1669:mvs_abort_task:rc=3D 5
>>> Mar 18 23:32:11 raidserver kernel: [ 1131.010585]
>>> /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c
>>> 1608:mvs_query_task:rc=3D 5
>>> Mar 18 23:32:11 raidserver kernel: [ 1131.010596]
>>> /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c
>>> 1669:mvs_abort_task:rc=3D 5
>>> Mar 18 23:32:11 raidserver kernel: [ 1131.010601]
>>> /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c
>>> 1608:mvs_query_task:rc=3D 5
>>> Mar 18 23:32:11 raidserver kernel: [ 1131.010612]
>>> /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c
>>> 1669:mvs_abort_task:rc=3D 5
>>> Mar 18 23:32:11 raidserver kernel: [ 1131.010617]
>>> /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c
>>> 1608:mvs_query_task:rc=3D 5
>>> Mar 18 23:32:42 raidserver kernel: [ 1162.010054]
>>> /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c
>>> 1669:mvs_abort_task:rc=3D 5
>>> Mar 18 23:32:42 raidserver kernel: [ 1162.010063]
>>> /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c
>>> 1608:mvs_query_task:rc=3D 5
>>> Mar 18 23:32:42 raidserver kernel: [ 1162.010084]
>>> /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c
>>> 1669:mvs_abort_task:rc=3D 5
>>> Mar 18 23:32:42 raidserver kernel: [ 1162.010090]
>>> /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c
>>> 1608:mvs_query_task:rc=3D 5
>>> Mar 18 23:32:42 raidserver kernel: [ 1162.010101]
>>> /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c
>>> 1669:mvs_abort_task:rc=3D 5
>>> Mar 18 23:32:42 raidserver kernel: [ 1162.010107]
>>> /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c
>>> 1608:mvs_query_task:rc=3D 5
>>> Mar 18 23:32:42 raidserver kernel: [ 1162.010119]
>>> /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c
>>> 1669:mvs_abort_task:rc=3D 5
>>> Mar 18 23:32:42 raidserver kernel: [ 1162.010125]
>>> /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c
>>> 1608:mvs_query_task:rc=3D 5
>>> Mar 18 23:32:42 raidserver kernel: [ 1162.010136]
>>> /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c
>>> 1669:mvs_abort_task:rc=3D 5
>>> Mar 18 23:32:42 raidserver kernel: [ 1162.010142]
>>> /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c
>>> 1608:mvs_query_task:rc=3D 5
>>> Mar 18 23:32:42 raidserver kernel: [ 1162.010153]
>>> /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c
>>> 1669:mvs_abort_task:rc=3D 5
>>> Mar 18 23:32:42 raidserver kernel: [ 1162.010159]
>>> /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c
>>> 1608:mvs_query_task:rc=3D 5
>>> Mar 18 23:33:13 raidserver kernel: [ 1193.010053]
>>> /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c
>>> 1669:mvs_abort_task:rc=3D 5
>>> Mar 18 23:33:13 raidserver kernel: [ 1193.010062]
>>> /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c
>>> 1608:mvs_query_task:rc=3D 5
>>> Mar 18 23:33:13 raidserver kernel: [ 1193.010083]
>>> /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c
>>> 1669:mvs_abort_task:rc=3D 5
>>> Mar 18 23:33:13 raidserver kernel: [ 1193.010089]
>>> /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c
>>> 1608:mvs_query_task:rc=3D 5
>>> Mar 18 23:33:13 raidserver kernel: [ 1193.010100]
>>> /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c
>>> 1669:mvs_abort_task:rc=3D 5
>>> Mar 18 23:33:13 raidserver kernel: [ 1193.010106]
>>> /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c
>>> 1608:mvs_query_task:rc=3D 5
>>> Mar 18 23:33:13 raidserver kernel: [ 1193.010118]
>>> /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c
>>> 1669:mvs_abort_task:rc=3D 5
>>> Mar 18 23:33:13 raidserver kernel: [ 1193.010123]
>>> /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c
>>> 1608:mvs_query_task:rc=3D 5
>>> Mar 18 23:33:13 raidserver kernel: [ 1193.010134]
>>> /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c
>>> 1669:mvs_abort_task:rc=3D 5
>>> Mar 18 23:33:13 raidserver kernel: [ 1193.010139]
>>> /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c
>>> 1608:mvs_query_task:rc=3D 5
>>> Mar 18 23:33:13 raidserver kernel: [ 1193.010150]
>>> /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c
>>> 1669:mvs_abort_task:rc=3D 5
>>> Mar 18 23:33:13 raidserver kernel: [ 1193.010156]
>>> /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c
>>> 1608:mvs_query_task:rc=3D 5
>>> Mar 18 23:33:16 raidserver ata_id[2906]: HDIO_GET_IDENTITY failed f=
or '/dev/sdj'
>>> Mar 18 23:33:16 raidserver ata_id[2910]: HDIO_GET_IDENTITY failed f=
or '/dev/sdk'
>>> Mar 18 23:33:16 raidserver ata_id[2911]: HDIO_GET_IDENTITY failed f=
or '/dev/sdi'
>>> Mar 18 23:33:34 raidserver kernel: [ 1213.857434] md: md0 still in =
use.
>>> Mar 18 23:33:40 raidserver kernel: [ 1219.907801] EXT4-fs: mballoc:=
 0
>>> blocks 0 reqs (0 success)
>>> Mar 18 23:33:40 raidserver kernel: [ 1219.907801] EXT4-fs: mballoc:=
 0
>>> extents scanned, 0 goal hits, 0 2^N hits, 0 breaks, 0 lost
>>> Mar 18 23:33:40 raidserver kernel: [ 1219.907801] EXT4-fs: mballoc:=
 0
>>> generated and it took 0
>>> Mar 18 23:33:40 raidserver kernel: [ 1219.907801] EXT4-fs: mballoc:=
 0
>>> preallocated, 0 discarded
>>> Mar 18 23:34:10 raidserver kernel: [ 1250.010051]
>>> /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c
>>> 1669:mvs_abort_task:rc=3D 5
>>> Mar 18 23:34:10 raidserver kernel: [ 1250.010061]
>>> /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c
>>> 1608:mvs_query_task:rc=3D 5
>>> Mar 18 23:34:10 raidserver kernel: [ 1250.010087]
>>> /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c
>>> 1669:mvs_abort_task:rc=3D 5
>>> Mar 18 23:34:10 raidserver kernel: [ 1250.010093]
>>> /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c
>>> 1608:mvs_query_task:rc=3D 5
>>> Mar 18 23:34:10 raidserver kernel: [ 1250.010109]
>>> /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c
>>> 1669:mvs_abort_task:rc=3D 5
>>> Mar 18 23:34:10 raidserver kernel: [ 1250.010115]
>>> /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c
>>> 1608:mvs_query_task:rc=3D 5
>>> Mar 18 23:34:10 raidserver kernel: [ 1250.010130]
>>> /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c
>>> 1669:mvs_abort_task:rc=3D 5
>>> Mar 18 23:34:10 raidserver kernel: [ 1250.010135]
>>> /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c
>>> 1608:mvs_query_task:rc=3D 5
>>> Mar 18 23:34:10 raidserver kernel: [ 1250.010150]
>>> /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c
>>> 1669:mvs_abort_task:rc=3D 5
>>> Mar 18 23:34:10 raidserver kernel: [ 1250.010155]
>>> /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c
>>> 1608:mvs_query_task:rc=3D 5
>>> Mar 18 23:34:10 raidserver kernel: [ 1250.010166]
>>> /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c
>>> 1669:mvs_abort_task:rc=3D 5
>>> Mar 18 23:34:10 raidserver kernel: [ 1250.010171]
>>> /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c
>>> 1608:mvs_query_task:rc=3D 5
>>> Mar 18 23:34:41 raidserver kernel: [ 1281.010517]
>>> /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c
>>> 1669:mvs_abort_task:rc=3D 5
>>> Mar 18 23:34:41 raidserver kernel: [ 1281.010528]
>>> /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c
>>> 1608:mvs_query_task:rc=3D 5
>>> Mar 18 23:34:41 raidserver kernel: [ 1281.010550]
>>> /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c
>>> 1669:mvs_abort_task:rc=3D 5
>>> Mar 18 23:34:41 raidserver kernel: [ 1281.010556]
>>> /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c
>>> 1608:mvs_query_task:rc=3D 5
>>> Mar 18 23:34:41 raidserver kernel: [ 1281.010572]
>>> /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c
>>> 1669:mvs_abort_task:rc=3D 5
>>> Mar 18 23:34:41 raidserver kernel: [ 1281.010578]
>>> /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c
>>> 1608:mvs_query_task:rc=3D 5
>>> Mar 18 23:34:41 raidserver kernel: [ 1281.010592]
>>> /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c
>>> 1669:mvs_abort_task:rc=3D 5
>>> Mar 18 23:34:41 raidserver kernel: [ 1281.010597]
>>> /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c
>>> 1608:mvs_query_task:rc=3D 5
>>> Mar 18 23:34:41 raidserver kernel: [ 1281.010611]
>>> /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c
>>> 1669:mvs_abort_task:rc=3D 5
>>> Mar 18 23:34:41 raidserver kernel: [ 1281.010617]
>>> /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c
>>> 1608:mvs_query_task:rc=3D 5
>>> Mar 18 23:34:41 raidserver kernel: [ 1281.010627]
>>> /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c
>>> 1669:mvs_abort_task:rc=3D 5
>>> Mar 18 23:34:41 raidserver kernel: [ 1281.010633]
>>> /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c
>>> 1608:mvs_query_task:rc=3D 5
>>> Mar 18 23:35:06 raidserver kernel: Kernel logging (proc) stopped.
>>> Mar 18 23:35:06 raidserver rsyslogd: [origin software=3D"rsyslogd"
>>> swVersion=3D"4.2.0" x-pid=3D"1027" x-info=3D"http://www.rsyslog.com=
"]
>>> exiting on signal 15.
>>> Mar 18 23:39:31 raidserver kernel: imklog 4.2.0, log source =3D
>>> /var/run/rsyslog/kmsg started.
>>> Mar 18 23:39:31 raidserver rsyslogd: [origin software=3D"rsyslogd"
>>> swVersion=3D"4.2.0" x-pid=3D"647" x-info=3D"http://www.rsyslog.com"=
]
>>> (re)start
>>> Mar 18 23:39:31 raidserver rsyslogd: rsyslogd's groupid changed to =
102
>>> Mar 18 23:39:31 raidserver rsyslogd: rsyslogd's userid changed to 1=
01
>>>
>>> --
>>> Stephan E Stachurski
>>> 773-315-1684
>>> ses1984@gmail.com
>>>
>>>
>>>
>>>
>>> --
>>> Stephan E Stachurski
>>> 773-315-1684
>>> ses1984@gmail.com
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-rai=
d" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.htm=
l
>>
>>
>
>
>
> --
> Stephan E Stachurski
> 773-315-1684
> ses1984@gmail.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

As Niel Brown stated in his reply, the issue is more complicated than t=
hat.

Your array has entered a less than known state; likely while working
with the critical section.  Some parts may be stored as before, while
others may be stored as things should look now.  This is why the
critical section backup and possible recovery is very important.
Please follow Niel Brown's directions /very/ carefully.  You probably
also want to save the start of each device.

dd if=3D/dev/container of=3Dsomeplace/array_dev_X.raw bs=3D1024k count=3D=
64
 for each device in the array (saving to separate files) would
probably be a tolerable safety net to start with.  You could also load
these much smaller segments in hex-editors more easily.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
