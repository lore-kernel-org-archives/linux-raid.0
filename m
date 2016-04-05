From: Noah Beck <noah.b.beck@gmail.com>
Subject: recovery from selinux blocking --backup-file during RAID5->6
Date: Mon, 4 Apr 2016 23:16:49 -0400
Message-ID: <CAFAW0zxisX2Db_YdJxtNpF4YKayy=AnKnWcGdAgw6piy1Jjyng@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I see a similar problem has been discussed at least once before at
https://marc.info/?t=144970286700004&r=1&w=2

In my case, this was a RAID5 array with 4 active devices and one
spare.  I wanted to switch this to a 5-device RAID6 instead.  Ran the
following:

  mdadm --grow /dev/md127 --raid-devices 5 --level 6 --backup-file
/root/raid_migration_file

Two things went wrong:

1) selinux jumped in and blocked access to the --backup-file.  From journalctl:

  SELinux is preventing mdadm from getattr access on the file
/root/raid_migration_file

This can be fixed with a "setenforce 0" in the future.  The
/root/raid_migration_file did get created (25MB) but hexdump says it
is all zeros so I believe no useful data was placed in this file.

2) Turns out my spare device in the old RAID5 was actually ready to
die.  This corresponds to what was previously the spare in my RAID5:

  ata4.00: revalidation failed (errno=-2)
  ata4.00: disabled
  ata4: EH complete
  blk_update_request: I/O error, dev sdb, sector 0
  blk_update_request: I/O error, dev sdb, sector 3907023935
  md: super_written gets error=-5
  md/raid:md127: Disk failure on sdb1, disabling device.
  md/raid:md127: Operation continuing on 4 devices.

Since /dev/sdb1 was marked as failed in the array I removed it.  I
tried zeroing it out with dd if=/dev/zero of=/dev/sdb1 to see what it
would do and then that disk completely died.  So I'll get a new disk
tomorrow.  In the meantime the system still seems to be running fine.
/proc/mdstat shows this now:

  md127 : active raid6 sde1[3] sda1[2] sdd1[0] sdf1[1]
      5860535808 blocks super 0.91 level 6, 64k chunk, algorithm 18
[5/4] [UUUU_]
      [>....................]  reshape =  0.0% (1/1953511936)
finish=722.0min speed=43680K/sec

The previous thread resulted in a patch (in
https://marc.info/?l=linux-raid&m=145187378405337&w=2 ).  If I want to
go back to having a 4-device RAID5 array before I shut this system
down to replace the bad disk, is the right thing to do still to apply
that patch to mdadm, stop /dev/md127, and assemble again with
--update=revert-reshape?  Or does the info above indicate I should use
any different solution?

Thanks,
Noah
