From: 4363@list.ru
Subject: kernel panic with bitmap_startwrite
Date: Thu, 14 Nov 2013 07:24:58 +0400
Message-ID: <1636076445.20131114072458@list.ru>
Reply-To: 4363@list.ru
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello!
I have an IBM System x3200 M2 with Fibre HBA: Brocade Communications Systems, Inc. 415/815/41B/81B 4Gbps/8Gbps PCIe single port FC HBA (rev 01), on it installed Red Hat Enterprise Linux 5 kernel 2.6.18-238.19.1.
used native multipath-tools v0.4.7 (03/12, 2006) and mdadm.

#modinfo bfa

filename: /lib/modules/2.6.18-238.19.1.el5/kernel/drivers/scsi/bfa/bfa.ko
version: 2.1.2.0
author: Brocade Communications Systems, Inc.
description: Brocade Fibre Channel HBA Driver fcpim

and IBM DS 3512 with 2 LUN, LUN this raid6

configured multipath configuration:

#cat /etc/multipath.conf

defaults {
# user_friendly_names no
# polling_interval 2
# path_selector "round-robin 0"
# selector "round-robin 0"
# polling_interval 2
# find_multipaths yes
# flush_on_last_del yes
# checker_timeout 10
# failback immediate
# failback manual
# path_checker readsector0
# path_checker rdac
# path_grouping_policy failover
# path_grouping_policy multibus
# rr_min_io 100
# features 0
# no_path_retry fail
# getuid_callout "/sbin/scsi_id -g -u -s /block/%n"
# getuid_callout "/lib/udev/scsi_id --whitelisted --device=/dev/%n."
# prio_callout "/sbin/mpath_prio_rdac /dev/%n"
# dev_loss_tmo 10
# fast_io_fail_tmo 5
}#defaults
####################
blacklist {
devnode "sda"
wwid *
}#blacklist
####################
blacklist_exceptions {
#osnovnoy_1
wwid 360080e50002ef5ee00000bbe524a8ced
#rezerv_1
wwid 360080e50002ef5ee00000bc1524a8d93
}#blacklist_exceptions
####################
devices {
device {
vendor "IBM"
product "1746 FAStT"
# path_checker rdac
# path_selector "round-robin 0"
}#device
}#devices
####################
multipaths {
multipath {
wwid 360080e50002ef5ee00000bbe524a8ced
alias osnov_1
}
multipath {
wwid 360080e50002ef5ee00000bc1524a8d93
alias rezerv_1
}
}


#lsscsi
[0:2:0:0] disk IBM ServeRAID-MR10k 1.40 /dev/sda
[3:0:0:0] disk IBM 1746 FAStT 1070 /dev/sdb
[3:0:0:1] disk IBM 1746 FAStT 1070 /dev/sdf
[3:0:0:31] disk IBM Universal Xport 1070 -
[3:0:1:0] disk IBM 1746 FAStT 1070 /dev/sdh
[3:0:1:1] disk IBM 1746 FAStT 1070 /dev/sdi
[3:0:1:31] disk IBM Universal Xport 1070 -
[3:0:2:0] disk IBM 1746 FAStT 1070 /dev/sdj
[3:0:2:1] disk IBM 1746 FAStT 1070 /dev/sdk
[3:0:2:31] disk IBM Universal Xport 1070 -
[3:0:3:0] disk IBM 1746 FAStT 1070 /dev/sdl
[3:0:3:1] disk IBM 1746 FAStT 1070 /dev/sdm
[3:0:3:31] disk IBM Universal Xport 1070 -
[4:0:0:0] disk IBM 1746 FAStT 1070 /dev/sdc
[4:0:0:1] disk IBM 1746 FAStT 1070 /dev/sdd
[4:0:0:31] disk IBM Universal Xport 1070 -
[4:0:1:0] disk IBM 1746 FAStT 1070 /dev/sde
[4:0:1:1] disk IBM 1746 FAStT 1070 /dev/sdg
[4:0:1:31] disk IBM Universal Xport 1070 -
[4:0:2:0] disk IBM 1746 FAStT 1070 /dev/sdn
[4:0:2:1] disk IBM 1746 FAStT 1070 /dev/sdo
[4:0:2:31] disk IBM Universal Xport 1070 -
[4:0:3:0] disk IBM 1746 FAStT 1070 /dev/sdp
[4:0:3:1] disk IBM 1746 FAStT 1070 /dev/sdq
[4:0:3:31] disk IBM Universal Xport 1070 -


