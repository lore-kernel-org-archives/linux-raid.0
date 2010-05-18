From: Brad Campbell <brad@wasp.net.au>
Subject: Upgrade to 2.6.34 failed to detect gpt partitions on md0
Date: Tue, 18 May 2010 21:13:17 +0800
Message-ID: <4BF2926D.2050508@wasp.net.au>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010306030900010703040302"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: RAID Linux <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------010306030900010703040302
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

G'day all,

I'm baffled.
I'm running 2.6.33.2 and I have several arrays :

brad@srv:~$ cat /proc/mdstat
Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [raid4]
md1 : active raid1 sdk1[0] sdl1[1]
       19542976 blocks [2/2] [UU]

md0 : active raid6 sdc[0] sdb[9] sdg[8] sde[7] sdh[6] sdi[5] sdf[4] sda[3] sdd[2] sdj[1]
       7814099968 blocks level 6, 128k chunk, algorithm 2 [10/10] [UUUUUUUUUU]

md2 : active raid5 sdn[0] sdo[2] sdm[1]
       1465148928 blocks level 5, 128k chunk, algorithm 2 [3/3] [UUU]

md5 : active raid1 sdl4[0] sdk4[1]
       200217984 blocks [2/2] [UU]

md4 : active (auto-read-only) raid1 sdl3[0] sdk3[1]
       4891712 blocks [2/2] [UU]

md3 : active raid1 sdl2[0] sdk2[1]
       19542976 blocks [2/2] [UU]

brad@srv:~$ mdadm --version
mdadm - v2.6.7.2 - 14th November 2008

brad@srv:~$ ls -la /dev/md*
brw-rw---- 1 root disk   9, 0 2010-05-18 20:58 /dev/md0
brw-rw---- 1 root disk 259, 0 2010-05-18 20:58 /dev/md0p1
brw-rw---- 1 root disk 259, 1 2010-05-18 20:58 /dev/md0p2
brw-rw---- 1 root disk 259, 2 2010-05-18 20:58 /dev/md0p3
brw-rw---- 1 root disk   9, 1 2010-05-18 20:58 /dev/md1
brw-rw---- 1 root disk   9, 2 2010-05-18 20:58 /dev/md2
brw-rw---- 1 root disk   9, 3 2010-05-18 20:58 /dev/md3
brw-rw---- 1 root disk   9, 4 2010-05-18 20:58 /dev/md4
brw-rw---- 1 root disk   9, 5 2010-05-18 20:58 /dev/md5

/dev/md:
total 0
drwxr-xr-x  2 root root    60 2010-05-18 20:58 .
drwxr-xr-x 13 root root 14060 2010-05-18 20:59 ..
brw-rw----  1 root disk  9, 1 2010-05-18 20:58 1

brad@srv:~$ uname -a
Linux srv 2.6.33.2 #23 SMP Thu Apr 8 08:19:14 WST 2010 x86_64 GNU/Linux

brad@srv:~$ sudo parted /dev/md0 print
Model: Unknown (unknown)
Disk /dev/md0: 8002GB
Sector size (logical/physical): 512B/512B
Partition Table: gpt

Number  Start   End     Size    File system  Name  Flags
  1      131kB   2199GB  2199GB  ext3         p1
  2      2199GB  5001GB  2802GB  ext3         p2
  3      5001GB  8002GB  3001GB  ext3         p3

The partitions are visible on 2.6.34 using parted, but the kernel just does not appear to see them

brad@srv:~$ cat /etc/mdadm/mdadm.conf
# mdadm.conf
#
# Please refer to mdadm.conf(5) for information about this file.
#

# by default, scan all partitions (/proc/partitions) for MD superblocks.
# alternatively, specify devices to scan, using wildcards if desired.
DEVICE partitions

# auto-create devices with Debian standard permissions
CREATE owner=root group=disk mode=0660 auto=yes

# automatically tag new arrays as belonging to the local system
HOMEHOST <system>

# instruct the monitoring daemon where to send mail alerts
MAILADDR root

# definitions of existing MD arrays

# This file was auto-generated on Fri, 30 May 2008 16:50:33 +0400
# by mkconf $Id: mkconf 261 2006-11-09 13:32:35Z madduck $
ARRAY /dev/md1 level=raid1 num-devices=2 UUID=bf3ec6f8:9bc5f6c5:6c0dbecc:c91236a8
ARRAY /dev/md3 level=raid1 num-devices=2 UUID=f193b588:38ea821b:ae17e277:43c77849
ARRAY /dev/md4 level=raid1 num-devices=2 UUID=b49564ef:4e7973a9:e03d5baa:c2658645
ARRAY /dev/md5 level=raid1 num-devices=2 UUID=ef65b648:5ff448a0:65917327:f86df9e1
ARRAY /dev/md2 level=raid5 num-devices=3 UUID=c31d52b7:c5f737c1:77b3e157:2a2b83d1
ARRAY /dev/md0 level=raid6 num-devices=10 UUID=45e0ee52:742c494a:9dee9486:6a6784c1 auto=part

