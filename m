From: Reindl Harald <h.reindl@thelounge.net>
Subject: Re: RAID10 and 'writemostly' support
Date: Sun, 19 Feb 2017 00:35:15 +0100
Message-ID: <5a11be45-1793-d4b7-7cf5-3adaef5740d6@thelounge.net>
References: <07e8d394-2f95-caae-d971-a5fef009fefe@thelounge.net>
 <033aa14d-32a0-531d-7d7d-c01a0aeb13eb@youngman.org.uk>
 <f6ed7560-97b8-78ef-26be-789a8bc372b5@thelounge.net>
 <7090c5c7-7f02-14a3-36f1-23b8bfe53043@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <7090c5c7-7f02-14a3-36f1-23b8bfe53043@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Am 18.02.2017 um 23:20 schrieb Phil Turmel:
> On 02/17/2017 05:03 AM, Reindl Harald wrote:
>
>>> Be careful. Don't confuse Raid10 with Raid1+0. They are NOT the
>>> same thing (on linux at least), although they are very similar
>>
>> yeah, i realized that but anyways thought the "writemostly" logic is
>> there too and maybe the docs not up-to-date
>
> Linux MD raid10 doesn't have a requirement that the number of devices
> be a multiple of the number of data copies.  Which creates "interesting"
> data layouts with odd numbers of devices or similar effects with ,n3 or
> ,f3 layouts.  Which makes it difficult if not impossible to designate
> specific devices as write mostly without weird operational asymmetries
> across the assembled array.

but since --writemostly doesn't get without manually intervention that 
cases would be unchanged (besides that they are unlikely)

> In other words, it is not at all like raid 1 on top of raid 0, except in
> certain very limited cases, and your assumptions are simply wrong.
>
> If there are features (other than layouts) of raid10 that make you
> prefer it to raid1, it would make sense to ask for those features to
> be implemented in raid1.

writemostly it's also very appealing on existing setups, the machine 
from where i type was installed in 2011

RAID1 don't have the benefit of doubled performance (also for writes, on 
a hybrid RAID slower but still faster than RAID1) *and* doubled space 
compared to a single disk combined with mirroring

another example: on machines like a HP microserver with only 4 drive 
slots that you could easily improve read-performance which is for many 
workloads the most important part by just switch half of the disk to SSD

price calculation for a hybrid RAID10 with 10 disks:
5x4 TB SSD = 5 x 1400€ = 7000€
5x4 TB HDD = 5 x 100€ = 500€
total price 7500€ versus 14000€ for flash-only

>> sadly i can't write a patch on my own but only point how useful it
>> would be
>
> That's unfortunate.  Patches are generally welcome

i would be *seriously* willing to pay the inital patch for any kernel 
maintainer who takes it over - Fedora regulary does kernel-rebases on GA 
versions
