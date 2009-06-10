From: Jody McIntyre <scjody@sun.com>
Subject: Strange RAID behaviour when faced with user error
Date: Wed, 10 Jun 2009 17:58:35 -0400
Message-ID: <20090610215835.GA4936@clouds>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

A user actually ran into this in the field (RHEL 5.3) and I'm able to reproduce
with:
Linux vm1 2.6.30-rc8 #1 SMP Mon Jun 8 11:32:59 EDT 2009 x86_64 GNU/Linux
mdadm - v2.6.7 - 6th June 2008

I'll investigate (i.e. read/debug code) when I have time but any insights would
be apprecated.

1. Assemble a RAID array incorrectly (forgetting the array name):

# mdadm --assemble /dev/sdb1 /dev/sdb2 /dev/sdb3 /dev/sdb4 --run
mdadm: /dev/sdb1 has been started with 3 drives (out of 4).
(The user did not require --run; I'm not sure why.)

2. An array is actually started.  That's not so weird...

# cat /proc/mdstat
Personalities : [multipath] [raid0] [raid1] [raid6] [raid5] [raid4] [raid10] 
md127 : active raid10 sdb2[1] sdb4[3] sdb3[2]
      513792 blocks 64K chunks 2 near-copies [4/3] [_UUU]
      
unused devices: <none>

3. But:

# mdadm --examine /dev/sdb1
mdadm: No md superblock detected on /dev/sdb1.
# mdadm --stop /dev/sdb1
mdadm: stopped /dev/sdb1
# mdadm --examine /dev/sdb1
mdadm: No md superblock detected on /dev/sdb1.
# mdadm --assemble /dev/md0 /dev/sdb1 /dev/sdb2 /dev/sdb3 /dev/sdb4
mdadm: no recogniseable superblock on /dev/sdb1
mdadm: /dev/sdb1 has no superblock - assembly aborted


The problem goes away after a reboot.

Cheers,
Jody
