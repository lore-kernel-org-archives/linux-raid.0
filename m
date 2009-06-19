From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: filesystem stripe parameters
Date: Fri, 19 Jun 2009 13:15:41 +0400
Message-ID: <4A3B573D.5020206@msgid.tls.msk.ru>
References: <7a329d910906181208t2f95d94bsc4eac2c5f20355f5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <7a329d910906181208t2f95d94bsc4eac2c5f20355f5@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Wil Reichert <wil.reichert@gmail.com>
Cc: linux raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Wil Reichert wrote:
> When using LVM on top of RAID 5, is it still worthwhile to pass RAID
> stripe information to the filesystem on creation?  Or do the PE's in
> LVM blur the specific stripe sizes & I'd want to use some multiple of
> those instead?

It's a very good question, especially in context of RAID5.

Yes it is still a good idea to pass that info because it is still a
RAID5 which requires proper treatment wrt unaligned writes and keeping
redundancy.

But the thing is that RAID5 and LVM are not good to each other UNLESS
RAID5 consists of 3, 5 or 9 (or 17 etc) drives -- i.e. 2^N+1, so that
there's 2^N data drives.

This is because LVM can only have blocksize as a power of two and in
order to be useful that blocksize should be a multiple of RAID5 data
row size (stripe size etc).

This is only possible when RAID5 has 2^N data drives or 2^N+1 total
drives.  The same is for RAID4, and for RAID6 it's 2^N+2 since RAID6
has 2 parity drives.

But if you can't match LVM blocksize and RAID strip size, there's
*almost* no point at telling raid parameters to the filesystem: no
matter how hard you'll try, LVM will make the whole thing non-optimal.

Ok, depending on the number of drives, *some* logical volumes will
be properly aligned, but definitely not all of them.  For example
on a 4-drive RAID5 array, only every 3rd volume will be ok, --
provided the volumes are allocated in full one after another,
without holes and fragmentation.

When everything is properly aligned, it's still worth the effort
IMHO to tell the filesystem about true raid properties.

/mjt