I've also attached a diff between the 2.6.33.2 and the 2.6.34 configs just in case.

Simply reverting back to 2.6.33.2 makes the problem go away.

Have I done something obviously dumb or not provided the right (or enough) info?

Regards,
Brad
-- 
Dolphins are so intelligent that within a few weeks they can
train Americans to stand at the edge of the pool and throw them
fish.

--------------010306030900010703040302
Content-Type: text/plain;
 name="diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="diff"

--- fred	2010-05-18 21:03:53.000000000 +0800
+++ .config	2010-05-18 20:25:45.000000000 +0800
@@ -1,7 +1,7 @@
 #
 # Automatically generated make config: don't edit
-# Linux kernel version: 2.6.33.2
-# Thu Apr  8 08:16:23 2010
+# Linux kernel version: 2.6.34
+# Tue May 18 20:25:45 2010
 #
 CONFIG_64BIT=y
 # CONFIG_X86_32 is not set
@@ -19,14 +19,15 @@
 CONFIG_HAVE_LATENCYTOP_SUPPORT=y
 CONFIG_MMU=y
 CONFIG_ZONE_DMA=y
+CONFIG_NEED_DMA_MAP_STATE=y
 CONFIG_GENERIC_ISA_DMA=y
 CONFIG_GENERIC_IOMAP=y
 CONFIG_GENERIC_BUG=y
 CONFIG_GENERIC_BUG_RELATIVE_POINTERS=y
 CONFIG_GENERIC_HWEIGHT=y
 CONFIG_ARCH_MAY_HAVE_PC_FDC=y
-CONFIG_RWSEM_GENERIC_SPINLOCK=y
-# CONFIG_RWSEM_XCHGADD_ALGORITHM is not set
+# CONFIG_RWSEM_GENERIC_SPINLOCK is not set
+CONFIG_RWSEM_XCHGADD_ALGORITHM=y
 CONFIG_ARCH_HAS_CPU_IDLE_WAIT=y
 CONFIG_GENERIC_CALIBRATE_DELAY=y
 CONFIG_GENERIC_TIME_VSYSCALL=y
@@ -44,6 +45,7 @@
 CONFIG_AUDIT_ARCH=y
 CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
 CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
+CONFIG_HAVE_EARLY_RES=y
 CONFIG_GENERIC_HARDIRQS=y
 CONFIG_GENERIC_HARDIRQS_NO__DO_IRQ=y
 CONFIG_GENERIC_IRQ_PROBE=y
@@ -89,12 +91,12 @@
 # CONFIG_RCU_TRACE is not set
 CONFIG_RCU_FANOUT=64
 # CONFIG_RCU_FANOUT_EXACT is not set
+# CONFIG_RCU_FAST_NO_HZ is not set
 # CONFIG_TREE_RCU_TRACE is not set
 CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=20
 CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
-# CONFIG_GROUP_SCHED is not set
 # CONFIG_CGROUPS is not set
 CONFIG_SYSFS_DEPRECATED=y
 CONFIG_SYSFS_DEPRECATED_V2=y
@@ -156,8 +158,10 @@
 CONFIG_HAVE_IOREMAP_PROT=y
 CONFIG_HAVE_KPROBES=y
 CONFIG_HAVE_KRETPROBES=y
+CONFIG_HAVE_OPTPROBES=y
 CONFIG_HAVE_ARCH_TRACEHOOK=y
 CONFIG_HAVE_DMA_ATTRS=y
+CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
 CONFIG_HAVE_DMA_API_DEBUG=y
 CONFIG_HAVE_HW_BREAKPOINT=y
 CONFIG_HAVE_USER_RETURN_NOTIFIER=y
@@ -238,6 +242,7 @@
 CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
 CONFIG_SCHED_OMIT_FRAME_POINTER=y
 # CONFIG_PARAVIRT_GUEST is not set
+CONFIG_NO_BOOTMEM=y
 # CONFIG_MEMTEST is not set
 # CONFIG_M386 is not set
 # CONFIG_M486 is not set
