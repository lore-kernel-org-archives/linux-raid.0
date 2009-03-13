From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Raid6 write performance
Date: Fri, 13 Mar 2009 13:11:47 -0400
Message-ID: <49BA93D3.9070700@tmr.com>
References: <49742E74.9090502@rabbit.us> <49A88DB4.40008@zytor.com> <49AADFCA.2060406@rabbit.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <49AADFCA.2060406@rabbit.us>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Rabbitson <rabbit+list@rabbit.us>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Peter Rabbitson wrote:
> H. Peter Anvin wrote:
>   
>> Peter Rabbitson wrote:
>>     
>>> Hi,
>>>
>>> I am experimenting with raid6 on 4 drives on 2.6.27.11. The problem I am
>>> having is that no matter what chunk size I use, the write benchmark
>>> always comes out at single drive speed, although I should be seeing
>>> double drive speed (read speed is at near 4x as expected).
>>>       
>> I have no idea why you "should" be seeing double drive speed.  All
>> drives have to be written, so you'd logically see single drive speed.
>>
>>     
>
> Because with properly adjusted elevators and chunk sizes it is reasonable
> to expect N * S write speed from _any_ raid, where N is the number of
> different data bearing disks in a stripe, and S is the speed of a hard
> drive (assuming the drive speeds are equal). So for raid5 we have N =
> numdisks-1, for raid6 numdisks-2, for raid10 -n4 -pf3 we get 4-(3-1) and
> so on. I have personally verified the write behavior for raid10 and raid5,
> don't see why it should/would be different for raid6.
>   

That's a lovely theory, but in practice I have to say I have never 
measured any such thing, using benchmarks intended to match real world, 
or even heavy disk writes of a dumb nature like dd. I have tested 
through the raw device, and through filesystems, tuned stripe-cache-size 
and buffers, tried setting "stride" in ext3, all to conclude that with 
raid5 I see essentially write speed of 1x a single drive and read speed 
of (N-1)x as you suggest. Actually, looking at results for arrays with 
more drives I can see a trend to write at (N/3)x speed, being a 
seek-write for full chunk data and seef-read-write for XOR. But even on 
six drive arrays I don't get near (N-1)x in measurable.

-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


