From: Daniel Pittman <daniel@rimspace.net>
Subject: Re: endianness of Linux kernel RAID
Date: Thu, 04 Aug 2005 17:20:35 +1000
Message-ID: <87y87if9rw.fsf@rimspace.net>
References: <20050803120656.GA16696@anthropohedron.net>
	<17137.42015.808716.889138@cse.unsw.edu.au>
	<17137.47596.652834.79165@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown <neilb@cse.unsw.edu.au> writes:
> On Thursday August 4, neilb@cse.unsw.edu.au wrote:
>> 
>> Oopps....
>> I meant to send the following in reply to a recent message from
>> Gregory Seidman, but inadvertently send it in reply to an earlier
>> message from Aaron Botsis (which I must have missed..)
>> 
>> Still, the offer is open to either, or anyone else.
>
> I decided to try it anyway...
>
> The following patch, when applied to mdadm-2.0-devel-3 (Recently
> released) should allow:
>
>   mdadm --examine --metadata=0.swap /dev/sda1
>
> which will show the superblock with bytes swapped.  If that looks right for
> all devices, then
>
>   mdadm --assemble /dev/mdX --update=byteorder /dev/sda1 /dev/sdb1 ...
>
> will assemble the array after swapping the byte order on all devices.
> Once it has been assembled this way, the superblocks will have the
> correct byte order, and in future the array can be assembled in the
> normal way.
>
> Feedback would be very welcome.

If I read your notes correctly, it should be possible to determine that
this is (or isn't) a byte-swapped v0 superblock by checking for the
byte-swapped magic number, right?

In that case, I think it would be good to have --update=byteorder refuse
to work if that magic number check either wasn't the byte-swapped
variant.

Adding a 'force' or something to bypass the check if you *really* want
to seems reasonable-ish.

That would make it just that little bit harder to accidentally byte-swap
a superblock when you shouldn't have done so.

  Daniel


