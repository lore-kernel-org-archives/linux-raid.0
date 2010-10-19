From: Tim Small <tim@seoss.co.uk>
Subject: Re: Deadlock in md barrier code? / RAID1 / LVM CoW snapshot + ext3
 / Debian 5.0 - lenny 2.6.26 kernel
Date: Tue, 19 Oct 2010 17:24:33 +0100
Message-ID: <4CBDC641.9090009@seoss.co.uk>
References: <4C938103.1010304@seoss.co.uk>	<20100918085925.5fee83ee@notabene>	<4C97BD21.1040405@seoss.co.uk>	<4C991D61.1040400@seoss.co.uk>	<20100922083039.283ccdfd@notabene>	<4CBC9774.6020500@seoss.co.uk> <20101019171650.20c83e7e@notabene>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101019171650.20c83e7e@notabene>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 19/10/10 07:16, Neil Brown wrote:
>
>> ... any use?
>>      
> Only in as much as that it excludes some possible avenues of investigation,
> which has some value.
>
> But I'm out of ideas.  I cannot think of anything that could keep
> ->nr_pending or ->barrier elevated such that raise_barrier would
> block for a long time.
>
> Maybe you could try adding printks to print
>    conf->{barrier,nr_pending,nr_waiting,nr_queued}
> just before and after the second wait_event_lock_irq in raise_barrier().
>
>    

run1:

[  130.168389] Pre wait barrier: 1, pend: 30, wait: 0, queued: 0
[  130.209456] Post wait barrier: 1, pend: 0, wait: 4, queued: 0
[  130.228814] Pre wait barrier: 1, pend: 82, wait: 0, queued: 0
[  130.267475] Post wait barrier: 1, pend: 0, wait: 5, queued: 0
[  130.290556] Pre wait barrier: 1, pend: 57, wait: 0, queued: 0
[  130.348259] Post wait barrier: 1, pend: 0, wait: 4, queued: 0
[  130.376040] Pre wait barrier: 1, pend: 42, wait: 0, queued: 0
[  130.414694] Post wait barrier: 1, pend: 0, wait: 5, queued: 0
[  130.438693] Pre wait barrier: 1, pend: 46, wait: 0, queued: 0
[  130.490211] Post wait barrier: 1, pend: 0, wait: 4, queued: 0
[  130.510371] Pre wait barrier: 1, pend: 57, wait: 0, queued: 0
[  130.551321] Post wait barrier: 1, pend: 0, wait: 4, queued: 0
[  130.564969] Pre wait barrier: 1, pend: 16, wait: 0, queued: 0
<hang>

run2:

[  155.947067] Pre wait barrier: 1, pend: 8, wait: 0, queued: 0
[  156.000027] Post wait barrier: 1, pend: 0, wait: 5, queued: 0
[  156.011959] Pre wait barrier: 1, pend: 13, wait: 0, queued: 0
[  156.059050] Post wait barrier: 1, pend: 0, wait: 5, queued: 0
[  156.076866] Pre wait barrier: 1, pend: 13, wait: 0, queued: 0
[  156.108234] Post wait barrier: 1, pend: 0, wait: 4, queued: 0
[  156.118437] Pre wait barrier: 1, pend: 93, wait: 0, queued: 0
[  156.140136] Post wait barrier: 1, pend: 0, wait: 4, queued: 0
[  156.140506] Pre wait barrier: 1, pend: 4, wait: 0, queued: 0
[  156.157644] Post wait barrier: 1, pend: 0, wait: 3, queued: 0
[  156.260883] Pre wait barrier: 1, pend: 51, wait: 0, queued: 0
<hang>

run3:

[  113.862479] Pre wait barrier: 1, pend: 6, wait: 0, queued: 0
[  113.892445] Post wait barrier: 1, pend: 0, wait: 2, queued: 0
[  113.912622] Pre wait barrier: 1, pend: 6, wait: 0, queued: 0
[  113.921417] Post wait barrier: 1, pend: 0, wait: 2, queued: 0
[  113.947774] Pre wait barrier: 1, pend: 22, wait: 0, queued: 0
[  113.970322] Post wait barrier: 1, pend: 0, wait: 2, queued: 0
[  114.024782] Pre wait barrier: 1, pend: 2, wait: 0, queued: 0
[  114.039825] Post wait barrier: 1, pend: 0, wait: 2, queued: 0
[  114.055788] Pre wait barrier: 1, pend: 33, wait: 0, queued: 0
[  114.071059] Post wait barrier: 1, pend: 0, wait: 2, queued: 0
[  114.076240] Pre wait barrier: 1, pend: 5, wait: 0, queued: 0
[  114.103378] Post wait barrier: 1, pend: 0, wait: 2, queued: 0
[  114.118969] Pre wait barrier: 1, pend: 27, wait: 0, queued: 0
<hang>


md2 : active raid1 sda6[0] sdb6[1]
       404600128 blocks [2/2] [UU]
       [>....................]  resync =  0.5% (2246720/404600128) 
finish=256573.1min speed=26K/sec




I then stuck a few more printks in both wait_event_lock_irq and 
raise_barrier,