@@ -269,6 +274,7 @@
 CONFIG_X86_INTERNODE_CACHE_SHIFT=6
 CONFIG_X86_CMPXCHG=y
 CONFIG_X86_L1_CACHE_SHIFT=6
+CONFIG_X86_XADD=y
 CONFIG_X86_WP_WORKS_OK=y
 CONFIG_X86_INTEL_USERCOPY=y
 CONFIG_X86_USE_PPRO_CHECKSUM=y
@@ -325,6 +331,7 @@
 CONFIG_HAVE_MEMORY_PRESENT=y
 CONFIG_SPARSEMEM_EXTREME=y
 CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
+CONFIG_SPARSEMEM_ALLOC_MEM_MAP_TOGETHER=y
 CONFIG_SPARSEMEM_VMEMMAP=y
 # CONFIG_MEMORY_HOTPLUG is not set
 CONFIG_PAGEFLAGS_EXTENDED=y
@@ -418,6 +425,7 @@
 #
 # CPUFreq processor drivers
 #
+# CONFIG_X86_PCC_CPUFREQ is not set
 CONFIG_X86_ACPI_CPUFREQ=m
 CONFIG_X86_POWERNOW_K8=m
 # CONFIG_X86_SPEEDSTEP_CENTRINO is not set
@@ -453,7 +461,6 @@
 # CONFIG_PCIEASPM_DEBUG is not set
 CONFIG_ARCH_SUPPORTS_MSI=y
 CONFIG_PCI_MSI=y
-# CONFIG_PCI_LEGACY is not set
 # CONFIG_PCI_DEBUG is not set
 # CONFIG_PCI_STUB is not set
 CONFIG_HT_IRQ=y
@@ -483,7 +490,6 @@
 # Networking options
 #
 CONFIG_PACKET=y
-# CONFIG_PACKET_MMAP is not set
 CONFIG_UNIX=y
 CONFIG_XFRM=y
 # CONFIG_XFRM_USER is not set
@@ -534,6 +540,7 @@
 CONFIG_NF_CONNTRACK=m
 CONFIG_NF_CT_ACCT=y
 CONFIG_NF_CONNTRACK_MARK=y
+CONFIG_NF_CONNTRACK_ZONES=y
 # CONFIG_NF_CONNTRACK_EVENTS is not set
 CONFIG_NF_CT_PROTO_DCCP=m
 CONFIG_NF_CT_PROTO_GRE=m
@@ -553,6 +560,7 @@
 CONFIG_NETFILTER_XTABLES=m
 CONFIG_NETFILTER_XT_TARGET_CLASSIFY=m
 CONFIG_NETFILTER_XT_TARGET_CONNMARK=m
+CONFIG_NETFILTER_XT_TARGET_CT=m
 CONFIG_NETFILTER_XT_TARGET_DSCP=m
 CONFIG_NETFILTER_XT_TARGET_HL=m
 CONFIG_NETFILTER_XT_TARGET_MARK=m
@@ -654,6 +662,7 @@
 # CONFIG_ATM is not set
 CONFIG_STP=y
 CONFIG_BRIDGE=y
+CONFIG_BRIDGE_IGMP_SNOOPING=y
 # CONFIG_NET_DSA is not set
 CONFIG_VLAN_8021Q=y
 # CONFIG_VLAN_8021Q_GVRP is not set
@@ -792,6 +801,7 @@
 #
 # SCSI device support
 #
+CONFIG_SCSI_MOD=y
 # CONFIG_RAID_ATTRS is not set
 CONFIG_SCSI=y
 CONFIG_SCSI_DMA=y
@@ -868,6 +878,7 @@
 # CONFIG_PATA_IT821X is not set
 # CONFIG_PATA_IT8213 is not set
 # CONFIG_PATA_JMICRON is not set
+# CONFIG_PATA_LEGACY is not set
 # CONFIG_PATA_TRIFLEX is not set
 # CONFIG_PATA_MARVELL is not set
 # CONFIG_PATA_MPIIX is not set
@@ -954,6 +965,7 @@
 # CONFIG_PCNET32 is not set
 # CONFIG_AMD8111_ETH is not set
 # CONFIG_ADAPTEC_STARFIRE is not set
+# CONFIG_KSZ884X_PCI is not set
 # CONFIG_B44 is not set
 CONFIG_FORCEDETH=m
 CONFIG_FORCEDETH_NAPI=y
@@ -1015,6 +1027,7 @@
 # CONFIG_USB_PEGASUS is not set
 # CONFIG_USB_RTL8150 is not set
 # CONFIG_USB_USBNET is not set
