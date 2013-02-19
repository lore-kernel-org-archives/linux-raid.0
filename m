From: "stone@heisl.org" <stone@heisl.org>
Subject: Brocken Raid & LUKS
Date: Tue, 19 Feb 2013 17:01:16 +0100
Message-ID: <5123A1CC.2000003@heisl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

hi guys.

yesterday my raid5 of 4 disk is broken and i dont find a better way as 
to re-create it new.
mdadm --create /dev/md2 --assume-clean --verbose --level=5 
--raid-devices=4 /dev/sdc1 /dev/sdd1 missing /dev/sdf1

my problem is now that i cannot open die LUKS on the device md2
cryptsetup luksOpen /dev/md2 md2_nas
Device /dev/md2 is not a valid LUKS device.

i found with an hexdump on the disk sdc1 and sdf1 the LUKS header
hexdump -C /dev/sdc1 | head -40
.....
00100000  4c 55 4b 53 ba be 00 01  61 65 73 00 00 00 00 00 
|LUKS....aes.....|
....

so i think the header must be also on the md2 device but not on the 
beginning.
is my raid constrct false? must i reconstruct my array new?

who can i bring my raid so up that i can open the LUKS and save all my data?

thank you.

