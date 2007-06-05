From: "Daniel Korstad" <dan@korstad.net>
Subject: RE:  RAID 6 grow problem
Date: Tue, 5 Jun 2007 14:21:21 -0500
Message-ID: <2076428235.1181071281354.JavaMail.root@gateway.korstad.net>
References: <C28B570A.7F4E%groups@email.iain.rauch.co.uk>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <C28B570A.7F4E%groups@email.iain.rauch.co.uk>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Iain Rauch <groups@email.iain.rauch.co.uk>, Bill Davidsen <davidsen@tmr.com>, Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org, Justin Piszcz <jpiszcz@lucidpixels.com>
List-Id: linux-raid.ids

Sounds like you are well on your way.
 
I am not too surprised on the time to completion.  I probably underestimated/exaggerated a bit when I said after a few hours :)
 
It took me over a day to grow one disk as well.  But my experience was on a system with an older AMD 754 x64 Mother Board with a couple SATA on board and the rest on two PCI cards each with 4 SATA ports.  So I have 8 SATA drives on my PCI (33Mhz x 4 bytes (32bits) = 133MB/s) bus of which is saturated basically after three drives.
 
But this box sets in the basement and acts as my NAS.  So for file access across the 100Mb/s network or wireless network, it does just fine.
 
When I do hdparm -tT /dev/md1 I get read access speeds from 110MB/s - 130MB/s  and for my individual drives at around 50 - 60 MB/s so the RAID6 outperforms (reads) any one drive and I am happy.  Bonnie/Bonnie++ is probably a better tool for testing, but I was just looking for quick and dirty numbers.
 
I have friends that have newer MB with half a dozen or almost a dozen SATA connectors and PCI-express SATA controller cards.  Getting rid of the slow PCI bus limitation increases the speed by magnitudes...  But this is another topic/thread...
  
 
Congrats on your new kernel and progress!
Cheers,
Dan.
  
----- Original Message -----
From: Iain Rauch 
Sent: Tue, 6/5/2007 12:09pm
To: Bill Davidsen ; Daniel Korstad ; Neil Brown ; linux-raid@vger.kernel.org; Justin Piszcz 
Subject: Re: RAID 6 grow problem 
 
 
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
