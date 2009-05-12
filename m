From: Neil Brown <neilb@suse.de>
Subject: Re: raid0 hashing funtion
Date: Wed, 13 May 2009 08:12:44 +1000
Message-ID: <18953.62556.265428.572219@notabene.brown>
References: <5d96567b0905030629s3e1ec55coa9f0fc5fb0a3ce2b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Raz on Sunday May 3
Sender: linux-raid-owner@vger.kernel.org
To: Raz <raziebe@gmail.com>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sunday May 3, raziebe@gmail.com wrote:
> Neil Hello
> I am reading the raid0 code, and I do not understand what is the
> rational behind this hashing and spacing ?
> I am asking because I am working on the chunk size restrictions.
> in raid0_make_request the zone calculation is as follows:
> 
>       {
>               sector_t x = sector >> conf->sector_shift;
>               sector_div(x, (u32)conf->spacing);
>               zone = conf->hash_table[x];
>       }
>         while (sector >= zone->zone_start + zone->sectors)
>                 zone++;
> 
> I replaced it with the code :
>         zone = &conf->strip_zone[0];
>         while (sector >= zone->zone_start + zone->sectors)
>                 zone++;
> and all is fine .  why do we need the hashing/spacing complication ?
> thank you
> raz

(Sorry for the delay in replying).

The existence of the hashing function predates my involvement with md.

As I understand it, the purpose was do perform the lookup as fast as
possible.  Rather than search through a list, just go straight to the
correct point in the list.

The original code did not have the "while ... zone++".  It just has a
simple "if" - either the right location was "this" one or the next
one, based on a similar test.
I added the while when I changed the hash_table to use kmalloc rather
than vmalloc.  In order to ensure the hash table never exceeded one
page, I had to allow that occasionally we had to probe more than one
location in the table.  Hence the 'while'.

On reflection, I am not convinced that the hash really does add value.
You cannot have more entries in the list than there are drives, and
you usually have much fewer.
Given that consecutive entries in the list are likely to be in the
same cache line, and the hash_table is in a totally different page,
probing 3 or 4 locations in the list is probably faster than doing a
lookup in the hash table.
And as we would be able to get rid of that sector_div, we would
probably get even more saving.

The only cost would be if someone had a raid0 with lots of devices all
of very different sizes.  I suspect that case does not need to be
optimised for.
So I would probably be happy to accept a patch which removed that hash
table.

NeilBrown
