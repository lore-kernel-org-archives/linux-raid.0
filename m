From: Jens Axboe <axboe@suse.de>
Subject: Re: Where is the performance bottleneck?
Date: Wed, 31 Aug 2005 19:35:26 +0200
Message-ID: <20050831173525.GJ4018@suse.de>
References: <Pine.LNX.4.61.0508291811480.24072@diagnostix.dwd.de> <20050829202529.GA32214@midnight.suse.cz> <Pine.LNX.4.61.0508301919250.25574@diagnostix.dwd.de> <20050831071126.GA7502@midnight.ucw.cz> <20050831072644.GF4018@suse.de> <Pine.LNX.4.61.0508311029170.16574@diagnostix.dwd.de> <20050831120714.GT4018@suse.de> <Pine.LNX.4.61.0508311339140.16574@diagnostix.dwd.de> <20050831162053.GG4018@suse.de> <Pine.LNX.4.61.0508311648390.16574@diagnostix.dwd.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0508311648390.16574@diagnostix.dwd.de>
Sender: linux-raid-owner@vger.kernel.org
To: Holger Kiehl <Holger.Kiehl@dwd.de>
Cc: Vojtech Pavlik <vojtech@suse.cz>, linux-raid <linux-raid@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, Aug 31 2005, Holger Kiehl wrote:
> ># ./oread /dev/sdX
> >
> >and it will read 128k chunks direct from that device. Run on the same
> >drives as above, reply with the vmstat info again.
> >
> Using kernel 2.6.12.5 again, here the results:

[snip]

Ok, reads as expected, like the buffered io but using less system time.
And you are still 1/3 off the target data rate, hmmm...

With the reads, how does the aggregate bandwidth look when you add
'clients'? Same as with writes, gradually decreasing per-device
throughput?

-- 
Jens Axboe

