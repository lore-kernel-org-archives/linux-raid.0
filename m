From: Paul Clements <Paul.Clements@SteelEye.com>
Subject: Re: calc. of currspeed in md.c code in 2.4.20
Date: Wed, 14 May 2003 09:48:22 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3EC24926.1D33CAAB@SteelEye.com>
References: <200305140833.h4E8X5P00764@oboe.it.uc3m.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: ptb@it.uc3m.es
Cc: neilb@cse.unsw.edu.au, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

"Peter T. Breuer" wrote:
> 
> Can you shed some light on this for me?
> 
> currspeed =
>  (j-mddev->resync_mark_cnt)/2/((jiffies-mddev->resync_mark)/HZ +1) +1;
> 
> jiffies is divided by HZ here, which results in a quantity of dimension
> time-squared!
> 
> I could understand it (better) if jiffies were multiplied by HZ.

Just curious, but are you looking at this because the speed calculations
break when using a bitmap to resync? I realized this problem a few days
ago, but I'm not sure how to solve it, yet...

I think we might need two counters, one for the actual resync progress
(to display the progress bar, and show actual resync speed) and the
other to throttle I/O if actual I/O becomes too fast...

--
Paul
