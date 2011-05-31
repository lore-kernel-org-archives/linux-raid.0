From: Simon McNair <simonmcnair@gmail.com>
Subject: Re: Storage device enumeration script
Date: Tue, 31 May 2011 19:51:46 +0100
Message-ID: <4DE538C2.5050504@gmail.com>
References: <4DDDC301.7090608@turmel.org>	<BANLkTiky1L9fisPnxMKsceG19LbhxcF0ag@mail.gmail.com>	<4DDDC750.6040600@turmel.org> <BANLkTik-HjxNPGON7ZEwOSKJZOBzeETeAg@mail.gmail.com> <4DDE40F7.1090908@turmel.org>
Reply-To: simonmcnair@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DDE40F7.1090908@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Phil,
Thanks for doing this work off your own back, I'm sure it'll help a lot 
of people.

My 2p would be to ask if you could have a comment at the start of the 
file with the prerequisite applications/packages named it may help the 
people that it doesn't work for (initially).  The other thing is that 
the virtualbox install of Ubuntu 11.04 that I just completed did not 
contain the LVM2 package.

regards
Simon

On 26/05/2011 13:00, Phil Turmel wrote:
> On 05/26/2011 04:24 AM, CoolCold wrote:
> [...]
>> On Debian Lenny produces error:
>> root@gamma2:/tmp# python lsdrv
>> Traceback (most recent call last):
>>    File "lsdrv", line 17, in<module>
>>      import os, io, re
>> ImportError: No module named io
> Huh.  The 'io' module is v2.6 and above.  Another reason to make a helper function for reading these files.
>
> Phil
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message tomajordomo@vger.kernel.org
> More majordomo info athttp://vger.kernel.org/majordomo-info.html
