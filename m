From: pg_lxra@lxra.for.sabi.co.UK (Peter Grandi)
Subject: Why are MD block IO requests subject to 'plugging'?
Date: Tue, 25 Mar 2008 12:05:07 +0000
Message-ID: <18408.60019.523141.419772@tree.ty.sabi.co.uk>
References: <18382.54925.354731.996508@tree.ty.sabi.co.UK>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18382.54925.354731.996508@tree.ty.sabi.co.UK>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

[ ... READ10 setup on fast system, poor read rates ... ]

> It was greatly perplexed to find that I could get 250MB/s
> clean when writing, [ ... ]

It seems that this is because the intelligent host adapter would
signal writes completed immediately, so removing the scheduling
from the Linux block IO system, not because the Lonux MD and block
IO subsystems handle writes better than reads, as I tried the
same on another system with slow dumb host adpter and 4 drives
and write performance was  not good.

> Highly perplexing, and then I remembered some people reporting
> that they had to do 'blockdev --setra 65536' to get good
> streaming performance in similar circumstances, and indeed this
> applied to my case too (when set on the '/dev/md0' device).

[ ... ]

>   I noticed that interrupts/s seemed exactly inversely
>   proportional to read ahead, with lots of interrupts/s for
>   small read-head, and few with large read-ahead.

> * Most revealingly, when I used values of read ahead which were
>   powers of 10, the numbers of block/s reported by 'vmstat 1'
>   was also a multiple of that power of 10.

More precisely it seems that the thruput is an exact multiple of
readhead and interrupts per second. For example on a single hard
disk, reading it 32KiB at a time with a read ahead of 1000 512B
sectors:

  soft# blockdev --getra /dev/hda; vmstat 1
  1000
  procs -----------memory---------- ---swap-- -----io---- --system-- --=
---cpu------
   r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us =
sy id wa st
   0  1      0   6304 468292   5652    0    0  1300    66  121   39  0 =
 1 96  3  0
   0  1      0   6328 468320   5668    0    0 41000     0  422  720  0 =
19  0 81  0
   1  1      0   6264 468348   5688    0    0 41500     0  429  731  0 =
14  0 86  0
   1  1      0   6076 468556   5656    0    0 41500     0  427  731  0 =
15  0 85  0
   1  1      0   6012 468584   5660    0    0 41500     0  428  730  0 =
19  0 81  0
   0  1      0   6460 468112   5660    0    0 41016     0  433  730  0 =
16  0 84  0
   0  0      0   6420 468112   5696    0    0    20     0  114   23  0 =
 0 100  0  0
   0  0      0   6420 468112   5696    0    0     0     0  104    9  0 =
 0 100  0  0
   0  0      0   6420 468112   5696    0    0     0     0  103   11  0 =
 0 100  0  0
   0  0      0   6420 468112   5696    0    0     0     0  104    9  0 =
 0 100  0  0

The 'bi' column is in 1KiB blocks, not 512B sectors. It is an
exact multiple of 500 If one looks at the number of ''idle''
interrupts (around 100-110/s) it seems as if there are 410-415
IO interrupts per second and on each exactly 1000 512B sectors
are read. Amazing coincidence!

> * Quite astonishingly, the Linux block device subsystem does
>   not do mailboxing/queueing of IO requests, but turns the
>   read-ahead for the device into a blocking factor, and always
>   issues read requests to the device driver for a strip of N
>   blocks, where N is the read-ahead, then waits for completion
>   of each strip before issuing the next request.

Indeed, and I have noticed that the number of interrupts/s per MiB
of read rate varies considerably as one changes the read-ahead
size, so I started suspecting some really dumb logic. But it does
not seem to affect physical block devices that much, as despite it
they still seem to be able to issue back-to-back requests to the
host adapter, even if excessively quantized; but it seems to
affect MD a lot.

Another interesting detail is that while real disk devices have
queueing parameter and MD device don't:

  # ls /sys/block/{md0,hda}/queue
  ls: cannot access /sys/block/md0/queue: No such file or directory
  /sys/block/hda/queue:
  iosched  max_hw_sectors_kb  max_sectors_kb  nr_requests  read_ahead_k=
b  scheduler

As one can set 'blockdev --setra' on an MD device (which should be
the same as setting 'queue/read_head_kb' to half the value), and
that does have an effect, but then the readhead on all the block
devices in the MD array are ignored.

