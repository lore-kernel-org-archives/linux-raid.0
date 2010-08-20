From: Juan Aristizabal <jaristizabal@datagardens.com>
Subject: mdadm create problem with existing bitmap file
Date: Fri, 20 Aug 2010 11:16:39 -0600
Message-ID: <4C6EB877.1050602@datagardens.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I am using mdadm 2.6.3 on Ubuntu 8.04.3 32 bits. Sometimes I hit this 
error when I try to create a RAID1:

mdadm --create --force --assume-clean /dev/md73 --level=1 
--bitmap=/root/bitmaps/md73bm.tmp --raid-devices=2 /dev/vg1/vol1 
--write-mostly /dev/sdj

Continue creating array? mdadm: failed to open bitmap file 
/root/bitmaps/md73bm.tmp: Text file busy

The bitmap file exists, but lsof doesn't show that it is in use by any 
other process.

If I copy the bitmap file and try the create again everything works fine.

Any idea what might be happening here?


Thanks,

 
Juan Aristizabal


