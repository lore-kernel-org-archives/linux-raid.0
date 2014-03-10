From: AdsGroup <AdsGroup@shaw.ca>
Subject: grub and mdadm
Date: Sun, 09 Mar 2014 18:24:23 -0600
Message-ID: <531D0637.4080009@shaw.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

In the past I have used whole drives (<2TB) as block devices for mdadm 
raid and a separate single drive for grub, boot, swap, root and home 
with no problem. I now want to upgrade (non-UEFI bios machine) to 
multiple 3TB drives thinking 3 active in Raid 5 with 1 spare again using 
the full drives as block devices and installing Lubuntu 12.10 LTS 
alternate for server/command line.

Using Lubuntu 13.10 desktop live (therefore recent mdadm, gparted, 
parted, etc) I've created and easily assembled/started the mdadm array 
/dev/md0 from sd[a-c], sdd as spare. I then partition /dev/md0 on MIB 
boundaries the following in order 1MB free space, 2MB bios-grub, 200MB 
boot, 10GB swap, remainder root (5.6 TB?) with 1MB trailing free space.

Then rebooting to 12.10 alternate for install I have difficulties 
installing grub anywhere. Even fails using boot-repair (link below) Any 
ideas?

Ashley



https://help.ubuntu.com/community/Boot-Repair
