From: Xiao Ni <xni@redhat.com>
Subject: Re: [PATCH 0/4] RFC: attempt to remove md deadlocks with metadata
 without
Date: Mon, 9 Oct 2017 13:32:16 +0800
Message-ID: <441ae9fe-fd73-2aac-8bb1-c64da28cda27@redhat.com>
References: <150518076229.32691.13542756562323866921.stgit@noble>
 <87o9qe9p3j.fsf@notabene.neil.brown.name>
 <446747392.10694917.1505364915884.JavaMail.zimbra@redhat.com>
 <871sn9alrh.fsf@notabene.neil.brown.name>
 <393232447.10845976.1505375841983.JavaMail.zimbra@redhat.com>
 <87vaju18dc.fsf@notabene.neil.brown.name>
 <c0e9b424-05d2-df6e-71ce-240a8141a2fd@redhat.com>
 <874lrc28x8.fsf@notabene.neil.brown.name>
 <1345780738.18087591.1507512089744.JavaMail.zimbra@redhat.com>
 <87a810zznc.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87a810zznc.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On 10/09/2017 12:57 PM, NeilBrown wrote:
> On Sun, Oct 08 2017, Xiao Ni wrote:
>
>> ----- Original Message -----
>>> From: "NeilBrown" <neilb@suse.com>
>>> To: "Xiao Ni" <xni@redhat.com>
>>> Cc: linux-raid@vger.kernel.org
>>> Sent: Friday, October 6, 2017 12:32:19 PM
>>> Subject: Re: [PATCH 0/4] RFC: attempt to remove md deadlocks with metadata without
>>>
>>> On Fri, Oct 06 2017, Xiao Ni wrote:
>>>
>>>> On 10/05/2017 01:17 PM, NeilBrown wrote:
>>>>> On Thu, Sep 14 2017, Xiao Ni wrote:
>>>>>
>>>>>>> What do
>>>>>>>    cat /proc/8987/stack
>>>>>>>    cat /proc/8983/stack
>>>>>>>    cat /proc/8966/stack
>>>>>>>    cat /proc/8381/stack
>>>>>>>
>>>>>>> show??
>>>>> ...
>>>>>
>>>>>> /usr/sbin/mdadm --grow --continue /dev/md0. Is it the reason to add
>>>>>> lockdep_assert_held(&mddev->reconfig_mutex)?
>>>>>> [root@dell-pr1700-02 ~]# cat /proc/8983/stack
>>>>>> [<ffffffffa0a3464c>] mddev_suspend+0x12c/0x160 [md_mod]
>>>>>> [<ffffffffa0a379ec>] suspend_lo_store+0x7c/0xe0 [md_mod]
>>>>>> [<ffffffffa0a3b7d0>] md_attr_store+0x80/0xc0 [md_mod]
>>>>>> [<ffffffff812ec8da>] sysfs_kf_write+0x3a/0x50
>>>>>> [<ffffffff812ec39f>] kernfs_fop_write+0xff/0x180
>>>>>> [<ffffffff81260457>] __vfs_write+0x37/0x170
>>>>>> [<ffffffff812619e2>] vfs_write+0xb2/0x1b0
>>>>>> [<ffffffff81263015>] SyS_write+0x55/0xc0
>>>>>> [<ffffffff810037c7>] do_syscall_64+0x67/0x150
>>>>>> [<ffffffff81777527>] entry_SYSCALL64_slow_path+0x25/0x25
>>>>>> [<ffffffffffffffff>] 0xffffffffffffffff
>>>>>>
>>>>>> [jbd2/md0-8]
>>>>>> [root@dell-pr1700-02 ~]# cat /proc/8966/stack
>>>>>> [<ffffffffa0a39b20>] md_write_start+0xf0/0x220 [md_mod]
>>>>>> [<ffffffffa0972b49>] raid5_make_request+0x89/0x8b0 [raid456]
>>>>>> [<ffffffffa0a34175>] md_make_request+0xf5/0x260 [md_mod]
>>>>>> [<ffffffff81376427>] generic_make_request+0x117/0x2f0
>>>>>> [<ffffffff81376675>] submit_bio+0x75/0x150
>>>>>> [<ffffffff8129e0b0>] submit_bh_wbc+0x140/0x170
>>>>>> [<ffffffff8129e683>] submit_bh+0x13/0x20
>>>>>> [<ffffffffa0957e29>] jbd2_write_superblock+0x109/0x230 [jbd2]
>>>>>> [<ffffffffa0957f8b>] jbd2_journal_update_sb_log_tail+0x3b/0x80 [jbd2]
>>>>>> [<ffffffffa09517ff>] jbd2_journal_commit_transaction+0x16ef/0x19e0 [jbd2]
>>>>>> [<ffffffffa0955d02>] kjournald2+0xd2/0x260 [jbd2]
>>>>>> [<ffffffff810c73f9>] kthread+0x109/0x140
>>>>>> [<ffffffff817776c5>] ret_from_fork+0x25/0x30
>>>>>> [<ffffffffffffffff>] 0xffffffffffffffff
>>>>> Thanks for this (and sorry it took so long to get to it).
>>>>> It looks like
>>>>>
>>>>> Commit: cc27b0c78c79 ("md: fix deadlock between mddev_suspend() and
>>>>> md_write_start()")
>>>>>
>>>>> is badly broken.  I wonder how it ever passed testing.
>>>>>
>>>>> In write_start() is change the wait_event() call to
>>>>>
>>>>> 	wait_event(mddev->sb_wait,
>>>>> 		   !test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags) &&
>>>>> 		   !mddev->suspended);
>>>>>
>>>>>
>>>>> That should be
>>>>>
>>>>> 	wait_event(mddev->sb_wait,
>>>>> 		   !test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags) ||
>>>>> 		   mddev->suspended);
>>>> Hi Neil
>>>>
>>>> Do we want write bio can be handled when mddev->suspended is 1? After
>>>> changing to this,
>>>> write bio can be handled when mddev->suspended is 1.
>>> This is OK.
>>> New write bios will not get past md_handle_request().
>>> A write bios that did get past md_handle_request() is still allowed
>>> through md_write_start().  The mddev_suspend() call won't complete until
>>> that write bio has finished.
>> Hi Neil
>>
>> Thanks for the explanation. I took some time to read the emails about the
>> patch cc27b0c78 which introduced this. It's similar with this problem I
>> countered. But there is a call of function mddev_suspend in level_store.
>> So add the check of mddev->suspended in md_write_start can fix the problem
>> "reshape raid5 -> raid6 atop bcache deadlocks at start on md_attr_store /
>> raid5_make_request".
>>
>> In function suspend_lo_store it doesn't call mddev_suspend under mddev->reconfig_mutex.
> It would if you had applied
>     [PATCH 3/4] md: use mddev_suspend/resume instead of ->quiesce()
>
> Did you apply all 4 patches?

