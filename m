From: David Rees <drees76@gmail.com>
Subject: RAID1 write-behind not working?
Date: Wed, 25 Mar 2009 17:39:24 -0700
Message-ID: <72dbd3150903251739q21de8a2ew835860f9e3b11d14@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I picked up a SSD (30GB OCZ Vertex if you're curious) and am planning
to set up a RAID1 with it and a SATA disk with the SATA disk in
write-mostly mode along with write-behind enabled.

So I went to test it to make sure I had all the details correct on
aligning the partition to a 128kB offset and the correct mdadm
commands to create the array in write-mostly and write-behind, but I
found that I couldn't get writes to "write-behind".  Essentially all
writes would complete at the speed of the rotating disk.  Reads
however worked great - they all appeared to be coming from the SSD.

I created the array with the following command:

mdadm --create /dev/md0 --raid-devices=2 --level=1 \
  --bitmap=internal --write-behind /dev/sdb1 --write-mostly /dev/sda1

/dev/sda is the SATA disk, /dev/sdb is the SSD.

So then I created an ext3 filesystem on the array (mkfs -t ext3 -E
stride=32 /dev/md0), mounted it and proceeded to run some quick dd
tests to verify that things were working as expected.

I simply wrote a 1kB file to disk like this:
dd if=/dev/zero of=/mnt/disk/tmpfile bs=1k count=1 conv=fdatasync

I tried various file sizes, and even tried reconfiguring the bitmap
with a write-behind setting of 10000.
I confirmed speeds by failing and removing either the SSD or SATA disk
- with both disks active, writes were completing at the speed of the
SATA disk, which was 2-5 times slower depending on the size of the
file.

My only guess is that by specifying fdatasync on the dd command, that
forces the data to be written out to all members of the array.  Not
quite intuitive if that is by design - because otherwise, when are you
able to take advantage of the write-behind feature.

The system I was testing on was running off a Fedora 10 live CD, so
it's not the most recent software, but it's not that old, either:
(kernel 2.6.27.5-117.fc10, mdadm 2.6.7.1).

Can anyone confirm that write-behind is working for them, and a quick
test to show that it's working?

-Dave
