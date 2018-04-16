From: Chris Murphy <lists@colorremedies.com>
Subject: Add udev-md-raid-safe-timeouts.rules
Date: Sun, 15 Apr 2018 19:04:15 -0600
Message-ID: <CAJCQCtQ3r16BYYtrx9rVYauh7JeAp9omWidS4zzwxqvhU1bh+g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-btrfs-owner@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>, linux-lvm@redhat.com, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I just ran into this:
https://github.com/neilbrown/mdadm/pull/32/commits/af1ddca7d5311dfc9ed60a5eb6497db1296f1bec

This solution is inadequate, can it be made more generic? This isn't
an md specific problem, it affects Btrfs and LVM as well. And in fact
raid0, and even none raid setups.

There is no good reason to prevent deep recovery, which is what
happens with the default command timer of 30 seconds, with this class
of drive. Basically that value is going to cause data loss for the
single device and also raid0 case, where the reset happens before deep
recovery has a chance. And even if deep recovery fails to return user
data, what we need to see is the proper error message: read error UNC,
rather than a link reset message which just obfuscates the problem.


-- 
Chris Murphy
