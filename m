From: Norbert Preining <preining@logic.at>
Subject: md raid oops on 2.4.25/alpha
Date: Sun, 28 Mar 2004 18:02:46 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040328160246.GA19965@gamma.logic.tuwien.ac.at>
References: <20031027141358.GA26271@gamma.logic.tuwien.ac.at> <20040327164153.GA7324@gamma.logic.tuwien.ac.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20040327164153.GA7324@gamma.logic.tuwien.ac.at>
To: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, mingo@redhat.com, neilb@cse.unsw.edu.au
List-Id: linux-raid.ids

Hi Ingo, hi Neil, hi lists!

We have some problems with the md code on alpha. We get regular oops
when using the md raid1. Here we got another oops when fsck (at boot=20
time) the raid:
This was after a fresh reboot. As long as only the raid is *not* mounte=
d
of fsck the machine works without any oops.

I also can mount the hard disks *without* raid directly as hda1 and
hdc1, and do NOT get any errors here, so I suspect that only the md cod=
e
is the culprit.

Please tell me how I can track down this problem, how I can help you!

ksymoops 2.4.5 on alpha 2.4.25.  Options used
     -V (default)
     -k /proc/ksyms (default)
     -l /proc/modules (default)
     -o /lib/modules/2.4.25/ (default)
     -m /boot/System.map-2.4.25 (default)

Warning: You did not tell me where to find symbol information.  I will
assume that the log matches the kernel and modules that are running
right now and I'll use the default options above for symbol resolution.
If the current kernel and/or modules do not match the log, you can get
more accurate output by telling me the kernel version and where to find
map, modules, ksyms etc.  ksymoops -h explains the options.

No modules in ksyms, skipping objects
Warning (read_lsmod): no symbols in lsmod, is /proc/modules a valid lsm=
od file?
Unable to handle kernel paging request at virtual address 0000440004c9c=
0fc
fsck.ext2(59): Oops 0
pc =3D [<fffffc00004a8aa4>]  ra =3D [<fffffc00004a8d7c>]  ps =3D 0000  =
  Not tainted
Using defaults from ksymoops -t elf64-alpha -a alpha
v0 =3D 0000000000000000  t0 =3D 0000000000000000  t1 =3D 0000440004c9c0=
f8
t2 =3D 0000440004c9c0fc  t3 =3D 0000000000000001  t4 =3D 0000480004a7b1=
00
t5 =3D fffffc000022101c  t6 =3D 0000000000000000  t7 =3D fffffc000f9500=
00
s0 =3D fffffc000f76b820  s1 =3D 0000000000000900  s2 =3D fffffc00002210=
00
s3 =3D fffffc000f76b820  s4 =3D fffffc000fe950c0  s5 =3D 00000000000000=
00
s6 =3D fffffc000098d8a0
a0 =3D fffffc0000221000  a1 =3D fffffc000f76b820  a2 =3D fffffc000f76b8=
20
a3 =3D 0000000000000000  a4 =3D 0000000000000002  a5 =3D 000000011ffffd=
20
t8 =3D 0000000000000000  t9 =3D 0000480004a7b120  t10=3D fffffc00002210=
18
t11=3D 0000020000211a40  pv =3D fffffc00004a8ba0  at =3D 00000000000000=
01
gp =3D fffffc000062fbe8  sp =3D fffffc000f953c08
Trace:fffffc00004ab950 fffffc0000356f40 fffffc000043fba4 fffffc000043fc=
ac fffffc0000358f00 fffffc0000356f40 fffffc000035dec0 fffffc000034a928 =
fffffc000035dda0 fffffc00003203c8 fffffc000033ed64 fffffc000033f4ac fff=
ffc000033f320 fffffc00003541cc fffffc0000310c40=20
Code: a09003d8  40803124  40449522  40649523  408705a1  f4200033 <a0230=
000> 2ffe0000=20


>>RA;  fffffc00004a8d7c <raid1_make_request+1dc/480>

>>PC;  fffffc00004a8aa4 <raid1_read_balance+104/200>   <=3D=3D=3D=3D=3D

Trace; fffffc00004ab950 <md_make_request+90/120>
Trace; fffffc0000356f40 <end_buffer_io_async+0/160>
Trace; fffffc000043fba4 <generic_make_request+204/240>
Trace; fffffc000043fcac <submit_bh+cc/1e0>
Trace; fffffc0000358f00 <block_read_full_page+340/3a0>
Trace; fffffc0000356f40 <end_buffer_io_async+0/160>
Trace; fffffc000035dec0 <blkdev_readpage+20/40>
Trace; fffffc000034a928 <_alloc_pages+28/40>
Trace; fffffc000035dda0 <blkdev_get_block+0/80>
Trace; fffffc00003203c8 <do_page_fault+228/560>
Trace; fffffc000033ed64 <do_generic_file_read+364/600>
Trace; fffffc000033f4ac <generic_file_read+ac/260>
Trace; fffffc000033f320 <file_read_actor+0/e0>
Trace; fffffc00003541cc <sys_read+ec/1c0>
Trace; fffffc0000310c40 <entSys+a8/c0>

Code;  fffffc00004a8a8c <raid1_read_balance+ec/200>
0000000000000000 <_PC>:
Code;  fffffc00004a8a8c <raid1_read_balance+ec/200>
   0:   d8 03 90 a0       ldl  t3,984(a0)
Code;  fffffc00004a8a90 <raid1_read_balance+f0/200>
   4:   24 31 80 40       subl t3,0x1,t3
Code;  fffffc00004a8a94 <raid1_read_balance+f4/200>
   8:   22 95 44 40       subq t1,0x24,t1
Code;  fffffc00004a8a98 <raid1_read_balance+f8/200>
   c:   23 95 64 40       subq t2,0x24,t2
Code;  fffffc00004a8a9c <raid1_read_balance+fc/200>
  10:   a1 05 87 40       cmpeq        t3,t6,t0
Code;  fffffc00004a8aa0 <raid1_read_balance+100/200>
  14:   33 00 20 f4       bne  t0,e4 <_PC+0xe4> fffffc00004a8b70 <raid1=
_read_balance+1d0/200>
Code;  fffffc00004a8aa4 <raid1_read_balance+104/200>   <=3D=3D=3D=3D=3D
  18:   00 00 23 a0       ldl  t0,0(t2)   <=3D=3D=3D=3D=3D
Code;  fffffc00004a8aa8 <raid1_read_balance+108/200>
  1c:   00 00 fe 2f       unop=20


2 warnings issued.  Results may not be reliable.




