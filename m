Received: from sg-3-45.ptr.tlmpb.com (sg-3-45.ptr.tlmpb.com [101.45.255.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A282823BD06
	for <linux-raid@vger.kernel.org>; Sun,  5 Jul 2026 09:03:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=101.45.255.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783242240; cv=none; b=UX+eGf8A1UZ7Xhh6mvbbTiC/R4LCKsaJ0eCeBW7OUVJfwQ5jWOEbheDqnjJ7WRbIwE0n57ZzKmpYU8tn8YM04GV06+O8hZkwooC/oNqJY5jteb+ysNQ/Nd63S3+LLffzVO8LBoYjlS/ia9B+ACg7EhD6X4R/BdUmoXHM+DmRn4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783242240; c=relaxed/simple;
	bh=oiCIHcIfIQBcWeIqkQZzwMqU/J6rdUbdguQMZIzOZkE=;
	h=Mime-Version:To:From:Date:Message-Id:References:In-Reply-To:Cc:
	 Subject:Content-Type; b=GpYLXkyNJ2yxrpPRDSCHfUqe2VD3+5OeAB4qNzhZK1K2twNyys2A6oJSq5P1cft+utVxvibOc3EGwNjLLhm1Xyfq8di5nfoCDb46w8SJkAzNZFBa0G8Jqws+8ECZaEawdpQclRdbmTkA1ndkdcEYtBQkGwkW/bJyjE+qheYbFW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=IQS0KEKu; arc=none smtp.client-ip=101.45.255.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="IQS0KEKu"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1783242149;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=Qs7Xp3ARZD2S/wj6zbBaxP+K1SYcFlkplP1to+Nse4o=;
 b=IQS0KEKuFD6hH8lAOLP7pnsZul7nmsvEImhjKhVk0nxcQoyaLJlwRPsqZVcpmX6LKw/0J3
 aDY22XhTEy9epvKGAxn/Sv1Ir5jp1JC8sYrscDX3EtY8YBBwtuNuGdnOuSdN0L90RCE4ez
 tTudhsJ2RTbY22NILCSEsCxANM2jmNeVg7+ckWtPLYvmofyCm8UGJ1cPdb3tUIKBN2xZW3
 TNHodvZ12oIe3m7Ue3Fp0yiCfagYbhus9suTsvfZAI9VbOblp01Ee6yTWIhKCKqkMsftwl
 kvX+sG1MIm8DJQdTrqLHS2hPu3UW53zYe8LYJRErD3GF1UbdnsqCY0DT1vsWbw==
X-Original-From: yu kuai <yukuai@fygo.io>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: yukuai@fygo.io
To: "Sajal Gupta" <sajal2005gupta@gmail.com>, <linux-raid@vger.kernel.org>, 
	<song@kernel.org>
From: "yu kuai" <yukuai@fygo.io>
Date: Sun, 5 Jul 2026 17:02:20 +0800
Message-Id: <05907420-cc63-4e1d-b5f8-1fed113434cc@fygo.io>
References: <20260622142146.56637-1-sajal2005gupta@gmail.com>
In-Reply-To: <20260622142146.56637-1-sajal2005gupta@gmail.com>
Received: from [192.168.1.104] ([39.182.0.144]) by smtp.larksuite.com with ESMTPS; Sun, 05 Jul 2026 09:02:28 +0000
Content-Transfer-Encoding: quoted-printable
Cc: <tomasz.majchrzak@intel.com>, <linux-kernel@vger.kernel.org>, 
	<error27@gmail.com>, <skhan@linuxfoundation.org>, 
	<me@brighamcampbell.com>, <linux-kernel-mentees@lists.linux.dev>, 
	<yukuai@fygo.io>
Subject: Re: [PATCH v2] md/raid5-ppl: fix use-after-free in ppl_do_flush()
Content-Type: text/plain; charset=UTF-8
X-Lms-Return-Path: <lba+26a4a1da4+ec69ef+vger.kernel.org+yukuai@fygo.io>

=E5=9C=A8 2026/6/22 22:06, Sajal Gupta =E5=86=99=E9=81=93:

> The loop in ppl_do_flush() continues iterating after calling
> ppl_io_unit_finished(), touching io->pending_flushes and leading to a
> use-after-free.
>
> Add a break statement to stop the loop once io is freed.
>
> Fixes: 1532d9e87e8b ("raid5-ppl: PPL support for disks with write-back ca=
che enabled")
> Reported-by: Dan Carpenter<error27@gmail.com>
> Closes:https://lore.kernel.org/all/ajJF2wKYWRk4GGCK@stanley.mountain/
> Signed-off-by: Sajal Gupta<sajal2005gupta@gmail.com>
> ---
> Compile tested only.
>
> Changes in v2:
>   - drop the refcount_t conversion
>
> v1:https://lore.kernel.org/all/20260622080656.22786-1-sajal2005gupta@gmai=
l.com/
>
>   drivers/md/raid5-ppl.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)

Looks correct.

Reviewed-by: Yu Kuai <yukuai@fygo.io>

--=20
Thanks,
Kuai