+# CONFIG_USB_IPHETH is not set
 # CONFIG_WAN is not set
 # CONFIG_FDDI is not set
 # CONFIG_HIPPI is not set
@@ -1120,6 +1133,7 @@
 CONFIG_SERIAL_CORE=y
 CONFIG_SERIAL_CORE_CONSOLE=y
 # CONFIG_SERIAL_JSM is not set
+# CONFIG_SERIAL_TIMBERDALE is not set
 CONFIG_UNIX98_PTYS=y
 # CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
 CONFIG_LEGACY_PTYS=y
@@ -1179,6 +1193,7 @@
 #
 # CONFIG_I2C_OCORES is not set
 # CONFIG_I2C_SIMTEC is not set
+# CONFIG_I2C_XILINX is not set
 
 #
 # External I2C/SMBus adapter drivers
@@ -1192,15 +1207,9 @@
 #
 # CONFIG_I2C_PCA_PLATFORM is not set
 # CONFIG_I2C_STUB is not set
-
-#
-# Miscellaneous I2C Chip support
-#
-# CONFIG_SENSORS_TSL2550 is not set
 # CONFIG_I2C_DEBUG_CORE is not set
 # CONFIG_I2C_DEBUG_ALGO is not set
 # CONFIG_I2C_DEBUG_BUS is not set
-# CONFIG_I2C_DEBUG_CHIP is not set
 # CONFIG_SPI is not set
 
 #
@@ -1234,10 +1243,11 @@
 # CONFIG_SENSORS_ADM1029 is not set
 # CONFIG_SENSORS_ADM1031 is not set
 # CONFIG_SENSORS_ADM9240 is not set
+# CONFIG_SENSORS_ADT7411 is not set
 # CONFIG_SENSORS_ADT7462 is not set
 # CONFIG_SENSORS_ADT7470 is not set
-# CONFIG_SENSORS_ADT7473 is not set
 # CONFIG_SENSORS_ADT7475 is not set
+# CONFIG_SENSORS_ASC7621 is not set
 # CONFIG_SENSORS_K8TEMP is not set
 CONFIG_SENSORS_K10TEMP=y
 # CONFIG_SENSORS_ASB100 is not set
@@ -1318,18 +1328,21 @@
 # Multifunction device drivers
 #
 # CONFIG_MFD_CORE is not set
+# CONFIG_MFD_88PM860X is not set
 # CONFIG_MFD_SM501 is not set
 # CONFIG_HTC_PASIC3 is not set
 # CONFIG_TWL4030_CORE is not set
 # CONFIG_MFD_TMIO is not set
 # CONFIG_PMIC_DA903X is not set
 # CONFIG_PMIC_ADP5520 is not set
+# CONFIG_MFD_MAX8925 is not set
 # CONFIG_MFD_WM8400 is not set
 # CONFIG_MFD_WM831X is not set
 # CONFIG_MFD_WM8350_I2C is not set
+# CONFIG_MFD_WM8994 is not set
 # CONFIG_MFD_PCF50633 is not set
 # CONFIG_AB3100_CORE is not set
-# CONFIG_MFD_88PM8607 is not set
+# CONFIG_LPC_SCH is not set
 # CONFIG_REGULATOR is not set
 # CONFIG_MEDIA_SUPPORT is not set
 
@@ -1342,6 +1355,8 @@
 # CONFIG_AGP_SIS is not set
 # CONFIG_AGP_VIA is not set
 CONFIG_VGA_ARB=y
+CONFIG_VGA_ARB_MAX_GPUS=16
+# CONFIG_VGA_SWITCHEROO is not set
 # CONFIG_DRM is not set
 CONFIG_VGASTATE=y
 # CONFIG_VIDEO_OUTPUT_CONTROL is not set
@@ -1447,6 +1462,7 @@
 #
 # Special HID drivers
 #
+# CONFIG_HID_3M_PCT is not set
 CONFIG_HID_A4TECH=m
 CONFIG_HID_APPLE=m
 CONFIG_HID_BELKIN=m
@@ -1463,14 +1479,19 @@
 CONFIG_HID_LOGITECH=m
 # CONFIG_LOGITECH_FF is not set
 # CONFIG_LOGIRUMBLEPAD2_FF is not set
+# CONFIG_LOGIG940_FF is not set
 CONFIG_HID_MICROSOFT=m
+# CONFIG_HID_MOSART is not set
 CONFIG_HID_MONTEREY=m
 CONFIG_HID_NTRIG=m
