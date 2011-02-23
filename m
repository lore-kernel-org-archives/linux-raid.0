From: Iordan Iordanov <iordan@cdf.toronto.edu>
Subject: failing a drive while RAID5 is initializing
Date: Wed, 23 Feb 2011 11:20:34 -0500
Message-ID: <4D6533D2.3020600@cdf.toronto.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi guys,

I just wanted to make sure that the behaviour I observed is as expected. 
With kernel 2.6.35.11, under Debian Lenny, I created a RAID5 array with 
5 drives, partitioned it, formatted a partition with ext3 and mounted 
it. Then, I put some load onto the filesystem with:

dd if=/dev/urandom of=/mnt/testfile

The array started initializing. At that point, I needed to fail and 
replace a drive for some unrelated testing, so I did that with:

mdadm /dev/md0 -f /dev/sdc

The result was a broken filesystem which was remounted read-only, and a 
bunch of errors in dmesg. Theoretically, one would imagine that failing 
a drive on a RAID5 even during initialization should render the array 
without redundancy but workable. Am I wrong? Is there something special 
about the initialization stage of RAID5 that makes drive failure fatal 
during the initialization? If not, then I have a bug to report and I'll 
try to reproduce it for you.

If initialisation is special, does that mean that when creating RAID5, 
it is advisable to *wait* until the array has fully initialized before 
using it, otherwise one risks losing any data that was put onto the 
array during the initialization phase if a drive fails at that point?

Many thanks for any input,
Iordan Iordanov
