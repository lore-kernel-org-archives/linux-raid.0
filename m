From: Iain Rauch <groups@email.iain.rauch.co.uk>
Subject: Re: RAID 6 grow problem
Date: Tue, 05 Jun 2007 18:08:10 +0100
Message-ID: <C28B570A.7F4E%groups@email.iain.rauch.co.uk>
References: <4664760E.8040606@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4664760E.8040606@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>, Daniel Korstad <dan@korstad.net>, Neil Brown <neilb@suse.de>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, Justin Piszcz <jpiszcz@lucidpixels.com>
List-Id: linux-raid.ids

>>>>> raid6 reshape wasn't added until 2.6.21.  Before that only raid5 was
>>>>> supported.
>>>>> You also need to ensure that CONFIG_MD_RAID5_RESHAPE=y.
>>>>>         
>>>> I don't see that in the config. Should I add it? Then reboot?
>>>> 
Don't know how I missed it first time, but that is in my config.

>>> You reported that you were running a 2.6.20 kernel, which doesn't
>>> support raid6 reshape.
>>> You need to compile a 2.6.21 kernel (or
>>>    apt-get install linux-image-2.6.21-1-amd64
>>> or whatever) and ensure that CONFIG_MD_RAID5_RESHAPE=y is in the
>>> .config before compiling.
>>>     
>> 
>> There only seems to be version 2.6.20 does this matter a lot? Also how do I
>> specify what is in the config when using apt-get install?
>>   
> 
> 2.6.20 doesn't support the feature you want, only you can tell if that
> matters a lot. You don't, either get a raw kernel source and configure,
> or run what the vendor provides for config. Sorry, those are the option.
I have finally managed to compile a new kernel (2.6.21) and boot it.

>>>> I used apt-get install mdadm to first install it, which gave me 2.5.x then
>>>> I
>>>> downloaded the new source and typed make then make install. Now mdadm -V
>>>> shows "mdadm - v2.6.2 - 21st May 2007".
>>>> Is there anyway to check it is installed correctly?
>>>
>>> The "mdadm -V" check is sufficient.
>> 
>> Are you sure because at first I just did the make/make install and mdadm -V
>> did tell me v2.6.2 but I don't believe it was installed properly because it
>> didn't recognise my array nor did it make a config file, and cat
>> /proc/mdstat said no file/directory??
> mdadm doesn't control the /proc/mdstat file, it's written by the kernel.
> The kernel had no active array to mention in the mdstat file.
I see, thanks. I think it is working OK.

I am currently growing a 4 disk array to an 8 disk array as a test, and if
it that works I'll use those 8 and add them to my original 8 to make a 16
disk array. This will be a while yet as this first grow is going to take
2000 minutes. It looks like it's going to work fine, but I'll report back in
a couple of days.

Thank you so much for your help; Dan, Bill, Neil, Justin and everyone else.

The last thing I would like to know is if it is possible to 'clean' the
super blocks to make sure they are all OK. TIA.


Iain


