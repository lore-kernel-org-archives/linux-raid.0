From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Large single raid and XFS or two small ones and EXT3?
Date: Thu, 22 Jun 2006 12:23:50 -0700
Message-ID: <449AEE46.6050408@zytor.com>
References: <449AEB7C.6040108@cjx.com> <Pine.LNX.4.56.0606222014210.21158@lion.drogon.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.56.0606222014210.21158@lion.drogon.net>
Sender: linux-raid-owner@vger.kernel.org
To: Gordon Henderson <gordon@drogon.net>
Cc: Chris Allen <chris@cjx.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Gordon Henderson wrote:
> On Thu, 22 Jun 2006, Chris Allen wrote:
> 
>> Dear All,
>>
>> I have a Linux storage server containing 16x750GB drives - so 12TB raw
>> space.
> 
> Just one thing - Do you want to use RAID-5 or RAID-6 ?
> 
> I just ask, as with that many drives (and that much data!) the
> possibilities of a 2nd drive failure is increasing, and personally,
> wherever I can, I take the hit these days, and have used RAID-6 for
> some time... drives are cheap, even the 750GB behemoths!
> 
>> If I make them into a single RAID5 array, then it appears my only
>> choice for a filesystem is XFS - as  EXT3 won't really handle partitions
>> over 8TB.
> 
> I can't help with this though - I didn't realise ext3 had such a
> limitation though!
> 

16 TB (2^32 blocks) should be the right number.

	-hpa

