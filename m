From: jan@weitan.org
Subject: Software RAID 1 boot procedure hangs after reset
Date: Sat, 1 Jan 2005 17:31:54 +0100 (CET)
Message-ID: <33268.85.72.22.63.1104597114.squirrel@weitan.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi there,
i have a debian sarge system with kernel 2.6.6. After a hard reset the
boot process hangs at recognising/ mounting the root file system, but s=
ays
he can start /dev/mdX with 2 out of 2 disks.
The error message is:
 pivot_root: No such file or directory
    /sbin/init: 424: cannot open dev/console: no such file
Exactly the same as
http://lists.debian.org/debian-kernel/2004/08/msg01301.html.
I am using a initrd with sata and raid1 modules.
The filesystem is fd (linux raid autodetect) and autofs is compiled int=
o
the kernel.
I tried the debian default kernel (2.6.3) and he detects a corrupted ra=
id
(starting with 1 out of 2 devices) and gives another error message.
I repaired it by using dd and an old image of the root filesystem. But =
i
do not understand the big picture here. Why does one kernel detect a fu=
lly
synchronised raid and the other kernel doesn=B4t?
Actually it happened twice and the first time there was some message th=
at
some filesystem has been mounted too many times and needs a check, afte=
r
that the system started normally. But before this messages he couldn=B4=
t
find the root fs. A friend of mine pointed to me that the wait time of =
the
kernel to autodetect the fs is/ was probably too short.
In general i googled for some information about the problem but couldn=B4=
t
find a good resource. Every howto explains how to set up software raid,
but no one explains how to repair a corrupted root fs.




jan@         _ __
 _    _____ (_) /____ ____   ___  _______ _
| |/|/ / -_) / __/ _ `/ _ \_/ _ \/ __/ _ `/
|__,__/\__/_/\__/\_,_/_//_(_)___/_/  \_, /
                                    /___/
--
"Dancing is the vertical expression of a horizontal desire" --Robert Fr=
ost


-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
