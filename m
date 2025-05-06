Received: from mail107.out.titan.email (mail107.out.titan.email [44.220.5.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63E882D5D04
	for <linux-raid@vger.kernel.org>; Tue,  6 May 2025 02:50:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.220.5.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746499805; cv=none; b=XySvhKCclOTR4kzEaoO7SIEvsSeU0iVd0S7EKRiGrWrulN+sV+P+56Xz2ix+oHO37I3vW4cjD2z3duase/j+y1ga4c/tcTxeo2UkFF4Mm13bhAHbYoh8MdhL654zlssLIfIaYDe7VkWkffVDIAOQlgD/grPALGtMARns1KnWhHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746499805; c=relaxed/simple;
	bh=FKi4ngNc76sBEFvtrMODsmXQ1XJog+27gFndRN273Nw=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=O00Vi/OIkEOqvjb5Ue8myhzXWg8UyDzGYlN+GbI3odvqvaOtpJSWxam5stP2cvjclQowFepfFMw81ZQU4fCLvoPG2SsLo0UyGHag6oPxUuFEbgnJYK8/5O1ZGUUvn6/GtRjxeyuDIVp+o0uZqNvJd+eyK2+sWi/QE6HaZIRkOnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=coly.li; spf=pass smtp.mailfrom=coly.li; dkim=pass (1024-bit key) header.d=t12smtp-sign004.email header.i=@t12smtp-sign004.email header.b=RlcH4OJd; arc=none smtp.client-ip=44.220.5.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=coly.li
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=coly.li
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=t12smtp-sign004.email header.i=@t12smtp-sign004.email header.b="RlcH4OJd"
Received: from localhost (localhost [127.0.0.1])
	by smtp-out.flockmail.com (Postfix) with ESMTP id 17DEEE03E0;
	Tue,  6 May 2025 02:34:19 +0000 (UTC)
DKIM-Signature: a=rsa-sha256; bh=SkUjRpMlygior7iWAnjiOFvZSc8PdBOUd9nO4pYDybs=;
	c=relaxed/relaxed; d=t12smtp-sign004.email;
	h=mime-version:subject:in-reply-to:date:from:references:cc:message-id:to:from:to:cc:subject:date:message-id:in-reply-to:references:reply-to;
	q=dns/txt; s=titan1; t=1746498858; v=1;
	b=RlcH4OJdRudGZ6ZoDDhPe92KePPHMGRiyNIoCV4KYF5bzUCkKeNNJUYd/RprKc7qFYB6bNW8
	hQGynxLo7ozFfz+CFHCmWEbQ84/MvyzHJaj4taHk4M6WT3OaFS4i3X81qyvFyzg4T8lnwwvZJnb
	Rci7WULbgZceKKfjyhqt/tdo=
Received: from smtpclient.apple (v133-18-227-172.vir.kagoya.net [133.18.227.172])
	by smtp-out.flockmail.com (Postfix) with ESMTPA id 1C4A6E03F7;
	Tue,  6 May 2025 02:34:15 +0000 (UTC)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.500.181.1.5\))
Subject: Re: [RFC PATCH] fix a reshape checking logic inside
 make_stripe_request()
Feedback-ID: :i@coly.li:coly.li:flockmailId
From: Coly Li <i@coly.li>
In-Reply-To: <ba1a64b6-db88-077b-2216-3b34d2cc55b3@huaweicloud.com>
Date: Tue, 6 May 2025 10:34:02 +0800
Cc: Coly Li <colyli@kernel.org>,
 linux-raid@vger.kernel.org,
 Logan Gunthorpe <logang@deltatee.com>,
 Xiao Ni <xni@redhat.com>,
 Song Liu <song@kernel.org>,
 "yukuai (C)" <yukuai3@huawei.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <9E1AEF87-FF33-4F0F-A8A4-97A1E2EB9EFA@coly.li>
References: <20250505152831.5418-1-colyli@kernel.org>
 <fgqrzhv5mbmrusocjkeybja6leaeeoi2r4hwihphi4lni2w3xg@meakhkiyuiab>
 <ba1a64b6-db88-077b-2216-3b34d2cc55b3@huaweicloud.com>
To: Yu Kuai <yukuai1@huaweicloud.com>
X-Mailer: Apple Mail (2.3826.500.181.1.5)
X-F-Verdict: SPFVALID
X-Titan-Src-Out: 1746498858921481349.26132.4652692255187061367@prod-use1-smtp-out1004.
X-CMAE-Score: 0
X-CMAE-Analysis: v=2.4 cv=fZxXy1QF c=1 sm=1 tr=0 ts=6819752a
	a=mj4eMbsE5mSnrU54dbyulA==:117 a=mj4eMbsE5mSnrU54dbyulA==:17
	a=IkcTkHD0fZMA:10 a=CEWIc4RMnpUA:10 a=AiHppB-aAAAA:8 a=VwQbUJbxAAAA:8
	a=gXLdhW2jAAAA:8 a=i0EeH86SAAAA:8 a=20KFwNOVAAAA:8 a=cFYND1yjmKNevEAXrVAA:9
	a=QEXdDO2ut3YA:10 a=Dn9eIPSr_RzuO0KTJioD:22