Sorry, it's my mistake. I insmod the wrong module. I'll apply the four 
patches
and do test again.
> Thanks.  I looks suspend_lo_store() is calling raid5_quiesce() directly
> as you say - so a patch is missing.

Yes, thanks for pointing about this.

>>>> Hmm, I have a question. Why can't call md_check_recovery when
>>>> MD_SB_CHANGE_PENDING
>>>> is set in raid5d?
>>> When MD_SB_CHANGE_PENDING is not set, there is no need to call
>>> md_check_recovery().  I wouldn't hurt except that it would be a waste of
>>> time.
>> I'm confused. If we want to call md_check_recovery when MD_SB_CHANGE_PENDING
>> is set, it should be
> Sorry, I described the condition wrongly.
> If any bit is set in ->sb_flags (except MD_SB_CHANGE_PENDING), then
> we need to call md_check_recovery().  If none of those other bits
> are set, there is no need.

Hmm, so it's the first question. Why can't call md_check_recovery when 
MD_SB_CHANGE_PENDING
is set. It needs to update the superblock too when MD_SB_CHANGE_PENDING 
is set. I can't
understand this part.

Can it be:
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -6299,7 +6299,7 @@ static void raid5d(struct md_thread *thread)
                         break;
                 handled += batch_size;

-               if (mddev->sb_flags & ~(1 << MD_SB_CHANGE_PENDING)) {
+               if (mddev->sb_flags) {


Best Regards
Xiao

>
> NeilBrown

