From: Dan Porter <dpreid@gmail.com>
Subject: Raid recovery after unfinished shrink reshape
Date: Fri, 22 Sep 2017 11:00:32 +0100
Message-ID: <CADtnS+yfWJKV8rbna8veSJbR1iCkW0XjGixHRYVxsBQ9p2665A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Synology weren't willing to help as I shrank an array, which they won't
support. I don't want to minimise my chances of recovery, so I thought I'd
reach out here first.

The problem I am facing today is that after a reboot, all disks in the
Synology are showing as 'Initialized'. It also shows there are no Disk Groups
or Volumes in the system. This was not the case prior to a reboot.

Prior to a reboot, a consistency check was stuck on 100.0% for a period of
about 2 weeks. I'd been unable to find a solution online, but today opted to
reboot for an update. Currently all of the data is inaccessible, I hope you
can help me.

On 7/14, the array made it's reshape and completion up to 9 drives in RAID 6.
At some point, a drive failed, and a replacement drive could not be sourced
within a reasonable time frame. To keep the array operating at 2-disk
redundancy, on 8/1 I opted for reducing the array size to 8 disks, with the
following commands:

mdadm --grow /dev/md2 --array-size 35134148736
mdadm --grow -n8 /dev/md2 --backup-file /root/mdadm.md2.backup

On 8/8, it was first noticed that the reshape had hung, and was stuck on
100.0% according to the synology interface (though 99% on mdadm:
https://www.irccloud.com/pastebin/eonrdAHu/mdadm%20output

The array continued unabated until this Tuesday (9/19) where a reboot occured,
and the array didn't come back. The backup file i created, annoyingly no
longer exists, as Synology wipe the root home directory on reboot.

Here is the status from each individual drive (partition) that was part of the
array: https://pastebin.com/Hn9PbTf3

Dan
