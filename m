From: Jools Wills <jools@oxfordinspire.co.uk>
Subject: Re: messed up changing chunk size
Date: Mon, 19 Jul 2010 14:24:12 +0100
Message-ID: <4C4451FC.30505@oxfordinspire.co.uk>
References: <4C439D19.4070906@gmail.com> <20100719095351.4536a252@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100719095351.4536a252@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <roman@rm.pp.ru>
Cc: Konstantin Svist <fry.kun@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 19/07/10 04:53, Roman Mamedov wrote:
> On Sun, 18 Jul 2010 17:32:25 -0700
> Konstantin Svist<fry.kun@gmail.com>  wrote:
>
>> I looked around and found that chunk size
>> of 512 should work better.
>
> Not true, at least with RAID5/6 a chunk size of 64K performs faster, see
> http://louwrentius.blogspot.com/2010/05/raid-level-and-chunk-size-benchmarks.html
> http://alephnull.com/benchmarks/sata2009/chunksize.html

There is no mention in this benchmark tests if he modified the stripe 
cache. With an increased stripe size a larger stripe cache would be 
needed for good performance (at least from my experience)

Best Regards

Jools
