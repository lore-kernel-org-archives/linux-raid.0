Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 211BE1CEAC3
	for <linux-raid@vger.kernel.org>; Tue,  3 Sep 2024 07:22:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725348156; cv=none; b=Vkwv4uuo2XGUtydlTPJxtTsUCfil2jR+sDJI67g5DeUNHD80hCd9FiepNPZmi35ch8WnyvWsqUNwylo/lFdI7Sd5HjmyYO08H0k6AWdboUkkRtHCPxvTwopOWFjIfk/8NlCRoNTHTg33bhf9GAASOfQHeupdZ+ZWzfKnZamhL8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725348156; c=relaxed/simple;
	bh=PAKO0v7DX5ufEXL86+vR/IDeXTI/7NunZjIsLAzY+cM=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Wvk6buAQyfPHtdZlaMIS+rsYdx+3tm8enjk6cE1xuhg5nUldn56RG6CKa4NXp3CxuC6K7VQn8d1GzyAzHxyuXuRYevrq8165h81ty+DWKNEAosSPJ5dcaIi2MicagaKfS+xSEZp97LnAXxokeioIa9sohGILJzBxYtqzsMAXgUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CY02tZbk; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CY02tZbk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725348155; x=1756884155;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=PAKO0v7DX5ufEXL86+vR/IDeXTI/7NunZjIsLAzY+cM=;
  b=CY02tZbkJ5bQ3b4Sd8nbaxTsiirVGbSe9/fYNFBFReAqW0b/azNjcWZf
   vaI6C/YQt8t+VW1MWvLJ0QnKICzpbFXuUaGQRi8beyCVvLFDAD7ioYHI6
   +/8YzpVuovPszq7/FJygJVxJeew/tBEx7VbFh1j1GMEtt79txj+uBo2Ku
   9Y0epq/OyxA8Zz57qXEkP3K2WcHtQpoOaVl9ic4UY2UJLHSkT5lS4oOyB
   F44vb3oxsXiebBBp3mhBAT52u/1sWDMF7zuKA6o1b3XzCpbd2I9RY6IMb
   xX9oLpoJutZMOkY3n59DCu+OYI2XHmk9UUJ6ymeoqi5EG9zAGUKlbU8AM
   Q==;
X-CSE-ConnectionGUID: YkUW3174SUGWGtcY/nCDAg==
X-CSE-MsgGUID: KOJM63drTM+eDR4sdQnyvQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11183"; a="24110837"
X-IronPort-AV: E=Sophos;i="6.10,198,1719903600"; 
   d="scan'208";a="24110837"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2024 00:22:20 -0700
X-CSE-ConnectionGUID: qsypn0OeQvCvL9lmfXyXHg==
X-CSE-MsgGUID: 1td3KVvVSBSvZpXKW4IRVw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,198,1719903600"; 
   d="scan'208";a="64450006"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.246.1.223])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2024 00:22:19 -0700
Date: Tue, 3 Sep 2024 09:22:14 +0200
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: Xiao Ni <xni@redhat.com>
Cc: linux-raid <linux-raid@vger.kernel.org>, Nigel Croxon
 <ncroxon@redhat.com>
Subject: Re: [PATCH 04/10] mdadm/Grow: sleep a while after removing disk in
 impose_level
Message-ID: <20240903092214.00000d1d@linux.intel.com>
In-Reply-To: <CALTww29ApVRidDFfgM7N-yM0NqBa2_X5yu3uWPTAZ1aGe_QHNg@mail.gmail.com>
References: <20240828021150.63240-1-xni@redhat.com>
	<20240828021150.63240-5-xni@redhat.com>
	<20240902121359.00007a84@linux.intel.com>
	<CALTww29ApVRidDFfgM7N-yM0NqBa2_X5yu3uWPTAZ1aGe_QHNg@mail.gmail.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue, 3 Sep 2024 08:53:42 +0800
Xiao Ni <xni@redhat.com> wrote:

> On Mon, Sep 2, 2024 at 6:14=E2=80=AFPM Mariusz Tkaczyk
> <mariusz.tkaczyk@linux.intel.com> wrote:
> >
> > On Wed, 28 Aug 2024 10:11:44 +0800
> > Xiao Ni <xni@redhat.com> wrote:
> > =20
> > > It needs to remove disks when reshaping from raid456 to raid0. In
> > > kernel space it sets MD_RECOVERY_RUNNING. And it will fail to change
> > > level. So wait sometime to let md thread to clear this flag.
> > >
> > > This is found by test case 05r6tor0.
> > >
> > > Signed-off-by: Xiao Ni <xni@redhat.com>
> > > ---
> > >  Grow.c | 6 ++++++
> > >  1 file changed, 6 insertions(+)
> > >
> > > diff --git a/Grow.c b/Grow.c
> > > index 2a7587315817..aaf349e9722f 100644
> > > --- a/Grow.c
> > > +++ b/Grow.c
> > > @@ -3028,6 +3028,12 @@ static int impose_level(int fd, int level, char
> > > *devname, int verbose) makedev(disk.major, disk.minor));
> > >                       hot_remove_disk(fd, makedev(disk.major, disk.mi=
nor),
> > > 1); }
> > > +             /*
> > > +              * hot_remove_disk lets kernel set MD_RECOVERY_RUNNING
> > > +              * and it can't set level. It needs to wait sometime
> > > +              * to let md thread to clear the flag.
> > > +              */
> > > +             sleep_for(5, 0, true); =20
> > =20
>=20
> Hi Mariusz
>=20
> > Shouldn't we check sysfs is shorter intervals? I know that is the simpl=
est
> > way but big sleeps are generally not good.
> >
> > I will merge it if you don't want to rework it but you need to add log =
that
> > we are waiting 5 second for the user to not panic that it is frozen. =20
>=20
> Which sysfs do you mean? If we have a better way, I want to choose it.
>=20

If we are sending hot remove to the disk, we can check if there is path
available: /sys/block/<mddev>/md/dev-{devnm}
if not, then device has been finally removed.
Eventually, we can see same in mdstat but checking path looks simpler to me.

Thanks,
Mariusz
