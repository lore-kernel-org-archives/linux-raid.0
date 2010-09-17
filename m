From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: advice to low cost hardware raid (with mdadm)
Date: Thu, 16 Sep 2010 23:38:59 -0500
Message-ID: <4C92F0E3.5060207@hardwarefreak.com>
References: <00c6ed0254381567aff38d7a95d200c5.squirrel@fuckaround.org>    <4C912F5D.5040305@hardwarefreak.com> <b6947b76728ca8c5d78d4d05fbd7894c.squirrel@fuckaround.org> <4C929D19.80001@ziu.info>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4C929D19.80001@ziu.info>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Michal Soltys put forth on 9/16/2010 5:41 PM:
> On 10-09-16 00:03, Pol Hallen wrote:
>>
>>> additionally, in the event
>>>  of a disk failure, rebuilding a 6x1TB RAID5/6 array will take forever
>>>  and a day.
>>
>> a nightmare...
>>
>> very thanks for your reasoning.. I don't have enought experience about
>> raid and friends!
>>
>> Pol
> 
> One remark - write intent bitmaps will make it perfectly fine (orders of
> magnitude faster). I'm not sure how the feature looks from performance
> point of view these days though.

My "forever and a day" RAID6 build/rebuild comment may have been taken
out of context.  The original post was inquiring about running a qty 6
SATA disk md RAID6 array on a standard 132 MB/s PCI bus, using three 2
port PCI SATA cards on the single PCI bus.  My comments were focused on
the PCI bottleneck in such a setup causing dreadful array performance.

-- 
Stan
