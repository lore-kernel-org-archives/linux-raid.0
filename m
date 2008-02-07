From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: using update-initramfs: how to get new mdadm.conf into the /boot?
 Or is it XFS?
Date: Thu, 07 Feb 2008 16:48:16 -0500
Message-ID: <47AB7CA0.9010407@tmr.com>
References: <47A77CC0.10807@pobox.com> <20080204210903.GD3959@baikonur.stro.at> <47A78949.7020803@pobox.com> <47AB7714.50608@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <47AB7714.50608@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Moshe Yudkowsky <moshe@pobox.com>, maximilian attems <max@stro.at>, linux raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Bill Davidsen wrote:
> Moshe Yudkowsky wrote:
>> maximilian attems wrote:
>>
>>> error 15 is an *grub* error.
>>>
>>> grub is known for it's dislike of xfs, so with this whole setup use 
>>> ext3
>>> rerun grub-install and you should be fine.
>>
>> I should mention that something *did* change. When attempting to use 
>> XFS, grub would give me a note about "18 partitions used" (I forget 
>> the exact language). This was different than I'd remembered; when I 
>> switched back to using reiserfs, grub reports using 19 partitions.
>>
>> So there's something definitely interesting about XFS and booting.
>>
>> As an additional note, if I use the grub boot-time commands to edit 
>> root to read, e.g., root=/dev/sda2 or root=/dev/sdb2, I get the same 
>> Error 15 error message.
>>
>> It may be that grub is complaining about grub and resiserfs, but I 
>> suspect that it has a true complain about the file system and what's 
>> on the partitions.
>>
> I think you have two choices, convert /boot to ext2 and be sure you 
> are going down the best-tested code path, or fight and debug, read 
> code, learn grub source, play with the init parts of the boot 
> sequence, and then convert /boot to ext2 anyway. No matter how 
> "better" something else might be, /boot has nothing I use except at 
> boot, I don't need features or performance, I just want it to work.
>
> Unless you are so frustrated you have entered "I am going to make this 
> *work* if it takes forever" mode, I would try the easy solution first. 
> Just my take on it.
>
Or you can get lucky and someone will have seen this before and hand you 
a solution...  ;-)

-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


