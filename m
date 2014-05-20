From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: raid6 - data integrity issue - data mis-compare on rebuilding
 RAID 6 - with 100 Mb resync speed.
Date: Mon, 19 May 2014 17:22:26 -0700
Message-ID: <CAA9_cmcMgfx4AuNrjNBy3e2oe9rFXc4i-CQT1JbCKSMDep0HFg@mail.gmail.com>
References: <13688C12F44C7C428726663F950CA2530972DC8C@venus.in.megatrends.com>
	<20140423170755.1aa92ba6@notabene.brown>
	<CAPcyv4gg6N_FYOZmooXTUYT22AOuBmqFuin_TiKqn8A9DOCnqw@mail.gmail.com>
	<20140505172110.73667211@notabene.brown>
	<CAA9_cmcn1mkm+FYzxbo-A1ih9d4fusskyA9UpQwcA9VDA_iWWA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAA9_cmcn1mkm+FYzxbo-A1ih9d4fusskyA9UpQwcA9VDA_iWWA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Manibalan P <pmanibalan@amiindia.co.in>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, May 16, 2014 at 11:11 AM, Dan Williams <dan.j.williams@intel.com> wrote:
> On Mon, May 5, 2014 at 12:21 AM, NeilBrown <neilb@suse.de> wrote:
>> On Wed, 23 Apr 2014 10:02:00 -0700 Dan Williams <dan.j.williams@intel.com>
>> wrote:
>>
>>> On Wed, Apr 23, 2014 at 12:07 AM, NeilBrown <neilb@suse.de> wrote:
>>> > On Fri, 11 Apr 2014 17:41:12 +0530 "Manibalan P" <pmanibalan@amiindia.co.in>
>>> > wrote:
>>> >
>>> >> Hi Neil,
>>> >>
>>> >> Also, I found the data corruption issue on RHEL 6.5.
>>> >>
>>> >> For your kind attention, I up-ported the md code [raid5.c + raid5.h]
>>> >> from FC11 kernel to CentOS 6.4, and there is no mis-compare with the
>>> >> up-ported code.
>>> >
>>> > This narrows it down to between 2.6.29 and 2.6.32 - is that correct?
>>> >
>>> > So it is probably the change to RAID6 to support async parity calculations.
>>> >
>>> > Looking at the code always makes my head spin.
>>> >
>>> > Dan : have you any ideas?
>>> >
>>> > It seems that writing to a double-degraded RAID6 while it is recovering to
>>> > a space can trigger data corruption.
>>> >
>>> > 2.6.29 works
>>> > 2.6.32 doesn't
>>> > 3.8.0 still doesn't.
>>> >
>>> > I suspect async parity calculations.
>>>
>>> I'll take a look.  I've had cleanups of that code on my backlog for "a
>>> while now (TM)".
>>
>>
>> Hi Dan,
>>  did you have a chance to have a look?
>>
>> I've been consistently failing to find anything.
>>
>> I have a question though.
>> If we set up a chain of async dma handling via:
>>    ops_run_compute6_2 then ops_bio_drain then ops_run_reconstruct
>>
>> is it possible for the ops_complete_compute callback set up by
>> ops_run_compute6_2 to be called before ops_run_reconstruct has been scheduled
>> or run?
>
> In the absence of a dma engine we never run asynchronously, so we will
> *always* call ops_complete_compute() before ops_run_reconstruct() in
> the synchronous acse.  This looks confused.  We're certainly leaking
> an uptodate state prior to the completion of the write.
>
>> If so, there seems to be some room for confusion over the setting for
>> R5_UPTODATE on blocks that are being computed and then drained to.  Both will
>> try to set the flag, so it could get set before reconstruction has run.
>>
>> I can't see that this would cause a problem, but then I'm not entirely sure
>> why we clear R5_UPTODATE when we set R5_Wantdrain.
>
> Let me see what problems this could be causing.  I'm thinking we
> should be protected by the global ->reconstruct_state, but something
> is telling me we do depend on R5_UPTODATE being consistent with the
> ongoing stripe operation.
>

Can you share your exact test scripts?  I'm having a hard time
reproducing this with something like:

echo 100000 > /proc/sys/dev/raid/speed_limit_min
mdadm --add /dev/md0 /dev/sd[bc]; dd if=urandom.dump of=/dev/md0
bs=1024M oflag=sync

This is a 7-drive raid6 array.
