From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: Superblock backup
Date: Fri, 11 May 2012 20:15:34 +0200
Message-ID: <20120511181534.GA2953@lazy.lzy>
References: <20120510174431.GA3019@lazy.lzy>
 <20120511085057.27790c1a@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120511085057.27790c1a@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

iHi Neil,

> > In any case, it would be still interesting to have
> > a "backup" capability at hand, like a "dd" of the
> > superblock to some secure file.
> 
> "mdadm -E" would probably be enough - just write a cron job :-)

actually, I was thinking "dd" because a restore
operation could be another "dd" (from file to device).

Does this make sense? Or old superblocks should
never replace newer ones?

I mean, let's say each day the first few MB of
each component device is stored somewhere.
As soon as some irreparable damage happens, the
files can be restored in the proper devices.
Practically rolling back to the previous day
the superblock status.

Would this work?

Thanks,

bye,

-- 

piergiorgio
