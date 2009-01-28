From: Jan Ceuleers <jan.ceuleers@computer.org>
Subject: Spare disk periodically woken up
Date: Wed, 28 Jan 2009 20:58:43 +0100
Message-ID: <4980B8F3.40502@computer.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi there.

I'm very sorry if this is an FAQ; I've searched the wiki but have not 
been able to find the answer.

I have five disks, four of which form a RAID5 set, with the fifth being 
a spare. This fifth disk is normally spun down, or at least it should 
be. (It's a bit more complicated than that, as is evident from the info 
included below, but this is essentially it).

I recently noticed that this fifth disk is periodically spun up for 
reasons unknown. It's not due to SMART monitoring because I've disabled 
the SMART daemon altogether.

My /proc/mdstat is shown below; the disk that is periodically spun up is 
/dev/sdf.

How can I find out what is causing my standby disk to spin up?

Many thanks.

Cheers, Jan

========= /proc/mdstat
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] 
[raid4] [raid10]
md2 : active raid5 sdf2[4](S) sda2[0] sdd2[3] sdc2[2] sdb2[1]
       934765824 blocks level 5, 64k chunk, algorithm 2 [4/4] [UUUU]

md1 : active raid1 sdb1[0] sdd1[1]
       979840 blocks [2/2] [UU]

md0 : active raid1 sdf1[2](S) sda1[0] sdc1[1]
       979840 blocks [2/2] [UU]

unused devices: <none>

