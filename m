From: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
Subject: Re: [PATCH] md: new bitmap sysfs interface
Date: Thu, 3 Aug 2006 08:39:35 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0608030838060.2068@filesrv1.baby-dragons.com>
References: <44C5BA6F.3010404@steeleye.com> <17617.21634.568180.436250@cse.unsw.edu.au>
 <44D1A4AC.3090302@dgreaves.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <44D1A4AC.3090302@dgreaves.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Greaves <david@dgreaves.com>
Cc: Neil Brown <neilb@suse.de>, Paul Clements <paul.clements@steeleye.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

 	Hello All ,

On Thu, 3 Aug 2006, David Greaves wrote:
> Neil Brown wrote:
>>   write-bits-here-to-dirty-them-in-the-bitmap
>>
>> is probably (no, definitely) too verbose.
>> Any better suggestions?
>
> It's not actually a bitmap is it?
> It takes a number or range and *operates* on a bitmap.
>
> so:
> dirty-chunk-in-bitmap
>
> or maybe:
> dirty-bitmap-chunk
>
> David

 	A thought , maybe  bitmap-dirty-this-chunk   ?

-- 
+----------------------------------------------------------------------+
| James   W.   Laferriere |   System    Techniques   | Give me VMS     |
| Network        Engineer | 3600 14th Ave SE #20-103 |  Give me Linux  |
| babydr@baby-dragons.com |  Olympia ,  WA.   98501  |   only  on  AXP |
+----------------------------------------------------------------------+
