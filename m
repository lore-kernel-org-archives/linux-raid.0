From: cau2jeaf1honoq@laposte.net
Subject: Massive RAID-1 desync
Date: Fri, 24 Apr 2015 22:47:49 +0200 (CEST)
Message-ID: <1810942606.18204832.1429908469113.JavaMail.zimbra@laposte.net>
References: <1919189912.18202330.1429908372364.JavaMail.zimbra@laposte.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1919189912.18202330.1429908372364.JavaMail.zimbra@laposte.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Something is happening here. I don't know what, but I'm having
fun trying to guess.

The root file system (ext3) is on a 4 x 30 GB RAID-1 array. A
couple hours after boot, the kernel detected something wrong in
the file system and decided to remount it read-only.

Comparing the component partitions finds many differences with a
very uneven distribution :

- sda1 and sdb1 are identical except for 4 bytes in the last
  70 kB,

- sdd1 is identical to sda1 and sdb1 except for about 67,000
  differences in the last 70 kB.

- sdc1 is grossly out of sync with about 300 million differences
  with the others, all of them in the first 450 MB or so.

I'm not sure what to make of this. The knee-jerk thought would
be "/dev/sdc1 is the odd man out so sdc must be faulty". But
that disk participates in other arrays without problems, I don't
see anything obviously bad in its SMART data and the kernel
messages just before the remount were actually about sda.

To be honest, I don't have a clear idea of how things got where 
they are. Since writing to a RAID-1 array writes the same data
to all devices, how can you have so many differences ?
