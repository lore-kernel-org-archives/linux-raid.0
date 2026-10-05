Received: from va-2-56.ptr.blmpb.com (va-2-56.ptr.blmpb.com [209.127.231.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 793984A49AC
	for <linux-raid@vger.kernel.org>; Mon,  5 Oct 2026 17:07:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791220075; cv=none; b=MfguRaaezEPiec3R2xAEHwFnTFIr3JBw8TsnrDKB4/qRCkCHnOm6aFT/dVxp9WEZfCdYWuZmSmoWWalISck6M5vrQBXqrDN0ZaKsIQ+S3LL/zCNY0ymGy9G4Ta1szfbxDGMpc/aAP5l6u0aHOFjO9Qmuib8b4zxAS9AODoKFvZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791220075; c=relaxed/simple;
	bh=MiOM2CJvQaT1xi38hh0McjixktHeGysZmHwkVp5OzQE=;
	h=To:From:Message-Id:Mime-Version:In-Reply-To:Cc:Content-Type:
	 Subject:Date:References; b=aAyAC7eLiCrZETbwjIFGts01eTbOylG5s742Vcvxk824dCg45bb6yqc/6z9x+JJ78wPPHyl7yRQwvr2I2K71YC4h6V/JZWNDlCVHSCHzBzNaIq3ikVOifcK/uT+oBTfVvkG0VUb7oaZ0wYB2JrPpBq49RgjB7hB5nq8nnoFJNU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=F6ncyfnN; arc=none smtp.client-ip=209.127.231.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="F6ncyfnN"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1791220059;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=LgSVS5TTs2nLP/n+W0qBGeQcNsx1kv14S/55P2s4U8A=;
 b=F6ncyfnNdsUNVUvtR/mCzeuSpvW7m2pZxKsDjJDCwlcOvNPEYosdiclU69klOLIK+yksvf
 vxZIAqeJldMu226TNMT/Bxor/KvuxZnjfoA4I+e+Chi5PRkLp7+7OBJcY7LIPmq0kh67G4
 lIzatoarxEGpgULEi+VGWXwDH6ZxqG4Aw7HRqWWi21pScFtfqbmVcsvmFQp6IrWIzlwiZQ
 Fu/fYyxXWkRb/HqYLR712OZAWQylk2w8vgLZWvKncxB8RIrGRr9Hg9Gjh64n8tepBGz13y
 s9Vp/yP8ByZqEmyFHH/PCJOWzj2J8GevhFd4RRyhzkZNaNkghMoTaPbqnGNU/w==
X-Lms-Return-Path: <lba+26ac3d95a+ea511a+vger.kernel.org+yukuai@fygo.io>
X-Original-From: yu kuai <yukuai@fygo.io>
Reply-To: yukuai@fygo.io
To: "Jinpu Wang" <jinpu.wang@cloud.ionos.com>, "Song Liu" <song@kernel.org>, 
	"yu kuai" <yukuai@fygo.io>
From: "yu kuai" <yukuai@fygo.io>
Message-Id: <7c13f020-cb10-4420-a5ba-6e0d11050f29@fygo.io>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
In-Reply-To: <CAMGffE=Vz19wLqdECCc3G47oZVRkQ=RuYFzZt8A1m7jxHUeV7A@mail.gmail.com>
Received: from [192.168.1.104] ([39.182.0.177]) by smtp.larksuite.com with ESMTPS; Mon, 05 Oct 2026 17:07:38 +0000
Cc: "Li Nan" <magiclinan@didiglobal.com>, "Xiao Ni" <xiao@kernel.org>, 
	<linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Subject: Re: [PATCH] md: fix mddev_unlock() called without holding lock in lbs_store()
Date: Tue, 6 Oct 2026 01:07:35 +0800
User-Agent: Mozilla Thunderbird
References: <20260920103705.23191-1-jinpu.wang@ionos.com> <CAMGffE=Vz19wLqdECCc3G47oZVRkQ=RuYFzZt8A1m7jxHUeV7A@mail.gmail.com>

Hi,

=E5=9C=A8 2026/10/5 12:57, Jinpu Wang =E5=86=99=E9=81=93:
> On Sun, Sep 20, 2026 at 12:37=E2=80=AFPM Jack Wang <jinpu.wang@ionos.com>=
 wrote:
>> From: Jack Wang <jinpu.wang@cloud.ionos.com>
>>
>> lbs_store() jumped to the unlock label on mddev_lock() failure,
>> calling mddev_unlock() on a mutex that was never acquired. Return
>> directly instead.
>>
>> Fixes: 62ed1b582246 ("md: allow configuring logical block size")
>> Signed-off-by: Jack Wang <jinpu.wang@cloud.ionos.com>
> ping?
>> ---
>>   drivers/md/md.c | 3 +--
>>   1 file changed, 1 insertion(+), 2 deletions(-)
>>
>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>> index 680b34a63cb3..41fbe5d9961a 100644
>> --- a/drivers/md/md.c
>> +++ b/drivers/md/md.c
>> @@ -6048,11 +6048,10 @@ lbs_store(struct mddev *mddev, const char *buf, =
size_t len)
>>
>>          err =3D mddev_lock(mddev);
>>          if (err)
>> -               goto unlock;
>> +               return err;
>>
>>          err =3D mddev_set_logical_block_size(mddev, lbs);
>>
>> -unlock:
>>          mddev_unlock(mddev);
>>          return err ?: len;
>>   }
>> --
>> 2.43.0

Already applied, looks like I forgot to reply to the email.

md: fix mddev_unlock() called without holding lock in lbs_store() -=20
kernel/git/mdraid/linux.git - song's fork of linux.git <https://git.kernel.=
org/pub/scm/linux/kernel/git/mdraid/linux.git/commit/?id=3D68dab5c14aaff176=
86df22ba1f1eea3b3433797a>

>>
--=20
Thanks,
Kuai