On Sam, 27 M=E4r 2004, preining wrote:
> HI list!
>=20
> We regularly experience kernel Ooops on our alpha SX164 with ext3 on =
md
> on ide controller:
>=20
> No modules loaded, lsmod empty, self compiled kernel
>=20
>=20
> ksymoops 2.4.5 on alpha 2.4.25.  Options used
>      -V (default)
>      -k /proc/ksyms (default)
>      -l /proc/modules (default)
>      -o /lib/modules/2.4.25/ (default)
>      -m /boot/System.map-2.4.25 (default)
>=20
> Warning: You did not tell me where to find symbol information.  I wil=
l
> assume that the log matches the kernel and modules that are running
> right now and I'll use the default options above for symbol resolutio=
n.
> If the current kernel and/or modules do not match the log, you can ge=
t
> more accurate output by telling me the kernel version and where to fi=
nd
> map, modules, ksyms etc.  ksymoops -h explains the options.
>=20
> No modules in ksyms, skipping objects
> Warning (read_lsmod): no symbols in lsmod, is /proc/modules a valid l=
smod file?
> Mar 27 06:33:36 beta kernel: Unable to handle kernel paging request a=
t virtual address 0000440003af267c
> Mar 27 06:33:36 beta kernel: find(826): Oops 0
> Mar 27 06:33:36 beta kernel: pc =3D [raid1_read_balance+384/512]  ra =
=3D [raid1_make_request+476/1152]  ps =3D 0000    Not tainted
> Mar 27 06:33:36 beta kernel: v0 =3D 0000000000001068  t0 =3D ffffffff=
fff7fff0  t1 =3D 0000000000080010
> Mar 27 06:33:36 beta kernel: t2 =3D 0000440003af269c  t3 =3D 00000000=
00000000  t4 =3D 0000440003af267c
> Mar 27 06:33:36 beta kernel: t5 =3D 0000440003af2674  t6 =3D 00000000=
00000002  t7 =3D fffffc000ec04000
> Mar 27 06:33:36 beta kernel: s0 =3D fffffc000cb419c0  s1 =3D 00000000=
00000900  s2 =3D fffffc0000221000
> Mar 27 06:33:36 beta kernel: s3 =3D fffffc000cb419c0  s4 =3D fffffc00=
0fe94cc0  s5 =3D 0000000000000000
> Mar 27 06:33:36 beta kernel: s6 =3D fffffc000098d8a0
> Mar 27 06:33:36 beta kernel: a0 =3D fffffc0000221000  a1 =3D fffffc00=
0cb419c0  a2 =3D fffffc000cb419c0
> Mar 27 06:33:36 beta kernel: a3 =3D 0000000000001000  a4 =3D 00000000=
00000008  a5 =3D fffffc0000221018
> Mar 27 06:33:36 beta kernel: t8 =3D 0000000000000000  t9 =3D 00004800=
038d1680  t10=3D 0000000000080010
> Mar 27 06:33:36 beta kernel: t11=3D fffffc0000221020  pv =3D fffffc00=
004a8ba0  at =3D fffffc000022101c
> Mar 27 06:33:36 beta kernel: gp =3D fffffc000062fbe8  sp =3D fffffc00=
0ec07c18
> Mar 27 06:33:36 beta kernel: Trace:fffffc00004ab950 fffffc0000355ba0 =
fffffc0000392abc fffffc000043fba4 fffffc000043fcac fffffc000044000c fff=
ffc0000355ba0 fffffc0000392b04 fffffc000036b5e0 fffffc000038ee28 fffffc=
000036ac28 fffffc000036b5e0 fffffc000036489c fffffc00003648f8 fffffc000=
03634b4 fffffc000036b5e0 fffffc000036b808 fffffc0000310c40=20
> Mar 27 06:33:36 beta kernel: Code: 42fc0403  2ffe0000  42f90405  a0f0=
03d8  40a49525  40c49526 <a0250000> 40649523=20
> Using defaults from ksymoops -t elf64-alpha -a alpha
>=20
>=20
> Trace; fffffc00004ab950 <md_make_request+90/120>
> Trace; fffffc0000355ba0 <end_buffer_io_sync+0/80>
> Trace; fffffc0000392abc <ext3_bread+1c/e0>
> Trace; fffffc000043fba4 <generic_make_request+204/240>
> Trace; fffffc000043fcac <submit_bh+cc/1e0>
> Trace; fffffc000044000c <ll_rw_block+24c/320>
> Trace; fffffc0000355ba0 <end_buffer_io_sync+0/80>
> Trace; fffffc0000392b04 <ext3_bread+64/e0>
> Trace; fffffc000036b5e0 <filldir64+0/1c0>
> Trace; fffffc000038ee28 <ext3_readdir+a8/4c0>
> Trace; fffffc000036ac28 <vfs_readdir+e8/1c0>
> Trace; fffffc000036b5e0 <filldir64+0/1c0>
> Trace; fffffc000036489c <link_path_walk+d7c/dc0>
> Trace; fffffc00003648f8 <path_walk+18/40>
> Trace; fffffc00003634b4 <permission+34/40>
> Trace; fffffc000036b5e0 <filldir64+0/1c0>
> Trace; fffffc000036b808 <sys_getdents64+68/120>
> Trace; fffffc0000310c40 <entSys+a8/c0>
>=20
> Code;  ffffffffffffffe8 <END_OF_CODE+3ffff98e430/????>
> 0000000000000000 <_PC>:
> Code;  ffffffffffffffe8 <END_OF_CODE+3ffff98e430/????>
>    0:   03 04 fc 42       addq t9,at,t2
> Code;  ffffffffffffffec <END_OF_CODE+3ffff98e434/????>
>    4:   00 00 fe 2f       unop=20
> Code;  fffffffffffffff0 <END_OF_CODE+3ffff98e438/????>
>    8:   05 04 f9 42       addq t9,t11,t4
> Code;  fffffffffffffff4 <END_OF_CODE+3ffff98e43c/????>
>    c:   d8 03 f0 a0       ldl  t6,984(a0)
> Code;  fffffffffffffff8 <END_OF_CODE+3ffff98e440/????>
>   10:   25 95 a4 40       subq t4,0x24,t4
> Code;  fffffffffffffffc <END_OF_CODE+3ffff98e444/????>
>   14:   26 95 c4 40       subq t5,0x24,t5
> Code;  0000000000000000 Before first symbol
>   18:   00 00 25 a0       ldl  t0,0(t4)
> Code;  0000000000000004 Before first symbol
>   1c:   23 95 64 40       subq t2,0x24,t2
>=20
>=20
> 2 warnings issued.  Results may not be reliable.
>=20
>=20
> Can you help us with this oops and how to fix it?
>=20
> Attached is the config file and the output of dmesg.
>=20

