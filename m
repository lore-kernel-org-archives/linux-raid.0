From: Laurent Lesage <laurent@lesagepono.be>
Subject: Re: Making bootable SATA RAID1 array in Mandriva 2006
Date: Mon, 14 Aug 2006 17:13:47 +0200
Message-ID: <44E0932B.8040801@lesagepono.be>
References: <44DFBB0E.90705@aol.com> <44E07D03.9020802@lesagepono.be> <44E08E41.4090705@aol.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <44E08E41.4090705@aol.com>
Sender: linux-raid-owner@vger.kernel.org
To: andy liebman <andyliebman@aol.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Andy,

there are options for the "mkinitrd" command, that are like the 
parameters in "mkinitrd.conf" (this is the case in "Debian"). did you 
use the -root=xxx option?

Laurent

andy liebman wrote:
> laurent@lesagepono.be wrote:
>> Hi Andy,
>>
>> I did the same a few times (!) with a Debian stable. I found two 
>> pages with "recipes" that were convenient to me. For what could be 
>> related to you, I had to modify the "/etc/mkinirtd/mkinitrd.conf" file :
>>>
>>> If you are using a SATA drive you pay attention!
>>>
>>> edit /etc/mkinitrd/mkinitrd.conf and change:
>>>
>>>     MODULES=most
>>>
>>> to
>>>
>>>     ###MODULES=most
>>>     MODULES=dep
>>>
>>> and
>>>
>>>     ROOT=probe
>>>
>>> to
>>>
>>>     ###ROOT=probe
>>>     ROOT="/dev/md2 jfs"
>>>
>>> This tells init to use what it takes to boot off of a raid device 
>>> not the /dev/sda device currently used. 
>> (modify according to your specs) The first part (mo=dep) is not 
>> mandatory (it just makes a smaller image), but the second is!
>>
>
> Thank you Laurent. I saw that in the same "how to" document. The 
> problem is, Mandriva does NOT have a mkinitrd.conf.
>
> I could create it, but I don't know if mkinitrd will use it! In 
> Mandriva, it probably just has to be in /etc/ if if's useful at all.
>
> Andy
>
>

