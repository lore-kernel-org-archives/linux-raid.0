From: Neil Brown <neilb@suse.de>
Subject: Re: Weird blocks at fsync() calls using md
Date: Fri, 28 Jul 2006 22:08:54 +1000
Message-ID: <17609.65110.567036.457706@cse.unsw.edu.au>
References: <20060728101645.GA32686@freshdot.net>
	<17609.61671.113267.692986@cse.unsw.edu.au>
	<20060728114704.GA2241@freshdot.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Sander Smeenk on Friday July 28
Sender: linux-raid-owner@vger.kernel.org
To: Sander Smeenk <ssmeenk@freshdot.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday July 28, ssmeenk@freshdot.net wrote:
> Quoting Neil Brown (neilb@suse.de):
> 
> > Precisely what evidence do you have?
> 
> I had a nicer strace. With the 30 seconds fsync() call in it. This one
> only took 4 seconds, but that's because only two of us were trying to
> generate enough disk IO to make it happen ;)
> 
> Look here, the read(0, "\r", 250) = 1 is the moment i hit <CR> on the :w
> command to vim.
> 
> 13:28:06.183890 open(".js_gen.pl.swp", O_RDWR|O_CREAT|O_EXCL, 0600) = 4
> 
> 13:28:07.011671 select(1, [0], NULL, [0], {0, 0}) = 0 (Timeout)
> *********
> 13:28:07.011717 fsync(4)                = 0
> 13:28:12.748252 open("js_gen.pl", O_WRONLY|O_CREAT|O_TRUNC, 0770) = 3
> *********
> 13:28:12.748427 write(3, "#!/usr/bin/perl -w\nuse strict;\nu"..., 2189) = 2189
> 13:28:12.748506 fsync(3)                = 0
> 13:28:13.006702 close(3)                = 0

Yes, it's weird.  The sync of the .swp file takes a lot longer than
the fsync of the actual file you are saving....

I have this theory that there might be some odd interaction between md
and the drive scheduler.
Can you try

  echo cfq > /sys/block/sdb/queue/scheduler
  echo cfq > /sys/block/sdc/queue/scheduler

and try again.

Maybe also try 'deadline' instead of 'cfq'.

Let me know what the results are.

Thanks,
NeilBrown
