From: Thomas Arthur Oehser <tom@toms.net>
Subject: Re: Is shrinking raid5 possible?
Date: Fri, 6 Nov 2009 08:17:40 -0500
Message-ID: <20091106131740.GA30506@Toms.NET>
References: <44960C45.9050407@anu.edu.au> <17558.10906.59066.196870@cse.unsw.edu.au> <449B3A80.4070602@tmr.com> <17563.17224.85968.572754@cse.unsw.edu.au> <bb145bd20606231116g7808e467w29a9bf273ba0df52@mail.gmail.com> <17567.36792.303403.35943@cse.unsw.edu.au> <bb145bd20606260433w2bafccfdu3448732f5b5c1c5f@mail.gmail.com> <4564B5C3.9050501@idgmail.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4564B5C3.9050501@idgmail.se>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


> > 2) One wants to do something else with some of the space, although for
> > a RAID5 I don't quite see the point - you'd end up with n small
> > partitions. Shrinking a 2-way mirror or stripe this way sounds far
> > more useful.

Oooh, what would I want to do with "n small partitions"?  I know!  Raid!

Scenario:

existing:
sda1 sdb1 sdc1 254M + 254M + 254M = 254M raid-1 /boot
sda2 sdb2 sbc2 2G + 2G + 2G = 6G raid-0 swap
sda3 sdb3 sdc3 1.5T + 1.5T + 15.T = 3T raid-5 /

desired:
sda1 sdb1 sdc1 254M + 254M + 254M = 254M raid-1 /dev/md1 /boot
sda2 sdb2 sbc2 2G + 2G + 2G = 6G raid-0 swap /dev/md2
sda3 sdb3 sdc3 1.4T + 1.4T + 1.4T = 2.8T raid-5 /dev/md3 /
sda4 sdb4 sdc4 100G + 100G + 100G = 200G raid-5 /dev/md4 / <= alt for Koala

Since /dev/md3 is still only 70% full, I thought I could do something like:

 - resize2fs /dev/md3 <smaller>
 - mdadm -G -z <smaller> /dev/md3
 - fdisk /dev/sd[a-c]3 <smaller>

It _almost_ works fine... but... the mdadm -G keeps the (0.90) superblock
at the _end_ of the _device_ ... which hasn't been resized yet ...

How do I put the superblock back after fdisk, or make -G move or recreate?

-Tom

