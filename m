From: "Roberto Samarone Araujo \(RSA\)" <sama@inf.ufsc.br>
Subject: Help ! Kernel panic: VFS: Unable to mount root fs on 09:01
Date: Thu, 1 May 2003 16:12:00 -0300
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <002301c31015$8c75e4c0$9affff0a@inpa.gov.br>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

     I have a conectiva Linux box server. It was working perfect until I
need to reset it using the computer reset button. When the machine tried to
return, after the boot, the system show me the message: "Kernel panic: VFS:
Unable to mount root fs on 09:01" and can't show me the prompt :/. The
kernel messages that I got was:

md: bind<hda2,1>
md: running: <hda2>
md: hda2's event count: 00000052
md0: former device [dev 16:02] is unavailable, removing from array!
md: md0: raid array is not clean -- starting background reconstruction
md: RAID level 1 does not need chunksize! Continuing Anyway.
kmod: failed to exec /sbin/modprobe -s -k md-personality-3, errno = 2
md: personality 3 is not loiaded!
md: do_md_run() returned -22
md: md0 stopped.
md: unbind<hda2,0>
md: export_rdev(hda2)
md: ...autorun DONE.
NET4: Linux TCP/IP 1.0 for NET4.0
IP Protocols: ICMP, UDP, TCP, IGMP
IP: routing cache hash table of 8192 buckets, 64KBytes
TCP: Hash tables configured (established 262144 bind 65536)
NET4: Unix domain sockets 1.0/SMP for Linux NET
NET4: Appletalk 0.18a for LINUX Net4.0
RAMDISK: Compressed image found at block 0
invalid compressed format (err=1),6. Freeing initrd memory: 484 freed
EXT2-fs: unable to read superblock
isofs_read_super: bread failed, dev=09:01, iso_blknum=16, block=32
Kernel panic: VFS: Unable to mount root fs on 09:01

    What is wrong ? The Linux box was working perfec until the reset. It was
using raid 1. I tried to remove the first hard disk and put the second as a
master, but the second hard disk fail to boot too, showing this message.
Now, after tried to fix this, the first hard disk is damaged. Is it possible
to boot using only the second hard disk as a master. What I nedd to do to
solve this error message ?

     Please help me. It was a very important machine on my network, I really
need to return this machine  to my network.

          Thanks,

      Roberto Samarone Araujo

