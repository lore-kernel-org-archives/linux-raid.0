From: Janek Kozicki <janek_listy@wp.pl>
Subject: very degraded RAID5, or increasing capacity by adding discs
Date: Mon, 8 Oct 2007 21:13:13 +0200
Message-ID: <20071008211313.6cd8bbb5@absurd>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

Recently I started to use mdadm and I'm very impressed by its
capabilities. 

I have raid0 (250+250 GB) on my workstation. And I want to have
raid5 (4*500 = 1500 GB) on my backup machine.

The backup machine currently doesn't have raid, just a single 500 GB
drive. I plan to buy more HDDs to have a bigger space for my
backups but since I cannot afford all HDDs at once I face a problem
of "expanding" an array. I'm able to add one 500 GB drive every few
months until I have all 4 drives.

But I cannot make a backup of a backup... so reformatting/copying all
data each time when I add new disc to the array is not possible for me.

Is it possible anyhow to create a "very degraded" raid array - a one
that consists of 4 drives, but has only TWO ?

This would involve some very tricky *hole* management on the block
device... A one that places holes in stripes on the block device,
until more discs are added to fill the holes. When the holes are
filled, the block device grows bigger, and with lvm I just increase
the filesystem size. This is perhaps coupled with some "unstripping"
that moves/reorganizes blocks around to fill/defragment the holes.

is it just a pipe dream?

best regards


PS: yes it's simple to make a degraded array of 3 drives, but I
cannot afford two discs at once...

-- 
Janek Kozicki                                                         |
