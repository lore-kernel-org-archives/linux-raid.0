From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: slow raid5 performance kernel 2.6 vs 2.4
Date: Tue, 14 Dec 2004 15:49:05 +1100
Message-ID: <16830.28865.842641.822948@cse.unsw.edu.au>
References: <20041212211330.M51235-100000@xs3.xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from ddx on Sunday December 12
Sender: linux-raid-owner@vger.kernel.org
To: ddx <ddx@xs4all.nl>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday December 12, ddx@xs4all.nl wrote:
> Hi,
> 
> system :
> 
> P4 2.4GHz HT, 1GB DDR
> 8*  S-ATA 250GB Hitachi on 2 Si3114 controllers
> 
> bonnie performance with 2.4 :
> block input 126MB/sec
> 
> with 2.6 :
> block input 90MB/sec
> 
> saw another posting about slow read performance with raid5 and 2.6
> any ideas yet how to fix this ?
> 

Not yet.  I've been doing some testing which you can read about at
    http://neilb.web.cse.unsw.edu.au/~neilb/01102979338

I only get a drop from about 250 to 220 on my hardware, which still
isn't good.
I've got a few ideas but I'm not sure when I will have a chance to
follow through with them.  I'm doing a bit more testing first to make
sure I have a complete picture.

NeilBrown

> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
