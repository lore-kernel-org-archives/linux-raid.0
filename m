From: "Liu H.T" <liuhongtong86@gmail.com>
Subject: MD - resync progress falls back to 0% after reboot
Date: Mon, 3 Jun 2013 10:41:09 +0800
Message-ID: <CAMKi=TEdBXC+c+ocinpVWyBVi+byJObQ6Z1JGHU8y99EAq0-tA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all.

Desctiption
  Building a RAID5 array on 5 disks with bitmap support. We reboot the
system while the array is resyncing. When the system restarts, resync
progress falls back to 0% and resync restarts. This problem occurs
once almost 20 reboot.

My analysis
  Reboot happens while md is resyncing. When md_check_recovery() is
holding mddev->reconfig_mutex lock, md_notify_reboot() will be unable
to get this lock by mddev_trylock() and overleap md_set_readonly(). If
md device is not readonly, resync process will go on, but disks will
be set readonly by SCSI driver in order, which may cause differences
between disks' metadata.
  When the system restarts, mdadm will read md metadata from each
disk, get the most recent events recorded in metadata, and update md
metadata to other disks whose events is old.
  When md module inits the sb_page in memory, it reads metadata from a
good disk no matter which one. If the disk unfortunately is one of
disks which have been updated md metadata, events in bitmap metadata
will be less than events in md metadata, and resync will restart from
0%.

  I have tried to replace the function mddev_trylock() used by
md_notify_reboot() by mddev_lock() and all is well after 2000 reboot.
  But what I am curious is the function is still mddev_trylock in the
latest kernel. Can someone tell me is there any reason that cannot use
mddev_lock() in md_notify_reboot().
  Thanks for your time!
