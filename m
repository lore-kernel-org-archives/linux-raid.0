From: Andargor The Wise <andargor@yahoo.com>
Subject: Re: First RAID Setup
Date: Thu, 22 Dec 2005 07:00:02 -0800 (PST)
Message-ID: <20051222150002.4421.qmail@web54614.mail.yahoo.com>
References: <43AAB7D1.8090400@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <43AAB7D1.8090400@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: "Callahan, Tom" <CallahanT@tessco.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



--- Bill Davidsen <davidsen@tmr.com> wrote:

> Andargor The Wise wrote:
> 
> >Yet another thing, someone has suggested that I
> should
> >increase the chunk size for my RAID5 from 32 to
> either
> >64 or 128.
> >
> >Is it worth it, considering that the system doesn't
> >normally run on a heavy load? Mail for a few users,
> >some read-only database applications, website, etc.
> >Mostly a development machine.
> >  
> >
> Can't think of a case where it's not worth having
> better performance... 
> I should write a WP on stripe size, and what happens
> as you change it 
> with given loads.
>

If anyone's interested, I ran some benchmarks:

http://www.andargor.com/raid5.html

I'll be spending the time to go to 128k chunks. :)

I was considering raidreconf, and tested it on a
scratch partition. It worked ok, but it was slow (1.17
MB/sec overall). I'll rsync or find -xdev | cpio
-admpv instead to mirror the existing stuff elsewhere
before blowing away the array.


> >Would this alleviate the "pauses" during large file
> >transfers/copies that I have indicated in my
> previous
> >post?
> >
> >I'm asking because backing up ~176 GB,
> reconfiguring
> >the RAID, and restoring it properly so the machine
> >boots (the RAID5 is /) is quite a PITA.
> >
> 
> You may have some special case, but I would never
> put data that large in 
> / just as a system admin issue. It makes backups and
> restores, as well 
> as upgrades quite unpleasant. I guess you may have
> noticed that by now 
> ;-) Good luck!

Concerning the "pause" issue, I believe my problem was
not really a problem at all. The priority isn't on
intreactive traffic (CONFIG_PREEMPT=n), so it was just
a perception of a pause during "ls". If I had real
"pauses" in my IO, I would have seen dismal benchmark
results.

Since I'll be recreating the array anyway, I might as
well split /, /home, and /var into three RAID5's.

Andargor




__________________________________________________
Do You Yahoo!?
Tired of spam?  Yahoo! Mail has the best spam protection around 
http://mail.yahoo.com 
