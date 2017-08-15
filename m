From: Guoqing Jiang <gqjiang@suse.com>
Subject: Re: BUG_ON(sh->batch_head) in init_stripe()
Date: Tue, 15 Aug 2017 17:24:53 +0800
Message-ID: <5992BDE5.8060108@suse.com>
References: <1E249B1F-4030-4482-ABB9-E18A87B5CD47@stanford.edu>
 <D70C6DBD-6B79-4FBE-A22D-8BC2E17CC2EB@stanford.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <D70C6DBD-6B79-4FBE-A22D-8BC2E17CC2EB@stanford.edu>
Sender: linux-raid-owner@vger.kernel.org
To: Stephane Thiell <sthiell@stanford.edu>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



On 08/14/2017 01:29 AM, Stephane Thiell wrote:
> Also known as "kernel BUG at drivers/md/raid5.c:527!"
>
> I’m still struggling with this issue in raid5.c. I currently have one crash per week in average on a system using Lustre and 24 x 10-disk raid6 per server. It did happen with or without check running. I now think there is a race at some point where a released stripe head (batched) is added to conf->inactive_list without sh->batch_head being set back to NULL.
>
> Because sh->batch_head is only being set back to NULL in a single function, break_stripe_batch_list(), my guess is that a call to raid5_release_stripe() on the head stripe is performed elsewhere. I didn’t find where this could come from yet. So perhaps sh->batch_head should be just set to NULL in do_release_stripe(), before being added to the inactive list?
>
> Alternatively, I wonder if it would make more sense to set batch_head to NULL where sh->overwrite_disks is also set back to 0 (like in ops_run_biodrain() today).
>
> Because sh->overwrite_disks is also set to 0 in init_stripe(), my current plan is to try this change, at least as a workaround: remove the BUG_ON(sh->batch_head) from init_stripe() and set sh->batch_head = NULL (I don’t think I need to lock on sh->stripe_lock there?). I will get new hardware soon so I will give it a try on a test system. Any suggestions welcomed…
>
> Quick analysis of the last vmcore:
>
> crash> ps | grep ">"
> ...
>> 16119  16111  22  ffff881f93bace70  RU   0.0  150772  10748  e2label
>> 151448      2  34  ffff881ff753bec0  RU   0.0       0      0  [kiblnd_sd_00_00]
>> 151449      2   2  ffff881ff753edd0  RU   0.0       0      0  [kiblnd_sd_00_01]
>> 154637      2  29  ffff881f776b1f60  RU   0.0       0      0  [md32_raid6]
>> 163643      2  11  ffff8820d200bec0  UN   0.0       0      0  [ll_ost_io01_008]
>> 164083      2  13  ffff8820d2753ec0  UN   0.0       0      0  [ll_ost_io01_034]
>> 171389      2   5  ffff883fd072de20  UN   0.0       0      0  [ll_ost_io01_058]
>> 171391      2  17  ffff883fd072ce70  UN   0.0       0      0  [ll_ost_io01_060]
>> 171399      2  33  ffff883fd9e9ce70  UN   0.0       0      0  [ll_ost_io01_068]
>> 237019      2  15  ffff882715628fb0  UN   0.0       0      0  [ll_ost_io01_084]
>> 237033      2   3  ffff881fb0250fb0  UN   0.0       0      0  [ll_ost_io01_098]
> ...
>
> crash>  bt 237033
> PID: 237033  TASK: ffff881fb0250fb0  CPU: 3   COMMAND: "ll_ost_io01_098"
>   #0 [ffff8826fa3e7240] machine_kexec at ffffffff81059bdb
>   #1 [ffff8826fa3e72a0] __crash_kexec at ffffffff811057c2
>   #2 [ffff8826fa3e7370] crash_kexec at ffffffff811058b0
>   #3 [ffff8826fa3e7388] oops_end at ffffffff8168fac8
>   #4 [ffff8826fa3e73b0] die at ffffffff8102e93b
>   #5 [ffff8826fa3e73e0] do_trap at ffffffff8168f180
>   #6 [ffff8826fa3e7430] do_invalid_op at ffffffff8102b144
>   #7 [ffff8826fa3e74e0] invalid_op at ffffffff81698b5e
>      [exception RIP: raid5_get_active_stripe+1809]
>      RIP: ffffffffa0fefd71  RSP: ffff8826fa3e7590  RFLAGS: 00010086
>      RAX: 0000000000000000  RBX: ffff883df051641c  RCX: dead000000000200
>      RDX: 0000000000000000  RSI: 0000000000000005  RDI: ffff881e08d54d30
>      RBP: ffff8826fa3e7638   R8: ffff881e08d54d40   R9: 0000000000000080
>      R10: 0000000000000000  R11: 0000000000000000  R12: ffff883df0516400
>      R13: ffff881e08d54d30  R14: 0000000000000000  R15: 0000000000000000
>      ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
>   #8 [ffff8826fa3e7640] raid5_make_request at ffffffffa0feff55 [raid456]
>   #9 [ffff8826fa3e7730] md_make_request at ffffffff814f838c
> #10 [ffff8826fa3e7790] generic_make_request at ffffffff812eedc9
> #11 [ffff8826fa3e77d8] submit_bio at ffffffff812eef11
> #12 [ffff8826fa3e7830] osd_submit_bio at ffffffffa10cdbcc [osd_ldiskfs]
> #13 [ffff8826fa3e7840] osd_do_bio at ffffffffa10d03c1 [osd_ldiskfs]
> #14 [ffff8826fa3e7960] osd_write_commit at ffffffffa10d0b94 [osd_ldiskfs]
> #15 [ffff8826fa3e7a00] ofd_commitrw_write at ffffffffa120c734 [ofd]
> #16 [ffff8826fa3e7a78] ofd_commitrw at ffffffffa120ff07 [ofd]
> #17 [ffff8826fa3e7b08] obd_commitrw at ffffffffa0c7dc22 [ptlrpc]
> #18 [ffff8826fa3e7b70] tgt_brw_write at ffffffffa0c55fc1 [ptlrpc]
> #19 [ffff8826fa3e7cd8] tgt_request_handle at ffffffffa0c52275 [ptlrpc]
> #20 [ffff8826fa3e7d20] ptlrpc_server_handle_request at ffffffffa0bfe1fb [ptlrpc]
> #21 [ffff8826fa3e7de8] ptlrpc_main at ffffffffa0c022b0 [ptlrpc]
> #22 [ffff8826fa3e7ec8] kthread at ffffffff810b0a4f
> #23 [ffff8826fa3e7f50] ret_from_fork at ffffffff81697218
>
>
> After some disassembly work, I found out that all active tasks are working on the same md (all are raid6):
>
> md32’s (struct r5conf *) is 0xffff883df0516400
>
> Our crashed task:
>
> crash> printf "%s", ((struct r5conf)*0xffff883df0516400).cache_name[0]
> raid6-md32
>
> Example for md32_raid6 task in release_inactive_stripe_list:
>
> crash> bt 154637
> PID: 154637  TASK: ffff881f776b1f60  CPU: 29  COMMAND: "md32_raid6"
>   #0 [ffff883ffc985e48] crash_nmi_callback at ffffffff8104d2e2
>   #1 [ffff883ffc985e58] nmi_handle at ffffffff8168fc77
>   #2 [ffff883ffc985eb0] do_nmi at ffffffff8168fe83
>   #3 [ffff883ffc985ef0] end_repeat_nmi at ffffffff8168f093
>      [exception RIP: _raw_spin_lock_irqsave+64]
>      RIP: ffffffff8168e5f0  RSP: ffff881e8d0cbc60  RFLAGS: 00000006
>      RAX: 00000000000031bb  RBX: ffff883df0516740  RCX: 000000000000009a
>      RDX: 0000000000000098  RSI: 000000000000009a  RDI: ffff883df051641c
>      RBP: ffff881e8d0cbc60   R8: 0000000000000206   R9: 0000000000000000
>      R10: 0000000000000000  R11: 0000000000000007  R12: ffff883df0516400
>      R13: ffff883df051641c  R14: 0000000000000006  R15: 0000000000000005
>      ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
> --- <NMI exception stack> ---
>   #4 [ffff881e8d0cbc60] _raw_spin_lock_irqsave at ffffffff8168e5f0
>   #5 [ffff881e8d0cbc68] release_inactive_stripe_list at ffffffffa0fe5500 [raid456]
>   #6 [ffff881e8d0cbcb0] handle_active_stripes at ffffffffa0ff34c2 [raid456]
>   #7 [ffff881e8d0cbd60] raid5d at ffffffffa0ff3c28 [raid456]
>   #8 [ffff881e8d0cbe50] md_thread at ffffffff814fb745
>   #9 [ffff881e8d0cbec8] kthread at ffffffff810b0a4f
> #10 [ffff881e8d0cbf50] ret_from_fork at ffffffff81697218
>
>
> crash> bt 163643 164083 171389 171391 171399 237019 237033 |grep "exception RIP:"
>      [exception RIP: _raw_spin_lock_irq+63]
>      [exception RIP: _raw_spin_lock_irq+63]
>      [exception RIP: _raw_spin_lock_irq+58]
>      [exception RIP: _raw_spin_lock_irq+63]
>      [exception RIP: _raw_spin_lock_irq+58]
>      [exception RIP: _raw_spin_lock_irq+63]
>      [exception RIP: raid5_get_active_stripe+1809]
>
> crash> bt 163643 164083 171389 171391 171399 237019 237033 |grep "raid5_get_active_stripe"
>   #5 [ffff883bcee93588] raid5_get_active_stripe at ffffffffa0fef6cb [raid456]
>   #5 [ffff883ba4af7588] raid5_get_active_stripe at ffffffffa0fef6cb [raid456]
>   #5 [ffff88390877b588] raid5_get_active_stripe at ffffffffa0fef6cb [raid456]
>   #5 [ffff88390803b588] raid5_get_active_stripe at ffffffffa0fef6cb [raid456]
>   #5 [ffff88390831f588] raid5_get_active_stripe at ffffffffa0fef6cb [raid456]
>   #5 [ffff8826fa7f7588] raid5_get_active_stripe at ffffffffa0fef6cb [raid456]
>      [exception RIP: raid5_get_active_stripe+1809]
>
> crash> bt 163643 164083 171389 171391 171399 237019 237033 |grep R12
>      R10: 0000000000000003  R11: 0000000000000000  R12: ffff883df0516400
>      R10: 0000000000000001  R11: 0000000000000000  R12: ffff883df0516400
>      R10: 0000000000000005  R11: 0000000000000000  R12: ffff883df0516400
>      R10: 0000000000000007  R11: 0000000000000000  R12: ffff883df0516400
>      R10: 0000000000000009  R11: 0000000000000000  R12: ffff883df0516400
>      R10: 0000000000000009  R11: 0000000000000000  R12: ffff883df0516400
>      R10: 0000000000000000  R11: 0000000000000000  R12: ffff883df0516400
>
>
> The bad stripe_head (sh) is available at (usually in %r13):
>
> crash> p ((struct stripe_head)*0xffff881e08d54d30).raid_conf
> $98 = (struct r5conf *) 0xffff883df0516400
>
> and batch_head is not NULL... that's the issue:
>
> crash> p ((struct stripe_head)*0xffff881e08d54d30).batch_head
> $99 = (struct stripe_head *) 0xffff881e08d54d30
>
> Full struct dump below. We can see than overwrite_disks is set to 0, state is 0… but this batch_head not set to NULL makes it crash in init_stripe():
>
> crash> p ((struct stripe_head)*0xffff881e08d54d30)
> $6 = {
>    hash = {
>      next = 0x0,
>      pprev = 0x0
>    },
>    lru = {
>      next = 0xffff881e08d54d40,
>      prev = 0xffff881e08d54d40
>    },
>    release_list = {
>      next = 0xffff881dfe405cc0
>    },
>    raid_conf = 0xffff883df0516400,
>    generation = 0,
>    sector = 3701224808,
>    pd_idx = 1,
>    qd_idx = 2,
>    ddf_layout = 0,
>    hash_lock_index = 5,
>    state = 0,
>    count = {
>      counter = 0
>    },
>    bm_seq = 22708787,
>    disks = 10,
>    overwrite_disks = 0,
>    check_state = check_state_idle,
>    reconstruct_state = reconstruct_state_idle,
>    stripe_lock = {
>      {
>        rlock = {
>          raw_lock = {
>            {
>              head_tail = 3709263126,
>              tickets = {
>                head = 56598,
>                tail = 56598
>              }
>            }
>          }
>        }
>      }
>    },
>    cpu = 15,
>    group = 0x0,
>    batch_head = 0xffff881e08d54d30,
>    batch_lock = {
>      {
>        rlock = {
>          raw_lock = {
>            {
>              head_tail = 9961624,
>              tickets = {
>                head = 152,
>                tail = 152
>              }
>            }
>          }
>        }
>      }
>    },
>    batch_list = {
>      next = 0xffff881dfe405d28,
>      prev = 0xffff881e0e2dec98
>    },
>    log_io = 0x0,
>    log_list = {
>      next = 0x0,
>      prev = 0x0
>    },
>    ops = {
>      target = 0,
>      target2 = 0,
>      zero_sum_result = (unknown: 0)
>    },
>    dev = {{
>        req = {
>          bi_sector = 0,
>          bi_next = 0x0,
>          bi_bdev = 0x0,
>          bi_flags = 1,
>          bi_rw = 0,
>          bi_vcnt = 0,
>          bi_idx = 0,
>          bi_phys_segments = 0,
>          bi_size = 0,
>          bi_seg_front_size = 0,
>          bi_seg_back_size = 0,
>          bi_end_io = 0x0,
>          bi_private = 0xffff881e08d54d30,
>          bi_ioc = 0x0,
>          bi_css = 0x0,
>          bi_integrity = 0x0,
>          bi_max_vecs = 1,
>          bi_cnt = {
>            counter = 1
>          },
>          bi_io_vec = 0xffff881e08d54f00,
>          bi_pool = 0x0,
>          {
>            bio_aux = 0x0,
>            __UNIQUE_ID_rh_kabi_hide15 = {
>              rh_reserved1 = 0x0
>            },
>            {<No data fields>}
>          },
>          bi_inline_vecs = 0xffff881e08d54e78
>        },
>        rreq = {
>          bi_sector = 0,
>          bi_next = 0x0,
>          bi_bdev = 0x0,
>          bi_flags = 1,
>          bi_rw = 0,
>          bi_vcnt = 0,
>          bi_idx = 0,
>          bi_phys_segments = 0,
>          bi_size = 0,
>          bi_seg_front_size = 0,
>          bi_seg_back_size = 0,
>          bi_end_io = 0x0,
>          bi_private = 0xffff881e08d54d30,
>          bi_ioc = 0x0,
>          bi_css = 0x0,
>          bi_integrity = 0x0,
>          bi_max_vecs = 1,
>          bi_cnt = {
>            counter = 1
>          },
>          bi_io_vec = 0xffff881e08d54f10,
>          bi_pool = 0x0,
>          {
>            bio_aux = 0x0,
>            __UNIQUE_ID_rh_kabi_hide15 = {
>              rh_reserved1 = 0x0
>            },
>            {<No data fields>}
>          },
>          bi_inline_vecs = 0xffff881e08d54f00
>        },
>        vec = {
>          bv_page = 0xffffea0078236080,
>          bv_len = 4096,
>          bv_offset = 0
>        },
>        rvec = {
>          bv_page = 0x0,
>          bv_len = 0,
>          bv_offset = 0
>        },
>        page = 0xffffea0078236080,
>        orig_page = 0xffffea0078236080,
>        toread = 0x0,
>        read = 0x0,
>        towrite = 0x0,
>        written = 0xffff8824832a7c00,
>        sector = 29609798632,
>        flags = 24,

Seems the flags is R5_OVERWRITE | R5_Insync, handle_stripe_clean_event
only calls break_stripe_batch_list if do_endio is set to true.

if (head_sh->batch_head && do_endio)
                 break_stripe_batch_list(head_sh, STRIPE_EXPAND_SYNC_FLAGS);

And do_endio is set to true if we meet the below condition.

if (!test_bit(R5_LOCKED, &dev->flags) &&
                             (test_bit(R5_UPTODATE, &dev->flags) ||
                              test_bit(R5_Discard, &dev->flags) ||
                              test_bit(R5_SkipCopy, &dev->flags))) {

I guess it is why the batch_head is not null, just my 2 cents.

>        log_checksum = 0
>      }}
> }

Thanks,
Guoqing

