From: "Rob Bray" <raid@bymeinc.com>
Subject: Re: Interesting RAID checking observations
Date: Thu, 21 Sep 2006 14:55:26 -0400 (EDT)
Message-ID: <57360.192.168.0.1.1158864926.squirrel@bymeinc.com>
References: <20060921065808.19682.qmail@science.horizon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20060921065808.19682.qmail@science.horizon.com>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid@vger.kernel.org, linux@horizon.com
List-Id: linux-raid.ids

> Just to follow up my speed observations last month on a 6x SATA <-> 3x
> PCIe <-> AMD64 system, as of 2.6.18 final, RAID-10 checking is running
> at a reasonable ~156 MB/s (which I presume means 312 MB/s of reads),
> and raid5 is better than the 23 MB/s I complained about earlier, but
> still a bit sluggish...
>
> md5 : active raid5 sdf4[5] sde4[4] sdd4[3] sdc4[2] sdb4[1] sda4[0]
>       1719155200 blocks level 5, 64k chunk, algorithm 2 [6/6] [UUUUUU]
>       [=>...................]  resync =  6.2% (21564928/343831040)
> finish=86.0min speed=62429K/sec
>
> I'm not sure why the raid5 check can't run at 250 MB/s (300 MB/s disk
> speed).  The processor is idle and can do a lot more than that:
>
> raid5: automatically using best checksumming function: generic_sse
>    generic_sse:  6769.000 MB/sec
> raid5: using function: generic_sse (6769.000 MB/sec)
>
>
> But anyway, it's better, so thank you!  I haven't rebooted the celeron
> I hung for the duration of a RAID-1 check, so I haven't checked that with
> 2.6.18 yet.
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Check the I/O performance on the box. I think the "speed" indicator comes
out of calculations to determine how fast a failing drive would be
rebuilt, were you doing a rebuild instead of a check. I like using the
"dstat" tool to get that info at-a-glance
(http://dag.wieers.com/home-made/dstat/).

