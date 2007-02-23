From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: Reshaping raid0/10
Date: Fri, 23 Feb 2007 13:59:04 +0100 (MET)
Message-ID: <Pine.LNX.4.61.0702231357420.9736@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0702211726500.12039@yvahk01.tjqt.qr>
 <17884.42154.248251.261955@notabene.brown>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17884.42154.248251.261955@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On Feb 22 2007 06:59, Neil Brown wrote:
>On Wednesday February 21, jengelh@linux01.gwdg.de wrote:
>> 
>> are there any plans to support reshaping
>> on raid0 and raid10?
>> 
>
>No concrete plans.  It largely depends on time and motivation.
>I expect that the various flavours of raid5/raid6 reshape will come
>first.
>Then probably converting raid0->raid5.
>
>I really haven't given any thought to how you might reshape a
>raid10...

It should not be any different from raid0/raid5 reshaping, should it?



Jan
-- 
