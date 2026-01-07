Received: from e234-52.smtp-out.ap-northeast-1.amazonses.com (e234-52.smtp-out.ap-northeast-1.amazonses.com [23.251.234.52])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1B0624A044;
	Wed,  7 Jan 2026 06:43:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=23.251.234.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767768216; cv=none; b=A8iJ1DuNU63RNR6kjFA2oNDkku2OUjr3/UWjk9V/xpfrXDKpVwRmU+kWV5LZ+6P2JXn2HIVDxEN476by6jMPGRVfAAER5u049Fr2rRc7DxqYfyt+My5w22Hd0J5BJaim/CnZ3lylfEEHBNfjSurcvU97D2o+Oe3NDlKKxC0YUFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767768216; c=relaxed/simple;
	bh=pfgh3jLlrQNlaLXiBZnL7JuzzxMETRln9wo8pC2ZET0=;
	h=In-Reply-To:From:To:Cc:Subject:Message-ID:Date:MIME-Version:
	 Content-Type; b=b6IrYCaLdyGZxmLx9Sf/NeaamaGwXW8rjrzNHo8e1PQ79eGyNwB6aG5OPO+FXsQO7ZIrUYqlVF5p+LhQs28W8Z4FKWBac/Hd35RHbaCmRtlZGVPKZgoHQehBU2WTYsLPbAHtnC3kNisAlWG4jvfGmwY/Vnkir6C11CTPMZYp7Dc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mgml.me; spf=pass smtp.mailfrom=send.mgml.me; dkim=pass (1024-bit key) header.d=mgml.me header.i=@mgml.me header.b=iR8Rj1kO; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=CsXqQnok; arc=none smtp.client-ip=23.251.234.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mgml.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=send.mgml.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mgml.me header.i=@mgml.me header.b="iR8Rj1kO";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="CsXqQnok"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple; s=resend;
	d=mgml.me; t=1767768213;
	h=In-Reply-To:From:To:Cc:Subject:Message-ID:Content-Transfer-Encoding:Date:MIME-Version:Content-Type;
	bh=pfgh3jLlrQNlaLXiBZnL7JuzzxMETRln9wo8pC2ZET0=;
	b=iR8Rj1kOBOb7joQm8oU/AY1a13FqhYW1an7W2kgSyH7nxrxfbZ+gH6WXdxBdgOWg
	6e3Ixx+O9ddmuVHwPtdjlQ4wN3C/dWOHvhAKvp7jijgj0atZpVUodJo5Uk71Y6xZCmS
	ORYPHWUAayjYafhOhSN2ddfGuNB6eyUgn+7HRMFk=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=suwteswkahkjx5z3rgaujjw4zqymtlt2; d=amazonses.com; t=1767768213;
	h=In-Reply-To:From:To:Cc:Subject:Message-ID:Content-Transfer-Encoding:Date:MIME-Version:Content-Type:Feedback-ID;
	bh=pfgh3jLlrQNlaLXiBZnL7JuzzxMETRln9wo8pC2ZET0=;
	b=CsXqQnokD6m04LR3cnubTZ0Qjc0Vga/zZbqHj7kXrh9vpJ5uGPCPLzK7At2w+U2e
	Dt0vDPx6mBR/nnGiJS1n+m9he5nGlGpzx9EW6ocoFSYkeMR8mY0oEhxk5ooTLV02zPo
	4KMwoQ7H6ZoHYxDKUaEFnf+oLAF9hd6myACcY8oE=
User-Agent: Mozilla Thunderbird
Content-Language: en-US
In-Reply-To:
 <CALTww282Kyg9ERXeSiY5Thd-O40vEXjAXsD8A2PxEsd-h-Cg3Q@mail.gmail.com>
From: Kenta Akagi <k@mgml.me>
To: Xiao Ni <xni@redhat.com>
Cc: k@mgml.me, linan666@huaweicloud.com, linux-raid@vger.kernel.org, 
	linux-kernel@vger.kernel.org, song@kernel.org, yukuai@fnnas.com, 
	shli@fb.com, mtkaczyk@kernel.org
Subject: Re: [PATCH v6 1/2] md: Don't set MD_BROKEN for RAID1 and RAID10
 when using FailFast
