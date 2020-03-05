From: Patrick Dung <patdung100@gmail.com>
Subject: Please show descriptive message about degraded raid when booting
Date: Thu, 5 Mar 2020 22:57:05 +0800
Message-ID: <CAJTWkdvU3of87+-zyUPn7uDBen8ZBswujwMn8wYSiwZb=0V3EQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

The system have Linux software raid (md) raid 1.
One of the disk is missing or have problem.

The raid is degraded.
When the OS boot, it hangs at the message for outputting to kernel at
about three seconds.
There is no descriptive message that the RAID is degraded.
I know the problem because I had wrote zero to one of the disk of the
raid 1. If I don't know the problem (maybe cable is loose or disk
failure), it is confusing.

Related log:

[    2.917387] sd 32:0:0:0: [sda] 56623104 512-byte logical blocks:
(29.0 GB/27.0 GiB)
[    2.917446] sd 32:0:1:0: [sdb] 56623104 512-byte logical blocks:
(29.0 GB/27.0 GiB)
[    2.917499] sd 32:0:0:0: [sda] Write Protect is off
[    2.917516] sd 32:0:0:0: [sda] Mode Sense: 61 00 00 00
[    2.917557] sd 32:0:1:0: [sdb] Write Protect is off
[    2.917575] sd 32:0:1:0: [sdb] Mode Sense: 61 00 00 00
[    2.917615] sd 32:0:0:0: [sda] Cache data unavailable
[    2.917636] sd 32:0:0:0: [sda] Assuming drive cache: write through
[    2.917661] sd 32:0:1:0: [sdb] Cache data unavailable
[    2.917677] sd 32:0:1:0: [sdb] Assuming drive cache: write through
[    2.927076] sd 32:0:0:0: [sda] Attached SCSI disk
[    2.927458]  sdb: sdb1 sdb2 sdb3 sdb4
[    2.929018] sd 32:0:1:0: [sdb] Attached SCSI disk
[    3.060855] vmxnet3 0000:0b:00.0 ens192: intr type 3, mode 0, 3
vectors allocated
[    3.061826] vmxnet3 0000:0b:00.0 ens192: NIC Link is Up 10000 Mbps
[  139.411464] md/raid1:md125: active with 1 out of 2 mirrors
[  139.412176] md125: detected capacity change from 0 to 1073676288
[  139.433441] md/raid1:md126: active with 1 out of 2 mirrors
[  139.434182] md126: detected capacity change from 0 to 314507264
[  139.436894]  md126:
[  139.455511] md/raid1:md127: active with 1 out of 2 mirrors
[  139.456739] md127: detected capacity change from 0 to 27582726144

So there are about 130 seconds without any descriptive messages. I
thought the system had hanged.

Could the kernel display more descriptive messages about the RAID?

If I use rd.debug boot parameters, I know the kernel is still running.
But it is scrolling very fast without actually knowing what is the the
problem.

Thanks,
Patrick
