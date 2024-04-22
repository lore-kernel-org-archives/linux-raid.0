Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A678A131191
	for <linux-raid@vger.kernel.org>; Mon, 22 Apr 2024 10:15:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713780927; cv=none; b=g7sxKP1D0Iwxg4SJ2HeZMhyaKTsVh6CcjccwomURaTS+zArze/gyqgzgrjHEoxl+tzKbn1OjDlozpnSJbSDiTXTtzKUi3/yjZS54dbX0u+pLcmZjeGCJp9e6UqQ6FBuszTmasEwFTPsx8aA58OZJRw3z3q1wSgRwGc16886yOtc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713780927; c=relaxed/simple;
	bh=RgMdNM1FBfmd3GB8k1LuuRyJ7g2MX/E/4RL3vGKWau8=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=k6G0/KeRqUgHvg1nNViFxOaT/OmDkMVU3baha1fkBJ4gqO0O9PeLfShgeWHPtW7DUn/n9yiaddO7DFIHsNRja+STJfwz2tN/vikNvWq9m5SS9m3aKYYsxmaz2K/OBnB1W/RjpsxmZHoTU/LTaA/Xvkte93a9gsWpS6fgMs7eoF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EIRTUV0W; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EIRTUV0W"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713780926; x=1745316926;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=RgMdNM1FBfmd3GB8k1LuuRyJ7g2MX/E/4RL3vGKWau8=;
  b=EIRTUV0WNntENjeoLpBQM6OIiwPULbz+ZJcrmpOk1rvpr9Cc67Zj6U/F
   LRapYcGjH9OkCeRAcgnjrBmAsjLv92mp+FB80yrTYHgooo9Og5mGBXpYr
   VbU346ZtCfmYY4UaIbFhVjZ+dkAhrU48I61OH4aHChPSt4ZKIFOKTlK2Z
   yF2O5c/Tpz3EjElSucKE8hTJB4I6btOhyTOvAQtKfcUSSJ7ty+mzP9rYj
   lF25en7NMjV+krwtXePxg/dCwaLhCDMZKwJ5mhDJHlAQHScg1/p0xOXy7
   T9SW7UxFWvgAQb1pS/eOe5jI6W6+fJ6nqNQcm6pKBbEKmrFkMBe8wzS/P
   Q==;
X-CSE-ConnectionGUID: caikdfsbQSO256zCDq+jpg==
X-CSE-MsgGUID: 1cALIVgKQ8SzpLVPwAvdJQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11051"; a="31801782"
X-IronPort-AV: E=Sophos;i="6.07,220,1708416000"; 
   d="scan'208";a="31801782"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2024 03:15:25 -0700
X-CSE-ConnectionGUID: gdovOLdjT3uy9+pzh7XaEg==
X-CSE-MsgGUID: TTwiq7tST4SJjwaywm6rfA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,220,1708416000"; 
   d="scan'208";a="28642808"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.237.142.95])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2024 03:15:23 -0700
Date: Mon, 22 Apr 2024 12:15:18 +0200
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: Xiao Ni <xni@redhat.com>
Cc: linux-raid@vger.kernel.org, jes@trained-monkey.org, song@kernel.org,
 yukuai1@huaweicloud.com, ncroxon@redhat.com, colyli@suse.de
Subject: Re: [PATCH 2/5] tests/00createnames enhance
Message-ID: <20240422121518.00003ecb@linux.intel.com>
In-Reply-To: <CALTww28CNBYHrfScPgh9XCr932VeNw=WJFeXiqQM26XwE=DaKQ@mail.gmail.com>
References: <20240418102321.95384-1-xni@redhat.com>
	<20240418102321.95384-3-xni@redhat.com>
	<20240419114702.0000694c@linux.intel.com>
	<CALTww28CNBYHrfScPgh9XCr932VeNw=WJFeXiqQM26XwE=DaKQ@mail.gmail.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, 22 Apr 2024 14:57:16 +0800
Xiao Ni <xni@redhat.com> wrote:

> On Fri, Apr 19, 2024 at 5:47=E2=80=AFPM Mariusz Tkaczyk
> <mariusz.tkaczyk@linux.intel.com> wrote:
> >
> > On Thu, 18 Apr 2024 18:23:18 +0800
> > Xiao Ni <xni@redhat.com> wrote:
> > =20
> > > +     local is_super1=3D"$(mdadm -D --export $DEVNODE_NAME | grep
> > > MD_METADATA=3D1.2)" =20
> >
> > You can also limit this test to super-1.2 it may depend on config, so w=
e can
> > specify metadata directly in create command (if it is not specified). =
=20
>=20
> Could you explain more? I don't catch you here.

Default metadata could be customized. At first glance, I thought
that you added this because we metadata is not specified so I checked:
	if [[ -z "$NAME" ]]; then
		mdadm -CR "$DEVNAME" -l0 -n 1 $dev0 --force
	else
		mdadm -CR "$DEVNAME" --name=3D"$NAME" --metadata=3D1.2 -l0 -n 1
	$dev0 --force
        fi


It seems that I forgot to add metadata specifier in first create command. If
you have different metadata than 1.2 you can add --metadata=3D1.2 and then:

> > > +     local is_super1=3D"$(mdadm -D --export $DEVNODE_NAME | grep
> > > MD_METADATA=3D1.2)"=20

won't be needed. Do I miss something?

Thanks,
Mariusz
