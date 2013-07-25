From: Roberto Spadim <rspadim@gmail.com>
Subject: Re: Help creating filesystem (xfs) and partitioning
Date: Thu, 25 Jul 2013 19:36:23 -0300
Message-ID: <CAH3kUhEMtauLoymUL7k8s==4NtvX=CRzOJhhtfL2EdJzYygd+A@mail.gmail.com>
References: <CAH3kUhFqX5fB0=eYbECxrR_52Yv3_v5oodG=6Z-8L_gcTwiC4Q@mail.gmail.com>
	<51F19E0F.5000400@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51F19E0F.5000400@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> I don't think this is a bad choice, although the 3.10 may be a bit faster
> for many CPU bound processes, even if only for ms at a time. If you like it
> better it's a good choice.
i will use xeon e3 1220v2 (without hyper thread), there's a 'dummy'
list of cpu/schedulers improvements?


> Other people have mentioned not using two filesystems to prevent thrashing
> and head motion, The only thing in root which changes a lot are logs, and
> then only when comthing log generating is running. Certainly http, nntp, and
> mail servers qualify. Unless you see some reason I missed, joining all the
> root and home in one filesystem will probably be a win over having two.
ok i think quotas is nice, what about changing /boot / and /home, to
only one partition? instead of 3 partitions?


> I note the lack of raid10, particularly raid10 with -f2 (far two) layout. In
> general that is going to be faster than raid1, and equally robust. You ran a
> lot of benchmarks, one more would config your choice or give you a better
> option.
hum i tested the system in raid10 and it runs slower with far and near
layout, i think that it have many read in non consecutive blocks ,
that make far layout bad
raid1 runs nice without problem and read aren't fast but they are
intensive (many files reads instead of many information in one file)


> Then you can play with hardware and software readahead, stride, all the
> write{back,thru,etc} options xfs may provide. Frankly, if you want good disk
> performance, the most time effective thing you can do is add more drives to
> spread the head motion and do more parallel i/o. With only two drives and
> raid1 you are limited to the transfer rate of the slowest drive and
> sequential seeks. with more spindles you start to do things in parallel, use
> the outer part of the drive for faster transfer, etc. What you have has a
> low theoretical max which you can beat without tuning using more disk and
> raid10.
no problem, a single disk works for the system, raid1 is for security,
maybe a bcache or another ssd+hdd cache could allow a better
performace, but i don't think i will need it
i don't know what's the best xfs parameters / fdisk parameters to
align disk with filesystem, should i add some parameter?


>> What more information should i share?
> Write size. The will effect your chunk size choices. I don't know what xfs
> gives you in control of favoring writes of a given size, ext4 does let you
> provide information to the kernel in extended options, which can be useful.
> In my experience more so when doing a series of sequential small writes
> (more than a chunk total, not huge) than a ton of small scattered writes,
> just mentioning things you can evaluate, since you have put a lot of work
> into test already.
well write mean size is something near to 4kb or 1kb, with some big
writes (1mb) when using a big commit or something like it in innodb
tables


thanks Bill!
any other idea is wellcome too =)

-- 
Roberto Spadim
