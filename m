From: Phil Turmel <philip@turmel.org>
Subject: Re: RAID10 and 'writemostly' support
Date: Sat, 18 Feb 2017 17:20:35 -0500
Message-ID: <7090c5c7-7f02-14a3-36f1-23b8bfe53043@turmel.org>
References: <07e8d394-2f95-caae-d971-a5fef009fefe@thelounge.net>
 <033aa14d-32a0-531d-7d7d-c01a0aeb13eb@youngman.org.uk>
 <f6ed7560-97b8-78ef-26be-789a8bc372b5@thelounge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <f6ed7560-97b8-78ef-26be-789a8bc372b5@thelounge.net>
Sender: linux-raid-owner@vger.kernel.org
To: Reindl Harald <h.reindl@thelounge.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 02/17/2017 05:03 AM, Reindl Harald wrote:

>> Be careful. Don't confuse Raid10 with Raid1+0. They are NOT the
>> same thing (on linux at least), although they are very similar
> 
> yeah, i realized that but anyways thought the "writemostly" logic is 
> there too and maybe the docs not up-to-date

Linux MD raid10 doesn't have a requirement that the number of devices
be a multiple of the number of data copies.  Which creates "interesting"
data layouts with odd numbers of devices or similar effects with ,n3 or
,f3 layouts.  Which makes it difficult if not impossible to designate
specific devices as write mostly without weird operational asymmetries
across the assembled array.

In other words, it is not at all like raid 1 on top of raid 0, except in
certain very limited cases, and your assumptions are simply wrong.

If there are features (other than layouts) of raid10 that make you
prefer it to raid1, it would make sense to ask for those features to
be implemented in raid1.

> sadly i can't write a patch on my own but only point how useful it
> would be

That's unfortunate.  Patches are generally welcome.

Phil
