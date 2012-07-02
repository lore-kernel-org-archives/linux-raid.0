From: Alexander Lyakas <alex.bolshoy@gmail.com>
Subject: Re: Question about raid5 disk recovery logic
Date: Mon, 2 Jul 2012 11:32:00 +0300
Message-ID: <CAGRgLy4qyy+_6HG29PxO6gU+iHL7j-hZScHdkFKNs=-5BEJUmw@mail.gmail.com>
References: <CAGRgLy7uJAzTwnuvgXgH=SnKdVBqgPF41eM0N-CYn8bS2BzW9A@mail.gmail.com>
	<20120701180053.504ba439@notabene.brown>
	<CAGRgLy4jdP-ZhiPYMB=-4NYAC7YJsM2nX6SyJcgmMKHpp-FXhQ@mail.gmail.com>
	<20120702074446.3e191fe5@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120702074446.3e191fe5@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Thanks, Neil, for the clear explanation.

Alex.


On Mon, Jul 2, 2012 at 12:44 AM, NeilBrown <neilb@suse.de> wrote:
> On Sun, 1 Jul 2012 16:36:51 +0300 Alexander Lyakas <alex.bolshoy@gmail.com>
> wrote:
>
>> Thanks, Neil!
>> That clarifies.
>>
>> Does this also mean, that when md_do_sync() gets to such
>> already-reconstructed stripe, it might reconstruct it once again,
>> unless the stripe stays in the stripe cache?
>
> Yes, it will reconstruct it, and that might be "again" if the reconstructed
> block has already been written.  If the stripe is still in the cache, I think
> it will still write that block out again, but won't need to reconstruct it.
>
> NeilBrown
>
>
>>
>> Thanks for helping,
>> Alex.
>>
>>
>> On Sun, Jul 1, 2012 at 11:00 AM, NeilBrown <neilb@suse.de> wrote:
>> > On Sun, 1 Jul 2012 10:08:40 +0300 Alexander Lyakas <alex.bolshoy@gmail.com>
>> > wrote:
>> >
>> >> Hi everybody,
>> >> I am trying to understand what happens when raid5 is recovering a
>> >> disk, and a write comes to a stripe that has not been recovered yet.
>> >> Does md first reconstruct the missing chunk and then applies the
>> >> write, or first the write is applied as if the array is still degraded
>> >> (and not recovering), and only later the missing chunk is
>> >> reconstructed (when the md_do_sync() loop gets to this area)?
>> >> I am looking at the stripe handling logic (kernel 2.6.38), can anybody
>> >> pls point me at the path that handle_stripe5() takes in that case?
>> >>
>> >>
>> >
>> > Hi Alex,
>> >
>> >  The stripe is still degraded, so md/raid5 treats it like a write to a
>> >  degraded array.
>> >  Exactly what happens depends one which block is being written.
>> >  If the block being written would be stored on the recovering devices, then
>> >  md will perform a reconstruct-write.  It will read the other data blocks,
>> >  calculate the parity, and write out the parity and the changed data.
>> >  Similarly if the parity block is on the recovering device a
>> >  reconstruct-write will be needed.
>> >  If some other block is being written, md will do a read-modify-write to
>> >  calculate the new parity and then write out the parity and data.  In this
>> >  case the block on the recovering device will not be written.
>> >
>> >  I hope that clarifies the situation.
>> >
>> > NeilBrown
>
