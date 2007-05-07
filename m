From: Peter Rabbitson <rabbit@rabbit.us>
Subject: Re: Raid1 replaced with raid10?
Date: Mon, 07 May 2007 09:02:51 +0200
Message-ID: <463ECF1B.7000007@rabbit.us>
References: <45FF1BDF.6060304@rabbit.us>	<463B2D15.7020305@rabbit.us>	<463B4C4F.9030504@tmr.com>	<17982.42974.461499.127486@notabene.brown>	<463ECBF5.7030206@rabbit.us> <17982.52772.893500.146509@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17982.52772.893500.146509@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> On Monday May 7, rabbit@rabbit.us wrote:
>> Neil Brown wrote:
>>> On Friday May 4, davidsen@tmr.com wrote:
>>>> Peter Rabbitson wrote:
>>>>> Hi,
>>>>>
>>>>> I asked this question back in march but received no answers, so here it
>>>>> goes again. Is it safe to replace raid1 with raid10 where the amount of
>>>>> disks is equal to the amount of far/near/offset copies? I understand it
>>>>> has the downside of not being a bit-by-bit mirror of a plain filesystem.
>>>>> Are there any other caveats?
>>>>>   
>>> To answer the original question, I assume you mean "replace" as in
>>> "backup, create new array, then restore".
>>> You will get different performance characteristics.  Whether they
>>> better suit your needs or not will depend largely on your needs.
>> Hi Neil,
>> Yes I meant take an existing 2 drive raid1 array (non bootable data) and
>> put a raid10 array in its place. All my testing indicates that I get the
>> same write performance but nearly double the read speed (due to
>> interleaving I guess). It seemed to good to be true, thus I am asking
>> the question. Could you elaborate on your last sentence? Are there
>> downsides I could not think of? Thank you!
> 
> I would have thought that you need "far" or "offset" to improve read
> performance, and they tend to hurt write performance (though I haven't
> really measured "offset" much).
> 
> What layout are you using?
> 

Correct, I am using 'far' layout. The interleaving of the 'offset'
layout does not work too good for sequential reads, but far really
shines. Yes write performance is hurt by about 10%. Compared to 190%
gain in reads I can live with it.
