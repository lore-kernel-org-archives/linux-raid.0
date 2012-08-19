From: Jan Ceuleers <jan.ceuleers@computer.org>
Subject: Spares not added upon reboot after distro upgrade
Date: Sun, 19 Aug 2012 09:42:56 +0200
Message-ID: <50309900.9040108@computer.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi

I recently upgraded my server from Ubuntu 11.04 to 11.10. Now the spare=
s
are *usually* not added to my RAID sets upon reboot, although sometimes
they are.

I can re-add them manually. The way I do that is to check (using the
lsdrv script) what the current name is of the inactive components:

       =E2=94=9C=E2=94=80sde2: [8:66] MD raid1 (2) 517.72m inactive
{c2bfb80c-0cbf-5cd9-67c6-2432ead2ec0c}
       =E2=94=94=E2=94=80sde3: [8:67] MD raid1 (2) 465.27g inactive
{442e9934-9719-1d8e-6d0c-f7a941621837}

These UUIDs correspond with those of the active components.

I then add them by issuing the following commands:

root@zotac:~# mdadm /dev/md0 --add /dev/sde2
mdadm: re-added /dev/sde2
root@zotac:~# mdadm /dev/md1 --add /dev/sde3
mdadm: re-added /dev/sde3

If necessary I can keep doing that and perhaps even automate it, but it
would of course be nicer if the boot scripts did this properly to begin
with.

=46or the first time ever I tried mdadm's incremental mode. So before
issuing the above two commands I tried the following;

root@zotac:~# mdadm -I /dev/sde2
mdadm: failed to add /dev/sde2 to /dev/md0: Invalid argument.
root@zotac:~# mdadm -I /dev/sde3
mdadm: failed to add /dev/sde3 to /dev/md1: Invalid argument.

Should this have worked, given that both arrays were already running at
the time? At the very least mdadm did recognise which array to add each
component to, but then failed to do so.

I've also got all of this in dmesg. This spans the above four commands
(so the two incremental commands followed by the two add commands).

[ 2565.636128] scsi_verify_blk_ioctl: 180 callbacks suppressed
[ 2565.636133] mdadm: sending ioctl 1261 to a partition!
[ 2565.636137] mdadm: sending ioctl 1261 to a partition!
[ 2565.650234] mdadm: sending ioctl 1261 to a partition!
[ 2565.650239] mdadm: sending ioctl 1261 to a partition!
[ 2565.650406] mdadm: sending ioctl 1261 to a partition!
[ 2565.650411] mdadm: sending ioctl 1261 to a partition!
[ 2565.661713] mdadm: sending ioctl 1261 to a partition!
[ 2565.661717] mdadm: sending ioctl 1261 to a partition!
[ 2565.662129] mdadm: sending ioctl 800c0910 to a partition!
[ 2565.662135] mdadm: sending ioctl 800c0910 to a partition!
[ 2587.811007] scsi_verify_blk_ioctl: 90 callbacks suppressed
[ 2587.811014] mdadm: sending ioctl 1261 to a partition!
[ 2587.811018] mdadm: sending ioctl 1261 to a partition!
[ 2587.811458] mdadm: sending ioctl 1261 to a partition!
[ 2587.811462] mdadm: sending ioctl 1261 to a partition!
[ 2587.811609] mdadm: sending ioctl 1261 to a partition!
[ 2587.811614] mdadm: sending ioctl 1261 to a partition!
[ 2587.811754] mdadm: sending ioctl 1261 to a partition!
[ 2587.811758] mdadm: sending ioctl 1261 to a partition!
[ 2587.811908] mdadm: sending ioctl 800c0910 to a partition!
[ 2587.811912] mdadm: sending ioctl 800c0910 to a partition!
[ 2587.816893] md: export_rdev(sde2)
[ 2613.272894] scsi_verify_blk_ioctl: 12 callbacks suppressed
[ 2613.272898] mdadm: sending ioctl 1261 to a partition!
[ 2613.272900] mdadm: sending ioctl 1261 to a partition!
[ 2613.273185] mdadm: sending ioctl 1261 to a partition!
[ 2613.273188] mdadm: sending ioctl 1261 to a partition!
[ 2613.273265] mdadm: sending ioctl 1261 to a partition!
[ 2613.273267] mdadm: sending ioctl 1261 to a partition!
[ 2613.273345] mdadm: sending ioctl 1261 to a partition!
[ 2613.273348] mdadm: sending ioctl 1261 to a partition!
[ 2613.273433] mdadm: sending ioctl 800c0910 to a partition!
[ 2613.273436] mdadm: sending ioctl 800c0910 to a partition!
[ 2613.279607] md: export_rdev(sde3)
[ 2645.090983] scsi_verify_blk_ioctl: 12 callbacks suppressed
[ 2645.090986] mdadm: sending ioctl 1261 to a partition!
[ 2645.090988] mdadm: sending ioctl 1261 to a partition!
[ 2645.092538] mdadm: sending ioctl 1261 to a partition!
[ 2645.092540] mdadm: sending ioctl 1261 to a partition!
[ 2645.094318] md: bind<sde2>
[ 2645.154102] mdadm: sending ioctl 1261 to a partition!
[ 2645.154108] mdadm: sending ioctl 1261 to a partition!
[ 2645.161908] mdadm: sending ioctl 1261 to a partition!
[ 2645.161914] mdadm: sending ioctl 1261 to a partition!
[ 2658.141416] mdadm: sending ioctl 1261 to a partition!
[ 2658.141422] mdadm: sending ioctl 1261 to a partition!
[ 2658.144421] mdadm: sending ioctl 1261 to a partition!
[ 2658.144426] mdadm: sending ioctl 1261 to a partition!
[ 2658.150211] md: bind<sde3>
[ 2658.305418] mdadm: sending ioctl 1261 to a partition!
[ 2658.305421] mdadm: sending ioctl 1261 to a partition!
[ 2658.321620] mdadm: sending ioctl 1261 to a partition!
[ 2658.321624] mdadm: sending ioctl 1261 to a partition!

Kernel version:
[ 2658.321624] mdadm: sending ioctl 1261 to a partition!
root@zotac:~# uname -a
Linux zotac 3.0.0-24-generic #40-Ubuntu SMP Tue Jul 24 15:38:25 UTC 201=
2
x86_64 x86_64 x86_64 GNU/Linux

mdadm version:
root@zotac:~# mdadm -V
mdadm - v3.1.4 - 31st August 2010

root@zotac:~# cat /proc/mdstat
Personalities : [raid1] [linear] [multipath] [raid0] [raid6] [raid5]
[raid4] [raid10]
md1 : active raid1 sde3[2](S) sdd2[0] sdb2[1]
      487861824 blocks [2/2] [UU]
      bitmap: 1/4 pages [4KB], 65536KB chunk

md0 : active raid1 sde2[2](S) sdd1[0] sdb1[1]
      521984 blocks [2/2] [UU]
      bitmap: 0/1 pages [0KB], 65536KB chunk

unused devices: <none>

Any pointers would be gratefully received.

Thanks, Jan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
