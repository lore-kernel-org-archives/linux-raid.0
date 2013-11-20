From: "David F." <df7729@gmail.com>
Subject: Re: MDADM 3.3 broken?
Date: Tue, 19 Nov 2013 17:34:29 -0800
Message-ID: <CAGRSmLvv0-MRyKV89W4zDi57Fhx8dxEUsR+zskOQ0R-H6x4Zbw@mail.gmail.com>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGRSmLsTnc_Lood59wF88w6nECVojbeiGkdntLExLEf6ZoaF7g@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Martin Wilck <mwilck@arcor.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

And here's some more data I have for them (again they have RAID5):

Storage devices (non-RAID) detected by Linux based on /sys/block:

Optical drives (srx):
  sr0: hp       DVDRAM GT30L     (fw rev = mP06)
Removable drives (sdx):
  sdb: 7453 MiB          Patriot Memory
Fixed hard drives (sdx):
  sdc: 136 GiB TOSHIBA  MK1401GRRB
  sdd: 136 GiB TOSHIBA  MK1401GRRB
  sde: 136 GiB TOSHIBA  MK1401GRRB
  sdf: 136 GiB TOSHIBA  MK1401GRRB
  sdg: 136 GiB TOSHIBA  MK1401GRRB

Contents of /sys/block:
md127  ram0   ram1   sdb    sdc    sdd    sde    sdf    sdg    sr0

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
dvdrw               sdb                 tty22               tty6
dvdrw1              sdb1                tty23               tty60
fd                  sdc                 tty24               tty61
full                sdc1                tty25               tty62
fuse                sdc2                tty26               tty63
hidraw0             sdd                 tty27               tty7
hidraw1             sde                 tty28               tty8
hidraw2             sdf                 tty29               tty9
hidraw3             sdf1                tty3                ttyS0
hidraw4             sdf2                tty30               ttyS1
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

   8       32  143638992 sdc
   8       33     102400 sdc1
   8       34  143535568 sdc2
   8       48  143638992 sdd
   8       64  143638992 sde
   8       80  143638992 sdf
   8       81     102400 sdf1
   8       82  143535568 sdf2
   8       96  143638992 sdg
  11        0      48160 sr0
   8       16    7632892 sdb

Disk /dev/sdc: 147.0 GB, 147086327808 bytes
255 heads, 63 sectors/track, 17882 cylinders, total 287277984 sectors
Units = sectors of 1 * 512 = 512 bytes

   Device Boot      Start         End      Blocks  Id System
/dev/sdc1   *        2048      206847      102400   7 HPFS/NTFS
Partition 1 does not end on cylinder boundary
/dev/sdc2          206848   855463935   427628544   7 HPFS/NTFS

Disk /dev/sdd: 147.0 GB, 147086327808 bytes
255 heads, 63 sectors/track, 17882 cylinders, total 287277984 sectors
Units = sectors of 1 * 512 = 512 bytes

Disk /dev/sdd doesn't contain a valid partition table

Disk /dev/sde: 147.0 GB, 147086327808 bytes
255 heads, 63 sectors/track, 17882 cylinders, total 287277984 sectors
Units = sectors of 1 * 512 = 512 bytes

Disk /dev/sde doesn't contain a valid partition table

Disk /dev/sdf: 147.0 GB, 147086327808 bytes
255 heads, 63 sectors/track, 17882 cylinders, total 287277984 sectors
Units = sectors of 1 * 512 = 512 bytes

   Device Boot      Start         End      Blocks  Id System
/dev/sdf1   *        2048      206847      102400   7 HPFS/NTFS
Partition 1 does not end on cylinder boundary
/dev/sdf2          206848   855463935   427628544   7 HPFS/NTFS

Disk /dev/sdg: 147.0 GB, 147086327808 bytes
255 heads, 63 sectors/track, 17882 cylinders, total 287277984 sectors
Units = sectors of 1 * 512 = 512 bytes

Disk /dev/sdg doesn't contain a valid partition table

Disk /dev/sdb: 7816 MB, 7816081408 bytes
241 heads, 62 sectors/track, 1021 cylinders, total 15265784 sectors
Units = sectors of 1 * 512 = 512 bytes

   Device Boot      Start         End      Blocks  Id System
