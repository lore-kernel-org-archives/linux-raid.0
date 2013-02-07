From: Carsten Aulbert <Carsten.Aulbert@aei.mpg.de>
Subject: Re: RAID performance
Date: Thu, 07 Feb 2013 08:02:04 +0100
Message-ID: <5113516C.5080606@aei.mpg.de>
References: <51134E43.7090508@websitemanagers.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51134E43.7090508@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <mailinglists@websitemanagers.com.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Adam

On 02/07/2013 07:48 AM, Adam Goryachev wrote:
> 
> Each drive only has a single partition, and is partitioned a little
> smaller than the drive (supposedly this should improve performance).
> Each drive is set to the deadline scheduler.

First, I'd start with the deadline scheduler.

Even for rotating rust systems you can improve performance quite a bit,
but with SSDs you might hit the limits way too early and need to tune it.

Save the current default values somewhere safe, so you can go back
easily, then start tuning these values (as a start):

for i in $(grep \^md /proc/mdstat |cut -d' ' -f 5-); do
    DEV=${i:0:3}
    echo deadline > /sys/block/$DEV/queue/scheduler
    echo 4096  > /sys/block/$DEV/queue/nr_requests
    echo 8192  > /sys/block/$DEV/queue/read_ahead_kb
    echo 5000  > /sys/block/$DEV/queue/iosched/read_expire
    echo 1000 > /sys/block/$DEV/queue/iosched/write_expire
    echo 2048  > /sys/block/$DEV/queue/iosched/fifo_batch
done

At least setting these helped quite a bit.

HTH

carsten
