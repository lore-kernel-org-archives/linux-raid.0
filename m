From: Janek Kozicki <janek_listy@wp.pl>
Subject: switching root fs '/' to boot from RAID1 with grub
Date: Tue, 30 Oct 2007 21:07:21 +0100
Message-ID: <20071030210721.386ca2fa@absurd>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I have and olde HDD and two new HDDs:

- hda1 - my current root filesystem '/'
- sda1 - part of raid1 /dev/md0 [U_U]
- hdc1 - part of raid1 /dev/md0 [U_U]

I want all hda1, sda1, hdc1 to be a raid1. I remounted hda1 readonly 
then I did 'dd if=/dev/hda1 of=/dev/md0'. I carefully checked that
the partition sizes match exactly. So now md0 contains the same thing
as hda1. 

But hda1 is still outside of the array. I want to add it to the array.
But before I do this I think that I should boot from /dev/md0 ?
Otherwise I might hose this system. I tried `grub-install /dev/sda1`
(assuming that grub would see no problem with reading raid1
partition, and boot from it, until mdadm detects an array). I tried
`grub-install /dev/sda` as well as on /dev/hdc and /dev/hdc1.
I turned off 'active' flag for partition hda1 and turned it on for hdc1
and sda1. But still grub is booting from hda1.

I did all this with version 1.1

mdadm --create --verbose /dev/md0 --chunk=64 --level=raid1 \
      --metadata=1.1  --bitmap=internal --raid-devices=3 /dev/sda1 \
      missing /dev/hdc1

I'm NOT using LVM here.

Can someone tell me how should I switch grub to boot from /dev/md0 ?

After the boot I will add hda1 to the array, and all three partitions
should become a raid1.

-- 
Janek Kozicki                                                         |
