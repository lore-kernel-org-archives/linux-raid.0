From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: calc. of currspeed in md.c code in 2.4.20
Date: Wed, 14 May 2003 21:47:19 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16066.11463.895289.232053@notabene.cse.unsw.edu.au>
References: <200305140833.h4E8X5P00764@oboe.it.uc3m.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Peter T. Breuer on Wednesday May 14
To: ptb@it.uc3m.es
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday May 14, ptb@it.uc3m.es wrote:
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
> 
> Peter

HZ == jiffies/second

so jiffies / HZ == jiffies / (jiffies/seconds) == seconds.

NeilBrown
