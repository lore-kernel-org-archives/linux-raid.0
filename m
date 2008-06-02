From: "Jon Nelson" <jnelson-linux-raid@jamponi.net>
Subject: Awful Raid10,f2 performance
Date: Mon, 2 Jun 2008 09:11:56 -0500
Message-ID: <cccedfc60806020711o39ccd321h5e410c963d8bf3b1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Linux-Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I have set up a 3-disk raid10 using f2 layout using 3x SATA disks each
capable of 70+ MB/s (give or take).
The CPU is a dual core 64 bit Athlon 3600+, and the SATA interface
consists of NVidia MCP55+ (PCIe or whatever).
Previously this was a 3 disk raid5.
The problem: I'm getting really awful transfer rates.  7-9MB/s
per-drive with 21-30MB/s combined. The average hangs around 22-24MB/s.
This, I feel, is really awful!

What parameters can I twiddle to improve the performance?
I am not using NCQ.
The drives individually are capable of 70+ MB/s.
I am using the deadline I/O scheduler but I have tried the others.
This is the openSUSE 2.6.22.17 kernel.
I am getting the I/O rates via dstat.
I am using the jfs filesystem primarily.
The operation I am performing varies but the I/O rates don't (much).
In particular, moving one 17G file from a logical volume (I am using
LVM) to another, both filesytems are JFS.
The load is around 2.6, with these four processing being the top CPU
consumers (they wiggle around a bit):


 2034 root      10  -5     0    0    0 D   10  0.0 201:00.30 md0_raid10
10631 root      18   0  8436 1076  668 D    7  0.1   2:07.65 mv
  218 root      15   0     0    0    0 D    3  0.0   2:06.30 pdflush
 2182 root      10  -5     0    0    0 S    3  0.0   0:32.51 jfsCommit

Is there more information that I can provide that can help explain why
I'm getting such slow speeds?


-- 
Jon
