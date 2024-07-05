Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7007E14830E
	for <linux-raid@vger.kernel.org>; Fri,  5 Jul 2024 11:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720177357; cv=none; b=G18GC/J/wvY+rlznX759G1GhSlnCVHRLiOz6yLy4DEswXkLuBjpSPLS4hwmrYpYCltTw6SWdRbX1IbDJgLEk1TCmy3C6bQ5GWAcwQmijTOIZUjagxL8hgbyUFSolOhXFD9Hm6OuyXfxblVZ4imZHbNeUeChxS6CeHstUwlKA+z4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720177357; c=relaxed/simple;
	bh=vINt4zzrp9TIeic48pA9dcSDpVjgF9t4sq9OcNYGBh8=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IJus85swxh19ALUgI+erS15FYZj417AfEOL1kRX4sgzvQTGNXpXYgXPSTY9sXvd/aDNP0IALrzj22z/sb2igmEU1OOpS4fV2y9Ee3Iac2+6dRw9b6a0xMqxWn4xUWu3mNTnxLXcuIBllB7N4t59k9JuKc+O1gdCERK8dRX4b9Ig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Dus92lEm; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Dus92lEm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1720177355; x=1751713355;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=vINt4zzrp9TIeic48pA9dcSDpVjgF9t4sq9OcNYGBh8=;
  b=Dus92lEmOgZFdzAyRJlrEHb5KZ8kH3lrRkB34FsItCkPpd0cUzkhbr5e
   9re9WXNOWNWLqcl/nRc2ll+b2gp7126cNFHnybHBZT2ScYiBgmu+tLJRV
   s186nrUmYORvk89HEKSfATDM9TX64jqPgrEz9P1DFocjFNGXN/dVhC3Ja
   806EH1+b0li5ryk7kVag9jTsjr2QKUzawfTBZ76CZjiPVfcn+Juvbpirp
   a4MNKtB6SzuUvWH+O5+7YuWATBhybN6LdYToDCalZdr6R1aM78tERTtXP
   e8dg104OiqZZL2xVBgTIr+UOCilO1ihy/hSWhpwKofZY276a+QAbu26eF
   Q==;
X-CSE-ConnectionGUID: WNXCQuAvQhCbMTpD5irgWA==
X-CSE-MsgGUID: l7dHh56uQa+Hf850wCS9ew==
X-IronPort-AV: E=McAfee;i="6700,10204,11123"; a="17678791"
X-IronPort-AV: E=Sophos;i="6.09,184,1716274800"; 
   d="scan'208";a="17678791"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jul 2024 04:02:34 -0700
X-CSE-ConnectionGUID: QlEeNL06TGmOdS6EJTCr7g==
X-CSE-MsgGUID: vYM9pNv2ReiWd8Ggz+qSvg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,184,1716274800"; 
   d="scan'208";a="51273550"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.245.98.108])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jul 2024 04:02:34 -0700
Date: Fri, 5 Jul 2024 13:02:29 +0200
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: Adam Niescierowicz <adam.niescierowicz@justnet.pl>
Cc: linux-raid@vger.kernel.org
Subject: Re: RAID6 12 device assemble force failure
Message-ID: <20240705130229.00004a90@linux.intel.com>
In-Reply-To: <9d4c77f9-9c08-48f1-8e0b-03adc90eec89@justnet.pl>
References: <56a413f1-6c94-4daf-87bc-dc85b9b87c7a@justnet.pl>
	<20240701105153.000066f3@linux.intel.com>
	<25cb6321-9e61-405f-abd7-2187236af62a@justnet.pl>
	<20240702104715.00007a35@linux.intel.com>
	<347003bc-28f1-41e9-b5c4-a2cba5a4475c@justnet.pl>
	<20240703094253.00007a94@linux.intel.com>
	<20240703121610.00001041@linux.intel.com>
	<76d322e3-a18a-4ed7-9907-7ce77ec0842e@justnet.pl>
	<20240704130610.00007f6a@linux.intel.com>
	<9d4c77f9-9c08-48f1-8e0b-03adc90eec89@justnet.pl>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Thu, 4 Jul 2024 14:35:26 +0200