> #
> # Automatically generated make config: don't edit
> #
> CONFIG_ALPHA=3Dy
> # CONFIG_UID16 is not set
> # CONFIG_RWSEM_GENERIC_SPINLOCK is not set
> CONFIG_RWSEM_XCHGADD_ALGORITHM=3Dy
>=20
> #
> # Code maturity level options
> #
> CONFIG_EXPERIMENTAL=3Dy
>=20
> #
> # Loadable module support
> #
> CONFIG_MODULES=3Dy
> # CONFIG_MODVERSIONS is not set
> CONFIG_KMOD=3Dy
>=20
> #
> # General setup
> #
> # CONFIG_ALPHA_GENERIC is not set
> # CONFIG_ALPHA_ALCOR is not set
> # CONFIG_ALPHA_XL is not set
> # CONFIG_ALPHA_BOOK1 is not set
> # CONFIG_ALPHA_AVANTI is not set
> # CONFIG_ALPHA_CABRIOLET is not set
> # CONFIG_ALPHA_DP264 is not set
> # CONFIG_ALPHA_EB164 is not set
> # CONFIG_ALPHA_EB64P is not set
> # CONFIG_ALPHA_EB66 is not set
> # CONFIG_ALPHA_EB66P is not set
> # CONFIG_ALPHA_EIGER is not set
> # CONFIG_ALPHA_JENSEN is not set
> # CONFIG_ALPHA_LX164 is not set
> # CONFIG_ALPHA_LYNX is not set
> # CONFIG_ALPHA_MARVEL is not set
> # CONFIG_ALPHA_MIATA is not set
> # CONFIG_ALPHA_MIKASA is not set
> # CONFIG_ALPHA_NAUTILUS is not set
> # CONFIG_ALPHA_NONAME is not set
> # CONFIG_ALPHA_NORITAKE is not set
> # CONFIG_ALPHA_PC164 is not set
> # CONFIG_ALPHA_P2K is not set
> # CONFIG_ALPHA_RAWHIDE is not set
> # CONFIG_ALPHA_RUFFIAN is not set
> # CONFIG_ALPHA_RX164 is not set
> CONFIG_ALPHA_SX164=3Dy
> # CONFIG_ALPHA_SABLE is not set
> # CONFIG_ALPHA_SHARK is not set
> # CONFIG_ALPHA_TAKARA is not set
> # CONFIG_ALPHA_TITAN is not set
> # CONFIG_ALPHA_WILDFIRE is not set
> CONFIG_ISA=3Dy
> CONFIG_EISA=3Dy
> # CONFIG_SBUS is not set
> # CONFIG_MCA is not set
> CONFIG_PCI=3Dy
> CONFIG_ALPHA_EV5=3Dy
> CONFIG_ALPHA_EV56=3Dy
> CONFIG_ALPHA_CIA=3Dy
> CONFIG_ALPHA_PYXIS=3Dy
> CONFIG_ALPHA_SRM=3Dy
> CONFIG_VERBOSE_MCHECK=3Dy
> CONFIG_EARLY_PRINTK=3Dy
> # CONFIG_DISCONTIGMEM is not set
> # CONFIG_ALPHA_LARGE_VMALLOC is not set
> CONFIG_PCI_NAMES=3Dy
> # CONFIG_HOTPLUG is not set
> # CONFIG_PCMCIA is not set
> CONFIG_NET=3Dy
> CONFIG_SYSVIPC=3Dy
> # CONFIG_BSD_PROCESS_ACCT is not set
> CONFIG_SYSCTL=3Dy
> CONFIG_KCORE_ELF=3Dy
> # CONFIG_KCORE_AOUT is not set
> CONFIG_SRM_ENV=3Dy
> CONFIG_BINFMT_AOUT=3Dm
> # CONFIG_OSF4_COMPAT is not set
> CONFIG_BINFMT_ELF=3Dy
> CONFIG_BINFMT_MISC=3Dm
> CONFIG_BINFMT_EM86=3Dy
>=20
> #
> # Parallel port support
> #
> # CONFIG_PARPORT is not set
>=20
> #
> # Memory Technology Devices (MTD)
> #
> # CONFIG_MTD is not set
>=20
> #
> # Plug and Play configuration
> #
> # CONFIG_PNP is not set
> # CONFIG_ISAPNP is not set
>=20
> #
> # Block devices
> #
> CONFIG_BLK_DEV_FD=3Dy
> # CONFIG_BLK_DEV_XD is not set
> # CONFIG_PARIDE is not set
> # CONFIG_BLK_CPQ_DA is not set
> # CONFIG_BLK_CPQ_CISS_DA is not set
> # CONFIG_CISS_SCSI_TAPE is not set
> # CONFIG_CISS_MONITOR_THREAD is not set
> # CONFIG_BLK_DEV_DAC960 is not set
> # CONFIG_BLK_DEV_UMEM is not set
> CONFIG_BLK_DEV_LOOP=3Dm
> # CONFIG_BLK_DEV_NBD is not set
> CONFIG_BLK_DEV_RAM=3Dm
> CONFIG_BLK_DEV_RAM_SIZE=3D8192
> # CONFIG_BLK_DEV_INITRD is not set
> # CONFIG_BLK_STATS is not set
>=20
> #
> # Multi-device support (RAID and LVM)
> #
> CONFIG_MD=3Dy
> CONFIG_BLK_DEV_MD=3Dy
> CONFIG_MD_LINEAR=3Dy
> CONFIG_MD_RAID0=3Dy
> CONFIG_MD_RAID1=3Dy
> CONFIG_MD_RAID5=3Dm
> # CONFIG_MD_MULTIPATH is not set
> # CONFIG_BLK_DEV_LVM is not set
>=20
> #
> # Networking options
> #
> CONFIG_PACKET=3Dy
> # CONFIG_PACKET_MMAP is not set
> CONFIG_NETLINK_DEV=3Dy
> # CONFIG_NETFILTER is not set
> CONFIG_FILTER=3Dy
> CONFIG_UNIX=3Dy
> CONFIG_INET=3Dy
> # CONFIG_IP_MULTICAST is not set
> # CONFIG_IP_ADVANCED_ROUTER is not set
> # CONFIG_IP_PNP is not set
> # CONFIG_NET_IPIP is not set
> # CONFIG_NET_IPGRE is not set
> # CONFIG_ARPD is not set
> # CONFIG_INET_ECN is not set
> # CONFIG_SYN_COOKIES is not set
> # CONFIG_IPV6 is not set
> # CONFIG_KHTTPD is not set
>=20
> #
> #    SCTP Configuration (EXPERIMENTAL)
> #
> CONFIG_IPV6_SCTP__=3Dy
> # CONFIG_IP_SCTP is not set
> # CONFIG_ATM is not set
> # CONFIG_VLAN_8021Q is not set
>=20
> #
> # =20
> #
> # CONFIG_IPX is not set
> # CONFIG_ATALK is not set
>=20
> #
> # Appletalk devices
> #
> # CONFIG_DEV_APPLETALK is not set
> # CONFIG_DECNET is not set
> # CONFIG_BRIDGE is not set
> # CONFIG_X25 is not set
> # CONFIG_LAPB is not set
> # CONFIG_LLC is not set
> # CONFIG_NET_DIVERT is not set
> # CONFIG_ECONET is not set
> # CONFIG_WAN_ROUTER is not set
> # CONFIG_NET_FASTROUTE is not set
> # CONFIG_NET_HW_FLOWCONTROL is not set
>=20
> #
> # QoS and/or fair queueing
> #
> # CONFIG_NET_SCHED is not set
>=20
> #
> # Network testing
> #
> # CONFIG_NET_PKTGEN is not set
>=20
> #
> # ATA/IDE/MFM/RLL support
> #
> CONFIG_IDE=3Dy
> MAX_HWIFS=3D4
>=20
> #
> # IDE, ATA and ATAPI Block devices
> #
> CONFIG_BLK_DEV_IDE=3Dy
>=20
> #
> # Please see Documentation/ide.txt for help/info on IDE drives
> #
> # CONFIG_BLK_DEV_HD_IDE is not set
> # CONFIG_BLK_DEV_HD is not set
> CONFIG_BLK_DEV_IDEDISK=3Dy
> # CONFIG_IDEDISK_MULTI_MODE is not set
> # CONFIG_IDEDISK_STROKE is not set
> # CONFIG_BLK_DEV_IDECS is not set
> CONFIG_BLK_DEV_IDECD=3Dm
> CONFIG_BLK_DEV_IDETAPE=3Dm
> # CONFIG_BLK_DEV_IDEFLOPPY is not set
> CONFIG_BLK_DEV_IDESCSI=3Dm
> # CONFIG_IDE_TASK_IOCTL is not set
>=20
> #
> # IDE chipset support/bugfixes
> #
> # CONFIG_BLK_DEV_CMD640 is not set
> # CONFIG_BLK_DEV_CMD640_ENHANCED is not set
> # CONFIG_BLK_DEV_ISAPNP is not set
> CONFIG_BLK_DEV_IDEPCI=3Dy
> # CONFIG_BLK_DEV_GENERIC is not set
> CONFIG_IDEPCI_SHARE_IRQ=3Dy
> CONFIG_BLK_DEV_IDEDMA_PCI=3Dy
> CONFIG_BLK_DEV_OFFBOARD=3Dy
> # CONFIG_BLK_DEV_IDEDMA_FORCED is not set
> CONFIG_IDEDMA_PCI_AUTO=3Dy
> # CONFIG_IDEDMA_ONLYDISK is not set
> CONFIG_BLK_DEV_IDEDMA=3Dy
> # CONFIG_IDEDMA_PCI_WIP is not set
> # CONFIG_BLK_DEV_ADMA100 is not set
> # CONFIG_BLK_DEV_AEC62XX is not set
> # CONFIG_BLK_DEV_ALI15X3 is not set
> # CONFIG_WDC_ALI15X3 is not set
> # CONFIG_BLK_DEV_AMD74XX is not set
> # CONFIG_AMD74XX_OVERRIDE is not set
> CONFIG_BLK_DEV_CMD64X=3Dy
> # CONFIG_BLK_DEV_TRIFLEX is not set
> # CONFIG_BLK_DEV_CY82C693 is not set
> # CONFIG_BLK_DEV_CS5530 is not set
> # CONFIG_BLK_DEV_HPT34X is not set
> # CONFIG_HPT34X_AUTODMA is not set
> # CONFIG_BLK_DEV_HPT366 is not set
> # CONFIG_BLK_DEV_PIIX is not set
> # CONFIG_BLK_DEV_NS87415 is not set
> # CONFIG_BLK_DEV_OPTI621 is not set
> CONFIG_BLK_DEV_PDC202XX_OLD=3Dm
> # CONFIG_PDC202XX_BURST is not set
> # CONFIG_BLK_DEV_PDC202XX_NEW is not set
> # CONFIG_PDC202XX_FORCE is not set
> # CONFIG_BLK_DEV_RZ1000 is not set
> # CONFIG_BLK_DEV_SC1200 is not set
> # CONFIG_BLK_DEV_SVWKS is not set
> CONFIG_BLK_DEV_SIIMAGE=3Dy
> # CONFIG_BLK_DEV_SIS5513 is not set
> # CONFIG_BLK_DEV_SLC90E66 is not set
> # CONFIG_BLK_DEV_TRM290 is not set
> # CONFIG_BLK_DEV_VIA82CXXX is not set
> # CONFIG_IDE_CHIPSETS is not set
> CONFIG_IDEDMA_AUTO=3Dy
> # CONFIG_IDEDMA_IVB is not set
> # CONFIG_DMA_NONPCI is not set
> CONFIG_BLK_DEV_PDC202XX=3Dy
> # CONFIG_BLK_DEV_ATARAID is not set
> # CONFIG_BLK_DEV_ATARAID_PDC is not set
> # CONFIG_BLK_DEV_ATARAID_HPT is not set
> # CONFIG_BLK_DEV_ATARAID_SII is not set
>=20
> #
> # SCSI support
> #
> CONFIG_SCSI=3Dy
>=20
> #
> # SCSI support type (disk, tape, CD-ROM)
> #
> CONFIG_BLK_DEV_SD=3Dy
> CONFIG_SD_EXTRA_DEVS=3D40
> CONFIG_CHR_DEV_ST=3Dy
> # CONFIG_CHR_DEV_OSST is not set
> CONFIG_BLK_DEV_SR=3Dy
> # CONFIG_BLK_DEV_SR_VENDOR is not set
> CONFIG_SR_EXTRA_DEVS=3D2
> CONFIG_CHR_DEV_SG=3Dm
>=20
> #
> # Some SCSI devices (e.g. CD jukebox) support multiple LUNs
> #
> # CONFIG_SCSI_DEBUG_QUEUES is not set
> # CONFIG_SCSI_MULTI_LUN is not set
> # CONFIG_SCSI_CONSTANTS is not set
> CONFIG_SCSI_LOGGING=3Dy
>=20
> #
> # SCSI low-level drivers
> #
> # CONFIG_BLK_DEV_3W_XXXX_RAID is not set
> # CONFIG_SCSI_7000FASST is not set
> # CONFIG_SCSI_ACARD is not set
> # CONFIG_SCSI_AHA152X is not set
> # CONFIG_SCSI_AHA1542 is not set
> # CONFIG_SCSI_AHA1740 is not set
> # CONFIG_SCSI_AACRAID is not set
> # CONFIG_SCSI_AIC7XXX is not set
> # CONFIG_SCSI_AIC79XX is not set
> # CONFIG_SCSI_AIC7XXX_OLD is not set
> # CONFIG_SCSI_DPT_I2O is not set
> # CONFIG_SCSI_ADVANSYS is not set
> # CONFIG_SCSI_IN2000 is not set
> # CONFIG_SCSI_AM53C974 is not set
> # CONFIG_SCSI_MEGARAID is not set
> # CONFIG_SCSI_MEGARAID2 is not set
> # CONFIG_SCSI_BUSLOGIC is not set
> # CONFIG_SCSI_CPQFCTS is not set
> # CONFIG_SCSI_DMX3191D is not set
> # CONFIG_SCSI_DTC3280 is not set
> # CONFIG_SCSI_EATA is not set
> # CONFIG_SCSI_EATA_DMA is not set
> # CONFIG_SCSI_EATA_PIO is not set
> # CONFIG_SCSI_FUTURE_DOMAIN is not set
> # CONFIG_SCSI_GDTH is not set
> # CONFIG_SCSI_GENERIC_NCR5380 is not set
> # CONFIG_SCSI_INITIO is not set
> # CONFIG_SCSI_INIA100 is not set
> # CONFIG_SCSI_NCR53C406A is not set
> # CONFIG_SCSI_NCR53C7xx is not set
> # CONFIG_SCSI_SYM53C8XX_2 is not set
> # CONFIG_SCSI_NCR53C8XX is not set
> CONFIG_SCSI_SYM53C8XX=3Dy
> CONFIG_SCSI_NCR53C8XX_DEFAULT_TAGS=3D8
> CONFIG_SCSI_NCR53C8XX_MAX_TAGS=3D32
> CONFIG_SCSI_NCR53C8XX_SYNC=3D20
> # CONFIG_SCSI_NCR53C8XX_PROFILE is not set
> # CONFIG_SCSI_NCR53C8XX_IOMAPPED is not set
> # CONFIG_SCSI_NCR53C8XX_PQS_PDS is not set
> CONFIG_SCSI_NCR53C8XX_SYMBIOS_COMPAT=3Dy
> # CONFIG_SCSI_PAS16 is not set
> # CONFIG_SCSI_PCI2000 is not set
> # CONFIG_SCSI_PCI2220I is not set
> # CONFIG_SCSI_PSI240I is not set
> # CONFIG_SCSI_QLOGIC_FAS is not set
> # CONFIG_SCSI_QLOGIC_ISP is not set
> # CONFIG_SCSI_QLOGIC_FC is not set
> # CONFIG_SCSI_QLOGIC_1280 is not set
> # CONFIG_SCSI_SIM710 is not set
> # CONFIG_SCSI_SYM53C416 is not set
> # CONFIG_SCSI_DC390T is not set
> # CONFIG_SCSI_T128 is not set
> # CONFIG_SCSI_U14_34F is not set
> # CONFIG_SCSI_NSP32 is not set
> # CONFIG_SCSI_DEBUG is not set
>=20
> #
> # Fusion MPT device support
> #
> # CONFIG_FUSION is not set
> # CONFIG_FUSION_BOOT is not set
> # CONFIG_FUSION_ISENSE is not set
> # CONFIG_FUSION_CTL is not set
> # CONFIG_FUSION_LAN is not set
>=20
> #
> # IEEE 1394 (FireWire) support (EXPERIMENTAL)
> #
> # CONFIG_IEEE1394 is not set
>=20
> #
> # Network device support
> #
> CONFIG_NETDEVICES=3Dy
>=20
> #
> # ARCnet devices
> #
> # CONFIG_ARCNET is not set
> # CONFIG_DUMMY is not set
> # CONFIG_BONDING is not set
> # CONFIG_EQUALIZER is not set
> # CONFIG_TUN is not set
> # CONFIG_ETHERTAP is not set
>=20
> #
> # Ethernet (10 or 100Mbit)
> #
> CONFIG_NET_ETHERNET=3Dy
> # CONFIG_SUNLANCE is not set
> # CONFIG_HAPPYMEAL is not set
> # CONFIG_SUNBMAC is not set
> # CONFIG_SUNQE is not set
> # CONFIG_SUNGEM is not set
> # CONFIG_NET_VENDOR_3COM is not set
> # CONFIG_LANCE is not set
> # CONFIG_NET_VENDOR_SMC is not set
> # CONFIG_NET_VENDOR_RACAL is not set
> # CONFIG_AT1700 is not set
> # CONFIG_DEPCA is not set
> # CONFIG_HP100 is not set
> CONFIG_NET_ISA=3Dy
> # CONFIG_E2100 is not set
> # CONFIG_EWRK3 is not set
> # CONFIG_EEXPRESS is not set
> # CONFIG_EEXPRESS_PRO is not set
> # CONFIG_HPLAN_PLUS is not set
> # CONFIG_HPLAN is not set
> # CONFIG_LP486E is not set
> # CONFIG_ETH16I is not set
> # CONFIG_NE2000 is not set
> CONFIG_NET_PCI=3Dy
> # CONFIG_PCNET32 is not set
> # CONFIG_AMD8111_ETH is not set
> # CONFIG_ADAPTEC_STARFIRE is not set
> # CONFIG_AC3200 is not set
> # CONFIG_APRICOT is not set
> # CONFIG_B44 is not set
> # CONFIG_CS89x0 is not set
> CONFIG_TULIP=3Dy
> # CONFIG_TULIP_MWI is not set
> CONFIG_TULIP_MMIO=3Dy
> # CONFIG_DE4X5 is not set
> # CONFIG_DGRS is not set
> # CONFIG_DM9102 is not set
> # CONFIG_EEPRO100 is not set
> # CONFIG_EEPRO100_PIO is not set
> # CONFIG_E100 is not set
> # CONFIG_LNE390 is not set
> # CONFIG_FEALNX is not set
> # CONFIG_NATSEMI is not set
> # CONFIG_NE2K_PCI is not set
> # CONFIG_NE3210 is not set
> # CONFIG_ES3210 is not set
> # CONFIG_8139CP is not set
> # CONFIG_8139TOO is not set
> # CONFIG_8139TOO_PIO is not set
> # CONFIG_8139TOO_TUNE_TWISTER is not set
> # CONFIG_8139TOO_8129 is not set
> # CONFIG_8139_OLD_RX_RESET is not set
> # CONFIG_SIS900 is not set
> # CONFIG_EPIC100 is not set
> # CONFIG_SUNDANCE is not set
> # CONFIG_SUNDANCE_MMIO is not set
> # CONFIG_TLAN is not set
> # CONFIG_VIA_RHINE is not set
> # CONFIG_VIA_RHINE_MMIO is not set
> # CONFIG_WINBOND_840 is not set
> # CONFIG_NET_POCKET is not set
>=20
> #
> # Ethernet (1000 Mbit)
> #
> # CONFIG_ACENIC is not set
> # CONFIG_DL2K is not set
> # CONFIG_E1000 is not set
> # CONFIG_MYRI_SBUS is not set
> # CONFIG_NS83820 is not set
> # CONFIG_HAMACHI is not set
> # CONFIG_YELLOWFIN is not set
> # CONFIG_R8169 is not set
> # CONFIG_SK98LIN is not set
> # CONFIG_TIGON3 is not set
> # CONFIG_FDDI is not set
> # CONFIG_HIPPI is not set
> # CONFIG_PLIP is not set
> # CONFIG_PPP is not set
> # CONFIG_SLIP is not set
>=20
> #
> # Wireless LAN (non-hamradio)
> #
> # CONFIG_NET_RADIO is not set
>=20
> #
> # Token Ring devices
> #
> # CONFIG_TR is not set
> # CONFIG_NET_FC is not set
> # CONFIG_RCPCI is not set
> # CONFIG_SHAPER is not set
>=20
> #
> # Wan interfaces
> #
> # CONFIG_WAN is not set
>=20
> #
> # Amateur Radio support
> #
> # CONFIG_HAMRADIO is not set
>=20
> #
> # ISDN subsystem
> #
> # CONFIG_ISDN is not set
>=20
> #
> # Old CD-ROM drivers (not SCSI, not IDE)
> #
> # CONFIG_CD_NO_IDESCSI is not set
>=20
> #
> # Input core support
> #
> # CONFIG_INPUT is not set
> # CONFIG_INPUT_KEYBDEV is not set
> # CONFIG_INPUT_MOUSEDEV is not set
> # CONFIG_INPUT_JOYDEV is not set
> # CONFIG_INPUT_EVDEV is not set
> # CONFIG_INPUT_UINPUT is not set
>=20
> #
> # Character devices
> #
> CONFIG_VT=3Dy
> CONFIG_VT_CONSOLE=3Dy
> CONFIG_SERIAL=3Dy
> CONFIG_SERIAL_CONSOLE=3Dy
> # CONFIG_SERIAL_EXTENDED is not set
> # CONFIG_SERIAL_NONSTANDARD is not set
> CONFIG_UNIX98_PTYS=3Dy
> CONFIG_UNIX98_PTY_COUNT=3D256
>=20
> #
> # I2C support
> #
> # CONFIG_I2C is not set
>=20
> #
> # Mice
> #
> # CONFIG_BUSMOUSE is not set
> # CONFIG_MOUSE is not set
>=20
> #
> # Joysticks
> #
> # CONFIG_INPUT_GAMEPORT is not set
>=20
> #
> # Input core support is needed for gameports
> #
>=20
> #
> # Input core support is needed for joysticks
> #
> # CONFIG_QIC02_TAPE is not set
> # CONFIG_IPMI_HANDLER is not set
> # CONFIG_IPMI_PANIC_EVENT is not set
> # CONFIG_IPMI_DEVICE_INTERFACE is not set
> # CONFIG_IPMI_KCS is not set
> # CONFIG_IPMI_WATCHDOG is not set
>=20
> #
> # Watchdog Cards
> #
> # CONFIG_WATCHDOG is not set
> # CONFIG_SCx200 is not set
> # CONFIG_SCx200_GPIO is not set
> # CONFIG_AMD_PM768 is not set
> # CONFIG_NVRAM is not set
> CONFIG_RTC=3Dy
> # CONFIG_DTLK is not set
> # CONFIG_R3964 is not set
> # CONFIG_APPLICOM is not set
>=20
> #
> # Ftape, the floppy tape device driver
> #
> # CONFIG_FTAPE is not set
> # CONFIG_AGP is not set
>=20
> #
> # Direct Rendering Manager (XFree86 DRI support)
> #
> # CONFIG_DRM is not set
>=20
> #
> # Multimedia devices
> #
> # CONFIG_VIDEO_DEV is not set
>=20
> #
> # File systems
> #
> CONFIG_QUOTA=3Dy
> # CONFIG_QFMT_V2 is not set
> # CONFIG_AUTOFS_FS is not set
> # CONFIG_AUTOFS4_FS is not set
> # CONFIG_REISERFS_FS is not set
> # CONFIG_REISERFS_CHECK is not set
> # CONFIG_REISERFS_PROC_INFO is not set
> # CONFIG_ADFS_FS is not set
> # CONFIG_ADFS_FS_RW is not set
> # CONFIG_AFFS_FS is not set
> # CONFIG_HFS_FS is not set
> # CONFIG_HFSPLUS_FS is not set
> # CONFIG_BEFS_FS is not set
> # CONFIG_BEFS_DEBUG is not set
> # CONFIG_BFS_FS is not set
> CONFIG_EXT3_FS=3Dy
> CONFIG_JBD=3Dy
> # CONFIG_JBD_DEBUG is not set
> CONFIG_FAT_FS=3Dy
> CONFIG_MSDOS_FS=3Dy
> # CONFIG_UMSDOS_FS is not set
> CONFIG_VFAT_FS=3Dy
> # CONFIG_EFS_FS is not set
> # CONFIG_JFFS_FS is not set
> # CONFIG_JFFS2_FS is not set
> # CONFIG_CRAMFS is not set
> CONFIG_TMPFS=3Dy
> CONFIG_RAMFS=3Dy
> CONFIG_ISO9660_FS=3Dy
> CONFIG_JOLIET=3Dy
> # CONFIG_ZISOFS is not set
> # CONFIG_JFS_FS is not set
> # CONFIG_JFS_DEBUG is not set
> # CONFIG_JFS_STATISTICS is not set
> CONFIG_MINIX_FS=3Dm
> # CONFIG_VXFS_FS is not set
> # CONFIG_NTFS_FS is not set
> # CONFIG_NTFS_RW is not set
> # CONFIG_HPFS_FS is not set
> CONFIG_PROC_FS=3Dy
> # CONFIG_DEVFS_FS is not set
> # CONFIG_DEVFS_MOUNT is not set
> # CONFIG_DEVFS_DEBUG is not set
> CONFIG_DEVPTS_FS=3Dy
> # CONFIG_QNX4FS_FS is not set
> # CONFIG_QNX4FS_RW is not set
> # CONFIG_ROMFS_FS is not set
> CONFIG_EXT2_FS=3Dy
> # CONFIG_SYSV_FS is not set
> # CONFIG_UDF_FS is not set
> # CONFIG_UDF_RW is not set
> # CONFIG_UFS_FS is not set
> # CONFIG_UFS_FS_WRITE is not set
> # CONFIG_XFS_FS is not set
> # CONFIG_XFS_QUOTA is not set
> # CONFIG_XFS_RT is not set
> # CONFIG_XFS_TRACE is not set
> # CONFIG_XFS_DEBUG is not set
>=20
> #
> # Network File Systems
> #
> # CONFIG_CODA_FS is not set
> # CONFIG_INTERMEZZO_FS is not set
> CONFIG_NFS_FS=3Dy
> CONFIG_NFS_V3=3Dy
> # CONFIG_NFS_DIRECTIO is not set
> # CONFIG_ROOT_NFS is not set
> CONFIG_NFSD=3Dy
> CONFIG_NFSD_V3=3Dy
> # CONFIG_NFSD_TCP is not set
> CONFIG_SUNRPC=3Dy
> CONFIG_LOCKD=3Dy
> CONFIG_LOCKD_V4=3Dy
> CONFIG_SMB_FS=3Dy
> # CONFIG_SMB_NLS_DEFAULT is not set
> CONFIG_SMB_UNIX=3Dy
> # CONFIG_NCP_FS is not set
> # CONFIG_NCPFS_PACKET_SIGNING is not set
> # CONFIG_NCPFS_IOCTL_LOCKING is not set
> # CONFIG_NCPFS_STRONG is not set
> # CONFIG_NCPFS_NFS_NS is not set
> # CONFIG_NCPFS_OS2_NS is not set
> # CONFIG_NCPFS_SMALLDOS is not set
> # CONFIG_NCPFS_NLS is not set
> # CONFIG_NCPFS_EXTRAS is not set
> # CONFIG_ZISOFS_FS is not set
>=20
> #
> # Partition Types
> #
> CONFIG_PARTITION_ADVANCED=3Dy
> # CONFIG_ACORN_PARTITION is not set
> CONFIG_OSF_PARTITION=3Dy
> # CONFIG_AMIGA_PARTITION is not set
> # CONFIG_ATARI_PARTITION is not set
> # CONFIG_MAC_PARTITION is not set
> CONFIG_MSDOS_PARTITION=3Dy
> CONFIG_BSD_DISKLABEL=3Dy
> # CONFIG_MINIX_SUBPARTITION is not set
> # CONFIG_SOLARIS_X86_PARTITION is not set
> # CONFIG_UNIXWARE_DISKLABEL is not set
> # CONFIG_LDM_PARTITION is not set
> # CONFIG_SGI_PARTITION is not set
> # CONFIG_ULTRIX_PARTITION is not set
> # CONFIG_SUN_PARTITION is not set
> # CONFIG_EFI_PARTITION is not set
> CONFIG_SMB_NLS=3Dy
> CONFIG_NLS=3Dy
>=20
> #
> # Native Language Support
> #
> CONFIG_NLS_DEFAULT=3D"cp437"
> CONFIG_NLS_CODEPAGE_437=3Dy
> CONFIG_NLS_CODEPAGE_737=3Dm
> CONFIG_NLS_CODEPAGE_775=3Dm
> CONFIG_NLS_CODEPAGE_850=3Dm
> CONFIG_NLS_CODEPAGE_852=3Dm
> CONFIG_NLS_CODEPAGE_855=3Dm
> CONFIG_NLS_CODEPAGE_857=3Dm
> CONFIG_NLS_CODEPAGE_860=3Dm
> CONFIG_NLS_CODEPAGE_861=3Dm
> CONFIG_NLS_CODEPAGE_862=3Dm
> CONFIG_NLS_CODEPAGE_863=3Dm
> CONFIG_NLS_CODEPAGE_864=3Dm
> CONFIG_NLS_CODEPAGE_865=3Dm
> CONFIG_NLS_CODEPAGE_866=3Dm
> CONFIG_NLS_CODEPAGE_869=3Dm
> CONFIG_NLS_CODEPAGE_936=3Dm
> CONFIG_NLS_CODEPAGE_950=3Dm
> CONFIG_NLS_CODEPAGE_932=3Dm
> CONFIG_NLS_CODEPAGE_949=3Dm
> CONFIG_NLS_CODEPAGE_874=3Dm
> CONFIG_NLS_ISO8859_8=3Dm
> # CONFIG_NLS_CODEPAGE_1250 is not set
> # CONFIG_NLS_CODEPAGE_1251 is not set
> CONFIG_NLS_ISO8859_1=3Dy
> CONFIG_NLS_ISO8859_2=3Dm
> CONFIG_NLS_ISO8859_3=3Dm
> CONFIG_NLS_ISO8859_4=3Dm
> CONFIG_NLS_ISO8859_5=3Dm
> CONFIG_NLS_ISO8859_6=3Dm
> CONFIG_NLS_ISO8859_7=3Dm
> CONFIG_NLS_ISO8859_9=3Dm
> # CONFIG_NLS_ISO8859_13 is not set
> CONFIG_NLS_ISO8859_14=3Dm
> CONFIG_NLS_ISO8859_15=3Dy
> CONFIG_NLS_KOI8_R=3Dm
> # CONFIG_NLS_KOI8_U is not set
> # CONFIG_NLS_UTF8 is not set
>=20
> #
> # Console drivers
> #
> CONFIG_VGA_CONSOLE=3Dy
>=20
> #
> # Frame-buffer support
> #
> # CONFIG_FB is not set
>=20
> #
> # Sound
> #
> # CONFIG_SOUND is not set
>=20
> #
> # USB support
> #
> # CONFIG_USB is not set
>=20
> #
> # Support for USB gadgets
> #
> # CONFIG_USB_GADGET is not set
>=20
> #
> # Bluetooth support
> #
> # CONFIG_BLUEZ is not set
>=20
> #
> # Kernel hacking
> #
> CONFIG_ALPHA_LEGACY_START_ADDRESS=3Dy
> CONFIG_DEBUG_KERNEL=3Dy
> CONFIG_MATHEMU=3Dy
> # CONFIG_DEBUG_SLAB is not set
> CONFIG_MAGIC_SYSRQ=3Dy
> # CONFIG_DEBUG_SPINLOCK is not set
> # CONFIG_DEBUG_RWLOCK is not set
> # CONFIG_DEBUG_SEMAPHORE is not set
> CONFIG_LOG_BUF_SHIFT=3D17
>=20
> #
> # Cryptographic options
> #
> # CONFIG_CRYPTO is not set
>=20
> #
> # Library routines
> #
> # CONFIG_CRC32 is not set
> CONFIG_ZLIB_INFLATE=3Dm
> CONFIG_ZLIB_DEFLATE=3Dm

