From: hansbkk@gmail.com
Subject: Shouldn't --zero-superblock reset the UUID?
Date: Wed, 16 Feb 2011 23:10:53 +0700
Message-ID: <AANLkTikuHrSyhmi01LgKGZhMCvAKoXJmutwhfL974zvT@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I've only seen this problem with RAID1, but perhaps it applies to other levels.

When adding a member partition to an array, the UUID of that partition
gets set to that of the array (and all the other members)

However, when fail/remove/zero-superblock 'ing a member back out of
the array, the UUID gets left behind, along with the label and fs
type.

Ideally the partition would be left in a state as if it never had any
filesystem at all on it, as when using dd /if=dev/zero and a fresh
sfdisk.

If this isn't possible, perhaps the zero-superblock option should
trigger a reminder message to either zero the drive or re-format the
partition?

Not a huge issue but. . .
