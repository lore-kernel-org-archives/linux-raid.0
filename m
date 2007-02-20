From: rabbit@rabbit.us (Peter Rabbitson)
Subject: RAID10 Resync fails with specific chunk size and drive sizes (reproducible)
Date: Tue, 20 Feb 2007 06:35:49 -0500
Message-ID: <20070220113549.GB5584@rabbit.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I think I've hit a reproducible bug in the raid 10 driver, tried on two 
different machines with kernels 2.6.20 and 2.6.18. This is a script to 
simulate the problem:

======================
#!/bin/bash

modprobe loop

for ID in 1 2 3 ; do
    echo -n "Creating loopback device $ID... "
    dd if=/dev/zero of=dsk${ID}.img bs=512 count=995967
    losetup /dev/loop${ID} dsk${ID}.img
    echo "done."
done

mdadm -C /dev/md2 -l 10 -n 3 -p o2 -c 2048 /dev/loop1 /dev/loop2 /dev/loop3
echo "Raid device assembled, check /proc/mdstat's output when resync is finished"
======================

This is the output I get in /proc/mdstat after the resync settles:

======================
md2 : active raid10 loop3[2] loop2[3](F) loop1[0]
      746496 blocks 2048K chunks 2 offset-copies [3/2] [U_U]
======================
