From: Matt Garman <matthew.garman@gmail.com>
Subject: Re: Latest on SSD Raid
Date: Sat, 30 Sep 2017 08:22:56 -0500
Message-ID: <CAJvUf-DgNz3_aZN-BFoq3BigUgjZAVKMsQjEP1crjUxMJE3mbg@mail.gmail.com>
References: <2931220.pImEXletoV@dag.newtech.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2931220.pImEXletoV@dag.newtech.fi>
Sender: linux-raid-owner@vger.kernel.org
To: Dag Nygren <dag@newtech.fi>
Cc: Mdadm <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, Sep 29, 2017 at 10:53 AM, Dag Nygren <dag@newtech.fi> wrote:
> Would like to tap some experience out of all here
> with the question:
>
> Any good hints and advice when setting up a RAID5 SSD with
> 3 disks to start with?

As is often (always?) the case, a lot depends on your expected workload.

Have now built three systems with 24-disk 2TB SSD RAID6 arrays.  We
used consumer-grade drives for cost savings, as this is a virtually
read-only workload.  We do add a small amount of data every
day---roughly 50GB, spread across the entire array.  The rest of the
time it's just read read read read.  (Effectively a WORM workload.)

In this role, our systems have been great.  We found that the network
interface was the first bottleneck.  Now we've got dual 40gbs ports on
these systems.  The interfaces are bonded and load balanced, and jumbo
frames is a must.

We did just a tiny bit of tuning, nothing special (don't remember the
details offhand).

The only real "gotcha" we ran into in all this is rebuild times.
Actually, rebuilds themselves are fast.  The problem is, it's a
tradeoff between reduced client performance and rebuild time.  mdadm
allows you to tune how fast the rebuild can go.  Although, with a bit
of experimentation, I found that mdadm supports multi-threaded
rebuilds, and this made a huge improvement in being able to do a
rebuild while still serving some data.

I suspect enterprise drives, with their generally bigger overprovision
space and smarter controllers, would likely fare better on rebuilds.
On the flipside, we haven't actually had any drive failures, the
rebuilds we did were just "practicing" for what to do and expect when
a drive does inevitably fail.
