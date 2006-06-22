From: Chris Allen <chris@photobox.co.uk>
Subject: Re: Large single raid and XFS or two small ones and EXT3?
Date: Thu, 22 Jun 2006 21:00:59 +0100
Message-ID: <449AF6FB.4010809@photobox.co.uk>
References: <449AEB7C.6040108@cjx.com> <Pine.LNX.4.56.0606222014210.21158@lion.drogon.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.56.0606222014210.21158@lion.drogon.net>
Sender: linux-raid-owner@vger.kernel.org
To: Gordon Henderson <gordon@drogon.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



Gordon Henderson wrote:
> On Thu, 22 Jun 2006, Chris Allen wrote:
>
>   
>> Dear All,
>>
>> I have a Linux storage server containing 16x750GB drives - so 12TB raw
>> space.
>>     
>
> Just one thing - Do you want to use RAID-5 or RAID-6 ?
>
> I just ask, as with that many drives (and that much data!) the
> possibilities of a 2nd drive failure is increasing, and personally,
> wherever I can, I take the hit these days, and have used RAID-6 for
> some time... drives are cheap, even the 750GB behemoths!
>
>   

Each of these boxes has an equivalent mirror box - so I'm happy with using
raid5 for the time being.
