From: Per Andreas Buer <perbu@linpro.no>
Subject: Re: poor performance with raid1 / raid0
Date: 18 Jun 2003 16:00:43 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <PERBUMSGID-ul63ci7trhw.fsf@ipchains.linpro.no>
References: <PERBUMSGID-ul6fzm7tvl3.fsf@ipchains.linpro.no>
	<1055943743.31927.20.camel@cinshrlnxws01.shermfin.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1055943743.31927.20.camel@cinshrlnxws01.shermfin.com>
To: Andrew Rechenberg <arechenberg@shermfin.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Andrew Rechenberg <arechenberg@shermfin.com> writes:

> Check /proc/sys/dev/raid/speed_limit_[min|max].  If they are set too low
> then your re-mirror will behave as such.  To change just echo a new
> value:
> 
> echo 30000 > /proc/sys/dev/raid/speed_limit_min
> echo 50000 > /proc/sys/dev/raid/speed_limit_max
> 

I did so - and now:

md6 : active raid1 md16[2] sdd6[0]
      117185984 blocks [2/1] [U_]
      [>....................]  recovery =  0.1% (229120/117185984)
finish=59.5min speed=32731K/sec

:D

Thanks.

-- 
There are only 10 different kinds of people in the world, 
those who understand binary, and those who don't.
