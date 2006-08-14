From: andy liebman <andyliebman@aol.com>
Subject: Re: Making bootable SATA RAID1 array in Mandriva 2006
Date: Mon, 14 Aug 2006 10:52:49 -0400
Message-ID: <44E08E41.4090705@aol.com>
References: <44DFBB0E.90705@aol.com> <44E07D03.9020802@lesagepono.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <44E07D03.9020802@lesagepono.be>
Sender: linux-raid-owner@vger.kernel.org
To: laurent@lesagepono.be
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

laurent@lesagepono.be wrote:
> Hi Andy,
> 
> I did the same a few times (!) with a Debian stable. I found two pages 
> with "recipes" that were convenient to me. For what could be related to 
> you, I had to modify the "/etc/mkinirtd/mkinitrd.conf" file :
>>
>> If you are using a SATA drive you pay attention!
>>
>> edit /etc/mkinitrd/mkinitrd.conf and change:
>>
>>     MODULES=most
>>
>> to
>>
>>     ###MODULES=most
>>     MODULES=dep
>>
>> and
>>
>>     ROOT=probe
>>
>> to
>>
>>     ###ROOT=probe
>>     ROOT="/dev/md2 jfs"
>>
>> This tells init to use what it takes to boot off of a raid device not 
>> the /dev/sda device currently used. 
> (modify according to your specs) The first part (mo=dep) is not 
> mandatory (it just makes a smaller image), but the second is!
> 

Thank you Laurent. I saw that in the same "how to" document. The problem 
is, Mandriva does NOT have a mkinitrd.conf.

I could create it, but I don't know if mkinitrd will use it! In 
Mandriva, it probably just has to be in /etc/ if if's useful at all.

Andy