+CONFIG_HID_ORTEK=m
 CONFIG_HID_PANTHERLORD=m
 # CONFIG_PANTHERLORD_FF is not set
 CONFIG_HID_PETALYNX=m
+# CONFIG_HID_QUANTA is not set
 CONFIG_HID_SAMSUNG=m
 CONFIG_HID_SONY=m
+# CONFIG_HID_STANTUM is not set
 CONFIG_HID_SUNPLUS=m
 CONFIG_HID_GREENASIA=m
 # CONFIG_GREENASIA_FF is not set
@@ -1495,8 +1516,6 @@
 CONFIG_USB_DEVICEFS=y
 CONFIG_USB_DEVICE_CLASS=y
 # CONFIG_USB_DYNAMIC_MINORS is not set
-CONFIG_USB_SUSPEND=y
-# CONFIG_USB_OTG is not set
 # CONFIG_USB_MON is not set
 # CONFIG_USB_WUSB is not set
 # CONFIG_USB_WUSB_CBAF is not set
@@ -1599,6 +1618,7 @@
 # CONFIG_USB_SERIAL_NAVMAN is not set
 CONFIG_USB_SERIAL_PL2303=m
 # CONFIG_USB_SERIAL_OTI6858 is not set
+# CONFIG_USB_SERIAL_QCAUX is not set
 # CONFIG_USB_SERIAL_QUALCOMM is not set
 # CONFIG_USB_SERIAL_SPCP8X5 is not set
 # CONFIG_USB_SERIAL_HP4X is not set
@@ -1612,6 +1632,7 @@
 # CONFIG_USB_SERIAL_OPTION is not set
 # CONFIG_USB_SERIAL_OMNINET is not set
 # CONFIG_USB_SERIAL_OPTICON is not set
+# CONFIG_USB_SERIAL_VIVOPAY_SERIAL is not set
 # CONFIG_USB_SERIAL_DEBUG is not set
 
 #
@@ -1624,7 +1645,6 @@
 # CONFIG_USB_RIO500 is not set
 # CONFIG_USB_LEGOTOWER is not set
 # CONFIG_USB_LCD is not set
-# CONFIG_USB_BERRY_CHARGE is not set
 # CONFIG_USB_LED is not set
 # CONFIG_USB_CYPRESS_CY7C63 is not set
 # CONFIG_USB_CYTHERM is not set
@@ -1637,7 +1657,6 @@
 # CONFIG_USB_IOWARRIOR is not set
 # CONFIG_USB_TEST is not set
 # CONFIG_USB_ISIGHTFW is not set
-# CONFIG_USB_VST is not set
 # CONFIG_USB_GADGET is not set
 
 #
@@ -1765,6 +1784,7 @@
 # CONFIG_BEFS_FS is not set
 # CONFIG_BFS_FS is not set
 # CONFIG_EFS_FS is not set
+# CONFIG_LOGFS is not set
 # CONFIG_CRAMFS is not set
 # CONFIG_SQUASHFS is not set
 # CONFIG_VXFS_FS is not set
@@ -1792,6 +1812,7 @@
 # CONFIG_RPCSEC_GSS_KRB5 is not set
 # CONFIG_RPCSEC_GSS_SPKM3 is not set
 # CONFIG_SMB_FS is not set
+# CONFIG_CEPH_FS is not set
 # CONFIG_CIFS is not set
 # CONFIG_NCP_FS is not set
 # CONFIG_CODA_FS is not set
@@ -2000,6 +2021,7 @@
 CONFIG_CRYPTO_MANAGER2=m
 # CONFIG_CRYPTO_GF128MUL is not set
 # CONFIG_CRYPTO_NULL is not set
+# CONFIG_CRYPTO_PCRYPT is not set
 CONFIG_CRYPTO_WORKQUEUE=m
 # CONFIG_CRYPTO_CRYPTD is not set
 CONFIG_CRYPTO_AUTHENC=m
@@ -2089,10 +2111,12 @@
 CONFIG_HAVE_KVM_IRQCHIP=y
 CONFIG_HAVE_KVM_EVENTFD=y
 CONFIG_KVM_APIC_ARCHITECTURE=y
+CONFIG_KVM_MMIO=y
 CONFIG_VIRTUALIZATION=y
 CONFIG_KVM=m
 # CONFIG_KVM_INTEL is not set
 CONFIG_KVM_AMD=m
+# CONFIG_VHOST_NET is not set
 # CONFIG_VIRTIO_PCI is not set
 # CONFIG_VIRTIO_BALLOON is not set
 # CONFIG_BINARY_PRINTF is not set

--------------010306030900010703040302--
