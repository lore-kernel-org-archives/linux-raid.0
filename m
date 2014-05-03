From: Chris Murphy <lists@colorremedies.com>
Subject: task mdadm blocked when stopping array, 3.15rc3
Date: Sat, 3 May 2014 17:16:18 -0600
Message-ID: <D2C55A8C-95E1-4DC0-8DC1-3D640C2CF5A8@colorremedies.com>
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org List" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

When I issue mdadm -S /dev/md0, I get a hang which does not recover after 30+ minutes. This is what appears in dmesg (partial), but I also have issued sysrq-w and included a followup dmesg and journalctl both of which are attached to this kernel bug because it's so wide it just looks ugly in email:

https://bugzilla.kernel.org/show_bug.cgi?id=75451

dmesg partial:

[  596.109426] rawhide.localdomain kernel: kworker/u6:7 (76) used greatest stack depth: 1872 bytes left
[  600.363333] rawhide.localdomain kernel: INFO: task mdadm:1209 blocked for more than 120 seconds.
[  600.363668] rawhide.localdomain kernel:       Not tainted 3.15.0-0.rc3.git3.1.fc21.x86_64 #1
[  600.363668] rawhide.localdomain kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  600.363668] rawhide.localdomain kernel: mdadm           D ffff880088abcd40  5464  1209   1055 0x00000080
[  600.363668] rawhide.localdomain kernel:  ffff880088be7c40 0000000000000046 ffff880088abcd40 00000000001d5dc0
[  600.363668] rawhide.localdomain kernel:  ffff880088be7fd8 00000000001d5dc0 ffff880099193380 ffff880000144710
[  600.363668] rawhide.localdomain kernel:  ffff880000144600 ffff880088be7c60 ffff880000144778 0000000000000001
[  600.363668] rawhide.localdomain kernel: Call Trace:
[  600.363668] rawhide.localdomain kernel:  [<ffffffff817ec479>] schedule+0x29/0x70
[  600.363668] rawhide.localdomain kernel:  [<ffffffffa031cbe5>] raise_barrier+0x135/0x1a0 [raid10]
[  600.363668] rawhide.localdomain kernel:  [<ffffffff810eed10>] ? abort_exclusive_wait+0xb0/0xb0
[  600.363668] rawhide.localdomain kernel:  [<ffffffffa031d58c>] stop+0x1c/0x90 [raid10]
[  600.363668] rawhide.localdomain kernel:  [<ffffffff8160589b>] __md_stop+0x1b/0x60
[  600.363668] rawhide.localdomain kernel:  [<ffffffff81613337>] do_md_stop+0x157/0x570
[  600.363668] rawhide.localdomain kernel:  [<ffffffff81614099>] ? md_ioctl+0x179/0x1d40
[  600.363668] rawhide.localdomain kernel:  [<ffffffff810f8f6d>] ? trace_hardirqs_on_caller+0x15d/0x200
[  600.363668] rawhide.localdomain kernel:  [<ffffffff81614cf5>] md_ioctl+0xdd5/0x1d40
[  600.363668] rawhide.localdomain kernel:  [<ffffffff810dbb26>] ? local_clock+0x16/0x30
[  600.363668] rawhide.localdomain kernel:  [<ffffffff810f5a7f>] ? lock_release_holdtime.part.28+0xf/0x200
[  600.363668] rawhide.localdomain kernel:  [<ffffffff8135e90a>] ? avc_has_perm+0x15a/0x350
[  600.363668] rawhide.localdomain kernel:  [<ffffffff8135e7e4>] ? avc_has_perm+0x34/0x350
[  600.363668] rawhide.localdomain kernel:  [<ffffffff813b0bcc>] blkdev_ioctl+0x1cc/0x840
[  600.363668] rawhide.localdomain kernel:  [<ffffffff8127e763>] block_ioctl+0x43/0x50
[  600.363668] rawhide.localdomain kernel:  [<ffffffff812513e0>] do_vfs_ioctl+0x2f0/0x520
[  600.363668] rawhide.localdomain kernel:  [<ffffffff81251691>] SyS_ioctl+0x81/0xa0
[  600.363668] rawhide.localdomain kernel:  [<ffffffff81155eac>] ? __audit_syscall_entry+0x9c/0xf0
[  600.363668] rawhide.localdomain kernel:  [<ffffffff817fca29>] system_call_fastpath+0x16/0x1b
[  600.363668] rawhide.localdomain kernel: 2 locks held by mdadm/1209:
[  600.363668] rawhide.localdomain kernel:  #0:  (&mddev->reconfig_mutex){+.+.+.}, at: [<ffffffff816132ba>] do_md_stop+0xda/0x570
[  600.363668] rawhide.localdomain kernel:  #1:  (&mddev->open_mutex){+.+.+.}, at: [<ffffffff816132cf>] do_md_stop+0xef/0x570
[  631.441218] rawhide.localdomain systemd[1]: Starting dnf makecache...
[  632.838884] rawhide.localdomain dnf[1213]: Config time: 0.079
[  632.845277] rawhide.localdomain dnf[1213]: cachedir: /var/cache/dnf/x86_64/21
[  632.886277] rawhide.localdomain dnf[1213]: dnf version: 0.4.20
[  632.903309] rawhide.localdomain dnf[1213]: Making cache files for all metadata files.
[  632.977230] rawhide.localdomain dnf[1213]: Metadata cache refreshed recently.
[  633.153699] rawhide.localdomain systemd[1]: Started dnf makecache.
[  720.363842] rawhide.localdomain kernel: INFO: task mdadm:1209 blocked for more than 120 seconds.
[  720.364012] rawhide.localdomain kernel:       Not tainted 3.15.0-0.rc3.git3.1.fc21.x86_64 #1
[  720.364948] rawhide.localdomain kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  720.373340] rawhide.localdomain kernel: mdadm           D ffff880088abcd40  5464  1209   1055 0x00000080
[  720.374515] rawhide.localdomain kernel:  ffff880088be7c40 0000000000000046 ffff880088abcd40 00000000001d5dc0
[  720.375523] rawhide.localdomain kernel:  ffff880088be7fd8 00000000001d5dc0 ffff880099193380 ffff880000144710
[  720.376624] rawhide.localdomain kernel:  ffff880000144600 ffff880088be7c60 ffff880000144778 0000000000000001
[  720.377007] rawhide.localdomain kernel: Call Trace:
[  720.377762] rawhide.localdomain kernel:  [<ffffffff817ec479>] schedule+0x29/0x70
[  720.378217] rawhide.localdomain kernel:  [<ffffffffa031cbe5>] raise_barrier+0x135/0x1a0 [raid10]
[  720.378922] rawhide.localdomain kernel:  [<ffffffff810eed10>] ? abort_exclusive_wait+0xb0/0xb0
[  720.383370] rawhide.localdomain kernel:  [<ffffffffa031d58c>] stop+0x1c/0x90 [raid10]
[  720.385210] rawhide.localdomain kernel:  [<ffffffff8160589b>] __md_stop+0x1b/0x60
[  720.385842] rawhide.localdomain kernel:  [<ffffffff81613337>] do_md_stop+0x157/0x570
[  720.386619] rawhide.localdomain kernel:  [<ffffffff81614099>] ? md_ioctl+0x179/0x1d40
[  720.387351] rawhide.localdomain kernel:  [<ffffffff810f8f6d>] ? trace_hardirqs_on_caller+0x15d/0x200
[  720.387924] rawhide.localdomain kernel:  [<ffffffff81614cf5>] md_ioctl+0xdd5/0x1d40
[  720.388639] rawhide.localdomain kernel:  [<ffffffff810dbb26>] ? local_clock+0x16/0x30
[  720.389361] rawhide.localdomain kernel:  [<ffffffff810f5a7f>] ? lock_release_holdtime.part.28+0xf/0x200
[  720.389917] rawhide.localdomain kernel:  [<ffffffff8135e90a>] ? avc_has_perm+0x15a/0x350
[  720.390633] rawhide.localdomain kernel:  [<ffffffff8135e7e4>] ? avc_has_perm+0x34/0x350
[  720.391295] rawhide.localdomain kernel:  [<ffffffff813b0bcc>] blkdev_ioctl+0x1cc/0x840
[  720.391835] rawhide.localdomain kernel:  [<ffffffff8127e763>] block_ioctl+0x43/0x50
[  720.392501] rawhide.localdomain kernel:  [<ffffffff812513e0>] do_vfs_ioctl+0x2f0/0x520
[  720.393187] rawhide.localdomain kernel:  [<ffffffff81251691>] SyS_ioctl+0x81/0xa0
[  720.393692] rawhide.localdomain kernel:  [<ffffffff81155eac>] ? __audit_syscall_entry+0x9c/0xf0
[  720.393894] rawhide.localdomain kernel:  [<ffffffff817fca29>] system_call_fastpath+0x16/0x1b
[  720.394313] rawhide.localdomain kernel: 2 locks held by mdadm/1209:
[  720.394798] rawhide.localdomain kernel:  #0:  (&mddev->reconfig_mutex){+.+.+.}, at: [<ffffffff816132ba>] do_md_stop+0xda/0x570
[  720.395450] rawhide.localdomain kernel:  #1:  (&mddev->open_mutex){+.+.+.}, at: [<ffffffff816132cf>] do_md_stop+0xef/0x570



