Received: from e234-57.smtp-out.ap-northeast-1.amazonses.com (e234-57.smtp-out.ap-northeast-1.amazonses.com [23.251.234.57])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B3A032D0E9;
	Tue,  6 Jan 2026 12:30:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=23.251.234.57
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767702646; cv=none; b=oP0894MsyzDyx6R7GbIAvRMik4zCVCTkB43M69TwM34+NOmYnwti6GGmcikoAPAjG6aeBujMzxwT1YwN0WF4epnMTI/zchpvPnxcr3eBtnXUmllIdtOMDu54dORIgUyvePPe3CjwKRpoStQPNLf5bsIJpnD0fM+9gAKZVAY+7Dk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767702646; c=relaxed/simple;
	bh=C+2yc6zFIqaO0EwtLC4G2s8ZYnvXgF5meCgMBqw5MUk=;
	h=In-Reply-To:From:To:Cc:Subject:Message-ID:Date:MIME-Version:
	 Content-Type; b=NU8t1h/j0Yv2Sp1vtc+cE1bEq0q1WLCuy+VjpQaAAGnEgmBHMLDAC1m0gEDf8cLSLUVxt+pdUgxhV3b3dxsbQ9zdaVA31iktQWmV5pfsyB1g4+dzZZ/sLawGeXtpC8MMueaPk63s4QBlmSlXUiBW5VHuQzUQfbSrWhpLjnuoyMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mgml.me; spf=pass smtp.mailfrom=send.mgml.me; dkim=pass (1024-bit key) header.d=mgml.me header.i=@mgml.me header.b=ZWMEj7TC; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=3MkMcL18; arc=none smtp.client-ip=23.251.234.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mgml.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=send.mgml.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mgml.me header.i=@mgml.me header.b="ZWMEj7TC";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="3MkMcL18"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple; s=resend;
	d=mgml.me; t=1767702642;
	h=In-Reply-To:From:To:Cc:Subject:Message-ID:Content-Transfer-Encoding:Date:MIME-Version:Content-Type;
	bh=C+2yc6zFIqaO0EwtLC4G2s8ZYnvXgF5meCgMBqw5MUk=;
	b=ZWMEj7TCmhkAs0VngyG3KCcdQFpn9ojURq45zmlrNEAWGKUDkbd4762sUusWursO
	Jsd0HoWM47feWawa+fpEMOGTOA0+9O4zVtmk50JLfOqnpoD+08/DsBHsi6fxu4TAzTu
	xXxDWGPDek/5Xfx9fX9Fw8o6PQl/GzmwN85O45ss=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=suwteswkahkjx5z3rgaujjw4zqymtlt2; d=amazonses.com; t=1767702642;
	h=In-Reply-To:From:To:Cc:Subject:Message-ID:Content-Transfer-Encoding:Date:MIME-Version:Content-Type:Feedback-ID;
	bh=C+2yc6zFIqaO0EwtLC4G2s8ZYnvXgF5meCgMBqw5MUk=;
	b=3MkMcL1808uRvNxoKmvvOy6GLEZymb8wqgkL+oqQelTibThAUx567bH2S2AE/xgu
	tarzkYChLY8yRZbWuA/L+00zQQjmyqeB0vGyRMvNtnneaVf9/SykPugFTTc3LuIn/aN
	i+qcKrmD9aCwi97sYJLHZBNREYbVtcJGGEiRJHac=
User-Agent: Mozilla Thunderbird
Content-Language: en-US
In-Reply-To: <7944a042-2e1e-1487-1b42-529768afbbd0@huaweicloud.com>
From: Kenta Akagi <k@mgml.me>
To: linan666@huaweicloud.com, xni@redhat.com
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, 
	song@kernel.org, yukuai@fnnas.com, shli@fb.com, mtkaczyk@kernel.org
Subject: Re: [PATCH v6 1/2] md: Don't set MD_BROKEN for RAID1 and RAID10
 when using FailFast
Message-ID: <0106019b9349bf39-5460c782-3d63-43cb-a56e-e34760ce51cd-000000@ap-northeast-1.amazonses.com>
Content-Transfer-Encoding: quoted-printable
Date: Tue, 6 Jan 2026 12:30:42 +0000
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Feedback-ID: ::1.ap-northeast-1.TOS0vxEE3Ar6ai29fkp2i/jb+l2iigajCGeLfF7S3sk=:AmazonSES
X-SES-Outgoing: 2026.01.06-23.251.234.57

Hi,
Thank you for reviewing.

On 2026/01/06 11:57, Li Nan wrote:
>=20
>=20
> =E5=9C=A8 2026/1/5 22:40, Kenta Akagi =E5=86=99=E9=81=93:
>> After commit 9631abdbf406 ("md: Set MD_BROKEN for RAID1 and RAID10"),
>> if the error handler is called on the last rdev in RAID1 or RAID10,
>> the MD_BROKEN flag will be set on that mddev.
>> When MD_BROKEN is set, =
write bios to the md will result in an I/O error.
>>
>> This causes a problem when using FailFast.
>> The current implementation=
 of FailFast expects the array to continue
>> functioning without issues =
even after calling md_error for the last
>> rdev.=C2=A0 Furthermore, due to=
 the nature of its functionality, FailFast may
>> call md_error on all =
rdevs of the md. Even if retrying I/O on an rdev
>> would succeed, it first=
 calls md_error before retrying.
>>
>> To fix this issue, this commit =
ensures that for RAID1 and RAID10, if the
>> last In_sync rdev has the =
FailFast flag set and the mddev's fail_last_dev
>> is off, the MD_BROKEN =
flag will not be set on that mddev.
>>
>> This change impacts userspace. =
After this commit, If the rdev has the
>> FailFast flag, the mddev never =
broken even if the failing bio is not
>> FailFast. However, it's unlikely =
that any setup using FailFast expects
>> the array to halt when md_error is=
 called on the last rdev.
>>
>=20
> In the current RAID design, when an IO =
error occurs, RAID ensures faulty
> data is not read via the following =
actions:
> 1. Mark the badblocks (no FailFast flag); if this fails,
> 2. Mark the disk as Faulty.
>=20
> If neither action is taken, and BROKEN=
 is not set to prevent continued RAID
> use, errors on the last remaining =
disk will be ignored. Subsequent reads
> may return incorrect data. This =
seems like a more serious issue in my opinion.

I agree that data =
inconsistency can certainly occur in this scenario.

However, a RAID1 with only one remaining rdev can considered the same as a =
plain
disk. From that perspective, I do not believe it is the mandatory =
responsibility
of md raid to block subsequent writes nor prevent data =
inconsistency in this situation.

The commit 9631abdbf406 ("md: Set =
MD_BROKEN for RAID1 and RAID10") that introduced
BROKEN for RAID1/10 also =
does not seem to have done so for that responsibility.

>=20
> In scenarios with a large number of transient IO errors, is FailFast not =
a
> suitable configuration? As you mentioned: "retrying I/O on an rdev =
would

It seems be right about that. Using FailFast with unstable =
underlayer is not good.
However, as md raid, which is issuer of FailFast =
bios,
I believe it is incorrect to shutdown the array due to the failure of=
 a FailFast bio.

Thanks,
Akagi

> succeed".
>=20
> --=C2=A0
> Thanks,
> Nan
>=20
>=20

