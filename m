Received: from mout.web.de (mout.web.de [212.227.15.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 930EA2D542A
	for <linux-raid@vger.kernel.org>; Wed, 15 Oct 2025 23:10:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760569804; cv=none; b=Z/N/s/OdkpX4FCwSGe9JjUxk0LKT91M/utsE2pmjLWS353caR8k8hJ4p1M8v8XIEF82bVEANw+PPn9V4YAsx25OTwmr6EPTFlfU1fcK9zCzVwRazMCL+SF2rjDNqM5mv0g2W8AGwtkVcDfcqG8zsYPBbBv9XFprwuN85a5F62Ps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760569804; c=relaxed/simple;
	bh=u9n8OX8OI90hZ2HDNyPCeBC07tLYdl0EXEaigJstQSs=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=JAFwcvc7Oso03kb/TzP/WcoJhX+432v4Df9yDOASphbKxxKEdrhA/yyJvZkz6K8q7C1Eo2pPVqk0zjQHd6EJXhOtKLbs/jUN3MIvqaAkTfvoROcCwbiBuxj1p3aqeYQZOb7x1krQ7AEZAhwTycuO6bSSNEJe5J/YYmGaBQ3I4Sk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=devzero@web.de header.b=UZc8YoIi; arc=none smtp.client-ip=212.227.15.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=devzero@web.de header.b="UZc8YoIi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1760569798; x=1761174598; i=devzero@web.de;
	bh=u9n8OX8OI90hZ2HDNyPCeBC07tLYdl0EXEaigJstQSs=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=UZc8YoIiNs8Exv9UUU4fZP+oh9coxKtKRp5bMFqHfWz6hvfw5ORT+SH6wOQf2pUW
	 dy2S6PDv78bG0bkQ7S0Ph4rF/wy6ds+nKeZimGz+heVMrvpRym61rDMPbnw3/sEHx
	 i00IZGqrwVyX2NS5idSKketDHZMWsJtqHZ5kXolpRlbePusItwi62Ssevq1YDymRQ
	 PMiGM/nBBaT8bTDw0hXSaAQhE5g6PIIZJzZhdpu9rs+jvs+Iz6pymxlX+71NkGLNF
	 YlDUzbzVxhCTsnoGQM+AJKAGBHfYe0RITABs0FMcVfTnMV2YkZjM07WmQogyk+sIp
	 IfQfXnJlwoyy+N7sDQ==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.179.107] ([87.78.184.70]) by smtp.web.de (mrweb006
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1N3Gkg-1uAIWC2RhS-00wo6K; Thu, 16
 Oct 2025 01:09:58 +0200
Message-ID: <fd968202-04aa-48e3-bbd7-8520570d1ae2@web.de>
Date: Thu, 16 Oct 2025 01:09:57 +0200
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: status of bugzilla #99171 - mdraid broken for O_DIRECT
To: Hannes Reinecke <hare@suse.de>, Reindl Harald <h.reindl@thelounge.net>,
 linux-raid@vger.kernel.org
References: <A4168F21-4CDF-4BAD-8754-30BAA1315C6F@web.de>
 <e686d669-c41f-42a7-be53-9538feb4721f@web.de>
 <9ef4398c-3488-492e-82ed-903fc46fed70@suse.de>
From: Roland <devzero@web.de>
In-Reply-To: <9ef4398c-3488-492e-82ed-903fc46fed70@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:PndXl4AuFyNnxAsrKqA2yvLDYUHZJ29FkHmrN7s+Y0poFx+lLB9
 kwoemTyvyERyBnrS4RDppWjC5aOb7Q+0UrA1ObPfi6yT85UWykylDtK/Rf+2wcZLiNlL6KD
 0qjWimRb/9WbgFnMB/kC6OA1b947sM0VsrRFhiFLK8Z+gCsw0MKAlMG8QmBtNbnOUnmVsNt
 B67nW1v62S2haCL9z4mpA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:EhDOhnMoG/Y=;ZxCGJG6MuaEpJjpA+r3BZfTLGDo
 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
 Qf01w==

> Welll ... I am sure you are aware of the somewhat dubious state of zfs=
=20
> and linux, right?

yes , i know about this "dubious" state due to licensing issues, but=20
it's in this state for years now and a pretty solid and well installable=
=20
and usable filesystem , used in many enterprise setups, though.
i run dozens of zfs installations for years and did not have a single=20
major issue , data loss or data corruption with those. but that's a=20
different story not belonging here...

> And anyway: 'break userspace' is a matter of debate here; the use of
> O_DIRECT effectively moves the burden of checking I/O from the kernel
> to userspace; with O_DIRECT you can submit _any_ I/O without the kernel
> interfering, but at the same time you _must_ ensure that the I/O
> submitted conforms to the expectations the block layer has.
> And one of the expectation is that data is not modified between
> assembling the request and submitting the request to the drive.
>
> But that is precisely what the test program does.
>
>> please look at this issue from a security perspective.
>>
>> if you can break or corrupt your raid mirror from userspace even from=
=20
>> an insulated layer/environment, i would better consider this=20
>> "testcase" to be "malicious code" , which is able to subvert the=20
>> virtualization/block/ fs layer stack.
>>
>> how could we prevent, that non-trused users in a vm or container=20
>> environment can execute this "invalid" code ?
>>
> Well, yes, but then this is O_DIRECT.
>
>>
>> how can we prevent, that they do harm on the underlying mirror in a=20
>> hosting environment for example ?
>>
>
> Well, this has been an ongoing debate for years, and we from the linux
> side have had long discussions about that, too.
> But eventually we settled on the notion of 'stable pages', ie that the
> data buffer for a command _must not_ be modified between assembling the
> command and submitting the command to the drivers.
> Precisely such that we _can_ do things like data checksumming.
>
>> not using it in a hosting environment is a little bit weird strategy=20
>> for a linux basic technoligy which exists for years.
>>
> Oh, agreed. We do want to make linux better.
> But there is a perfectly viable workaround (namely: do not disable
> caching on the VM ...). So the question really is: where's the
> advantage?
> Security and O_DIRECT is always a very tricky subject, as O_DIRECT
> is precisely there to circumvent checks in the kernel. And yes,
> some of these checks are there to prevent security issues.
> So of course the will be security implications, but that was
> kinda the idea.
>
> Cheers,
>
> Hannes=20

thank you for your feedback.

i see, things are complicated and O_DIRECT is a very special beast....

meanwhile, i gave bcachefs a try today , because it looks interesting .

like zfs, it does not seem to be affected by this problem, at least from=
=20
my first tests reported at=20
https://bugzilla.kernel.org/show_bug.cgi?id=3D99171#c26 (i hope this is a=
=20
valid test for consistency)

so we have at least a second "software raid" technology besides zfs,=20
which does NOT suffer from the "by design" O_DIRECT breakage.

that's at least surprising me, as bcachefs is far from production=20
ready,=C2=A0 and i wonder why it just seems to work at this early stage of=
=20
development.

roland






