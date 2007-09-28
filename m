From: "Dean S. Messing" <deanm@sharplabs.com>
Subject: Re: Help: very slow software RAID 5.
Date: Fri, 28 Sep 2007 16:21:46 -0700 (PDT)
Message-ID: <20070928232146.E6611102F5B@medulla.enet.sharplabs.com>
References: <20070918230914.9FF5910215F@medulla.enet.sharplabs.com>	<Pine.LNX.4.64.0709182004210.13217@p34.internal.lan>	<20070919014919.DF19D10215F@medulla.enet.sharplabs.com>	<Pine.LNX.4.64.0709190437050.4411@p34.internal.lan>	<20070919174956.9497310209D@medulla.enet.sharplabs.com>	<46F292E2.1090700@tmr.com>	<20070920184738.441FD10208C@medulla.enet.sharplabs.com>	<46F2E159.9030806@msgid.tls.msk.ru>	<20070921005851.44E8910236D@medulla.enet.sharplabs.com> <87r6knay66.fsf@informatik.uni-tuebingen.de> <20070925181618.82F47102162@medulla.enet.sharplabs.com> <46FC2C09.3010107@tmr.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <46FC2C09.3010107@tmr.com> (message from Bill Davidsen on Thu, 27
	Sep 2007 18:17:45 -0400)
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, brederlo@informatik.uni-tuebingen.de
List-Id: linux-raid.ids


: Dean S. Messing wrote:
: > I have also discovered "smartctl" and have read that if the short smartctl
: > tests are run daily and the long test weekly that the chances of being
: > caught "with my pants down" are quite low, even in a two disk RAID-0
: > config.  What is your opinion?
: >   
: 
: There's a good paper on using smartctl to predict the health of disks, 
: and if you can't find it I probably have a copy somewhere, since I gave 
: a presentation on RAID issues which included it. But the basic premise 
: was that if you see errors of certain types, the drives are likely to 
: fail soon. It did *not* say that absent these warnings the drives were 
: unlikely to fail, un fact most drives which did fail did so without 
: warning. So for about 90% of the failures there is no warning.
: 
: I had servers a few years ago, running 6TB/server, on lots of small fast 
: drives, and I concluded that the predictive value of SMART was so small 
: that it didn't justify looking at the reports. Take that as my opinion, 
: assume that drives fail without warning.

From what you and another poster said (about the False Alarm rate of
Smartctl) I'll put my trust in backups, alone.  I agree: if it
predicts such a low % of failures, there's no point to waste time
reading the reports and having a false sense of security.

: I'm getting around to replying to several things you have said in 
: various posts, so that people who are threading answers will be happy...

I'll look forward to your comments, especially on my misconceptions.
I've learned a great deal already.

Dean


