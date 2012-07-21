From: "Peter Modrala" <x3m2@centrum.sk>
Subject: "A Nasty md/raid bug"
Date: Sat, 21 Jul 2012 16:16:07 +0200
Message-ID: <20120721161607.8820D2C3@centrum.sk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,
=C2=A0
I firstly installed ubuntu server 12.04 and set up LVM on top of RAID1.=
 After several days the system wasn't able to boot. RAID array was brok=
en. Then I found this bug on your page:
http://neil.brown.name/blog/20120615073245
Then I decided to install newest ubuntu alternate which provides 3.5.0-=
5 version of kernel. After instalation's very first reboot I got the sa=
me messages as previously.
I also installed linux-source-3.5.0 to verify the bug was fixed in this=
 version of kernel.
=C2=A0
I can provide you root access if you want to check anything on my serve=
r.
=C2=A0
Thank You
=C2=A0
Martin
=C2=A0
---
=C2=A0
# uname -a
Linux rat 3.5.0-5-generic #5-Ubuntu SMP Tue Jul 17 16:17:55 UTC 2012 x8=
6_64 x86_64 x86_64 GNU/Linux
=C2=A0
linux-source-3.5.0/drivers/md/md.c:
=2E..
static int md_notify_reboot(struct notifier_block *this,
 unsigned long code, void *x)
{
 struct list_head *tmp;
 struct mddev *mddev;
 int need_delay =3D 0;

 for_each_mddev(mddev, tmp) {
 if (mddev_trylock(mddev)) {
 if (mddev->pers)
 __md_stop_writes(mddev);
 mddev->safemode =3D 2;
 mddev_unlock(mddev);
 }
 need_delay =3D 1;
 }
 /*
 * certain more exotic SCSI devices are known to be
 * volatile wrt too early system reboots. While the
 * right place to handle this issue is the given
 * driver, we do want to have a safe RAID driver ...
 */
 if (need_delay)
 mdelay(1000*1);

 return NOTIFY_DONE;
}=C2=A0
=2E..
=C2=A0
=C2=A0
# update-grub
error: unknown LVM metadata header.
error: unknown LVM metadata header.
error: unknown LVM metadata header.
error: unknown LVM metadata header.
Generating grub.cfg ...
error: unknown LVM metadata header.
error: unknown LVM metadata header.
error: unknown LVM metadata header.
error: unknown LVM metadata header.
error: unknown LVM metadata header.
error: unknown LVM metadata header.
error: unknown LVM metadata header.
error: unknown LVM metadata header.
error: unknown LVM metadata header.
error: unknown LVM metadata header.
error: unknown LVM metadata header.
error: unknown LVM metadata header.
error: unknown LVM metadata header.
error: unknown LVM metadata header.
error: unknown LVM metadata header.
error: unknown LVM metadata header.
error: unknown LVM metadata header.
error: unknown LVM metadata header.
error: unknown LVM metadata header.
error: unknown LVM metadata header.
error: unknown LVM metadata header.
error: unknown LVM metadata header.
=46ound linux image: /boot/vmlinuz-3.5.0-5-generic
=46ound initrd image: /boot/initrd.img-3.5.0-5-generic
error: unknown LVM metadata header.
error: unknown LVM metadata header.
error: unknown LVM metadata header.
error: unknown LVM metadata header.
error: unknown LVM metadata header.
error: unknown LVM metadata header.
error: unknown LVM metadata header.
error: unknown LVM metadata header.
error: unknown LVM metadata header.
error: unknown LVM metadata header.
=46ound linux image: /boot/vmlinuz-3.5.0-5-generic
=46ound initrd image: /boot/initrd.img-3.5.0-5-generic
error: unknown LVM metadata header.
error: unknown LVM metadata header.
error: unknown LVM metadata header.
error: unknown LVM metadata header.
error: unknown LVM metadata header.
error: unknown LVM metadata header.
error: unknown LVM metadata header.
error: unknown LVM metadata header.
error: unknown LVM metadata header.
error: unknown LVM metadata header.
error: unknown LVM metadata header.
error: unknown LVM metadata header.
error: unknown LVM metadata header.
error: unknown LVM metadata header.
error: unknown LVM metadata header.
error: unknown LVM metadata header.
=46ound memtest86+ image: /boot/memtest86+.bin
done
=C2=A0
=C2=A0
# mdadm -Evvvvs
mdadm: No md superblock detected on /dev/dm-3.
mdadm: No md superblock detected on /dev/dm-2.
mdadm: No md superblock detected on /dev/dm-1.
mdadm: No md superblock detected on /dev/dm-0.
mdadm: No md superblock detected on /dev/md/0.
mdadm: No md superblock detected on /dev/sdb5.
/dev/sdb2:
 MBR Magic : aa55
Partition[0] : 683800576 sectors at 2 (type 8e)
/dev/sdb1:
 Magic : a92b4efc
 Version : 1.2
 Feature Map : 0x0
 Array UUID : dec31ddc:13aa86e0:d0635ca8:b630b4a5
 Name : rat:0 (local to host rat)
 Creation Time : Fri Jul 20 23:11:14 2012
 Raid Level : raid1
 Raid Devices : 2

 Avail Dev Size : 292704256 (139.57 GiB 149.86 GB)
 Array Size : 146352000 (139.57 GiB 149.86 GB)
 Used Dev Size : 292704000 (139.57 GiB 149.86 GB)
 Data Offset : 262144 sectors
 Super Offset : 8 sectors
 State : clean
 Device UUID : a9e91e4b:550235d5:de6f6a16:44d74be1

 Update Time : Sat Jul 21 16:06:32 2012
 Checksum : c91e067d - correct
 Events : 26


 Device Role : Active device 1
 Array State : AA ('A' =3D=3D active, '.' =3D=3D missing)
/dev/sdb:
 MBR Magic : aa55
Partition[0] : 292966400 sectors at 2048 (type fd)
Partition[1] : 683800578 sectors at 292970494 (type 05)
mdadm: No md superblock detected on /dev/sda5.
/dev/sda2:
 MBR Magic : aa55
Partition[0] : 683800576 sectors at 2 (type 8e)
/dev/sda1:
 Magic : a92b4efc
 Version : 1.2
 Feature Map : 0x0
 Array UUID : dec31ddc:13aa86e0:d0635ca8:b630b4a5
 Name : rat:0 (local to host rat)
 Creation Time : Fri Jul 20 23:11:14 2012
 Raid Level : raid1
 Raid Devices : 2

 Avail Dev Size : 292704256 (139.57 GiB 149.86 GB)
 Array Size : 146352000 (139.57 GiB 149.86 GB)
 Used Dev Size : 292704000 (139.57 GiB 149.86 GB)
 Data Offset : 262144 sectors
 Super Offset : 8 sectors
 State : clean
 Device UUID : 458f63c4:1a882d4d:1ce3c46c:b0da0244

 Update Time : Sat Jul 21 16:06:32 2012
 Checksum : 736ca887 - correct
 Events : 26


 Device Role : Active device 0
 Array State : AA ('A' =3D=3D active, '.' =3D=3D missing)
/dev/sda:
 MBR Magic : aa55
Partition[0] : 292966400 sectors at 2048 (type fd)
Partition[1] : 683800578 sectors at 292970494 (type 05)


=C2=A0
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
