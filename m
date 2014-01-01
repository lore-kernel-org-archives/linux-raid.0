From: Krzysztof Adamski <k-list@adamski.org>
Subject: Looking for help how to migrate 2disk RAID1 to 3 disk RAID6
Date: Tue, 31 Dec 2013 19:51:51 -0500
Message-ID: <1388537511.5058.22.camel@oxygen.netxsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have a system with two drives like this:
/ RAID1 on sda3 and sdb3
/boot RAID1 on sda1 and sdb1

I would like to migrate to
/ RAID6 on sdi3, sdj3 and sdh3
/boot RAID1 on sdi1, sdj1 and sdh1

The /boot already done.
How would I do the migration to RAID6?

The new drives i,j and h are larger then a and b, after the migration I
will reshape the raid to use all the space on the new raid, unless it is
possible to do it in one step.

The reason I want RAID6 and not RAID1 with 3 drives is that later I may
add more drives to the array.

Currently I don't trust any RAID that has only one parity drive, it has
to survive a failure of any two drives. So RAID6 or triple RAID1 are a
minimum.

Thanks in advance,
K

