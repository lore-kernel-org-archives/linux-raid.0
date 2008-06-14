From: "Sean Hildebrand" <silverwraithii@gmail.com>
Subject: Rebuilding an array with a corrupt disk.
Date: Fri, 13 Jun 2008 22:22:22 -0400
Message-ID: <fa037c550806131922y475de7ew8c3a66aa06d081b1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I had a batch of disks go bad in my array, and have swapped in new disks.

My array is a five disk RAID5, each 750GB. Currently I have four disks
operational within the array, so the array is functionally a RAID0.
Rebuilds have gone fine, except for the latest disk, which I've tried
four times.

At 74% into the rebuild, mdadm drops /dev/sdd1 (The spare being
synced) and /dev/sda1 (A synced disk active in the array.) due to a
read error on /dev/sda1. Checking smartctl, there have been 43 read
errors on the disk, and they occur in groups.

The array contents have been modifed since the removal of the older
disks - So only the four currently-operational disks are synced.

Fscking the array also has issues past the halfway mark - Namely, when
it gets to a certain point, /dev/sda1 is dropped from the array and
fsck begins spitting out inode read errors.

Are there any safe ways to remedy my problem? Resizing the array from
five disks to four and then removing /dev/sda1 is impossible, as for
the array to be resized, error free reads of /dev/sda1 would be
necessary, no?
