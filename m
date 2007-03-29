From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: Software RAID (non-preempt) server blocking question. (2.6.20.4)
Date: Thu, 29 Mar 2007 05:56:12 -0300
Message-ID: <20070329085612.GA19278@khazad-dum.debian.net>
References: <Pine.LNX.4.64.0703270557360.31853@p34.internal.lan> <17931.23488.160031.119117@notabene.brown> <Pine.LNX.4.64.0703290410260.32099@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0703290410260.32099@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Neil Brown <neilb@suse.de>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 29 Mar 2007, Justin Piszcz wrote:
> >Did you look at "cat /proc/mdstat" ?? What sort of speed was the check
> >running at?
> Around 44MB/s.
> 
> I do use the following optimization, perhaps a bad idea if I want other 
> processes to 'stay alive'?
> 
> echo "Setting minimum resync speed to 200MB/s..."
> echo "This improves the resync speed from 2.1MB/s to 44MB/s"
> echo 200000 > /sys/block/md0/md/sync_speed_min
> echo 200000 > /sys/block/md1/md/sync_speed_min
> echo 200000 > /sys/block/md2/md/sync_speed_min
> echo 200000 > /sys/block/md3/md/sync_speed_min
> echo 200000 > /sys/block/md4/md/sync_speed_min

md RAID1 resync reacts *extremely* badly to CFQ.  Just a data point, you may
want to check on it.  Might mean other RAID types also get screwed, and also
that md "check" is also disturbed by CFQ (or disturbs CFQ, whatever).

I reverted everything here to non-CFQ while the RAID did its resync (which
fixed all issues immediately), and we went back to 2.6.16.x later for other
reasons.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
