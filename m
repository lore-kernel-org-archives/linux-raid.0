From: Xiao Ni <xni@redhat.com>
Subject: Re: [PATCH 0/4] RFC: attempt to remove md deadlocks with metadata
 without
Date: Fri, 6 Oct 2017 11:40:18 +0800
Message-ID: <cd519be9-2929-6d30-44b1-bc372e74fe3c@redhat.com>
References: <150518076229.32691.13542756562323866921.stgit@noble>
 <f5b2cb91-3a9e-69ba-6b01-51335ec74da1@redhat.com>
 <87y3oq18zs.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87y3oq18zs.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On 10/05/2017 01:03 PM, NeilBrown wrote:
> On Sat, Sep 30 2017, Xiao Ni wrote:
>
>> On 09/12/2017 09:49 AM, NeilBrown wrote:
>>> Hi,
>>>    I looked again at the previous patch I posted which tried to mak
>>>    md_update_sb() safe without taking reconfig_mutex, and realized that
>>>    it had serious problems, particularly around devices being added or
>>>    removed while the update was happening.
>> Could you explain this in detail? What's the serious problems?
> My patch allowed md_update_sb() to run without holding ->reconfig_mutex.
> md_update_sb() uses rdev_for_each() in several places, so either that
> list needs to be kept stable, or md_update_sb() needs to ensure it is
> very careful while walking the list.
>
> I couldn't just use a spinlock to protect the lists because one of the
> rdev_for_Each calls md_super_write() on some of the devices, which is
> not allowed while holding a spinlock.
>
> I decided it was too hard to make md_update_sb() walk the list in a
> fully say manner.
>
> NeilBrown

Hi Neil

Thanks for this explanation. Now I know the reason.

Regards
XIao
>
>
>> Regards
>> Xiao
>>>    So I decided to try a different approach, which is embodied in these
>>>    patches.  The md thread is now explicitly allowed to call
>>>    md_update_sb() while some other thread holds the lock and
>>>    waits for mddev_suspend() to complete.
>>>
>>>    Please test these and confirm that they still address the problem you
>>>    found.
>>>
>>> Thanks,
>>> NeilBrown
>>>
>>> ---
>>>
>>> NeilBrown (4):
>>>         md: always hold reconfig_mutex when calling mddev_suspend()
>>>         md: don't call bitmap_create() while array is quiesced.
>>>         md: use mddev_suspend/resume instead of ->quiesce()
>>>         md: allow metadata update while suspending.
>>>
>>>
>>>    drivers/md/dm-raid.c     |    5 ++++-
>>>    drivers/md/md.c          |   45 ++++++++++++++++++++++++++++++++-------------
>>>    drivers/md/md.h          |    6 ++++++
>>>    drivers/md/raid5-cache.c |    2 ++
>>>    4 files changed, 44 insertions(+), 14 deletions(-)
>>>
>>> --
>>> Signature
>>>

