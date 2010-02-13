From: Giovanni Tessore <giotex@texsoft.it>
Subject: Re: Linux mdadm superblock question.
Date: Sat, 13 Feb 2010 10:35:05 +0100
Message-ID: <4B767249.2070305@texsoft.it>
References: <alpine.DEB.2.00.1002111758350.12031@p34.internal.lan>	 <4B7664AC.4080504@texsoft.it> <4877c76c1002130126m7ff93c33m5159eb4e554d22b4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4877c76c1002130126m7ff93c33m5159eb4e554d22b4@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


>> I recently reinstalled my systems, and I had to use superblock 0.9 to be
>> able to boot ext4 from raid-1 (kernel 2.6.31 - grub2 1.97-beta4).
>> I didn't go deep with it as I was quite in hurry, so I'm not sure if it
>> depends by grub2 or by kernel's md autodetection at boot.
>> I used superblock 1.1 for the others md devices.
>>
>> ...
> mdadm 1.0 block devices, since stored at the end, can still be used
> /read only/ the same way that 0.90 devices were used before grub knew
> how to talk to them.  By looking at the underlying block devices and
> ignoring their tails.  This does however only hold for raid-1 layouts
> with the 1.0 or 0.90 format labels.

I guessed so, infact I created superblock 1.0 for the raid-1 devices md0 
(root) and md1 (swap), while 1.1 for the others .. but it didn't work 
and I had to revert to 0.9 for root and swap ...

Regards

-- 
Cordiali saluti.
Yours faithfully.

Giovanni Tessore


