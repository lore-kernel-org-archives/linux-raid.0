From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: advice to low cost hardware raid (with mdadm)
Date: Fri, 17 Sep 2010 01:42:08 +0100
Message-ID: <4C92B960.2050305@anonymous.org.uk>
References: <00c6ed0254381567aff38d7a95d200c5.squirrel@fuckaround.org>    <4C912F5D.5040305@hardwarefreak.com> <b6947b76728ca8c5d78d4d05fbd7894c.squirrel@fuckaround.org> <4C929D19.80001@ziu.info>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4C929D19.80001@ziu.info>
Sender: linux-raid-owner@vger.kernel.org
To: Michal Soltys <soltys@ziu.info>
Cc: Pol Hallen <polhallen@fuckaround.org>, Stan Hoeppner <stan@hardwarefreak.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 16/09/2010 23:41, Michal Soltys wrote:
> On 10-09-16 00:03, Pol Hallen wrote:
>>
>>> additionally, in the event
>>> of a disk failure, rebuilding a 6x1TB RAID5/6 array will take forever
>>> and a day.
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

It should be configured with a sensible block size; the default block 
size is usually too small and spoils performance. I chose a 16MB write 
intent bitmap block size after experimenting a while ago (have a look 
for posts on the subject from me), on the basis that larger gave 
diminishing returns for write performance and smaller (nearer the 
default) impacted badly on write performance, but others have gone as 
big as 128MB (again see the archives), but the default, while it depends 
on the array size and metadata version, often damages write performance 
for only a small benefit in recovery time.

In short, the default write intent bitmap block size works but is liable 
to be suboptimal so you should consider tuning it rather than take the 
default.

Cheers,

John.
