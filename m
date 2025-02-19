Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 166521B423B
	for <linux-raid@vger.kernel.org>; Wed, 19 Feb 2025 17:50:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739987411; cv=none; b=a1R4grRtgqj0D4Y37UlKPuCRgO2USLVTfIFLog0SsI/+OYpcRRX1li0uG5tNtwo/oYfVVA5mdfYC4pQJsgqTJu8bBwSvFVTKoOoR8wmrQEPaEEfzoke0RVEBUdgWXWRdZA0S9hqqRJZyi5AI2D2gczk6A/Gz9hrCulMWA/Le6VE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739987411; c=relaxed/simple;
	bh=qmaLxwwTmnjNi2DHHXlbQdmKNpNf+kUUAD454yCR8YM=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FdGgsa3V9ORypSFwH8x/G93lF4FSPM27zMjw4NBcfUW657JeUvFlgeCs/kG0K+SFMbY3aKXXP967h99YCZHAte0nmDwXvg/NwX1tW3llCoyvUDu14SHzRU+WXtSEM4mOzMyJyl8ECg3eKMIuEv4mz/WYTCBjpD6ZKw+V1ML6jm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mr9LYqK+; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mr9LYqK+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739987410; x=1771523410;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qmaLxwwTmnjNi2DHHXlbQdmKNpNf+kUUAD454yCR8YM=;
  b=mr9LYqK+ZwMpdyp+poG1XK2KeE8lDscf3zNKl7spPNWjTqjLb5ed46ZK
   0SldnTIF5KIIZqgqYWaqjMlrkV1BhU8Z6E5thqRca6quhnLHGBpXHCgxK
   Oo384kxy985hsR/IZqLOFjt9J5btawE+URihr5MvqhwwdBmQZGfwIcRby
   Zd5/jJxglqK5x8squ7Fsqp6rah+pw9twNovYune1j7VEo7C9k44mN5Bov
   tRvXyLp2HayW8KEtqTbfqwPXv5txLFbhgU9UQWFZjMa7UZWaOfUCde3NP
   0TwzyP6+fSpVu5AdFeQM2pj9AUo3p1C1Uh5UI5UJ0K7nZ3guJznXGN6G3
   w==;
X-CSE-ConnectionGUID: hEsChMyeTt6v/cW0HIBjrA==
X-CSE-MsgGUID: 3UQ+fUfRT7i/hW53tYZD7Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11350"; a="51720655"
X-IronPort-AV: E=Sophos;i="6.13,299,1732608000"; 
   d="scan'208";a="51720655"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2025 09:50:09 -0800
X-CSE-ConnectionGUID: Ag8Tkq+LTK++m48lX5U+0w==
X-CSE-MsgGUID: nA3Owx3ETiKXMrQ6/hcC/w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,299,1732608000"; 
   d="scan'208";a="145625111"
Received: from unknown (HELO localhost) ([10.217.182.253])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2025 07:55:06 -0800
Date: Wed, 19 Feb 2025 16:54:46 +0100
From: Blazej Kucman <blazej.kucman@linux.intel.com>
To: junxiao.bi@oracle.com
Cc: Mariusz Tkaczyk <mtkaczyk@kernel.org>, linux-raid@vger.kernel.org,
 ncroxon@redhat.com, song@kernel.org, xni@redhat.com, yukuai@kernel.org
Subject: Re: [PATCH] mdmon: imsm: fix metadata corruption when managing new
 array
Message-ID: <20250219165446.000010b4@linux.intel.com>
In-Reply-To: <2170b01d-33a0-4cc5-984b-3e0d91f42e9e@oracle.com>
References: <20250210212225.10633-1-junxiao.bi@oracle.com>
	<20250212110713.1f112947@mtkaczyk-private-dev>
	<20250212225016.000060d9@linux.intel.com>
	<6d5c8902-ec3b-4d2e-baed-c926ad99cd8d@oracle.com>
	<20250218192228.2997b2e6@mtkaczyk-private-dev>
	<2170b01d-33a0-4cc5-984b-3e0d91f42e9e@oracle.com>
Organization: intel
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: quoted-printable

On Tue, 18 Feb 2025 10:50:46 -0800
junxiao.bi@oracle.com wrote:

> Thanks Mariusz for the review and share the test details.
>=20
> I have sent a v2 to address the code/log style issue.
>=20
> Hi Blazej, can you help review the v2 version?

Hi Junxiao,

Sorry for the delay, I need some more time, I want to run this through
our internal functional testing, but unfortunately I have a CI failure.

Regards,
Blazej

