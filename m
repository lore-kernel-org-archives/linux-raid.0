From: David Miller <millerdc@fusion.gat.com>
Subject: RAID6 mdadm --grow bug?
Date: Wed, 12 Sep 2007 17:39:08 -0700
Message-ID: <42161BFD-EAE6-4485-8DE6-05D0EBE51A06@fusion.gat.com>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=ISO-8859-1;
	delsp=yes	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



Problem:

The mdadm --grow command fails when trying to add disk to a RAID6.

The man page says it can do this.

"GROW MODE
        The GROW mode is used for changing the size or shape of an =20
active array.  For this to  work,
        the  kernel must support the necessary change.  Various types =20
of growth are being added dur-
        ing 2.6 development, including restructuring a raid5 array to =20
have more active devices.

        Currently the only support available is to

        =B7   change the "size" attribute for RAID1, RAID5 and RAID6.

        =B7   increase the "raid-disks" attribute of RAID1, RAID5, and =
=20
RAID6.

        =B7   add a write-intent bitmap to any array which supports =20
these bitmaps, or remove a  write-
            intent bitmap from such an array.
"

So far I have replicated this problem on RHEL5 and Ubuntu 7.04 =20
running the latest official updates and patches. I have even tried it =20
with the most latest version of mdadm 2.6.3 under RHEL5. RHEL5 uses =20
version 2.5.4.

How to replicate the problem:

You can either use real physical disks or use the loopback device to =20
create fake disks.

Here are the steps using the loopback method as root.

cd /tmp
dd if=3D/dev/zero of=3Drd1 bs=3D10240 count=3D10240
cp rd1 rd2;cp rd1 rd3;cp rd1 rd4;cp rd1 rd5
losetup /dev/loop1 rd1;losetup /dev/loop2 rd2;losetup /dev/loop3 =20
rd3;losetup /dev/loop4 rd4;losetup /dev/loop5 rd5
mdadm --create --verbose /dev/md0 --level=3D6 --raid-devices=3D4 /dev/=20
loop1 /dev/loop2 /dev/loop3 /dev/loop4

At this point wait a minute while the raid is being built.

mdadm --add /dev/md0 /dev/loop5
mdadm --grow /dev/md0 --raid-devices=3D5

You should get the following error

mdadm: Need to backup 384K of critical section..
mdadm: Cannot set device size/shape for /dev/md0: Invalid argument

How to clean up

mdadm --stop /dev/md0
mdadm --remove /dev/md0
losetup -d /dev/loop1;losetup -d /dev/loop2;losetup -d /dev/=20
loop3;losetup -d /dev/loop4;losetup -d /dev/loop5
rm rd1 rd2 rd3 rd4 rd5

David.
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
