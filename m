From: rrk <rrk@prairie.lakes.com>
Subject: re mdadm  raid1 creation problems
Date: Sat, 12 Jun 2004 05:13:57 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <40CAD765.7040307@prairie.lakes.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

sorry my reply's are not making it to the list

the error msg i get is

/dev/md1 file system size ( according to the superblock) is 2560351
the pyhical size of the device is 2560320 either the superblock or
the partion table is corrupt

/dev/md1: UNEXPECTED INCONSISTENCY; RUN fsck MANUALLY

i get this msg on the first boot with md1 as the primary boot partion

i thought i was being pretty careful about rebooting after all partion 
changes

the build order/process is

build and test hda  debian 2.4.26 with raid compiled in
sfdisk to transfer partions   sfdisk -d /dev/hda | sfdisk /dev/hdc
set hdc partion type  to fd
reboot
mk file system on hdc and copy hda to hdc
reboot
test hdc as primary boot
reboot
create md1   mdadm --create /dev/md1 --level=1 --raid-devices=2 missing 
/dev/hdc1
there are 3 md devices / home & var
reboot
mount md device for test
change hda partion type to fd
reboot
edit fstab and grub on md devices
shutdown
boot from mepis rescue disk
mdadm --add /dev/md1 /dev/hda1
wait for resync
shutdown
reboot from md1

thanks
rob


