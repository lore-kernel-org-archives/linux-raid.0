From: Arkadiusz Miskiewicz <arekm@pld-linux.org>
Subject: Fwd: starting an array on Linux, advise needed
Date: Sat, 17 Jan 2004 00:46:45 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200401170046.45895.arekm@pld-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I've asked Neil about that previously but he didn't respond, so I'm ask=
ing here....

----------  Przekazana wiadomo=B6=E6  ----------

Subject: starting an array on Linux, advise needed
Date: pon 15. grudnia 2003 13:35
=46rom: Arkadiusz Miskiewicz <arekm@pld-linux.org>
To: neilb@cse.unsw.edu.au

Hi,

I need smallest possible version of tool for starting md array on Linux=
=2E
 Right now I'm doing:

raid_start /dev/md0 /dev/hda1 /dev/hdb1 /dev/hdc1

and code does
fd_md =3D open(argv[1], O_RDWR, 0);

for (i =3D 2; i < argc; i++) {
       if (stat(argv[i], &st)) {
                       bb_perror_msg("error stating raid builing device
 `%s'", argv[i]);
                       continue;
        }

        if (ioctl(fd_md, START_ARRAY, (unsigned long) st.st_rdev) =3D=3D=
 -1) {
                       bb_perror_msg("error starting raid device `%s:%s=
'",
argv[1], argv[i]);
                       continue;
         }
         return 0;
}

return 1;

so it starts using first working device and tries to assemble array fro=
m
 other devices found in superblock.

Unfortunately there are some hard disk controllers which on 2.4
provide /dev/hdX devices while on 2.6 these are visible as /dev/sdX so =
even
raid_start /dev/md0 /dev/sda1 /dev/sdb1 /dev/sdc1 won't work because it=
 will
try to use /dev/sda1 and hdb1+hdc1 (from superblock).

How simplest possible version should look like - is this below ok?

fd_md =3D open(argv[1], O_RDWR, 0);
ioctl(fd_md, SET_ARRAY_INFO, NULL);
for (i =3D 2; i < argc; i++) {
       stat(argv[i], &disk);
       ioctl(fd_md, ADD_NEW_DISK, &disk);
}
ioctl(fd_md, RUN_ARRAY, NULL);

and what if some of these ioctls fails - would be safe to do
ioctl(fd_md, STOP_ARRAY, NULL)?

Thanks for help.
--
Arkadiusz Mi=B6kiewicz    CS at FoE, Wroclaw University of Technology
arekm.pld-linux.org AM2-6BONE, 1024/3DB19BBD, arekm(at)ircnet, PLD/Linu=
x

-------------------------------------------------------

The other problem is that after switching from 2.4.21 to 2.6.1 I got:
=46S: Mounted root (romfs filesystem) readonly.
+ insmod /lib/modumd: md driver 0.90.0 MAX_MD_DEVS=3D256, MD_SB_DISKS=3D=
27
les/2.6.1-1.csetraid5: measuring checksumming speed
20040116_0629smp   8regs     :   916.000 MB/sec
/kernel/drivers/   8regs_prefetch:   732.000 MB/sec
md/md.ko
Using    32regs    :   408.000 MB/sec
/lib/modules/2.6   32regs_prefetch:   400.000 MB/sec
=2E1-1.cset2004011   pIII_sse  :   996.000 MB/sec
6_0629smp/kernel   pII_mmx   :  1252.000 MB/sec
/drivers/md/md.k   p5_mmx    :  1308.000 MB/sec
o
+ insmod /libraid5: using function: pIII_sse (996.000 MB/sec)
/modules/2.6.1-1md: raid5 personality registered as nr 4
=2Ecset20040116_06SCSI subsystem initialized
29smp/kernel/drivers/md/xor.ko
Using /lib/modules/2.6.1-1.cset20040116_0629smp/kernel/drivers/md/xor.k=
o
+ insmod /lib/modules/2.6.1-1.cset20040116_0629smp/kernel/drivers/md/ra=
id5.ko
Using /lib/modules/2.6.1-1.cset20040116_0629smp/kernel/drivers/md/raid5=
=2Eko
+ insmod /lib/modules/2.6.1-1.cset20040116_0629smp/kernel/drivers/scsi/=
scsi_mod.ko
Using /lib/modules/2.6.1-1.cset20040116_0629smp/kernel/drivers/scsi/scs=
i_mod.ko
+ insmod /lib/modules/2.6.1-1.cset20040116_0629smp/kernel/drivers/scsi/=
sd_mod.ko
Using /lib/modules/2.6.1-1.cset20040116_0629smp/kernel/drivers/scsi/sd_=
mod.ko
+ insmod /lib/modules/2.6.1-1.cset20040116_0629smp/kernel/fs/jbd/jbd.ko
Using /lib/modules/2.6.1-1.cset20040116_0629smp/kernel/fs/jbd/jbd.ko
+ insmod /lib/modules/2.6.1-1.cset20040116_0629smp/kernel/fs/mbcache.km=
d: could not lock unknown-block(8,34).
o
Using /lib/momd: could not import unknown-block(8,34)!
dules/2.6.1-1.csmd: autostart unknown-block(0,2082) failed!
et20040116_0629smd: could not lock unknown-block(8,18).
mp/kernel/fs/mbcmd: could not import unknown-block(8,18)!
ache.ko
+ insmomd: autostart unknown-block(0,2066) failed!
d /lib/modules/2md: could not lock unknown-block(8,2).
=2E6.1-1.cset20040md: could not import unknown-block(8,2)!
116_0629smp/kernmd: autostart unknown-block(0,2050) failed!
el/fs/ext3/ext3.ko
Using /lib/modules/2.6.1-1.cset20040116_0629smp/kernel/fs/ext3/ext3.ko
+ raid_start /dev/md0 /dev/sdc2 /dev/sdb2 /dev/sda2
raid_start: error starting raid device `/dev/md0:/dev/sdc2': Invalid ar=
gument
raid_start: error starting raid device `/dev/md0:/dev/sdb2': Invalid ar=
gument
raid_start: error starting raid device `/dev/md0:/dev/sda2': Invalid ar=
gument
romfs: unable to read superblock
EXT3-fs: unable to read superblock
Kernel panic: VFS: Unable to mount root fs on md0

(kernel messages are unfortunately mixed with messages from userspace a=
pps)
--=20
Arkadiusz Mi=B6kiewicz    CS at FoE, Wroclaw University of Technology
arekm.pld-linux.org AM2-6BONE, 1024/3DB19BBD, arekm(at)ircnet, PLD/Linu=
x
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
