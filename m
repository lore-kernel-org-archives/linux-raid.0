From: Nerijus Baliunas <nerijus@users.sourceforge.net>
Subject: mounting /dev/hdax and xfs problems
Date: Sun, 5 Oct 2003 02:26:02 +0300 (EEST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <S262703AbTJDX0w/20031004232652Z+8001@vger.kernel.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: INLINE
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I have on debian /home mounted on raid1. Some time ago
it was remounted as 'mount /dev/hda2 /home' instead of
'mount /dev/md0 /home'. Now when I umount it and try
to mount /dev/md0, I see in dmesg:

XFS mounting filesystem md(9,0)
Starting XFS recovery on filesystem: md(9,0) (dev: 9/0)
XFS: dirty log written in incompatible format - can't recover
XFS: log mount/recovery failed
XFS: log mount failed

When mounting /dev/hda2 it succeeds. The question is -
does mounting part of raid1 mirror when raid is still running
do anything bad for a raid? How raid works in this situation -
is it still mirroring info from /dev/hda2 to /dev/hdb2?
If I raidstop and raidstart, can it damage filesystem?

/proc/mdstat shows that everything is OK.

Regards,
Nerijus