static void raise_barrier(conf_t *conf)
{
         spin_lock_irq(&conf->resync_lock);

         /* Wait until no block IO is waiting */
         printk(KERN_DEBUG "%i: Pre wait until no IO waiting: %d, pend: 
%d, wait: %d, queued: %d\n", current->pid, conf->barrier, 
conf->nr_pending, conf->nr_waiting, conf->nr_queued);
         wait_event_lock_irq(conf->wait_barrier, !conf->nr_waiting,
                             conf->resync_lock,
                             raid1_unplug(conf->mddev->queue));
         printk(KERN_DEBUG "%i: Post wait until no IO waiting: %d, pend: 
%d, wait: %d, queued: %d\n", current->pid, conf->barrier, 
conf->nr_pending, conf->nr_waiting, conf->nr_queued);

         /* block any new IO from starting */
         conf->barrier++;

         /* No wait for all pending IO to complete */
         printk(KERN_DEBUG "%i: Pre wait pending to complete: %d, pend: 
%d, wait: %d, queued: %d\n", current->pid, conf->barrier, 
conf->nr_pending, conf->nr_waiting, conf->nr_queued);
         wait_event_lock_irq(conf->wait_barrier,
                             !conf->nr_pending && conf->barrier < 
RESYNC_DEPTH,
                             conf->resync_lock,
                             raid1_unplug(conf->mddev->queue));
         printk(KERN_DEBUG "%i: Post wait pending to complete: %d, pend: 
%d, wait: %d, queued: %d\n", current->pid, conf->barrier, 
conf->nr_pending, conf->nr_waiting, conf->nr_queued);

         spin_unlock_irq(&conf->resync_lock);
}

#define __wait_event_lock_irq(wq, condition, lock, cmd)                 \
do {                                                                    \
         wait_queue_t __wait;                                            \
         int ourpid;                                                     \
         ourpid = current->pid;                                          \
         printk(KERN_DEBUG "%i is pid in wait_event_lock_irq.\n", 
ourpid);      \
         init_waitqueue_entry(&__wait, current);                         \
                                                                         \
         add_wait_queue(&wq, &__wait);                                   \
         for (;;) {                                                      \
                 set_current_state(TASK_UNINTERRUPTIBLE);                \
                 if (condition)                                          \
                         break;                                          \
                 spin_unlock_irq(&lock);                                 \
                 printk(KERN_DEBUG "%i Calling cmd\n", 
ourpid);                  \
                 cmd;                                                    \
                 printk(KERN_DEBUG "%i Returned from cmd\n", 
ourpid);                    \
                 schedule();                                             \
                 spin_lock_irq(&lock);                                   \
         }                                                               \
         if (ourpid != (current->pid))                                   \
                 printk(KERN_DEBUG "PID changed!  Old: %i, new: %i\n", 
ourpid, current->pid); \
         current->state = TASK_RUNNING;                                  \
         remove_wait_queue(&wq, &__wait);                                \
} while (0)




  and got this:



[  112.240838] 2410 Returned from cmd
[  112.240838] 2410 Calling cmd
[  112.240838] 2410 Returned from cmd
[  112.240838] 2410 Calling cmd
[  112.240838] 2410 Returned from cmd
[  112.240838] 2410 Calling cmd
[  112.240838] 2410 Returned from cmd
[  112.240838] 2410 Calling cmd
[  112.240838] 2410 Returned from cmd
[  112.240838] 2410 Calling cmd
[  112.240838] 2410 Returned from cmd
[  112.240838] 2410 Calling cmd
[  112.240838] 2410 Returned from cmd
[  112.240838] 2410 Calling cmd
[  112.240838] 2410 Returned from cmd
[  112.240838] 2410 Calling cmd
[  112.240838] 2410 Returned from cmd
[  112.240838] 2410 Calling cmd
[  112.240838] 2410 Returned from cmd
[  112.240838] 2410 Calling cmd
[  112.240838] 2410 Returned from cmd
[  112.240838] 2410: Post wait until no IO waiting: 0, pend: 448, wait: 
0, queued: 0
[  112.240838] 2410: Pre wait pending to complete: 1, pend: 448, wait: 
0, queued: 0
[  112.240838] 2410 is pid in wait_event_lock_irq.
[  112.240838] 2410 Calling cmd
[  112.243066] 5950 is pid in wait_event_lock_irq.
[  112.243066] 5950 Calling cmd
[  112.243066] 5950 Returned from cmd
[  112.240838] 2410 Returned from cmd
[  112.243066] 2430 is pid in wait_event_lock_irq.
[  112.243066] 2430 Calling cmd
[  112.243066] 2430 Returned from cmd
[  112.257942] 2430 Calling cmd
[  112.258447] 2410 Calling cmd
[  112.258447] 5950 Calling cmd
[  112.258453] 2410 Returned from cmd
[  112.258447] 5950 Returned from cmd
[  112.257942] 2430 Returned from cmd
[  112.258447] 5745 is pid in wait_event_lock_irq.
[  112.258451] 5745 Calling cmd
[  112.258454] 5745 Returned from cmd
[  112.262495] 5745 Calling cmd
[  112.262495] 2430 Calling cmd
[  112.262495] 2410 Calling cmd
[  112.262495] 5745 Returned from cmd
[  112.262495] 2430 Returned from cmd
[  112.262495] 2410 Returned from cmd
[  112.262495] 5950 Calling cmd
[  112.262495] 5950 Returned from cmd
[  112.263422] 2430 Calling cmd
[  112.263422] 2430 Returned from cmd
[  112.264770] 2410 Calling cmd
[  112.264772] 2410 Returned from cmd






-- 
South East Open Source Solutions Limited
Registered in England and Wales with company number 06134732.
Registered Office: 2 Powell Gardens, Redhill, Surrey, RH1 1TQ
VAT number: 900 6633 53  http://seoss.co.uk/ +44-(0)1273-808309

