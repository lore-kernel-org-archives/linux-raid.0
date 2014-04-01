From: "nixbugz" <nixbugz@outlook.com>
Subject: Can't grow IMSM RAID5
Date: Tue, 1 Apr 2014 16:42:27 +0100
Message-ID: <DUB113-DS14AD0971A94EC90C73E3A6A9620@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed	reply-type=original
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello

I=E2=80=99m stuck trying to add a 4th disc to an IMSM RAID5 container:

# mdadm -a /dev/md127 /dev/sdb
mdadm: added /dev/sdb

# mdadm --grow --raid-devices=3D4=20
/dev/md127 --backup-file=3D/mnt/spare/raid-backup-file
mdadm: Cannot read superblock for /dev/md127

# cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md0 : active raid5 sdd[2] sda[1] sdc[0]
      1887436800 blocks super external:/md127/0 level 5, 128k chunk,=20
algorithm 0 [3/3] [UUU]

md1 : active (auto-read-only) raid5 sdc[2] sdd[1] sda[0]
      66077696 blocks super external:/md127/1 level 5, 128k chunk, algo=
rithm=20
0 [3/3] [UUU]

md127 : inactive sdb[3](S) sda[2](S) sdc[1](S) sdd[0](S)
      12612 blocks super external:imsm

unused devices: <none>

# mdadm =E2=80=93V
mdadm - v3.3 - 3rd September 2013


I don=E2=80=99t know if this is related but mdmon has trouble finding t=
he ports:

# mdadm --detail-platform -v
mdadm: checking metadata 0.90
mdadm: 0.90 metadata is platform independent
mdadm: checking metadata 1.x
mdadm: 1.x metadata is platform independent
mdadm: checking metadata ddf
mdadm: ddf metadata is platform independent
mdadm: checking metadata imsm
mdmon: found Intel(R) SATA RAID controller at 0000:00:1f.2.
       Platform : Intel(R) Matrix Storage Manager
        Version : 11.6.0.1702
    RAID Levels : raid0 raid1 raid10 raid5
    Chunk Sizes : 4k 8k 16k 32k 64k 128k
    2TB volumes : supported
      2TB disks : supported
      Max Disks : 6
    Max Volumes : 2 per array, 4 per controller
I/O Controller : /sys/devices/pci0000:00/0000:00:1f.2 (SATA)
mdmon: failed to determine port number for=20
/sys/devices/pci0000:00/0000:00:1f.2/ata1/host0/target0:0:0/0:0:0:0
mdmon: failed to enumerate ports on SATA controller at 0000:00:1f.2.
mdadm: checking metadata mbr
mdadm: mbr metadata is platform independent
mdadm: checking metadata gpt
mdadm: gpt metadata is platform independent
#

Thanks=20

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
