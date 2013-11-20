From: "David F." <df7729@gmail.com>
Subject: Re: MDADM 3.3 broken?
Date: Wed, 20 Nov 2013 15:15:41 -0800
Message-ID: <CAGRSmLsCdXbAUCUMncKv1ER9HBtFnk9BeuF6iaWv=9SSRAiHeA@mail.gmail.com>
References: <CAGRSmLviYJtCfNiARKW0FvrJ0BUDrvhPnQy2drzbkf95-Gfpag@mail.gmail.com>
	<528A7721.8080604@arcor.de>
	<CAGRSmLvRVQtrkYPLS8NfRS+DvyS0xZ72cwVdLygb0w5KbVrARA@mail.gmail.com>
	<20131119110110.396b2af3@notabene.brown>
	<528BBFEB.7050202@arcor.de>
	<20131120105115.27494ab6@notabene.brown>
	<CAGRSmLsAALx=kJFiB6_b_yeb66qMZCa+4brg8Aejeaf031_JPg@mail.gmail.com>
	<CAGRSmLs8AXqTG9Y0YU46vtpb2q08-2ApknBHVPF75FXPJu7C0Q@mail.gmail.com>
	<20131120114833.695fc9d4@notabene.brown>
	<CAGRSmLsTnc_Lood59wF88w6nECVojbeiGkdntLExLEf6ZoaF7g@mail.gmail.com>
	<CAGRSmLvv0-MRyKV89W4zDi57Fhx8dxEUsR+zskOQ0R-H6x4Zbw@mail.gmail.com>
	<20131120133016.7de2d400@notabene.brown>
	<CAGRSmLvR0vrddZ=qOQsM0m+3diDNC3uu-TW2OjwF2mS8UsNF7A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGRSmLvR0vrddZ=qOQsM0m+3diDNC3uu-TW2OjwF2mS8UsNF7A@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Martin Wilck <mwilck@arcor.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have the updated info for that cisco server with the lsi controller
- This was run all at the same time, using the latest patch that
worked on the isw system.

Storage devices (non-RAID) detected by Linux based on /sys/block:

Optical drives (srx):
  sr0: hp       DVDRAM GT30L     (fw rev = mP06)
Removable drives (sdx):
  sdg: 7453 MiB          Patriot Memory
Fixed hard drives (sdx):
  sda: 1863 GiB WD       Ext HDD 1021
  sdb: 136 GiB TOSHIBA  MK1401GRRB
  sdc: 136 GiB TOSHIBA  MK1401GRRB
  sdd: 136 GiB TOSHIBA  MK1401GRRB
  sde: 136 GiB TOSHIBA  MK1401GRRB
  sdf: 136 GiB TOSHIBA  MK1401GRRB

Contents of /sys/block:
md127  ram0   ram1   sda    sdb    sdc    sdd    sde    sdf    sdg    sr0

Contents of /dev:
block               port                tty1                tty47
bsg                 ppp                 tty10               tty48
bus                 psaux               tty11               tty49
cdrom               ptmx                tty12               tty5
cdrom1              ptp0                tty13               tty50
cdrw                ptp1                tty14               tty51
cdrw1               pts                 tty15               tty52
char                ram0                tty16               tty53
console             ram1                tty17               tty54
core                random              tty18               tty55
cpu_dma_latency     rfkill              tty19               tty56
disk                rtc                 tty2                tty57
dvd                 rtc0                tty20               tty58
dvd1                sda                 tty21               tty59
dvdrw               sda1                tty22               tty6
dvdrw1              sdb                 tty23               tty60
fd                  sdb1                tty24               tty61
full                sdb2                tty25               tty62
fuse                sdc                 tty26               tty63
hidraw0             sdd                 tty27               tty7
hidraw1             sde                 tty28               tty8
hidraw2             sde1                tty29               tty9
hidraw3             sde2                tty3                ttyS0
hidraw4             sdf                 tty30               ttyS1
hidraw5             sdg                 tty31               ttyS2
hpet                sg0                 tty32               ttyS3
input               sg1                 tty33               urandom
kmsg                sg2                 tty34               vcs
log                 sg3                 tty35               vcs1
loop-control        sg4                 tty36               vcs2
loop0               sg5                 tty37               vcs3
loop1               sg6                 tty38               vcs4
mapper              sg7                 tty39               vcs5
mcelog              shm                 tty4                vcsa
md                  sr0                 tty40               vcsa1
md127               stderr              tty41               vcsa2
mem                 stdin               tty42               vcsa3
net                 stdout              tty43               vcsa4
network_latency     synth               tty44               vcsa5
network_throughput  tty                 tty45               vga_arbiter
null                tty0                tty46               zero

