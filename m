From: Neil Brown <neilb@suse.de>
Subject: Re: Re[2]: problem with spare, acive device, clean degrated, reshaip RADI5, anybody can help ?
Date: Mon, 4 Feb 2008 12:31:26 +1100
Message-ID: <18342.27374.356338.989265@notabene.brown>
References: <1153106913.20080131033456@j8.com.ru>
	<18342.24549.433129.798288@notabene.brown>
	<151448044.20080204035634@j8.com.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Andreas-Sokov on Monday February 4
Sender: linux-raid-owner@vger.kernel.org
To: Andreas-Sokov <andre.s@j8.com.ru>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday February 4, andre.s@j8.com.ru wrote:
> 
> raid01:/etc# cat /proc/mdstat
> Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [raid4] [multipath] [faulty]
> md1 : active(auto-read-only) raid5 sdc[0] sdb[5](S) sdf[3] sde[2] sdd[1]
              ^^^^^^^^^^^^^^^
>       1465159488 blocks super 0.91 level 5, 64k chunk, algorithm 2 [5/4] [UUUU_]
> 
> unused devices: <none>

That explains it.  The array is still 'read-only' and won't write
anything until you allow it to.
The easiest way is
  mdadm -w /dev/md1

That should restart the reshape.

NeilBrown