avc_has_perm looks selinux related, but enforcing=0

Also, after rebooting it's possible to stop the array without error. It only seems to happen when issued shortly after umount. So I'm not really sure what's going on here.




Setup:
VirtualBox 4.3.10 2.5G RAM, 3 CPUs, 3x 8GB virtual disks are on SATA
+ Fedora Rawhide

Versions:
kernel-3.15.0-0.rc3.git0.1.fc21.x86_64
kernel-3.15.0-0.rc3.git3.1.fc21.x86_64 (debug kernel)
mdadm-3.3-7.fc21.x86_64


Reproduce steps:
# mdadm -C /dev/md0 -n 3 -l raid10 --assume-clean /dev/sd[bcd]
# mkfs.xfs /dev/md0
# mount /dev/md0 /mnt
# umount /mnt
# mdadm -S /dev/md0

--hang--

Additional info:

# mdadm -D /dev/md0
/dev/md0:
        Version : 1.2
  Creation Time : Sat May  3 16:47:43 2014
     Raid Level : raid10
     Array Size : 12570624 (11.99 GiB 12.87 GB)
  Used Dev Size : 8380416 (7.99 GiB 8.58 GB)
   Raid Devices : 3
  Total Devices : 3
    Persistence : Superblock is persistent

    Update Time : Sat May  3 16:47:43 2014
          State : clean 
 Active Devices : 3
