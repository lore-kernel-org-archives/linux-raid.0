Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C0777E8
	for <linux-raid@vger.kernel.org>; Wed, 12 Jun 2024 14:37:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718203045; cv=none; b=XeQwSXb42Ww+ob9wT1yrWM1qQ1zm2FJeEi+Nvqf1YMm/A11lDC2afhJuJXNpLLV5TFqXCkfPd5o06vLTJbsOxNYDGV6RMrAkYZPxghLlGN9e4e9TLYImRcH+cY2RCSzE9F2ECuxAvtbAsfVfXTcDpReEOFohqk/UCP2Gx5tLfyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718203045; c=relaxed/simple;
	bh=JX3mn5M5KeSWzhdpGqB0ck+FWQrMO5HV/sccTCSytAs=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VbPmLsJXu/vg+I3X3qj/HWwmre2UDKRm6i7eQxn7sDWK3p8U4bq0pTjI2VEeH2y+CJGgqKUIYTYFo+xicNzGR56wOHM5aiA0HLLAKjDmIydWONB+NTbhRoUw/B8Srybo+6/F454/auZkHvhw0c2JzpvEZU/0Km9Xf3Tk5pIgFI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PtMmjoqu; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PtMmjoqu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718203043; x=1749739043;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JX3mn5M5KeSWzhdpGqB0ck+FWQrMO5HV/sccTCSytAs=;
  b=PtMmjoqu1of7zb+tskOQpkj0ax31SK/q+H3c50SrbjYK4FkIhFY0Muy/
   CT2ea+MJR56v1RDDZKyECfCeBbU3B87IrgVPs8y5YIrtow+ZDQX0cegYd
   FbAbXqoQqGa2wjQevW9vlZrj+qPN1eUsHTS+zFZ873t9WzOW2fYcvynTM
   Vt+eSohlAZiS57kaAE1TsVtKkTBk8jRBSdnaXPEHIygpfHrpVRZeV/ayn
   y6/bHMJbcrkPxswB25ilp8yIV2CfjjDqK56SZSInIqO8m04MmILC+s2Iw
   CsX+rFQ3TQ1hYnScEDoH32ncgR6WWU7pOKR/TAGGUc/unrQMcOjvXRCaC
   g==;
X-CSE-ConnectionGUID: jdH7rxDgSbO9rjNMB3+yhQ==
X-CSE-MsgGUID: nY7eAJODTamaXOoUfWi2Rw==
X-IronPort-AV: E=McAfee;i="6700,10204,11101"; a="14933094"
X-IronPort-AV: E=Sophos;i="6.08,233,1712646000"; 
   d="scan'208";a="14933094"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2024 07:36:22 -0700
X-CSE-ConnectionGUID: cVVGf4OuRaKOYhR7UU2hKw==
X-CSE-MsgGUID: 0/K2IBllS926PHjYBykSbg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,233,1712646000"; 
   d="scan'208";a="39742006"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.245.112.252])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2024 07:36:21 -0700
Date: Wed, 12 Jun 2024 16:36:16 +0200
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: Sven =?ISO-8859-1?Q?K=F6hler?= <sven.koehler@gmail.com>
Cc: linux-raid@vger.kernel.org
Subject: Re: regression: drive was detected as raid member due to metadata
 on partition
Message-ID: <20240612163616.0000717a@linux.intel.com>
In-Reply-To: <dcc76f1d-0828-4be8-bb87-394c20ce3c10@gmail.com>
References: <93d95bbe-f804-4d12-bd0d-7d3cc82650b3@gmail.com>
	<20240507093252.000032c2@linux.intel.com>
	<dcc76f1d-0828-4be8-bb87-394c20ce3c10@gmail.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Wed, 29 May 2024 00:57:17 +0200
Sven K=F6hler <sven.koehler@gmail.com> wrote:

> Hi Mariusz,
>=20
> Am 07.05.24 um 09:32 schrieb Mariusz Tkaczyk:
> > On Tue, 9 Apr 2024 01:31:35 +0200
> > Sven K=F6hler <sven.koehler@gmail.com> wrote:
> >  =20
> >> I strongly believe that mdadm should ignore any metadata - regardless =
of
> >> the version - that is at a location owned by any of the partitions. =20
> >=20
> > That would require mdadm to understand gpt parttable, not only clone it.
> > We have gpt support to clone the gpt metadata( see super-gpt.c).
> > It should save us from such issues so you have my ack if you want to do
> > this. =20
>=20
> I get your point. That seems wrong to me. I wonder whether the kernel=20
> has some interface to gather information on partitions on a device.=20
> After all, the kernel knows lots of partition table types (mbr, gpt, ...)

