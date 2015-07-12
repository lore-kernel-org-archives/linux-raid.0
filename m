From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: Re: Resurrecting a Dirty RAID-5
Date: Mon, 13 Jul 2015 08:33:09 +1000
Message-ID: <55A2EB25.10607@websitemanagers.com.au>
References: <OFC233BA12.DDED55A2-ON85257E7C.00420655-85257E7C.0043331F@jt-sw.com> <559D2374.7040208@turmel.org> <OF71F1F6CD.C562AA57-ON85257E7D.000FAD79-85257E7D.0010311B@jt-sw.com> <alpine.DEB.2.02.1507120756020.11810@uplift.swm.pp.se> <OF4E023A92.1624DC91-ON85257E80.0051B769-85257E80.005287C5@jt-sw.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <OF4E023A92.1624DC91-ON85257E80.0051B769-85257E80.005287C5@jt-sw.com>
Sender: linux-raid-owner@vger.kernel.org
To: jtroan@jt-sw.com, Mikael Abrahamsson <swmike@swm.pp.se>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 13/07/15 01:01, jtroan@jt-sw.com wrote:
>> On Wed, 8 Jul 2015, jtroan@jt-sw.com wrote:
>>
>>> I'm also thinking about adding a fourth drive and try to config it as a
>>> hot-spare, giving me some extra margin for failure.
>> I would recommend you turn your raid5 into raid6 instead of having a
>> raid5+spare. This can be done with a fairly simple command, without
>> downtime.
>>
> I like the idea of using RAID-6 for / (for all the VMs under /var).  (I
> figure I'll probably still have to do a spare on my RAID-1 device
> for /boot .)
>
> What's the (mdadm?) command to convert an MD from RAID-5 to RAID-6?
>
I think the standard option would be to have a hot spare, and then 
something like:
mdadm /dev/mdX --grow --level=raid6

Also, for your raid1, never have a hot spare, just do this:
mdadm /dev/mdX --grow --raid-devices=3
Then you will always have all your data replicated on all three drives, 
so again, no hot spare required.

Also remember to duplicate the grub/whatever boot sector....

Regards,
Adam

-- 
Adam Goryachev Website Managers www.websitemanagers.com.au