Contents of /proc/partitions:
major minor  #blocks  name

   8        0 1953512448 sda
   8        1 1953511424 sda1
   8       16  143638992 sdb
   8       17     102400 sdb1
   8       18  143535568 sdb2
   8       32  143638992 sdc
   8       48  143638992 sdd
   8       64  143638992 sde
   8       65     102400 sde1
   8       66  143535568 sde2
   8       80  143638992 sdf
  11        0      48608 sr0
   8       96    7632892 sdg

Disk /dev/sda: 2000.3 GB, 2000396746752 bytes
255 heads, 63 sectors/track, 243201 cylinders, total 3907024896 sectors
Units = sectors of 1 * 512 = 512 bytes

   Device Boot      Start         End      Blocks  Id System
/dev/sda1            2048  3907024895  1953511424   7 HPFS/NTFS

Disk /dev/sdb: 147.0 GB, 147086327808 bytes
255 heads, 63 sectors/track, 17882 cylinders, total 287277984 sectors
Units = sectors of 1 * 512 = 512 bytes

   Device Boot      Start         End      Blocks  Id System
/dev/sdb1   *        2048      206847      102400   7 HPFS/NTFS
Partition 1 does not end on cylinder boundary
/dev/sdb2          206848   855463935   427628544   7 HPFS/NTFS

Disk /dev/sdc: 147.0 GB, 147086327808 bytes
255 heads, 63 sectors/track, 17882 cylinders, total 287277984 sectors
Units = sectors of 1 * 512 = 512 bytes

Disk /dev/sdc doesn't contain a valid partition table

Disk /dev/sdd: 147.0 GB, 147086327808 bytes
255 heads, 63 sectors/track, 17882 cylinders, total 287277984 sectors
Units = sectors of 1 * 512 = 512 bytes

Disk /dev/sdd doesn't contain a valid partition table

Disk /dev/sde: 147.0 GB, 147086327808 bytes
255 heads, 63 sectors/track, 17882 cylinders, total 287277984 sectors
Units = sectors of 1 * 512 = 512 bytes

   Device Boot      Start         End      Blocks  Id System
/dev/sde1   *        2048      206847      102400   7 HPFS/NTFS
Partition 1 does not end on cylinder boundary
/dev/sde2          206848   855463935   427628544   7 HPFS/NTFS

Disk /dev/sdf: 147.0 GB, 147086327808 bytes
255 heads, 63 sectors/track, 17882 cylinders, total 287277984 sectors
Units = sectors of 1 * 512 = 512 bytes

Disk /dev/sdf doesn't contain a valid partition table

Disk /dev/sdg: 7816 MB, 7816081408 bytes
241 heads, 62 sectors/track, 1021 cylinders, total 15265784 sectors
Units = sectors of 1 * 512 = 512 bytes

   Device Boot      Start         End      Blocks  Id System
/dev/sdg1   ?   778135908  1919645538   570754815+ 72 Unknown
Partition 1 has different physical/logical beginnings (non-Linux?):
     phys=(357, 116, 40) logical=(52077, 22, 11)
Partition 1 has different physical/logical endings:
     phys=(357, 32, 45) logical=(128473, 31, 51)
Partition 1 does not end on cylinder boundary
/dev/sdg2   ?   168689522  2104717761   968014120  65 Unknown
Partition 2 has different physical/logical beginnings (non-Linux?):
     phys=(288, 115, 43) logical=(11289, 149, 47)
Partition 2 has different physical/logical endings:
     phys=(367, 114, 50) logical=(140859, 41, 42)
Partition 2 does not end on cylinder boundary
/dev/sdg3   ?  1869881465  3805909656   968014096  79 Unknown
Partition 3 has different physical/logical beginnings (non-Linux?):
     phys=(366, 32, 33) logical=(125142, 156, 30)
Partition 3 has different physical/logical endings:
     phys=(357, 32, 43) logical=(254712, 47, 39)
Partition 3 does not end on cylinder boundary
/dev/sdg4   ?  2885681152  2885736650       27749+  d Unknown
Partition 4 has different physical/logical beginnings (non-Linux?):
     phys=(372, 97, 50) logical=(193125, 119, 25)
Partition 4 has different physical/logical endings:
     phys=(0, 10, 0) logical=(193129, 50, 33)
