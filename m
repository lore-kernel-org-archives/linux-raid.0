From: Peter Rabbitson <rabbit+list@rabbit.us>
Subject: Re: Raid6 write performance
Date: Sun, 01 Mar 2009 20:19:38 +0100
Message-ID: <49AADFCA.2060406@rabbit.us>
References: <49742E74.9090502@rabbit.us> <49A88DB4.40008@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <49A88DB4.40008@zytor.com>
Sender: linux-raid-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

H. Peter Anvin wrote:
> Peter Rabbitson wrote:
>> Hi,
>>
>> I am experimenting with raid6 on 4 drives on 2.6.27.11. The problem I am
>> having is that no matter what chunk size I use, the write benchmark
>> always comes out at single drive speed, although I should be seeing
>> double drive speed (read speed is at near 4x as expected).
> 
> I have no idea why you "should" be seeing double drive speed.  All
> drives have to be written, so you'd logically see single drive speed.
> 

Because with properly adjusted elevators and chunk sizes it is reasonable
to expect N * S write speed from _any_ raid, where N is the number of
different data bearing disks in a stripe, and S is the speed of a hard
drive (assuming the drive speeds are equal). So for raid5 we have N =
numdisks-1, for raid6 numdisks-2, for raid10 -n4 -pf3 we get 4-(3-1) and
so on. I have personally verified the write behavior for raid10 and raid5,
don't see why it should/would be different for raid6.

In any case the witnessed problem was due to a hardware misconfiguration,
which has not been resolved to this day. Thus thread is dead :)
