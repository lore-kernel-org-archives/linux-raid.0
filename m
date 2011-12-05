From: Marcus Sorensen <shadowsor@gmail.com>
Subject: Re: RAID1 round robin read support in md?
Date: Sun, 4 Dec 2011 20:13:38 -0700
Message-ID: <CALFpzo7WqkXNF9DcCNJn_D1ZP=Jgpb85u6H=5_KPONQMy7FpYQ@mail.gmail.com>
References: <CAAs5ODuHAE=K-nbd=YuMq-FL33x-22TM2cnmBHud9mEhwuJFOw@mail.gmail.com>
	<CALFpzo48C2-HHgw=iOefdHaAUCwEJfjoiXjq=Ngv62a-0yEpcQ@mail.gmail.com>
	<CAAs5ODv01LE6HRZjteYYsaMF5stTNv-8pdK9JDP18u4QeNGUOQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAAs5ODv01LE6HRZjteYYsaMF5stTNv-8pdK9JDP18u4QeNGUOQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Borg Onion <borg.onion@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Keep forgetting to reply all on these.

Here is my dd test, split ~50/50. Again, one thread will leave half of
each disk idle, as it makes requests serially:

[root@server ~]# dd if=3D/dev/md0 of=3D/dev/null & iostat -xk 1 /dev/sd=
a /dev/sdb
[1] 5293
Linux 2.6.32-71.29.1.el6.x86_64 (server) 	12/04/2011 	_x86_64_	(4 CPU)

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           2.65    0.00    6.67    0.03    0.00   90.65

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s
avgrq-sz avgqu-sz   await  svctm  %util
sdb               0.44     0.44    4.24    9.50   172.99    56.46
33.39     0.07    4.78   2.41   3.31
sda               0.43     0.44    4.26    9.50   173.30    56.46
33.39     0.07    4.81   2.39   3.29

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           6.42    0.00   21.48   22.96    0.00   49.14

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s
avgrq-sz avgqu-sz   await  svctm  %util
sdb            8776.00     0.00  292.00   10.00 36320.00    83.00
241.08     1.07    3.56   1.85  55.90
sda            8080.00     2.00  269.00    0.00 33272.00     0.00
247.38     0.98    3.40   1.81  48.80

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           6.90    0.00   21.67   22.91    0.00   48.52

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s
avgrq-sz avgqu-sz   await  svctm  %util
sdb            6903.00     0.00  231.00   40.00 28288.00    47.00
209.11     2.01    7.41   2.21  59.80
sda            7264.00     1.00  242.00   54.00 30148.00   131.50
204.59     1.64    5.76   1.77  52.50



On Sun, Dec 4, 2011 at 6:42 PM, Borg Onion <borg.onion@gmail.com> wrote=
:
> According to what sar is showing, it only reads from ONE drive. =A0(d=
d
> if=3D... is my test tool). =A0Multi-threaded clients should not drive
> performance in md IO. =A0A large read request can be broken down
> internally to take advantage of round-robin.
>
> --Bart
>
>
> On 4 December 2011 17:11, Marcus Sorensen <shadowsor@gmail.com> wrote=
:
>> Is there a reason to do round robin when it already does simultaneou=
s read
>> from all member devices? Note this is only obvious with a multithrea=
ded
>> benchmark.
>>
>> On Dec 4, 2011 4:31 PM, "Borg Onion" <borg.onion@gmail.com> wrote:
>>>
>>> Hello,
>>>
>>> Is it possible to implement round-robin read support for raid1.c in
>>> md? =A0I sure would appreciate the extra speed given my RAID1x3SSD
>>> setup. =A0A possible algorithm might go like this:
>>>
>>> 1) Given the RAID1 drives are enumerated 0,1,2
>>> 2) For each read request, call an atomic increment
>>> 3) mod the returned value with # of drives (3)
>>> 4) Use the modulus result as the drive # to read from for this oper=
ation
>>>
>>> Part of implementation might look like this:
>>>
>>> uint32_t get_next_read_drive(uint32_t num_drives)
>>> {
>>> =A0 =A0 =A0 =A0static uint32_t op_count;
>>>
>>> =A0 =A0 =A0 =A0return __sync_fetch_and_add(&op_count, 1) % num_driv=
es;
>>> }
>>>
>>> I'm making the assumption that the md code is multi-threaded. =A0Th=
is
>>> implementation won't work on all platforms, others might have to do
>>> some locking. =A0The num_drives and drive list enumeration is assum=
ed to
>>> exclude write-mostly devices. =A0Temporary balancing fairness error=
s
>>> from the num_drives variable changing value (adding or removing of
>>> drives) should be innocuous given these are just read ops on mirror=
ed
>>> data.
>>>
>>> Thoughts?
>>>
>>> --
>>> Borg Onion
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-rai=
d" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.htm=
l
>
>
>
> --
> --Borg Onion
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
