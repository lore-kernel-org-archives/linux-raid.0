Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83E82205E37;
	Tue, 12 Nov 2024 07:54:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731398081; cv=none; b=upwve5aAPwj0DnZ+YrX4x4Yg0ZPQHgLEVq+O5G2CAuy+L/lMy1bo8tbxzHNXo6krEfFQprg5W55eOBdhxFDEo3hUpliFIa0bvH2UJUHVYwwWiRFk+mqfzpz+xh0pwxHtLJkVIIfL0VLQidj/8eF/VB1hvfJMXkf7ZPk3ooIc7ZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731398081; c=relaxed/simple;
	bh=B7T6rH98Pun81Q0J4vmg63UTyhk1+HV6gmwVAT5X4lA=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=u0mMh4mriddiWZOPFkqlys0sfHLAwEIH0Zcovel+eZ11ZZrjcuzoGs2/swpAJjWSzP0KSYMMyKyvCXPyZ5+EjbQr8GkptTiSSbP1pphj9nuwGq6jVQygnDYdn3DbiaUlyDFBh84iEM92DjnGgyXunws4fk5r39VfUqTi3bTx43s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EMot6XBg; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EMot6XBg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731398079; x=1762934079;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=B7T6rH98Pun81Q0J4vmg63UTyhk1+HV6gmwVAT5X4lA=;
  b=EMot6XBgDLKD9mG+HUr+tgGk3qab+2uw1K/qxqA6OMfiWl4vzUuPk4ET
   ZT7WMsutKHG3NbdHMA6JupBK9+Xj0GMWVxxvXK+s0MoN+XRx1p9NWOX3M
   kEyrjXlNYfG2Y81m/m8Yfs5egxDkas47TRWS4qHYkge3MRbQp80FPDsna
   IOzIJXPoaAJC5whca9VUPXjnxbczo/ZmZiwb+2FDf2s85ok2e0dhVupw/
   RfIA+1kyt07xTUK9wj5seyKpX61fhnW0GJnuRzfDkgIwTK3WXZYGFsYo9
   v/fm39u9ed8kqsgvXBKPO/enIjjGrukT5s87wpP0P50NYpd6kGG0lEtjw
   w==;
X-CSE-ConnectionGUID: jM7UVzOuR7mZFyRDSfmzOA==
X-CSE-MsgGUID: qx9catwkQ9CdwMvB8hRRfQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11253"; a="30623719"
X-IronPort-AV: E=Sophos;i="6.12,147,1728975600"; 
   d="scan'208";a="30623719"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2024 23:54:39 -0800
X-CSE-ConnectionGUID: tXNP3PGQS0COdAds28Ow1A==
X-CSE-MsgGUID: L1iUEA27Q9OltbTQbXvQSg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="92272960"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.246.20.233])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2024 23:54:37 -0800
Date: Tue, 12 Nov 2024 08:54:31 +0100
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: Song Liu <song@kernel.org>
Cc: Yu Kuai <yukuai1@huaweicloud.com>, linux-raid@vger.kernel.org,
 linux-kernel@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com,
 "yukuai (C)" <yukuai3@huawei.com>
Subject: Re: [PATCH md-6.13] md: remove bitmap file support
Message-ID: <20241112085327.00007de3@linux.intel.com>
In-Reply-To: <CAPhsuW4tcXqL3K3Pdgy_LDK9E6wnuzSkgWbmyXXqAa=qjAnv7A@mail.gmail.com>
References: <20241107125911.311347-1-yukuai1@huaweicloud.com>
 <CAPhsuW7Ry0iUs6X7P4jL5CX3+8EGfb5uL=g-q_8jVR-g19ummQ@mail.gmail.com>
 <ef4dcb9e-a2fa-d9dc-70c1-e58af6e71227@huaweicloud.com>
 <CAPhsuW4tcXqL3K3Pdgy_LDK9E6wnuzSkgWbmyXXqAa=qjAnv7A@mail.gmail.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu, 7 Nov 2024 17:28:43 -0800
Song Liu <song@kernel.org> wrote:

> On Thu, Nov 7, 2024 at 5:03=E2=80=AFPM Yu Kuai <yukuai1@huaweicloud.com> =
wrote:
> >
> > Hi,
> >
> > =E5=9C=A8 2024/11/08 7:41, Song Liu =E5=86=99=E9=81=93: =20
> > > On Thu, Nov 7, 2024 at 5:02=E2=80=AFAM Yu Kuai <yukuai1@huaweicloud.c=
om> wrote: =20
> > >>
> > >> From: Yu Kuai <yukuai3@huawei.com>
> > >>
> > >> The bitmap file has been marked as deprecated for more than a year n=
ow,
> > >> let's remove it, and we don't need to care about this case in the new
> > >> bitmap.
> > >>
> > >> Signed-off-by: Yu Kuai <yukuai3@huawei.com> =20
> > >
> > > What happens when an old array with bitmap file boots into a kernel
> > > without bitmap file support? =20
> >
> > If mdadm is used with bitmap file support, then kenel will just ignore
> > the bitmap, the same as none bitmap. Perhaps it's better to leave a
> > error message? =20
>=20
> Yes, we should print some error message before assembling the array.
>=20
> > And if mdadm is updated, reassemble will fail. =20

I would be great if mdadm can just ignore it too. It comes from config file=
, so
simply you can ignore bitmap entry if it is different than "internal" or
"clustered". You can print error however you must do it somewhere else (out=
side
config.c), otherwise user would be always prompted about that on every conf=
ig
read - probably we don't need to make it such noise but maybe we should (us=
er
may not notice change if we are not screaming it loud). I have no opinion h=
ere.

The first rule is always data access- we should not break that if possible.=
 I
think case I think it is possible to keep them assembled.

>=20
> I think we should ship this with 6.14 (not 6.13), so that we have
> more time testing different combinations of old/new mdadm
> and kernel. WDYT?

Later is better because it decreases possibility that someone would met the
case with new kernel and old mdadm, where probably some ioctl/sysfs writes
fails will be observed.

I would say that we should wait around one year after removing it from mdad=
m.
That is preferred by me.

I will merge Kuai changes soon, before the release. I think it is valuable =
to
have it blocked in new mdadm release.

Mariusz
