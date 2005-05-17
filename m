From: ptb@lab.it.uc3m.es (Peter T. Breuer)
Subject: Re: Raid 1 install revealed poor HD performance (I think)
Date: Wed, 18 May 2005 00:45:18 +0200
Message-ID: <uo8ql2-h0k.ln1@news.it.uc3m.es>
References: <428A09A3.9000802@heyjay.com> <Pine.LNX.4.56.0505171649090.32621@lion.drogon.net> <428A1924.8030801@heyjay.com> <Pine.LNX.4.56.0505171720070.32621@lion.drogon.net> <428A2133.4080202@h3c.com> <428A594E.5080207@heyjay.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Jay Strauss <me@heyjay.com> wrote:
> > Either way, one of the first things I typically do on a server is add an
> > hdparm line with whatever the disks need for that particular machine.

> I don't understand the above "whatever the disks need" portion of this 
> statement.  Can you give me a little more detail?

He means that you set them up the way you want to.  Use hdparm.  -i or
-I or -v should show you what modes they are in now.  Pay particular
attention to the dma mode.

> What settings am I to force?  And to what values?  I guess I'm asking, 

Whatever you like, and whatever turns out to be best.

Peter

