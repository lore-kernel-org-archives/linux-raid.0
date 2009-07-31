From: Fredrik Andersson <nablaman@gmail.com>
Subject: Linux Software Raid hangs after months of operation
Date: Fri, 31 Jul 2009 21:05:35 +0200
Message-ID: <a125a870907311205k6380fafcy3eecbac6150f23f5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi, I have a bunch of machines running Linux 2.6.29.1 on x86_64 which
are running Linux software raid consisting of two disk partitions
merged into a single raid0 in /dev/md0. This setup is for performance
reasons.
The OS is not run from the raid, it is only used to hold a set of data files.

This seems to work great for weeks to months at a time, but then all
of a sudden access to the raid filesystem completely locks up. A
process trying to access any file in there hangs to the point where it
cannot be killed even with -9, so I suppose it's locked up in a
syscall.
I can't attach a debugger to the process, for then the terminal locks
up too. But the system is operational as long as I don't read anything
from the raid mount.

Th only thing that helps is a reboot. Then the raid will function
correctly again.

The version of mdadm is v2.6.7.1 - 15th October 2008.

Here is my /etc/mdadm.conf:
DEVICE /dev/sda5
DEVICE /dev/sdb3
ARRAY /dev/md0 devices=/dev/sda5,/dev/sdb3

/proc/mdstat from a locked machine:
Personalities : [raid0]
md0 : active raid0 sda5[0] sdb3[1]
898362368 blocks 256k chunks

unused devices: <none>

The raid has an ext4 filesystem on it.

I can find no other logs or status files for the software raid system.
There's nothing in /var/log/messages or any other standard log.

Does anybody know what is going on? Is this a known bug in md or the kernel?

Thank you for any help!

Fredrik
