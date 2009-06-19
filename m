From: Justin Perreault <justinperreault@dl-jp.com>
Subject: Re: filesystem stripe parameters
Date: Fri, 19 Jun 2009 21:59:02 +0100
Message-ID: <1245445142.18616.33.camel@Gecko.local>
References: <7a329d910906181208t2f95d94bsc4eac2c5f20355f5@mail.gmail.com>
	 <4A3B573D.5020206@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4A3B573D.5020206@msgid.tls.msk.ru>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Wil Reichert <wil.reichert@gmail.com>, linux raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Still learning, please be gentle.

On Fri, 2009-06-19 at 13:15 +0400, Michael Tokarev wrote:
> Wil Reichert wrote:
> > When using LVM on top of RAID 5, is it still worthwhile to pass RAID
> > stripe information to the filesystem on creation?  Or do the PE's in
> > LVM blur the specific stripe sizes & I'd want to use some multiple of
> > those instead?
> Yes it is still a good idea to pass that info because it is still a
> RAID5 which requires proper treatment wrt unaligned writes and keeping
> redundancy.
> 
> But the thing is that RAID5 and LVM are not good to each other UNLESS
> RAID5 consists of 3, 5 or 9 (or 17 etc) drives -- i.e. 2^N+1, so that
> there's 2^N data drives.
> 
> This is because LVM can only have blocksize as a power of two and in
> order to be useful that blocksize should be a multiple of RAID5 data
> row size (stripe size etc).
> 
> This is only possible when RAID5 has 2^N data drives or 2^N+1 total
> drives.  The same is for RAID4, and for RAID6 it's 2^N+2 since RAID6
> has 2 parity drives.
> 
> But if you can't match LVM blocksize and RAID strip size, there's
> *almost* no point at telling raid parameters to the filesystem: no
> matter how hard you'll try, LVM will make the whole thing non-optimal.

2.5 questions:

1) Will this same issue affect a 5+0 raid array?

2) It is inferred that one can choose to not tell the filesystem the
raid parameters, what negative effect does not doing it have?
Conversely, what is the positive effect does doing it have?

Thanks,
Justin



