Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CCAAC433E0
	for <linux-raid@archiver.kernel.org>; Tue, 19 Jan 2021 14:54:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D15922DFB
	for <linux-raid@archiver.kernel.org>; Tue, 19 Jan 2021 14:54:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391556AbhASOyD (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 19 Jan 2021 09:54:03 -0500
Received: from mx3.molgen.mpg.de ([141.14.17.11]:35933 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389580AbhASLbi (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Tue, 19 Jan 2021 06:31:38 -0500
Received: from [192.168.0.5] (ip5f5aed2c.dynamic.kabel-deutschland.de [95.90.237.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: buczek)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 9262B20645D7D;
        Tue, 19 Jan 2021 12:30:44 +0100 (CET)
From:   Donald Buczek <buczek@molgen.mpg.de>
Subject: Re: md_raid: mdX_raid6 looping after sync_action "check" to "idle"
 transition
To:     Guoqing Jiang <guoqing.jiang@cloud.ionos.com>,
        Song Liu <song@kernel.org>, linux-raid@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        it+raid@molgen.mpg.de
References: <aa9567fd-38e1-7b9c-b3e1-dc2fdc055da5@molgen.mpg.de>
 <95fbd558-5e46-7a6a-43ac-bcc5ae8581db@cloud.ionos.com>
 <77244d60-1c2d-330e-71e6-4907d4dd65fc@molgen.mpg.de>
 <7c5438c7-2324-cc50-db4d-512587cb0ec9@molgen.mpg.de>
 <b289ae15-ff82-b36e-4be4-a1c8bbdbacd7@cloud.ionos.com>
 <37c158cb-f527-34f5-2482-cae138bc8b07@molgen.mpg.de>
 <efb8d47b-ab9b-bdb9-ee2f-fb1be66343b1@molgen.mpg.de>
Message-ID: <55e30408-ac63-965f-769f-18be5fd5885c@molgen.mpg.de>
Date:   Tue, 19 Jan 2021 12:30:43 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <efb8d47b-ab9b-bdb9-ee2f-fb1be66343b1@molgen.mpg.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Dear md-raid people,

I've reported a problem in this thread in December:

"We are using raid6 on several servers. Occasionally we had failures, where a mdX_raid6 process seems to go into a busy loop and all I/O to the md device blocks. We've seen this on various kernel versions." It was clear, that this is related to "mdcheck" running, because we found, that the command, which should stop the scrubbing in the morning (`echo idle > /sys/devices/virtual/block/md1/md/sync_action`) is also blocked.

On 12/21/20, I've reported, that the problem might be caused by a failure of the underlying block device driver, because I've found "inflight" counters of the block devices not being zero. However, this is not the case. We were able to run into the mdX_raid6 looping condition a few times again, but the non-zero inflight counters have not been observed again.

I was able to collect a lot of additional information from a blocked system.

- The `cat idle > /sys/devices/virtual/block/md1/md/sync_action` command is waiting at kthread_stop to stop the sync thread. [ https://elixir.bootlin.com/linux/latest/source/drivers/md/md.c#L7989 ]

- The sync thread ("md1_resync") does not finish, because its blocked at

[<0>] raid5_get_active_stripe+0x4c4/0x660     # [1]
[<0>] raid5_sync_request+0x364/0x390
[<0>] md_do_sync+0xb41/0x1030
[<0>] md_thread+0x122/0x160
[<0>] kthread+0x118/0x130
[<0>] ret_from_fork+0x22/0x30

[1] https://elixir.bootlin.com/linux/latest/source/drivers/md/raid5.c#L735

- yes, gdb confirms that `conf->cache_state` is 0x03 ( R5_INACTIVE_BLOCKED + R5_ALLOC_MORE )

- We have lots of active stripes:

root@deadbird:~/linux_problems/mdX_raid6_looping# cat /sys/block/md1/md/stripe_cache_active
27534

- handle_stripe() doesn't make progress:

echo "func handle_stripe =pflt" > /sys/kernel/debug/dynamic_debug/control

In dmesg, we see the debug output from https://elixir.bootlin.com/linux/latest/source/drivers/md/raid5.c#L4925 but never from https://elixir.bootlin.com/linux/latest/source/drivers/md/raid5.c#L4958:

[171908.896651] [1388] handle_stripe:4929: handling stripe 4947089856, state=0x2029 cnt=1, pd_idx=9, qd_idx=10
                 , check:4, reconstruct:0
[171908.896657] [1388] handle_stripe:4929: handling stripe 4947089872, state=0x2029 cnt=1, pd_idx=9, qd_idx=10
                 , check:4, reconstruct:0
[171908.896669] [1388] handle_stripe:4929: handling stripe 4947089912, state=0x2029 cnt=1, pd_idx=9, qd_idx=10
                 , check:4, reconstruct:0

The sector numbers repeat after some time. We have only the following variants of stripe state and "check":

state=0x2031 cnt=1, check:0 # ACTIVE        +INSYNC+REPLACED+IO_STARTED, check_state_idle
state=0x2029 cnt=1, check:4 # ACTIVE+SYNCING       +REPLACED+IO_STARTED, check_state_check_result
state=0x2009 cnt=1, check:0 # ACTIVE+SYNCING                +IO_STARTED, check_state_idle

- We have MD_SB_CHANGE_PENDING set:

root@deadbird:~/linux_problems/mdX_raid6_looping# cat /sys/block/md1/md/array_state
write-pending

gdb confirms that sb_flags = 6 (MD_SB_CHANGE_CLEAN + MD_SB_CHANGE_PENDING)

So it can be assumed that handle_stripe breaks out at https://elixir.bootlin.com/linux/latest/source/drivers/md/raid5.c#L4939

- The system can manually be freed from the deadlock:

When `echo active > /sys/block/md1/md/array_state` is used, the scrubbing and other I/O continue. Probably because of https://elixir.bootlin.com/linux/latest/source/drivers/md/md.c#L4520

I, of coruse, don't fully understand it yet. Any ideas?

I append some data from a hanging raid... (mddev, r5conf and a sample stripe_head from handle_list with it first disks)

Donald


$L_002: (struct mddev *) 0xffff8898a48e3000 : {
     private = (struct r5conf *) 0xffff88988695a800 /* --> $L_004 */
     pers = (struct md_personality *) 0xffffffff826ee280 <raid6_personality>
     unit = 9437185
     md_minor = 1
     disks = {next = 0xffff889886ee8c00, prev = 0xffff889891506000}
     flags = 0
     sb_flags = 6
     suspended = 0
     active_io = { counter=4 }  /* atomic_t */
     ro = 0
     sysfs_active = 0
     gendisk = (struct gendisk *) 0xffff8898bc357800
     kobj = {
         name = (const char *) 0xffffffff8220cef8 "md"
         entry = {next = 0xffff8898a48e3058, prev = 0xffff8898a48e3058}    /* empty */
         parent = (struct kobject *) 0xffff8898bc357868
         kset = 0x0
         ktype = (struct kobj_type *) 0xffffffff826ef140 <md_ktype>
         sd = (struct kernfs_node *) 0xffff8898b5f65980
         kref = {
             refcount = {
                 refs = { counter=17 }  /* atomic_t */
             }
         }
         state_initialized = 1
         state_in_sysfs = 1
         state_add_uevent_sent = 0
         state_remove_uevent_sent = 0
         uevent_suppress = 0
     }
     hold_active = 0
     major_version = 1
     minor_version = 2
     patch_version = 0
     persistent = 1
     external = 0
     metadata_type = [
(8)
         [0] : 0 '\000'
         [1] : 0 '\000'
         [2] : 0 '\000'
         [3] : 0 '\000'
         [4] : 0 '\000'
         [5] : 0 '\000'
         [6] : 0 '\000'
         [7] : 0 '\000'
         [8] : 0 '\000'
         [9] : 0 '\000'
         [10] : 0 '\000'
         [11] : 0 '\000'
         [12] : 0 '\000'
         [13] : 0 '\000'
         [14] : 0 '\000'
         [15] : 0 '\000'
         [16] : 0 '\000'
     ]
     chunk_sectors = 1024
     ctime = 1607680540
     utime = 1610853337
     level = 6
     layout = 2
     clevel = [
(8)
         [0] : 114 'r'
         [1] : 97 'a'
         [2] : 105 'i'
         [3] : 100 'd'
         [4] : 54 '6'
         [5] : 0 '\000'
         [6] : 0 '\000'
         [7] : 0 '\000'
         [8] : 0 '\000'
         [9] : 0 '\000'
         [10] : 0 '\000'
         [11] : 0 '\000'
         [12] : 0 '\000'
         [13] : 0 '\000'
         [14] : 0 '\000'
         [15] : 0 '\000'
     ]
     raid_disks = 16
     max_disks = 1920
     dev_sectors = 15627788288
     array_sectors = 218789036032
     external_size = 0
     events = 32409
     can_decrease_events = 0
     uuid = [
(8)
         [0] : -49 '\317'
         [1] : 69 'E'
         [2] : 119 'w'
         [3] : 62 '>'
         [4] : -113 '\217'
         [5] : -107 '\225'
         [6] : 9 '\t'
         [7] : -90 '\246'
         [8] : -2 '\376'
         [9] : 84 'T'
         [10] : -12 '\364'
         [11] : -31 '\341'
         [12] : -110 '\222'
         [13] : 24 '\030'
         [14] : -15 '\361'
         [15] : 109 'm'
     ]
     reshape_position = 18446744073709551615
     delta_disks = 0
     new_level = 6
     new_layout = 2
     new_chunk_sectors = 1024
     reshape_backwards = 0
     thread = (struct md_thread *) 0xffff889887bde080
     sync_thread = 0x0
     last_sync_action = (char *) 0xffffffff8225e246 "check"
     curr_resync = 4947256648
     curr_resync_completed = 4947016640
     resync_mark = 4415850173
     resync_mark_cnt = 66402936
     curr_mark_cnt = 75262560
     resync_max_sectors = 15627788288
     resync_mismatches = {
         counter = 0
     }
     suspend_lo = 0
     suspend_hi = 0
     sync_speed_min = 0
     sync_speed_max = 0
     parallel_resync = 0
     ok_start_degraded = 0
     recovery = 203
     recovery_disabled = 16
     in_sync = 0
     open_mutex = {
         owner = { counter=0 }  /* atomic_t */
         wait_lock = {counter=0} /* spinlock_t */
         osq = {
             tail = { counter=0 }  /* atomic_t */
         }
         wait_list = {next = 0xffff8898a48e31d8, prev = 0xffff8898a48e31d8}    /* empty */
     }
     reconfig_mutex = {
         owner = { counter=-131247629823744 }  /* atomic_t */
         wait_lock = {counter=0} /* spinlock_t */
         osq = {
             tail = { counter=0 }  /* atomic_t */
         }
         wait_list = {next = 0xffff8898a48e31f8, prev = 0xffff8898a48e31f8}    /* empty */
     }
     active = { counter=2 }  /* atomic_t */
     openers = { counter=1 }  /* atomic_t */
     changed = 0
     degraded = 0
     recovery_active = { counter=181360 }  /* atomic_t */
     recovery_wait = {
         lock = {counter=0} /* spinlock_t */
         head = {next = 0xffff8898a48e3228, prev = 0xffff8898a48e3228}    /* empty */
     }
     recovery_cp = 18446744073709551615
     resync_min = 4871994088
     resync_max = 18446744073709551615
     sysfs_state = (struct kernfs_node *) 0xffff8898b5f65380
     sysfs_action = (struct kernfs_node *) 0xffff889887d87600
     sysfs_completed = (struct kernfs_node *) 0xffff8898ac6f4e80
     sysfs_degraded = (struct kernfs_node *) 0xffff8898ac6f4b80
     sysfs_level = (struct kernfs_node *) 0xffff8898b5f65700
     del_work = {
         data = { counter=128 }  /* atomic_t */
         entry = {next = 0xffff8898a48e3280, prev = 0xffff8898a48e3280}    /* empty */
         func = (work_func_t) 0xffffffff819ad430 <md_start_sync>
     }
     lock = {counter=0} /* spinlock_t */
     sb_wait = {
         lock = {counter=0} /* spinlock_t */
         head = {next = 0xffffc9000e4a7a68, prev = 0xffffc9000cf97d30}
     }
     pending_writes = { counter=0 }  /* atomic_t */
     safemode = 0
     safemode_delay = 201
     safemode_timer = {
         entry = {
             next = (struct hlist_node *) 0xdead000000000122
             pprev = 0x0
         }
         expires = 4415857239
         function = (void (*)(struct timer_list *)) 0xffffffff819a6a40 <md_safemode_timeout>
         flags = 314572820
     }
     writes_pending = {
         percpu_count_ptr = 105896157983096
         data = (struct percpu_ref_data *) 0xffff8898b340fc80
     }
     sync_checkers = 0
     queue = (struct request_queue *) 0xffff8898b65847c8
     bitmap = (struct bitmap *) 0xffff889887d84400
     bitmap_info = {
         file = 0x0
         offset = 8
         space = 0
         default_offset = 2
         default_space = 6
         mutex = {
             owner = { counter=0 }  /* atomic_t */
             wait_lock = {counter=0} /* spinlock_t */
             osq = {
                 tail = { counter=0 }  /* atomic_t */
             }
             wait_list = {next = 0xffff8898a48e3350, prev = 0xffff8898a48e3350}    /* empty */
         }
         chunksize = 67108864
         daemon_sleep = 5000
         max_write_behind = 0
         external = 0
         nodes = 0
         cluster_name = [
(8)
             [0] : 0 '\000'
             [1] : 0 '\000'
             [2] : 0 '\000'
             [3] : 0 '\000'
             [4] : 0 '\000'
             [5] : 0 '\000'
             [6] : 0 '\000'
             [7] : 0 '\000'
             [8] : 0 '\000'
             [9] : 0 '\000'
             [10] : 0 '\000'
             [11] : 0 '\000'
             [12] : 0 '\000'
             [13] : 0 '\000'
             [14] : 0 '\000'
             [15] : 0 '\000'
             [16] : 0 '\000'
             [17] : 0 '\000'
             [18] : 0 '\000'
             [19] : 0 '\000'
             [20] : 0 '\000'
             [21] : 0 '\000'
             [22] : 0 '\000'
             [23] : 0 '\000'
             [24] : 0 '\000'
             [25] : 0 '\000'
             [26] : 0 '\000'
             [27] : 0 '\000'
             [28] : 0 '\000'
             [29] : 0 '\000'
             [30] : 0 '\000'
             [31] : 0 '\000'
             [32] : 0 '\000'
             [33] : 0 '\000'
             [34] : 0 '\000'
             [35] : 0 '\000'
             [36] : 0 '\000'
             [37] : 0 '\000'
             [38] : 0 '\000'
             [39] : 0 '\000'
             [40] : 0 '\000'
             [41] : 0 '\000'
             [42] : 0 '\000'
             [43] : 0 '\000'
             [44] : 0 '\000'
             [45] : 0 '\000'
             [46] : 0 '\000'
             [47] : 0 '\000'
             [48] : 0 '\000'
             [49] : 0 '\000'
             [50] : 0 '\000'
             [51] : 0 '\000'
             [52] : 0 '\000'
             [53] : 0 '\000'
             [54] : 0 '\000'
             [55] : 0 '\000'
             [56] : 0 '\000'
             [57] : 0 '\000'
             [58] : 0 '\000'
             [59] : 0 '\000'
             [60] : 0 '\000'
             [61] : 0 '\000'
             [62] : 0 '\000'
             [63] : 0 '\000'
         ]
     }
     max_corr_read_errors = { counter=20 }  /* atomic_t */
     all_mddevs = {next = 0xffffffff826eef10, prev = 0xffff88810a551bc8}
     to_remove = 0x0
     bio_set = {
         bio_slab = (struct kmem_cache *) 0xffff889886fbdc00
         front_pad = 0
         bio_pool = {
             lock = {counter=0} /* spinlock_t */
             min_nr = 2
             curr_nr = 2
             elements = (void **) 0xffff8898b4fae300
             pool_data = (void *) 0xffff889886fbdc00
             alloc = (mempool_alloc_t *) 0xffffffff811c8540 <mempool_alloc_slab>
             free = (mempool_free_t *) 0xffffffff811c8560 <mempool_free_slab>
             wait = {
                 lock = {counter=0} /* spinlock_t */
                 head = {next = 0xffff8898a48e3428, prev = 0xffff8898a48e3428}    /* empty */
             }
         }
         bvec_pool = {
             lock = {counter=0} /* spinlock_t */
             min_nr = 2
             curr_nr = 2
             elements = (void **) 0xffff8898b4fae2e0
             pool_data = (void *) 0xffff8881078ecb40
             alloc = (mempool_alloc_t *) 0xffffffff811c8540 <mempool_alloc_slab>
             free = (mempool_free_t *) 0xffffffff811c8560 <mempool_free_slab>
             wait = {
                 lock = {counter=0} /* spinlock_t */
                 head = {next = 0xffff8898a48e3470, prev = 0xffff8898a48e3470}    /* empty */
             }
         }
         bio_integrity_pool = {
             lock = {counter=0} /* spinlock_t */
             min_nr = 0
             curr_nr = 0
             elements = 0x0
             pool_data = 0x0
             alloc = 0x0
             free = 0x0
             wait = {
                 lock = {counter=0} /* spinlock_t */
                 head = {next = 0x0000000000000000, prev = 0x0000000000000000}
             }
         }
         bvec_integrity_pool = {
             lock = {counter=0} /* spinlock_t */
             min_nr = 0
             curr_nr = 0
             elements = 0x0
             pool_data = 0x0
             alloc = 0x0
             free = 0x0
             wait = {
                 lock = {counter=0} /* spinlock_t */
                 head = {next = 0x0000000000000000, prev = 0x0000000000000000}
             }
         }
         rescue_lock = {counter=0} /* spinlock_t */
         rescue_list = {
             head = 0x0
             tail = 0x0
         }
         rescue_work = {
             data = { counter=68719476704 }  /* atomic_t */
             entry = {next = 0xffff8898a48e3530, prev = 0xffff8898a48e3530}    /* empty */
             func = (work_func_t) 0xffffffff81430230 <bio_alloc_rescue>
         }
         rescue_workqueue = 0x0
     }
     sync_set = {
         bio_slab = (struct kmem_cache *) 0xffff889886fbdc00
         front_pad = 0
         bio_pool = {
             lock = {counter=0} /* spinlock_t */
             min_nr = 2
             curr_nr = 2
             elements = (void **) 0xffff8898b4fae2c0
             pool_data = (void *) 0xffff889886fbdc00
             alloc = (mempool_alloc_t *) 0xffffffff811c8540 <mempool_alloc_slab>
             free = (mempool_free_t *) 0xffffffff811c8560 <mempool_free_slab>
             wait = {
                 lock = {counter=0} /* spinlock_t */
                 head = {next = 0xffff8898a48e3598, prev = 0xffff8898a48e3598}    /* empty */
             }
         }
         bvec_pool = {
             lock = {counter=0} /* spinlock_t */
             min_nr = 2
             curr_nr = 2
             elements = (void **) 0xffff8898b4fae2a0
             pool_data = (void *) 0xffff8881078ecb40
             alloc = (mempool_alloc_t *) 0xffffffff811c8540 <mempool_alloc_slab>
             free = (mempool_free_t *) 0xffffffff811c8560 <mempool_free_slab>
             wait = {
                 lock = {counter=0} /* spinlock_t */
                 head = {next = 0xffff8898a48e35e0, prev = 0xffff8898a48e35e0}    /* empty */
             }
         }
         bio_integrity_pool = {
             lock = {counter=0} /* spinlock_t */
             min_nr = 0
             curr_nr = 0
             elements = 0x0
             pool_data = 0x0
             alloc = 0x0
             free = 0x0
             wait = {
                 lock = {counter=0} /* spinlock_t */
                 head = {next = 0x0000000000000000, prev = 0x0000000000000000}
             }
         }
         bvec_integrity_pool = {
             lock = {counter=0} /* spinlock_t */
             min_nr = 0
             curr_nr = 0
             elements = 0x0
             pool_data = 0x0
             alloc = 0x0
             free = 0x0
             wait = {
                 lock = {counter=0} /* spinlock_t */
                 head = {next = 0x0000000000000000, prev = 0x0000000000000000}
             }
         }
         rescue_lock = {counter=0} /* spinlock_t */
         rescue_list = {
             head = 0x0
             tail = 0x0
         }
         rescue_work = {
             data = { counter=68719476704 }  /* atomic_t */
             entry = {next = 0xffff8898a48e36a0, prev = 0xffff8898a48e36a0}    /* empty */
             func = (work_func_t) 0xffffffff81430230 <bio_alloc_rescue>
         }
         rescue_workqueue = 0x0
     }
     md_io_pool = {
         lock = {counter=0} /* spinlock_t */
         min_nr = 2
         curr_nr = 2
         elements = (void **) 0xffff8898b236af60
         pool_data = (void *) 0x28 <fixed_percpu_data+40>
         alloc = (mempool_alloc_t *) 0xffffffff811c8b50 <mempool_kmalloc>
         free = (mempool_free_t *) 0xffffffff811c84b0 <mempool_kfree>
         wait = {
             lock = {counter=0} /* spinlock_t */
             head = {next = 0xffff8898a48e36f8, prev = 0xffff8898a48e36f8}    /* empty */
         }
     }
     flush_bio = 0x0
     flush_pending = { counter=0 }  /* atomic_t */
     start_flush = 121249416090188
     last_flush = 121249416090188
     flush_work = {
         data = { counter=2176 }  /* atomic_t */
         entry = {next = 0xffff8898a48e3730, prev = 0xffff8898a48e3730}    /* empty */
         func = (work_func_t) 0xffffffff819aca80 <md_submit_flush_data>
     }
     event_work = {
         data = { counter=0 }  /* atomic_t */
         entry = {next = 0x0000000000000000, prev = 0x0000000000000000}
         func = 0x0
     }
     serial_info_pool = 0x0
     sync_super = 0x0
     cluster_info = 0x0
     good_device_nr = 0
     noio_flag = 0
     has_superblocks = true_21_
     fail_last_dev = false_21_
     serialize_policy = false_21_
}

$L_004: (struct r5conf *) 0xffff88988695a800 : {
     stripe_hashtbl = (struct hlist_head *) 0xffff8898a1cb9000 /* --> $L_006 */
     hash_locks = [
(23)
         [0] : {counter=0} /* spinlock_t */
         [1] : {counter=0} /* spinlock_t */
         [2] : {counter=0} /* spinlock_t */
         [3] : {counter=0} /* spinlock_t */
         [4] : {counter=0} /* spinlock_t */
         [5] : {counter=0} /* spinlock_t */
         [6] : {counter=0} /* spinlock_t */
         [7] : {counter=0} /* spinlock_t */
     ]
     mddev = (struct mddev *) 0xffff8898a48e3000
     chunk_sectors = 1024
     level = 6
     algorithm = 2
     rmw_level = 1
     max_degraded = 2
     raid_disks = 16
     max_nr_stripes = 29816
     min_nr_stripes = 256
     reshape_progress = 18446744073709551615
     reshape_safe = 0
     previous_raid_disks = 16
     prev_chunk_sectors = 1024
     prev_algo = 2
     generation = 0
     gen_lock = {
         seqcount = {
             sequence = 0
         }
     }
     reshape_checkpoint = 0
     min_offset_diff = 0
     handle_list = {next = 0xffff888a7893c890, prev = 0xffff8889de3cc7d0}
     loprio_list = {next = 0xffff88988695a898, prev = 0xffff88988695a898}    /* empty */
     hold_list = {next = 0xffff88988695a8a8, prev = 0xffff88988695a8a8}    /* empty */
     delayed_list = {next = 0xffff88988695a8b8, prev = 0xffff88988695a8b8}    /* empty */
     bitmap_list = {next = 0xffff88988695a8c8, prev = 0xffff88988695a8c8}    /* empty */
     retry_read_aligned = 0x0
     retry_read_offset = 0
     retry_read_aligned_list = 0x0
     preread_active_stripes = { counter=0 }  /* atomic_t */
     active_aligned_reads = { counter=0 }  /* atomic_t */
     pending_full_writes = { counter=0 }  /* atomic_t */
     bypass_count = 0
     bypass_threshold = 1
     skip_copy = 0
     last_hold = (struct list_head *) 0xffff88a299ea0010
     reshape_stripes = { counter=0 }  /* atomic_t */
     active_name = 0
     cache_name = [
(2)
         [0] : [
(8)
             [0] : 114 'r'
             [1] : 97 'a'
             [2] : 105 'i'
             [3] : 100 'd'
             [4] : 54 '6'
             [5] : 45 '-'
             [6] : 109 'm'
             [7] : 100 'd'
             [8] : 49 '1'
             [9] : 0 '\000'
             [10] : 0 '\000'
             [11] : 0 '\000'
             [12] : 0 '\000'
             [13] : 0 '\000'
             [14] : 0 '\000'
             [15] : 0 '\000'
             [16] : 0 '\000'
             [17] : 0 '\000'
             [18] : 0 '\000'
             [19] : 0 '\000'
             [20] : 0 '\000'
             [21] : 0 '\000'
             [22] : 0 '\000'
             [23] : 0 '\000'
             [24] : 0 '\000'
             [25] : 0 '\000'
             [26] : 0 '\000'
             [27] : 0 '\000'
             [28] : 0 '\000'
             [29] : 0 '\000'
             [30] : 0 '\000'
             [31] : 0 '\000'
         ]
         [1] : [
(8)
             [0] : 114 'r'
             [1] : 97 'a'
             [2] : 105 'i'
             [3] : 100 'd'
             [4] : 54 '6'
             [5] : 45 '-'
             [6] : 109 'm'
             [7] : 100 'd'
             [8] : 49 '1'
             [9] : 45 '-'
             [10] : 97 'a'
             [11] : 108 'l'
             [12] : 116 't'
             [13] : 0 '\000'
             [14] : 0 '\000'
             [15] : 0 '\000'
             [16] : 0 '\000'
             [17] : 0 '\000'
             [18] : 0 '\000'
             [19] : 0 '\000'
             [20] : 0 '\000'
             [21] : 0 '\000'
             [22] : 0 '\000'
             [23] : 0 '\000'
             [24] : 0 '\000'
             [25] : 0 '\000'
             [26] : 0 '\000'
             [27] : 0 '\000'
             [28] : 0 '\000'
             [29] : 0 '\000'
             [30] : 0 '\000'
             [31] : 0 '\000'
         ]
     ]
     slab_cache = (struct kmem_cache *) 0xffff8881078eca80
     cache_size_mutex = {
         owner = { counter=0 }  /* atomic_t */
         wait_lock = {counter=0} /* spinlock_t */
         osq = {
             tail = { counter=0 }  /* atomic_t */
         }
         wait_list = {next = 0xffff88988695a970, prev = 0xffff88988695a970}    /* empty */
     }
     seq_flush = 5031591
     seq_write = 5031591
     quiesce = 0
     fullsync = 0
     recovery_disabled = 15
     percpu = (struct raid5_percpu *) 0x604fdee147e8
     scribble_disks = 16
     scribble_sectors = 1024
     node = {
         next = 0x0
         pprev = (struct hlist_node **) 0xffff88810a5b89a8
     }
     active_stripes = { counter=27534 }  /* atomic_t */
     inactive_list = [
(3)
         [0] : {next = 0xffff88990fd76710, prev = 0xffff8889b7f72550}
         [1] : {next = 0xffff88959af002d0, prev = 0xffff889958cd4590}
         [2] : {next = 0xffff88a60a070150, prev = 0xffff88a37d3d0850}
         [3] : {next = 0xffff889e211e0690, prev = 0xffff8893a4000110}
         [4] : {next = 0xffff888c2139a350, prev = 0xffff88901a188410}
         [5] : {next = 0xffff88a83413e3d0, prev = 0xffff88a2090bc350}
         [6] : {next = 0xffff88a720d54310, prev = 0xffff888a0da6c5d0}
         [7] : {next = 0xffff888a0412c650, prev = 0xffff889250596550}
     ]
     r5c_cached_full_stripes = { counter=0 }  /* atomic_t */
     r5c_full_stripe_list = {next = 0xffff88988695aa48, prev = 0xffff88988695aa48}    /* empty */
     r5c_cached_partial_stripes = { counter=0 }  /* atomic_t */
     r5c_partial_stripe_list = {next = 0xffff88988695aa60, prev = 0xffff88988695aa60}    /* empty */
     r5c_flushing_full_stripes = { counter=0 }  /* atomic_t */
     r5c_flushing_partial_stripes = { counter=0 }  /* atomic_t */
     empty_inactive_list_nr = { counter=0 }  /* atomic_t */
     released_stripes = {
         first = 0x0
     }
     wait_for_quiescent = {
         lock = {counter=0} /* spinlock_t */
         head = {next = 0xffff88988695aa90, prev = 0xffff88988695aa90}    /* empty */
     }
     wait_for_stripe = {
         lock = {counter=0} /* spinlock_t */
         head = {next = 0xffffc9000e3f7c78, prev = 0xffffc9000e3f7c78}
     }
     wait_for_overlap = {
         lock = {counter=0} /* spinlock_t */
         head = {next = 0xffff88988695aac0, prev = 0xffff88988695aac0}    /* empty */
     }
     cache_state = 3
     shrinker = {
         count_objects = (long unsigned int (*)(struct shrinker *, struct shrink_control *)) 0xffffffff8198bc60 <raid5_cache_count>
         scan_objects = (long unsigned int (*)(struct shrinker *, struct shrink_control *)) 0xffffffff8198de90 <raid5_cache_scan>
         batch = 128
         seeks = 128
         flags = 0
         list = {next = 0xffff8898867e8c30, prev = 0xffffffffa0e14520}
         id = 0
         nr_deferred = (atomic_long_t *) 0xffff88988d8955c0
     }
     pool_size = 16
     device_lock = {counter=0} /* spinlock_t */
     disks = (struct disk_info *) 0xffff8898b1df3800
     bio_split = {
         bio_slab = (struct kmem_cache *) 0xffff889886fbdc00
         front_pad = 0
         bio_pool = {
             lock = {counter=0} /* spinlock_t */
             min_nr = 2
             curr_nr = 2
             elements = (void **) 0xffff8898b4fae280
             pool_data = (void *) 0xffff889886fbdc00
             alloc = (mempool_alloc_t *) 0xffffffff811c8540 <mempool_alloc_slab>
             free = (mempool_free_t *) 0xffffffff811c8560 <mempool_free_slab>
             wait = {
                 lock = {counter=0} /* spinlock_t */
                 head = {next = 0xffff88988695ab70, prev = 0xffff88988695ab70}    /* empty */
             }
         }
         bvec_pool = {
             lock = {counter=0} /* spinlock_t */
             min_nr = 0
             curr_nr = 0
             elements = 0x0
             pool_data = 0x0
             alloc = 0x0
             free = 0x0
             wait = {
                 lock = {counter=0} /* spinlock_t */
                 head = {next = 0x0000000000000000, prev = 0x0000000000000000}
             }
         }
         bio_integrity_pool = {
             lock = {counter=0} /* spinlock_t */
             min_nr = 0
             curr_nr = 0
             elements = 0x0
             pool_data = 0x0
             alloc = 0x0
             free = 0x0
             wait = {
                 lock = {counter=0} /* spinlock_t */
                 head = {next = 0x0000000000000000, prev = 0x0000000000000000}
             }
         }
         bvec_integrity_pool = {
             lock = {counter=0} /* spinlock_t */
             min_nr = 0
             curr_nr = 0
             elements = 0x0
             pool_data = 0x0
             alloc = 0x0
             free = 0x0
             wait = {
                 lock = {counter=0} /* spinlock_t */
                 head = {next = 0x0000000000000000, prev = 0x0000000000000000}
             }
         }
         rescue_lock = {counter=0} /* spinlock_t */
         rescue_list = {
             head = 0x0
             tail = 0x0
         }
         rescue_work = {
             data = { counter=68719476704 }  /* atomic_t */
             entry = {next = 0xffff88988695ac78, prev = 0xffff88988695ac78}    /* empty */
             func = (work_func_t) 0xffffffff81430230 <bio_alloc_rescue>
         }
         rescue_workqueue = 0x0
     }
     thread = 0x0
     temp_inactive_list = [
(3)
         [0] : {next = 0xffff88988695aca0, prev = 0xffff88988695aca0}    /* empty */
         [1] : {next = 0xffff88988695acb0, prev = 0xffff88988695acb0}    /* empty */
         [2] : {next = 0xffff88988695acc0, prev = 0xffff88988695acc0}    /* empty */
         [3] : {next = 0xffff88988695acd0, prev = 0xffff88988695acd0}    /* empty */
         [4] : {next = 0xffff88988695ace0, prev = 0xffff88988695ace0}    /* empty */
         [5] : {next = 0xffff88988695acf0, prev = 0xffff88988695acf0}    /* empty */
         [6] : {next = 0xffff88988695ad00, prev = 0xffff88988695ad00}    /* empty */
         [7] : {next = 0xffff88988695ad10, prev = 0xffff88988695ad10}    /* empty */
     ]
     worker_groups = 0x0
     group_cnt = 0
     worker_cnt_per_group = 0
     log = 0x0
     log_private = 0x0
     pending_bios_lock = {counter=0} /* spinlock_t */
     batch_bio_dispatch = true_21_
     pending_data = (struct r5pending_data *) 0xffff88988fae0000
     free_list = {next = 0xffff88988fae4fd8, prev = 0xffff88988fae0000}
     pending_list = {next = 0xffff88988695ad60, prev = 0xffff88988695ad60}    /* empty */
     pending_data_cnt = 0
     next_pending_data = 0x0
}


set $sh = container_of ((void *)0xffff88a57f1e6550, struct stripe_head, lru)

(gdb) dump *$sh

$L_010: (struct stripe_head *) 0xffff88a57f1e6540 : {
     hash = {
         next = (struct hlist_node *) 0xffff888768f7c680
         pprev = (struct hlist_node **) 0xffff8892f0520080
     }
     lru = {next = 0xffff88945e034510, prev = 0xffff8891d8f04210}
     release_list = {
         next = (struct llist_node *) 0xffff88945e034520
     }
     raid_conf = (struct r5conf *) 0xffff88988695a800
     generation = 0
     sector = 4947068032
     pd_idx = 14
     qd_idx = 15
     ddf_layout = 0
     hash_lock_index = 0
     state = 8242                                           # 0x2032  HANDLE + INSYNC + REPLACED + STARTED
     count = { counter=0 }  /* atomic_t */
     bm_seq = 5030861
     disks = 16
     overwrite_disks = 0
     check_state = check_state_idle_5_
     reconstruct_state = reconstruct_state_idle_5_
     stripe_lock = {counter=0} /* spinlock_t */
     cpu = 17
     group = 0x0
     batch_head = 0x0                                               # no batch
     batch_lock = {counter=0} /* spinlock_t */
     batch_list = {next = 0xffff88a57f1e65c8, prev = 0xffff88a57f1e65c8}    /* empty */
     /* anon union*/ {
         log_io = 0x0
         ppl_io = 0x0
     }
     log_list = {next = 0xffff88a57f1e65e0, prev = 0xffff88a57f1e65e0}    /* empty */
     log_start = 18446744073709551615
     r5c = {next = 0xffff88a57f1e65f8, prev = 0xffff88a57f1e65f8}    /* empty */
     ppl_page = 0x0
     ops = {
         target = 0
         target2 = 0
         zero_sum_result = 0_5_
     }


(gdb) dump $sh->dev[0]

$L_011: (struct r5dev *) 0xffff88a57f1e6620 : {
     req = {
         bi_next = 0x0
         bi_disk = 0x0
         bi_opf = 0
         bi_flags = 0
         bi_ioprio = 0
         bi_write_hint = 0
         bi_status = 0 '\000'
         bi_partno = 0 '\000'
         __bi_remaining = { counter=1 }  /* atomic_t */
         bi_iter = {
             bi_sector = 0
             bi_size = 0
             bi_idx = 0
             bi_bvec_done = 0
         }
         bi_end_io = 0x0
         bi_private = 0x0
         bi_blkg = 0x0
         bi_issue = {
             value = 0
         }
         /* anon union*/ {
             bi_integrity = 0x0
         }
         bi_vcnt = 0
         bi_max_vecs = 1
         __bi_cnt = { counter=1 }  /* atomic_t */
         bi_io_vec = (struct bio_vec *) 0xffff88a57f1e6710
         bi_pool = 0x0
         bi_inline_vecs = [
         ]
     }
     rreq = {
         bi_next = 0x0
         bi_disk = 0x0
         bi_opf = 0
         bi_flags = 0
         bi_ioprio = 0
         bi_write_hint = 0
         bi_status = 0 '\000'
         bi_partno = 0 '\000'
         __bi_remaining = { counter=1 }  /* atomic_t */
         bi_iter = {
             bi_sector = 0
             bi_size = 0
             bi_idx = 0
             bi_bvec_done = 0
         }
         bi_end_io = 0x0
         bi_private = 0x0
         bi_blkg = 0x0
         bi_issue = {
             value = 0
         }
         /* anon union*/ {
             bi_integrity = 0x0
         }
         bi_vcnt = 0
         bi_max_vecs = 1
         __bi_cnt = { counter=1 }  /* atomic_t */
         bi_io_vec = (struct bio_vec *) 0xffff88a57f1e6720
         bi_pool = 0x0
         bi_inline_vecs = [
         ]
     }
     vec = {
         bv_page = (struct page *) 0xffffea008ffccc80
         bv_len = 4096
         bv_offset = 0
     }
     rvec = {
         bv_page = 0x0
         bv_len = 0
         bv_offset = 0
     }
     page = (struct page *) 0xffffea008ffccc80
     orig_page = (struct page *) 0xffffea008ffccc80
     offset = 0
     toread = 0x0
     read = 0x0
     towrite = 0x0
     written = 0x0
     sector = 69258950784
     flags = 17                                                         # 0x11  : R5_UPTODATE + R5_INSYNC
     log_checksum = 0
     write_hint = 0
}

$sh->dev[1] .. $sh->dev[15] omitted. All the same, just different page buffers and sector numbers.

$sh->dev[14] and $sh->dev[15] have sector = 0.
