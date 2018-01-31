From: mostafa kishani <mostafa.kishani@gmail.com>
Subject: Re: Implementing Global Parity Codes
Date: Wed, 31 Jan 2018 19:33:54 +0330
Message-ID: <CACm9mdU_Ljdxy1bTp3qBpD4EeeVteA0qBiep+9_=_1bWoxdXjg@mail.gmail.com>
References: <CACm9mdUJLczo8zSB5UfU9Fd_6VK3+sGCYJYdaEaX0qW1cMLtYA@mail.gmail.com>
 <5A6C3A43.6030701@youngman.org.uk> <CACm9mdWs0d+Fo32AQ3prMuJhfsmECK2jBw-0O7D-KR=LNWtyvw@mail.gmail.com>
 <5A6C972C.8070401@youngman.org.uk> <bcd4cf40-dba6-1c52-ab8a-6884290215fa@hesbynett.no>
 <CACm9mdV4pjCLcPmmVRmwsXACoSZCUe7pCvwXBSTnhX5mH9kCVg@mail.gmail.com> <5A708BCD.10205@hesbynett.no>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5A708BCD.10205@hesbynett.no>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david.brown@hesbynett.no>
Cc: Wols Lists <antlists@youngman.org.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Yes that's exactly what the code does. Here the math of
encoding/decoding is not as important of IO overhead. Upon a stripe
update, it needs to update the Global parity as well (that is probably
in another stripe). This should result in a terrible performance in
random-write workloads. But in sequential-write workloads this code
may have a performance near to RAID5 and slightly better than RAID6.
The 2D codes (as you suggested) also suffer a huge IO penalty and this
is why the're barely employed even is fast memory structure such as
SRAM/DRAM.

Bests,
Mostafa

On Tue, Jan 30, 2018 at 6:44 PM, David Brown <david.brown@hesbynett.no> wrote:
> On 30/01/18 12:30, mostafa kishani wrote:
>> David what you pointed about employment of PMDS codes is correct. We
>> have no access to what happens in the SSD firmware (such as FTL). But
>> why this code cannot be implemented in the software layer (similar to
>> RAID5/6...) ? I also thank you for pointing out very interesting
>> subjects.
>>
>
> I must admit that I haven't dug through the mathematical details of the
> paper.  It looks to be at a level that I /could/ understand, but would
> need to put in quite a bit of time and effort.  And the paper does not
> strike me as being particularly outstanding or special - there are many,
> many such papers published about new ideas in error detection and
> correction.
>
> While it is not clear to me exactly how these additional "global" parity
> blocks are intended to help correct errors in the paper, I can see a way
> to handle it.
>
> d d d d d P
> d d d d d P
> d d d d d P
> d d d S S P
>
> Where the "d" blocks are normal data blocks, "P" are raid-5 parity
> blocks (another column for raid-6 Q blocks could be added), and "S" are
> these "global" parity blocks.
>
> If a row has more errors than the normal parity block(s) can correct,
> then it is possible to use wider parity blocks to help.  If you have one
> S that is defined in the same way as raid-6 Q parity, then it can be
> used to correct an extra error in a stripe.  That relies on all the
> other stripes having at most P-correctable errors.
>
> The maths gets quite hairy.  Two parity blocks are well-defined at the
> moment - raid-5 (xor) and raid-6 (using powers of 2 weights on the data
> blocks, over GF(8)).  To provide recovery here, the S parities would
> have to fit within the same scheme.  A third parity block is relatively
> easy to calculate using powers of 4 weights - but that is not scalable
> (a fourth parity using powers of 8 does not work beyond 21 data blocks).
>  An alternative multi-parity scheme is possible using significantly more
> complex maths.
>
> However it is done, it would be hard.  I am also not convinced that it
> would work for extra errors distributed throughout the block, rather
> than just in one row.
>
> A much simpler system could be done using vertical parities:
>
> d d d d d P
> d d d d d P
> d d d d d P
> V V V V V P
>
> Here, the V is just a raid-5 parity of the column of blocks.  You now
> effectively have a raid-5-5 layered setup, but distributed within the
> one set of disks.  Recovery would be straight-forward - if a block could
> not be re-created from a horizontal parity, then the vertical parity
> would be used.  You would have some write amplification, but it would
> perhaps not be too bad (you could have many rows per vertical parity
> block), and it would be fine for read-mostly applications.  It bears a
> certain resemblance to raid-10 layouts.  Of course, raid-5-6, raid-6-5
> and raid-6-6 would also be possible.
>
>
>>>
>>> Other things to consider on big arrays are redundancy of controllers, or
>>> even servers (for SAN arrays).  Consider the pros and cons of spreading your
>>> redundancy across blocks.  For example, if your server has two controllers
>>> then you might want your low-level block to be Raid-1 pairs with one disk on
>>> each controller.  That could give you a better spread of bandwidths and give
>>> you resistance to a broken controller.
>>>
>>> You could also talk about asymmetric raid setups, such as having a
>>> write-only redundant copy on a second server over a network, or as a cheap
>>> hard disk copy of your fast SSDs.
>>>
>>> And you could also discuss strategies for disk replacement - after failures,
>>> or for growing the array.
>>
>> The disk replacement strategy has a significant effect on both
>> reliability and performance. The occurrence of human errors in desk
>> replacement can result in data unavailability and data loss. In the
>> following paper I've briefly discussed this subject and how a good
>> disk replacement policy can improve reliability by orders of magnitude
>> (a more detailed version of this paper is on the way!):
>> https://dl.acm.org/citation.cfm?id=3130452
>
> In my experience, human error leads to more data loss than mechanical
> errors - and you really need to take it into account.
>
>>
>> you can download it using sci-hub if you don't have ACM access.
>>
>>>
>>> It is also worth emphasising that RAID is /not/ a backup solution - that
>>> cannot be said often enough!
>>>
>>> Discuss failure recovery - how to find and remove bad disks, how to deal
>>> with recovering disks from a different machine after the first one has died,
>>> etc.  Emphasise the importance of labelling disks in your machines and being
>>> sure you pull the right disk!
>>
>> I really appreciate if you can share your experience about pulling
>> wrong disk and any statistics. This is an interesting subject to
>> discuss.
>>
>
> My server systems are too small in size, and too few in numbers, for
> statistics.  I haven't actually pulled the wrong disk, but I did come
> /very/ close before deciding to have one last double-check.
>
> I have also tripped over the USB wire to an external disk and thrown it
> across the room - I am now a lot more careful about draping wires around!
>
>
> mvh.,
>
> David
>
