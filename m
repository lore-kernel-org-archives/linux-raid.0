From: Christoph Nelles <evilazrael@evilazrael.de>
Subject: Re: Raid5 crashed, need comments on possible repair solution
Date: Mon, 23 Apr 2012 23:47:12 +0200
Message-ID: <4F95CDE0.4070200@evilazrael.de>
References: <4F955F80.80903@evilazrael.de> <20120424070044.707745b8@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120424070044.707745b8@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello Neil,


first thanks for the answer. I will happily provide any data or logs if
it helps you to investigate this problem.


Am 23.04.2012 23:00, schrieb NeilBrown:
> This is really worrying.  It's about the 3rd or 4th report recently which
> contains:
> 
>>      Raid Level : -unknown-
>>    Raid Devices : 0
> 
> and that should not be possible.  There must be some recent bug that causes
> the array to be "cleared" *before* writing out the metadata - and that should
> be impossible.
> What kernel are you running?

I switched kernel versions during that server rebuild. Last running
system was with 3.2.5, then rebuild and switch to 3.3.1 ant with that it
crashed. Kernel is vanilla selfcompiled, x86_64.
mdadm is 3.1.5, selfcompiled, too.

> You are correct that order is important.  Your algorithm looks good.
> However I suggest that you first look through your system looks to see if
> 
>   RAID conf printout:
> 
> appears at all.  That could contain the device order.

Yes, i found that, but as i reordered and rewired the drives due to
thermal reasons so I have no idea which drive was mapped to which device
name. In the normal system logs are only the model names and i had
multiple drives of the same type.

Regards

Christoph Nelles


-- 
Christoph Nelles

E-Mail    : evilazrael@evilazrael.de
Jabber    : eazrael@evilazrael.net      ICQ       : 78819723

PGP-Key   : ID 0x424FB55B on subkeys.pgp.net
            or http://evilazrael.net/pgp.txt