/dev/sdb1   ?   778135908  1919645538   570754815+ 72 Unknown
Partition 1 has different physical/logical beginnings (non-Linux?):
     phys=(357, 116, 40) logical=(52077, 22, 11)
Partition 1 has different physical/logical endings:
     phys=(357, 32, 45) logical=(128473, 31, 51)
Partition 1 does not end on cylinder boundary
/dev/sdb2   ?   168689522  2104717761   968014120  65 Unknown
Partition 2 has different physical/logical beginnings (non-Linux?):
     phys=(288, 115, 43) logical=(11289, 149, 47)
Partition 2 has different physical/logical endings:
     phys=(367, 114, 50) logical=(140859, 41, 42)
Partition 2 does not end on cylinder boundary
/dev/sdb3   ?  1869881465  3805909656   968014096  79 Unknown
Partition 3 has different physical/logical beginnings (non-Linux?):
     phys=(366, 32, 33) logical=(125142, 156, 30)
Partition 3 has different physical/logical endings:
     phys=(357, 32, 43) logical=(254712, 47, 39)
Partition 3 does not end on cylinder boundary
/dev/sdb4   ?  2885681152  2885736650       27749+  d Unknown
Partition 4 has different physical/logical beginnings (non-Linux?):
     phys=(372, 97, 50) logical=(193125, 119, 25)
Partition 4 has different physical/logical endings:
     phys=(0, 10, 0) logical=(193129, 50, 33)
Partition 4 does not end on cylinder boundary

Partition table entries are not in disk order

Contents of /proc/mdstat (Linux software RAID status):
Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5]
[raid4] [multipath]
md127 : inactive sdg[0](S)
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
ARRAY container=7ab254d0:fae71048:404edde9:750a8a05 member=0
UUID=45b3ab73:5c998afc:01bbf815:12660984

Long listing of /dev/md directory and /dev/md* device files (Linux
software RAID devices):
brw-rw---T    1 root     disk        9, 127 Nov 18 17:12 /dev/md127

/dev/md:
lrwxrwxrwx    1 root     root             8 Nov 18 17:12 ddf0 -> ../md127

Contents of /dev/mapper directory:
crw------T    1 root     root       10, 236 Nov 18 17:12 control

startraid mode = null (default)

Contents of dmraid-boot.txt file (from activate command on boot):
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
NOTICE: skipping removable device /dev/sda
NOTICE: /dev/sdg: asr     discovering
NOTICE: /dev/sdg: hpt37x  discovering
NOTICE: /dev/sdg: hpt45x  discovering
NOTICE: /dev/sdg: jmicron discovering
NOTICE: /dev/sdg: lsi     discovering
NOTICE: /dev/sdg: nvidia  discovering
NOTICE: /dev/sdg: pdc     discovering
NOTICE: /dev/sdg: sil     discovering
NOTICE: /dev/sdg: via     discovering
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
no raid disks with format:
"asr,hpt37x,hpt45x,jmicron,lsi,nvidia,pdc,sil,via,dos"
WARN: unlocking /var/lock/dmraid/.lock

Output of dmraid --raid_devices command:
/dev/sdg: ddf1, ".ddf1_disks", GROUP, unknown, 285155328 sectors, data@ 0
/dev/sdf: ddf1, ".ddf1_disks", GROUP, ok, 285155328 sectors, data@ 0
/dev/sde: ddf1, ".ddf1_disks", GROUP, ok, 285155328 sectors, data@ 0
/dev/sdd: ddf1, ".ddf1_disks", GROUP, ok, 285155328 sectors, data@ 0
/dev/sdc: ddf1, ".ddf1_disks", GROUP, ok, 285155328 sectors, data@ 0

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
/dev/sdd: UUID="LSI     M-^@M-^F^]h^Q7" TYPE="ddf_raid_member"
/dev/sde: UUID="LSI     M-^@M-^F^]h^Q7" TYPE="ddf_raid_member"
/dev/sr0: LABEL="iflnet" TYPE="iso9660"
/dev/sdg: UUID="LSI     M-^@M-^F^]h^Q7" TYPE="ddf_raid_member"
/dev/sdb: LABEL="CS SUPPORT" UUID="4CC3-3665" TYPE="vfat"

