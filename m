From: Saurabh Barve <sa@atmos.colostate.edu>
Subject: replacing failed hard drives in RAID 5 configuration
Date: Mon, 11 Oct 2004 15:33:57 -0600
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <416AFC45.1010001@atmos.colostate.edu>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090400090500050005000007"
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------090400090500050005000007
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

I am running a server that has four 250 GB hard drives in a RAID 5 
configuration. Recently, two of the hard drives failed. I copied the 
data bitwise from one of the failed hard drives (/dev/hdc1) to another 
(/dev/hdd1) using dd_rescue 
(http://www.garloff.de/kurt/linux/ddrescue/). The failed hard drive had 
about 300 bad blocks (I checked using the badblocks utility). Because of 
the failure of the two hard drives, the RAID (/dev/md0) wouldn't start.

I tried to add the new hard drive (/dev/hdd1) to the RAID using mdadm. I 
kept the failed hard drive (/dev/hdc1) in the machine. The other two 
functional hard drives are /dev/hdg1 and /dev/hdh1. Initially I tried 
starting the array with 'raidstart'. When I did this, I got the 
following error messages in /var/log/messages:

Oct 11 14:41:15 server-name kernel: md: invalid raid superblock magic on 
hdd1
Oct 11 14:41:15 server-name kernel: md: hdd1 has invalid sb, not importing!
Oct 11 14:41:15 server-name kernel: md: could not import hdd1, trying to 
run array nevertheless.
Oct 11 14:41:15 server-name kernel:  [events: 00000017]
Oct 11 14:41:15 server-name kernel:  [events: 00000017]
Oct 11 14:41:15 server-name kernel: md: autorun ...
Oct 11 14:41:15 server-name kernel: md: considering hdh1 ...
Oct 11 14:41:15 server-name kernel: md:  adding hdh1 ...
Oct 11 14:41:15 server-name kernel: md:  adding hdg1 ...
Oct 11 14:41:15 server-name kernel: md:  adding hdc1 ...
Oct 11 14:41:15 server-name kernel: md: created md0
Oct 11 14:41:15 server-name kernel: md: bind<hdc1,1>
Oct 11 14:41:15 server-name kernel: md: bind<hdg1,2>
Oct 11 14:41:15 server-name kernel: md: bind<hdh1,3>
Oct 11 14:41:15 server-name kernel: md: running: <hdh1><hdg1><hdc1>
Oct 11 14:41:15 server-name kernel: md: hdh1's event counter: 00000017
Oct 11 14:41:15 server-name kernel: md: hdg1's event counter: 00000017
Oct 11 14:41:15 server-name kernel: md: hdc1's event counter: 0000000f
Oct 11 14:41:15 server-name kernel: md: superblock update time 
inconsistency -- using the most recent one
Oct 11 14:41:15 server-name kernel: md: freshest: hdh1
Oct 11 14:41:15 server-name kernel: md: kicking non-fresh hdc1 from array!
Oct 11 14:41:15 server-name kernel: md: unbind<hdc1,2>
Oct 11 14:41:15 server-name kernel: md: export_rdev(hdc1)
Oct 11 14:41:15 server-name kernel: md0: removing former faulty hdd1!
Oct 11 14:41:15 server-name kernel: md0: max total readahead window set 
to 768k
Oct 11 14:41:15 server-name kernel: md0: 3 data-disks, max readahead per 
data-disk: 256k
Oct 11 14:41:15 server-name kernel: raid5: device hdh1 operational as 
raid disk 3
Oct 11 14:41:15 server-name kernel: raid5: device hdg1 operational as 
raid disk 2
Oct 11 14:41:15 server-name kernel: raid5: not enough operational 
devices for md0 (2/4 failed)
Oct 11 14:41:15 server-name kernel: RAID5 conf printout:
Oct 11 14:41:15 server-name kernel:  --- rd:4 wd:2 fd:2
Oct 11 14:41:15 server-name kernel:  disk 0, s:0, o:0, n:0 rd:0 us:1 
dev:[dev 00:00]
Oct 11 14:41:15 server-name kernel:  disk 1, s:0, o:0, n:1 rd:1 us:1 
dev:[dev 00:00]
Oct 11 14:41:15 server-name kernel:  disk 2, s:0, o:1, n:2 rd:2 us:1 
dev:hdg1
Oct 11 14:41:15 server-name kernel:  disk 3, s:0, o:1, n:3 rd:3 us:1 
dev:hdh1
Oct 11 14:41:15 server-name kernel: raid5: failed to run raid set md0
Oct 11 14:41:15 server-name kernel: md: pers->run() failed ...
Oct 11 14:41:15 server-name kernel: md :do_md_run() returned -22
Oct 11 14:41:15 server-name kernel: md: md0 stopped.
Oct 11 14:41:15 server-name kernel: md: unbind<hdh1,1>
Oct 11 14:41:15 server-name kernel: md: export_rdev(hdh1)
Oct 11 14:41:15 server-name kernel: md: unbind<hdg1,0>
Oct 11 14:41:15 server-name kernel: md: export_rdev(hdg1)
Oct 11 14:41:15 server-name kernel: md: ... autorun DONE.

I also tried to run the array using mdamd - 'mdadm --assemble --scan 
/dev/md0 /dev/hdc1 /dev/hdd1 /dev/hdg1 /dev/hdh1'. However, diung this 
gave me an error message of "Segmentation Fault".

Can anybody help me replace the old hard drive (/dev/hdc1) with the new 
hard drive (/dev/hdd1) that has data copied off of the old drive?

Thanks,
Saurabh Barve.

--------------090400090500050005000007
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


--------------090400090500050005000007--
