From: Alexander Lyakas <alex.bolshoy@gmail.com>
Subject: Re: raid5 write latency is 10x the drive latency
Date: Tue, 4 Mar 2014 11:50:45 +0200
Message-ID: <CAGRgLy5mTGKMCkWE3qYz2Hjiija5qvgFJ0MkV6iUd9N-_OS3VA@mail.gmail.com>
References: <CAGRgLy55eAiam-JJFzUAZH581odHu8o9Pxt6y8jbcj92v+q6CQ@mail.gmail.com>
	<21268.65296.503057.601739@tree.ty.sabi.co.uk>
	<21269.4194.236349.136774@tree.ty.sabi.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <21269.4194.236349.136774@tree.ty.sabi.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Grandi <pg@lxra2.for.sabi.co.uk>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Mar 4, 2014 at 1:29 AM, Peter Grandi <pg@lxra2.for.sabi.co.uk> wrote:
>> [ ... ] Which tool settings? [ ... ]
>
> As to this, how are the 8KiB writes aligned? To 1KiB? 4KiB?
> 8KiB? To something else?
They were 4Kb aligned. Looking at the code, I don't think it matters
much; if I had them them 8K aligned, it would still be required to
load/update 2 stripe-heads for each write.

>
> Is there any other activity on the same physical disks given
> that the RAID members seem to be LVs?
They are device-mapper devices (but not LVs), and there was no other
activity. The device-mappers lead to drives behind MegaRAID write-back
caching. (Something tells me you will find this funny at best, but as
I mentioned, I am just trying to understand how much write latency MD
can add on top of drives latencies).

>
> Also what's the size of those LV members of the MD set? It may
> be quite small...
Each one is 560GB. The whole MD usable space is ~2.2TB, so with a
random workload over such huge capacity, MD stripe cache cannot help
anyways. You need to load and update new stripe-heads every write.
This was the purpose of the test. In my case, I had 1024 stripe-heads,
while only up to 500 of them were active.

Alex.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
