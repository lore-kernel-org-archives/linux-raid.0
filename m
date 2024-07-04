Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D3F11A2555
	for <linux-raid@vger.kernel.org>; Thu,  4 Jul 2024 09:43:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720086190; cv=none; b=bx3it36oJCidkTQ4fVTnYprsGPFDATv8vWVJnSvjZR4mw2UMw24mz+I2/CKu71gwSR6WEctZ4Q/Oeh/mikt6Gq/wcc3qHskJ/fQGZwbJCxKILRHySlDhfmPybNfQ3Kx36WxFcn1CqPeP16z9van/Rd+z0lUm0m4vHYr4ECykFF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720086190; c=relaxed/simple;
	bh=aWxTnEHsxxK40CrmeCBXoVIuH5CcPECsRNjuuph3hZw=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HXmAfT8X33O84/0BTmYceq4FMw9QryUJDj5U6poq4k8ZSrAS+Auy/NZXXTlZieJ2uUIkGbD37Tuesuqpj+cQGRvE5HlkZGDPoHNYx3XKl9eEyyC1ztj4oTwKu+OgmpJTlSe34+KqNBo/rnEatviAeFko5WBn1/QvtmvzjGJCkOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=oIAYDoQk; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="oIAYDoQk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1720086189; x=1751622189;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=aWxTnEHsxxK40CrmeCBXoVIuH5CcPECsRNjuuph3hZw=;
  b=oIAYDoQk4NYHLtQNqpNh4/4rqCGnFGxvU76CmuEUdTbhu/UpyqSF9iqo
   Wf2ao7aWhpHo40VnnxRjQzr9+7LkT1AOXZdCd9a2Y+ae/k86otKV65Ej5
   IGa4uMbCsxu1KBX+Wzf4P8LeRcZiMltsBtQ7ueoVS709s1bGfAyYoGKN8
   JMnke37YMS+WdDi4A7ZkJyZfo8t6LpBiNpqkClTreEJN6NUDBSeSFCTZB
   T96+X3pQqE1IHtwL2gfuRyHiXqP3ZVOqDu8+Xc1acF2l5y3e1IutM9NhV
   drGhtwGjdfvfYvrPFgven+VQwpHdsNTreRahxXzc4TCKLyvL/Q95u75tB
   w==;
X-CSE-ConnectionGUID: fzZqzDPRQvmZXTlZHwp8qQ==
X-CSE-MsgGUID: 2up/5W1QSp6/nFQsiDFRdQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11122"; a="42781717"
X-IronPort-AV: E=Sophos;i="6.09,183,1716274800"; 
   d="scan'208";a="42781717"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jul 2024 02:43:08 -0700
X-CSE-ConnectionGUID: s2gHqdtzTTaTaPdsVcu7Ew==
X-CSE-MsgGUID: NHVJCLeFT3utRXsFI1P8lw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,183,1716274800"; 
   d="scan'208";a="51135110"
Received: from ktanska-mobl1.ger.corp.intel.com (HELO intel.linux.com) ([10.246.51.105])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jul 2024 02:43:07 -0700
Date: Thu, 4 Jul 2024 11:43:04 +0200
From: Kinga Stefaniuk <kinga.stefaniuk@linux.intel.com>
To: Song Liu <song@kernel.org>
Cc: Kinga Stefaniuk <kinga.stefaniuk@intel.com>, linux-raid@vger.kernel.org
Subject: Re: [PATCH v6 1/1] md: generate CHANGE uevents for md device
Message-ID: <20240704114304.00004750@intel.linux.com>
In-Reply-To: <CAPhsuW7xOdQgcWLjOVjYDLqBzMo+TgZxmEbUqCwGZFtGGA0rXQ@mail.gmail.com>
References: <20240522073310.8014-1-kinga.stefaniuk@intel.com>
	<20240522073310.8014-2-kinga.stefaniuk@intel.com>
	<CAPhsuW7xOdQgcWLjOVjYDLqBzMo+TgZxmEbUqCwGZFtGGA0rXQ@mail.gmail.com>
X-Mailer: Claws Mail 3.19.0 (GTK+ 2.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, 10 Jun 2024 11:03:25 -0700
Song Liu <song@kernel.org> wrote:

> On Wed, May 22, 2024 at 12:32=E2=80=AFAM Kinga Stefaniuk
> <kinga.stefaniuk@intel.com> wrote:
> > =20
> [...]
>=20
> > ---
> >  drivers/md/md.c     | 47
> > ++++++++++++++++++++++++++++++--------------- drivers/md/md.h     |
> >  2 +- drivers/md/raid10.c |  2 +-
> >  drivers/md/raid5.c  |  2 +-
> >  4 files changed, 35 insertions(+), 18 deletions(-)
> >
> > diff --git a/drivers/md/md.c b/drivers/md/md.c
> > index aff9118ff697..2ec696e17f3d 100644
> > --- a/drivers/md/md.c
> > +++ b/drivers/md/md.c
> > @@ -313,6 +313,16 @@ static int start_readonly;
> >   */
> >  static bool create_on_open =3D true;
> >
> > +/*
> > + * Send every new event to the userspace.
> > + */
> > +static void trigger_kobject_uevent(struct work_struct *work)
> > +{
> > +       struct mddev *mddev =3D container_of(work, struct mddev,
> > event_work); +
> > +       kobject_uevent(&disk_to_dev(mddev->gendisk)->kobj,
> > KOBJ_CHANGE); +}
> > +
> >  /*
> >   * We have a system wide 'event count' that is incremented
> >   * on any 'interesting' event, and readers of /proc/mdstat
> > @@ -325,10 +335,15 @@ static bool create_on_open =3D true;
> >   */
> >  static DECLARE_WAIT_QUEUE_HEAD(md_event_waiters);
> >  static atomic_t md_event_count;
> > -void md_new_event(void)
> > +void md_new_event(struct mddev *mddev, bool trigger_event)
> >  {
> >         atomic_inc(&md_event_count);
> >         wake_up(&md_event_waiters);
> > +
> > +       if (trigger_event)
> > +               kobject_uevent(&disk_to_dev(mddev->gendisk)->kobj,
> > KOBJ_CHANGE);
> > +       else
> > +               schedule_work(&mddev->event_work); =20
>=20
> event_work is also used by dmraid. Will this cause an issue with
> dmraid?
>=20
> Thanks,
> Song
>=20

Hi Song,

yes, you're right. It is fixed in next patchset - new work_struct
uevent_work was added.

Regards,
Kinga
