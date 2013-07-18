From: Qin Dehua <qindehua@gmail.com>
Subject: Problem with disk replacement
Date: Fri, 19 Jul 2013 00:57:30 +0800
Message-ID: <CA+gQ4tcp99ZKOmUCguZgDWaMqrLf=q9c73VPqXUZsutTjL8jRg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,
I use kernel 3.9.6 and found data may lost while replacing a RAID disk
using --replace.

Here is the steps of the test case:
1. Create 3-drives RAID5 and wait for resync done (I use 1GB disks in
VirtualBox machine)
2. Calculate the md5sum on the whole raid: dd if=/dev/md1 bs=1M
iflag=direct | md5sum
3. add two spare disks to the raid: mdadm /dev/md1 -a /dev/sdi -a /dev/sdj
4. mdadm --replace a disk then --fail another disk:
   mdadm /dev/md1 --replace /dev/sdb; sleep 3; mdadm /dev/md1 -f /dev/sdc
5. wait for recovery done
6. recalculate the md5sum on the whole raid: dd if=/dev/md1 bs=1M
iflag=direct | md5sum

The md5sum of step 6 is NOT identical with that of step 2, this means
data is corrupted.
I found in step 4, when another disk was made failed, the replacing
process was stopped,
and started recovering of the failed disk, and afterwards the
replacing not continue.

Regards,
Qin Dehua
