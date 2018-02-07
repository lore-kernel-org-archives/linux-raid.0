From: Marc MERLIN <marc@merlins.org>
Subject: Re: force remapping a pending sector in sw raid5 array
Date: Tue, 6 Feb 2018 20:29:44 -0800
Message-ID: <20180207042944.d2b2ncaxhuctf5b3@merlins.org>
References: <20180206181416.amo6geclrvc6ylrf@merlins.org>
 <d764a824-fe3e-583a-10ef-040bc32dc78e@websitemanagers.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <d764a824-fe3e-583a-10ef-040bc32dc78e@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <mailinglists@websitemanagers.com.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Feb 07, 2018 at 08:51:15AM +1100, Adam Goryachev wrote:
> On 07/02/18 05:14, Marc MERLIN wrote:
> > So, I have 2 drives on a 5x6TB array that have respectively 1 and 8
> > pending sectors in smart.
> > 
> > Currently, I have a check running, but it will take a while...
> > 
> > echo check > /sys/block/md7/md/sync_action
> > md7 : active raid5 sdf1[0] sdg1[5] sdd1[3] sdh1[2] sde1[1]
> >        23441561600 blocks super 1.2 level 5, 512k chunk, algorithm 2 [5/5] [UUUUU]
> >        [==>..................]  check = 10.5% (615972996/5860390400) finish=4822.1min speed=18125K/sec
> >        bitmap: 3/44 pages [12KB], 65536KB chunk

So, I'm a bit confused.
First, I had
      [====>................]  check = 22.5% (1321310068/5860390400) finish=3442.7min speed=21973K/sec
and to recover from that mark, I have to 
echo 2642620136 > /sys/block/md7/md/sync_min

In other words, 1321310068 is not the number you feed to sync_min, you
have to double it.

Then, you said I should take my LBA from 
# 2  Short offline       Completed: read failure       90%       293         1287409520
and multiply it by 4.

Does it really mean I should have used 8?

I used
1287000000 * 4 
5148000000
1288000000 * 4
5152000000
echo 5144000000 > /sys/block/md7/md/sync_min
echo 5160000000 > /sys/block/md7/md/sync_max

And the sync ran without tripping the bad block.
Worse (kinda), the resync just hung once it reached 5160000000. I had to
force idle to stop it.
For what it's worth, the finish counter is also based on the last block
of the drive, and not the value of sync_max.
Minor bugs/problems?

Ok, so I tried again by doubling the value:
echo 10296000000 > /sys/block/md7/md/sync_min
echo 10304000000 > /sys/block/md7/md/sync_max
echo check > /sys/block/md7/md/sync_action

This does not seem to have helped either. I'm now stuck on:
Personalities : [linear] [raid0] [raid1] [raid10] [multipath] [raid6] [raid5] [raid4]
md7 : active raid5 sdf1[0] sdg1[5] sdd1[3] sdh1[2] sde1[1]
      23441561600 blocks super 1.2 level 5, 512k chunk, algorithm 2 [5/5] [UUUUU]
      [=================>...]  check = 87.9% (5152000000/5860390400) finish=1977.2min speed=5970K/sec
      bitmap: 1/44 pages [4KB], 65536KB chunk

Sync has reached max and is hung there, but without triggering the bad
block.

Mmmh, hitting this LBA reported in smart seems harder than it seemed.
I've just reset it to running the whole disk and hope it'll hit the bad
block eventually. 

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                       | PGP 7F55D5F27AAF9D08