> Linux version 2.4.25 (root@beta) (gcc version 2.95.4 20011002 (Debian=
 prerelease)) #6 Thu Mar 25 16:35:34 CET 2004
> Booting on EB164 variation SX164 using machine vector SX164 from SRM
> Major Options: EV56 LEGACY_START MAGIC_SYSRQ=20
> Command line: ro root=3D/dev/sda1
> memcluster 0, usage 1, start        0, end      256
> memcluster 1, usage 0, start      256, end    32758
> memcluster 2, usage 1, start    32758, end    32768
> freeing pages 256:384
> freeing pages 827:32758
> reserving pages 827:828
> pci: cia revision 1 (pyxis)
> On node 0 totalpages: 32758
> zone(0): 32758 pages.
> zone(1): 0 pages.
> zone(2): 0 pages.
> Kernel command line: ro root=3D/dev/sda1
> Using epoch =3D 1952
> Console: colour VGA+ 80x25
> Calibrating delay loop... 1055.68 BogoMIPS
> Memory: 253616k/262064k available (2175k kernel code, 6400k reserved,=
 577k data, 368k init)
> Dentry cache hash table entries: 32768 (order: 6, 524288 bytes)
> Inode cache hash table entries: 16384 (order: 5, 262144 bytes)
> Mount cache hash table entries: 512 (order: 0, 8192 bytes)
> Buffer cache hash table entries: 8192 (order: 3, 65536 bytes)
> Page-cache hash table entries: 32768 (order: 5, 262144 bytes)
> POSIX conformance testing by UNIFIX
> pci: passed tb register update test
> pci: passed sg loopback i/o read test
> pci: passed pte write cache snoop test
> pci: failed valid tag invalid pte reload test (mcheck; workaround ava=
ilable)
> pci: passed pci machine check test
> pci: tbia workaround enabled
> pci: enabling save/restore of SRM state
> SMC37c669 Super I/O Controller found @ 0x3f0
> Linux NET4.0 for Linux 2.4
> Based upon Swansea University Computer Society NET3.039
> Initializing RT netlink socket
> srm_env: version 0.0.5 loaded successfully
> Starting kswapd
> VFS: Disk quotas vdquot_6.5.1
> Journalled Block Device driver loaded
> Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
> pty: 256 Unix98 ptys configured
> Serial driver version 5.05c (2001-07-08) with MANY_PORTS SHARE_IRQ SE=
RIAL_PCI enabled
> ttyS00 at 0x03f8 (irq =3D 4) is a 16550A
> ttyS01 at 0x02f8 (irq =3D 3) is a 16550A
> rtc: Digital UNIX epoch (1952) detected
> Real Time Clock Driver v1.10f
> Floppy drive(s): fd0 is 2.88M
> FDC 0 is a post-1991 82077
> Linux Tulip driver version 0.9.15-pre12 (Aug 9, 2002)
> tulip0:  EEPROM default media type Autosense.
> tulip0:  Index #0 - Media MII (#11) described by a 21140 MII PHY (1) =
block.
> tulip0:  MII transceiver #0 config 0000 status 780d advertising 01e1.
> eth0: Digital DS21140 Tulip rev 34 at 0xfffffc880a104000, 00:40:05:36=
:50:D4, IRQ 25.
> Uniform Multi-Platform E-IDE driver Revision: 7.00beta4-2.4
> ide: Assuming 33MHz system bus speed for PIO modes; override with ide=
bus=3Dxx
> SiI680: IDE controller at PCI slot 00:06.0
> SiI680: chipset revision 1
> SiI680: not 100% native mode: will probe irqs later
> SiI680: BASE CLOCK =3D=3D 133=20
>     ide0: MMIO-DMA , BIOS settings: hda:pio, hdb:pio
>     ide1: MMIO-DMA , BIOS settings: hdc:pio, hdd:pio
> hda: HDS722516VLAT80, ATA DISK drive
> blk: queue fffffc0000609c58, no I/O memory limit
> hdc: HDS722516VLAT80, ATA DISK drive
> blk: queue fffffc000060a3c0, no I/O memory limit
> ide0 at 0xfffffc880a102080-0xfffffc880a102087,0xfffffc880a10208a on i=
rq 27
> ide1 at 0xfffffc880a1020c0-0xfffffc880a1020c7,0xfffffc880a1020ca on i=
rq 27
> hda: attached ide-disk driver.
> hda: host protected area =3D> 1
> hda: 321672960 sectors (164697 MB) w/7938KiB Cache, CHS=3D20023/255/6=
3, UDMA(100)
> hdc: attached ide-disk driver.
> hdc: host protected area =3D> 1
> hdc: 321672960 sectors (164697 MB) w/7938KiB Cache, CHS=3D20023/255/6=
3, UDMA(100)
> Partition check:
>  hda: hda1
>  hdc: hdc1
> SCSI subsystem driver Revision: 1.00
> sym53c8xx: at PCI bus 0, device 7, function 0
> sym53c8xx: setting PCI_COMMAND_PARITY...(fix-up)
> sym53c8xx: 53c875 detected with Symbios NVRAM
> sym53c875-0: rev 0x26 on pci bus 0 device 7 function 0 irq 26
> sym53c875-0: Symbios format NVRAM, ID 7, Fast-20, Parity Checking
> sym53c875-0: on-chip RAM at 0xa100000
> sym53c875-0: restart (scsi reset).
> sym53c875-0: Downloading SCSI SCRIPTS.
> scsi0 : sym53c8xx-1.7.3c-20010512
> blk: queue fffffc000098d2d0, no I/O memory limit
>   Vendor: IBM       Model: DCAS-34330W       Rev: S65A
>   Type:   Direct-Access                      ANSI SCSI revision: 02
> blk: queue fffffc000098d4d0, no I/O memory limit
>   Vendor: IBM       Model: DDYS-T36950N      Rev: S93E
>   Type:   Direct-Access                      ANSI SCSI revision: 03
> blk: queue fffffc000098d6d0, no I/O memory limit
> sym53c875-0-<0,0>: tagged command queue depth set to 8
> sym53c875-0-<2,0>: tagged command queue depth set to 8
> Attached scsi disk sda at scsi0, channel 0, id 0, lun 0
> Attached scsi disk sdb at scsi0, channel 0, id 2, lun 0
> sym53c875-0-<0,*>: FAST-20 SCSI 20.0 MB/s (50.0 ns, offset 15)
> SCSI device sda: 8467200 512-byte hdwr sectors (4335 MB)
>  sda: sda1 sda2 sda3
> sym53c875-0-<2,*>: FAST-20 SCSI 20.0 MB/s (50.0 ns, offset 16)
> SCSI device sdb: 71687340 512-byte hdwr sectors (36704 MB)
>  sdb: sdb1
> md: linear personality registered as nr 1
> md: raid0 personality registered as nr 2
> md: raid1 personality registered as nr 3
> md: md driver 0.90.0 MAX_MD_DEVS=3D256, MD_SB_DISKS=3D27
> md: Autodetecting RAID arrays.
>  [events: 00000001]
>  [events: 00000001]
> md: autorun ...
> md: considering hdc1 ...
> md:  adding hdc1 ...
> md:  adding hda1 ...
> md: created md0
> md: bind<hda1,1>
> md: bind<hdc1,2>
> md: running: <hdc1><hda1>
> md: hdc1's event counter: 00000001
> md: hda1's event counter: 00000001
> md: md0: raid array is not clean -- starting background reconstructio=
n
> md: RAID level 1 does not need chunksize! Continuing anyway.
> md0: max total readahead window set to 248k
> md0: 1 data-disks, max readahead per data-disk: 248k
> raid1: device hdc1 operational as mirror 0
> raid1: device hda1 operational as mirror 1
> raid1: raid set md0 not clean; reconstructing mirrors
> raid1: raid set md0 active with 2 out of 2 mirrors
> md: updating md0 RAID superblock on device
> md: hdc1 [events: 00000002]<6>(write) hdc1's sb offset: 160834624
> md: syncing RAID array md0
> md: minimum _guaranteed_ reconstruction speed: 100 KB/sec/disc.
> md: using maximum available idle IO bandwith (but not more than 10000=
0 KB/sec) for reconstruction.
> md: using 248k window, over a total of 160834624 blocks.
> md: hda1 [events: 00000002]<6>(write) hda1's sb offset: 160834624
> md: ... autorun DONE.
> NET4: Linux TCP/IP 1.0 for NET4.0
> IP Protocols: ICMP, UDP, TCP
> IP: routing cache hash table of 4096 buckets, 32Kbytes
> TCP: Hash tables configured (established 32768 bind 16384)
> NET4: Unix domain sockets 1.0/SMP for Linux NET4.0.
> VFS: Mounted root (ext2 filesystem) readonly.
> Freeing unused kernel memory: 368k freed
> Adding Swap: 265848k swap-space (priority -1)
> kjournald starting.  Commit interval 5 seconds
> EXT3 FS 2.4-0.9.19, 19 August 2002 on md(9,0), internal journal
> EXT3-fs: mounted filesystem with ordered data mode.
> eth0: Setting full-duplex based on MII#0 link partner capability of 0=
1e1.
> md: md0: sync done.
> Unable to handle kernel paging request at virtual address 0000440003a=
f267c
> find(826): Oops 0
> pc =3D [<fffffc00004a8b20>]  ra =3D [<fffffc00004a8d7c>]  ps =3D 0000=
    Not tainted
