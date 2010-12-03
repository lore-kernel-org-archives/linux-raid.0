From: Phil Karn <karn@ka9q.net>
Subject: Re: RAID-5 implementation questions
Date: Fri, 03 Dec 2010 04:02:23 -0800
Message-ID: <4CF8DC4F.4020206@ka9q.net>
References: <4CF8AF30.5070505@ka9q.net> <alpine.DEB.1.10.1012031057070.9121@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.1012031057070.9121@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 12/3/10 2:02 AM, Mikael Abrahamsson wrote:

> "--assume-clean".

Thanks.

> Some raid implementations won't read/write to all drives, but might
> instead read the block being written to, and the parity block, then
> write the new block and recalculate the parity, thus not read/writing to
> all blocks. If this is the case, if the parity is wrong, it'll still be
> wrong after the operation, thus you don't have any redundancy.

Good point. That had occurred to me too but I didn't know if Linux did
that. I can see how one might dynamically pick one way or the other
depending on how much of the stripe is already in the buffer cache.

> Doing a rebuild when creating the array is something I'd only skip if I
> was doing lab work, never in production. I use raid for redundancy, thus
> I want to make sure everything is ok and it doesn't matter to me if it
> takes half a day.

I hear you. But I think an important special case is when you're
initially loading a new RAID-5 array from an existing (typically
smaller) file system that will then be replaced by the new array.

Why not let the new array work something like a RAID-0, leaving the
parity blocks unwritten until you're finished loading the array? Then
pass through the array writing all the parity blocks with the final
data. If a drive fails in the new array before you're done, you still
have all your original data; you haven't lost anything.

Ultimately, RAID-5 in software is always going to be at least somewhat
vulnerable because of the lack of an atomic (all or none) committed
write of all the blocks in a stripe. This might silently corrupt an old,
stable file in a way that you won't notice until a drive fails and you
don't have the redundancy you thought you had to reconstruct it. can
accept losing whatever files I was writing at the time of a crash, but
silent corruption of an old and stable file seems far more insidious. I
do periodically run checkarray to ensure that the parities are
consistent, but this takes a long time and seems inelegant somehow.
Maybe we need software ECC on all data so that one doesn't have to rely
on the drive itself to detect errors.

Thanks,

Phil
