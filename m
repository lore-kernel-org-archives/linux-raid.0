Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 544E71F584A
	for <linux-raid@vger.kernel.org>; Mon,  3 Mar 2025 11:15:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741000545; cv=none; b=gCEr8LbUe6f7Ej2DbfJZJW4M8Ji9bNw4hhsJ98s7swjOzyOtiVENH0qpeMLWTxAihoRHCfj+KX5ywDYA9JHiPtwt0Fwqgk+VsxobQzIjGcLhWaQevx8uCiWI6dOqmtoiyTjB3J6oMYu6FXRXXgS4CR7cxViGVosK+OZIj26cUg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741000545; c=relaxed/simple;
	bh=Rvanpx9WRzl4SQ1HdP2iV+M4Z3GHR5HCSwm0lVp0GMM=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EBVupxEY2+iQDYT34SITQccy8b638pYm2cXDCoU0dmS3nXEdG8AYJeioal66gATHMQjB0K/7JlFlE4V5rJURGofk5d/iG8zXRdRTzPU7Mk9NX8qDcP3h8dLFRXe0jiwhxggQjNraFkZDeSmkaTYPCjd9dqUuIQloEUXCCln8SdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=n4tAHHEl; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="n4tAHHEl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741000543; x=1772536543;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Rvanpx9WRzl4SQ1HdP2iV+M4Z3GHR5HCSwm0lVp0GMM=;
  b=n4tAHHElcR7euWULFtB779CKq+PtuysePOP/L1Mr74NxjKvtq4Tt9lmK
   PM0x9uf3kiIb0fEi5pubSvakU/Hue3BiYXSI6lDQ9w/GphFNooOLKOc+w
   +Drek9XbSO2vfpZocxJ5QzhC/rGUzuTSVSWevc2t9/6pt0U0xZXt1HYuw
   KULFS0uRnLIDuqr2FjUbWJQihPUCmcMDIxrbB8p4URea2PXbSlk3WBZ1E
   cvd6ETkOYMHy3pSAOmBNHBg/9iTvzBovjGqmqN5NUiNfA+RKi2BI1qrgR
   PE38lupEEzg2TE2mEusC+Typeqiytbu7muoEDZgLnT+i15lluCOq2xMBj
   A==;
X-CSE-ConnectionGUID: ZjjKx7M3TR2x8KfgM+GR7w==
X-CSE-MsgGUID: 2t/d/d5qSsaOuXNe01P+OQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11361"; a="53261758"
X-IronPort-AV: E=Sophos;i="6.13,329,1732608000"; 
   d="scan'208";a="53261758"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2025 03:15:43 -0800
X-CSE-ConnectionGUID: mQtw8XufRhu/yv4H3+ItRQ==
X-CSE-MsgGUID: KzRR+ZKLRKGErL8NOzcovQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,329,1732608000"; 
   d="scan'208";a="117967672"
Received: from bkucman-mobl1.ger.corp.intel.com (HELO localhost) ([10.245.81.248])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2025 03:15:40 -0800
Date: Mon, 3 Mar 2025 12:15:35 +0100
From: Blazej Kucman <blazej.kucman@linux.intel.com>
To: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Xiao Ni <xni@redhat.com>, "mtkaczyk@kernel.org" <mtkaczyk@kernel.org>,
 "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
 "ncroxon@redhat.com" <ncroxon@redhat.com>, "song@kernel.org"
 <song@kernel.org>, "yukuai@kernel.org" <yukuai@kernel.org>
Subject: Re: [PATCH V2] mdmon: imsm: fix metadata corruption when managing
 new array
Message-ID: <20250303121535.00006fd8@linux.intel.com>
In-Reply-To: <6DAD41A3-A511-46C7-9361-A9D975A69991@oracle.com>
References: <20250218184831.19694-1-junxiao.bi@oracle.com>
	<20250224141541.000042f1@linux.intel.com>
	<CALTww2-DSfGAO-f2Porbu3+vrhNGcAd=SsP7h+wciw60v12JAA@mail.gmail.com>
	<20250228103807.000028e7@linux.intel.com>
	<6DAD41A3-A511-46C7-9361-A9D975A69991@oracle.com>
