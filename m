From: Neil Brown <neilb@suse.de>
Subject: Re: conflicting superblocks - Re: what is the best approach for fixing
 a degraded RAID5 (one drive failed) using mdadm?
Date: Tue, 12 Jun 2007 14:51:33 +1000
Message-ID: <18030.9813.5683.133889@notabene.brown>
References: <466D4F51.40009@musicpictures.com>
	<466E24B6.6070505@musicpictures.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from simon redfern on Tuesday June 12
Sender: linux-raid-owner@vger.kernel.org
To: simon redfern <simon@musicpictures.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday June 12, simon@musicpictures.com wrote:
> 
> 
> Can anyone please advise which commands we should use to get the array
> back to at least a read only state?

mdadm --assemble /dev/md0  /dev/sd[abcd]2

and let mdadm figure it out.  It is good at that.
If the above doesn't work, add "--force", but be aware that there is
some possibility of hidden data corruption.  At least a "fsck" would
be advised.

NeilBrown
