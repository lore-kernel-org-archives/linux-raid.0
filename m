From: Neil Brown <neilb@suse.de>
Subject: Re: Is that normal a removed part in RAID0 still showed as "active sync"
Date: Tue, 8 Jan 2008 14:53:54 +1100
Message-ID: <18306.62418.854287.117775@notabene.brown>
References: <14670113.post@talk.nabble.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Hxsrmeng on Monday January 7
Sender: linux-raid-owner@vger.kernel.org
To: Hxsrmeng <hxsrmeng@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday January 7, hxsrmeng@gmail.com wrote:
> 
> The /dev/md0 is set as RAID0
> "cat /proc/mdstat" shows
> md0 : active raid0 sda1[0] sdd1[3] sdc1[2] sdb1[1]
> 157307904 blocks 64k chunks
> 
> Then sdd is removed.
> 
> But  "cat /proc/mdsta" still shows the same information as above, while two
> RAID5 devices show their sdd parts as (F)
> md0 : active raid0 sda1[0] sdd1[3] sdc1[2] sdb1[1]
> 157307904 blocks 64k chunks
> 
> Is this normal?

Yes.

raid0 is not real raid.  It is not able to cope with disk failures, so
it doesn't even try.  Devices in a raid0 are never marked failed as
doing so would be of no benefit.

NeilBrown


