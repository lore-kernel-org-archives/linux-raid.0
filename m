From: Eivind Sarto <eivindsarto@gmail.com>
Subject: Re: raid resync speed
Date: Thu, 20 Mar 2014 09:19:26 -0700
Message-ID: <9A0E06E3-6E0A-46B8-9340-C3C2D8D60B1E@gmail.com>
References: <CAPrpM6wLpRhMqqsXQ8Baqz4axxj6cvoB2Z1HAOiNm7gPv1FT=w@mail.gmail.com> <532AFCC8.6080902@hardwarefreak.com> <532B0ABC.5040604@fastmail.fm> <532B0B04.5030602@fastmail.fm>
Mime-Version: 1.0 (Mac OS X Mail 7.2 \(1874\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <532B0B04.5030602@fastmail.fm>
Sender: linux-raid-owner@vger.kernel.org
To: Bernd Schubert <bernd.schubert@fastmail.fm>
Cc: stan@hardwarefreak.com, Jeff Allison <jeff.allison@allygray.2y.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On Mar 20, 2014, at 8:36 AM, Bernd Schubert <bernd.schubert@fastmail.fm> wrote:

> On 03/20/2014 04:35 PM, Bernd Schubert wrote:
>>> 
>>> Yes.  The article gives 16384 and 32768 as examples for
>>> stripe_cache_size.  Such high values tend to reduce throughput instead
>>> of increasing it.  Never use a value above 2048 with rust, and 1024 is
>>> usually optimal for 7.2K drives.  Only go 4096 or higher with SSDs.  In
>>> addition, high values eat huge amounts of memory.  The formula is:
>>> 
>> 
>> Why should the stripe-cache size differ between SSDs and rotating disks?
>> Did you ever try to figure out yourself why it got slower with higher
>> values? I profiled that in the past and it was a CPU/memory limitation -
>> the md thread went to 100%, searching for stripe-heads.
> 
> Sorry, I forgot to write 'cpu usage', so it went to 100% cpu usage.
> 
>> 
>> So I really wonder how you got the impression that the stripe cache size
>> should have different values for differnt kinds of drives.
>> 
>> 
>> Cheers,
>> Bernd
>> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

The hash chains for the stripe cache become long if you increase the stripe cache.  There are only 256
hash buckets.  With 32K stripe cache entries, the average length of a hash chain will be 128 and that will
increase contention for the lock protection the chain.

-eivind

