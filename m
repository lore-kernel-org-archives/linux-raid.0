From: Gordon Henderson <gordon@drogon.net>
Subject: Re: power saving..
Date: Tue, 2 Sep 2003 18:25:26 +0100 (BST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.56.0309021821410.25538@unicorn.drogon.net>
References: <bWpzdHVtcGY=.a755c1b661ea4ce4056611076787574d@1061829354.cotse.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <bWpzdHVtcGY=.a755c1b661ea4ce4056611076787574d@1061829354.cotse.net>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 25 Aug 2003, mjstumpf wrote:

> I have a relatively large (11 drive) server that operates 24/7.
>
> It really doesn't need to, though.  Use is sporadic at best; the purpose
> is mostly archiving.
>
> So what I'm wondering, is do we have auto-spin-down, power save features
> available & STABLE?  This thing sucks down a lot of power, giving me a
> bunch of heat in return :-)

Sorry for a late reply, but I've been on holiday...

I asked something like this a while back and got a positive reply. I've
been using "noflushd" on a small server/firewall for some time with good
results.  It's only a 2-disk RADI-1 system and what I've found is that one
drive is spun-down nearly all of the time, and the other is spun down most
of the time. It onl seems to spin up one disk when it need to read
something thats not in memory. Spin-up time is about 8 seconds (these are
old drives)  and it works very well and runs very cool and mostly quiet.

Gordon
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
On Mon, 25 Aug 2003, mjstumpf wrote:

> I have a relatively large (11 drive) server that operates 24/7.
>
> It really doesn't need to, though.  Use is sporadic at best; the purpose
> is mostly archiving.
>
> So what I'm wondering, is do we have auto-spin-down, power save features
> available & STABLE?  This thing sucks down a lot of power, giving me a
> bunch of heat in return :-)

Sorry for a late reply, but I've been on holiday...

I asked something like this a while back and got a positive reply. I've
been using "noflushd" on a small server/firewall for some time with good
results.  It's only a 2-disk RADI-1 system and what I've found is that one
drive is spun-down nearly all of the time, and the other is spun down most
of the time. It onl seems to spin up one disk when it need to read
something thats not in memory. Spin-up time is about 8 seconds (these are
old drives)  and it works very well and runs very cool and mostly quiet.

Gordon