Partition 4 does not end on cylinder boundary

Partition table entries are not in disk order

Contents of /proc/mdstat (Linux software RAID status):
Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5]
[raid4] [multipath]
md127 : inactive sdf[0](S)
      1061328 blocks super external:ddf

unused devices: <none>

Contents of /run/mdadm/map (Linux software RAID arrays):
md127 ddf 7ab254d0:fae71048:404edde9:750a8a05 /dev/md/ddf0

Contents of /etc/mdadm/mdadm.conf (Linux software RAID config file):
# mdadm.conf
#
# Please refer to mdadm.conf(5) for information about this file.
#

# by default (built-in), scan all partitions (/proc/partitions) and all
# containers for MD superblocks. alternatively, specify devices to scan, using
# wildcards if desired.
DEVICE partitions containers

# automatically tag new arrays as belonging to the local system
HOMEHOST <system>

ARRAY metadata=ddf UUID=7ab254d0:fae71048:404edde9:750a8a05
ARRAY /dev/md/MegaSR container=7ab254d0:fae71048:404edde9:750a8a05
member=0 UUID=9515a157:e69d2ad3:8427131f:92b29c7a

Long listing of /dev/md directory and /dev/md* device files (Linux
software RAID devices):
brw-rw---T    1 root     disk        9, 127 Nov 20 15:06 /dev/md127

/dev/md:
lrwxrwxrwx    1 root     root             8 Nov 20 15:06 ddf0 -> ../md127

Contents of /tbu/utility/mdadm.txt (mdadm troubleshooting data
captured when 'start-md' is executed):
mdadm - v3.3-32-g357ac10 - 20th November 2013
Output of 'mdadm --examine --scan'
ARRAY metadata=ddf UUID=7ab254d0:fae71048:404edde9:750a8a05
ARRAY /dev/md/MegaSR container=7ab254d0:fae71048:404edde9:750a8a05
member=0 UUID=9515a157:e69d2ad3:8427131f:92b29c7a
Output of 'mdadm --assemble --scan --no-degraded -v'
mdadm: looking for devices for further assembly
mdadm: no RAID superblock on /dev/sr0
mdadm: no RAID superblock on /dev/sde2
mdadm: no RAID superblock on /dev/sde1
mdadm: no RAID superblock on /dev/sdb2
mdadm: no RAID superblock on /dev/sdb1
mdadm: no RAID superblock on /dev/sda1
mdadm: no RAID superblock on /dev/sda
mdadm: /dev/sdf is identified as a member of /dev/md/ddf0, slot 4.
mdadm: /dev/sde is identified as a member of /dev/md/ddf0, slot 3.
mdadm: /dev/sdd is identified as a member of /dev/md/ddf0, slot 2.
mdadm: /dev/sdc is identified as a member of /dev/md/ddf0, slot 1.
mdadm: /dev/sdb is identified as a member of /dev/md/ddf0, slot 0.
mdadm: ignoring /dev/sdb as it reports /dev/sdf as failed
mdadm: ignoring /dev/sdc as it reports /dev/sdf as failed
mdadm: ignoring /dev/sdd as it reports /dev/sdf as failed
mdadm: ignoring /dev/sde as it reports /dev/sdf as failed
mdadm: no uptodate device for slot 0 of /dev/md/ddf0
mdadm: no uptodate device for slot 2 of /dev/md/ddf0
mdadm: no uptodate device for slot 4 of /dev/md/ddf0
mdadm: no uptodate device for slot 6 of /dev/md/ddf0
mdadm: added /dev/sdf to /dev/md/ddf0 as 4
mdadm: Container /dev/md/ddf0 has been assembled with 1 drive (out of 5)
mdadm: looking for devices for /dev/md/MegaSR
mdadm: looking in container /dev/md/ddf0
mdadm: no recogniseable superblock on /dev/sr0
mdadm: /dev/sdf has wrong uuid.
mdadm: no recogniseable superblock on /dev/sde2
mdadm: no recogniseable superblock on /dev/sde1
mdadm: /dev/sde has wrong uuid.
mdadm: /dev/sdd has wrong uuid.
mdadm: /dev/sdc has wrong uuid.
mdadm: no recogniseable superblock on /dev/sdb2
mdadm: no recogniseable superblock on /dev/sdb1
mdadm: /dev/sdb has wrong uuid.
mdadm: Cannot assemble mbr metadata on /dev/sda1
mdadm: Cannot assemble mbr metadata on /dev/sda
mdadm: looking for devices for /dev/md/MegaSR
mdadm: looking in container /dev/md/ddf0
mdadm: no recogniseable superblock on /dev/sr0
mdadm: /dev/sdf has wrong uuid.
mdadm: no recogniseable superblock on /dev/sde2
mdadm: no recogniseable superblock on /dev/sde1
mdadm: /dev/sde has wrong uuid.
mdadm: /dev/sdd has wrong uuid.
mdadm: /dev/sdc has wrong uuid.
mdadm: no recogniseable superblock on /dev/sdb2
mdadm: no recogniseable superblock on /dev/sdb1
mdadm: /dev/sdb has wrong uuid.
mdadm: Cannot assemble mbr metadata on /dev/sda1
mdadm: Cannot assemble mbr metadata on /dev/sda
Output of 'dmesg | grep md:'
md: linear personality registered for level -1
md: raid0 personality registered for level 0
md: raid1 personality registered for level 1
md: raid10 personality registered for level 10
md: raid6 personality registered for level 6
md: raid5 personality registered for level 5
md: raid4 personality registered for level 4
md: multipath personality registered for level -4
md: md127 stopped.
md: bind<sdf>

