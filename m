From: Alexander Lyakas <alex.bolshoy@gmail.com>
Subject: md/raid5: raid5d livelocks after drive failure during resync
Date: Thu, 18 Jul 2013 13:59:29 +0300
Message-ID: <CAGRgLy7GoknqbUSYFk82FnuNVBkvznqZZF7+FK1L3kPq7_C6wQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>, linux-raid <linux-raid@vger.kernel.org>
Cc: yair@zadarastorage.com, Shyam Kaushik <shyam@zadarastorage.com>, vladimir@zadarastorage.com
List-Id: linux-raid.ids

Hello Neil,
we have a 3-drive raid5, that was resyncing, but then one drive
failed. As a result, now raid5 is livelocked on 100% cpu, and the
failed drive is not ejected from the array.
Kernel is ubuntu-precise 3.2.0-25 40 plus following patches applied manually:

commit fab363b5ff502d1b39ddcfec04271f5858d9f26e
Author: Shaohua Li <shli <at> kernel.org>
Date:   Tue Jul 3 15:57:19 2012 +1000
    raid5: delayed stripe fix

and

commit a7854487cd7128a30a7f4f5259de9f67d5efb95f
Author: Alexander Lyakas <alex.bolshoy@gmail.com>
Date:   Thu Oct 11 13:50:12 2012 +1100
    md: When RAID5 is dirty, force reconstruct-write instead of
read-modify-write.

/proc/mdstat shows:

Personalities : [raid1] [raid6] [raid5] [raid4]
md2 : active raid5 dm-5[0] dm-7[2](F) dm-6[1]
      7809200128 blocks super 1.2 level 5, 64k chunk, algorithm 2 [3/2] [UU_]
        resync=PENDING
      bitmap: 29/30 pages [116KB], 65536KB chunk

From the patches applied to that kernel above our version, the
following seems somewhat relevant:

cc1ceee md/raid5: In ops_run_io, inc nr_pending before calling
md_wait_for_blocked_rdev

but in our case badblocks are disabled.
(original conversation is in http://www.spinics.net/lists/raid/msg39191.html).

Here are some stacks that we captured and appropriate places in the code:

[] __cond_resched+0x2a/0x40
[] handle_stripe+0x400/0x1d80 [raid456]
[] raid5d+0x463/0x650 [raid456]
[] md_thread+0x10e/0x140
[] kthread+0x8c/0xa0
[] kernel_thread_helper+0x4/0x10
[] 0xffffffffffffffff
0x59e0 is in handle_stripe
(/mnt/work/alex/Ubuntu-3.2.0-25.40/drivers/md/raid5.c:495).
490             struct r5conf *conf = sh->raid_conf;
491             int i, disks = sh->disks;
492
493             might_sleep();
494
495             for (i = disks; i--; ) {
496                     int rw;
497                     struct bio *bi;
498                     struct md_rdev *rdev;
499                     if (test_and_clear_bit(R5_Wantwrite,
&sh->dev[i].flags)) {

[] __cond_resched+0x2a/0x40
[] raid5d+0x470/0x650 [raid456]
[] md_thread+0x10e/0x140
[] kthread+0x8c/0xa0
[] kernel_thread_helper+0x4/0x10
[] 0xffffffffffffffff
0x8d80 is in raid5d (/mnt/work/alex/Ubuntu-3.2.0-25.40/drivers/md/raid5.c:4306).
4301                    handled++;
4302                    handle_stripe(sh);
4303                    release_stripe(sh);
4304                    cond_resched();
4305
4306                    if (mddev->flags & ~(1<<MD_CHANGE_PENDING))
4307                            md_check_recovery(mddev);
4308
4309                    spin_lock_irq(&conf->device_lock);
4310            }

[] md_wakeup_thread+0x28/0x30
[] __release_stripe+0x101/0x1d0 [raid456]
[] release_stripe+0x4d/0x60 [raid456]
[] raid5d+0x46b/0x650 [raid456]
[] md_thread+0x10e/0x140
[] kthread+0x8c/0xa0
[] kernel_thread_helper+0x4/0x10
0x1be1 is in __release_stripe
(/mnt/work/alex/Ubuntu-3.2.0-25.40/drivers/md/raid5.c:227).
222                                     if (conf->retry_read_aligned)
223
md_wakeup_thread(conf->mddev->thread);
224                             }
225                     }
226             }
227     }
228
229     static void release_stripe(struct stripe_head *sh)
230     {
231             struct r5conf *conf = sh->raid_conf;

[] __cond_resched+0x2a/0x40
[] handle_stripe+0x5dc/0x1d80 [raid456]
[] raid5d+0x463/0x650 [raid456]
[] md_thread+0x10e/0x140
[] kthread+0x8c/0xa0
[] kernel_thread_helper+0x4/0x10
[] 0xffffffffffffffff
0x5bbc is in handle_stripe
(/usr/src/linux-headers-3.2.0-25-generic/arch/x86/include/asm/bitops.h:121).
116      * clear_bit() is atomic and implies release semantics before the memory
117      * operation. It can be used for an unlock.
118      */
119     static inline void clear_bit_unlock(unsigned nr, volatile
unsigned long *addr)
120     {
121             barrier();
122             clear_bit(nr, addr);
123     }
124
125     static inline void __clear_bit(int nr, volatile unsigned long *addr)

[] __cond_resched+0x2a/0x40
[] handle_stripe+0xde/0x1d80 [raid456]
[] raid5d+0x463/0x650 [raid456]
[] md_thread+0x10e/0x140
[] kthread+0x8c/0xa0
[] kernel_thread_helper+0x4/0x10
0x56be is in handle_stripe (include/linux/spinlock.h:310).
305             raw_spin_lock_nest_lock(spinlock_check(lock),
nest_lock);       \
306     } while (0)
307
308     static inline void spin_lock_irq(spinlock_t *lock)
309     {
310             raw_spin_lock_irq(&lock->rlock);
311     }
312
313     #define spin_lock_irqsave(lock, flags)                          \
314     do {

[] md_wakeup_thread+0x28/0x30
[] __release_stripe+0x101/0x1d0 [raid456]
[] release_stripe+0x42/0x60 [raid456]
[] raid5d+0x46b/0x650 [raid456]
[] md_thread+0x10e/0x140
[] kthread+0x8c/0xa0
[] kernel_thread_helper+0x4/0x10
0x1cf2 is in release_stripe (include/linux/spinlock.h:340).
335             raw_spin_unlock_irq(&lock->rlock);
336     }
337
338     static inline void spin_unlock_irqrestore(spinlock_t *lock,
unsigned long flags)
339     {
340             raw_spin_unlock_irqrestore(&lock->rlock, flags);
341     }
342
343     static inline int spin_trylock_bh(spinlock_t *lock)
344     {

Can you pls advise what might be the issue?

Thanks,
Alex.
