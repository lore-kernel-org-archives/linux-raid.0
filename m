From: FRLinux <frlinux@frlinux.net>
Subject: sil crash
Date: Sat, 03 Jul 2004 12:11:33 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1088853093.3226.14.camel@power.users>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I am currently using a Silicon Image 3112 controller with 2 SATA Maxtor
160GB drives named as sda and sdb by the lib_ata driver. This is on a
Gentoo 2004.1 system running a 2.6.7 kernel.

Since i have created the md0 and md1 arrays (both raid1), the md0 one
crashes in average every 3 days and detaches sda2 from its array
generating a lot of errors. I don't think it is related to the drives,
they are brand new and smart status report no errors whatsoever. Also, i
am running multiple linux on the first drive (fedora, mandrake,
slackware, lfs, etc ...) but not using raid, and they never crash.

Here is the error i'm getting once the crash occured (currently logged
on under FC2) : 

cat /proc/mdstat
Personalities : [raid1]
md1 : active raid1 hda3[0] hdc3[1]
      19542976 blocks [2/2] [UU]
       
md0 : active raid1 hdc2[1]
      97667072 blocks [2/1] [_U]

hda: max request size: 64KiB
hda: 320173056 sectors (163928 MB) w/7936KiB Cache, CHS=19929/255/63
 hda: hda1 hda2 hda3 hda4 < hda5 hda6 hda7 hda8 hda9 hda10 hda11 >
hdc: max request size: 64KiB
hdc: 320173056 sectors (163928 MB) w/7936KiB Cache, CHS=19929/255/63
 hdc: hdc1 hdc2 hdc3 hdc4 < hdc5 >

libata version 1.02 loaded.
sata_promise version 1.00
ata1: SATA max UDMA/133 cmd 0x2283D200 ctl 0x2283D238 bmdma 0x0 irq 10
ata2: SATA max UDMA/133 cmd 0x2283D280 ctl 0x2283D2B8 bmdma 0x0 irq 10
ata1: no device found (phy stat 00000000)
scsi0 : sata_promise
ata2: no device found (phy stat 00000000)
scsi1 : sata_promise
md: raid1 personality registered as nr 3
md: Autodetecting RAID arrays.
md: autorun ...
md: considering hdc2 ...
md:  adding hdc2 ...
md:  adding hda2 ...
md: hda3 has different UUID to hdc2
md: hdc3 has different UUID to hdc2
md: created md0
md: bind<hda2>
md: bind<hdc2>
md: running: <hdc2><hda2>
md: kicking non-fresh hda2 from array!
md: unbind<hda2>
md: export_rdev(hda2)
raid1: raid set md0 active with 1 out of 2 mirrors
md: considering hda3 ...
md:  adding hda3 ...
md:  adding hdc3 ...
md: created md1
md: bind<hdc3>
md: bind<hda3>
md: running: <hda3><hdc3>
raid1: raid set md1 active with 2 out of 2 mirrors
md: ... autorun DONE.
md: Autodetecting RAID arrays.
md: autorun ...
md: considering hda2 ...
md:  adding hda2 ...
md: md0 already running, cannot run hda2
md: export_rdev(hda2)
md: ... autorun DONE.


More importantly, i can't reboot under Gentoo right now, this is a
transcript of what i got : 

SCSI Error on Channel 0 id 0
cdb: 0 x28 00 00 03 40 3d 00 08 00
current sda sense 403
end request I/0 error dev
sda sector 213053
raid1: disk failure on sda2 disabling device
continuing on 1 devices
raid1: sda2 rescheduling sector 4208
--- wd:1 rd:2
disk 0, wo:1, o:0, dev:sda2
disk 1, wo:0, o:1, dev:sdb2
RAID1 conf printout:
--- wd:1 rd:2
disk 1, wo:0 o:1, dev:sdb2
raid1: sdb2: redirecting sector 4208
ata2: DMA timeout, stat:0x0
ATA: abnormal status 0x58 on port 0xE0D16
scsi1: ERROR on channel 0, id 0, lun 0
current sdb: sense = 70 3
ASC=11 ASCQ= 4
Raw sense data:0x70 0x00 0x03 0x00 0x00
end_request: I/O error, dev sdb
<snip>
... etc ...

Then it does not seem to reboot anymore. At one stage, it disconnects
sdb2 from the array, i can boot back in the system again, then i usually
do : raidhotadd /dev/md0 /dev/sdb2 then it reconstructs the array again,
then works for a couple of days and dies again.

Been using soft raid for a long time but never used the libata driver
before, which seems to be having problems. I've been googling for this
and posted on my local lug even without being able to fix this.

I hope someone can enlighten me on this.
Thanks,
Steph