Contents of /dev/mapper directory:
crw------T    1 root     root       10, 236 Nov 20 15:05 control

startraid mode = null (default)

Contents of /tbu/utility/dmraid-boot.txt file (from activate command on boot):
NOTICE: checking format identifier asr
NOTICE: checking format identifier hpt37x
NOTICE: checking format identifier hpt45x
NOTICE: checking format identifier jmicron
NOTICE: checking format identifier lsi
NOTICE: checking format identifier nvidia
NOTICE: checking format identifier pdc
NOTICE: checking format identifier sil
NOTICE: checking format identifier via
NOTICE: checking format identifier dos
WARN: locking /var/lock/dmraid/.lock
NOTICE: /dev/sdf: asr     discovering
NOTICE: /dev/sdf: hpt37x  discovering
NOTICE: /dev/sdf: hpt45x  discovering
NOTICE: /dev/sdf: jmicron discovering
NOTICE: /dev/sdf: lsi     discovering
NOTICE: /dev/sdf: nvidia  discovering
NOTICE: /dev/sdf: pdc     discovering
NOTICE: /dev/sdf: sil     discovering
NOTICE: /dev/sdf: via     discovering
NOTICE: /dev/sde: asr     discovering
NOTICE: /dev/sde: hpt37x  discovering
NOTICE: /dev/sde: hpt45x  discovering
NOTICE: /dev/sde: jmicron discovering
NOTICE: /dev/sde: lsi     discovering
NOTICE: /dev/sde: nvidia  discovering
NOTICE: /dev/sde: pdc     discovering
NOTICE: /dev/sde: sil     discovering
NOTICE: /dev/sde: via     discovering
NOTICE: /dev/sdd: asr     discovering
NOTICE: /dev/sdd: hpt37x  discovering
NOTICE: /dev/sdd: hpt45x  discovering
NOTICE: /dev/sdd: jmicron discovering
NOTICE: /dev/sdd: lsi     discovering
NOTICE: /dev/sdd: nvidia  discovering
NOTICE: /dev/sdd: pdc     discovering
NOTICE: /dev/sdd: sil     discovering
NOTICE: /dev/sdd: via     discovering
NOTICE: /dev/sdc: asr     discovering
NOTICE: /dev/sdc: hpt37x  discovering
NOTICE: /dev/sdc: hpt45x  discovering
NOTICE: /dev/sdc: jmicron discovering
NOTICE: /dev/sdc: lsi     discovering
NOTICE: /dev/sdc: nvidia  discovering
NOTICE: /dev/sdc: pdc     discovering
NOTICE: /dev/sdc: sil     discovering
NOTICE: /dev/sdc: via     discovering
NOTICE: /dev/sdb: asr     discovering
NOTICE: /dev/sdb: hpt37x  discovering
NOTICE: /dev/sdb: hpt45x  discovering
NOTICE: /dev/sdb: jmicron discovering
NOTICE: /dev/sdb: lsi     discovering
NOTICE: /dev/sdb: nvidia  discovering
NOTICE: /dev/sdb: pdc     discovering
NOTICE: /dev/sdb: sil     discovering
NOTICE: /dev/sdb: via     discovering
NOTICE: /dev/sda: asr     discovering
NOTICE: /dev/sda: hpt37x  discovering
NOTICE: /dev/sda: hpt45x  discovering
NOTICE: /dev/sda: jmicron discovering
NOTICE: /dev/sda: lsi     discovering
NOTICE: /dev/sda: nvidia  discovering
NOTICE: /dev/sda: pdc     discovering
NOTICE: /dev/sda: sil     discovering
NOTICE: /dev/sda: via     discovering
no raid disks with format:
"asr,hpt37x,hpt45x,jmicron,lsi,nvidia,pdc,sil,via,dos"
WARN: unlocking /var/lock/dmraid/.lock

