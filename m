From: "Norman Zhang" <nzhang@arkon-group.com>
Subject: RAID1 removal
Date: Fri, 20 Jun 2003 09:42:37 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <bcvdhn$r0f$1@main.gmane.org>
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I tried to remove a hot-swap RAID1 SCSI disk from the chassis. So I issued
the following command

> raidsetfaulty /dev/md4 /dev/sdd6
> raidhotremove /dev/md4 /dev/sdd6

But got the following message,

/dev/md4: cannot hot-remove disk: disk is not in array!

So I presume the disk is offline or something, and issued the following
command

echo "scsi remove-single-device 1 0 3 0" > /proc/scsi/scsi

When I checked the newly created /proc/scsi/scsi, the device is still listed
in the file. I checked /proc/mdstat and saw the following

md4: active raid1 scsi/host1/bus0/target2/lun0/part6[0]
     521984 blocks [2/1][U_]

How do I remove the device, so I can add a new device to reconstruct the
array again? Please give me a few pointers?

Regards,
Norman



