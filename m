From: Norman <norman.quisumbing@kkoncepts.net>
Subject: Raid failure- Please help - Linux-Raid noob
Date: Sun, 4 Sep 2016 12:15:19 +0800
Message-ID: <e1d86018-e5e1-3d2c-6f12-e29de571afe3@kkoncepts.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I'm familiar with basic RAID technology but I'm not that familiar with 
software RAID on Linux. My system admin is not available as the RAID 5 
failure happened early Friday evening. I'd like to recovery the RAID 
since it seems the hard-disks are still operational, at least they seem 
to be.

The scenario: 1U server with (4) 2TB drives in RAID5 and RAID1 
configuration. The system boots to GRUB but root partition doesn't 
mount. I get a small shell call BusyBox. I can run mdadm for it.
Running mdadm --examine manually, it seems that sda1, sda3, sdb1, sdb3, 
sdc1, sdc3, sdd1, and sdd3 are missing are not active and missing the 
super-block. All other devices sdx2-sdx9 are active. Cat /proc/mdstat 
shows...

md5 :active (auto-read-only) raid1 sdb8[4] sdc8[5], 204788 blocks super 
1.2 [4/2] [_UU_]

md4 :inactive sdb7[4] sdc7[5], 419225 blocks super 1.2

md3 :active (auto-read-only) raid5 sda6[0] sdd6[3] sdc6[5], 6286848 
blocks super 1.2 level 5, 512k chunk, algorithm 2 [4/4] [UUUU]

md2 :inactive sdb5[4] sdc5[5], 2096128 blocks super 1.2

md1 :inactive sdb4[4] sdc4[5], 2096128 blocks super 1.2

md0 :active (auto-read-only) raid1 sda2[0] sdd2[3] sdc2[5] sdb2[4], 
102388 blocks super 1.2 [4/4] [UUUU]

unused devices: <none>

I hope there aren't any typos as I typed the above manually.

Lastly, thing to note...is that I get an Alert! - Alert! 
/dev/disk/by-uuid/c6e309d7-07ce-42e2-9c62-fb53be4b99cc does not exist. I 
don't see this device at all, I see 4 drive with different UUIDs.

I'm not sure what to do or what direction I should go in.

Many thanks for any help.

N

