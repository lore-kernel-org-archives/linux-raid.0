From: Oliver Martin <oliver@volatilevoid.net>
Subject: Re: Creating a 3-disk RAID6 array
Date: Fri, 18 May 2012 01:27:02 +0200
Message-ID: <4FB58946.2050508@volatilevoid.net>
References: <4FB4534A.5070608@volatilevoid.net> <20120517113817.7faf9c1e@notabene.brown> <CAA9_cmd=tXvfWkgm1efsZmaWMgXQeuOdX0pAHrLC_-KejyseKw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAA9_cmd=tXvfWkgm1efsZmaWMgXQeuOdX0pAHrLC_-KejyseKw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Am 17.05.2012 23:02, schrieb Dan Williams:
>> I'll have to leave for for hpa to answer.  I've occasionally thought that
>> maybe it should be fixed, but it never seemed worth the effort.
>
> The math assumes 2 data disks.

Aside from a BUG_ON in async_raid6_datap_recov, it seems like it should 
work based on a cursory glance. Especially the various gen_syndrome 
implementations and raid6_datap_recov look like they should produce the 
correct result.

>> Yes, not possible at present.
>> It might be as simple and finding the places that impose the limit and delete
>> them...
>
> You'd certainly need to route around the acceleration code, because
> that increased the dependency on the assumption that there is always
> two data disk slots.

This, however, makes it seem like lots of hassle for very little gain, 
given that the same on-disk data can much more cheaply be produced by 
using a RAID1. I think the more sensible thing to do is to add support 
for reshaping a RAID1 into a 4-disk RAID6. This should hopefully not be 
too different from the existing RAID5-RAID6 reshape, and is probably 
what I'll (at least try to) implement when the time comes to expand my 
array.

Oliver
