From: David Waite <david@alkaline-solutions.com>
Subject: Re: Unable to (un)-grow raid6
Date: Sat, 5 Dec 2015 20:04:19 -0700
Message-ID: <465BF0F5-B5C7-4C02-8EB5-552B959B8D29@alkaline-solutions.com>
References: <4E26C335-DEDB-489E-B54E-A285273569A1@alkaline-solutions.com>
Mime-Version: 1.0 (Mac OS X Mail 9.1 \(3096.5\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E26C335-DEDB-489E-B54E-A285273569A1@alkaline-solutions.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I=E2=80=99m having difficulty shrinking down a RAID6 array (md2) on a S=
inology NAS. I wish to go from 13 drives to 11, and believe I need to g=
o to 12 first to maintain operation and redundancy through the resizing=
 process.

The -array-size has already been shrunk to account for the two drives I=
 wish to remove, and one of the devices has been removed and the machin=
e restarted before the command output below was generated.

---
# cat /proc/mdstat=20
Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [raid=
4]=20
md2 : active raid6 sda3[0] sdia3[14] sdib3[9] sdic3[10] sdid3[11] sdie3=
[12] sdg3[17] sdf3[5] sde3[16] sdd3[3] sdc3[13] sdb3[15]
      26329895935 blocks super 1.2 level 6, 64k chunk, algorithm 2 [13/=
12] [UUUUUUU_UUUUU]
     =20
md1 : active raid1 sda2[0] sdb2[1] sdc2[2] sdd2[3] sde2[4] sdf2[5] sdg2=
[6]
      2097088 blocks [8/7] [UUUUUUU_]
     =20
md0 : active raid1 sda1[0] sdb1[1] sdc1[2] sdd1[3] sde1[4] sdf1[5] sdg1=
[6]
      2490176 blocks [8/7] [UUUUUUU_]
     =20
unused devices: <none>

---

When running=20
# mdadm --grow -n 12 /dev/md2 --backup-file=3D/mnt/backup-file3
mdadm: max_devs [384] of [/dev/md2]
mdadm: Need to backup 7040K of critical section..
mdadm: Cannot set device shape for /dev/md2: Invalid argument

---

dmesg just reports:
[87908.606245] md: couldn't update array info. -22

---

# uname -a
Linux diskstation 3.10.77 #7135 SMP Thu Oct 15 13:36:56 CST 2015 x86_64=
 GNU/Linux synology_avoton_1815+

---

Anyone have advice on how to proceed? I thought shrinking of a RAID6 ar=
ray is supported as long as you use a backup file to allow recovery of =
the initial blocks

-DW

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
