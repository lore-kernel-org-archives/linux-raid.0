From: Richard Scobie <richard@sauce.co.nz>
Subject: Array will not assemble
Date: Fri, 07 Jul 2006 11:39:23 +1200
Message-ID: <44AD9F2B.9090205@sauce.co.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Perhaps I am misunderstanding how assemble works, but I have created a 
new RAID 1 array on a pair of SCSI drives and am having difficulty 
re-assembling it after a reboot.

The relevent mdadm.conf entry looks like this:


ARRAY /dev/md3 level=raid1 num-devices=2 
UUID=72189255:acddbac3:316abdb0:9152808d devices=/dev/sdc,/dev/sdd

The above is all one line.

If I run "mdadm -As", I get the error:

mdadm: no devices found for /dev/md3.

If I then run:

mdadm --assemble /dev/md3 /dev/sdc /dev/sdd

it all starts up fine.

Thanks,

Richard
