From: "Ulrich Windl" <Ulrich.Windl@rz.uni-regensburg.de>
Subject: Problems creating MS-RAID1: "device .. not suitable for any
 style of raid array" / "Device or resource busy"
Date: Fri, 06 May 2011 14:15:59 +0200
Message-ID: <4DC4029F020000A100005CA7@gwsmtp1.uni-regensburg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello!

I'm having strange trouble with SLES11 SP1 amd MD RAID1 (mdadm - v3.0.3 (mdadm-3.0.3-0.22.4), 2.6.32.36-0.5-xen):

I was able to create one RAID1 array, but not a second one. I have no idea what's wrong, but my guesses are:

1) An error when using "--bitmap internal" for a 30GB disk
2) Unsure whether the disks needs an msdos signature or a RAID partition
3) It seems a failed attempt to create the array keeps one device busy (a reboot(!) resolves that problem for one attempt)

Some output:
# mdadm -C -l1 -n2 --bitmap internal /dev/md0 /dev/xvdd /dev/xvde
mdadm: device /dev/xvdd not suitable for any style of array
(Reboot)
# mdadm -C -l1 -n2  /dev/md0 /dev/xvdd /dev/xvde
mdadm: /dev/xvdd appears to be part of a raid array:
    level=raid1 devices=2 ctime=Wed May  4 12:00:12 2011
Continue creating array? y
mdadm: array /dev/md0 started.

# mdadm --grow --bitmap internal /dev/md0
mdadm: failed to set internal bitmap.
# mdadm --stop /dev/md0
mdadm: stopped /dev/md0
# mdadm -C -l1 -n2 --bitmap internal /dev/md0 /dev/xvdd /dev/xvde
mdadm: /dev/xvdd appears to be part of a raid array:
    level=raid1 devices=2 ctime=Wed May  4 12:38:20 2011
mdadm: /dev/xvde appears to be part of a raid array:
    level=raid1 devices=2 ctime=Wed May  4 12:38:20 2011
Continue creating array? y
mdadm: failed to write superblock to /dev/xvdd
mdadm: ADD_NEW_DISK for /dev/xvde failed: Device or resource busy
# mdadm -C -l1 -n2 --bitmap internal /dev/md0 /dev/xvdd /dev/xvde
mdadm: device /dev/xvdd not suitable for any style of array
# xm reboot rksapv01
# mdadm -C -l1 -n2 --bitmap internal /dev/md0 /dev/xvdd /dev/xvde
mdadm: /dev/xvdd appears to be part of a raid array:
    level=raid1 devices=2 ctime=Wed May  4 13:26:55 2011
mdadm: /dev/xvde appears to be part of a raid array:
    level=raid1 devices=2 ctime=Wed May  4 12:38:20 2011
Continue creating array? y
mdadm: failed to write superblock to /dev/xvdd
mdadm: ADD_NEW_DISK for /dev/xvde failed: Device or resource busy

# mdadm -C -l1 -n2 --bitmap internal /dev/md0 /dev/xvdd /dev/xvde   
mdadm: /dev/xvdd appears to be part of a raid array:
    level=raid1 devices=2 ctime=Wed May  4 13:37:28 2011
mdadm: /dev/xvde appears to be part of a raid array:
    level=raid1 devices=2 ctime=Wed May  4 12:38:20 2011
Continue creating array? y
mdadm: failed to write superblock to /dev/xvdd
mdadm: ADD_NEW_DISK for /dev/xvde failed: Device or resource busy
# mdadm -C -l1 -n2 --bitmap internal /dev/md0 /dev/xvdd /dev/xvde
mdadm: device /dev/xvdd not suitable for any style of array

(At this point I filed a service request for SLES with no result until now)

Trying some other disks (of varying size):
# mdadm -C -l1 -n2 --bitmap internal /dev/md0 /dev/xvdd /dev/xvde   
mdadm: /dev/xvdd appears to be part of a raid array:
    level=raid1 devices=2 ctime=Wed May  4 13:37:28 2011
mdadm: /dev/xvde appears to be part of a raid array:
    level=raid1 devices=2 ctime=Wed May  4 12:38:20 2011
Continue creating array? y
mdadm: failed to write superblock to /dev/xvdd
mdadm: ADD_NEW_DISK for /dev/xvde failed: Device or resource busy
# mdadm -C -l1 -n2 --bitmap internal /dev/md0 /dev/xvdd /dev/xvde
mdadm: device /dev/xvdd not suitable for any style of array

(another Reboot)
# mdadm -C -l1 -n2 --bitmap internal /dev/md1 /dev/xvdf /dev/xvdg
mdadm: /dev/xvdf appears to be part of a raid array:
    level=raid1 devices=2 ctime=Wed May  4 16:36:59 2011
Continue creating array? y
mdadm: failed to write superblock to /dev/xvdf
mdadm: ADD_NEW_DISK for /dev/xvdg failed: Device or resource busy
# mdadm -C -l1 -n2 --bitmap internal /dev/md2 /dev/xvdh /dev/xvdi
mdadm: /dev/xvdh appears to be part of a raid array:
    level=raid1 devices=2 ctime=Wed May  4 16:37:26 2011
Continue creating array? y
mdadm: failed to write superblock to /dev/xvdh
mdadm: ADD_NEW_DISK for /dev/xvdi failed: Device or resource busy
# mdadm -C -l1 -n2 --bitmap internal /dev/md3 /dev/xvdj /dev/xvdk
mdadm: /dev/xvdj appears to be part of a raid array:
    level=raid1 devices=2 ctime=Wed May  4 16:37:38 2011
Continue creating array? y
mdadm: failed to write superblock to /dev/xvdj
mdadm: ADD_NEW_DISK for /dev/xvdk failed: Device or resource busy

Corresponding Syslog messages:
May  4 17:18:54 rksapv01 kernel: [  231.942241] md: bind<xvdf>
May  4 17:18:54 rksapv01 kernel: [  231.942265] md: could not bd_claim xvdg.
May  4 17:18:54 rksapv01 kernel: [  231.942269] md: md_import_device returned
-16
May  4 17:19:13 rksapv01 kernel: [  250.118561] md: bind<xvdh>
May  4 17:19:13 rksapv01 kernel: [  250.118586] md: could not bd_claim xvdi.
May  4 17:19:13 rksapv01 kernel: [  250.118590] md: md_import_device returned
-16
May  4 17:19:27 rksapv01 kernel: [  264.505337] md: bind<xvdj>
May  4 17:19:27 rksapv01 kernel: [  264.505365] md: could not bd_claim xvdk.
May  4 17:19:27 rksapv01 kernel: [  264.505368] md: md_import_device returned
-16

Do you understand that I'm quite frustrated? Maybe I should mention that the disks are from a FC-SAN with a 4-way multipath (multipath-tools-0.4.8-40.25.1). Also "lsof" finds no process that has the device open.

Finally: I had a similar problem with SLES10 SP3 which made me quit using MD-RAID about two years ago...

Regards,
Ulrich
P.S: I'm not subscribed to the list, so please CC: -- Thank you

