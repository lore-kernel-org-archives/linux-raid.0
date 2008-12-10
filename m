From: =?ISO-8859-1?Q?Tor_Arne_Vestb=F8?= <torarnv@gmail.com>
Subject: Linux RAID autodetect partitions go missing from /dev, but fdisk
 can see them
Date: Wed, 10 Dec 2008 21:56:30 +0100
Message-ID: <49402CFE.3080708@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

I have a very strange problem that I've been trying to debug for days
now. I'm hoping someone on this list may have ran into this before, or
have any tips on how I can continue debugging this, because I have to
admit I'm a little lost...

I had a RAID5 with four drives and one spare, /dev/sd[bcde]1 +
/dev/sdf1, and everything was working fine, until one day one of the
drives in the array (sdb) no longer had a partition (sdb1). Letting the
spare take over I ignored this for a few days, but then it happened
again, this time with sdc. Kernel is 2.6.22.17, and I've compiled all
raid support in. The symptoms are:

  - The kernel seems to detect the partitions (lines 396 and 407 in the
dmesg [1])

  - But once the boot process finishes and the RAID is started, there i=
s
no longer any sdc1 or sdb1, so the RAID fails to start (lines 550-576 i=
n
dmesg [1])

  - Running fdisk -l shows that the drives in question (sdb and sdc) do
have similar partitions as the other working drives, namely one Linux
RAID autodetect partition each (see command output [2])

  - But, the partitions are missing from /proc/partitions (see [3])

  - Manually adding device nodes using mknod works, but doing file -sL
on the device gives "writable, no read permission", even though
permissions are the same as the other sd* nodes in /dev

  - Running 'partprobe -s' successfully finds the two missing partition=
s
and adds device nodes, and the nodes can be 'file -sL'ed, but when
trying to assemble the array again with these new nodes in the system,
I'm told that sdc1 is not found, and after the --assemble is done, the
device nodes are once again missing (!) see [4]

  - I've tried using the 'dmraid' command to look for fakeraid
partitions or meta data on the drives, which I was told could mess up
the auto-detection of Linux software ride partitions, but could not fin=
d
any issues.


As you can tell I've exhausted all my current options, so any help on
what I could try next would be very much appreciated. I am especially
curious as to why I lose the partitions when mdadm tries to assemble th=
e
array?

Thanks!

Tor Arne Vestb=F8

[1] http://pastebin.com/m15b9c275   dmesg
[2] http://pastebin.com/f50fb323a   fdisk -l
[3] http://pastebin.com/f4547c2ca   cat /proc/partitions
[4] http://pastebin.com/m4475c9ae   partprobe + mdadm --assemble
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
