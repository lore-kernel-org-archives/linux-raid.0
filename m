Received: from e234-57.smtp-out.ap-northeast-1.amazonses.com (e234-57.smtp-out.ap-northeast-1.amazonses.com [23.251.234.57])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93F2E39890A;
	Wed, 23 Sep 2026 04:08:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=23.251.234.57
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790136505; cv=none; b=WLVMN3n+Hz33APirSrH5KDbLSg/my1O5tPcOrY58d2kMD+hE/i6h7j0Zd8of2jTP4vU8hcIdaZJyLRO3grgywfQRkc8wYGUhRlEPBCOcgwvFO7gODXicR8tMKOV8yRcUtWuUiImoYi2SgqjHGy51gOyQRITgegZ0PAgVF3hR/aI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790136505; c=relaxed/simple;
	bh=oCgfmvH6rMSIRzC1+/rGnvNMhMMQckafrufxciJ2m7U=;
	h=In-Reply-To:From:To:Cc:Subject:Message-ID:Date:MIME-Version:
	 Content-Type; b=dMbsbhRZAO9I0LjnNu9wiSt8j21Va/sQHu8tfo3w0nN2ERsZvfV8vS8hicjVSs08WL+RMV/KqRNkb7GqNmgxs+QuIysXJ+B/mzHwlcsaf27EaiTO3eOY2b4imDeoLvMsTM2r0a5P+m5NCQCKnMQhqS5Qm0K+JYXlTBzKqkPnnvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mgml.me; spf=pass smtp.mailfrom=send.mgml.me; dkim=pass (1024-bit key) header.d=mgml.me header.i=@mgml.me header.b=V9L/aZaL; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=hxzhJZpK; arc=none smtp.client-ip=23.251.234.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mgml.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=send.mgml.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mgml.me header.i=@mgml.me header.b="V9L/aZaL";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="hxzhJZpK"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple; s=resend;
	d=mgml.me; t=1790136502;
	h=In-Reply-To:From:To:Cc:Subject:Message-ID:Content-Transfer-Encoding:Date:MIME-Version:Content-Type;
	bh=oCgfmvH6rMSIRzC1+/rGnvNMhMMQckafrufxciJ2m7U=;
	b=V9L/aZaL0OYKe4hiE7bG4izv3k82Sh0BY6B5J8+mBGHRYDYuDe13Lzv1btu9e/Xt
	P5efHSIv+77jm2XaG+gR6c5AY9sGEOZ+r9xdwF3dkrI6TxS3VFwvWBoG2p5Xc0ypZGj
	nzXZbvCchW8FgORFiZVvuzl5MaVKg8nu0yZ8qcdI=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=zh4gjftm6etwoq6afzugpky45synznly; d=amazonses.com; t=1790136502;
	h=In-Reply-To:From:To:Cc:Subject:Message-ID:Content-Transfer-Encoding:Date:MIME-Version:Content-Type:Feedback-ID;
	bh=oCgfmvH6rMSIRzC1+/rGnvNMhMMQckafrufxciJ2m7U=;
	b=hxzhJZpKknFvT+cKKW1RKVNLaAWwX1fmjHioQIwga0wJyDiSZsReyAUuUXxVa3Tt
	0DQiQlfAmlxhrYMoM9IkSISoIm/g3CK0ZXsqNMpnnFQDVTcQtk5qXL/WjaxZFSr+n+g
	5bJEUTRGPHPKzDjWAqdvs4yKzuamUr0jRR/iMvoQ=
User-Agent: Mozilla Thunderbird
Content-Language: en-US
In-Reply-To: <0cce3ff7dc782ef2f2618212b6b87889aea8e653.camel@suse.com>
From: Kenta Akagi <k@mgml.me>
To: martin.wilck@suse.com, xni@redhat.com, linan666@huaweicloud.com
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, 
	song@kernel.org, yukuai@fnnas.com, shli@fb.com, mtkaczyk@kernel.org
Subject: Re: [PATCH v6 1/2] md: Don't set MD_BROKEN for RAID1 and RAID10
 when using FailFast
Message-ID: <010601a0cc7347e3-ff9a517e-b03b-4de5-bd38-93b664f3425c-000000@ap-northeast-1.amazonses.com>
Content-Transfer-Encoding: quoted-printable
Date: Wed, 23 Sep 2026 04:08:22 +0000
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Feedback-ID: :1.ap-northeast-1.SskAFE1oaJ7KCjyyJFCV37nkSRmUZttpeGoevLE2CszduPSq19CK0OWqrkMmPMemkYWmFvQfvS6+lCR9ETv8vDWvEFaQZtUQ69n4DuGGNbGH4U7i+CnKWCHWm/HpilUFxPcCpCRFiQTHPHnKlfimqanQj7AjyJ2y8XQuaQGs83Sl+MS5tJ/lS6+Uh2zwyhRo:1.ap-northeast-1.TOS0vxEE3Ar6ai29fkp2i/jb+l2iigajCGeLfF7S3sk=:AmazonSES
X-SES-Outgoing: 2026.09.23-23.251.234.57



