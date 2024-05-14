Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF732D531
	for <linux-raid@vger.kernel.org>; Tue, 14 May 2024 10:56:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715684205; cv=none; b=ex05QPdbU56kV4yeI+bgmtEETPxnmrgKmlY997BjeoTcgdJFzyzW/DVsVR7xO263o64aMP496QtevsCjQItPGVIBBR+9SPnZ6FPAIHgmnvtsnn0CdeLgEd1e3nH9S3Uo4DntfokCNl8QP1kHpfwp1KAVSArJAVA2W2EiSivCZMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715684205; c=relaxed/simple;
	bh=12ZlwEsApU8ZocKKPOckGuzx4SzHSdUi5Ut1d2iPS9c=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=K9mGtv4Maghh5ytBunaxxDSrLbIcvIVxPqALb8Qaj7LtDJnPm10d9yxccLf4l2T6MSjKUEPG1nDFuqDB0ut8CIqxLKGjsIglZURyRbgAxb0LGRoUGc2B+TpFDUvhVs+Ht0kaHrOEJWgRqFkS14Ppdx+cucTr7iSowarRKVnVT74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XBAqa7OJ; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XBAqa7OJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715684204; x=1747220204;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=12ZlwEsApU8ZocKKPOckGuzx4SzHSdUi5Ut1d2iPS9c=;
  b=XBAqa7OJlvng3ZL/jAkTsCvt52JMLCbcs5QTA8BZYudNvXsNI+3VLgUT
   w/kloXBDqMOKdF1PcYJXLK1q9VMm1hlFfRWiI5KrtWZ3u4FHYlZewLV0a
   AREmphN8l6HSLJhGGNTQNd9UsRnyKDbQrJ2zii2eRtKYQpOb1vkQBjVrC
   RG3NEKhkT/I0DYTt+QF7Y+wmz+fLfb7Nvxwj+rahLuStCRRASPmqsOWjQ
   hcPjgibkzBfXgZhWa2+YzyorM3+Zhx2Mp7y6GX+Xjp0KJjW1x2b2kDJ9B
   ffAAgxt+K3Zuzw0szr81qQQgApYgXWPu59MjvDzQuSK4PNTpNcnj+cAAV
   Q==;
X-CSE-ConnectionGUID: W2wH32JAQ2abbVyj/TmywQ==
X-CSE-MsgGUID: 3ZwNJdxhTlGZLlAopIAhqQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11072"; a="11480994"
X-IronPort-AV: E=Sophos;i="6.08,159,1712646000"; 
   d="scan'208";a="11480994"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2024 03:56:42 -0700
X-CSE-ConnectionGUID: FOQMjLtATdeOvG6TMZBOSA==
X-CSE-MsgGUID: HKbdmwEwQEeJkk1h2OBM8g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,159,1712646000"; 
   d="scan'208";a="30656675"
Received: from ktanska-mobl1.ger.corp.intel.com (HELO intel.linux.com) ([10.246.36.71])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2024 03:56:40 -0700
Date: Tue, 14 May 2024 12:56:38 +0200
From: Kinga Stefaniuk <kinga.tanska@linux.intel.com>
To: Paul Menzel <pmenzel@molgen.mpg.de>
Cc: Kinga Stefaniuk <kinga.stefaniuk@intel.com>, linux-raid@vger.kernel.org,
 jes@trained-monkey.org, mariusz.tkaczyk@linux.intel.com
Subject: Re: [PATCH 2/2] Wait for mdmon when it is stared via systemd
Message-ID: <20240514125638.00000a9c@intel.linux.com>
In-Reply-To: <fcae76b9-32e5-40f4-b3d4-f927ef28aea3@molgen.mpg.de>
References: <20240507033856.2195-1-kinga.stefaniuk@intel.com>
	<20240507033856.2195-3-kinga.stefaniuk@intel.com>
	<fcae76b9-32e5-40f4-b3d4-f927ef28aea3@molgen.mpg.de>
