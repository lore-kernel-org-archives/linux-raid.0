From: Jordan Russell <jr-list-2010@quo.to>
Subject: Re: Data-check brings system to a standstill
Date: Fri, 18 Jun 2010 11:54:54 -0500
Message-ID: <4C1BA4DE.70701@quo.to>
References: <4C0FCFCD.4070201@quo.to> <4C19015B.3020807@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4C19015B.3020807@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 6/16/2010 11:52 AM, Bill Davidsen wrote:
> Not sure what's causing that, other than you just have your max set
> pretty high for raid1.

200000 is just the default.

> By leaving nothing in the way of capacity for
> system operation you are filling all of memory with writes to the
> resyncing drive. I would measure the speed of the disk read on the inner
> tracks (dd with offset from sda to /dev/null) and not set max over 2/3
> of that.

The outer tracks measure about 65000 KB/sec, and the inner tracks about
35000 KB/sec.

The problem I have with just setting sync_speed_max to a fixed, low
value like 30000 prior to starting the data-check is it needlessly slows
down the reading of the outer tracks, causing the check to take an extra
hour or so to complete.

I would prefer to see md use as much bandwidth as possible, but pause
whenever any I/O requests come in. This appears to be what the code is
designed to do -- and the log says "idle IO bandwidth" -- but given that
tasks are routinely hanging for 120+ seconds, it doesn't seem to be
working in my case.

> Alternatively, you can try setting your io scheduler to
> deadline,

Interesting idea. I'll give that a try and report back.

> I think md would benefit from a limit on how much io can be outstanding
> to any given device, but that would be a non-trivial change, I fear.

Perhaps an option to force msleep()s at regular intervals (e.g., every
50 MB) would help...

-- 
Jordan Russell
