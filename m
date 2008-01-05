From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: On the subject of RAID-6 corruption recovery
Date: Fri, 04 Jan 2008 16:45:21 -0800
Message-ID: <477ED321.6000708@zytor.com>
References: <4774663C.5090609@zytor.com>    <59840.88.217.65.202.1199491167.squirrel@www.e18.physik.tu-muenchen.de>    <477EC96D.80505@zytor.com> <51481.88.217.65.202.1199493668.squirrel@www.e18.physik.tu-muenchen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51481.88.217.65.202.1199493668.squirrel@www.e18.physik.tu-muenchen.de>
Sender: linux-raid-owner@vger.kernel.org
To: Thiemo Nagel <thiemo.nagel@ph.tum.de>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Thiemo Nagel wrote:
>>> For errors occurring on the level of hard disk blocks (signature: most
>>> bytes of the block have D errors, all with same z), the probability for
>>> multidisc corruption to go undetected is ((n-1)/256)**512.  This might
>>> pose a problem in the limiting case of n=255, however for practical
>>> applications, this probability is negligible as it drops off
>>> exponentially with decreasing n:
>>>
>> That assumes fully random data distribution, which is almost certainly a
>> false assumption.
> 
> Agreed.  This means, that the formula only serves to specify a lower limit
> to the probability.  However, is there an argumentation, why a pathologic
> case would be probable, i.e. why the probability would be likely to
> *vastly* deviate from the theoretical limit?  And if there is, would that
> argumentation not apply to other raid 6 operations (like "check") also? 
> And would it help to use different Galois field generators at different
> positions in a sector instead of using a uniform generator?
> 

What you call "pathologic" cases when it comes to real-world data are 
very common.  It is not at all unusual to find sectors filled with only 
a constant (usually zero, but not always), in which case your **512 
becomes **1.

It doesn't mean it's not worthwhile, but don't try to claim it is 
anything other than opportunistic.

	-hpa
