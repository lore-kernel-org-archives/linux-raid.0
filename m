From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: reconstruction stalls
Date: Wed, 17 Jul 2002 08:47:55 +1000 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15668.41627.988382.451061@notabene.cse.unsw.edu.au>
References: <Pine.LNX.4.33.0207161515560.29547-100000@pandora.is.bizsystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Michael Robinton on Tuesday July 16
To: Michael Robinton <michael@bizsystems.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday July 16, michael@bizsystems.com wrote:
> i86 2.4.17 kernel
> 2 - 1de 20 gig western digital drives on separate channels (ASUS-me99)
> There are several raid partitions on this drive, one managed to get out of
> sync when the cpu failed. The ext2 file system is fine but the arrray will
> not reconstruct -- I have 7 linux boxes running various flavors or raid 1
> and 5 for several years, and this is the first time I've seen anything
> like this.
> 
> The reconstruction proceeds until /proc/mdstat says 99.9% complete
> (2015872,2015936) finish 0.0 min
> then the speed keeps going down with each successive query. There is no
> disk activity per the "red" light. Tried this twice with identical results
> each time.
> 
> Any suggestions??

Sounds like a bug that was fixed recently...
It may be that you just need to encourage some other disc activity on
that system and it will spring to life and finish.

NeilBrown

> 
> Michael
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
