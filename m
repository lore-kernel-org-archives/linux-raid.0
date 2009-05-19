From: "NeilBrown" <neilb@suse.de>
Subject: Re: [PATCH] md: Enhancements and clean to linear RAID
Date: Tue, 19 May 2009 17:25:30 +1000 (EST)
Message-ID: <9a138833b29b54e5d6c1eaa188f27399.squirrel@neil.brown.name>
References: <37d33d830905182323x22eec1c8l2a7471668c1a02b3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <37d33d830905182323x22eec1c8l2a7471668c1a02b3@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: SandeepKsinha <sandeepksinha@gmail.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, May 19, 2009 4:23 pm, SandeepKsinha wrote:
> Hi Neil,
>
> I have made the desired changes and have tested the changes as well.
> As expected the performance gain with number of devices ( > 20 ) is
> quite visible.

How did you measure the performance gain and what were your
results?

> The code also looks simpler as compared to what it earlier was.
>
> I have created the following patches for the changes:
>
> PATCH [01/03] md: Removal of num_sectors from dev_info in linear raid
>
> This patch removes the num_sectors from dev_info and makes use of the
> rdev->sectors for
> all further usage.

Could I as you to redo this one a little differently?
I want to keep the linear search very tight, and you have just added
a pointer de-reference to it.

If you could replace start_sector by end_sector, we wouldn't need that
de-reference or the addition.


>
> PATCH[02/03] md: Getting rid of sector_div and hash table in linear raid
>
> Removal of all the code pertaining hast table and other related data
> structures.
> This also makes the code really really simple.
> The searching being made linear for the time being to test the patch.
>
> PATCH[03/03] md: Replacing linear with a binary search
>
> This patch replaces the linear search in which_dev with binary search.

Two things wrong with you binary search.
1/ the while() condition is "hi >= lo".  That will always be true, so it
  would be better to make that explicit.  i.e. "while(1)".
  However the while loop of a binary search should be
   while (hi > lo)

2/ You have 3 comparisons against 'sector' inside the loop.  There should
   only be one.  We are aiming for speed remember :-)

   while (hi > lo) {
       mid = (hi + lo + 1) / 2;
       dev = conf->disks + mid;

       if (sector >= dev->start_sector)
            lo = mid;
       else
            hi = mid - 1;
    }
    return dev;

    With that formulation, you don't even need to replace
    sector_start by sector_end.. However doing so would make other
    code simpler, so please do proceed with replacing sector_start by
    sector_end.
    Then the binary search (with a fix because dev can be uninitialised),
    becomes:

    while (hi > lo) {
       mid = (hi + lo) / 2;

       if (sector < conf->disks[mid].end_sector)
            hi = mid;
       else
            lo = mid + 1;
    }
    return conf->disks + lo;

NeilBrown



