From: Jean Jordaan <jean@upfrontsystems.co.za>
Subject: Recovering RAID5 array
Date: Tue, 20 Jan 2004 08:54:55 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <400CD0BF.2010808@upfrontsystems.co.za>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all

I'm having a RAID week. It looks like 1 disk out of a
3-disk RAID5 array has failed. The array consists of
/dev/hda3 /dev/hdb3 /dev/hdc3 (all 40Gb)
I'm not sure which one is physically faulty. In an attempt
to find out, I did:
   mdadm --manage --set-faulty /dev/md0 /dev/hda3

The consequence of this was 2 disks marked faulty and no
way to get the array up again in order to use raidhotadd
to put that device back.

I'm scared of recreating superblocks and losing all my data.
So now I'm doing 'dd if=/dev/hdb3 of=/dev/hdc2' of all three
RAID partitions so that I can work on a *copy* of the data.

Then I aim to
mdadm --create /dev/md0 --raid-devices=3 --level=5 \
   --spare-devices=1 --chunk=64 --size=37111 \
   /dev/hda1 /dev/hda2 missing /dev/hdb1 /dev/hdb2

hda2 is a copy of the partition of the drive I'm currently
suspecting of failure. hdb2 is a blank partition.

I've been running Seagate's drive diagnostic software
overnight, and the old disks check out clean. This makes me
afraid that it's reiserfs corruption, not a RAID disk
failure :/

Does anyone here have any comments on what I've done so far,
or if there's anything better I can do next?

-- 
Jean Jordaan
http://www.upfrontsystems.co.za

