From: <linux-raid@stormagic.com>
Subject: Problems growing 1 disk linear md online after underlying disk grown
Date: Thu, 6 Dec 2012 19:12:02 -0000
Message-ID: <031601cdd3e5$95923150$c0b693f0$@stormagic.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-gb
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi, I presume this is the right place to report bugs in mdadm.

My goal is to be able to grow a linear md on a single disk whilst it is
online and in use.
The underlying disk is a VMDK mapped by ESX which has been grown.
I'm only growing it by a small amount here as an example, but in reality
this will be done on many live production systems with much larger values.
In case you're wondering why bother using md at all in this scenario - it
allows for the array to be expanded in the future, and also allows me to
programmatically treat it in a similar manor to more complex raid
configurations.

Here's my setup:

/root# uname -a
Linux protection 3.6.7 #1 SMP Thu Dec 6 12:11:50 GMT 2012 i686 pentium3 i386
GNU/Linux
/root# mdadm --version
mdadm - v3.2.6 - 25th October 2012

# I have a linear md on /dev/sde, SCSI HBTL 0:0:4:0, called ssss
# I have lvm configured on it:

/root# mdadm --detail /dev/md/ssss
/dev/md/ssss:
        Version : 1.2
  Creation Time : Thu Dec  6 16:43:39 2012
     Raid Level : linear
     Array Size : 10485752 (10.00 GiB 10.74 GB)
   Raid Devices : 1
  Total Devices : 1
    Persistence : Superblock is persistent

    Update Time : Thu Dec  6 16:43:39 2012
          State : clean
 Active Devices : 1
Working Devices : 1
 Failed Devices : 0
  Spare Devices : 0

       Rounding : 0K

           Name : protection:ssss  (local to host protection)
           UUID : 44e01539:be8065d8:b60ba374:cdf65c36
         Events : 0

    Number   Major   Minor   RaidDevice State
       0       8       64        0      active sync   /dev/sde
/root# mdadm --examine --scan --verbose /dev/sde
ARRAY /dev/md/ssss  level=linear metadata=1.2 num-devices=1
UUID=44e01539:be8065d8:b60ba374:cdf65c36 name=protection:ssss
   devices=/dev/sde

/root# basename $(readlink /sys/block/sde/device)
0:0:4:0

/root# readlink /dev/md/ssss
/dev/md127

/root# cat /proc/partitions | grep -E "major|sde|$(basename $(readlink
/dev/md/ssss))"
major minor  #blocks  name
   8       64   10485760 sde
   9      127   10485752 md127

# Ignore "Pool0", its "ssss" that we're looking at here

/root# pvs
  PV                VG        1st PE  PSize  PFree  Used   Attr PE   Alloc
PV Tags #PMda
  /dev/md/Pool0     Pool0       4.06M 15.99G 13.94G  2.05G a-   4094   525
1
  /dev/md/ssss      ssss        4.06M  9.99G  8.99G  1.00G a-   2558   256
1
/root# vgs
  Fmt  VG UUID                                VG        Attr   VSize  VFree
SYS ID Ext   #Ext Free MaxLV MaxPV #PV #LV #SN Seq VG Tags   #VMda VMdaFree
VMdaSize
  lvm2 0RAdw0-AulW-1oi5-0hUq-6bLF-kkC6-Xsw5OK Pool0     wz--n- 15.99G 13.94G
4.00M 4094 3569     0     0   1   3   0  74 CAP-16376     1     2.03M
4.06M
  lvm2 XrSOKA-S0aC-WWku-k13H-3NK6-w2lc-rJ11vA ssss      wz--n-  9.99G  8.99G
4.00M 2558 2302     0     0   1   1   0  13 CAP-6136      1     2.03M
4.06M
/root# lvs
  LV                   VG        Attr   LSize     Origin Snap%  Move Log
Copy%  Convert LV UUID                                Maj Min KMaj KMin
LSize     LV Tags
  uuiddfe9010300000011 Pool0     -wi-a-  1024.00M
K6V1Np-OE5M-s2aP-o9o5-f1jk-cF01-RMzeLh  -1  -1 253  1     1024.00M
  uuiddfe9010300000012 Pool0     -wi-ao  1024.00M
3GdYbX-L1SX-hMLG-R8Dd-Cu3y-XDkk-NHOV8F  -1  -1 253  2     1024.00M
  uuiddfe9010300000013 Pool0     -wi-a-    52.00M
2sOBWP-Wtnh-3fPw-Ebfu-fCx2-7PhQ-9GnGc8  -1  -1 253  3       52.00M
  uuiddfe9010300000014 ssss      -wi-a-  1024.00M
PiUyku-GzAD-KgkV-IiiC-8Ty8-r2TM-Sg11hA  -1  -1 253  0     1024.00M


# I Grow VMDK that is mapped to /dev/sde 0:0:4:0 in ESX by 1G

# I open the /dev/mapper/ssss-uuiddfe9010300000014 lvm volume file in python
to make it appear to be in use

# I tell linux I've grown the disk

/root# echo 1 > /sys/class/scsi_device/0:0:4:0/device/rescan

/root# cat /proc/partitions | grep -E "major|sde|$(basename $(readlink
/dev/md/ssss))"
major minor  #blocks  name
   8       64   11534336 sde
   9      127   10485752 md127

