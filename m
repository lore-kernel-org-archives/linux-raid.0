From: John Rowe <J.M.Rowe@exeter.ac.uk>
Subject: Unusual RAID 1 recovery problem
Date: Fri, 10 May 2013 18:31:15 +0100
Message-ID: <1368207075.17201.49695.camel@amp>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Following a system reinstall (an upgrade from Scientific Linux 5.x  to
to 6.x), I had a RAID1 array that  I could start manually with:

> mdadm --assemble /dev/md0 /dev/sda4 /dev/sdb4

but would not start automatically on reboot. SL is a RedHat clone and
all partitions were of type "fd".

The above command worked fine and I could see all my data, but every
time I rebooted the RAID1 array wasn't there.

Encouraged by the reassuring words of the mdadm man page:

        --assume-clean
                      Tell mdadm that the array pre-existed and is known
        to be clean.  It can be  useful  when trying to recover from a
        major failure as you can be sure that no data will be affected
        unless you actually write to the array.
        
I tried:

> mdadm --create -l 1 -n 2 -assume-clean /dev/md0 /dev/sda4 /dev/sdb4

This worked, following the usual warning about how the partitions had
previously been part of an array. But now:

> mount -r /md0 /bob

refuses to do anything even if I try:

> mount -t ext2 -r /md0 /bob

I get an error message listing various possibilities such as "bad
superblock". dmesg tells me it can't find an ext2 file system
on /dev/md0


Clearly I had misunderstood the meaning of "you can be sure that no data
will be affected unless you actually write to the array" but I'm hoping
there is still a way of accessing this unaffected data.

Thanks.

John



