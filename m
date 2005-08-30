From: Holger Kiehl <Holger.Kiehl@dwd.de>
Subject: Re: Where is the performance bottleneck?
Date: Tue, 30 Aug 2005 19:18:52 +0000 (GMT)
Message-ID: <Pine.LNX.4.61.0508301909220.25574@diagnostix.dwd.de>
References: <Pine.LNX.4.61.0508291811480.24072@diagnostix.dwd.de>
 <200508292310.39903.a1426z@gawab.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932394AbVH3TUU@vger.kernel.org>
In-Reply-To: <200508292310.39903.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Al Boldi <a1426z@gawab.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, 29 Aug 2005, Al Boldi wrote:

> Holger Kiehl wrote:
>> Why do I only get 247 MB/s for writting and 227 MB/s for reading (from the
>> bonnie++ results) for a Raid0 over 8 disks? I was expecting to get nearly
>> three times those numbers if you take the numbers from the individual
>> disks.
>>
>> What limit am I hitting here?
>
> You may be hitting a 2.6 kernel bug, which has something to do with
> readahead, ask Jens Axboe about it! (see "[git patches] IDE update" thread)
> Sadly, 2.6.13 did not fix it either.
>
I did read that threat, but due to my limited understanding about kernel
code, don't see the relation to my problem.

But I am willing to try any patches to solve the problem.

> Did you try 2.4.31?
>
No. Will give this a try if the problem is not found.

Thanks,
Holger