Output of dmraid --raid_devices command:
/dev/sdf: ddf1, ".ddf1_disks", GROUP, unknown, 285155328 sectors, data@ 0
/dev/sde: ddf1, ".ddf1_disks", GROUP, ok, 285155328 sectors, data@ 0
/dev/sdd: ddf1, ".ddf1_disks", GROUP, ok, 285155328 sectors, data@ 0
/dev/sdc: ddf1, ".ddf1_disks", GROUP, ok, 285155328 sectors, data@ 0
/dev/sdb: ddf1, ".ddf1_disks", GROUP, ok, 285155328 sectors, data@ 0

Output of dmraid -s -s command:
*** Group superset .ddf1_disks
--> Subset
name   : ddf1_MegaSR   R5 #0
size   : 855465984
stride : 128
type   : raid5_ls
status : ok
subsets: 0
devs   : 4
spares : 0

Output of blkid command:
/dev/sda1: LABEL="Elements" UUID="DA1CE6D71CE6AE27" TYPE="ntfs"
/dev/sdc: UUID="LSI     M-^@M-^F^]h^Q7" TYPE="ddf_raid_member"
/dev/sdd: UUID="LSI     M-^@M-^F^]h^Q7" TYPE="ddf_raid_member"
/dev/sdf: UUID="LSI     M-^@M-^F^]h^Q7" TYPE="ddf_raid_member"
/dev/sdg: LABEL="CS SUPPORT" UUID="4CC3-3665" TYPE="vfat"
/dev/sr0: LABEL="iflnet" TYPE="iso9660"

Output of free command (memory):

             total       used       free     shared    buffers     cached
Mem:       2039280     185052    1854228          0      40996      77220
-/+ buffers/cache:      66836    1972444
Swap:            0          0          0

Output of lsmod command (loaded modules):

Module                  Size  Used by    Not tainted
sr_mod                 10387  0
cdrom                  24577  1 sr_mod
sg                     17182  0
sd_mod                 25922  1
crc_t10dif               996  1 sd_mod
usb_storage            32098  0
hid_generic              665  0
usbhid                 18838  0
hid                    60174  2 hid_generic,usbhid
pcspkr                  1227  0
isci                   71218  1
i2c_i801                7257  0
libsas                 47529  1 isci
scsi_transport_sas     16455  2 isci,libsas
igb                    98565  0
i2c_algo_bit            3747  1 igb
i2c_core               13114  3 i2c_i801,igb,i2c_algo_bit
ehci_pci                2540  0
ptp                     5420  1 igb
pps_core                4544  1 ptp
processor              14951  8
thermal_sys            12739  1 processor
hwmon                    881  2 igb,thermal_sys
button                  3413  0
dm_mod                 50912  0
ehci_hcd               28628  1 ehci_pci
edd                     5144  0

Contents of /sys/module:
8250                i2c_algo_bit        ptp                 speakup_dtlk
acpi                i2c_core            raid1               speakup_dummy
auth_rpcgss         i2c_i801            raid10              speakup_keypc
block               i8042               random              speakup_ltlk
brd                 igb                 rcupdate            speakup_soft
button              input_polldev       rcutree             speakup_spkout
cdrom               isci                rfkill              speakup_txprt
cifs                kernel              scsi_mod            spurious
cpuidle             keyboard            scsi_transport_fc   sr_mod
crc_t10dif          libata              scsi_transport_sas  sunrpc
dm_mod              libsas              sd_mod              tcp_cubic
dns_resolver        lockd               sg                  thermal_sys
edd                 md_mod              speakup             usb_storage
ehci_hcd            mousedev            speakup_acntpc      usbcore
ehci_pci            nfs                 speakup_acntsa      usbhid
firmware_class      pcie_aspm           speakup_apollo      vt
fuse                pcspkr              speakup_audptr      workqueue
hid                 pps_core            speakup_bns         xz_dec
hid_generic         printk              speakup_decext
hwmon               processor           speakup_dectlk
