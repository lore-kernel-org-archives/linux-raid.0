From: Saurabh Barve <sa@atmos.colostate.edu>
Subject: RAID5 creation problems
Date: Thu, 28 Oct 2004 16:04:51 -0600
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <41816D03.9060706@atmos.colostate.edu>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080909080405000802060102"
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
Cc: Saurabh Barve <sa@atmos.colostate.edu>
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------080909080405000802060102
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

I created a new software RAID 5 array with fresh hard disks. I used 
mkraid to generate the RAID array with four devices /dev/hdc1, 
/dev/hdd1, /dev/hdg1, and /dev/hdh1. I formatted the drives clean, usd 
mkfs to create ext3 filesystems on each, then used 'mkraid /dev/md0' to 
create the RAID. I then used the command 'mke2fs -j -b 4096 -R stride=16 
/dev/md0' to create the filesystem on /dev/md0. I read somewhere that 
the chunk-size parameter in the /etc/raidtab file match the value of the 
block size multiplied by the stride value in the command above. The 
chunk-size in my /etc/raidtab file is 64. I then started the RAID using 
'raidstart /dev/md0'. I was able to mount the partition correctly. 
However, when I tried to examine the status of the RAID array using 
mdadm, it showed /dev/hdg1 as being 'faulty removed'. I then hot added 
/dev/hdg1 to the array, and it started the rebuild process.

Today the array finished rebuilding, and all the hard drives seemed to 
be included in the RAID array. fsck also reported /dev/md0 to be clean. 
However, 'mdadm --detail --scan /dev/md0' shows the status as "Dirty".

Since, this didn't work as I had expected, I formatted my disks again, 
and tried using the following command to create the RAID array:
"mdadm -C /dev/md0 -c 64 -l raid5 -p left-symmetric -n 4 /dev/hdc1 
/dev/hdd1 /dev/hdg1 /dev/hdh1".

This created the RAID array, but when I went to examine the array (mdamd 
-E /dev/md0), I still got an error:
"mdadm: No super block found on /dev/md0 (Expected magic a92b4efc, got 
00000000)"

And 'mdadm --detail --scan /dev/md0' still returns the state of the 
array as 'dirty, degraded, recovering', and this time it is spare 
rebuilding /dev/hdh1.

What do the error messages mean?

Saurabh.





--------------080909080405000802060102
Content-Type: text/x-vcard; charset=utf-8;
 name="sa.vcf"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="sa.vcf"

begin:vcard
fn:Saurabh Barve
n:Barve;Saurabh
org:Colorado State University;Department of Atmospheric Science
adr:;;4100 West Laporte Avenue;Fort Collins;CO;80523;USA
email;internet:sa@atmos.colostate.edu
title:Systems Administrator
tel;work:(970) 491-7714
tel;home:(970) 416-7512
x-mozilla-html:TRUE
version:2.1
end:vcard


--------------080909080405000802060102--
