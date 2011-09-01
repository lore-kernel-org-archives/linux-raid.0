From: Pim Zandbergen <P.Zandbergen@macroscoop.nl>
Subject: freshly grown array shrinks after first reboot - major data loss
Date: Thu, 01 Sep 2011 17:28:53 +0200
Message-ID: <4E5FA4B5.6010407@macroscoop.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I replaced every 2TB drive of my 7-drive RAID-5 array with 3TB drives.
After the last replacement I could grow the array from 12 TB to 18 TB using

mdadm --grow /dev/md0 --size max

That worked:
md0: detected capacity change from 12002386771968 to 18003551059968

It worked for quite a while, until the machine had to be rebooted. It 
shrunk:
md0: detected capacity change from 0 to 4809411526656

The LVM volume group on this array would not be activated until I repeated
the mdadm command. It grew back to the original size.
md0: detected capacity change from 4809411526656 to 18003551059968

However, this caused major data loss, as everything beyond the perceived
4.8 TB size was wiped by the sync process.

This happened on Fedora 15, using kernel-2.6.38.6-27.fc15.x86_64 and
mdadm-3.2.2-6.fc15.x86_64.

The drives are Hitachi Deskstar 7K3000 HDS723030ALA640. The adapter is an
LSI Logic  SAS2008 PCI-Express Fusion-MPT SAS-2 [Falcon] (rev 03)
(LSI SAS 9211-8i). I had to buy this adapter as my old SAS1068 based card
would not support 3TB drives.

I can probably fix this by creating a fresh new array and then start 
restoring
my backups, but now is the time to seek for the cause of this.

I can reproduce this on demand. I can grow the array again, and it will 
shrink
immediately after the next reboot.

What should I do to find the cause?

Thanks,
Pim
