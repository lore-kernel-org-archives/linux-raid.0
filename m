From: Sarah Newman <srn@prgmr.com>
Subject: Re: Raid check didn't fix Current_Pending_Sector, but badblocks -nsv
 did
Date: Mon, 6 Jun 2016 12:10:23 -0700
Message-ID: <5755CA9F.6090807@prgmr.com>
References: <20160606174113.GI12382@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20160606174113.GI12382@merlins.org>
Sender: linux-raid-owner@vger.kernel.org
To: Marc MERLIN <marc@merlins.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 06/06/2016 10:41 AM, Marc MERLIN wrote:
> Howdy, I have a raid 5 where one drive reported this:
> 197 Current_Pending_Sector  0x0032   200   199   000    Old_age   Always -       29
> 
> So I did this:
> myth:~# echo check > /sys/block/md5/md/sync_action
> [173947.749761] md: data-check of RAID array md5
> (...)
> [370316.769230] md: md5: data-check done.
> 
> My understanding was that it was supposed to read every block of every
> drive, and if some blocks were unreadable, use parity to rewrite them on
> some fresh backup blocks.
> If a block returned garbage instead, md5 cannot fix this not knowing which
> block is wrong, but I'm assuming the check would have failed with an error.

https://www.kernel.org/doc/Documentation/md.txt shows for sync_action

       check         - A full check of redundancy was requested and is
                       happening.  This reads all blocks and checks
                       them. A repair may also happen for some raid
                       levels.
       repair        - A full check and repair is happening.  This is
                       similar to 'resync', but was requested by the
                       user, and the write-intent bitmap is NOT used to
		       optimise the process.

I think you wanted 'repair' not 'check'.

--Sarah
