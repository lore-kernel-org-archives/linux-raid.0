Received: from mout.web.de (mout.web.de [217.72.192.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F04FE233155
	for <linux-raid@vger.kernel.org>; Fri, 17 Oct 2025 20:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.72.192.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760732331; cv=none; b=bn3Ccs42gmZilTZ9kXyQwhDDdvxf40TYpbjVC5nIADozQKiT4uNheKtxBNM2a1uI1XMBChvBcOIH+JQostXm1OlQwRzJ0gkABTjAHMDNCXBdIKOhgw/OC5zKseLDiiQorGdW4FZH2Zh/xqkuTGH5K7oggVDfdpRAHMaVjL1Dmeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760732331; c=relaxed/simple;
	bh=WU4aEBJjpLH22FlvRCrPTkRzlLIPkVtwICZQ7kqkGoU=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=IhLQ4QPScplQdgVTrT12idIznJ80Zfq9x6Rug+EN8010n3+KLPNtjlyW/nmiyqUFGvE4fdSrtQsBerPmvZzbPUHxznyKzYMVwBDJdDVBE6oS9bwKqg6GDQRDq1lQcSGdi2EsD48uUu+YO5W5RgLLu88ehS+WCSCMbYbmA/z9KmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=devzero@web.de header.b=vkgJJ1UU; arc=none smtp.client-ip=217.72.192.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=devzero@web.de header.b="vkgJJ1UU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1760732321; x=1761337121; i=devzero@web.de;
	bh=WU4aEBJjpLH22FlvRCrPTkRzlLIPkVtwICZQ7kqkGoU=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=vkgJJ1UUbGXlFfE5R5wZCgBXKLE5mG2JEPriafG8sQiTYJHzkBb6X4ABbCP5Rm9J
	 SbwB7/iCYcQWaX9J8YQ3jDGy5+HExupyy3PIQ6caa8mAYglGWrLitaCHVxJNn9061
	 NuIT8ikFcgVSGOyNmKI3stWWnXdOwWiAbAxDCWmTKkXRAsokH3vJZ1NLs9tCCQ2r3
	 PN2dxsvicWEkSWbNQZ7+PZxdzDTBkr67l8DkqgvNia6yKZWVtLvRPuS0BYs7SNOHd
	 3nWO7SHzkMBeFHymu/0Vdt/Tdnx4BQKsa7VzmTCOd9DcZa1npAl7c4yebOR9njt+s
	 cYBy/dT86OBdaXr0OQ==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.179.107] ([78.34.206.180]) by smtp.web.de (mrweb105
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1M7Nig-1v8m3J0aR2-00FOus; Fri, 17
 Oct 2025 22:18:41 +0200
Message-ID: <fc14e278-34d0-408c-93ef-ad22a42e87fd@web.de>
Date: Fri, 17 Oct 2025 22:18:40 +0200
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
 <fd968202-04aa-48e3-bbd7-8520570d1ae2@web.de>
 <92bc9643-53fe-4c56-abdd-7a9efb451f1c@suse.de>
From: Roland <devzero@web.de>
In-Reply-To: <92bc9643-53fe-4c56-abdd-7a9efb451f1c@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:iaH+ruifiUZrju8/DosX72m1WrO1QEDCr4FD84v1w83ysrP5oK8
 J2TgMuZynPdSa1HDrrw0Q2wbq4+2NZc525zY47V6uy3Q+CuxaimZGFqOYhqvTMjeNn+Fonb
 dS1eZme3jVrLKFSJq4WSkbzgW79Xr74cCxJqYTcpOY5l8BRsVb8xvehM3lgg2sCAQqwkid3
 qhNhd6tu2RS9fn+46jl/Q==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:TBbAiCcTNf8=;I26Cszh++q04oMjIy68p/x21Rtr
 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

good evening,

are you really sure fs-fsdevel is the right place to report this?

i just was able to reproduce the mdraid breakage without any filesystem=20
involved,=C2=A0 just put lvm on top of mdraid and passed lvm logical volum=
es=20
from that to the debian vm, and then ran "break-raid-odirect /dev/sdb"=20
inside vm.

meanwhile,=C2=A0 btrfs issue with O_DIRECT seems to be fixed,=C2=A0 at lea=
st from=20
my quick tests, reported at=20
https://bugzilla.kernel.org/show_bug.cgi?id=3D99171#c35 . btrfs fix is=20
also linked there.

regards
Roland

Am 16.10.25 um 08:02 schrieb Hannes Reinecke:
> On 10/16/25 01:09, Roland wrote:
> [ .. ]>
>> thank you for your feedback.
>>
>> i see, things are complicated and O_DIRECT is a very special beast....
>>
>> meanwhile, i gave bcachefs a try today , because it looks interesting .
>>
>> like zfs, it does not seem to be affected by this problem, at least=20
>> from my first tests reported at=20
>> https://bugzilla.kernel.org/show_bug.cgi? id=3D99171#c26 (i hope this=
=20
>> is a valid test for consistency)
>>
>> so we have at least a second "software raid" technology besides zfs,=20
>> which does NOT suffer from the "by design" O_DIRECT breakage.
>>
>> that's at least surprising me, as bcachefs is far from production=20
>> ready,=C2=A0 and i wonder why it just seems to work at this early stage=
 of=20
>> development.
>>
> Hmm. True.
>
> I would suggest bringing up this topic on linux-fsdevel; there is
> always a chance that there is a bug somewhere.
> At least some explanation would be warranted why bcachefs does not
> suffer from this issue.
>
> Cheers,
>
> Hannes