X-Mailer: Claws Mail 3.19.0 (GTK+ 2.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue, 14 May 2024 11:17:16 +0200
Paul Menzel <pmenzel@molgen.mpg.de> wrote:

> Dear Kinga,
>=20
>=20
> Thank you for the patch. There is a small typo in the summary:
> star*t*ed.
>=20
> Am 07.05.24 um 05:38 schrieb Kinga Stefaniuk:
> > When mdmon is being started it may need few seconds to start.
> > For now, we didn't wait for it. Introduce wait_for_mdmon()
> > function, which waits up to 5 seconds for mdmon to start completely.
> >=20
> > Signed-off-by: Kinga Stefaniuk <kinga.stefaniuk@intel.com>
> > ---
> >   Assemble.c |  4 ++--
> >   Grow.c     |  7 ++++---
> >   mdadm.h    |  2 ++
> >   util.c     | 29 +++++++++++++++++++++++++++++
> >   4 files changed, 37 insertions(+), 5 deletions(-)
> >=20
> > diff --git a/Assemble.c b/Assemble.c
> > index f6c5b99e25e2..9cb1747df0a3 100644
> > --- a/Assemble.c
> > +++ b/Assemble.c
> > @@ -2175,8 +2175,8 @@ int assemble_container_content(struct
> > supertype *st, int mdfd, if (!mdmon_running(st->container_devnm))
> >   				start_mdmon(st->container_devnm);
> >   			ping_monitor(st->container_devnm);
> > -			if (mdmon_running(st->container_devnm) &&
> > -			    st->update_tail =3D=3D NULL)
> > +			if (wait_for_mdmon(st->container_devnm) =3D=3D
> > MDADM_STATUS_SUCCESS &&
> > +			    !st->update_tail)
> >   				st->update_tail =3D &st->updates;
> >   		}
> >  =20
> > diff --git a/Grow.c b/Grow.c
> > index 074f19956e17..0e44fae4891e 100644
> > --- a/Grow.c
> > +++ b/Grow.c
> > @@ -2085,7 +2085,7 @@ int Grow_reshape(char *devname, int fd,
> >   			if (!mdmon_running(st->container_devnm))
> >   				start_mdmon(st->container_devnm);
> >   			ping_monitor(container);
> > -			if (mdmon_running(st->container_devnm) =3D=3D
> > false) {
> > +			if (wait_for_mdmon(st->container_devnm) !=3D
> > MDADM_STATUS_SUCCESS) { pr_err("No mdmon found. Grow cannot
> > continue.\n"); goto release;
> >   			}
> > @@ -3176,7 +3176,8 @@ static int reshape_array(char *container, int
> > fd, char *devname, if (!mdmon_running(container))
> >   				start_mdmon(container);
> >   			ping_monitor(container);
> > -			if (mdmon_running(container) &&
> > st->update_tail =3D=3D NULL)
> > +			if (wait_for_mdmon(container) =3D=3D
> > MDADM_STATUS_SUCCESS &&
> > +			    !st->update_tail)
> >   				st->update_tail =3D &st->updates;
> >   		}
> >   	}
> > @@ -5140,7 +5141,7 @@ int Grow_continue_command(char *devname, int
> > fd, start_mdmon(container);
> >   		ping_monitor(container);
> >  =20
> > -		if (mdmon_running(container) =3D=3D false) {
> > +		if (wait_for_mdmon(container) !=3D
> > MDADM_STATUS_SUCCESS) { pr_err("No mdmon found. Grow cannot
> > continue.\n"); ret_val =3D 1;
> >   			goto Grow_continue_command_exit;
> > diff --git a/mdadm.h b/mdadm.h
> > index af4c484afdf7..9b8fb3f6f8d8 100644
> > --- a/mdadm.h
> > +++ b/mdadm.h
> > @@ -1769,6 +1769,8 @@ extern struct superswitch
> > *version_to_superswitch(char *vers);=20
> >   extern int mdmon_running(const char *devnm);
> >   extern int mdmon_pid(const char *devnm);
> > +extern mdadm_status_t wait_for_mdmon(const char *devnm);
> > +
> >   extern int check_env(char *name);
> >   extern __u32 random32(void);
> >   extern void random_uuid(__u8 *buf);
> > diff --git a/util.c b/util.c
> > index 65056a19e2cd..df12cf2bb2b1 100644
> > --- a/util.c
> > +++ b/util.c
> > @@ -1921,6 +1921,35 @@ int mdmon_running(const char *devnm)
> >   	return 0;
> >   }
> >  =20
> > +/*
> > + * wait_for_mdmon() - Waits for mdmon within specified time.
> > + * @devnm: Device for which mdmon should start.
> > + *
> > + * Function waits for mdmon to start. It may need few seconds
> > + * to start, we set timeout to 5, it should be sufficient.
> > + * Do not wait if mdmon has been started.
> > + *
> > + * Return: MDADM_STATUS_SUCCESS if mdmon is running, error code
> > otherwise.
> > + */
> > +mdadm_status_t wait_for_mdmon(const char *devnm)
> > +{
> > +	const time_t mdmon_timeout =3D 5;
> > +	time_t start_time =3D time(0);
> > +
> > +	if (mdmon_running(devnm))
> > +		return MDADM_STATUS_SUCCESS;
> > +
> > +	pr_info("Waiting for mdmon to start\n");
> > +	while (time(0) - start_time < mdmon_timeout) {
> > +		sleep_for(0, MSEC_TO_NSEC(200), true);
> > +		if (mdmon_running(devnm))
> > +			return MDADM_STATUS_SUCCESS;
> > +	};
> > +
> > +	pr_err("Timeout waiting for mdmon\n"); =20
>=20
> Please print the timeout limit.
>=20
> > +	return MDADM_STATUS_ERROR;
> > +}
> > +
> >   int start_mdmon(char *devnm)
> >   {
> >   	int i; =20
>=20
> Doesn=E2=80=99t systemd have some interface sd_ on how to notify about a=
=20
> successful start?
>=20
>=20
> Kind nregards,
>=20
> Paul
>=20

Hi Paul,

mdadm has its own mechanism to verify if mdmon is running and using it
we are not limited only to systemd, so it's better to use this way.

Thanks,
Kinga