# I ask md to grow into the new space on the disk that has been extended

/root# mdadm --grow --size=max --array-size=max /dev/md/ssss
mdadm: component size of /dev/md/ssss unchanged at 0K

# bug: it doesn't grow.

# bug: it tells me it is 0K in size


# I try to stop the md array, which should fail due to my open file
desciptor on the lvm volume. I wouldn't usually be doing this, but it
appears to show another bug

/root# mdadm --stop /dev/md/ssss
mdadm: Cannot get exclusive access to /dev/md/ssss:Perhaps a running
process, mounted filesystem or active volume group?

# It says it can't stop it, but it's clearly ripped it out anyway. Anything
accessing it now gets IO errors.

/root# pvs
  /dev/md/ssss: read failed after 0 of 4096 at 0: Input/output error
  PV                VG        1st PE  PSize  PFree  Used   Attr PE   Alloc
PV Tags #PMda
  /dev/md/Pool0     Pool0       4.06M 15.99G 13.94G  2.05G a-   4094   525
1
/root# vgs
  /dev/md/ssss: read failed after 0 of 4096 at 0: Input/output error
  Fmt  VG UUID                                VG        Attr   VSize  VFree
SYS ID Ext   #Ext Free MaxLV MaxPV #PV #LV #SN Seq VG Tags   #VMda VMdaFree
VMdaSize
  lvm2 0RAdw0-AulW-1oi5-0hUq-6bLF-kkC6-Xsw5OK Pool0     wz--n- 15.99G 13.94G
4.00M 4094 3569     0     0   1   3   0  74 CAP-16376     1     2.03M
4.06M
/root# lvs
  /dev/md/ssss: read failed after 0 of 4096 at 0: Input/output error
  LV                   VG        Attr   LSize     Origin Snap%  Move Log
Copy%  Convert LV UUID                                Maj Min KMaj KMin
LSize     LV Tags
  uuiddfe9010300000011 Pool0     -wi-a-  1024.00M
K6V1Np-OE5M-s2aP-o9o5-f1jk-cF01-RMzeLh  -1  -1 253  1     1024.00M
  uuiddfe9010300000012 Pool0     -wi-ao  1024.00M
3GdYbX-L1SX-hMLG-R8Dd-Cu3y-XDkk-NHOV8F  -1  -1 253  2     1024.00M
  uuiddfe9010300000013 Pool0     -wi-a-    52.00M
2sOBWP-Wtnh-3fPw-Ebfu-fCx2-7PhQ-9GnGc8  -1  -1 253  3       52.00M





# OK, let's take a different approach. I've now rebooted and fixed it so I
have  good starting point. This time I'll reluctantly try it offline.

/root# cat /proc/partitions | grep -E "major|sde|$(basename $(readlink
/dev/md/ssss))"
major minor  #blocks  name
   8       64   11534336 sde
   9      127   11534328 md127

# I Grow VMDK that is mapped to /dev/sde 0:0:4:0 in ESX by 1G
# I tell linux I've grown the disk

/root# echo 1 > /sys/class/scsi_device/0:0:4:0/device/rescan
/root# cat /proc/partitions | grep -E "major|sde|$(basename $(readlink
/dev/md/ssss))"
major minor  #blocks  name
   8       64   12582912 sde
   9      127   11534328 md127

# I stop the md from being in use before stopping it, then reassembling

/root# lvchange -an /dev/mapper/ssss-uuiddfe9010300000014
/root# mdadm --stop /dev/md/ssss
mdadm: stopped /dev/md/ssss
/root# mdadm --grow --size=max --array-size=max /dev/md/ssss
mdadm: /dev/md/ssss is not an active md array - aborting
/root# mdadm --assemble /dev/md/ssss --uuid=44e01539be8065d8b60ba374cdf65c36
mdadm: /dev/md/ssss has been started with 1 drive.
/root# cat /proc/partitions | grep -E "major|sde|$(basename $(readlink
/dev/md/ssss))"
major minor  #blocks  name
   8       64   12582912 sde
   9      123   11534328 md123

# So I'm not allowed to grow it while offline.
# The md hasn't grown when I reassembled - but then I wouldn't expect it to
as I didn't specify --update=devicesize when assembling.
# Let's try growing again now its assembled

/root# mdadm --grow --size=max --array-size=max /dev/md/ssss
mdadm: component size of /dev/md/ssss unchanged at 0K
/root# cat /proc/partitions | grep -E "major|sde|$(basename $(readlink
/dev/md/ssss))"
major minor  #blocks  name
   8       64   12582912 sde
   9      123   11534328 md123

# So I still can't grow online

/root# mdadm --stop /dev/md/ssss
mdadm: stopped /dev/md/ssss
/root# mdadm --assemble /dev/md/ssss --uuid=44e01539be8065d8b60ba374cdf65c36
mdadm: /dev/md/ssss has been started with 1 drive.
/root# cat /proc/partitions | grep -E "major|sde|$(basename $(readlink
/dev/md/ssss))"
major minor  #blocks  name
   8       64   12582912 sde
   9      127   12582904 md127

# It appears that I can however grow it offline, but only if I ask it to do
so while online, which is a bit odd.

Please let me know if there's anything I've missed.

Thanks
Barry.



