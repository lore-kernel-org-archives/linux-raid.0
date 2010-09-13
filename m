From: maurice <mhilarius@gmail.com>
Subject: Q: mdadm as implemented in Openfiler
Date: Mon, 13 Sep 2010 09:36:50 -0600
Message-ID: <4C8E4512.9000709@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

  I am doing some maintenance on a machine that is running Openfiler.
It has a degraded RAID on it with a member that has gone "missing"

Having replaced the drive, I tried to do a "raidhotadd" but that command 
is not available.

kernel is:
[root@somebox tmp]# uname -a
Linux somebox.mystuff.net 2.6.29.6-0.24.smp.gcc3.4.x86.i686 #1 SMP Tue 
Mar 9 05:01:39 GMT 2010 i686 i686 i386 GNU/Linux

Instead I was able to use the more cumbersome:
mdadm --manage /dev/md0 --add /dev/sda1

Which is working.

I am curious about this, does anyone think further action is advisable?




-- 
Cheers,
Maurice Hilarius
eMail: /mhilarius@gmail.com/
