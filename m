From: Sebastian Riemer <sebastian.riemer@profitbricks.com>
Subject: Re: [PATCH v2] md: also hot remove disk from pers when hot removing
Date: Tue, 20 Nov 2012 10:52:09 +0100
Message-ID: <50AB52C9.3070802@profitbricks.com>
References: <1353081849-10516-1-git-send-email-sebastian.riemer@profitbricks.com> <CAA9_cmcViMsVMrxyEcC9yaHPq9Xc-5Dt63fMEJ+X+kZst8O9Fg@mail.gmail.com> <50AA0985.6060601@profitbricks.com> <50AA596D.4080003@profitbricks.com> <20121120081938.1c49f6e8@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20121120081938.1c49f6e8@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Dan Williams <djbw@fb.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 19.11.2012 22:19, NeilBrown wrote:
> On Mon, 19 Nov 2012 17:08:13 +0100 Sebastian Riemer
> <sebastian.riemer@profitbricks.com> wrote:
>
>> On 19.11.2012 11:27, Sebastian Riemer wrote:
>>> On 17.11.2012 01:07, Dan Williams wrote:
>>>> Hmm, how are you getting ->raid_disk set to -1 without the personality
>>>> being notified? That seems to be the source of the bug. Otherwise it
>>>> would seem the state_store("remove") path is also susceptible.
>>>>
>>>> --
>>>> Dan
>>> Thanks for your feedback!
>>>
>>> Perhaps it's only something for my use-case of read-only
>>> raid1-replicated volumes where I never have any spares. I don't set
>>> ->raid_disk to -1 when hot adding them. I have to put them directly to
>>> their stored slot because I assemble read-only on read-only rdevs. So
>>> the syncer never runs. Those read-only rdevs are coming from remote
>>> storage. Imagine HA CD-ROM images.
>>>
>>> My thought was that it would be cleaner behavior if the cleanup of an
>>> rdev in the personality already happens when hot removing the disk.
>>>
>>> You're right, the state_store("remove") path would need this change,
too.
>>>
>>> With the "slot_store" path I could trigger a panic when I hot added the
>>> disk as spare, marked it insync and tried to give it the slot it belongs
>>> to. I'll test this with the latest vanilla kernel and try to reproduce
>>> this on rw volumes which I set to read-only. If I can also crash it that
>>> way, I've got a proof that there is a bug.
>>
>> The kernel blocks most ioctls on a read-only mddev. So I guess I've got
>> another custom patch. IMHO it would be still cleaner to also hot remove
>> the disk from the personality when hot removing an rdev.
>
> But you *cannot* hot-remove an rdev when it is owned by the personality.
> The "remove from the personality" operation is called "--fail".
> The "remove from array" operation is call "--remove".
>
> It would be wrong to conflate these two.
>
> Thanks for confirming it was a local problem - I won't go hunting.
>
> NeilBrown
>

Thanks for the hint!

Ahhh, O.K., found it: md_check_recovery() and remove_and_add_spares()
handle the hot remove from the personality. I have to convince them to
handle my special read-only rdevs as well. The error handler of the
personality just sets the "Faulty" flag and the raid1d() calls
md_check_recovery() afterwards.

Cheers,
Sebastian

