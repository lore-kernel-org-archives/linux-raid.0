From: Mike Hardy <mhardy@h3c.com>
Subject: Re: Raid 1 install revealed poor HD performance (I think)
Date: Tue, 17 May 2005 13:54:17 -0700
Message-ID: <428A59F9.5050908@h3c.com>
References: <428A09A3.9000802@heyjay.com> <Pine.LNX.4.56.0505171649090.32621@lion.drogon.net> <428A1924.8030801@heyjay.com> <Pine.LNX.4.56.0505171720070.32621@lion.drogon.net> <428A2133.4080202@h3c.com> <428A594E.5080207@heyjay.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <428A594E.5080207@heyjay.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jay Strauss <me@heyjay.com>
Cc: Gordon Henderson <gordon@drogon.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



Jay Strauss wrote:

> I don't understand the above "whatever the disks need" portion of this
> statement.  Can you give me a little more detail?

I did mean the hdparm settings, sorry I wasn't clearer

> What settings am I to force?  And to what values?  I guess I'm asking,
> are you saying just put the hdparm setting in a rc.local?  If so, I'm
> still stumped on what those settings need to be

Well, the "typical" problem with regard to speed is DMA detection on
your IDE chipset, which Gordon guessed (and which I would have). That
needs to be set sometimes.

I usually also set write-caching to off, although this does have a
performance impact. Its also possible to twiddle some of the other
hdparm settings, though these may or may not help. Things like
multicount, IRQ unmasking.

You can try any of them, then run bonnie++ or similar and see if they
have an effect, and put them in rc.local (or similar) to make sure they
stay in force across reboots.

That's fine-grained tuning mostly though, and not really on topic for
you as it appears you have something entirely different going on. What
exactly is going on, I must admit, I don't know. :-/

-Mike
