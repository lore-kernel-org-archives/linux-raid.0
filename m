From: Mark Knecht <markknecht@gmail.com>
Subject: 3 disk RAID1?
Date: Mon, 8 Mar 2010 12:39:26 -0800
Message-ID: <5bdc1c8b1003081239l32c5653fs8347179e23c0a287@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi all,
   I'm still very much on a steep learning curve about what I can do
with Linux software RAID. In another thread this weekend a couple of
responders discussed among themselves 3-disk RAID1 solutions that can
survive if 2 disks die. I don't understand what that means. Can
someone point me at a quick explanation? Is that really possible?

   In general I'm using a few Wikipedia pages and gravitate toward the
diagrams as much as anything.

http://en.wikipedia.org/wiki/RAID
http://en.wikipedia.org/wiki/RAID1#RAID_1

RAID0 - striping, speed not reliability (2 disk minimum)
RAID1 - duplicate data, no other protection (2 disk minimum)

   How do I build RAID1 using three drives? Just duplicate the data 3
times? If drives start going bad how do I determine which one or two
are failing? (fsck? SMART?) With 3 drives 1 fail seems relatively
straightforward to figure out, but 2?

Thanks,
Mark
