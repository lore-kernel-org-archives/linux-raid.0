From: David Brown <david.brown@hesbynett.no>
Subject: Growing layered raids
Date: Mon, 11 Apr 2011 23:44:58 +0200
Message-ID: <invsor$qrt$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Am I right in thinking that you cannot grow the size of a raid array 
that is build on top of other arrays?

I am doing some experiments at the moment with small loopback devices 
mapped to files on a tmpfs file system - the idea being I can play 
around with my fake "disks" without any risk, and with resync times 
faster than I can type.

My setup is like this (in case anyone wants to try it) :

mount -t tmpfs tmpfs /root/loops
dd if=/dev/zero of=/root/loops/loop1 bs=1M count=128
dd if=/dev/zero of=/root/loops/loop2 bs=1M count=128
dd if=/dev/zero of=/root/loops/loop3 bs=1M count=128
dd if=/dev/zero of=/root/loops/loop4 bs=1M count=160
dd if=/dev/zero of=/root/loops/loop5 bs=1M count=160
dd if=/dev/zero of=/root/loops/loop6 bs=1M count=160

losetup /dev/loop1 /root/loops/loop1
...
losetup /dev/loop6 /root/loops/loop6

This gives me 6 "disks" - 3 x 128 MB disks, and 3 x 160 MB disks.

Make some single-disk "mirrors":

mdadm --create /dev/md/mdpair1 --level=1 --force -n 1 /dev/loop1
mdadm --create /dev/md/mdpair2 --level=1 --force -n 1 /dev/loop2
mdadm --create /dev/md/mdpair3 --level=1 --force -n 1 /dev/loop3


Make a raid5 with no redundancy, so it's easy to see if something goes 
horribly wrong:

mdadm --create /dev/md/mdr --level=5 -n 4 /dev/md/mdpair1 
/dev/md/mdpair2 /dev/md/mdpair3 missing


Make and mount a file system, and put some data on it - so we can check 
the data is still there.

mkfs.ext4 /dev/md/mdr
mkdir m
mount /dev/md/mdr m
cp -r /usr/share m


At this stage, I've got a degraded raid5 with about 384MB space, in use 
as a mounted file system.


Now I want to swap out each of my 128 MB "disks" with 160 MB "disks".  I 
want to do that without reducing the redundancy of the main raid (in the 
real world, it would be raid 6 - not a degraded raid 5), and by using 
mirror copies to minimise the strain on the other disks.

Add a new disk as a "hot spare" to a pair:

mdadm --add /dev/md/mdpair1 /dev/loop4

Change it to being a 2-drive mirror

mdadm --grow /dev/md/mdpair1 -n 2

Wait for the sync to complete...

Remove the small disk and change it back to a 1-drive mirror

mdadm --fail /dev/md/mdpair1 /dev/loop1
mdadm --remove /dev/md/mdpair1 /dev/loop1
mdadm --grow /dev/md/mdpair1 -n 1 --force

Now I can grow the one-disk mirror to use the whole new disk:

mdadm --grow /dev/md/mdpair1 --size=max


Repeat the procedure for the other two mdpair components.

My raid5 array is build on top of these three raid1 mirrors, which have 
now all increased from 128 MB to 160 MB (confirmed by mdadm --detail and 
blockdev --report).

But when I try to grow the raid 5 array, nothing happens:

mdadm --grow /dev/md/mdr --size=max

I am still getting a "component size" of 128 MB.


If I do the same setup, but build the raid5 array directly from the 128 
MB loopback devices, then add the 160 MB devices, then remove the 128 MB 
devices (after appropriate resyncs, of course), then I can grow the raid 
5 array as expected.


Am I doing something wrong here, or is this a limitation of hierarchical 
raid setups?





