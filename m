From: Edward Kuns <eddie.kuns@gmail.com>
Subject: mdadm-grow-continue service crashing (similiar to "raid5 reshape is
 stuck" thread from May)
Date: Sun, 12 Jul 2015 01:02:24 -0500
Message-ID: <CACsGCySTbrEYddSNfi7+9KnxWeddkBGDbxTsBSJkkvGHOaJwKg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I experienced a total drive failure.  Looking into it, I discovered
that the particular hard drive model that failed is a particularly bad
one.  So I replaced not only the failed drive, but another of the same
model.  In the process, I ran into a problem where on reboot the RAID
device was inactive.

I finally found a solution to my problem in the earlier thread "raid5
reshape is stuck" that started on 15 May.  By the way, I am on Fedora
21

> rpm -q mdadm
mdadm-3.3.2-1.fc21.x86_64

> uname -srvmpio
Linux 4.0.4-202.fc21.x86_64 #1 SMP Wed May 27 22:28:42 UTC 2015 x86_64
x86_64 x86_64 GNU/Linux

The short version of the story is that I replaced the dead drive and
let the raid5 partition rebuild.  Then I added a new drive and let the
partition rebuild.  Then I removed the not-yet-dead drive and here is
where I ran into the same problem as the other poster.  Basically, I
did this to replace the still-working-but-suspect device, after the
partition completed rebuilding when I replaced the actually-dead
drive:

mdadm --manage /dev/md125 --add /dev/sdf1
mdadm --grow --raid-devices=5 /dev/md125

 ... wait for the rebuild to complete

mdadm --fail /dev/md125 /dev/sdd2
mdadm --remove /dev/md125 /dev/sdd2
mdadm --grow --raid-devices=4 /dev/md125

mdadm: this change will reduce the size of the array.
       use --grow --array-size first to truncate array.
       e.g. mdadm --grow /dev/md125 --array-size 118964736

mdadm --grow /dev/md125 --array-size 118964736
mdadm --grow --raid-devices=4 /dev/md125

... this failed with a mysterious complaint about my first partition
(Cannot set new_offset).  Research got me to try:

mdadm --grow --raid-devices=4 /dev/md125 --backup-file /root/md125.backup

.... here everything ground to a halt.  The reshape was at 0% and
there was no disk activity.

The solution was to edit
/lib/systemd/system/mdadm-grow-continue@.service to look like this (it
was important that the backup file was placed in /tmp and not in /root
or anywhere else.  SELinux allowed mdadm to create a file in /tmp by
not anywhere else I tried):

#  This file is part of mdadm.
#
#  mdadm is free software; you can redistribute it and/or modify it
#  under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2 of the License, or
#  (at your option) any later version.

[Unit]
Description=Manage MD Reshape on /dev/%I
DefaultDependencies=no

[Service]
ExecStart=/usr/sbin/mdadm --grow --continue /dev/%I
--backup-file=/tmp/raid-backup-file
StandardInput=null
#StandardOutput=null
#StandardError=null
KillMode=none

I had to comment out the standard out and error lines to see why the
service was failing.  I was pulling out my hair.  The raid device
failed to initialize, so my computer dumped me into runlevel 1.

When the process finished after the above fix, I ended up in a weird state:

    Number   Major   Minor   RaidDevice State
       0       8        2        0    active sync   /dev/sda2
       1       8       17        1    active sync   /dev/sdb1
       5       8       33        2    active sync   /dev/sdc1
       6       0        0        6    removed

       6       8       49        -    spare   /dev/sdd1

but that is probably as a result of what I tried to bring it back.  I
could "stop" the raid and manually recreate it and the filesystems on
it were fine.  But it wouldn't come up without me doing that.  I'm
going to try to fail and re-add that disk again and see if it works
now that it was able to complete a sync.  I did a fail, remove, and
add on /dev/sdd1  and it very quickly synced and came into service.
The command "mdadm --detail /dev/md125" now shows a happy raid5 with
four partitions in it, all "active sync"  So all I had to do was add
the --backup-file to the command to "grow" down to 4 devices, and also
to mdadm-grow-continue@.service.

I thought I'd let you know, in particular, that adding
--backup-file=/tmp/raid-backup-file to the service file worked to get
the process unstuck, and that due to SELinux it must be in tmp.  Also,
should the "Cannot set new_offset" complaint maybe suggest trying
again with a backup file?

                 Eddie