Anbother interesting detail is that in my usual setup I get 50MB/s
with a read-ahead of 64, 250MB/s with 128, and 50MB/s with 256,
which strongly suggests some "resonance" at work between
quantization factors.

So I started digging around for the obvious: some scheme for
quantizing/batching requests in the block IO subsystem, and indeed
if one looks at the details of the ''plugging'' logic:

http://www.gelato.unsw.edu.au/lxr/source/block/ll_rw_blk.c#L1605

=C2=AB* generic_unplug_device - fire a request queue
 * @q:    The &struct request_queue in question
 *
 * Description:
 *   Linux uses plugging to build bigger requests queues before letting
 *   the device have at them. If a queue is plugged, the I/O scheduler
 *   is still adding and merging requests on the queue. Once the queue
 *   gets unplugged, the request_fn defined for the queue is invoked an=
d
 *   transfers started.=C2=BB

and reads further confessions here:

http://www.linuxsymposium.org/proceedings/reprints/Reprint-Axboe-OLS200=
4.pdf

 =C2=ABFor the longest time, the Linux block layer has used a
  technique dubbed plugging to increase IO throughput. In its
  simplicity, plugging works sort of like the plug in your tub
  drain=E2=80=94when IO is queued on an initially empty queue, the queu=
e
  is plugged.
  Only when someone asks for the completion of some of the queued
  IO is the plug yanked out, and io is allowed to drain from the
  queue. So instead of submitting the =EF=AC=81rst immediately to the
  driver, the block layer allows a small buildup of requests.
  There=E2=80=99s nothing wrong with the principle of plugging, and it
  has been shown to work well for a number of workloads.=C2=BB

BTW, this statement is a naive advocacy for a gross impropriety,
as it is absolutely only the business of the device-specific part
of IO (e.g. the host adapter driver) how to translate logical IO
requests into physical IO requests, whether coalescing or even
splitting them is good, and there is amazingly little
justification for rearranging a stream of logical IO requests
at the logical IO level.

Conversely, quite properly elevators (another request stream
restructuring) apply to physical devices, not to partitions or MD
devices, and one can have different elevators on different devices
(even if having them different for MD slave devices in most cases
is very dubious).

 =C2=AB2.6 also contains some additional logic to unplug a given queue
  once it reaches the point where waiting longer doesn=E2=80=99t make m=
uch
  sense. So where 2.4 will always wait for an explicit unplug, 2.6
  can trigger an unplug when one of two conditions are met:

  1. The number of queued requests reach a certain limit,
     q->unplug_thresh. This is device tweak able and defaults to 4.

It not only defaults to 4, it is 4, as it is never changed from
the default:

  $ pwd
  /usr/local/src/linux-2.6.23
  $ find * -name '*.[ch]' | xargs egrep unplug_thresh
  block/elevator.c:               if (nrq >=3D q->unplug_thresh)
  block/ll_rw_blk.c:      q->unplug_thresh =3D 4;           /* hmm */
  include/linux/blkdev.h: int                     unplug_thresh;  /* Af=
ter this many requests */

But more ominously, there is some (allegedly rarely triggered)
timeout on unplugging a plugged queue:

 =C2=AB2. When the queue has been idle for q-> unplug_delay. Also
     device tweak able, and defaults to 3 milliseconds.

  The idea is that once a certain number of requests have
  accumulated in the queue, it doesn=E2=80=99t make much sense to
  continue waiting for more=E2=80=94there is already an adequate number
  available to keep the disk happy. The time limit is really a
  last resort, and should rarely trigger in real life.

  Observations on various work loads have verified this. More
  than a handful or two timer unplugs per minute usually
  indicates a kernel bug.=C2=BB

So I had a look at how the MD subsystem handles unplugging,
because of a terrible suspicion that it does two-level
unplugging, and wonder what:

http://www.gelato.unsw.edu.au/lxr/source/drivers/md/raid10.c#L599

  static void raid10_unplug(struct request_queue *q)
  {
	  mddev_t *mddev =3D q->queuedata;

	  unplug_slaves(q->queuedata);
	  md_wakeup_thread(mddev->thread);
  }

Can some MD developer justify the lines above?

Can some MD developer also explain why should MD engage in double
level request queueing/unplugging at both the MD and slave level?

Can some MD developer then give some very good reason why the MD
layer should be subject to plugging *at all*?

This before I spend a bit of time doing a bit of 'blktrace' work
to see how unplugging "helps" MD and perhaps setting 'unplug_thresh'
globally to 1 "just for fun" :-).
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
