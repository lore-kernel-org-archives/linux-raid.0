Received: from mout.web.de (mout.web.de [212.227.15.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB6ED2FFDFB
	for <linux-raid@vger.kernel.org>; Tue, 14 Oct 2025 20:14:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760472893; cv=none; b=ubGft4KhBtS4RtCKTGAAL6RwO2Sg4o9HRK/M2R+WO8BGwMkPA0ZaaThrTHMLDCX6xQFfHgLeiVHqFebd9UHIb6wCA/hUorVYP74RjuGZnDbKtKmlTD5/nYAhZi5eUrwkTi5YEU5JCsc3oPzMOURuzzsp/M+CSHXf3i3Sh5uY5NY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760472893; c=relaxed/simple;
	bh=slcGqALAtkVZ60Vmx86mEKUWGZFwOgIr4ax7SpC8vVs=;
	h=Message-ID:Date:MIME-Version:From:Subject:References:To:
	 In-Reply-To:Content-Type; b=P/edlG4FJ8VJ+J4OqbKDnbjXtdRlYbV7ylnDTjSKBAI8NQDzAu7ZDtQZ/IM8/ORhVDWvkIlFAxO6iekrU/nvxxGIyEw1aAz9Zm0ktwxmJRL1ocylBv2LtvJvR3lUWpUjvUYdsB9YZs/MQ7uVY9JO6qjKWLBWhugULXa1Pih+xFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=devzero@web.de header.b=ufaisH82; arc=none smtp.client-ip=212.227.15.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=devzero@web.de header.b="ufaisH82"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1760472880; x=1761077680; i=devzero@web.de;
	bh=slcGqALAtkVZ60Vmx86mEKUWGZFwOgIr4ax7SpC8vVs=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:From:Subject:
	 References:To:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=ufaisH827sh/8YyLz3pRuSF2gmqUgqZD6qln/k7HCCPPefPxlwL2AGKYJFGfWsNw
	 PCQIAgExIddjPoIm6sy3g9jfQSQfIuA1BiviNJI65XOFoLXYLD5aoUBpzAbUo47LL
	 SIHOvYyYnVFznvb6zZREmM4R4QvFbPzOhCDB5s2NS8TUu3uHX/jU904APOuzqud1d
	 MCM5UaCdJHeyKmGsOX1aEvL53rFbCLkHJ11hvX+y+ay8Q/YR+BVAX4CyaOUeoBa25
	 laWGV6rayj5tpKR98EXorED0IOSsX7EmqdBp90LiSGG0VtTOMReX1oLFcRjpiFBNV
	 IBX0cgSsR1p2M7TAjw==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.190.43] ([77.176.133.236]) by smtp.web.de (mrweb005
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1MuVGA-1uHLa93zG6-00rmd8; Tue, 14
 Oct 2025 22:14:40 +0200
Message-ID: <e686d669-c41f-42a7-be53-9538feb4721f@web.de>
Date: Tue, 14 Oct 2025 22:14:39 +0200
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Roland <devzero@web.de>
Subject: status of bugzilla #99171 - mdraid broken for O_DIRECT
References: <A4168F21-4CDF-4BAD-8754-30BAA1315C6F@web.de>
To: Hannes Reinecke <hare@suse.de>, Reindl Harald <h.reindl@thelounge.net>,
 linux-raid@vger.kernel.org
In-Reply-To: <A4168F21-4CDF-4BAD-8754-30BAA1315C6F@web.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:+ZJscr1pFtgkr3EIAXUIId++fIAax/CDAraprOO4Rl2yLys67da
 O8/qh3EOzrcj3S/XmIRhCzBp0F3mo/lJuRteCOlEn/TmFK0x058j9gY1T2w1GZAJ+ub45eN
 Ei9NQwXZeU6w5k8faLKjZJOK2wdutAk9JRmEbHZFNXt1bFVXXSsaeJEUDftpGm6tLcJ3CgC
 A8DQtBhU8lgn1Il468HsQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:qqQlc4DeDmc=;K2SQ97zFXOOcCrM4XkGzfRFy9z7
 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
 tyG/cwfqF3t3bA==

sorry, resend in text format as mail contained html and bounced from ML.

=EF=BB=BF
Am 14.10.25 um 08:31 schrieb Hannes Reinecke:
> Hmm. I still would argue that the testcase quoted is invalid.
>
> What you do is to issue writes of a given buffer, while at the
> same time modifying the contents of that buffer.
>
> As we're doing zerocopy with O_DIRECT the buffer passed to pwrite
> is _the same_ buffer used when issuing the write to disk. The
> block layer now assumes that the buffer will _not_ be modified
> when writing to disk (ie between issuing 'pwrite' and the resulting
> request being send to disk).
> But that's not the case here; it will be modified, and consequently
> all sorts of issues will pop up.
> We have had all sorts of fun some years back with this issue until
> we fixed up all filesystems to do this correctly; if interested
> dig up the threads regarding 'stable pages' on linux-fsdevel.
>
> I would think you will end up with a corrupted filesystem if you
> run this without mdraid by just using btrfs with data checksumming.
>
yes, it's correct. you also end up with corrupted btrfs with this tool,=20
see https://bugzilla.kernel.org/show_bug.cgi?id=3D99171#c16

> So really I'm not sure how to go from here; I would declare this
> as invalid, but what do I know ...
>
> Cheers,
>
> Hannes=20

anyhow, i don't see why this testcase is invalid, especially when zfs=20
seems not to be affected.

please look at this issue from a security perspective.

if you can break or corrupt your raid mirror from userspace even from an=
=20
insulated layer/environment, i would better consider this "testcase" to=20
be "malicious code" , which is able to subvert the=20
virtualization/block/fs layer stack.

how could we prevent, that non-trused users in a vm or container=20
environment can execute this "invalid" code ?


how can we prevent, that they do harm on the underlying mirror in a=20
hosting environment for example ?

not using it in a hosting environment is a little bit weird strategy for=
=20
a linux basic technoligy which exists for years.

and let it up to the hoster to remember he needs to disable direct-io=20
for the hypervisor - is dissatisfying and error-prone, too.

roland



