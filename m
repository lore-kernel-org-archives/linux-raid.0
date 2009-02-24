From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: RAID-10 unbalanced reads
Date: Tue, 24 Feb 2009 20:16:04 +0100
Message-ID: <20090224191604.GA3470@lazy.lzy>
References: <20090209202728.GA11996@lazy.lzy> <20090209231138.GB13450@rap.rap.dk> <20090223221532.GA23542@lazy.lzy> <20090223225202.GA28505@rap.rap.dk> <20090223232415.GA24493@lazy.lzy> <20090224090034.GA8051@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090224090034.GA8051@rap.rap.dk>
Sender: linux-raid-owner@vger.kernel.org
To: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Cc: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

> The boot partition is most likely a raid1 partition, which is quite

yep, it is.

> Depends on how you measure things. It could be that sdb2 has delivered
> some blocks that md1 did not use, and thus did not register as read.

OK, good to know.
 
> Are these numbers taken like just after a boot?

No, after some usage.
And this makes me doubt of myself.
Maybe I started something which was causing this.

> Activity on /boot indicates this. You seldomly use /boot after booting.
> If so, it is a bit interesting that you have about 1/3 of the IO done in
> writing. Why is there so much wroting? I thought that booting was 
> almost only reading.

I think /boot was OK, it is on /dev/sd[ab]1, not
so many writes.
 
> > The only thing that *could* do something on the
> > raw devices is "smartd", I cannot think anything
> > else. Maybe I will disable it, for now...
> 
> I think that would be a good idea for your testing.

I'll try to enable/disable "special" services and see.

If I can reproduce clearly the issue, I'll come back.
Hope not...

Thanks again for your support,

bye,

-- 

piergiorgio
