From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: Growing a single disk into a 2 disk raid0
Date: Fri, 28 Jan 2011 13:29:21 -0500
Message-ID: <4D430B01.6040606@cfl.rr.com>
References: <4D42FA3E.6000206@cfl.rr.com> <4D4302B6.2090208@panix.com> <4D430794.60101@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D430794.60101@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: Berkey B Walker <berk@panix.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 1/28/2011 1:14 PM, John Robinson wrote:
> At the moment, mdadm doesn't support reshaping RAID-0 and RAID-10,
> though if you've been following the many posts/patches from the Intel
> guys, you'll know it's coming in mdadm 3.2.

Ahh, I will keep my eyes out for that and hopefully it will also enable
creating a single disk raid0 initially, then reshape.

> Anything involving mirroring (RAID-1 or RAID-10) isn't going to expand
> the available storage space; you've only got two discs, so the second
> will be consumed by a mirror of the first.

This is true for raid-1, but not raid-10.  If you add a disk to a
raid-10 then the majority of its space will be added to the capacity of
the array if you do not increase the number of duplicate copies ( i.e.
leave n=2 as it defaults to ).

> the second disc onto the first one. (Actually there is a cunning third
> option: shrink the filesystem a little and create the array with
> metadata at the end, but I'd be very VERY wary of doing this on data of

That is what I was trying to do, and had no trouble converting a plain
partition into an mdadm managed one using that technique, but then ran
into the problems I stated originally.

> any value.) I think I'd use LVM instead (multiple PVs in a VG usable by
> one LV) though it has the same problems with what to do with metadata.

Unfortunately that isn't an option if you aren't already using LVM,
though figuring out how to upgrade a plain disk to LVM is another
interesting problem.

> If you want some redundancy as well as more storage space, you need more
> discs.

The idea here was to get more storage and speed by converting to raid-0,
but without data loss.
