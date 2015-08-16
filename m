From: "David C. Rankin" <drankinatty@suddenlinkmail.com>
Subject: moving arrays from MBR part table install to GPT? Possible?
Date: Sun, 16 Aug 2015 01:31:10 -0500
Message-ID: <55D02E2E.1080909@suddenlinkmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: mdraid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

All,

   I suffered a controller failure on my server housing a 2-disk/4-partition 
raid1 mdraid array under Archlinux with MBR partition table. The original 
motherboard was non-UEFI, of course everything now is. I am getting conflicting 
information whether my existing arrays are usable with the new UEFI board. I 
don't know if this is the best place to ask, but heck, there is a lot of 
collective wisdom regarding mdadm here.

   I am planning to set the BIOS on the new board to Legacy and attempt to use 
my existing arrays by booting the Arch install media, assembling the arrays, 
then chrooting and rebuilding initramfs to preserve the existing setup. Is there 
any reason that can't work?. (I haven't dealt with the UEFI fun before)

   If that will not work, I'm left with installing to new drives. If I do end up 
with a full install, I'm left with the MBR or GPT partition table choice. I will 
install to 2 new drives that I want to again be setup as raid1 arrays with 
mdadmin. Does mdadmin/mdraid require a MBR partition type? Or, can I create a 
GPT partition table and use mdadm to manage the array?

   If GPT is fine, then is there anyway to migrate my existing array to a GPT 
partition table in the new box without having to install to new drives with a 
GPT table and then mount one of the existing drives to copy the data to the new 
array?

   If these questions are already answered in a link somewhere, I apologize, I 
haven't found it. Thanks for any help/advise you can provide.

-- 
David C. Rankin, J.D.,P.E.
