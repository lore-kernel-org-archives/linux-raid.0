From: Dallas Clement <dallas.a.clement@gmail.com>
Subject: Re: best base / worst case RAID 5,6 write speeds
Date: Thu, 10 Dec 2015 18:02:57 -0600
Message-ID: <CAE9DZUR1Nka=5mAB2WQHeFkinO0CzuH_GT1gRiVsuREQfgdGcQ@mail.gmail.com>
References: <CAE9DZUR=uSzYfdqFkVFdyXx+iKb1SeXxo5eX7M_nTw-fnWBwNA@mail.gmail.com>
	<5669DB3B.30101@turmel.org>
	<CAE9DZUSNkLxaKH8MtggW+5_uo38CHRTcscvh7Kk-VTb_zWPQ4g@mail.gmail.com>
	<CAK2H+ednN7dCGzcOt8TxgNdhdDA1mN6Xr5P8vQ+Y=-uRoxRksw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAK2H+ednN7dCGzcOt8TxgNdhdDA1mN6Xr5P8vQ+Y=-uRoxRksw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mark Knecht <markknecht@gmail.com>
Cc: Phil Turmel <philip@turmel.org>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, Dec 10, 2015 at 5:04 PM, Mark Knecht <markknecht@gmail.com> wrote:
>
>
> On Thu, Dec 10, 2015 at 12:09 PM, Dallas Clement
> <dallas.a.clement@gmail.com> wrote:
>>
>> On Thu, Dec 10, 2015 at 2:06 PM, Phil Turmel <philip@turmel.org> wrote:
>> <SNIP>
>> >>
>> >> Could someone please confirm whether these formulas are accurate or
>> >> not?
>> >
>> > Confirm these?  No.  In fact, I see no theoretical basis for stating a
>> > worst case speed as half the best case speed.  Or any other fraction.
>> > It's dependent on numerous variables -- block size, processor load, I/O
>> > bandwidth at various choke points (Northbridge, southbridge, PCI/PCIe,
>> > SATA/SAS channels, port mux...), I/O latency vs. queue depth vs. drive
>> > buffers, sector positioning at block boundaries, drive firmware
>> > housekeeping, etc.
>> >
>> > Where'd you get the worst case formulas?
>> >
>>
>> > Where'd you get the worst case formulas?
>>
>> Google search I'm afraid.  I think the assumption for RAID 5,6 worst
>> case is having to read and write the parity + data every cycle.
>
> What sustained throughput do you get in this system if you skip RAID, set
> up a script and write different data to all 12 drives in parallel? I don't
> think
> you've addressed Phil's comment concerning all the other potential choke
> points in  the system. You'd need to be careful and make sure all the data
> is really out to disk but it might tell you something about your assumptions
> vs what the hardware is really doing..
>
> - Mark

Hi Mark,

> What sustained throughput do you get in this system if you skip RAID, set
> up a script and write different data to all 12 drives in parallel?

Just tried this again, running fio concurrently on all 12 disks.  This
time doing sequential writes, bs=2048k, direct=1 to the raw disk
device - no filesystem.  The results are not encouraging.  I tried to
watch the disk behavior with iostat.  This 8 core xeon system was
really getting crushed.  The load average during the 10 minute test
was 15.16  26.41  21.53.  iostat showed %iowait varying between 40%
and 80%.  Also iostat showed only about 8 of the 12 disks on average
getting CPU time.  They had high near 100% utilization and pretty good
write speed ~160 - 170 MB/s.  Looks like my disks are just too slow
and the CPU cores are stuck waiting for them.