Message-ID: <0106019b97324465-29511120-f4d0-4ac7-88e0-d0b998071b79-000000@ap-northeast-1.amazonses.com>
Content-Transfer-Encoding: quoted-printable
Date: Wed, 7 Jan 2026 06:43:32 +0000
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Feedback-ID: ::1.ap-northeast-1.TOS0vxEE3Ar6ai29fkp2i/jb+l2iigajCGeLfF7S3sk=:AmazonSES
X-SES-Outgoing: 2026.01.07-23.251.234.52

Hi,

On 2026/01/07 12:35, Xiao Ni wrote:
> On Tue, Jan 6, 2026 at =
8:30=E2=80=AFPM Kenta Akagi <k@mgml.me> wrote:
>>
>> Hi,
>> Thank you for reviewing.
>>
>> On 2026/01/06 11:57, Li Nan wrote:
>>>
>>>
>>> =E5=9C=A8 2026/1/5 22:40, Kenta Akagi =E5=86=99=E9=81=93:
>>>> After commit 9631abdbf406 ("md: Set MD_BROKEN for RAID1 and RAID10"),
>>>> if the error handler is called on the last rdev in RAID1 or RAID10,
>>>> the MD_BROKEN flag will be set on that mddev.
>>>> When MD_BROKEN is =
set, write bios to the md will result in an I/O error.
>>>>
>>>> This causes a problem when using FailFast.
>>>> The current =
implementation of FailFast expects the array to continue
>>>> functioning without issues even after calling md_error for the last
>>>> rdev.  Furthermore, due to the nature of its functionality, FailFast =
may
>>>> call md_error on all rdevs of the md. Even if retrying I/O on an =
rdev
>>>> would succeed, it first calls md_error before retrying.
>>>>
>>>> To fix this issue, this commit ensures that for RAID1 and RAID10, if =
the
>>>> last In_sync rdev has the FailFast flag set and the mddev's =
fail_last_dev
>>>> is off, the MD_BROKEN flag will not be set on that mddev=
.
>>>>
>>>> This change impacts userspace. After this commit, If the rdev =
has the
>>>> FailFast flag, the mddev never broken even if the failing bio =
is not
>>>> FailFast. However, it's unlikely that any setup using FailFast =
expects
>>>> the array to halt when md_error is called on the last rdev.
>>>>
>>>
>>> In the current RAID design, when an IO error occurs, RAID =
ensures faulty
>>> data is not read via the following actions:
>>> 1. Mark the badblocks (no FailFast flag); if this fails,
>>> 2. Mark the disk as Faulty.
>>>
>>> If neither action is taken, and =
BROKEN is not set to prevent continued RAID
>>> use, errors on the last =
remaining disk will be ignored. Subsequent reads
>>> may return incorrect =
data. This seems like a more serious issue in my opinion.
>>
>> I agree that data inconsistency can certainly occur in this scenario.
>>
>> However, a RAID1 with only one remaining rdev can considered the same as=
 a plain
>> disk. From that perspective, I do not believe it is the =
mandatory responsibility
>> of md raid to block subsequent writes nor =
prevent data inconsistency in this situation.
>>
>> The commit 9631abdbf406=
 ("md: Set MD_BROKEN for RAID1 and RAID10") that introduced
>> BROKEN for RAID1/10 also does not seem to have done so for that =
responsibility.
>>
>>>
>>> In scenarios with a large number of transient IO=
 errors, is FailFast not a
>>> suitable configuration? As you mentioned: =
"retrying I/O on an rdev would
>>
>> It seems be right about that. Using =
FailFast with unstable underlayer is not good.
>> However, as md raid, =
which is issuer of FailFast bios,
>> I believe it is incorrect to shutdown =
the array due to the failure of a FailFast bio.
>=20
> Hi all
>=20
> I understand @Li Nan 's point now. The badblock can't be recorded in
> this situation and the last working device is not set to faulty. To be
> frank, I think consistency of data is more important. Users don't
> think it's a single disk, they must think raid1 should guarantee the

Hmm, I see...

> consistency. But the write request should return an error =
when calling
> raid1_error for the last working device, right? So there is =
no
> consistency problem?
>=20
> hi, Kenta. I have a question too. What =
will you do in your environment
> after the network connection works again?=
 Add those disks one by one
> to do recovery?

Yes. We will have to add a =
new disk or remove and add the rdev marked as faulty.
Currently, the array is being recreated because it is mark as broken.

Thanks,
Akagi

>=20
> Best Regards
> Xiao
>=20
>>
>> Thanks,
>> Akagi
>>
>>> succeed".
>>>
>>> --
>>> Thanks,
>>> Nan
>>>
>>>
>>
>=20
>=20