Working Devices : 3
 Failed Devices : 0
  Spare Devices : 0

         Layout : near=2
     Chunk Size : 512K

           Name : rawhide.localdomain:0  (local to host rawhide.localdomain)
           UUID : c9aa4d6c:0870ebeb:1fb70b0a:3af4bdf3
         Events : 0

    Number   Major   Minor   RaidDevice State
       0       8       16        0      active sync   /dev/sdb
       1       8       32        1      active sync   /dev/sdc
       2       8       48        2      active sync   /dev/sdd



# mkfs.xfs /dev/md0
log stripe unit (524288 bytes) is too large (maximum is 256KiB)
log stripe unit adjusted to 32KiB
meta-data=/dev/md0               isize=256    agcount=16, agsize=196480 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=0
data     =                       bsize=4096   blocks=3142656, imaxpct=25
         =                       sunit=128    swidth=384 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=0
log      =internal log           bsize=4096   blocks=12800, version=2
         =                       sectsz=512   sunit=8 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0



## Not included in dmesg, but included in journalctl (which is attached to bug report also) is this suspicious udev entry from systemd:
[  450.100607] rawhide.localdomain systemd-udevd[310]: worker [1210] /devices/virtual/block/md0 timeout; kill it
[  450.109793] rawhide.localdomain systemd-udevd[310]: seq 1902 '/devices/virtual/block/md0' killed
[  450.114924] rawhide.localdomain systemd-udevd[310]: worker [1210] terminated by signal 9 (Killed)