>=20
> Thanks,
>=20
> Junxiao.
>=20
> On 2/18/25 10:22 AM, Mariusz Tkaczyk wrote:
> > Hello,
> > Sorry for a delay.
> >
> > On Wed, 12 Feb 2025 22:38:13 -0800
> > junxiao.bi@oracle.com wrote:
> > =20
> >> Hi Mariusz & Blazej,
> >>
> >> Thanks for the review and file PR.
> >>
> >> Please check other comments below.
> >>
> >> On 2/12/25 1:51 PM, Blazej Kucman wrote: =20
> >>> On Wed, 12 Feb 2025 11:07:13 +0100
> >>> Mariusz Tkaczyk <mtkaczyk@kernel.org> wrote:
> >>>    =20
> >>>> Hello Junxiao,
> >>>> Thanks for solid and complete explanation!
> >>>>
> >>>> On Mon, 10 Feb 2025 13:22:25 -0800
> >>>> Junxiao Bi <junxiao.bi@oracle.com> wrote:
> >>>>    =20
> >>>>> When manager thread detects new array, it will invoke
> >>>>> manage_new(). For imsm array, it will further invoke
> >>>>> imsm_open_new(). Since commit bbab0940fa75("imsm: write bad
> >>>>> block log on metadata sync"), it preallocates bad block log when
> >>>>> opening the array, that requires increasing the mpb buffer size.
> >>>>> To do that, imsm_open_new() invokes
> >>>>> imsm_update_metadata_locally(), which first uses
> >>>>> imsm_prepare_update() to allocate a larger mpb buffer and store
> >>>>> it at "mpb->next_buf", and then invoke imsm_process_update() to
> >>>>> copy the content from current mpb buffer "mpb->buf" to
> >>>>> "mpb->next_buf", and then free the current mpb buffer and set
> >>>>> the new buffer as current.
> >>>>>
> >>>>> There is a small race window, when monitor thread is syncing
> >>>>> metadata, it grabs current buffer pointer in
> >>>>> imsm_sync_metadata()->write_super_imsm(), but before flushing
> >>>>> the buffer to disk, manager thread does above switching buffer
> >>>>> which frees current buffer, then monitor thread will run into
> >>>>> use-after-free issue and could cause on-disk metadata
> >>>>> corruption. If system keeps running, further metadata update
> >>>>> could fix the corruption, because after switching buffer, the
> >>>>> new buffer will contain good metadata, but if panic/power cycle
> >>>>> happens while disk metadata is corrupted, the system will run
> >>>>> into bootup failure if array is used as root, otherwise the
> >>>>> array can not be assembled after boot if not used as root.
> >>>>>
> >>>>> This issue will not happen for imsm array with only one member
> >>>>> array, because the memory array has not be opened yet, monitor
> >>>>> thread will not do any metadata updates.
> >>>>> This can happen for imsm array with at lease two member array,
> >>>>> in the following two scenarios:
> >>>>> 1. Restarting mdmon process with at least two member array
> >>>>> This will happen during system boot up or user restart mdmon
> >>>>> after mdadm upgrade
> >>>>> 2. Adding new member array to exist imsm array with at least one
> >>>>> member array.
> >>>>>
> >>>>> To fix this, delay the switching buffer operation to monitor
> >>>>> thread.
> >>>>>
> >>>>> Fixes: bbab0940fa75 ("imsm: write bad block log on metadata
> >>>>> sync") Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
> >>>>> ---
> >>>>>    managemon.c   |  6 ++++++
> >>>>>    super-intel.c | 14 +++++++++++---
> >>>>>    2 files changed, 17 insertions(+), 3 deletions(-)
> >>>>>
> >>>>> diff --git a/managemon.c b/managemon.c
> >>>>> index d79813282457..855c85c3da92 100644
> >>>>> --- a/managemon.c
> >>>>> +++ b/managemon.c
> >>>>> @@ -726,6 +726,7 @@ static void manage_new(struct mdstat_ent
> >>>>> *mdstat, int i, inst;
> >>>>>    	int failed =3D 0;
> >>>>>    	char buf[SYSFS_MAX_BUF_SIZE];
> >>>>> +	struct metadata_update *update =3D NULL; =20
> >>>> If you are adding something new here, please follow reversed
> >>>> Christmas tree convention. =20
> >> got it, i will move this new variable to the top of the function in
> >> v2. Should i move variable "buf" to proper location as well?
> >>
> >> =20
> > Either way is fine. I have no objections to do this.
> > =20
> >>>>    =20
> >>>>>   =20
> >>>>>    	/* check if array is ready to be monitored */
> >>>>>    	if (!mdstat->active || !mdstat->level)
> >>>>> @@ -824,9 +825,14 @@ static void manage_new(struct mdstat_ent
> >>>>> *mdstat, /* if everything checks out tell the metadata handler
> >>>>> we want to
> >>>>>    	 * manage this instance
> >>>>>    	 */
> >>>>> +	container->update_tail =3D &update;
> >>>>>    	if (!aa_ready(new) ||
> >>>>> container->ss->open_new(container, new, inst) < 0) {
> >>>>> +		container->update_tail =3D NULL;
> >>>>>    		goto error;
> >>>>>    	} else {
> >>>>> +		if (update)
> >>>>> +			queue_metadata_update(update);
> >>>>> +		container->update_tail =3D NULL;
> >>>>>    		replace_array(container, victim, new);
> >>>>>    		if (failed) {
> >>>>>    			new->check_degraded =3D 1;
> >>>>> diff --git a/super-intel.c b/super-intel.c
> >>>>> index cab841980830..4988eef191da 100644
> >>>>> --- a/super-intel.c
> >>>>> +++ b/super-intel.c
> >>>>> @@ -8467,12 +8467,15 @@ static int imsm_count_failed(struct
> >>>>> intel_super *super, struct imsm_dev *dev, return failed;
> >>>>>    }
> >>>>>   =20
> >>>>> +static int imsm_prepare_update(struct supertype *st,
> >>>>> +			       struct metadata_update *update);
> >>>>>    static int imsm_open_new(struct supertype *c, struct
> >>>>> active_array *a, int inst)
> >>>>>    {
> >>>>>    	struct intel_super *super =3D c->sb;
> >>>>>    	struct imsm_super *mpb =3D super->anchor;
> >>>>> -	struct imsm_update_prealloc_bb_mem u;
> >>>>> +	struct imsm_update_prealloc_bb_mem *u;
> >>>>> +	struct metadata_update mu;
> >>>>>   =20
> >>>>>    	if (inst >=3D mpb->num_raid_devs) {
> >>>>>    		pr_err("subarry index %d, out of range\n",
> >>>>> inst); @@ -8482,8 +8485,13 @@ static int imsm_open_new(struct
> >>>>> supertype *c, struct active_array *a, dprintf("imsm: open_new
> >>>>> %d\n", inst); a->info.container_member =3D inst;
> >>>>>   =20
> >>>>> -	u.type =3D update_prealloc_badblocks_mem;
> >>>>> -	imsm_update_metadata_locally(c, &u, sizeof(u));
> >>>>> +	u =3D xmalloc(sizeof(*u));
> >>>>> +	u->type =3D update_prealloc_badblocks_mem;
> >>>>> +	mu.len =3D sizeof(*u);
> >>>>> +	mu.buf =3D (char *)u;
> >>>>> +	imsm_prepare_update(c, &mu);
> >>>>> +	if (c->update_tail)
> >>>>> +		append_metadata_update(c, u, sizeof(*u));
> >>>>>   =20
> >>>>>    	return 0;
> >>>>>    } =20
> >>>> I don't see issues, so you have my approve but it is Intel owned
> >>>> code and I need Intel to approve.
> >>>> .
> >>>> Blazej, Could you please create Github PR with a patch if Intel
> >>>> is good with the change? I would like to see test results before
> >>>> merge. =20
> >>> Hi
> >>> I've added a PR on github, I'll review this change by the end of
> >>> the week.
> >>>
> >>> PR: https://github.com/md-raid-utilities/mdadm/pull/152 =20
> >> I see this error reported from PR test, may i know how to access
> >> these two logs?=A0 This fix is for imsm, and ->open_new for ddf not
> >> even touch "update_tail", not sure how this could cause ddf test
> >> failure.
> >>
> >>   =A0=A0=A0 /home/vagrant/host/mdadm/tests/10ddf-create-fail-rebuild...
> >> Execution time (seconds): 46 FAILED - see
> >> /var/tmp/10ddf-create-fail-rebuild.log and
> >> /var/tmp/fail10ddf-create-fail-rebuild.log for details
> >>   =A0=A0=A0 /home/vagrant/host/mdadm/tests/10ddf-fail-readd... Executi=
on
> >> time (seconds): 27 FAILED - see /var/tmp/10ddf-fail-readd.log and
> >> /var/tmp/fail10ddf-fail-readd.log for details =20
> > It is known problem, so far I know Nigel is looking at it. There is
> > no fix for now. Execution timed out and logs has not been copied
> > for user as expected.
> >
> > Here you can see the Nightly report that is executed on top
> > regularly to at least determine if fails are persistent (probably
> > not caused by your change).
> >
> > Sorry, it is not yet perfect but at least something :)
> >
> > Thanks,
> > Mariusz =20

