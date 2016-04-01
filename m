From: Benjamin Meier <maillists@ferienwohnung-altenbeken.de>
Subject: Re: Recovery after failed chunk size change
Date: Fri, 1 Apr 2016 22:03:03 +0200
Message-ID: <56FED3F7.8080009@ferienwohnung-altenbeken.de>
References: <56FD7B92.1030102@ferienwohnung-altenbeken.de>
 <87a8ldrjcr.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87a8ldrjcr.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

Am 01.04.2016 um 07:25 schrieb NeilBrown:
> mdadm --assemble --force --update=revert-reshape --invalid-backup 
> --backup-file=/whatever /dev/md/TA /dev/list-of-devices using mdadm 3.4. 
Thanks. Now my array is online again and working.
> If someone can provide a recipe for how to reproduce the problem (e.g. 
> using loop-back devices) I'll happily look into fixing it, or 
> identifying which kernel it is already fixed in. Neilbrown 
I could reproduce the issue with my current kernel. I also tried the 
debian unstable kernel 4.4 and mdadm 3.4 - it looks like the bug is 
still there. Most of the time it is not reshaping any block. As I 
executed the commands by hand I could see that sometimes the process 
stops after only one block and sometimes the process stops in the 
middle. You can use the script that I wrote to make the reproduction 
easier. Maybe it is also working with smaller files than 1GiB.

Good luck for the bug hunting!
--
#!/bin/bash

# Create a seven disk RAID6 array with sparse files (1GiB each)
declare -a LO_DEVICES
for x in 0 1 2 3 4 5 6; do
   dd if=/dev/zero of=sparse$x bs=1G count=0 seek=1
   losetup -f sparse${x}
   LO_DEVICES[$x]=$(losetup -a|grep sparse${x}|cut -f1 -d" "|sed "s/://")
done
mdadm --create /dev/md/TestMD --chunk=4096 --bitmap=internal --level=6 
--raid-devices=7 \
   ${LO_DEVICES[*]}
mdadm --wait /dev/md/TestMD

# Provocate BUG.
# Tested with Linux 3.16.0-4-amd64 #1 SMP Debian 3.16.7-ckt20-1+deb8u4 
(2016-02-29) x86_64 GNU/Linux
#             mdadm - v3.3.2 - 21st August 2014
mdadm --grow /dev/md/TestMD --chunk=64 --backup-file=backup.file