Hi Sven,
It might be to early to rely on kernel. Kernel initialized partitions on op=
en
(generally caused by udev) and at the same call mdadm is called by udev, so=
 the
partition may or may not be there (in sysfs). I think, there could be race
possibility.

That is what I remember but I was there few years ago. I hope it is helpful.

>=20
> > But... GPT should have secondary header located at the end of the devic=
e, so
> > your metadata should be not at the end. Are you using gpt or mbr partta=
ble?
> > Maybe missing secondary gpt header is the reason? =20
>=20
> I just checked. My disks don't have a GPT backup at the end. I might=20
> have converted an MBR partition table to a GPT. That would not create a=20
> backup GPT if the space is already occupied by a partition.
>=20
> That said, for the sake of argument, I might just as well be using an=20
> MBR partition table.

Yeah, make sense.

>=20
> >> While I'm not 100% sure how to implement that, the following might also
> >> work: first scan the partitions for metadata, then ignore if the parent
> >> device has metadata with a UUID previously found. =20
> >=20
> > No, it is not an option. In udev world, you should only operate on devi=
ce
> > you are processing so we should avoid referencing the system. =20
>=20
> Hmm, I think I know what you mean.
>=20
> > BTW. To avoid this issue you can left few bytes empty at the end of dis=
k,
> > simply make your last partition ended few bytes before end of the drive.
> > With that metadata will not be recognized directly on the drive. That i=
s at
> > least what I expected but I'm not native experienced so please be aware=
 of
> > that. =20
>=20
> I verified that my last partition ends at the last sector of the disc.=20
> Pretty sure that means it must have been an MBR PT once upon a time.
>=20
> This is not about me. I'm not asking to support my case for the sake of=20
> having my system work. I already converted to metadata 1.2 and that=20
> fixed the issue regardless where the last partition ends.
>=20
> It's a regression, in the sense that my system has worked for years and=20
> after an upgrade suddenly didn't. I'd like to prevent that the same=20
> happens to others. It was pretty scary, even though no data seems to=20
> have been lost.

Great open source attitude!

>=20
> >> I did the right thing and converted my RAID arrays to metadata 1.2, but
> >> I'd like to save other from the adrenaline shock. =20
> >=20
> > There are reasons why we introduced v1.2 located at the begging of devi=
ce.
> > You can try to fix it but I think that you should just follow upstream =
and
> > choose 1.2 if you can. =20
>=20
> Yes, I agree with you. That's why I migrated to 1.2 already.
>=20
> > As we are more and more with 1.2 that naturally we care less about 0.9,
> > especially of workarounds in other utilities. We cannot control
> > if legacy workarounds are still there (the root cause of this change ma=
y be
> > outside md/mdadm, you never know :)). =20
>=20
> Likely, the reason is outside of the mdadm binary but inside the mdadm=20
> repo. Arch Linux uses the udev rules provided by the mdadm package=20
> without modification. The diff on the udev rules between mdadm 4.2 and=20
> 4.3 release is significant. Both invoke mdadm -If $name but likely the=20
> order has changed.
>=20
> An investigation of that is still pending. I'm not an expert in udev=20
> debugging, and the logs don't show.

Slowly you will figure it out. I debugged udev few times but every time I
make something wrong and it is not working :)

>=20
> > So the cases like that will always come. It is right to use 1.2 now to =
be
> > better supported if you don't have strong need to stay with 0.9. =20
>=20
> Would it be possible to have automated tests for incremental raid=20
> assembly via udev rules? I'm not an expert in udev though.

yes, it is possible. The simplest way it to synthesize "add" event, for exa=
mple:
echo add > /sys/block/nvme1n1/uevent

I don't know if it is reliable way, but I'm using it time to time.
mdadm does it this way too.

Mariusz

>=20
>=20
> > Anyway, patches are always welcomed! =20
>=20
> Still working on my udev debugging skills. But afterwards, I may very=20
> well prepare a patch.
>=20
>=20
>=20
> Best,
>    Sven

