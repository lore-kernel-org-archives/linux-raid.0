From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Linux RAID Partition Offset 63 cylinders / 30% performance hit?
Date: Wed, 19 Dec 2007 10:31:12 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0712191031060.2468@p34.internal.lan>
References: <Pine.LNX.4.64.0712190926150.2468@p34.internal.lan>
 <Pine.GSO.4.64.0712191558290.1549@montezuma.acc.umu.se>
 <Pine.LNX.4.64.0712191002580.2468@p34.internal.lan>
 <cccedfc60712190706w7f9131c3g79dffbb0a4e2fe86@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cccedfc60712190706w7f9131c3g79dffbb0a4e2fe86@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jon Nelson <jnelson@jamponi.net>
Cc: Mattias Wadenstein <maswan@acc.umu.se>, linux-raid@vger.kernel.org, apiszcz@solarrain.com
List-Id: linux-raid.ids



On Wed, 19 Dec 2007, Jon Nelson wrote:

> On 12/19/07, Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
>>
>>
>> On Wed, 19 Dec 2007, Mattias Wadenstein wrote:
>>>> From that setup it seems simple, scrap the partition table and use the
>>> disk device for raid. This is what we do for all data storage disks (hw raid)
>>> and sw raid members.
>>>
>>> /Mattias Wadenstein
>>>
>>
>> Is there any downside to doing that?  I remember when I had to take my
>
> There is one (just pointed out to me yesterday): having the partition
> and having it labeled as raid makes identification quite a bit easier
> for humans and software, too.
>
> -- 
> Jon
>

Some nice graphs found here:
http://sqlblog.com/blogs/linchi_shea/archive/2007/02/01/performance-impact-of-disk-misalignment.aspx

