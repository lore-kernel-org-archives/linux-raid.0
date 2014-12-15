From: "John L. Center" <jlcenter@comcast.net>
Subject: udisks error creating watch file in md127 container directory
Date: Mon, 15 Dec 2014 11:38:13 -0500
Message-ID: <548F0E75.1050502@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I'm running Ubuntu 14.04 with the 3.17.5 kernel.  I have 3 IMSM RAID1
arrays set up & I noticed the following syslog messages:

Dec 15 09:49:06 mariposa udisksd[3255]: udisks daemon version 2.1.3 starting
Dec 15 09:49:06 mariposa udisksd[3255]: Error creating watch for file
/sys/devices/virtual/block/md123/md/sync_action: No such file or
directory (g-file-error-quark, 4)
Dec 15 09:49:06 mariposa udisksd[3255]: Error creating watch for file
/sys/devices/virtual/block/md123/md/degraded: No such file or directory
(g-file-error-quark, 4)
Dec 15 09:49:06 mariposa udisksd[3255]: Error creating watch for file
/sys/devices/virtual/block/md125/md/sync_action: No such file or
directory (g-file-error-quark, 4)
Dec 15 09:49:06 mariposa udisksd[3255]: Error creating watch for file
/sys/devices/virtual/block/md125/md/degraded: No such file or directory
(g-file-error-quark, 4)
Dec 15 09:49:06 mariposa udisksd[3255]: Error creating watch for file
/sys/devices/virtual/block/md127/md/sync_action: No such file or
directory (g-file-error-quark, 4)
Dec 15 09:49:06 mariposa udisksd[3255]: Error creating watch for file
/sys/devices/virtual/block/md127/md/degraded: No such file or directory
(g-file-error-quark, 4)
Dec 15 09:49:06 mariposa dbus[1230]: [system] Successfully activated
service 'org.freedesktop.UDisks2'

The files (degraded,sync_action) don't exist in the container (md127,
etc.) directories, but do exist in the array (md126, etc.) directories
themselves.  I never noticed this before, is this something I should be
concerned about?  I recently ran software updates, but udisks was not
one of the packages patched.

Thanks.

    -John


