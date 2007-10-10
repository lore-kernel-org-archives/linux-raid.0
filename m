From: Kelly Byrd <kbyrd-linuxraid@memcpy.com>
Subject: Different sized disks for RAID1+0 or RAID10.
Date: Wed, 10 Oct 2007 06:12:45 -0700
Message-ID: <2c4919c7d0aa93b6f41a7b2eb1ccd4e5@memcpy.com>
Reply-To: kbyrd-linuxraid@memcpy.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


I've currently got a pair of identical drives in a RAID1 set for
my data partition. I'll be getting a pair of bigger drives in a
bit, and I was wondering if I could RAID1 those (of course) and
then RAID0 the two differently sized mds. Even better, will RAID10
let me do this? 

I don't need to grow the current RAID1 into this new beast, I've
got a place I can copy the existing data so I can start from
scratch.

I imagine the answer is: "sure RAID10 / RAID0 let's you do this,
but you don't get the striping performance benefit" for some of
the data", which would be ok with me until the smaller drives go
bad and I replace them.