Output of free command (memory):

             total       used       free     shared    buffers     cached
Mem:       2039280     185776    1853504          0      40996      76512
-/+ buffers/cache:      68268    1971012
Swap:            0          0          0

Output of lsmod command (loaded modules):

Module                  Size  Used by    Not tainted
sr_mod                 10387  0
cdrom                  24577  1 sr_mod
sg                     17182  0
sd_mod                 25922  2
crc_t10dif               996  1 sd_mod
usb_storage            32002  1
hid_generic              665  0
usbhid                 18838  0
hid                    60158  2 hid_generic,usbhid
pcspkr                  1227  0
igb                    98565  0
i2c_algo_bit            3747  1 igb
ptp                     5420  1 igb
pps_core                4544  1 ptp
i2c_i801                7257  0
i2c_core               13114  3 igb,i2c_algo_bit,i2c_i801
ehci_pci                2540  0
isci                   71218  1
libsas                 47529  1 isci
processor              14951  8
thermal_sys            12739  1 processor
scsi_transport_sas     16455  2 isci,libsas
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

On Tue, Nov 19, 2013 at 5:29 PM, David F. <df7729@gmail.com> wrote:
> Hi,
>
> Yes, it's in this thread already - but I'll repost here:
>
> For cisco's server:
>
>> mdadm --examine --scan
> ARRAY metadata=ddf UUID=7ab254d0:fae71048:
> 404edde9:750a8a05
> ARRAY container=7ab254d0:fae71048:404edde9:750a8a05 member=0
> UUID=5337ab03:86ca2abc:d42bfbc8:23626c78
>
>> mdadm --assemble --scan --no-degraded -v
> mdadm: looking for devices for further assembly
> mdadm: /dev/md/ddf0 is a container, but we are looking for components
> mdadm: no RAID superblock on /dev/sdf
> mdadm: no RAID superblock on /dev/md/MegaSR2
> mdadm: no RAID superblock on /dev/md/MegaSR1
> mdadm: no RAID superblock on /dev/md/MegaSR
> mdadm: cannot open device /dev/sr0: No medium found
> mdadm: /dev/sdd is busy - skipping
> mdadm: /dev/sdc is busy - skipping
> mdadm: /dev/sdb is busy - skipping
> mdadm: /dev/sda is busy - skipping
> mdadm: /dev/sde is busy - skipping
> mdadm: looking for devices for further assembly
> mdadm: looking in container /dev/md/ddf0
> mdadm: member /md127/0 in /dev/md/ddf0 is already assembled
> mdadm: Cannot assemble mbr metadata on /dev/sdf
> mdadm: Cannot assemble mbr metadata on /dev/md/MegaSR2
> mdadm: Cannot assemble mbr metadata on /dev/md/MegaSR1
> mdadm: Cannot assemble mbr metadata on /dev/md/MegaSR
> mdadm: cannot open device /dev/sr0: No medium found
> mdadm: /dev/sdd has wrong uuid.
> mdadm: /dev/sdc has wrong uuid.
> mdadm: /dev/sdb has wrong uuid.
> mdadm: /dev/sda has wrong uuid.
> mdadm: /dev/sde has wrong uuid.
>
>
>
>
> On Tue, Nov 19, 2013 at 4:48 PM, NeilBrown <neilb@suse.de> wrote:
>> On Tue, 19 Nov 2013 16:35:44 -0800 "David F." <df7729@gmail.com> wrote:
>>>
>>> Also, was Cisco's information useful for why their cisco server (using
>>> lsi)  RAID5 won't assembly?  Do you think the patch deals with that as
>>> well?
>>>
>>>
>>
>> You did say something about Cisco in the original post but it wasn't at all
>> clear what you were asking or what the context was.
>>
>> Could you please spell it all out.  You said something about dmraid reporting
>> something.  Showing the output of dmraid in that case wouldn't hurt.
>> And show the output of "mdadm --examine /dev/device" for any relevant device
>> is often a good idea.
>>
>> NeilBrown
