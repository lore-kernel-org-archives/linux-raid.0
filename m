From: Nat Makarevitch <nat@makarevitch.org>
Subject: Re: Linux MD RAID 5 Benchmarks Across (3 to 10) 300 Gigabyte Veliciraptors
Date: Wed, 11 Jun 2008 17:02:28 +0000 (UTC)
Message-ID: <loom.20080611T164646-549@post.gmane.org>
References: <alpine.DEB.1.10.0806071015110.23323@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Justin Piszcz <jpiszcz <at> lucidpixels.com> writes:

> Ever wonder what kind of speed is possible with 3 disk, 4,5,6,7,8,9,10-disk
RAID5s?

> Here are the bonnie++ results:
>
http://home.comcast.net/~jpiszcz/20080607/raid5-benchmarks-3to10-veliciraptors/veliciraptor-raid.html

Why does the amount of spindles has nearly no effect on the amount of seeks per
second?

3 disks: 713.9 seeks/s  (AFAIK the Raptor works at 10000 rpm, getting 230+
seeks/s is astonishing)

10 disks: 705.5 seeks/s  (same as 3 disks?!)

Did I miss something? Or did you use a very large stripe size (to the point of
forbiding the 16 GB file used to span over all spindles?)? Or is it some glitch
in the RAID code (I don't think so, on a RAID10 with 10 low-end disk I obtained
~1000 IOPS: http://www.makarevitch.org/rant/raid/#3wmd)?

