From: Wol <antlists@youngman.org.uk>
Subject: Re: Reassembling Raid5 in degraded state
Date: Mon, 13 Jan 2020 18:46:40 +0000
Message-ID: <7b7c8d20-6402-485b-5251-956637acb7db@youngman.org.uk>
References: <54384251-9978-eb99-e7ec-2da35f41566c@inview.de>
 <5E1C86F4.4070506@youngman.org.uk>
 <CAPhsuW45052b5OjoWgQhs0r50CeisBS3ya3nGi74Jr0_8HDB5A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAPhsuW45052b5OjoWgQhs0r50CeisBS3ya3nGi74Jr0_8HDB5A@mail.gmail.com>
Content-Language: en-GB
Sender: linux-raid-owner@vger.kernel.org
To: Song Liu <liu.song.a23@gmail.com>
Cc: Christian Deufel <christian.deufel@inview.de>, linux-raid <linux-raid@vger.kernel.org>, NeilBrown <neilb@suse.com>
List-Id: linux-raid.ids

On 13/01/2020 17:31, Song Liu wrote:
>> Song, Neil,
>>
>> Just a guess as to what went wrong, but the array event count does not
>> match the disk counts. Iirc this is one of the events that cause an
> Which mismatch do you mean?
> 
>> assemble to stop. Is it possible that a crash at the wrong moment could
>> interrupt an update and trigger this problem?
> It looks like sdc1 failed first. Then sdd1 and sdf1 got events for sdc1 failed.
> Based on super block on sdd1 and sdf1, we already have two failed drive,
> so assemble stopped.
> 
> Does this answer the question?
> 
Sorry yes it does. My fault for mis-reading the logs the OP sent.

Cheers.,
Wol
