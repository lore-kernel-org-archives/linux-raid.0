Received: from e234-57.smtp-out.ap-northeast-1.amazonses.com (e234-57.smtp-out.ap-northeast-1.amazonses.com [23.251.234.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB7732E2644;
	Thu, 18 Sep 2025 16:12:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=23.251.234.57
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758211981; cv=none; b=R541T1u9NWRx7pFaEsQoBfO8BzVxAmQBlFnd9Fbw+dZti1vR7plig+K8qRyhnXrbDO1gn7KN++s+1B1w+nT8AwXtHhk8cbqBZRgcjznwANUjs/Vl24zyBEc+mv9wNmQGn48h1nEkOti82ds9q9cmqvm7+nkjbMhyHixl+brjCv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758211981; c=relaxed/simple;
	bh=ic2DdsPhqzZai0gh2uHOtWWCtQ1BWS6D1TUtB+Y2S1E=;
	h=In-Reply-To:From:To:Cc:Subject:Message-ID:Date:MIME-Version:
	 Content-Type; b=KcuLozf1A42cylz/0jr5I1AKF+m9JqGFcnrIy7NY1qy/DFjZvmO3cMwpy1OGpyd8ChANIS9htVL8ri7/S+FIegNV1FaXD6vKaLHO7A8isijVNArsXVuJ4Ri6W9QCzqYWwkkCxb6fZ3pu0cncpXHZhy2qYWgzBxOlLwL0mL0C7Tg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mgml.me; spf=pass smtp.mailfrom=send.mgml.me; dkim=pass (1024-bit key) header.d=mgml.me header.i=@mgml.me header.b=DsirBSWZ; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=i/aQKCEO; arc=none smtp.client-ip=23.251.234.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mgml.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=send.mgml.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mgml.me header.i=@mgml.me header.b="DsirBSWZ";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="i/aQKCEO"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple; s=resend;
	d=mgml.me; t=1758211978;
	h=In-Reply-To:From:To:Cc:Subject:Message-ID:Content-Transfer-Encoding:Date:MIME-Version:Content-Type;
	bh=ic2DdsPhqzZai0gh2uHOtWWCtQ1BWS6D1TUtB+Y2S1E=;
	b=DsirBSWZb2R19rQTfNEUlCMXqXegoqxYO2pmlU0u2S3ao4FfuCgiKSZlpcNmgdPC
	9JWlFLdQtZ344Fk5accp30BtaN7OJ6F0ltIRNvatRZBO8pbdR/COek2Et41G0/i0Dti
	rbOzOdHgY611f/NGI/7+UMQmjkCFhjZNw6w+z7Yo=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=suwteswkahkjx5z3rgaujjw4zqymtlt2; d=amazonses.com; t=1758211978;
	h=In-Reply-To:From:To:Cc:Subject:Message-ID:Content-Transfer-Encoding:Date:MIME-Version:Content-Type:Feedback-ID;
	bh=ic2DdsPhqzZai0gh2uHOtWWCtQ1BWS6D1TUtB+Y2S1E=;
	b=i/aQKCEO05mGU1/okx/xOscwFhzCIBG7q1HZcBYHcUpPjnbr2W+gjgGMla9Va9VS
	nirzeqC6kUi5PYoMis9lpBWaRlTKcY+FtkfyhO9i+fcgvcwyaOKmQepoJoSBak3XQVX
	wn0olbT6z+5ty/eFqp0zEX0PcvJFwtqKA4xX3ha0=
User-Agent: Mozilla Thunderbird
Content-Language: en-US
In-Reply-To: <e7031446-88be-cd4d-ca00-7ce95da5f55a@huaweicloud.com>
From: Kenta Akagi <k@mgml.me>
To: linan666@huaweicloud.com, song@kernel.org, yukuai3@huawei.com, 
	mtkaczyk@kernel.org, shli@fb.com, jgq516@gmail.com
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, k@mgml.me
Subject: Re: [PATCH v4 7/9] md/raid10: fix failfast read error not
 rescheduled
Message-ID: <010601995d99b3dc-e860902f-c7c4-4d04-8adb-c49a551a616a-000000@ap-northeast-1.amazonses.com>
Content-Transfer-Encoding: quoted-printable
Date: Thu, 18 Sep 2025 16:12:58 +0000
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Feedback-ID: ::1.ap-northeast-1.TOS0vxEE3Ar6ai29fkp2i/jb+l2iigajCGeLfF7S3sk=:AmazonSES
X-SES-Outgoing: 2025.09.18-23.251.234.57



On 2025/09/18 16:38, Li Nan wrote:
>=20
>=20
> =E5=9C=A8 2025/9/15 11:42,=
 Kenta Akagi =E5=86=99=E9=81=93:
>> raid10_end_read_request lacks a path to=
 retry when a FailFast IO fails.
>> As a result, when Failfast Read IOs =
fail on all rdevs, the upper layer
>> receives EIO, without read =
rescheduled.
>>
>> Looking at the two commits below, it seems only =
raid10_end_read_request
>> lacks the failfast read retry handling, while =
raid1_end_read_request has
>> it. In RAID1, the retry works as expected.
>> * commit 8d3ca83dcf9c ("md/raid10: add failfast handling for reads.")
>> * commit 2e52d449bcec ("md/raid1: add failfast handling for reads.")
>>
>> I don't know why raid10_end_read_request lacks this, but it is probably
>> just a simple oversight.
>=20
> Agreed, these two lines can be removed.

I will revise the commit message.

>=20
> Other than that, LGTM.
>=20
> Reviewed-by: Li Nan <linan122@huawei.com>

Thank you. However, there is a=
 WARNING due to the comment format that needs to be fixed.
I also received a failure email from the RAID CI system.

------------------------------------------------------------------------
patch-v4/v4-0007-md-raid10-fix-failfast-read-error-not-rescheduled.patch
------------------------------------------------------------------------
WARNING: Block comments use a trailing */ on a separate line
#39: FILE: drivers/md/raid10.c:405:
+                * want to retry */

total: 0 errors, 1 warnings, 11 lines checked


I will apply the =
corrections below and resubmit as v5.
Is it okay to add a Reviewed-by tag =
in this case?
Sorry to bother you.

+       } else if (test_bit(FailFast, =
&rdev->flags) &&
+                test_bit(R10BIO_FailFast, =
&r10_bio->state)) {
+               /* This was a fail-fast read so we =
definitely
+                * want to retry
+                */
+               ;

Thanks,
Akagi

>=20
>>
>> This commit will make the =
failfast read bio for the last rdev in raid10
>> retry if it fails.
>>
>> Fixes: 8d3ca83dcf9c ("md/raid10: add failfast handling for reads.")
>> Signed-off-by: Kenta Akagi <k@mgml.me>
>> ---
>> =C2=A0 =
drivers/md/raid10.c | 5 +++++
>> =C2=A0 1 file changed, 5 insertions(+)
>>
>> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
>> index 92cf3047dce6..86c0eacd37cb 100644
>> --- a/drivers/md/raid10.c
>> +++ b/drivers/md/raid10.c
>> @@ -399,6 +399,11 @@ static void =
raid10_end_read_request(struct bio *bio)
>> =C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * wait for the 'master' bio.
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 */
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
set_bit(R10BIO_Uptodate, &r10_bio->state);
>> +=C2=A0=C2=A0=C2=A0 } else if=
 (test_bit(FailFast, &rdev->flags) &&
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 test_bit(R10BIO_FailFast, &r10_bio->state)) {
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* This was a fail-fast read=
 so we definitely
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * =
want to retry */
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 } else if (!raid1_should_handle_error(bio=
)) {
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 uptodate =3D=
 1;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 } else {
>=20
> --=C2=A0
> Thanks,
> Nan
>=20
>=20