> v0 =3D 0000000000001068  t0 =3D fffffffffff7fff0  t1 =3D 000000000008=
0010
> t2 =3D 0000440003af269c  t3 =3D 0000000000000000  t4 =3D 0000440003af=
267c
> t5 =3D 0000440003af2674  t6 =3D 0000000000000002  t7 =3D fffffc000ec0=
4000
> s0 =3D fffffc000cb419c0  s1 =3D 0000000000000900  s2 =3D fffffc000022=
1000
> s3 =3D fffffc000cb419c0  s4 =3D fffffc000fe94cc0  s5 =3D 000000000000=
0000
> s6 =3D fffffc000098d8a0
> a0 =3D fffffc0000221000  a1 =3D fffffc000cb419c0  a2 =3D fffffc000cb4=
19c0
> a3 =3D 0000000000001000  a4 =3D 0000000000000008  a5 =3D fffffc000022=
1018
> t8 =3D 0000000000000000  t9 =3D 00004800038d1680  t10=3D 000000000008=
0010
> t11=3D fffffc0000221020  pv =3D fffffc00004a8ba0  at =3D fffffc000022=
101c
> gp =3D fffffc000062fbe8  sp =3D fffffc000ec07c18
> Trace:fffffc00004ab950 fffffc0000355ba0 fffffc0000392abc fffffc000043=
fba4 fffffc000043fcac fffffc000044000c fffffc0000355ba0 fffffc0000392b0=
4 fffffc000036b5e0 fffffc000038ee28 fffffc000036ac28 fffffc000036b5e0 f=
ffffc000036489c fffffc00003648f8 fffffc00003634b4 fffffc000036b5e0 ffff=
fc000036b808 fffffc0000310c40=20
> Code: 42fc0403  2ffe0000  42f90405  a0f003d8  40a49525  40c49526 <a02=
50000> 40649523=20


Best wishes

Norbert

-----------------------------------------------------------------------=
--------
Norbert Preining <preining AT logic DOT at>         Technische Universi=
t=E4t Wien
gpg DSA: 0x09C5B094      fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 0=
9C5 B094
-----------------------------------------------------------------------=
--------
DEEPING ST NICHOLAS (n.)
			--- Douglas Adams, The Meaning of Liff
What street-wise kids do at Christmas. They hide on the rooftops
waiting for Santa Claus so that if he arrives and goes down the
chimney, they can rip stuff off from his sleigh.
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
