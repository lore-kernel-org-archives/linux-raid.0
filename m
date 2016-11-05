From: Darko Luketic <darko@luketic.de>
Subject: RAID10 with 2 drives auto-assembled as RAID1
Date: Sat, 5 Nov 2016 15:10:17 +0100
Message-ID: <0487f9a4-c04a-8a4d-78ad-0191995d4be9@luketic.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

Scenario:

Moved 6 drives from old to new computer. All good but since there was no 
UEFI entry for grub I had to run the EFI shell and manuall boot grub and 
thus Archlinux.

2 of those drives were previously in a RAID10 array. Created with mdadm 
--level10 -raid-devices=2.

Systemd .. bootprocess stops because it can't start 2 services, 1 the 
VLAN and the other the usually /home mounted device with UUID=some-id. 
Fine I think nothing of it, enter the root password and see what the 
issues is.

Do a "cat /proc/mdstat" and see that the devices that were previously 
assembled as RAID10 are now assembled as RAID1 and syncing. RED ALERT. 
What was the command again? mdadm --manage --stop /dev/md0.

18.1% of syncing complete.

modprobe raid10, rmmod raid1.

mdadm --assemble /dev/md0 /dev/sde1 /dev/sdf1

cat /prod/mdadm

Assembled as RAID1, syncing 18.4%

stopped quickly.

Now. I'd like to save whatever data is possible to be saved.

I'd like to force the 2 drives to be recognized as being in a RAID10 
array. By whatever means necessary, without losing more data.

What can be done? Hex editing signatures is possible.

The RAID10 was created as nearest neighbor.

Theoretically data reconstruction should be possible. Practically?

I mean I don't know how mdadm arranges the blocks, if it's RAID1 
compatible then no big change is needed. If not them I guess I'm SOL.

