From: Prakash Achuthan <prakasha@india.hp.com>
Subject: Changing MD device partition type
Date: Thu, 05 Jun 2003 14:51:35 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3EDFBB67.5030504@india.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I have a software RAID volume (of four 160 GB harddisk) which is to be 
added to a separate volume group. Now, when I do a pvcreate (pvcreate 
/dev/md3), it fails saying "Invalid phyiscal volume". All the disks in 
the RAID volume have their partition type set to "linux auto detect". 
One of the mails in a mailing list says that the partition type of the 
md0 should be "8e".

How do I change the partition type ? fdisk /dev/md3 does not show any 
partition.


Thanks,
Prakash

