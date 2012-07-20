From: Jaromir Capik <jcapik@redhat.com>
Subject: Re: [RFE] Please, add optional RAID1 feature (= chunk checksums) to make it more robust
Date: Fri, 20 Jul 2012 07:07:32 -0400 (EDT)
Message-ID: <c4ee4468-579c-4bc3-acd3-c487bebfe35d@zmail15.collab.prod.int.phx2.redhat.com>
References: <5006E44B.50402@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5006E44B.50402@shiftmail.org>
Sender: linux-raid-owner@vger.kernel.org
To: Asdo <asdo@shiftmail.org>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> This is a very invasive change that you ask, conceptually,
> man-hours-wise, performance-wise, ondisk-format wise, space-wise

Yes ... I'm aware of possibly high number of man-hours.
If we talk about space ... 0.78% is not so invasive, is it?
On-disk format ... interleaving chunks with checksum sectors doesn't
seem to me a complicated math ... 

  chunk_starting_sector = chunk_number * (chunk_size_in_sectors + 1)

... of course this is relative to the chunk area offset.

> also it really should stay at another layer, preferably below the
> RAID

but how would you like to implement that if the lower level is known
to be unreliable enough?

> (btrfs and zfs do this above though). 

Btrfs and zfs has it's own RAID layer, so there's no need for
underlying MD-RAID. But I haven't studied how exactly it's done
there.

> This should probably be a
> DM/LVM
> project.

LVM ? How do you want to implement that in LVM? You would create
two big PVs with two big logical partitions protected by checksums?
The mdraid layer would be built on top of these, right? 
That could possibly work too if LVM returns read errors for blocks
with incorrect checksums. I'm not fully against that idea.

> 
> Drives do this already, they have checksums (google for
> reed-solomon).
> If the checksums are not long enough you should use different drives.
> But in my life I never saw a "silent data corruption" like the one
> you say.

I believe I've mentioned my experience with such nasty HDD behaviour
in my previous email. I also don't like that, but it apparently
happens and we can't rely on the proper hardware functioning
especially when it's unreliable by nature.

Regards,
Jaromir.
