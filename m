From: David Brown <david.brown@hesbynett.no>
Subject: Re: Creating a 3-disk RAID6 array
Date: Thu, 17 May 2012 15:18:33 +0200
Message-ID: <4FB4FAA9.7000100@hesbynett.no>
References: <4FB4534A.5070608@volatilevoid.net> <20120517113817.7faf9c1e@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120517113817.7faf9c1e@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Oliver Martin <oliver@volatilevoid.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 17/05/12 03:38, NeilBrown wrote:
> On Thu, 17 May 2012 03:24:26 +0200 Oliver Martin<oliver@volatilevoid.net>
> wrote:
>
>> Hi,
>>
>> is there any specific reason why md refuses to create a RAID6 array with
>> 3 disks? My (probably naive) understanding suggests it should be the
>> same as a 3-disk RAID1, similar to a 2-disk RAID5.
>
> I'll have to leave for for hpa to answer.  I've occasionally thought that
> maybe it should be fixed, but it never seemed worth the effort.
>
>>
>> The reason I'm asking is that I currently have space on three disks for
>> a new array, and would like to expand it when I add a fourth. I tried
>> this scenario with a few loopback devices, but the only way to go from a
>> 3-disk RAID1 to a 4-disk RAID6 seems to be via an intermediate 3-disk
>> RAID5, requiring two reshapes. I'd like to avoid one of them, if at all
>> possible.
>
> Yes, not possible at present.
> It might be as simple and finding the places that impose the limit and delete
> them...
>
> NeilBrown
>

Theoretically, a 3-disk RAID6 is like a 2-disk RAID5 or a 1-disk RAID1 - 
it is possible, but not much use except as a building block for 
expansion later.  mdadm supports 1-disk RAID1 (you need a "--force" to 
persuade mdadm that you know what you are doing, which is nice), and I 
think it supports a 2-disk RAID5, though I haven't tried it.  I can't 
think of any good reason for it /not/ to support 3-disk RAID6, as there 
is nothing in the algorithms to hinder it.

mvh.,

David

