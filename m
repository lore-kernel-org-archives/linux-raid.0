From: "NeilBrown" <neilb@suse.de>
Subject: RE: Resync failing to start.
Date: Tue, 9 Jun 2009 22:53:29 +1000 (EST)
Message-ID: <80291bb9f05d84d104ff6aeac8d46ba2.squirrel@neil.brown.name>
References: <3D76E016F4A2A749A1EB1A3FD83E22BC028D9D6F@uk-email.terastack.bluearc.com>
    <4ee98271b4c703fc080f63bb03667ee9.squirrel@neil.brown.name>
    <3D76E016F4A2A749A1EB1A3FD83E22BC028D9DF3@uk-email.terastack.bluearc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3D76E016F4A2A749A1EB1A3FD83E22BC028D9DF3@uk-email.terastack.bluearc.c
     om>
Sender: linux-raid-owner@vger.kernel.org
To: Simon Jackson <sjackson@bluearc.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, June 9, 2009 10:38 pm, Simon Jackson wrote:
>
> I checked with the system owner.  He does not have the output any more.
> Not sure how he cleared the problem.
>
> Kernel version: Linux  2.6.26-1-amd64 #1 SMP Sat Jan 10 17:57:00 UTC
> 2009 x86_64 GNU/Linux

I cannot see any changes since 2.6.26 that might fix any bugs about
resync not starting.
However I was in 2.6.26 that the "meaningless warning" I mentioned
first appeared.  I got rid of it for 2.6.27.
My guess is that all but one were "resync=DELAYED" and the other
was doing a resync.  This is of course normal.  This would have
cleared itself eventually when all the resyncs finished.

Is that possible?

NeilBrown

>
> I will ask him to try to reproduce the problem and get the output of
> /proc/mdstat.
>
> Simon.
>
> -----Original Message-----
> From: NeilBrown [mailto:neilb@suse.de]
> Sent: 09 June 2009 12:25
> To: Simon Jackson
> Cc: linux-raid@vger.kernel.org
> Subject: Re: Resync failing to start.
>
> On Tue, June 9, 2009 8:29 pm, Simon Jackson wrote:
>>
>> We had a hard reset on a system that has 3 RAID 1 partitions on a
> single
>> pair of disks.
>>
>> After the reboot it was noticed that all the md devices were in
>> resync=DELAYED state.
>>
>> I had a quick look in the /var/log/messages and saw the raid start up
>> messages that were queuing the raid syncs.
>>
>> However, a bit further down was the following call trace.  Does this
>> indicate that the resync process aborted?
>
> It's hard to be sure without the preceding half-dozen lines, but
> I don't think it indicates that anything has aborted - I think it
> is just a meaningless warning.
> You can easily check with "ps".
>
> What kernel version?
>
> Can you show the full output of "cat /proc/mdstat" ??
>
>
> NeilBrown
>
>
>
>>
>>
>> 2009-06-09T08:49:00+00:00 m211 kernel: [  377.961124] md1_resync    D
>> 0000000000000000     0  2055      2
>> 2009-06-09T08:49:00+00:00 m211 kernel: [  377.961128]
> ffff8100ddc67db0
>> 0000000000000046 0000000000000000 0000000000000000
>> 2009-06-09T08:49:00+00:00 m211 kernel: [  377.961131]
> ffff8100e50e4810
>> ffff8100e76a3470 ffff8100e50e4a98 0000000100000000
>> 2009-06-09T08:49:00+00:00 m211 kernel: [  377.961134]
> 0000000000000000
>> 0000000000000000 00000000ffffffff 0000000000000000
>> 2009-06-09T08:49:00+00:00 m211 kernel: [  377.961137] Call Trace:
>> 2009-06-09T08:49:00+00:00 m211 kernel: [  377.961171]
>> [<ffffffffa00bf9ad>] :md_mod:md_do_sync+0x224/0x908
>> 2009-06-09T08:49:00+00:00 m211 kernel: [  377.961177]
>> [<ffffffff80228cbd>] update_curr+0x44/0x6f
>> 2009-06-09T08:49:00+00:00 m211 kernel: [  377.961181]
>> [<ffffffff8022a4ad>] dequeue_entity+0x1a/0xa1
>> 2009-06-09T08:49:00+00:00 m211 kernel: [  377.961184]
>> [<ffffffff8022a36b>] __dequeue_entity+0x25/0x69
>> 2009-06-09T08:49:00+00:00 m211 kernel: [  377.961187]
>> [<ffffffff8020a857>] __switch_to+0x96/0x35e
>> 2009-06-09T08:49:00+00:00 m211 kernel: [  377.961190]
>> [<ffffffff8022f07f>] hrtick_set+0x88/0xf7
>> 2009-06-09T08:49:00+00:00 m211 kernel: [  377.961195]
>> [<ffffffff802461a9>] autoremove_wake_function+0x0/0x2e
>> 2009-06-09T08:49:00+00:00 m211 kernel: [  377.961204]
>> [<ffffffffa00c24b1>] :md_mod:md_thread+0xd7/0xed
>> 2009-06-09T08:49:00+00:00 m211 kernel: [  377.961212]
>> [<ffffffffa00c23da>] :md_mod:md_thread+0x0/0xed
>> 2009-06-09T08:49:00+00:00 m211 kernel: [  377.961214]
>> [<ffffffff80246083>] kthread+0x47/0x74
>> 2009-06-09T08:49:00+00:00 m211 kernel: [  377.961216]
>> [<ffffffff80230196>] schedule_tail+0x27/0x5c
>> 2009-06-09T08:49:00+00:00 m211 kernel: [  377.961219]
>> [<ffffffff8020cf28>] child_rip+0xa/0x12
>> 2009-06-09T08:49:00+00:00 m211 kernel: [  377.961225]
>> [<ffffffff8021a826>] lapic_next_event+0xf/0x13
>> 2009-06-09T08:49:00+00:00 m211 kernel: [  377.961229]
>> [<ffffffff8024603c>] kthread+0x0/0x74
>> 2009-06-09T08:49:00+00:00 m211 kernel: [  377.961231]
>> [<ffffffff8020cf1e>] child_rip+0x0/0x12
>> 2009-06-09T08:49:00+00:00 m211 kernel: [  377.961233]
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid"
> in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>