#multipath -ll
osnov_1 (360080e50002ef5ee00000bbe524a8ced) dm-2 IBM,1746 FAStT
[size=11T][features=3 queue_if_no_path pg_init_retries 50][hwhandler=1 rdac][rw]
\_ round-robin 0 [prio=400][active]
\_ 4:0:0:0 sdc 8:32 [active][ready]
\_ 3:0:1:0 sdh 8:112 [active][ready]
\_ 3:0:3:0 sdl 8:176 [active][ready]
\_ 4:0:2:0 sdn 8:208 [active][ready]
\_ round-robin 0 [prio=0][enabled]
\_ 3:0:0:0 sdb 8:16 [active][ghost]
\_ 4:0:1:0 sde 8:64 [active][ghost]
\_ 3:0:2:0 sdj 8:144 [active][ghost]
\_ 4:0:3:0 sdp 8:240 [active][ghost]
rezerv_1 (360080e50002ef5ee00000bc1524a8d93) dm-3 IBM,1746 FAStT
[size=11T][features=3 queue_if_no_path pg_init_retries 50][hwhandler=1 rdac][rw]
\_ round-robin 0 [prio=400][active]
\_ 4:0:0:1 sdd 8:48 [active][ready]
\_ 3:0:1:1 sdi 8:128 [active][ready]
\_ 3:0:3:1 sdm 8:192 [active][ready]
\_ 4:0:2:1 sdo 8:224 [active][ready]
\_ round-robin 0 [prio=0][enabled]
\_ 3:0:0:1 sdf 8:80 [active][ghost]
\_ 4:0:1:1 sdg 8:96 [active][ghost]
\_ 3:0:2:1 sdk 8:160 [active][ghost]
\_ 4:0:3:1 sdq 65:0 [active][ghost]


configured mdadm configuration:

#mdadm -D /dev/md0
mdadm: metadata format 1.00 unknown, ignored.
/dev/md0:
Version : 1.00
Creation Time : Tue Oct 22 12:34:01 2013
Raid Level : raid1
Array Size : 11718818096 (11175.94 GiB 12000.07 GB)
Used Dev Size : 11718818096 (11175.94 GiB 12000.07 GB)
Raid Devices : 2
Total Devices : 2
Preferred Minor : 0
Persistence : Superblock is persistent

Intent Bitmap : Internal

Update Time : Thu Oct 24 11:45:38 2013
State : active
Active Devices : 2
Working Devices : 2
Failed Devices : 0
Spare Devices : 0

Name : 0
UUID : cfffde5b:3f232606:f45a5be9:d7a5c4b2
Events : 21

Number Major Minor RaidDevice State
0 253 4 0 active sync /dev/dm-4
1 253 5 1 active sync /dev/dm-5


#cat /proc/mdstat
Personalities : [raid1]
md0 : active raid1 dm-4[0] dm-5[1]
11718818096 blocks super 1.0 [2/2] [UU]
bitmap: 0/11 pages [0KB], 524288KB chunk

unused devices: <none>


md0 is formatted in ext3

#tune2fs -l /dev/md0
tune2fs 1.39 (29-May-2006)
Filesystem volume name: <none>
Last mounted on: <not available>
Filesystem UUID: 6a2352e4-be78-4c53-80a3-a7e7614cb6c2
Filesystem magic number: 0xEF53
Filesystem revision #: 1 (dynamic)
Filesystem features: has_journal resize_inode dir_index filetype needs_recovery sparse_super large_file
Default mount options: (none)
Filesystem state: clean
Errors behavior: Continue
Filesystem OS type: Linux
Inode count: 1464860672
Block count: 2929704524
Reserved block count: 29297045
Free blocks: 2883691408
Free inodes: 1464860662
First block: 0
Block size: 4096
Fragment size: 4096
Reserved GDT blocks: 325
Blocks per group: 32768
Fragments per group: 32768
Inodes per group: 16384
Inode blocks per group: 512
Filesystem created: Wed Oct 23 09:16:11 2013
Last mount time: Thu Oct 24 11:45:33 2013
Last write time: Thu Oct 24 11:45:33 2013
Mount count: 5
Maximum mount count: 38
Last checked: Wed Oct 23 09:16:11 2013
Check interval: 15552000 (6 months)
Next check after: Mon Apr 21 09:16:11 2014
Reserved blocks uid: 0 (user root)
Reserved blocks gid: 0 (group root)
First inode: 11
Inode size: 128
Journal inode: 8
Default directory hash: tea
Directory Hash Seed: 82383c38-be3a-4096-9082-ad295ee3404e
Journal backup: inode blocks

md0 mounted on /osnov.
and using the command:
#dd if=/dev/zero of=/osnov/test bs=1MB count=1000
or 
simply copy from MCvs

we get:

Code: 0f 0b 68 ce fc 2c 88 c2 95 04 8d 42 01 66 89 45 00 c7 43 50
RIP [<ffffffff80218ab2>] bitmap_startwrite+0xb5/0x101
    RSP<ffff81105fbb9c20>
<0>Kernel panic - not syncing: Fatal exception

without bitmap all works!
You can get rid of this problem without installing new drivers and programs?




-- 
Yuriy Vet