On 2026/09/17 22:58, Martin Wilck wrote:
> Hello Kenta, all,
>=20
> On Fri, 2026-01-16 at 11:04 +0900, Kenta Akagi wrote:
>>
>>
>> On 2026/01/07 12:35, Xiao Ni wrote:
>>> On Tue, Jan 6, 2026 at =
8:30=E2=80=AFPM Kenta Akagi <k@mgml.me> wrote:
>>>>
>>>> Hi,
>>>> Thank you for reviewing.
>>>>
>>>> On 2026/01/06 11:57, Li Nan wrote:
>>>>>
>>>>>
>>>>> =E5=9C=A8 2026/1/5 22:40, Kenta Akagi =E5=86=99=E9=81=93:
>>>>>> After commit 9631abdbf406 ("md: Set MD_BROKEN for RAID1 and
>>>>>> RAID10"),
>>>>>> if the error handler is called on the last rdev in =
RAID1 or
>>>>>> RAID10,
>>>>>> the MD_BROKEN flag will be set on that mddev=
.
>>>>>> When MD_BROKEN is set, write bios to the md will result in an
>>>>>> I/O error.
>>>>>>
>>>>>> This causes a problem when using FailFast.
>>>>>> The current implementation of FailFast expects the array to
>>>>>> continue
>>>>>> functioning without issues even after calling =
md_error for
>>>>>> the last
>>>>>> rdev.=C2=A0 Furthermore, due to the =
nature of its functionality,
>>>>>> FailFast may
>>>>>> call md_error on =
all rdevs of the md. Even if retrying I/O on
>>>>>> an rdev
>>>>>> would succeed, it first calls md_error before retrying.
>>>>>>
>>>>>> To fix this issue, this commit ensures that for RAID1 and
>>>>>> RAID10, if the
>>>>>> last In_sync rdev has the FailFast flag set =
and the mddev's
>>>>>> fail_last_dev
>>>>>> is off, the MD_BROKEN flag will=
 not be set on that mddev.
>>>>>>
>>>>>> This change impacts userspace. =
After this commit, If the rdev
>>>>>> has the
>>>>>> FailFast flag, the =
mddev never broken even if the failing bio
>>>>>> is not
>>>>>> FailFast. However, it's unlikely that any setup using
>>>>>> FailFast expects
>>>>>> the array to halt when md_error is called on=
 the last rdev.
>>>>>>
>>>>>
>>>>> In the current RAID design, when an IO =
error occurs, RAID
>>>>> ensures faulty
>>>>> data is not read via the =
following actions:
>>>>> 1. Mark the badblocks (no FailFast flag); if this =
fails,
>>>>> 2. Mark the disk as Faulty.
>>>>>
>>>>> If neither action is =
taken, and BROKEN is not set to prevent
>>>>> continued RAID
>>>>> use, errors on the last remaining disk will be ignored.
>>>>> Subsequent reads
>>>>> may return incorrect data. This seems like a =
more serious issue
>>>>> in my opinion.
>>>>
>>>> I agree that data =
inconsistency can certainly occur in this
>>>> scenario.
>>>>
>>>> However, a RAID1 with only one remaining rdev can considered the
>>>> same as a plain
>>>> disk. From that perspective, I do not believe it =
is the mandatory
>>>> responsibility
>>>> of md raid to block subsequent =
writes nor prevent data
>>>> inconsistency in this situation.
>>>>
>>>> The commit 9631abdbf406 ("md: Set MD_BROKEN for RAID1 and
>>>> RAID10") that introduced
>>>> BROKEN for RAID1/10 also does not seem =
to have done so for that
>>>> responsibility.
>>>>
>>>>>
>>>>> In scenarios with a large number of transient IO errors, is
>>>>> FailFast not a
>>>>> suitable configuration? As you mentioned: =
"retrying I/O on an
>>>>> rdev would
>>>>
>>>> It seems be right about that=
. Using FailFast with unstable
>>>> underlayer is not good.
>>>> However, as md raid, which is issuer of FailFast bios,
>>>> I believe it is incorrect to shutdown the array due to the
>>>> failure of a FailFast bio.
>>>
>>> Hi all
>>>
>>> I understand @Li Nan=
 's point now. The badblock can't be recorded
>>> in
>>> this situation and the last working device is not set to faulty. To
>>> be
>>> frank, I think consistency of data is more important. Users =
don't
>>> think it's a single disk, they must think raid1 should guarantee
>>> the
>>> consistency. But the write request should return an error when
>>> calling
>>> raid1_error for the last working device, right? So there is=
 no
>>> consistency problem?
>>
>> Hi all,
>>
>> I understand that when =
md_error is issued for the last remaining
>> rdev,=20
>> the array should be stopped except in the failfast case, also,=20
>> it is no longer appropriate to treat an RAID1 array that has lost=20
>> redundancy as "just a normal single drive" [1].
>>
>> I will post an PATCH v7 based on v5.
>=20
> I wonder what became of this=
 v7 series. Have you given up on this?
> If yes, what is the bottom line - =
simply not using failfast in setups
> like the one you described?

Hi Martin,

I have not given up on it, but I have not managed to post v7 =
yet.
I still think failfast should be usable even in setups like that.

It has been a while, but I intend to resume work on it.

Thanks,
Akagi

>=20
> Martin
>=20
> --=20
> Dr. Martin Wilck <mwilck@suse.com>
> SUSE Software Solutions Germany GmbH, Frankenstr. 146, 90461 =
N=C3=BCrnberg,
> Germany
> Gesch=C3=A4ftsf=C3=BChrer: Stefan Gaiser, Jochen=
 Jaser, Abhinav Puri (HRB
> 36809,AG N=C3=BCrnberg)
>=20

