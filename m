From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: Re: RAID performance
Date: Thu, 07 Feb 2013 21:12:10 +1100
Message-ID: <51137DFA.5020406@websitemanagers.com.au>
References: <51134E43.7090508@websitemanagers.com.au> <5113516C.5080606@aei.mpg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5113516C.5080606@aei.mpg.de>
Sender: linux-raid-owner@vger.kernel.org
To: Carsten Aulbert <Carsten.Aulbert@aei.mpg.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 07/02/13 18:02, Carsten Aulbert wrote:
> Hi Adam
> 
> On 02/07/2013 07:48 AM, Adam Goryachev wrote:
>>
>> Each drive only has a single partition, and is partitioned a little
>> smaller than the drive (supposedly this should improve performance).
>> Each drive is set to the deadline scheduler.
> 
> First, I'd start with the deadline scheduler.

Already using it, am going to try noop shortly....

> Even for rotating rust systems you can improve performance quite a bit,
> but with SSDs you might hit the limits way too early and need to tune it.
> 
> Save the current default values somewhere safe, so you can go back
> easily, then start tuning these values (as a start):
> 
> for i in $(grep \^md /proc/mdstat |cut -d' ' -f 5-); do
>     DEV=${i:0:3}
>     echo deadline > /sys/block/$DEV/queue/scheduler
>     echo 4096  > /sys/block/$DEV/queue/nr_requests
>     echo 8192  > /sys/block/$DEV/queue/read_ahead_kb
>     echo 5000  > /sys/block/$DEV/queue/iosched/read_expire
>     echo 1000 > /sys/block/$DEV/queue/iosched/write_expire
>     echo 2048  > /sys/block/$DEV/queue/iosched/fifo_batch
> done
> 
> At least setting these helped quite a bit.

Do you have any information on what your workload is, or how/why these
values might help?

You are changing values significantly from the default, and I am
cautious that they may cause other issues. Also, someone else has
advised to reduce nr_requests rather than increasing it?

Thank you for your advice.

Regards,
Adam

-- 
Adam Goryachev
Website Managers
www.websitemanagers.com.au
