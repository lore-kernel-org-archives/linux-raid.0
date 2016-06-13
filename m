From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [GIT PULL REQUEST] md fixes for 4.3
Date: Mon, 13 Jun 2016 09:31:04 -0400
Message-ID: <wrfjziqpqkpz.fsf@redhat.com>
References: <8737xrhylj.fsf@notabene.neil.brown.name>
	<CAGRgLy6f22pJscGab3i28BZGR6QXUP9sq1ygYD2m25yLt-cV5g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGRgLy6f22pJscGab3i28BZGR6QXUP9sq1ygYD2m25yLt-cV5g@mail.gmail.com>
	(Alexander Lyakas's message of "Mon, 13 Jun 2016 13:52:53 +0300")
Sender: linux-raid-owner@vger.kernel.org
To: Alexander Lyakas <alex.bolshoy@gmail.com>
Cc: Neil Brown <neil@brown.name>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Alexander Lyakas <alex.bolshoy@gmail.com> writes:
> Hello Neil,Jes,
>
> Question about the patch
> " md/raid1: Avoid raid1 resync getting stuck"
>
> Is this patch relevant for kernel 3.18? In Linus's tree I don't see
> this patch being tagged for stable[1].

Hi Alex,

I am not 200% sure as it's been a long time. Looking at it, I think it
falls into the category of has been around forever bugs and the patch
should be relevant for 3.18 too.

Cheers,
Jes

> [1]
> commit e8ff8bf09ff49733534ff3cee91bde030186055f
> Author: Jes Sorensen <Jes.Sorensen@redhat.com>
> Date:   Wed Sep 16 10:20:05 2015 -0400
>
>     md/raid1: Avoid raid1 resync getting stuck
>
>     close_sync() needs to set conf->next_resync to a large, but safe value
>     below MaxSector and use it to determine whether or not to set
>     start_next_window in wait_barrier()
>
>     Solution suggested by Neil Brown.
>
>     Reported-by: Nate Dailey <nate.dailey@stratus.com>
>     Tested-by: Xiao Ni <xni@redhat.com>
>     Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
>     Signed-off-by: NeilBrown <neilb@suse.com>
>
>
>
>
> On Sun, Oct 4, 2015 at 10:39 AM, Neil Brown <neil@brown.name> wrote:
>>
>> Hi Linus,
>>  a few md bug fixes.
>> Thanks,
>> NeilBrown
>>
>> The following changes since commit bcee19f424a0d8c26ecf2607b73c690802658b29:
>>
>>   Merge branch 'for-4.3-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup (2015-09-21 18:26:54 -0700)
>>
>> are available in the git repository at:
>>
>>   git://neil.brown.name/md tags/md/4.3-fixes
>>
>> for you to fetch changes up to da6fb7a9e5bd6f04f7e15070f630bdf1ea502841:
>>
>>   md/bitmap: don't pass -1 to bitmap_storage_alloc. (2015-10-02 17:24:13 +1000)
>>
>> ----------------------------------------------------------------
>> Assorted fixes for md in 4.3-rc
>>
>> Two tagged for -stable
>> One is really a cleanup to match and improve kmemcache interface.
>>
>> ----------------------------------------------------------------
>> Jes Sorensen (1):
>>       md/raid1: Avoid raid1 resync getting stuck
>>
>> Julia Lawall (1):
>>       md: drop null test before destroy functions
>>
>> NeilBrown (4):
>>       md: wait for pending superblock updates before switching to read-only
>>       md/raid5: don't index beyond end of array in need_this_block().
>>       md/raid0: apply base queue limits *before* disk_stack_limits
>>       md/bitmap: don't pass -1 to bitmap_storage_alloc.
>>
>> Shaohua Li (2):
>>       raid5: update analysis state for failed stripe
>>       md: clear CHANGE_PENDING in readonly array
>>
>>  drivers/md/bitmap.c    |  3 ++-
>>  drivers/md/md.c        |  5 +++++
>>  drivers/md/multipath.c |  3 +--
>>  drivers/md/raid0.c     | 12 ++++++------
>>  drivers/md/raid1.c     | 11 ++++-------
>>  drivers/md/raid10.c    |  9 +++------
>>  drivers/md/raid5.c     | 11 +++++++----
>>  7 files changed, 28 insertions(+), 26 deletions(-)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
