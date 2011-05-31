From: CoolCold <coolthecold@gmail.com>
Subject: Re: Storage device enumeration script
Date: Wed, 1 Jun 2011 01:21:16 +0400
Message-ID: <BANLkTimxnJaS0J6ZWLfZUo1GHiahMA+4gQ@mail.gmail.com>
References: <4DDDC301.7090608@turmel.org>
	<BANLkTiky1L9fisPnxMKsceG19LbhxcF0ag@mail.gmail.com>
	<4DDDC750.6040600@turmel.org>
	<BANLkTik-HjxNPGON7ZEwOSKJZOBzeETeAg@mail.gmail.com>
	<4DDE40F7.1090908@turmel.org>
	<4DE538C2.5050504@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DE538C2.5050504@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: simonmcnair@gmail.com
Cc: Phil Turmel <philip@turmel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, May 31, 2011 at 10:51 PM, Simon McNair <simonmcnair@gmail.com> =
wrote:
> Hi Phil,
> Thanks for doing this work off your own back, I'm sure it'll help a l=
ot of
> people.
>
> My 2p would be to ask if you could have a comment at the start of the=
 file
> with the prerequisite applications/packages named it may help the peo=
ple
> that it doesn't work for (initially). =A0The other thing is that the
> virtualbox install of Ubuntu 11.04 that I just completed did not cont=
ain the
> LVM2 package.
There is debian packaging for this tool, checkout
https://github.com/pturmel/lsdrv
You should be able build your package with proper dependencies.


>
> regards
> Simon
>
> On 26/05/2011 13:00, Phil Turmel wrote:
>>
>> On 05/26/2011 04:24 AM, CoolCold wrote:
>> [...]
>>>
>>> On Debian Lenny produces error:
>>> root@gamma2:/tmp# python lsdrv
>>> Traceback (most recent call last):
>>> =A0 File "lsdrv", line 17, in<module>
>>> =A0 =A0 import os, io, re
>>> ImportError: No module named io
>>
>> Huh. =A0The 'io' module is v2.6 and above. =A0Another reason to make=
 a helper
>> function for reading these files.
>>
>> Phil
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message tomajordomo@vger.kernel.org
>> More majordomo info athttp://vger.kernel.org/majordomo-info.html
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Best regards,
[COOLCOLD-RIPN]
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
