From: Jinpu Wang <jinpu.wang@profitbricks.com>
Subject: (unknown)
Date: Tue, 20 Dec 2016 09:38:57 +0100
Message-ID: <CAMGffE=CSOJXC+SHNV39vA6rQCr5zB+DzdrH-NH4bwJq+A5P8Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
Subject: 
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org, Shaohua Li <shli@fb.com>, Nate Dailey <nate.dailey@stratus.com>
List-Id: linux-raid.ids

Hi Neil,

On Mon, Dec 19, 2016 at 11:45 PM, NeilBrown <neilb@suse.com> wrote:
> On Mon, Dec 19 2016, Jinpu Wang wrote:
>
>> Hi Neil,
>>
>> After apply the patch below, it paniced during boot in
>> generic_make_request-> bio_list_pop.
>> Looks related to you do bio_list_init(&bio_list_on_stack); again.
>>> diff --git a/block/blk-core.c b/block/blk-core.c
>>> index 14d7c0740dc0..3436b6fc3ef8 100644
>>> --- a/block/blk-core.c
>>> +++ b/block/blk-core.c
>>> @@ -2036,10 +2036,31 @@ blk_qc_t generic_make_request(struct bio *bio)
>>>                 struct request_queue *q =3D bdev_get_queue(bio->bi_bdev=
);
>>>
>>>                 if (likely(blk_queue_enter(q, false) =3D=3D 0)) {
>>> +                       struct bio_list hold;
>>> +                       struct bio_list lower, same;
>>> +
>>> +                       /* Create a fresh bio_list for all subordinate =
requests */
>>> +                       bio_list_merge(&hold, &bio_list_on_stack);
>
> This is the problem.  'hold' hasn't been initialised.
> We could either do:
>   bio_list_init(&hold);
>   bio_list_merge(&hold, &bio_list_on_stack);
I did try first variant, it leads to panic in bio_check_pages_dirty

PID: 4004   TASK: ffff8802337f3400  CPU: 1   COMMAND: "fio"

 #0 [ffff88023ec838d0] machine_kexec at ffffffff8104075a

 #1 [ffff88023ec83918] crash_kexec at ffffffff810d54c3

 #2 [ffff88023ec839e0] oops_end at ffffffff81008784

 #3 [ffff88023ec83a08] no_context at ffffffff8104a8f6

 #4 [ffff88023ec83a60] __bad_area_nosemaphore at ffffffff8104abcf

 #5 [ffff88023ec83aa8] bad_area_nosemaphore at ffffffff8104ad3e

 #6 [ffff88023ec83ab8] __do_page_fault at ffffffff8104afd7

 #7 [ffff88023ec83b10] do_page_fault at ffffffff8104b33c

 #8 [ffff88023ec83b20] page_fault at ffffffff818173a2

    [exception RIP: bio_check_pages_dirty+65]

    RIP: ffffffff813f6221  RSP: ffff88023ec83bd8  RFLAGS: 00010212

    RAX: 0000000000000020  RBX: ffff880232d75010  RCX: 0000000000000001

    RDX: ffff880232d74000  RSI: 0000000000000000  RDI: 0000000000000000

    RBP: ffff88023ec83bf8   R8: 0000000000000001   R9: 0000000000000000

    R10: ffffffff81f25ac0  R11: ffff8802348acef0  R12: 0000000000000001

    R13: 0000000000000000  R14: ffff8800b53b7d00  R15: ffff88009704d180

    ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018

 #9 [ffff88023ec83c00] dio_bio_complete at ffffffff811d010e

#10 [ffff88023ec83c38] dio_bio_end_aio at ffffffff811d0367

#11 [ffff88023ec83c68] bio_endio at ffffffff813f637a

#12 [ffff88023ec83c80] call_bio_endio at ffffffffa0868220 [raid1]

#13 [ffff88023ec83cc8] raid_end_bio_io at ffffffffa086885b [raid1]

#14 [ffff88023ec83cf8] raid1_end_read_request at ffffffffa086a184 [raid1]

#15 [ffff88023ec83d50] bio_endio at ffffffff813f637a

#16 [ffff88023ec83d68] blk_update_request at ffffffff813fdab6

#17 [ffff88023ec83da8] blk_mq_end_request at ffffffff81406dfe



> or just
>   hold =3D bio_list_on_stack;
>
>
> You didn't find 'hold' to be necessary in your testing, but I think that
> is more complex arrangements it could make an important difference.

Could you elaborate  a bit more, from my understanding, in later
logic, we traverse the whole bio_list_on_stack,
and sort it into either lower or same bio_list, merge again the
initial bio_list_on_stack will lead to duplicated bio, isn't it?

>
> Thanks,
> NeilBrown

Thanks
Jinpu
>
>
>>> +                       bio_list_init(&bio_list_on_stack); ??? maybe in=
it hold, and then merge bio_list_on_stack?
>>>                         ret =3D q->make_request_fn(q, bio);
>>>
>>>                         blk_queue_exit(q);



--=20
Jinpu Wang
Linux Kernel Developer

ProfitBricks GmbH
Greifswalder Str. 207
D - 10405 Berlin

Tel:       +49 30 577 008  042
Fax:      +49 30 577 008 299
Email:    jinpu.wang@profitbricks.com
URL:      https://www.profitbricks.de

Sitz der Gesellschaft: Berlin
Registergericht: Amtsgericht Charlottenburg, HRB 125506 B
Gesch=C3=A4ftsf=C3=BChrer: Achim Weiss
