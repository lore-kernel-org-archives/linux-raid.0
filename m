From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: Deleting mdadm RAID arrays
Date: Tue, 05 Feb 2008 18:16:01 +0300
Message-ID: <47A87DB1.2070901@msgid.tls.msk.ru>
References: <200802051142.19625.admin@domeny.pl> <20080205132717.238c4312@szpak> <47A86A12.2090405@msgid.tls.msk.ru> <47A873D5.3000201@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <47A873D5.3000201@pobox.com>
Sender: linux-raid-owner@vger.kernel.org
To: Moshe Yudkowsky <moshe@pobox.com>
Cc: Janek Kozicki <janek_listy@wp.pl>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Moshe Yudkowsky wrote:
> Michael Tokarev wrote:
>> Janek Kozicki wrote:
>>> Marcin Krol said:     (by the date of Tue, 5 Feb 2008 11:42:19 +0100)
>>>
>>>> 2. How can I delete that damn array so it doesn't hang my server up
>>>> in a loop?
>>> dd if=/dev/zero of=/dev/sdb1 bs=1M count=10
>>
>> This works provided the superblocks are at the beginning of the
>> component devices.  Which is not the case by default (0.90
>> superblocks, at the end of components), or with 1.0 superblocks.
>>
>>   mdadm --zero-superblock /dev/sdb1
> 
> Would that work if even if he doesn't update his mdadm.conf inside the
> /boot image? Or would mdadm attempt to build the array according to the
> instructions in mdadm.conf? I expect that it might depend on whether the
> instructions are given in terms of UUID or in terms of devices.

After zeroing superblocks, mdadm will NOT assemble the array,
regardless if using UUIDs or devices or whatever.  In order
to assemble the array, all component devices MUST have valid
superblocks and the superblocks must match each other.

mdadm --assemble in initramfs will simple fail to do its work.

/mjt