Organization: intel
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Fri, 28 Feb 2025 15:56:03 +0000
Junxiao Bi <junxiao.bi@oracle.com> wrote:

> > On Feb 28, 2025, at 1:38=E2=80=AFAM, Blazej Kucman
> > <blazej.kucman@linux.intel.com> wrote:
> >=20
> > =EF=BB=BFOn Thu, 27 Feb 2025 14:48:17 +0800
> > Xiao Ni <xni@redhat.com> wrote:
> >  =20
> >>> On Mon, Feb 24, 2025 at 9:16=E2=80=AFPM Blazej Kucman
> >>> <blazej.kucman@linux.intel.com> wrote:
> >>>=20
> >>> On Tue, 18 Feb 2025 10:48:31 -0800
> >>> Junxiao Bi <junxiao.bi@oracle.com> wrote:
> >>>  =20
> >>>> When manager thread detects new array, it will invoke
> >>>> manage_new(). For imsm array, it will further invoke
> >>>> imsm_open_new(). Since commit bbab0940fa75("imsm: write bad block
> >>>> log on metadata sync"), it preallocates bad block log when
> >>>> opening the array, that requires increasing the mpb buffer size.
> >>>> For that, imsm_open_new() invokes function
> >>>> imsm_update_metadata_locally(), which first uses
> >>>> imsm_prepare_update() to allocate a larger mpb buffer and store
> >>>> it at "mpb->next_buf", and then invoke imsm_process_update() to
> >>>> copy the content from current mpb buffer "mpb->buf" to
> >>>> "mpb->next_buf", and then free the current mpb buffer and set the
> >>>> new buffer as current.
> >>>>=20
> >>>> There is a small race window, when monitor thread is syncing
> >>>> metadata, it gets current buffer pointer in
> >>>> imsm_sync_metadata()->write_super_imsm(), but before flushing the
> >>>> buffer to disk, manager thread does above switching buffer which
> >>>> frees current buffer, then monitor thread will run into
> >>>> use-after-free issue and could cause on-disk metadata corruption.
> >>>> If system keeps running, further metadata update could fix the
> >>>> corruption, because after switching buffer, the new buffer will
> >>>> contain good metadata, but if panic/power cycle happens while
> >>>> disk metadata is corrupted, the system will run into bootup
> >>>> failure if array is used as root, otherwise the array can not be
> >>>> assembled after boot if not used as root.
> >>>>=20
> >>>> This issue will not happen for imsm array with only one member
> >>>> array, because the memory array has not be opened yet, monitor
> >>>> thread will not do any metadata updates.
> >>>> This can happen for imsm array with at lease two member array, in
> >>>> the following two scenarios:
> >>>> 1. Restarting mdmon process with at least two member array
> >>>> This will happen during system boot up or user restart mdmon
> >>>> after mdadm upgrade
> >>>> 2. Adding new member array to exist imsm array with at least one
> >>>> member array.
> >>>>=20
> >>>> To fix this, delay the switching buffer operation to monitor
> >>>> thread.
> >>>>=20
> >>>> Fixes: bbab0940fa75("imsm: write bad block log on metadata sync")
> >>>> Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
> >>>> ---
> >>>> v2 <- v1:
> >>>> - address code style in manage_new()
> >>>> - make lines of git log not over 75 characters
> >>>>=20
> >>>> managemon.c   | 10 ++++++++--
> >>>> super-intel.c | 14 +++++++++++---
> >>>> 2 files changed, 19 insertions(+), 5 deletions(-)
> >>>>=20
> >>>> diff --git a/managemon.c b/managemon.c
> >>>> index d79813282457..74b64bfc9613 100644
> >>>> --- a/managemon.c
> >>>> +++ b/managemon.c
> >>>> @@ -721,11 +721,12 @@ static void manage_new(struct mdstat_ent
> >>>> *mdstat,
> >>>>       * the monitor.
> >>>>       */
> >>>>=20
> >>>> +     struct metadata_update *update =3D NULL;
> >>>>      struct active_array *new =3D NULL;
> >>>>      struct mdinfo *mdi =3D NULL, *di;
> >>>> -     int i, inst;
> >>>> -     int failed =3D 0;
> >>>>      char buf[SYSFS_MAX_BUF_SIZE];
> >>>> +     int failed =3D 0;
> >>>> +     int i, inst;
> >>>>=20
> >>>>      /* check if array is ready to be monitored */
> >>>>      if (!mdstat->active || !mdstat->level)
> >>>> @@ -824,9 +825,14 @@ static void manage_new(struct mdstat_ent
> >>>> *mdstat, /* if everything checks out tell the metadata handler we
> >>>> want to
> >>>>       * manage this instance
> >>>>       */
> >>>> +     container->update_tail =3D &update;
> >>>>      if (!aa_ready(new) || container->ss->open_new(container,
> >>>> new, inst) < 0) {
> >>>> +             container->update_tail =3D NULL;
> >>>>              goto error;
> >>>>      } else {
> >>>> +             if (update)
> >>>> +                     queue_metadata_update(update);
> >>>> +             container->update_tail =3D NULL;
> >>>>              replace_array(container, victim, new);
> >>>>              if (failed) {
> >>>>                      new->check_degraded =3D 1;
> >>>> diff --git a/super-intel.c b/super-intel.c
> >>>> index cab841980830..4988eef191da 100644
> >>>> --- a/super-intel.c
> >>>> +++ b/super-intel.c
> >>>> @@ -8467,12 +8467,15 @@ static int imsm_count_failed(struct
> >>>> intel_super *super, struct imsm_dev *dev, return failed;
> >>>> }
> >>>>=20
> >>>> +static int imsm_prepare_update(struct supertype *st,
> >>>> +                            struct metadata_update *update);
> >>>> static int imsm_open_new(struct supertype *c, struct
> >>>> active_array *a, int inst)
> >>>> {
> >>>>      struct intel_super *super =3D c->sb;
> >>>>      struct imsm_super *mpb =3D super->anchor;
> >>>> -     struct imsm_update_prealloc_bb_mem u;
> >>>> +     struct imsm_update_prealloc_bb_mem *u;
> >>>> +     struct metadata_update mu;
> >>>>=20
> >>>>      if (inst >=3D mpb->num_raid_devs) {
> >>>>              pr_err("subarry index %d, out of range\n", inst);
> >>>> @@ -8482,8 +8485,13 @@ static int imsm_open_new(struct supertype
> >>>> *c, struct active_array *a, dprintf("imsm: open_new %d\n", inst);
> >>>>      a->info.container_member =3D inst;
> >>>>=20
> >>>> -     u.type =3D update_prealloc_badblocks_mem;
> >>>> -     imsm_update_metadata_locally(c, &u, sizeof(u));
> >>>> +     u =3D xmalloc(sizeof(*u));
> >>>> +     u->type =3D update_prealloc_badblocks_mem;
> >>>> +     mu.len =3D sizeof(*u);
> >>>> +     mu.buf =3D (char *)u;
> >>>> +     imsm_prepare_update(c, &mu);
> >>>> +     if (c->update_tail)
> >>>> +             append_metadata_update(c, u, sizeof(*u));
> >>>>=20
> >>>>      return 0;
> >>>> }   =20
> >>>=20
> >>> Hi Junxiao,
> >>>=20
> >>> LGTM, Approved
> >>>=20
> >>> Thanks,
> >>> Blazej
> >>>  =20
> >>=20
> >> Hi Blazej
> >>=20
> >> Have you updated the PR
> >> https://github.com/md-raid-utilities/mdadm/pull/152 with this V2
> >> version?
> >>=20
> >> Regards
> >> Xiao
> >>  =20
> > Hi,
> >=20
> > Yes, the test result is the same as V1 but there is one note from
> > checkpatch
> >=20
> > WARNING:BAD_FIXES_TAG: Please use correct Fixes: style 'Fixes: <12
> > chars of sha1> ("<title line>")' - ie: 'Fixes: ca847037fafb
> > ("[V2]mdmon: imsm: fix metadata corruption when managing new
> > array")' #42: Fixes: bbab0940fa75("imsm: write bad block log on
> > metadata sync") =20
> If you don=E2=80=99t mind, just add a space between commit id and subject
> should fix it, the checkpatch seemed too strict on this.

Hi,=20
I corrected it in PR.

Regards,
Blazej

>=20
> Thanks,
> Junxiao
> >=20
> > Regards,
> > Blazej
> >  =20
> >>  =20
> >  =20