Adam Niescierowicz <adam.niescierowicz@justnet.pl> wrote:

> On 4.07.2024 o=A013:06, Mariusz Tkaczyk wrote:
> >> Data that can't be store on the foulty device should be keep in the bi=
tmap.
> >> Next when we reatach missing third drive when we write missing data fr=
om
> >> bitmap to disk everything should be good, yes?
> >>
> >> I'm thinking correctly?
> >> =20
> > Bitmap doesn't record writes. Please read:
> > https://man7.org/linux/man-pages/man4/md.4.html
> > bitmap is used to optimize resync and recovery in case of re-add (but we
> > know that it won't work in your case). =20
>=20
> Is there a way to make storage more fault tolerant?
>=20
>  From what I saw till now one array=3Done PV(LVM)=3DLV(LVM)=3Done FS.
>=20
> Mixing two array in LVM and FS isn't good practice.

I don't have expertise to advice about FS and LVM.

We (MD) can offer you RAID6 RAID1 and RAID10 so please choose wisely what f=
its
best your needs. RAID1 is the best fault tolerant but capacity is the lowes=
t.

>=20
>=20
> But what about raid configuration?
> I have 4 external backplane, 12 disk each. Each backplane is attached by=
=20
> external four SAS LUNs.
> In scenario where I attache three disk to one LUN and one LUN crash or=20
> hang and next restart or ... data on the array will be damaged, yes?

Yes, that could be. RAID6 cannot save you from that. It has up to 2 failure
tolerance, not more. That is why backups are important.

Leading array to failed state may cause data damage, any recover from somet=
hing
like that is recover from error scenario so data might be damaged. I cannot=
 say
yes or no because it varies. Generally, you should be always ready for the
worst case.

We *should* not record failed state in metadata to give user chance to reco=
ver
from such scenario so I don't get why it happened (maybe a bug?). I will tr=
y to
find time to work on it in next weeks.

>=20
> I think that I can create raid5 array for three disk in one LUN so when=20
> LUN freeze, disconect, hungs or etc one array will stop like server=20
> crash without power and this should be recovable(until now I didn't have=
=20
> problem with array rebuild in this kind of situation)

We cannot record any failure because we lost all drives at the same moment.=
 It
is kind of workaround, it will save you from going to failed or degraded
state. There could be still filesystem error but probably correctable (if a=
rray
is wasn't degraded, otherwise RWH may happen).

>=20
> Problem is with disk usage, each 12 pcs backplane will use 4 disk for=20
> parity( 12 disk=3D4 luns =3D 4 raid 5 array).
>=20
> Is there better way to do this?

It depends what do you mean by better :) This is always the compromise betw=
een
performance, capacity and redundancy. If you are satisfied with raid5
performance, and you think that the redundancy offered by this approach is
enough for your needs- this is fine. If you need more fault tolerant array =
(or
arrays)- please consider raid1 and raid10.

>=20
>=20
> > And I failed to start it, sorry. It is possible but it requires to=20
> > work with =20
> >>> sysfs and ioctls directly so much safer is to recreate an array with
> >>> --assume-clean, especially that it is fresh array. =20
> >> I recreated the array, LVM detected PV and works fine but XFS above the
> >> LVM is missing data from recreate array.
> >> =20
> > Well, it looks like you did it right because LVM is up. Please compare =
if
> > disks are ordered same way in new array (indexes of the drives in mdadm=
 -D
> > output). Just do be double sure. =20
>=20
> How can I assigne raid disk number to each disk?
>=20
>=20

Order in create command matters. You must pass devices in same order as they
were, starting from the lowest one i.e.:
mdadm -CR volume -n 12 /dev/disk1 /dev/disk2 ...

If you are using bask completion please be aware that it may order them
differently.

Mariusz
