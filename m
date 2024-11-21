Received: from mail.flyingcircus.io (mail.flyingcircus.io [212.122.41.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D28B155330;
	Thu, 21 Nov 2024 12:06:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.122.41.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732190774; cv=none; b=Hw0XJw1H5TEG7oY9bzb9Toetw5H5WIAyeF+FqEqbUFqph63KoG32C8BvS/XWNcbB8qN4+FY5a9vWuWVdthsWLDhQnUN/cNtfPSDTeDCTSV6S7YB+LcD/f9dlazeBdFU1O/BQoqPSdN2Ons6T4tRPoz8ETnfdpM+HSV89VsbIItA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732190774; c=relaxed/simple;
	bh=d5xuqQUSGEDUXrjk5NlMoo/YnLL4yHpmgTs8I84to6I=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=PvvqUKbdRcVDeTIRZ295p2nhA69zjAHaUmww7LzBpSl2b0oJRP9t7Jw0qP5GQBZrsG7Jkc97T5lzh385XUgRk/VMDdfEr7hS36Amt+V+UA108VzJmz7fyP0I/+EMdOLxYYvH10t6agqxkWfeykGgDLZ/KE61Tj65Ec+i0u8vus0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=flyingcircus.io; spf=pass smtp.mailfrom=flyingcircus.io; dkim=pass (1024-bit key) header.d=flyingcircus.io header.i=@flyingcircus.io header.b=d19bgBZK; arc=none smtp.client-ip=212.122.41.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=flyingcircus.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flyingcircus.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=flyingcircus.io header.i=@flyingcircus.io header.b="d19bgBZK"
Content-Type: text/plain;
	charset=utf-8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flyingcircus.io;
	s=mail; t=1732190766;
	bh=d5xuqQUSGEDUXrjk5NlMoo/YnLL4yHpmgTs8I84to6I=;
	h=Subject:From:In-Reply-To:Date:Cc:References:To;
	b=d19bgBZKaOCivlFjpgvuxjVyzT+kIZ2T7/VaOMAFUyyHFJvWs1zYsX1fgYojbv+si
	 X3kaxKJWjdFKDutnpXg9OqKgc0DuxBCHGki68qnCrP7lxWCwI0R/ym7BLxMjX7E40U
	 cy3L186GK8VR9+3eY1mSCQEe81qCtRsrkTvQ/qeU=
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.200.121\))
Subject: Re: [PATCH md-6.13 4/5] md/raid5: implement pers->bitmap_sector()
From: Christian Theune <ct@flyingcircus.io>
In-Reply-To: <6434853a-4df4-d3c4-14b9-a0d4ad599602@huaweicloud.com>
Date: Thu, 21 Nov 2024 13:05:45 +0100
Cc: Jinpu Wang <jinpu.wang@ionos.com>,
 Haris Iqbal <haris.iqbal@ionos.com>,
 linux-kernel@vger.kernel.org,
 linux-raid@vger.kernel.org,
 song@kernel.org,
 xni@redhat.com,
 yangerkun@huawei.com,
 yi.zhang@huawei.com,
 =?utf-8?Q?Florian-Ewald_M=C3=BCller?= <florian-ewald.mueller@ionos.com>,
 "yukuai (C)" <yukuai3@huawei.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <828B989D-9683-4B03-B95A-C7390ABDB9A5@flyingcircus.io>
References: <adf796b9-2443-d29a-f4ac-fb9b8a657f93@huaweicloud.com>
 <20241119152939.158819-1-jinpu.wang@ionos.com>
 <CAMGffEkODwo19u0EjKojQ0WaWVkvOOB8aRR8R3NXn+oC6TFQWQ@mail.gmail.com>
 <d456368e-cff5-5476-238e-4cc97f016cfa@huaweicloud.com>
 <DFAA8E00-E2CD-4BD0-99E5-FD879A6B2057@flyingcircus.io>
 <6434853a-4df4-d3c4-14b9-a0d4ad599602@huaweicloud.com>
To: Yu Kuai <yukuai1@huaweicloud.com>

Hi,

ok, good thing I asked, then =E2=80=A6 :)

I=E2=80=99ll try this out later today.

Christian

> On 21. Nov 2024, at 12:01, Yu Kuai <yukuai1@huaweicloud.com> wrote:
>=20
> Hi,
>=20
> =E5=9C=A8 2024/11/21 17:30, Christian Theune =E5=86=99=E9=81=93:
>> Hi,
>>> On 21. Nov 2024, at 09:33, Yu Kuai <yukuai1@huaweicloud.com> wrote:
>>>=20
>>> Hi,
>>>=20
>>> =E5=9C=A8 2024/11/21 16:10, Jinpu Wang =E5=86=99=E9=81=93:
>>>> On Tue, Nov 19, 2024 at 4:29=E2=80=AFPM Jack Wang =
<jinpu.wang@ionos.com> wrote:
>>>>>=20
>>>>> Hi Kuai,
>>>>>=20
>>>>> We will test on our side and report back.
>>>> Hi Kuai,
>>>> Haris tested the new patchset, and it works fine.
>>>> Thanks for the work.
>>>=20
>>> Thanks for the test! And just to be sure, the BUG_ON() problem in =
the
>>> other thread is not triggered as well, right?
>>>=20
>>> +CC Christian
>>>=20
>>> Are you able to test this set for lastest kernel?
>> I have scheduled testing for later today. My current plan was to try =
Xiao Ni=E2=80=99s fix on 6.6 as that did fix it on 6.11 for me.
>> Which way forward makes more sense now? Are those two patches =
independent or amalgamated or might they be stepping on each others=E2=80=99=
 toes?
>=20
> Our plan is to apply this set to latest kernel first, and then =
backport
> this to older kernel. Xiao's fix will not be considered. :(
>=20
> Thanks,
> Kuai
>=20
>> Christian


Liebe Gr=C3=BC=C3=9Fe,
Christian Theune

--=20
Christian Theune =C2=B7 ct@flyingcircus.io =C2=B7 +49 345 219401 0
Flying Circus Internet Operations GmbH =C2=B7 https://flyingcircus.io
Leipziger Str. 70/71 =C2=B7 06108 Halle (Saale) =C2=B7 Deutschland
HR Stendal HRB 21169 =C2=B7 Gesch=C3=A4ftsf=C3=BChrer: Christian Theune, =
Christian Zagrodnick

