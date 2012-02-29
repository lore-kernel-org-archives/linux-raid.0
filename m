From: Doug Dumitru <doug@easyco.com>
Subject: Re: What are these reads in what should be simply a full-stripe write?
Date: Tue, 28 Feb 2012 21:52:26 -0800
Message-ID: <CAFx4rwSATp6C1ZkWEQbiWS-U78ZUY6bwWy1kknhVUDcZfxVRag@mail.gmail.com>
References: <FC0D60DF-6357-495C-B10A-1C727AAFCBE3@avid.com>
Reply-To: doug@easyco.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <FC0D60DF-6357-495C-B10A-1C727AAFCBE3@avid.com>
Sender: linux-raid-owner@vger.kernel.org
To: John Adams <john.adams@avid.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Mr. Adams,

Raid 5/6 exports a parameter called "optimal_io_size".=A0 You should
find this in /sys/block/mdx/queue/optimal_io_size.

This is the size of a single stripe.=A0 In theory, if you write exactly
this size aligned blocks to raid 5/6, then the stripe cache should
handle the IO perfectly and you should see zero reads.=A0 If you miss
the boundaries, most of the time, raid 5/6 will cache the writes in
the stripe cache and you will still get zero reads.=A0 Unfortunately, a
small percentage of the time, a read/modify/write will get scheduled
in between two inbound write requests.

To make this somewhat more complicated, there is also a limit to how
large a single request can be.=A0 This is limited globally to "#define
BIO_MAX_PAGES 256" or 1MB (as of 3.1.7).=A0 With raid 5/6 arrays, with
64KB chunks, this lets you have 16 active drives.=A0 At least so goes
the theory.=A0 I seem to remember some other limit at 1023 sectors,
which then limits you 511KB or 7 active drives.

If you need to drive this from an application, then the application
has to hit "optimal_io_size" exactly, both in terms of size and
alignment.=A0 You can test this with 'dd'.=A0 If you miss the alignment=
,
then you will get a small number of reads.

If you want to drive this from user space, then O_DIRECT will work.
Ideally, you want multiple outstanding IOs so that the drives can
stream.=A0 This implies AIO (which sucked the last time I tried it), or
else you need to hack something inside of kernel space.

Now why raid 5/6 tends to miss and schedule read/modify/write at
inopportune times seems to just be a design trade-off inside of raid.
I stared at the code for a long time, and never did find any type of
specific timing for how long to wait before scheduling a RMW, so it
looks like you are just at the mercy of where clock ticks happen.

All in all, the raid 5/6 code is really elegant, but it would be nice
if the kernel in general allowed for longer atomic requests.=A0 1MB (or
512KB, or 511KB depending on where you look), is just too short for
some "high bandwidth" application.

Doug Dumitru
EasyCo LLC

On Tue, Feb 28, 2012 at 10:47 AM, John Adams <john.adams@avid.com> wrot=
e:
>
> For some years I've been working on some niche filesystems which serv=
e
> workflows involving lots of video. =A0Lately, I have had occasion to
> investigate the behavior of md as a possible raid solution (2.6.32
> kernel).
>
> As part of that, we looked at some fio based loads in the buffered an=
d
> O_DIRECT cases and noticed some reading that we didn't understand whe=
n
> using O_DIRECT. =A0We were led to this comparision by incorrect
> information from a vendor. (We were trying to repro some reported
> performance and were initially told that O_DIRECT had been used).
>
> We are aware of the problems discussed concerning O_DIRECT. =A0As fs
> guys, we're accustomed to worrying about copies and such, so it wasn'=
t
> immediately obvious to us that O_DIRECT would be a mistake in our
> case. =A0This is essentially an embedded system with a single process
> owning a group of disks with no filesystem. =A0There is no possibilit=
y
> of a race with another process.
>
> Anyway, I am curious about this reading behavior and I would grateful=
 for any
