From: Manuel Arostegui <manuel@tuenti.com>
Subject: Lenny to squeeze mdadm problem + e2label problem
Date: Wed, 22 Feb 2012 12:44:26 +0100
Message-ID: <CAA8xrZdnBD+GTgk759aQigey0qVBQk-FsMj27_3ik8bjnTP_jw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hey all,

Whilst trying to upgrade one box from Debian Lenny to Debian Squeeze I
have run into some problems with mdadm and the RAID labeling.

Kernel: 2.6.32-41
mdadm version: v3.1.4
Disks: 4

RAID devices:
/dev/md0 - boot - RAID1 - ext3
/dev/md1 swap
/dev/md2 - "/" - RAID1 - ext3
/dev/md3 - "/var/lib/mysql" - RAID10 - xfs

When doing the dist-upgrade and replacing the kernel + udev the system
changes the RAID devices to md124, md125, md126 etc.
As far as I have read, this makes sense - as mdadm is changing
superblock and has to recalculate the whole RAID. This is big problem,
if you have devices into /etc/fstab, like we do.

As this is kinda from the past, we have tried to label the RAID
devices in order to boot up using labels. As in the future migrations,
no one knows if this can arise again and using labels would prevent us
from having these kind of problems.

We used e2label for the ext3 partitions and xfs_admin for the XFS one.

Everything was fine when checking with blkid. We could see the labels
fine in /dev/mdX.
When rebooting, the machine won't boot up:

ALERT! /dev/disk/by-uuid/c018-etc-etc... does not exist


If we re-check the labels we can see all the devices got the same
label (the one assigned to md0, md1 etc), so probably grub is trying
to boot from single devices, and not from the md0 which is /boot
This is blkid's output:

/dev/sdb1: LABEL=3D"boot" UUID=3D"6d15111c-d2d9-4636-b2a5-7954ddcbcae2"
SEC_TYPE=3D"ext2" TYPE=3D"ext3"
/dev/sdb2: LABEL=3D"swap" UUID=3D"af027073-b59e-4886-9e5a-e3bad38ae466"=
 TYPE=3D"swap"
/dev/sdb3: LABEL=3D"/" UUID=3D"c8e78ff4-b165-45d4-9382-ed669e5650dc"
SEC_TYPE=3D"ext2" TYPE=3D"ext3"
/dev/sdc1: LABEL=3D"boot" UUID=3D"6d15111c-d2d9-4636-b2a5-7954ddcbcae2"
SEC_TYPE=3D"ext2" TYPE=3D"ext3"
/dev/sdc2: LABEL=3D"swap" UUID=3D"af027073-b59e-4886-9e5a-e3bad38ae466"=
 TYPE=3D"swap"
/dev/sdc3: LABEL=3D"/" UUID=3D"c8e78ff4-b165-45d4-9382-ed669e5650dc"
SEC_TYPE=3D"ext2" TYPE=3D"ext3"
/dev/sdd1: LABEL=3D"boot" UUID=3D"6d15111c-d2d9-4636-b2a5-7954ddcbcae2"
SEC_TYPE=3D"ext2" TYPE=3D"ext3"
/dev/sdd2: LABEL=3D"swap" UUID=3D"af027073-b59e-4886-9e5a-e3bad38ae466"=
 TYPE=3D"swap"
/dev/sdd3: LABEL=3D"/" UUID=3D"c8e78ff4-b165-45d4-9382-ed669e5650dc"
SEC_TYPE=3D"ext2" TYPE=3D"ext3"

<snip>

/dev/md0: LABEL=3D"boot" UUID=3D"6d15111c-d2d9-4636-b2a5-7954ddcbcae2"
SEC_TYPE=3D"ext2" TYPE=3D"ext3"
/dev/md1: LABEL=3D"swap" UUID=3D"af027073-b59e-4886-9e5a-e3bad38ae466" =
TYPE=3D"swap"
/dev/md2: LABEL=3D"/" UUID=3D"c8e78ff4-b165-45d4-9382-ed669e5650dc"
SEC_TYPE=3D"ext2" TYPE=3D"ext3"
/dev/md3: LABEL=3D"mysql" UUID=3D"e627f664-f929-4be8-815e-9e3cf559e512"=
 TYPE=3D"xfs"


As we have to migrate loads of machines, using labels is the fastest
and cleanest way to do it. Just create the labels and change
/etc/fstab across all the machines and voil=E1. But we cannot get it
running. Is there any workaround to work with labels and avoid all the
disks in the raid to get them as well?.
Using UUID doesn't seem like a good idea, as they may change with
future dist-upgrades, mdadm upgrades etc.

Has someone had same/similar problem with mdadm?

Thanks a lot
Manuel
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
