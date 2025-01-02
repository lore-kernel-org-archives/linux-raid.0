Received: from nt.romanrm.net (nt.romanrm.net [185.213.174.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66BEF3FE4
	for <linux-raid@vger.kernel.org>; Thu,  2 Jan 2025 12:22:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.213.174.59
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735820546; cv=none; b=fwkyKR1kG3nM3wGBR/cJrCggAjExSIZWLmkFREIjN/5ic7IxXZrW/cWJeGoG0ARxZwNbvgpV4PFSDH9WjpaIox/xtbfWLnbAJrPH2G292hwuam56+wU/O6vAgEFA4Mp5CFP71SEDvCly5yKmUsrKTCmSbjLEtr2741EWAh78ieY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735820546; c=relaxed/simple;
	bh=w8MyGj+8r2ejsbJNDPzbpPJtq7rVbkzkaaz0gK5ZuHo=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qEU6jF53axiRySBqbxi2PIeEBNwPHtwCqxfgXyvu0Hv5rUGOPmAgZvMFMJT/0VjUmKN1slXULldlArf7l+loQ1AIC7mxmjuFoXFACTixwtgUqCamXEPUDzt7FFDCNaC+DtiL8Klk1oZqjng3JyKmJzpFtCWHatvTgNFB6aw7b7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=romanrm.net; spf=pass smtp.mailfrom=romanrm.net; arc=none smtp.client-ip=185.213.174.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=romanrm.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=romanrm.net
Received: from nvm (umi.2.romanrm.net [IPv6:fd39:a37d:999f:7e35:7900:fcd:12a3:6181])
	by nt.romanrm.net (Postfix) with SMTP id 443BC40446;
	Thu,  2 Jan 2025 12:16:38 +0000 (UTC)
Date: Thu, 2 Jan 2025 17:16:37 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Allen Toureg <thetanix@gmail.com>
Cc: Song Liu <song@kernel.org>, Yu Kuai <yukuai3@huawei.com>,
 linux-raid@vger.kernel.org, regressions@vger.kernel.org
Subject: Re: md-linear accidental(?) removal, removed significant(?) use
 case?
Message-ID: <20250102171637.15bdb26f@nvm>
In-Reply-To: <CABrqrA6b2y29tC2Z-9H2vYsuP_t5c6uCw9DZrjY7DmeNcczf0w@mail.gmail.com>
References: <CABrqrA6b2y29tC2Z-9H2vYsuP_t5c6uCw9DZrjY7DmeNcczf0w@mail.gmail.com>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed, 1 Jan 2025 20:14:12 -0800
Allen Toureg <thetanix@gmail.com> wrote:

> Preamble: I have extensive arrays of drives and due to their irregular
> sizes, I was using md-linear as a convenient way to manually
> concatenate arrays of underlying MD (raid5/etc) to manually deal with
> redundancy.
>=20
> I have probably a few thousand TB in total raw space, and hundreds of
> TB of actual data and files attached to singular systems.
>=20
> In a recent OS update, I discovered my larger volumes no longer mount
> because md-linear has been removed entirely from the kernel as of 6.8.
>=20
> I am trying to do rationale archaeology. I sent a note to Mr. Neil
> Brown who was responsible for the earliest change I found related to
> this and he suggested I email regressions and linux-raid along with
> the current maintainers about it.
>=20
> What I've been able to find:
>=20
> In 2604b703b6b3db80e3c75ce472a54dfd0b7bf9f4 (2006) Neil Brown marked a
> MODULE_ALIAS entry for md-personality-1 as deprecated but it appears
> the reason was because the form of the personality was changed (not
> that the underlying md-linear itself was deprecated.)
>=20
> d9d166c2a9d5d01af34396793950aa695883eed4 (2006) reinforced this change
> via a diff algorithm that overzealously included that line in a diff
> chunk but which makes annotating prior to it a more manual process.
>=20
> 608f52e30aae7dc8da836e5b7b112d50a2d00e43 (2021) marked md-linear as
> deprecated in Kconfig, using the rationale that md-linear was
> deprecated in MODULE_ALIAS=E2=80=94but again which doesn't explain why the
> *module* was deprecated and appears to me at least to accidentally
> misconstrue the original reason for the deprecation comment.
>=20
> 849d18e27be9a1253f2318cb4549cc857219d991 (2023) eliminated md-linear
> entirely, again mostly self-referencing a deprecation notice which was
> there in actuality for basically multiple decades and seems to have
> referenced something else entirely.
>=20
> I was hoping you could help me understand why this module was removed?
> I have found others who also are running into this. Functionality they
> relied on has disappeared, as per the existence of the following:
>=20
> https://github.com/dougvj/md-linear
>=20
> https://gitlab.archlinux.org/archlinux/packaging/packages/linux/-/issues/=
34
> https://bbs.archlinux.org/viewtopic.php?id=3D294005
> (etc)
>=20
> So, it looks like there are many of us who were still using mdadm to
> manage sub-device concatenation, again in my case for 100s of TB of
> admittedly casual data storage, and I can't currently find what the
> actual actual rationale was for removing it. :(
>=20
> For utility's sake, I would like to suggest that linear volumes lessen
> problems like substriping. I do not think for many of us that
> shuffling around a few hundred TB is easy to do at any rate. Currently
> I'm manually re-compiling a fairly heavily-modified md-linear as a
> user-built module and it seems to work okay. I am definitely not the
> only one doing this.
>=20
> Please consider resurrecting md-linear. :-)

I fully support keeping md-linear for users with existing deployments.

Wanted to only ask out of curiosity, did you try using md-raid0 for the same
scenario?

It can use different sized devices in RAID0. In case of two disks it will
stripe between them over the matching portion of the sizes, and then the ta=
il
of the larger device will be accessed in a linear fashion. Not sure it can
handle 3 or more in this manner, will there be multiple steps of the stripi=
ng,
each time with a smaller number of the remaining larger devices (but would =
not
be surprised if yes).

Given that a loss of one device in md-linear likely means complete data loss
anyway (relying on picking up pieces with data recovery tools is not a good
plan), seems like using md-raid0 here instead would have no downsides but
likely improve performance by a lot.

Aside from all that, the "industry" way to do the task of md-linear current=
ly
would be a large LVM LV over a set of multiple PVs in a volume group.

--=20
With respect,
Roman
