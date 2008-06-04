From: Jules Bean <jules@jellybean.co.uk>
Subject: boot time autoassembly: how come it works?
Date: Wed, 04 Jun 2008 23:05:16 +0100
Message-ID: <4847119C.3070002@jellybean.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I'm trying to understand the boot sequence of new kernels (2.6.24, 
initramfs) better and I really don't understand how the RAID assembly works.

The docs (md.txt) say that auto-assembly only occurs if the RAID arrays 
are marked as 'RAID autodetect' aka partition type 0xfd. On the other 
hand mdadm needs mdadm.conf to get going.

My RAID arrays (including the one which contains the root file system, 
/dev/md2) are not marked as 0xfd, and they are not correctly listed in 
/etc/mdadm/mdadm.conf on the initramfs filesystem either. (There are 
some listings in there but they are out of date : UUIDs wrong and number 
of devices wrong).

So how come it works?

Jules
