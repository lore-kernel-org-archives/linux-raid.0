From: Daniel Sanabria <sanabria.d@gmail.com>
Subject: Re: help please, can't mount/recover raid 5 array
Date: Sun, 10 Feb 2013 09:17:02 +0000
Message-ID: <CAHscji28x5v_-Qo2rSpa4mA2t7y9QGFQEdhTcrepHWX3hDJfxA@mail.gmail.com>
References: <CAHscji2-8KaKOA041VykHeA+jCEka5afgEoH=EHVGDak-D4UFg@mail.gmail.com>
	<CAKHEz2aE8dz3+GgfchYS7WsLxXjT+1adJbdeiBjqo2uiXzJbcw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAKHEz2aE8dz3+GgfchYS7WsLxXjT+1adJbdeiBjqo2uiXzJbcw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dave Cundiff <syshackmin@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Dave,

The upgrade was from fedora 16 to fedora 17 and I think the array was
created on F16 or F15. I didn't specify the metadata version when
recreating :(

Here's the output of pvdisplay and vgdisplay but I don't think I was
using LVM here (i know this from an output of an old kickstart the
anaconda-ks.cfg on f16):

[root@lamachine ~]#

[root@lamachine ~]# pvdisplay -v
    Scanning for physical volume names
  --- Physical volume ---
  PV Name               /dev/md127
  VG Name               libvirt_lvm
  PV Size               90.00 GiB / not usable 3.50 MiB
  Allocatable           yes
  PE Size               4.00 MiB
  Total PE              23038
  Free PE               5630
  Allocated PE          17408
  PV UUID               VmsWRd-8qHt-bauf-lvAn-FC97-KyH5-gk89ox

  --- Physical volume ---
  PV Name               /dev/md126
  VG Name               vg_bigblackbox
  PV Size               29.30 GiB / not usable 3.94 MiB
  Allocatable           yes
  PE Size               4.00 MiB
  Total PE              7499
  Free PE               1499
  Allocated PE          6000
  PV UUID               cE4ePh-RWO8-Wgdy-YPOY-ehyC-KI6u-io1cyH

[root@lamachine ~]# vgdisplay -v
    Finding all volume groups
    Finding volume group "libvirt_lvm"
  --- Volume group ---
  VG Name               libvirt_lvm
  System ID
  Format                lvm2
  Metadata Areas        1
  Metadata Sequence No  8
  VG Access             read/write
  VG Status             resizable
  MAX LV                0
  Cur LV                5
  Open LV               0
  Max PV                0
  Cur PV                1
  Act PV                1
  VG Size               89.99 GiB
  PE Size               4.00 MiB
  Total PE              23038
  Alloc PE / Size       17408 / 68.00 GiB
  Free  PE / Size       5630 / 21.99 GiB
  VG UUID               t8GQck-f2Eu-iD2V-fnJQ-kBm6-QyKw-dR31PB

  --- Logical volume ---
  LV Path                /dev/libvirt_lvm/win7
  LV Name                win7
  VG Name                libvirt_lvm
  LV UUID                uJaz2L-jhCy-kOU2-klnM-i6P7-I13O-5D1u3d
  LV Write Access        read/write
  LV Creation host, time ,
  LV Status              available
  # open                 0
  LV Size                25.00 GiB
  Current LE             6400
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     6144
  Block device           253:1

  --- Logical volume ---
  LV Path                /dev/libvirt_lvm/cms_test
  LV Name                cms_test
  VG Name                libvirt_lvm
  LV UUID                ix5PwP-Wket-9rAe-foq3-8hJY-jfVL-haCU6a
  LV Write Access        read/write
  LV Creation host, time ,
  LV Status              available
  # open                 0
  LV Size                8.00 GiB
  Current LE             2048
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     6144
  Block device           253:2

  --- Logical volume ---
  LV Path                /dev/libvirt_lvm/centos_updt
  LV Name                centos_updt
  VG Name                libvirt_lvm
  LV UUID                vp1nAZ-jZmX-BqMb-fuEL-kkto-1d6X-a15ecI
  LV Write Access        read/write
  LV Creation host, time ,
  LV Status              available
  # open                 0
  LV Size                8.00 GiB
  Current LE             2048
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     6144
  Block device           253:3

  --- Logical volume ---
  LV Path                /dev/libvirt_lvm/cms
  LV Name                cms
  VG Name                libvirt_lvm
  LV UUID                gInAgv-7LAQ-djtZ-Oc6P-xRME-dHU4-Wj885d
  LV Write Access        read/write
  LV Creation host, time ,
  LV Status              available
  # open                 0
  LV Size                8.00 GiB
  Current LE             2048
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     6144
  Block device           253:4

  --- Logical volume ---
  LV Path                /dev/libvirt_lvm/litp
  LV Name                litp
  VG Name                libvirt_lvm
  LV UUID                dbev0d-b7Tx-WXro-fMvN-dcm6-SH5N-ylIdlS
  LV Write Access        read/write
  LV Creation host, time ,
  LV Status              available
  # open                 0
  LV Size                19.00 GiB
  Current LE             4864
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     6144
  Block device           253:5

  --- Physical volumes ---
  PV Name               /dev/md127
  PV UUID               VmsWRd-8qHt-bauf-lvAn-FC97-KyH5-gk89ox
  PV Status             allocatable
  Total PE / Free PE    23038 / 5630

    Finding volume group "vg_bigblackbox"
  --- Volume group ---
  VG Name               vg_bigblackbox
  System ID
  Format                lvm2
  Metadata Areas        1
  Metadata Sequence No  5
  VG Access             read/write
  VG Status             resizable
  MAX LV                0
  Cur LV                4
  Open LV               4
  Max PV                0
  Cur PV                1
  Act PV                1
  VG Size               29.29 GiB
  PE Size               4.00 MiB
  Total PE              7499
  Alloc PE / Size       6000 / 23.44 GiB
  Free  PE / Size       1499 / 5.86 GiB
  VG UUID               VWfuwI-5v2q-w8qf-FEbc-BdGW-3mKX-pZd7hR

  --- Logical volume ---
  LV Path                /dev/vg_bigblackbox/LogVol_var
  LV Name                LogVol_var
  VG Name                vg_bigblackbox
  LV UUID                1NJcwG-01B4-6CSY-eijZ-bEES-Rcqd-tTM3ig
  LV Write Access        read/write
  LV Creation host, time ,
  LV Status              available
  # open                 1
  LV Size                3.91 GiB
  Current LE             1000
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:6

  --- Logical volume ---
  LV Path                /dev/vg_bigblackbox/LogVol_root
  LV Name                LogVol_root
  VG Name                vg_bigblackbox
  LV UUID                VTBWT0-OdxR-R5bG-ZiTV-oZAp-8KX0-s9ziS8
  LV Write Access        read/write
  LV Creation host, time ,
  LV Status              available
  # open                 1
  LV Size                9.77 GiB
  Current LE             2500
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:0

  --- Logical volume ---
  LV Path                /dev/vg_bigblackbox/LogVol_opt
  LV Name                LogVol_opt
  VG Name                vg_bigblackbox
  LV UUID                x8kbeS-erIn-X1oJ-5oXp-H2AK-HHHQ-Z3GnB1
  LV Write Access        read/write
  LV Creation host, time ,
  LV Status              available
  # open                 1
  LV Size                7.81 GiB
  Current LE             2000
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:7

  --- Logical volume ---
  LV Path                /dev/vg_bigblackbox/LogVol_tmp
  LV Name                LogVol_tmp
  VG Name                vg_bigblackbox
  LV UUID                j8A2Rv-KNo9-MmBV-WMEw-snIu-cfWU-HXkvnM
  LV Write Access        read/write
  LV Creation host, time ,
  LV Status              available
  # open                 1
  LV Size                1.95 GiB
  Current LE             500
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:8

  --- Physical volumes ---
  PV Name               /dev/md126
  PV UUID               cE4ePh-RWO8-Wgdy-YPOY-ehyC-KI6u-io1cyH
  PV Status             allocatable
  Total PE / Free PE    7499 / 1499

[root@lamachine ~]#

here's the output of the old kickstart file:

$ cat anaconda-ks.cfg
# Kickstart file automatically generated by anaconda.

#version=DEVEL
install
lang en_US.UTF-8
keyboard uk
network --onboot yes --device p20p1 --bootproto dhcp --noipv6
--hostname lamachine
timezone --utc Europe/London
rootpw  --iscrypted
$6$Ue9iCKeAVqBBTb24$mZFg.v4BjFAM/gD8FOaZBPTu.7PLixoZNWVsa6L65eHl1aON3m.CmTB7ni1gnuH7KqUzG2UPmCOyPEocdByh.1
selinux --enforcing
authconfig --enableshadow --passalgo=sha512
firewall --service=ssh
# The following is the partition information you requested
# Note that any partitions you deleted are not expressed
# here so unless you clear all partitions first, this is
# not guaranteed to work
#clearpart --none



#part  --onpart=sdc6 --noformat
#part raid.008037 --onpart=sdc5 --noformat
#part raid.008034 --onpart=sdc2 --noformat
#part raid.008033 --onpart=sdc1 --noformat


#part  --onpart=sdb6 --noformat
#part raid.008021 --onpart=sdb5 --noformat
#part swap --onpart=sdb3 --noformat
#part raid.008018 --onpart=sdb2 --noformat


#part  --onpart=sda6 --noformat
#part raid.008005 --onpart=sda5 --noformat
#raid pv.009003 --level=0 --device=md3 --useexisting --noformat
raid.008005 raid.008021 raid.008037
#volgroup libvirt_lvm --pesize=4096 --useexisting --noformat pv.009003
#logvol  --name=win7 --vgname=libvirt_lvm --useexisting --noformat
#logvol  --name=litp --vgname=libvirt_lvm --useexisting --noformat
#logvol  --name=cms_test --vgname=libvirt_lvm --useexisting --noformat
#logvol  --name=cms --vgname=libvirt_lvm --useexisting --noformat
#logvol  --name=centos_updt --vgname=libvirt_lvm --useexisting --noformat
#part raid.008003 --onpart=sda3 --noformat
#raid /home --fstype=ext4 --level=5 --device=md2 --useexisting
--noformat raid.008003 raid.008018 raid.008034
#part raid.008002 --onpart=sda2 --noformat
#raid pv.009001 --level=10 --device=md1 --useexisting --noformat
raid.008002 raid.008033
#volgroup vg_bigblackbox --pesize=4096 --useexisting --noformat pv.009001
#logvol /var --fstype=ext4 --name=LogVol_var --vgname=vg_bigblackbox
--useexisting
#logvol /tmp --fstype=ext4 --name=LogVol_tmp --vgname=vg_bigblackbox
--useexisting
#logvol / --fstype=ext4 --name=LogVol_root --vgname=vg_bigblackbox --useexisting
#logvol /opt --fstype=ext4 --name=LogVol_opt --vgname=vg_bigblackbox
--useexisting
#part /boot --fstype=ext4 --onpart=sda1








bootloader --location=mbr --timeout=5 --driveorder=sda,sdb,sdc
--append="nomodeset quiet rhgb"
repo --name="Fedora 16 - x86_64"
--baseurl=http://mirror.bytemark.co.uk/fedora/linux/releases/16/Everything/x86_64/os/
--cost=1000
repo --name="Fedora 16 - x86_64 - Updates"
--baseurl=http://mirror.bytemark.co.uk/fedora/linux/updates/16/x86_64/
--cost=1000

%packages
@core
@online-docs
@virtualization
python-libguestfs
virt-top
libguestfs-tools
guestfs-browser
%end
$

Regards,

Daniel

On 9 February 2013 23:00, Dave Cundiff <syshackmin@gmail.com> wrote:
> On Sat, Feb 9, 2013 at 4:03 PM, Daniel Sanabria <sanabria.d@gmail.com> wrote:
>> Hi,
>>
>> I'm having issues with my raid 5 array after upgrading my os and I
>> have to say I'm desperate :-(
>>
>> whenever I try to mount the array I get the following:
>>
>> [root@lamachine ~]# mount /mnt/raid/
>> mount: /dev/sda3 is already mounted or /mnt/raid busy
>> [root@lamachine ~]#
>>
>> and the messages log is recording the following:
>>
>> Feb  9 20:25:10 lamachine kernel: [ 3887.287305] EXT4-fs (md2): VFS:
>> Can't find ext4 filesystem
>> Feb  9 20:25:10 lamachine kernel: [ 3887.304025] EXT4-fs (md2): VFS:
>> Can't find ext4 filesystem
>> Feb  9 20:25:10 lamachine kernel: [ 3887.320702] EXT4-fs (md2): VFS:
>> Can't find ext4 filesystem
>> Feb  9 20:25:10 lamachine kernel: [ 3887.353233] ISOFS: Unable to
>> identify CD-ROM format.
>> Feb  9 20:25:10 lamachine kernel: [ 3887.353571] FAT-fs (md2): invalid
>> media value (0x82)
>> Feb  9 20:25:10 lamachine kernel: [ 3887.368809] FAT-fs (md2): Can't
>> find a valid FAT filesystem
>> Feb  9 20:25:10 lamachine kernel: [ 3887.369140] hfs: can't find a HFS
>> filesystem on dev md2.
>> Feb  9 20:25:10 lamachine kernel: [ 3887.369665] hfs: unable to find
>> HFS+ superblock
>>
>> /etc/fstab is as follows:
>>
>> [root@lamachine ~]# cat /etc/fstab
>>
>> #
>> # /etc/fstab
>> # Created by anaconda on Fri Feb  8 17:33:14 2013
>> #
>> # Accessible filesystems, by reference, are maintained under '/dev/disk'
>> # See man pages fstab(5), findfs(8), mount(8) and/or blkid(8) for more info
>> #
>> /dev/mapper/vg_bigblackbox-LogVol_root /                       ext4
>> defaults        1 1
>> UUID=7bee0f50-3e23-4a5b-bfb5-42006d6c8561 /boot                   ext4
>>    defaults        1 2
>> UUID=48be851b-f021-0b64-e9fb-efdf24c84c5f /mnt/raid ext4 defaults 1 2
>> /dev/mapper/vg_bigblackbox-LogVol_opt /opt                    ext4
>> defaults        1 2
>> /dev/mapper/vg_bigblackbox-LogVol_tmp /tmp                    ext4
>> defaults        1 2
>> /dev/mapper/vg_bigblackbox-LogVol_var /var                    ext4
>> defaults        1 2
>> UUID=70933ff3-8ed0-4486-abf1-01f00023d1b2 swap                    swap
>>    defaults        0 0
>> [root@lamachine ~]#
>>
>> After the upgrade I had to assemble the array manually and didn't get
>> any errors but I was still getting the mount problem. I went ahead and
>> recreated it with mdadm --create --assume-clean and still the smae result.
>>
>> here's some more info about md2:
>> [root@lamachine ~]# mdadm --misc --detail /dev/md2
>> /dev/md2:
>>         Version : 1.2
>>   Creation Time : Sat Feb  9 17:30:32 2013
>>      Raid Level : raid5
>>      Array Size : 511996928 (488.28 GiB 524.28 GB)
>>   Used Dev Size : 255998464 (244.14 GiB 262.14 GB)
>>    Raid Devices : 3
>>   Total Devices : 3
>>     Persistence : Superblock is persistent
>>
>>     Update Time : Sat Feb  9 20:47:46 2013
>>           State : clean
>>  Active Devices : 3
>> Working Devices : 3
>>  Failed Devices : 0
>>   Spare Devices : 0
>>
>>          Layout : left-symmetric
>>      Chunk Size : 512K
>>
>>            Name : lamachine:2  (local to host lamachine)
>>            UUID : 48be851b:f0210b64:e9fbefdf:24c84c5f
>>          Events : 2
>>
>>     Number   Major   Minor   RaidDevice State
>>        0       8        3        0      active sync   /dev/sda3
>>        1       8       18        1      active sync   /dev/sdb2
>>        2       8       34        2      active sync   /dev/sdc2
>> [root@lamachine ~]#
>>
>> it looks like it know about how much space is being used which might
>> indicate that the data is still there?
>>
>> what can I do to recover the data?
>>
>> Any  help or guidance is more than welcome.
>>
>> Thanks in advance,
>>
>> Dan
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> What OS did you upgrade from and to? What OS was the array originally
> created on?
>
> Looks like you have LVM on top the of md array so the output of
> pvdisplay and vgdisplay would be useful.
>
> Did you specify metadata version when re-creating the array?
> Recreating the array at best changed the UUID, and depending on what
> OS the array was created on, overwrote the beginning of your
> partitions.
>
> --
> Dave Cundiff
> System Administrator
> A2Hosting, Inc
> http://www.a2hosting.com
