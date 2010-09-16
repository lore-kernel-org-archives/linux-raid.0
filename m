From: Michal Soltys <soltys@ziu.info>
Subject: Re: advice to low cost hardware raid (with mdadm)
Date: Fri, 17 Sep 2010 00:41:29 +0200
Message-ID: <4C929D19.80001@ziu.info>
References: <00c6ed0254381567aff38d7a95d200c5.squirrel@fuckaround.org>    <4C912F5D.5040305@hardwarefreak.com> <b6947b76728ca8c5d78d4d05fbd7894c.squirrel@fuckaround.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <b6947b76728ca8c5d78d4d05fbd7894c.squirrel@fuckaround.org>
Sender: linux-raid-owner@vger.kernel.org
To: Pol Hallen <polhallen@fuckaround.org>
Cc: Stan Hoeppner <stan@hardwarefreak.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 10-09-16 00:03, Pol Hallen wrote:
>
>>additionally, in the event
>>  of a disk failure, rebuilding a 6x1TB RAID5/6 array will take forever
>>  and a day.
>
> a nightmare...
>
> very thanks for your reasoning.. I don't have enought experience about
> raid and friends!
>
> Pol

One remark - write intent bitmaps will make it perfectly fine (orders of 
magnitude faster). I'm not sure how the feature looks from performance 
point of view these days though.

