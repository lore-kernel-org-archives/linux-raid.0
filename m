From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: "Missing" RAID devices
Date: Thu, 23 May 2013 22:45:56 -0500
Message-ID: <519EE274.5030905@hardwarefreak.com>
References: <CAGPLN=viGgdw0MM18tiNxwjNadg0cj8xjntW3ne1qMNkfgocaA@mail.gmail.com> <519B9351.4050708@turmel.org> <CAGPLN=uiUD3wnwt6DfELaLh+yqxkbrA=KetPiQHZrqq4FrS=HA@mail.gmail.com> <519C0B13.3040906@turmel.org> <519D4A15.7020107@hardwarefreak.com> <519D541B.1090508@turmel.org> <519DB04B.5030505@hardwarefreak.com> <20130523083032.GA2579@www5.open-std.org>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130523083032.GA2579@www5.open-std.org>
Sender: linux-raid-owner@vger.kernel.org
To: keld@keldix.com
Cc: Phil Turmel <philip@turmel.org>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 5/23/2013 3:30 AM, keld@keldix.com wrote:
> On Thu, May 23, 2013 at 12:59:39AM -0500, Stan Hoeppner wrote:

>> You may be tempted to use md/RAID10 of some layout
>> to optimize for writes, but you'd gain nothing, and you'd lose some
>> performance due to overhead.  The partitions you'll be using in this
>> case are so small that they easily fit in a single physical disk track,
>> thus no head movement is required to seek between sectors, only rotation
>> of the platter.
...
> I think a raid10,far3 is a good choice for swap, then you will enjoy
> RAID0-like reading speed. and good write speed (compared to raid6),
> and a chance of live surviving if just one drive keeps functioning.

As I mention above, none of the md/RAID10 layouts will yield any added
performance benefit for swap partitions.  And I state the reason why.
If you think about this for a moment you should reach the same conclusion.

-- 
Stan

