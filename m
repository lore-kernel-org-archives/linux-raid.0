Received: from va-2-29.ptr.blmpb.com (va-2-29.ptr.blmpb.com [209.127.231.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6C1B12B94
	for <linux-raid@vger.kernel.org>; Tue, 17 Mar 2026 03:36:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.29
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773718597; cv=none; b=FDKkohvtpYbNM+XfX8/EZZbJDUAv9xbfMwqB4RIMksTt8PQSb/O/c1X8pJZF3T3RltUyxA+szkDXthj81JjyWxcUY3NDez+kClywj/d8w+aHBrwxubydHFoKZPq1jeaDr0ZkRSaEqAs9VfXEmLaSME/nnYThQv0GkDRdKUtmtps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773718597; c=relaxed/simple;
	bh=19zMSTpP2ajUE723HMe7aIze5ZbPZhPNc2hZWcLpDOM=;
	h=Date:Message-Id:To:Cc:Subject:Content-Type:In-Reply-To:From:
	 Mime-Version:References; b=mKUTFTWDIQMSnImRfts+BG0BBF33c0k1cqOsTkVsyhkRYmmYhqhKakCvQDIOBm/XiOA/iFgnAbYecRPugHWSu0ttvf+h0BqhCoVNTezWJ8/si49f5Oy337SR+emGiIkGWWSLwZJQ/02wF/vG6C+umFjAKiw0F/U5MsaYWnWpnIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=I2EImq+S; arc=none smtp.client-ip=209.127.231.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="I2EImq+S"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1773718584;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=nAZNAV+tHwjLecWp0fAqZhZ95sDecJixCUBbYdfoTis=;
 b=I2EImq+SgInxnGx3xAMC5Ask6XRUafyVFIQEDMIgv450Se/FYwS1QV8IJs4plGW77c5wI9
 ELQxDIIXD//DiOTTnduz7jPK9ln5ULkg9bh/nO4mBF+pH4yRmLZRg1SgNFCBu9WHf4AZeN
 5UjDmbQexhOquRTvq9fhktnM9Ezt9/WRH3n/ElIVBlQ9+qyCIrACFUkdSSp8zeLXV96EQN
 XJBdJhwriM4Oo+F4m/8jKv3F/B5fioE7lW2At9xsDLLb8qLDaB3TOl4t7Denr7ejKNruFT
 qstA0ApKctd9gFNOoyixap+YrTLU0ulWQoaDrzU5pIDM+UididWxhsfYI7AlZw==
Reply-To: yukuai@fnnas.com
Date: Tue, 17 Mar 2026 11:36:19 +0800
Message-Id: <3f374305-2b1f-4c80-b27c-7c104eee3832@fnnas.com>
User-Agent: Mozilla Thunderbird
To: "Xiao Ni" <xni@redhat.com>, <yukuai@fnnas.com>
Cc: <song@kernel.org>, <linan122@huawei.com>, <colyli@fnnas.com>, 
	<linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Received: from [192.168.1.104] ([39.182.0.175]) by smtp.feishu.cn with ESMTPS; Tue, 17 Mar 2026 11:36:21 +0800
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v2 4/5] md/md-llbitmap: add CleanUnwritten state for RAID-5 proactive parity building
X-Original-From: Yu Kuai <yukuai@fnnas.com>
Content-Type: text/plain; charset=UTF-8
Content-Language: en-US
In-Reply-To: <CALTww2_cWUjHajL=7VRUSh-5jyzg4xK9ih2G_AhD3jMsF3qrAQ@mail.gmail.com>
From: "Yu Kuai" <yukuai@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260223024038.3084853-1-yukuai@fnnas.com> <20260223024038.3084853-5-yukuai@fnnas.com> <CALTww2_cWUjHajL=7VRUSh-5jyzg4xK9ih2G_AhD3jMsF3qrAQ@mail.gmail.com>
X-Lms-Return-Path: <lba+269b8cc36+123a5f+vger.kernel.org+yukuai@fnnas.com>

Hi,

=E5=9C=A8 2026/3/13 11:16, Xiao Ni =E5=86=99=E9=81=93:
> On Mon, Feb 23, 2026 at 10:44=E2=80=AFAM Yu Kuai <yukuai@fnnas.com> wrote=
:
>> Add new states to the llbitmap state machine to support proactive XOR
>> parity building for RAID-5 arrays. This allows users to pre-build parity
>> data for unwritten regions before any user data is written.
>>
>> New states added:
>> - BitNeedSyncUnwritten: Transitional state when proactive sync is trigge=
red
>>    via sysfs on Unwritten regions.
>> - BitSyncingUnwritten: Proactive sync in progress for unwritten region.
>> - BitCleanUnwritten: XOR parity has been pre-built, but no user data
>>    written yet. When user writes to this region, it transitions to BitDi=
rty.
>>
>> New actions added:
>> - BitmapActionProactiveSync: Trigger for proactive XOR parity building.
>> - BitmapActionClearUnwritten: Convert CleanUnwritten/NeedSyncUnwritten/
>>    SyncingUnwritten states back to Unwritten before recovery starts.
>>
>> State flows:
>> - Current (lazy): Unwritten -> (write) -> NeedSync -> (sync) -> Dirty ->=
 Clean
>> - New (proactive): Unwritten -> (sysfs) -> NeedSyncUnwritten -> (sync) -=
> CleanUnwritten
>> - On write to CleanUnwritten: CleanUnwritten -> (write) -> Dirty -> Clea=
n
>> - On disk replacement: CleanUnwritten regions are converted to Unwritten
>>    before recovery starts, so recovery only rebuilds regions with user d=
ata
>>
>> A new sysfs interface is added at /sys/block/mdX/md/llbitmap/proactive_s=
ync
>> (write-only) to trigger proactive sync. This only works for RAID-456 arr=
ays.
>>
>> Signed-off-by: Yu Kuai <yukuai@fnnas.com>
>> ---
>>   drivers/md/md-llbitmap.c | 140 +++++++++++++++++++++++++++++++++++----
>>   drivers/md/md.c          |   6 +-
>>   2 files changed, 132 insertions(+), 14 deletions(-)
>>
>> diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
>> index 5f9e7004e3e3..461050b2771b 100644
>> --- a/drivers/md/md-llbitmap.c
>> +++ b/drivers/md/md-llbitmap.c
>> @@ -208,6 +208,20 @@ enum llbitmap_state {
>>          BitNeedSync,
>>          /* data is synchronizing */
>>          BitSyncing,
>> +       /*
>> +        * Proactive sync requested for unwritten region (raid456 only).
>> +        * Triggered via sysfs when user wants to pre-build XOR parity
>> +        * for regions that have never been written.
>> +        */
>> +       BitNeedSyncUnwritten,
>> +       /* Proactive sync in progress for unwritten region */
>> +       BitSyncingUnwritten,
>> +       /*
>> +        * XOR parity has been pre-built for a region that has never had
>> +        * user data written. When user writes to this region, it transi=
tions
>> +        * to BitDirty.
>> +        */
>> +       BitCleanUnwritten,
>>          BitStateCount,
>>          BitNone =3D 0xff,
>>   };
>> @@ -232,6 +246,12 @@ enum llbitmap_action {
>>           * BitNeedSync.
>>           */
>>          BitmapActionStale,
>> +       /*
>> +        * Proactive sync trigger for raid456 - builds XOR parity for
>> +        * Unwritten regions without requiring user data write first.
>> +        */
>> +       BitmapActionProactiveSync,
>> +       BitmapActionClearUnwritten,
>>          BitmapActionCount,
>>          /* Init state is BitUnwritten */
>>          BitmapActionInit,
>> @@ -304,6 +324,8 @@ static char state_machine[BitStateCount][BitmapActio=
nCount] =3D {
>>                  [BitmapActionDaemon]            =3D BitNone,
>>                  [BitmapActionDiscard]           =3D BitNone,
>>                  [BitmapActionStale]             =3D BitNone,
>> +               [BitmapActionProactiveSync]     =3D BitNeedSyncUnwritten=
,
>> +               [BitmapActionClearUnwritten]    =3D BitNone,
>>          },
>>          [BitClean] =3D {
>>                  [BitmapActionStartwrite]        =3D BitDirty,
>> @@ -314,6 +336,8 @@ static char state_machine[BitStateCount][BitmapActio=
nCount] =3D {
>>                  [BitmapActionDaemon]            =3D BitNone,
>>                  [BitmapActionDiscard]           =3D BitUnwritten,
>>                  [BitmapActionStale]             =3D BitNeedSync,
>> +               [BitmapActionProactiveSync]     =3D BitNone,
>> +               [BitmapActionClearUnwritten]    =3D BitNone,
>>          },
>>          [BitDirty] =3D {
>>                  [BitmapActionStartwrite]        =3D BitNone,
>> @@ -324,6 +348,8 @@ static char state_machine[BitStateCount][BitmapActio=
nCount] =3D {
>>                  [BitmapActionDaemon]            =3D BitClean,
>>                  [BitmapActionDiscard]           =3D BitUnwritten,
>>                  [BitmapActionStale]             =3D BitNeedSync,
>> +               [BitmapActionProactiveSync]     =3D BitNone,
>> +               [BitmapActionClearUnwritten]    =3D BitNone,
>>          },
>>          [BitNeedSync] =3D {
>>                  [BitmapActionStartwrite]        =3D BitNone,
>> @@ -334,6 +360,8 @@ static char state_machine[BitStateCount][BitmapActio=
nCount] =3D {
>>                  [BitmapActionDaemon]            =3D BitNone,
>>                  [BitmapActionDiscard]           =3D BitUnwritten,
>>                  [BitmapActionStale]             =3D BitNone,
>> +               [BitmapActionProactiveSync]     =3D BitNone,
>> +               [BitmapActionClearUnwritten]    =3D BitNone,
>>          },
>>          [BitSyncing] =3D {
>>                  [BitmapActionStartwrite]        =3D BitNone,
>> @@ -344,6 +372,44 @@ static char state_machine[BitStateCount][BitmapActi=
onCount] =3D {
>>                  [BitmapActionDaemon]            =3D BitNone,
>>                  [BitmapActionDiscard]           =3D BitUnwritten,
>>                  [BitmapActionStale]             =3D BitNeedSync,
>> +               [BitmapActionProactiveSync]     =3D BitNone,
>> +               [BitmapActionClearUnwritten]    =3D BitNone,
>> +       },
>> +       [BitNeedSyncUnwritten] =3D {
>> +               [BitmapActionStartwrite]        =3D BitNeedSync,
>> +               [BitmapActionStartsync]         =3D BitSyncingUnwritten,
>> +               [BitmapActionEndsync]           =3D BitNone,
>> +               [BitmapActionAbortsync]         =3D BitUnwritten,
>> +               [BitmapActionReload]            =3D BitUnwritten,
>> +               [BitmapActionDaemon]            =3D BitNone,
>> +               [BitmapActionDiscard]           =3D BitUnwritten,
>> +               [BitmapActionStale]             =3D BitUnwritten,
>> +               [BitmapActionProactiveSync]     =3D BitNone,
>> +               [BitmapActionClearUnwritten]    =3D BitUnwritten,
>> +       },
>> +       [BitSyncingUnwritten] =3D {
>> +               [BitmapActionStartwrite]        =3D BitSyncing,
>> +               [BitmapActionStartsync]         =3D BitSyncingUnwritten,
> Hi Kuai
>
> Is it ok to set the above state to BitNone? The orignal state is
> already BitSyncingUnwritten.
>
>> +               [BitmapActionEndsync]           =3D BitCleanUnwritten,
>> +               [BitmapActionAbortsync]         =3D BitUnwritten,
>> +               [BitmapActionReload]            =3D BitUnwritten,
>> +               [BitmapActionDaemon]            =3D BitNone,
>> +               [BitmapActionDiscard]           =3D BitUnwritten,
>> +               [BitmapActionStale]             =3D BitUnwritten,
>> +               [BitmapActionProactiveSync]     =3D BitNone,
>> +               [BitmapActionClearUnwritten]    =3D BitUnwritten,
>> +       },
>> +       [BitCleanUnwritten] =3D {
>> +               [BitmapActionStartwrite]        =3D BitDirty,
>> +               [BitmapActionStartsync]         =3D BitNone,
>> +               [BitmapActionEndsync]           =3D BitNone,
>> +               [BitmapActionAbortsync]         =3D BitNone,
>> +               [BitmapActionReload]            =3D BitNone,
>> +               [BitmapActionDaemon]            =3D BitNone,
>> +               [BitmapActionDiscard]           =3D BitUnwritten,
>> +               [BitmapActionStale]             =3D BitUnwritten,
>> +               [BitmapActionProactiveSync]     =3D BitNone,
>> +               [BitmapActionClearUnwritten]    =3D BitUnwritten,
>>          },
>>   };
>>
>> @@ -376,6 +442,7 @@ static void llbitmap_infect_dirty_bits(struct llbitm=
ap *llbitmap,
>>                          pctl->state[pos] =3D level_456 ? BitNeedSync : =
BitDirty;
>>                          break;
>>                  case BitClean:
>> +               case BitCleanUnwritten:
>>                          pctl->state[pos] =3D BitDirty;
>>                          break;
>>                  }
>> @@ -383,7 +450,7 @@ static void llbitmap_infect_dirty_bits(struct llbitm=
ap *llbitmap,
>>   }
>>
>>   static void llbitmap_set_page_dirty(struct llbitmap *llbitmap, int idx=
,
>> -                                   int offset)
>> +                                   int offset, bool infect)
>>   {
>>          struct llbitmap_page_ctl *pctl =3D llbitmap->pctl[idx];
>>          unsigned int io_size =3D llbitmap->io_size;
>> @@ -398,7 +465,7 @@ static void llbitmap_set_page_dirty(struct llbitmap =
*llbitmap, int idx,
>>           * resync all the dirty bits, hence skip infect new dirty bits =
to
>>           * prevent resync unnecessary data.
>>           */
>> -       if (llbitmap->mddev->degraded) {
>> +       if (llbitmap->mddev->degraded || !infect) {
>>                  set_bit(block, pctl->dirty);
>>                  return;
>>          }
>> @@ -438,7 +505,9 @@ static void llbitmap_write(struct llbitmap *llbitmap=
, enum llbitmap_state state,
>>
>>          llbitmap->pctl[idx]->state[bit] =3D state;
>>          if (state =3D=3D BitDirty || state =3D=3D BitNeedSync)
>> -               llbitmap_set_page_dirty(llbitmap, idx, bit);
>> +               llbitmap_set_page_dirty(llbitmap, idx, bit, true);
>> +       else if (state =3D=3D BitNeedSyncUnwritten)
>> +               llbitmap_set_page_dirty(llbitmap, idx, bit, false);
>>   }
>>
>>   static struct page *llbitmap_read_page(struct llbitmap *llbitmap, int =
idx)
>> @@ -627,11 +696,10 @@ static enum llbitmap_state llbitmap_state_machine(=
struct llbitmap *llbitmap,
>>                          goto write_bitmap;
>>                  }
>>
>> -               if (c =3D=3D BitNeedSync)
>> +               if (c =3D=3D BitNeedSync || c =3D=3D BitNeedSyncUnwritte=
n)
>>                          need_resync =3D !mddev->degraded;
>>
>>                  state =3D state_machine[c][action];
>> -
>>   write_bitmap:
>>                  if (unlikely(mddev->degraded)) {
>>                          /* For degraded array, mark new data as need sy=
nc. */
>> @@ -658,8 +726,7 @@ static enum llbitmap_state llbitmap_state_machine(st=
ruct llbitmap *llbitmap,
>>                  }
>>
>>                  llbitmap_write(llbitmap, state, start);
>> -
>> -               if (state =3D=3D BitNeedSync)
>> +               if (state =3D=3D BitNeedSync || state =3D=3D BitNeedSync=
Unwritten)
>>                          need_resync =3D !mddev->degraded;
>>                  else if (state =3D=3D BitDirty &&
>>                           !timer_pending(&llbitmap->pending_timer))
>> @@ -1229,7 +1296,7 @@ static bool llbitmap_blocks_synced(struct mddev *m=
ddev, sector_t offset)
>>          unsigned long p =3D offset >> llbitmap->chunkshift;
>>          enum llbitmap_state c =3D llbitmap_read(llbitmap, p);
>>
>> -       return c =3D=3D BitClean || c =3D=3D BitDirty;
>> +       return c =3D=3D BitClean || c =3D=3D BitDirty || c =3D=3D BitCle=
anUnwritten;
>>   }
>>
>>   static sector_t llbitmap_skip_sync_blocks(struct mddev *mddev, sector_=
t offset)
>> @@ -1243,6 +1310,10 @@ static sector_t llbitmap_skip_sync_blocks(struct =
mddev *mddev, sector_t offset)
>>          if (c =3D=3D BitUnwritten)
>>                  return blocks;
>>
>> +       /* Skip CleanUnwritten - no user data, will be reset after recov=
ery */
>> +       if (c =3D=3D BitCleanUnwritten)
>> +               return blocks;
>> +
>>          /* For degraded array, don't skip */
>>          if (mddev->degraded)
>>                  return 0;
>> @@ -1261,14 +1332,25 @@ static bool llbitmap_start_sync(struct mddev *md=
dev, sector_t offset,
>>   {
>>          struct llbitmap *llbitmap =3D mddev->bitmap;
>>          unsigned long p =3D offset >> llbitmap->chunkshift;
>> +       enum llbitmap_state state;
>> +
>> +       /*
>> +        * Before recovery starts, convert CleanUnwritten to Unwritten.
>> +        * This ensures the new disk won't have stale parity data.
>> +        */
>> +       if (offset =3D=3D 0 && test_bit(MD_RECOVERY_RECOVER, &mddev->rec=
overy) &&
>> +           !test_bit(MD_RECOVERY_LAZY_RECOVER, &mddev->recovery))
>> +               llbitmap_state_machine(llbitmap, 0, llbitmap->chunks - 1=
,
>> +                                      BitmapActionClearUnwritten);
>> +
>>
>>          /*
>>           * Handle one bit at a time, this is much simpler. And it doesn=
't matter
>>           * if md_do_sync() loop more times.
>>           */
>>          *blocks =3D llbitmap->chunksize - (offset & (llbitmap->chunksiz=
e - 1));
>> -       return llbitmap_state_machine(llbitmap, p, p,
>> -                                     BitmapActionStartsync) =3D=3D BitS=
yncing;
>> +       state =3D llbitmap_state_machine(llbitmap, p, p, BitmapActionSta=
rtsync);
>> +       return state =3D=3D BitSyncing || state =3D=3D BitSyncingUnwritt=
en;
>>   }
>>
>>   /* Something is wrong, sync_thread stop at @offset */
>> @@ -1474,9 +1556,15 @@ static ssize_t bits_show(struct mddev *mddev, cha=
r *page)
>>          }
>>
>>          mutex_unlock(&mddev->bitmap_info.mutex);
>> -       return sprintf(page, "unwritten %d\nclean %d\ndirty %d\nneed syn=
c %d\nsyncing %d\n",
>> +       return sprintf(page,
>> +                      "unwritten %d\nclean %d\ndirty %d\n"
>> +                      "need sync %d\nsyncing %d\n"
>> +                      "need sync unwritten %d\nsyncing unwritten %d\n"
>> +                      "clean unwritten %d\n",
>>                         bits[BitUnwritten], bits[BitClean], bits[BitDirt=
y],
>> -                      bits[BitNeedSync], bits[BitSyncing]);
>> +                      bits[BitNeedSync], bits[BitSyncing],
>> +                      bits[BitNeedSyncUnwritten], bits[BitSyncingUnwrit=
ten],
>> +                      bits[BitCleanUnwritten]);
>>   }
>>
>>   static struct md_sysfs_entry llbitmap_bits =3D __ATTR_RO(bits);
>> @@ -1549,11 +1637,39 @@ barrier_idle_store(struct mddev *mddev, const ch=
ar *buf, size_t len)
>>
>>   static struct md_sysfs_entry llbitmap_barrier_idle =3D __ATTR_RW(barri=
er_idle);
>>
>> +static ssize_t
>> +proactive_sync_store(struct mddev *mddev, const char *buf, size_t len)
>> +{
>> +       struct llbitmap *llbitmap;
>> +
>> +       /* Only for RAID-456 */
>> +       if (!raid_is_456(mddev))
>> +               return -EINVAL;
>> +
>> +       mutex_lock(&mddev->bitmap_info.mutex);
>> +       llbitmap =3D mddev->bitmap;
>> +       if (!llbitmap || !llbitmap->pctl) {
>> +               mutex_unlock(&mddev->bitmap_info.mutex);
>> +               return -ENODEV;
>> +       }
>> +
>> +       /* Trigger proactive sync on all Unwritten regions */
>> +       llbitmap_state_machine(llbitmap, 0, llbitmap->chunks - 1,
>> +                              BitmapActionProactiveSync);
>> +
>> +       mutex_unlock(&mddev->bitmap_info.mutex);
>> +       return len;
>> +}
>> +
>> +static struct md_sysfs_entry llbitmap_proactive_sync =3D
>> +       __ATTR(proactive_sync, 0200, NULL, proactive_sync_store);
>> +
>>   static struct attribute *md_llbitmap_attrs[] =3D {
>>          &llbitmap_bits.attr,
>>          &llbitmap_metadata.attr,
>>          &llbitmap_daemon_sleep.attr,
>>          &llbitmap_barrier_idle.attr,
>> +       &llbitmap_proactive_sync.attr,
>>          NULL
>>   };
>>
>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>> index 245785ad0ffd..b6543d81ac96 100644
>> --- a/drivers/md/md.c
>> +++ b/drivers/md/md.c
>> @@ -9878,8 +9878,10 @@ void md_do_sync(struct md_thread *thread)
>>                                   * Give other IO more of a chance.
>>                                   * The faster the devices, the less we =
wait.
>>                                   */
>> -                               wait_event(mddev->recovery_wait,
>> -                                          !atomic_read(&mddev->recovery=
_active));
>> +                               wait_event_timeout(
>> +                                       mddev->recovery_wait,
>> +                                       !atomic_read(&mddev->recovery_ac=
tive),
>> +                                       HZ);
> Could you explain this change? It no longer waits for synchronous I/O
> to finish when the sync speed is fast. Does it have relasionship with
> this major change of this patch?

I should separate this change into another patch, I didn't notice this was
amended into this patch.

And I'll also check the return value and goto repeat if timeout, instead of
waiting for all sync_io to be done, I think this is more graceful and can a=
llow
sync io to be issued once current speed is less than sync speed min.

>
> Best Regards
> Xiao
>>                          }
>>                  }
>>          }
>> --
>> 2.51.0
>>
>>
--=20
Thansk,
Kuai
