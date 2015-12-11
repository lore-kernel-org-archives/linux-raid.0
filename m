From: Dallas Clement <dallas.a.clement@gmail.com>
Subject: Re: best base / worst case RAID 5,6 write speeds
Date: Fri, 11 Dec 2015 09:44:06 -0600
Message-ID: <CAE9DZURK+bZ=4czbGojzW815Du1ascr5vzAPtQBw4ZDGyq0MAQ@mail.gmail.com>
References: <CAE9DZUR=uSzYfdqFkVFdyXx+iKb1SeXxo5eX7M_nTw-fnWBwNA@mail.gmail.com>
	<5669DB3B.30101@turmel.org>
	<CAE9DZUSNkLxaKH8MtggW+5_uo38CHRTcscvh7Kk-VTb_zWPQ4g@mail.gmail.com>
	<CAK2H+ednN7dCGzcOt8TxgNdhdDA1mN6Xr5P8vQ+Y=-uRoxRksw@mail.gmail.com>
	<CAE9DZUR1Nka=5mAB2WQHeFkinO0CzuH_GT1gRiVsuREQfgdGcQ@mail.gmail.com>
	<CAK2H+efF2dM1BsM7kzfTxMdQEHvbWRaVe7zJLTGcPZzafn2M6A@mail.gmail.com>
	<CAE9DZUQ+LOFWNQ2MpKoSx8j8RHVqkL15PO+jVjs7EkCQykG6VA@mail.gmail.com>
	<CAE9DZUQo4CojhuVkQ6y=gTEWG5qUkeu57wcZsqbXZtGD_V5JCQ@mail.gmail.com>
	<CAK2H+ec-zMbhxoFyHXLkdM-z-9cYYzNbPFhn19XjTHqrOMDZKQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAK2H+ec-zMbhxoFyHXLkdM-z-9cYYzNbPFhn19XjTHqrOMDZKQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mark Knecht <markknecht@gmail.com>
Cc: Phil Turmel <philip@turmel.org>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, Dec 10, 2015 at 8:50 PM, Mark Knecht <markknecht@gmail.com> wrote:
>
>
> On Thu, Dec 10, 2015 at 5:19 PM, Dallas Clement <dallas.a.clement@gmail.com>
> wrote:
>>
>> <SNIP>
>> >> One thing I didn't see in this thread was a check to make sure your
>> >> alignment is on the physical sector alignment if you're using 4K
>> >> sectors
>> >> which I assume drives this large are using.
>> >
>> > Yes, these drives surely use 4K sectors.  But I haven't checked for
>> > sector alignment issues.  Any tips on how to do that?
>>
>> According to parted, my disk partition is aligned.
>>
>> (parted) align-check
>> alignment type(min/opt)  [optimal]/minimal?
>> Partition number? 6
>> 6 aligned
>>
>> Partition Table: gpt
>>
>> Number  Start      End          Size         File system  Name     Flags
>>  1      2048s      10002431s    10000384s                 primary
>>  2      10002432s  42002431s    32000000s                 primary
>>  3      42002432s  42004479s    2048s                     primary
>> bios_grub
>>  4      42004480s  42006527s    2048s                     primary
>>  5      42006528s  50008063s    8001536s                  primary
>> > 6      50008064s  7796883455s  7746875392s               primary
>>
>> 50008064 / 4096 = 12209
>
> I think you want to divide by 8 as 8*512 = 4096 but you're likely ok
> on all of them. Partitioning tools are better about that these days.
>
> Looking back I didn't see what sort of controller/s you have all these
> drives attached to. If you're spinning in IO loops then it could be a
> driver issue.
>
> I would suggest googling for causes of iowait cycles and post
> back additional questions.
>
> Good luck,
> Mark

Hi Mark.  I have three different controllers on this motherboard.  A
Marvell 9485 controls 8 of the disks.  And an Intel Cougar Point
controls the 4 remaining disks.

> If you're spinning in IO loops then it could be a driver issue.

It sure is looking like that.  I will try to profile the kernel
threads today and maybe use blktrace as Phil recommended to see what
is going on there.

This is pretty sad that 12 single threaded fio jobs can bring this
system to its knees.
