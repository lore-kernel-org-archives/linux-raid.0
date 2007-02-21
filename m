From: Neil Brown <neilb@suse.de>
Subject: Re: Reshaping raid0/10
Date: Thu, 22 Feb 2007 06:59:38 +1100
Message-ID: <17884.42154.248251.261955@notabene.brown>
References: <Pine.LNX.4.61.0702211726500.12039@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Jan Engelhardt on Wednesday February 21
Sender: linux-raid-owner@vger.kernel.org
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday February 21, jengelh@linux01.gwdg.de wrote:
> Hello,
> 
> 
> 
> are there any plans to support reshaping
> on raid0 and raid10?
> 

No concrete plans.  It largely depends on time and motivation.
I expect that the various flavours of raid5/raid6 reshape will come
first.
Then probably converting raid0->raid5.

I really haven't given any thought to how you might reshape a
raid10...

NeilBrown
