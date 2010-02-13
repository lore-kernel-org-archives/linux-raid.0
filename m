From: Giovanni Tessore <giotex@texsoft.it>
Subject: Re: Linux mdadm superblock question.
Date: Sat, 13 Feb 2010 11:06:17 +0100
Message-ID: <4B767999.1070902@texsoft.it>
References: <alpine.DEB.2.00.1002111758350.12031@p34.internal.lan>	 <4B7664AC.4080504@texsoft.it>	 <4877c76c1002130126m7ff93c33m5159eb4e554d22b4@mail.gmail.com>	 <4B767249.2070305@texsoft.it> <4877c76c1002130140x65cb2b24ydcb57913c6d89b64@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4877c76c1002130140x65cb2b24ydcb57913c6d89b64@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


>>>> I recently reinstalled my systems, and I had to use superblock 0.9 to be
>>>> able to boot ext4 from raid-1 (kernel 2.6.31 - grub2 1.97-beta4).
>>>> I didn't go deep with it as I was quite in hurry, so I'm not sure if it
>>>> depends by grub2 or by kernel's md autodetection at boot.
>>>> I used superblock 1.1 for the others md devices.
>>>>         
>>> mdadm 1.0 block devices, since stored at the end, can still be used
>>> /read only/ the same way that 0.90 devices were used before grub knew
>>> how to talk to them.  By looking at the underlying block devices and
>>> ignoring their tails.  This does however only hold for raid-1 layouts
>>> with the 1.0 or 0.90 format labels.
>>>       
>> I guessed so, infact I created superblock 1.0 for the raid-1 devices md0
>> (root) and md1 (swap), while 1.1 for the others .. but it didn't work and I
>> had to revert to 0.9 for root and swap ...
>>
>>     
>
> Just a guess, but did you tell grub root was /dev/md0 or did you say
> root was /dev/sd(whatever backs md0) ?
>   

Root was set to (md0), I followed the installer of the distro (ubuntu 
9.10 srv) and also tried manually with update-grub and then grub-install 
/dev/sda, grub-install /dev/sdb, grub-install /dev/sdc (3 disk raid-1)
Both failed with superblock 1.0, giving a message like 'missing mapping 
of device /dev/md0', infact into /boot/grub/device.map it was missing 
(even for 0.9), but also adding it ( (md0) /dev/md0 )didn't help, giving 
other error messages.

Btw, even if I missed something, the point is:
- with 0.9 it worked painless
- with 1.0 it didn't work
donno if it dependes by distro, kernel of md, but some different 
behaviour relative to superblock 0.9 and 1.0 existed.
I didn't investigate further as I was in extreme hurry to setup the system.

Regards

-- 
Cordiali saluti.
Yours faithfully.

Giovanni Tessore


