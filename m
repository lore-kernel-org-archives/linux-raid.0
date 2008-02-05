From: Moshe Yudkowsky <moshe@pobox.com>
Subject: Re: Deleting mdadm RAID arrays
Date: Tue, 05 Feb 2008 08:33:57 -0600
Message-ID: <47A873D5.3000201@pobox.com>
References: <200802051142.19625.admin@domeny.pl> <20080205132717.238c4312@szpak> <47A86A12.2090405@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <47A86A12.2090405@msgid.tls.msk.ru>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Janek Kozicki <janek_listy@wp.pl>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Michael Tokarev wrote:
> Janek Kozicki wrote:
>> Marcin Krol said:     (by the date of Tue, 5 Feb 2008 11:42:19 +0100)
>>
>>> 2. How can I delete that damn array so it doesn't hang my server up in a loop?
>> dd if=/dev/zero of=/dev/sdb1 bs=1M count=10
> 
> This works provided the superblocks are at the beginning of the
> component devices.  Which is not the case by default (0.90
> superblocks, at the end of components), or with 1.0 superblocks.
> 
>   mdadm --zero-superblock /dev/sdb1

Would that work if even if he doesn't update his mdadm.conf inside the 
/boot image? Or would mdadm attempt to build the array according to the 
instructions in mdadm.conf? I expect that it might depend on whether the 
instructions are given in terms of UUID or in terms of devices.

-- 
Moshe Yudkowsky * moshe@pobox.com * www.pobox.com/~moshe
  "I think it a greater honour to have my head standing on the ports
   of this town for this quarrel, than to have my portrait in the
   King's bedchamber." -- Montrose, 20 May 1650
