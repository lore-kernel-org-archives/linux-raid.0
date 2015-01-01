From: Aryeh Leib Taurog <vim@aryehleib.com>
Subject: Reassembling RAID1 after good drive was offline [newbie]
Date: Thu, 1 Jan 2015 19:40:48 +0200
Message-ID: <20150101174048.GB4840@deb76.aryehleib.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I recently made a RAID1 array from a couple of extra usb drives:

$ mdadm --create --metadata 1.2 --verbose /dev/md/backup --level=mirror -n2 /dev/sd[cd]2

I'm using it for my backups.  I've run into a small problem though.
One of the drives for some reason hadn't come online when I tried to 
assemble the array.  Trying --assemble a second time after it came online 
apparently wasn't the right thing to do:

$ mdadm --assemble --scan
mdadm: /dev/md/backup has been started with 1 drive (out of 2).
$ mdadm --assemble --scan
mdadm: /dev/md/backup has been started with 1 drive (out of 2).
$ cat /proc/mdstat 
Personalities : [raid1] 
md126 : active (auto-read-only) raid1 sdc2[0]
      943587136 blocks super 1.2 [2/1] [U_]
      
md127 : active (auto-read-only) raid1 sdd2[1]
      943587136 blocks super 1.2 [2/1] [_U]


AFAIK both drives are healthy, but since that happened, it refuses to 
assemble them both in the array:

$ mdadm --assemble --force /dev/md/backup /dev/sd[db]2
mdadm: ignoring /dev/sdb2 as it reports /dev/sdd2 as failed
mdadm: /dev/md/backup has been started with 1 drive (out of 2).

I haven't mounted the volume, so I believe the drives are in sync.

Is there any way to put the array back together without having to 
resync?  It looks like I want something like --assume-clean, but that 
flag isn't valid in assemble mode.

Please cc responses to me.

Thanks,
Aryeh Leib Taurog