> comments.
>
> I tried writing single stripes under both scenarios. =A0To give the
> barest possible summary. I used a dd command like this with
> oflag=3Ddirect omitted or not. =A0This was driven from a script that
> sets up some blktrace and ftrace things, waits an appropriate time in
> the buffered case etc.
>
> dd oflag=3Ddirect if=3D/dev/zero of=3D/dev/md0 seek=3D0 bs=3D1M count=
=3D1
>
> 8+2 128k strip
>
> [physical disk completions via blkparse]
>
> Buffered:
>
> =A0Reads Completed: =A0 =A0 =A0 =A02, =A0 =A0 =A0 =A05KiB =A0Writes C=
ompleted: =A0 =A0 =A0 =A04, =A0 =A0 =A0258KiB
> =A0Reads Completed: =A0 =A0 =A0 =A00, =A0 =A0 =A0 =A00KiB =A0Writes C=
ompleted: =A0 =A0 =A0 =A03, =A0 =A0 =A0130KiB
> =A0Reads Completed: =A0 =A0 =A0 =A00, =A0 =A0 =A0 =A00KiB =A0Writes C=
ompleted: =A0 =A0 =A0 =A03, =A0 =A0 =A0130KiB
> =A0Reads Completed: =A0 =A0 =A0 =A00, =A0 =A0 =A0 =A00KiB =A0Writes C=
ompleted: =A0 =A0 =A0 =A03, =A0 =A0 =A0130KiB
> =A0Reads Completed: =A0 =A0 =A0 =A00, =A0 =A0 =A0 =A00KiB =A0Writes C=
ompleted: =A0 =A0 =A0 =A03, =A0 =A0 =A0130KiB
> =A0Reads Completed: =A0 =A0 =A0 =A00, =A0 =A0 =A0 =A00KiB =A0Writes C=
ompleted: =A0 =A0 =A0 =A03, =A0 =A0 =A0130KiB
> =A0Reads Completed: =A0 =A0 =A0 =A00, =A0 =A0 =A0 =A00KiB =A0Writes C=
ompleted: =A0 =A0 =A0 =A03, =A0 =A0 =A0130KiB
> =A0Reads Completed: =A0 =A0 =A0 =A00, =A0 =A0 =A0 =A00KiB =A0Writes C=
ompleted: =A0 =A0 =A0 =A03, =A0 =A0 =A0130KiB
> =A0Reads Completed: =A0 =A0 =A0 =A02, =A0 =A0 =A0 =A08KiB =A0Writes C=
ompleted: =A0 =A0 =A0 =A03, =A0 =A0 =A0130KiB
> =A0Reads Completed: =A0 =A0 =A0 =A06, =A0 =A0 =A0 24KiB =A0Writes Com=
pleted: =A0 =A0 =A0 =A04, =A0 =A0 =A0258KiB
>
> Direct Example 1:
>
> =A0Reads Completed: =A0 =A0 =A0 =A02, =A0 =A0 =A0 =A05KiB =A0Writes C=
ompleted: =A0 =A0 =A0 20, =A0 =A0 =A0258KiB
> =A0Reads Completed: =A0 =A0 =A0 =A09, =A0 =A0 =A0 36KiB =A0Writes Com=
pleted: =A0 =A0 =A0 14, =A0 =A0 =A0130KiB
> =A0Reads Completed: =A0 =A0 =A0 32, =A0 =A0 =A0128KiB =A0Writes Compl=
eted: =A0 =A0 =A0 14, =A0 =A0 =A0130KiB
> =A0Reads Completed: =A0 =A0 =A0 =A01, =A0 =A0 =A0 =A04KiB =A0Writes C=
ompleted: =A0 =A0 =A0 16, =A0 =A0 =A0130KiB
> =A0Reads Completed: =A0 =A0 =A0 32, =A0 =A0 =A0128KiB =A0Writes Compl=
eted: =A0 =A0 =A0 12, =A0 =A0 =A0130KiB
> =A0Reads Completed: =A0 =A0 =A0 =A00, =A0 =A0 =A0 =A00KiB =A0Writes C=
ompleted: =A0 =A0 =A0 =A08, =A0 =A0 =A0130KiB
> =A0Reads Completed: =A0 =A0 =A0 =A00, =A0 =A0 =A0 =A00KiB =A0Writes C=
ompleted: =A0 =A0 =A0 =A08, =A0 =A0 =A0130KiB
> =A0Reads Completed: =A0 =A0 =A0 =A00, =A0 =A0 =A0 =A00KiB =A0Writes C=
ompleted: =A0 =A0 =A0 =A08, =A0 =A0 =A0130KiB
> =A0Reads Completed: =A0 =A0 =A0 =A02, =A0 =A0 =A0 =A08KiB =A0Writes C=
ompleted: =A0 =A0 =A0 =A08, =A0 =A0 =A0130KiB
> =A0Reads Completed: =A0 =A0 =A0 =A06, =A0 =A0 =A0 24KiB =A0Writes Com=
pleted: =A0 =A0 =A0 19, =A0 =A0 =A0258KiB
>
> Direct Example 2:
>
> =A0Reads Completed: =A0 =A0 =A0 =A04, =A0 =A0 =A0133KiB =A0Writes Com=
pleted: =A0 =A0 =A0 =A03, =A0 =A0 =A0130KiB
> =A0Reads Completed: =A0 =A0 =A0 11, =A0 =A0 =A0164KiB =A0Writes Compl=
eted: =A0 =A0 =A0 =A03, =A0 =A0 =A0130KiB
> =A0Reads Completed: =A0 =A0 =A0 34, =A0 =A0 =A0256KiB =A0Writes Compl=
eted: =A0 =A0 =A0 =A03, =A0 =A0 =A0130KiB
> =A0Reads Completed: =A0 =A0 =A0 =A02, =A0 =A0 =A0132KiB =A0Writes Com=
pleted: =A0 =A0 =A0 =A03, =A0 =A0 =A0130KiB
> =A0Reads Completed: =A0 =A0 =A0 33, =A0 =A0 =A0256KiB =A0Writes Compl=
eted: =A0 =A0 =A0 =A03, =A0 =A0 =A0130KiB
> =A0Reads Completed: =A0 =A0 =A0 =A03, =A0 =A0 =A0136KiB =A0Writes Com=
pleted: =A0 =A0 =A0 =A03, =A0 =A0 =A0130KiB
> =A0Reads Completed: =A0 =A0 =A0 =A07, =A0 =A0 =A0152KiB =A0Writes Com=
pleted: =A0 =A0 =A0 =A03, =A0 =A0 =A0130KiB
>
>
> I was able to gain a little bit of insight through blktrace and
> ftrace. =A0Our initial assumption was that maybe things were being
> broken up differently such that md thought it needed to do a rmv.
>
> But as I dug into the blktrace output, that did not seem to be the
> case (reads are coming after what is obviously the strip write). =A0I
> used ftrace to show me the path down to md_make_request in the
> O_DIRECT and buffered cases. =A0This showed me some calls refering to
> read_ahead in the direct case.
>
> =A0 =A0 =A0 =A0 =A0 <...>-14859 [001] 510340.525310: md_make_request
> =A0 =A0 =A0 =A0 =A0 <...>-14859 [001] 510340.525311: <stack trace>
> =A0=3D> generic_make_request
> =A0=3D> submit_bio
> =A0=3D> submit_bh
> =A0=3D> block_read_full_page
> =A0=3D> blkdev_readpage
> =A0=3D> __do_page_cache_readahead
> =A0=3D> force_page_cache_readahead
> =A0=3D> page_cache_sync_readahead
>
> So is this read ahead I'm observing? =A0Why does it occur only in the
> direct case?
>
> I noticed that blktrace sometime identifies what I assume to be the
> instigator of the io. =A0So I can sometimes see dd or md_raid6 there.
> As in [dd] or [md0_raid6]:
>
> =A08,16 =A0 1 =A0 =A0 =A0115 =A0 =A0 0.042000000 =A02910 =A0D =A0 W 2=
256 + 48 [md0_raid6]
>
> These unexplained reads either mention blkid or [0] or [(null)].
>
> It isn't clear to me whether the unexpected read behavior is due to a
> tuning problem in the O_DIRECT case or simply the way things work.
>
> Thank you for any comments.--
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html




--
Doug Dumitru
EasyCo LLC
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
