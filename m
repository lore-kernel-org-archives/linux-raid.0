From: Bernd Schubert <bernd.schubert@fastmail.fm>
Subject: Re: raid resync speed
Date: Thu, 20 Mar 2014 16:35:24 +0100
Message-ID: <532B0ABC.5040604@fastmail.fm>
References: <CAPrpM6wLpRhMqqsXQ8Baqz4axxj6cvoB2Z1HAOiNm7gPv1FT=w@mail.gmail.com> <532AFCC8.6080902@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <532AFCC8.6080902@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com, Jeff Allison <jeff.allison@allygray.2y.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>
> Yes.  The article gives 16384 and 32768 as examples for
> stripe_cache_size.  Such high values tend to reduce throughput instead
> of increasing it.  Never use a value above 2048 with rust, and 1024 is
> usually optimal for 7.2K drives.  Only go 4096 or higher with SSDs.  In
> addition, high values eat huge amounts of memory.  The formula is:
>

Why should the stripe-cache size differ between SSDs and rotating disks? 
Did you ever try to figure out yourself why it got slower with higher 
values? I profiled that in the past and it was a CPU/memory limitation - 
the md thread went to 100%, searching for stripe-heads.

So I really wonder how you got the impression that the stripe cache size 
should have different values for differnt kinds of drives.


Cheers,
Bernd

