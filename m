From: Bar Ziony <bartzy@gmail.com>
Subject: Re: Does mdadm supports TRIM command to SSDs?
Date: Wed, 11 Jul 2012 10:59:25 +0300
Message-ID: <CAF-9Jei-Jv=TrZoJsnc=gqoSasFs40rD99akpwV5Ch7JPwUJ0g@mail.gmail.com>
References: <CAF-9JegPGmayAO0gAsqY4J3rpRpTq_ciLA5e+nu0PsSjJhwr-A@mail.gmail.com>
	<CA+sTkh7+==A7FxM_E-UN1gvLq0qqrojEXOTZwzup4+YG72FQpA@mail.gmail.com>
	<CA+sTkh7CGExOh6gpkv9+7R2nXsMdjyOBA92fN9gPMPZsE=xoRA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CA+sTkh7CGExOh6gpkv9+7R2nXsMdjyOBA92fN9gPMPZsE=xoRA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Igor M Podlesny <for.poige+lsr@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

So does that mean that there's no TRIM support? Because as I
understood, TRIM support was added from 2.6.37. As I'm not familiar
with the code, can someone check some recent version to see if there
is TRIM support?

Thanks,
Bar.


On Wed, Jul 11, 2012 at 4:08 AM, Igor M Podlesny
<for.poige+lsr@gmail.com> wrote:
> On 11 July 2012 08:43, Igor M Podlesny <for.poige+lsr@gmail.com> wrote:
>> On 11 July 2012 06:55, Bar Ziony <bartzy@gmail.com> wrote:
>>> Hi,
>>>
>>> I wasn't able to find any information about it after searching for
>>> hours - Does mdadm supports sending the TRIM command to SSDs, if using
>>> the right filesystem with the 'discard' flag?
>>> If it does support it, from what kernel version it is?
>>
>>    Hi!
>>
>>    https://lkml.org/lkml/2012/3/11/261
>>
>    But those patches don't seem to be accepted though.
>
> --
