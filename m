From: Albert Pauw <albert.pauw@gmail.com>
Subject: Re: Bugreport ddf rebuild problems
Date: Sat, 03 Aug 2013 11:43:23 +0200
Message-ID: <51FCD0BB.1040402@gmail.com>
References: <51FAB74B.4030200@gmail.com>	<51FAB282.6040303@arcor.de> <CAGkViCFT0+qm9YAnAJM7JGgVg0RTJi8=HAYDTMs-mfhXinqdcg@mail.gmail.com> <51FACF7C.50400@arcor.de> <51FADCA5.1080801@arcor.de> <51FAE319.6030604@arcor.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51FAE319.6030604@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: Martin Wilck <mwilck@arcor.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Martin,

I can confirm that patch 3/4 indeed fixed the problem.

Thanks for your quick fix.

Kind regards,

Albert

On 08/02/2013 12:37 AM, Martin Wilck wrote:
> Hi Albert,
>
> On 08/02/2013 12:09 AM, Martin Wilck wrote:
>> On 08/01/2013 11:13 PM, Martin Wilck wrote:
>>> Can you please try the attached patch?
>> DON'T use it, it's broken. I will send a better one in a minute.
> My latest patch series should fix this. The fix for your problem is 3/4,
> and I added your test case as 4/4. Retest is welcome.
>
> Martin
>
>>
>>> Regards,
>>> Martin
>>>
>>>



