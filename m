From: Beolach <beolach@gmail.com>
Subject: Re: Upgrading from RAID 5 to 6 or build native level 6?
Date: Fri, 18 Feb 2011 19:02:07 -0700
Message-ID: <AANLkTikqytG1S1nU0NkZSjcEs08kyDFUUKpfgxGerQn7@mail.gmail.com>
References: <AANLkTik8XFxjKJ+GoPjmos6Qm_WKzFw4O29Rr2w8cnGJ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTik8XFxjKJ+GoPjmos6Qm_WKzFw4O29Rr2w8cnGJ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Lasse Jensen <fafler@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Feb 16, 2011 at 08:40, Lasse Jensen <fafler@gmail.com> wrote:
> Is a RAID 6 array made by upgrading a RAID 5 array to RAID 6 in any
> way inferior to a RAID 6 array build from scratch? I read somewhere
> that the last drive would be parity only. I'm not sure what to make of
> it and i cant find the link again either. Is it going to be a
> bottleneck like in RAID 4?
>

That information is incomplete or out-of-date.  During a RAID 5 to
RAID 6 reshape, there may be an intermediate step where all of the Q
parity blocks are stored on one disk, but as the reshape continues, it
will move all the Q parity blocks to a normal RAID 6 layout.  IIRC, in
the very early stages of RAID 5 to RAID 6 reshape development, it
would leave it in the abnormal layout, but that has not been the case
for quite some time.  And I believe in some cases a RAID 5 to RAID 6
reshape will not even use the intermediate step w/ the abnormal
layout.  After the reshape fully completes, it is exactly the same as
a RAID 6 array built from scratch.

> The story is i have a degraded RAID 6 array with 3 out of 5 drives
> active because of random read errors on the drives. Danm you, Western
> Digital. Anyway, i can get all my data out, so no worries. I need to
> ship the two drives for replacement and when i get them back, i'm
> going to rearrange the array to put the encryption layer on top of the
> RAID layer instead of the other way around as it drops out drives from
> the array from time to time. Thats a whole different story.
>
> Now, when i get the drives back, i could use one drive for most of my
> data and put the rest on a couple of laptops and spare drives, build a
> 4 drive RAID 6 array and then add the last drive to the array.
> Or i could put my data on two drives a make a 3 drive RAID 5 array,
> copy data in to it, add the last two drives and upgrade to RAID 6.
> Which is better?
>

If I understand you correctly, I think the RAID 6 route would be
slightly better, because it would have enough parity info to recover
from a single drive failure, while the RAID 5 route you describe would
lose the array completely if a drive failed before you added the last
two drives.


Good luck!
