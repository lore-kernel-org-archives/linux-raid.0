From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: Unbelievably _good_ write performance: RHEL5.4 mirror
Date: Wed, 04 Nov 2009 15:40:47 +0300
Message-ID: <4AF1764F.20302@msgid.tls.msk.ru>
References: <f3177b9e0911021028t1fea4ad2lb4cf87059d300a0c@mail.gmail.com>	 <921ca19c0911030437s4ba6b2d9l24fe4d2c83029e9b@mail.gmail.com>	 <4877c76c0911030831q2ca99007lf3b9068de6be48b@mail.gmail.com>	 <f3177b9e0911031129g2e0026f6s65275b8f684438f4@mail.gmail.com>	 <4877c76c0911031611h3572851avaed9870795db3d92@mail.gmail.com>	 <f3177b9e0911031621p29c390e4xc5017001a38046ff@mail.gmail.com> <4877c76c0911031629n580dc25ay7e47990908b056e7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4877c76c0911031629n580dc25ay7e47990908b056e7@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Evans <mjevans1983@gmail.com>
Cc: Chris Worley <worleys@gmail.com>, Sujit K M <sjt.kar@gmail.com>, linuxraid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Michael Evans wrote:
>> So, you're saying that the MD layer is doing it's own buffering?  Are
>> you sure?  With the system cache disabled and the drive (and block
>> device driver) cache disabled, there should be no reason to require
>> synchronous I/O, unless, as you suggest, the MD layer is broken.
>>
>> You're saying that both O_DIRECT and O_SYNC must be used to disable
>> cache effects. Why then are there two separate flags and not just one?
>>  Synchronous is a very different behavior that is not necessary for
>> this test and put additional requirements that are not needed for this
>> test.
>>
>> Chris
>>
> 
> Reading the manual page it seems O_DIRECT explicitly minimizes any
> attempts at extra copying; not explicitly disabling buffers, merely
> not adding more.  In another mail thread this tweak-able was
> discussed:
> 
> echo 0 > /sys/block/md*/md/stripe_cache_size

stripe_cache_size only exists for raid4, raid5 and raid6.
It never existed for other raid levels because it's pointless.

/mjt