> 2025=E5=B9=B45=E6=9C=886=E6=97=A5 09:50=EF=BC=8CYu Kuai =
<yukuai1@huaweicloud.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> Hi,
>=20
> =E5=9C=A8 2025/05/05 23:47, Coly Li =E5=86=99=E9=81=93:
>> On Mon, May 05, 2025 at 11:28:31PM +0800, colyli@kernel.org wrote:
>>> From: Coly Li <colyli@kernel.org>
>>>=20
>>> Commit f4aec6a09738 ("md/raid5: Factor out helper from
>>> raid5_make_request() loop") added the following code block to check
>> After read historical commits, I realize the change was from
>> commit 486f60558607 ("md/raid5: Check all disks in a stripe_head for
>> reshape progress").
>>> whether the reshape range passed the stripe head range during =
thetime to
>>> wait for a valid struct stripe_head object,
>>>=20
>>> 5971         if (unlikely(previous) &&
>>> 5972             stripe_ahead_of_reshape(mddev, conf, sh)) {
>>> 5973                 /*
>>> 5974                  * Expansion moved on while waiting for a =
stripe.
>>> 5975                  * Expansion could still move past after this
>>> 5976                  * test, but as we are holding a reference to
>>> 5977                  * 'sh', we know that if that happens,
>>> 5978                  *  STRIPE_EXPANDING will get set and the =
expansion
>>> 5979                  * won't proceed until we finish with the =
stripe.
>>> 5980                  */
>>> 5981                 ret =3D STRIPE_SCHEDULE_AND_RETRY;
>>> 5982                 goto out_release;
>>> 5983         }
>>>=20
>>> But from the code comments and context, the if statement should =
check
>>> whether stripe_ahead_of_reshape() returns false, then the code logic =
can
>>> match the context that reshape range went accross the sh range =
during
>>> raid5_get_active_stripe().
>> And the code logic might be correct, because inside
>> stripe_ahead_of_reshape(),
>> 5788         if (!range_ahead_of_reshape(mddev, min_sector, =
max_sector,
>> 5789                                      conf->reshape_progress))
>> 5790                 /* mismatch, need to try again */
>> 5791                 ret =3D true;
>> true is returned when the sh range is NOT ahead of reshape position.
>> Then the logic makes sense, but the function name =
stripe_ahead_of_reshape()
>> is really misleading IMHO. Maybe it should be named something like
>> stripe_behind_reshape()?
>> Should we change the name? Or I missed something important and still =
don't
>> understand the code correctly?
>=20
> The logic is correct. What I understand is that the *ahead of* means
> reshape is not performed yet in this area, not that the location is
> ahead of reshape position. And 'reshape_backwards' can make location
> comparison different completely. Noted there is a local variable
> 'previous' with the same logical.
>=20
> Instead of 'behind', I'll perfer another name to reflect this.

Yes, the logic is correct, but the code in stripe_ahead_of_reshape() =
indeed checks whether
this stripe head is NOT ahead of reshape, see the code below which I =
copy & paste from
stripe_ahead_of_reshape(),

5788         if (!range_ahead_of_reshape(mddev, min_sector, max_sector,
5789                                      conf->reshape_progress))
5790                 /* mismatch, need to try again */
5791                 ret =3D true;

It returns =E2=80=98true=E2=80=99 when the sh range is in reshaped or =
reshaping range, not ahead of reshape range.
This is the expected logic, but the function name is misleading. That =
why I though the code logic
was incorrect at the first glance.

>=20
>=20
>>>=20
>>> And unlikely(previous) seems useless inside the if statement, and =
the
>>> unlikely() should include all checking statemetns.
>=20
> And I think the unlikely is fine, this is called from IO path, and the
> 'previous' is unlikely to set.
>=20

5971         if (unlikely(previous) &&
5972             stripe_ahead_of_reshape(mddev, conf, sh)) {
5973                 /*
5974                  * Expansion moved on while waiting for a stripe.
5975                  * Expansion could still move past after this
5976                  * test, but as we are holding a reference to
5977                  * 'sh', we know that if that happens,
5978                  *  STRIPE_EXPANDING will get set and the expansion
5979                  * won't proceed until we finish with the stripe.
5980                  */
5981                 ret =3D STRIPE_SCHEDULE_AND_RETRY;
5982                 goto out_release;
5983         }

For the above code, I don=E2=80=99t see how only unlikely(previous) help =
on branch prediction and prefetch,
IMHO the following form may help to achieve expected unlikely() result,

          if (unlikely(previous && !stripe_ahead_of_reshape(mddev, conf, =
sh))) {

Thanks.

Coly Li


>=20
>>>=20
>> This part still valid IMHO.
>> Thanks for comments.
>>> This patch has both of the above changes, hope it can make the code =
be
>>> more comfortable.
>>>=20
>>> Fixes: f4aec6a09738 ("md/raid5: Factor out helper from =
raid5_make_request() loop")
>>> Signed-off-by: Coly Li <colyli@kernel.org>
>>> Cc: Logan Gunthorpe <logang@deltatee.com>
>>> Cc: Yu Kuai <yukuai3@huawei.com>
>>> Cc: Xiao Ni <xni@redhat.com>
>>> Cc: Song Liu <song@kernel.org>
>>> ---
>>>  drivers/md/raid5.c | 3 +--
>>>  1 file changed, 1 insertion(+), 2 deletions(-)
>>>=20
>>> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
>>> index 39e7596e78c0..030e4672ab18 100644
>>> --- a/drivers/md/raid5.c
>>> +++ b/drivers/md/raid5.c
>>> @@ -5969,8 +5969,7 @@ static enum stripe_result =
make_stripe_request(struct mddev *mddev,
>>>   return STRIPE_FAIL;
>>>   }
>>>  - if (unlikely(previous) &&
>>> -     stripe_ahead_of_reshape(mddev, conf, sh)) {
>>> + if (unlikely(previous && !stripe_ahead_of_reshape(mddev, conf, =
sh))) {
>>>   /*
>>>    * Expansion moved on while waiting for a stripe.
>>>    * Expansion could still move past after this
>>> --=20
>>> 2.39.5


