From: "exxs.net - matevz sernc-urban" <ms@exxs.net>
Subject: RAID10,f2 out of sync though synced
Date: Fri, 25 Jul 2008 13:18:02 +0200
Message-ID: <4889B66A.20301@exxs.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

we have a RAID10,f2 over 4 SATA drives connected directly to the mobo.

Comparing a md5sum on first 1K (or 1M) gives me two different md5 - 
sometimes its '0f343b0931126a20f133d67c2b018a3b' and other times its 
'eff670f7076825ba3411ec24dd1ea5b1'.

Is this a correct behaviour on a RAID10,f2 with 4 disks?
And hints?

* cat /proc/mdstat
Personalities : [raid1] [raid10]
md2 : active raid10 sdb5[1] sda5[0] sdd5[3] sdc5[2]
       953778688 blocks 64K chunks 2 far-copies [4/4] [UUUU]

* echo check > /sys/block/md2/md/sync_action
finished without any new result - then array must be in sync i suppose.

* did also:
echo 1 > /proc/sys/vm/drop_caches

* and now we compare the first 1K from the array - it should always be 
the same, but its not.

=> dd if=/dev/md2 iflag=direct bs=1K count=1 status=noxfer|md5sum
0f343b0931126a20f133d67c2b018a3b
=> dd if=/dev/md2 iflag=direct bs=1K count=1 status=noxfer|md5sum
eff670f7076825ba3411ec24dd1ea5b1
=> dd if=/dev/md2 iflag=direct bs=1K count=1 status=noxfer|md5sum
eff670f7076825ba3411ec24dd1ea5b1
=> dd if=/dev/md2 iflag=direct bs=1K count=1 status=noxfer|md5sum
0f343b0931126a20f133d67c2b018a3b

thanks
mat
