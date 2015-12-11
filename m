From: Dallas Clement <dallas.a.clement@gmail.com>
Subject: Re: best base / worst case RAID 5,6 write speeds
Date: Thu, 10 Dec 2015 18:41:40 -0600
Message-ID: <CAE9DZUQ+LOFWNQ2MpKoSx8j8RHVqkL15PO+jVjs7EkCQykG6VA@mail.gmail.com>
References: <CAE9DZUR=uSzYfdqFkVFdyXx+iKb1SeXxo5eX7M_nTw-fnWBwNA@mail.gmail.com>
	<5669DB3B.30101@turmel.org>
	<CAE9DZUSNkLxaKH8MtggW+5_uo38CHRTcscvh7Kk-VTb_zWPQ4g@mail.gmail.com>
	<CAK2H+ednN7dCGzcOt8TxgNdhdDA1mN6Xr5P8vQ+Y=-uRoxRksw@mail.gmail.com>
	<CAE9DZUR1Nka=5mAB2WQHeFkinO0CzuH_GT1gRiVsuREQfgdGcQ@mail.gmail.com>
	<CAK2H+efF2dM1BsM7kzfTxMdQEHvbWRaVe7zJLTGcPZzafn2M6A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAK2H+efF2dM1BsM7kzfTxMdQEHvbWRaVe7zJLTGcPZzafn2M6A@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mark Knecht <markknecht@gmail.com>
Cc: Phil Turmel <philip@turmel.org>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, Dec 10, 2015 at 6:22 PM, Mark Knecht <markknecht@gmail.com> wrote:
>
>
> On Thu, Dec 10, 2015 at 4:02 PM, Dallas Clement <dallas.a.clement@gmail.com>
> wrote:
>>
>> On Thu, Dec 10, 2015 at 5:04 PM, Mark Knecht <markknecht@gmail.com> wrote:
> <SNIP>
>>
>> Hi Mark,
>>
>> > What sustained throughput do you get in this system if you skip RAID,
>> > set
>> > up a script and write different data to all 12 drives in parallel?
>>
>> Just tried this again, running fio concurrently on all 12 disks.  This
>> time doing sequential writes, bs=2048k, direct=1 to the raw disk
>> device - no filesystem.  The results are not encouraging.  I tried to
>> watch the disk behavior with iostat.  This 8 core xeon system was
>> really getting crushed.  The load average during the 10 minute test
>> was 15.16  26.41  21.53.  iostat showed %iowait varying between 40%
>> and 80%.  Also iostat showed only about 8 of the 12 disks on average
>> getting CPU time.  They had high near 100% utilization and pretty good
>> write speed ~160 - 170 MB/s.  Looks like my disks are just too slow
>> and the CPU cores are stuck waiting for them.
>
> Well, it was hard on the system but it might not be a total loss. I'm not
> saying this is a good test but it might give you some ideas about how to
> proceed. Fewer drives? Better controller?
>
> Was it any different at the front and back of the drive?
>
> One thing I didn't see in this thread was a check to make sure your
> alignment is on the physical sector alignment if you're using 4K sectors
> which I assume drives this large are using.
>
> Anyway, data is just data. It gives you something to think about.
>
> Good luck,
> Mark

Hi Mark.  Perhaps this is normal behavior when there are more disks to
be served than there are CPUs.  But it surely does seem like a waste
for the CPUs to be locked up in uninterruptible sleep waiting for I/O
on these disks.  I presume this is caused by threads in the kernel
tied up in spin loops waiting for I/O.  It would sure be nice if the
I/O could be handled in a more asynchronous way so that these CPUs can
go off and do other things while they are waiting for I/Os to complete
on slow disks.

> Was it any different at the front and back of the drive?

Didn't try on this particular test.

> One thing I didn't see in this thread was a check to make sure your
> alignment is on the physical sector alignment if you're using 4K sectors
> which I assume drives this large are using.

Yes, these drives surely use 4K sectors.  But I haven't checked for
sector alignment issues.  Any tips on how to do that?
