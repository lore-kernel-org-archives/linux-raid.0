From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: RAID 6 grow problem
Date: Mon, 04 Jun 2007 16:29:02 -0400
Message-ID: <4664760E.8040606@tmr.com>
References: <C287AF46.7EDF%groups@email.iain.rauch.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <C287AF46.7EDF%groups@email.iain.rauch.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Iain Rauch <groups@email.iain.rauch.co.uk>
Cc: Neil Brown <neilb@suse.de>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, Justin Piszcz <jpiszcz@lucidpixels.com>
List-Id: linux-raid.ids

Iain Rauch wrote:
>>>> raid6 reshape wasn't added until 2.6.21.  Before that only raid5 was
>>>> supported.
>>>> You also need to ensure that CONFIG_MD_RAID5_RESHAPE=y.
>>>>         
>>> I don't see that in the config. Should I add it? Then reboot?
>>>       
>> You reported that you were running a 2.6.20 kernel, which doesn't
>> support raid6 reshape.
>> You need to compile a 2.6.21 kernel (or
>>    apt-get install linux-image-2.6.21-1-amd64
>> or whatever) and ensure that CONFIG_MD_RAID5_RESHAPE=y is in the
>> .config before compiling.
>>     
>
> There only seems to be version 2.6.20 does this matter a lot? Also how do I
> specify what is in the config when using apt-get install?
>   

2.6.20 doesn't support the feature you want, only you can tell if that 
matters a lot. You don't, either get a raw kernel source and configure, 
or run what the vendor provides for config. Sorry, those are the option.
>   
>>> I used apt-get install mdadm to first install it, which gave me 2.5.x then I
>>> downloaded the new source and typed make then make install. Now mdadm -V
>>> shows "mdadm - v2.6.2 - 21st May 2007".
>>> Is there anyway to check it is installed correctly?
>>>       
>> The "mdadm -V" check is sufficient.
>>     
>
> Are you sure because at first I just did the make/make install and mdadm -V
> did tell me v2.6.2 but I don't believe it was installed properly because it
> didn't recognise my array nor did it make a config file, and cat
> /proc/mdstat said no file/directory??
mdadm doesn't control the /proc/mdstat file, it's written by the kernel. 
The kernel had no active array to mention in the mdstat file.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

