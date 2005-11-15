From: Neil Brown <neilb@suse.de>
Subject: Re: Crooked raid
Date: Wed, 16 Nov 2005 10:07:30 +1100
Message-ID: <17274.27186.622362.978757@cse.unsw.edu.au>
References: <4379FCC8.5090903@logidac.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Guillaume Filion on Tuesday November 15
Sender: linux-raid-owner@vger.kernel.org
To: Guillaume Filion <gfk@logidac.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday November 15, gfk@logidac.com wrote:
> 
> I'm wondering what would be the easiest way to correct this. If 
> possible, I'd prefer not having to start from scratch.
> 

It's not entirely clear to me what is happening,  In particular, why
md is tring to bind '..../disc,*' to an array.  Maybe something is
running 'raidstart'.  Do you have an '/etc/raidtab'?? If so, remove
it.

If md0 doesn't hold your root filesystem, try unmounting it, stopping
it with
  mdadm --stop /dev/md0
and restarting with
  mdadm --assemble /dev/md0 --update=summaries /dev/hd[gc]2

NeilBrown
