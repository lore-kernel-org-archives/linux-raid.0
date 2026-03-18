Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96DDB361DBC
	for <linux-raid@vger.kernel.org>; Wed, 18 Mar 2026 09:35:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773826516; cv=none; b=k/jbcwsYClt83BYKhs94A9ZnKkfQ/3uSRQjWTLCmw6pIN4+kA3VK8ysPQrXUOPCxu1FqLh1h5WSqo7X+M6WAhkpEUdKOGbL4a8qKpFPECLWw1iuunzQj3374/bB1iJj+q7Kej8vMl1HeTrU21ei1w0U+EP2pzau+lMHul5n9nQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773826516; c=relaxed/simple;
	bh=5lBw0awjkCKtkYKO6JwDwmPYcjBmC7eHJCS1mYm9zeo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Wsu7NyvTZmjg+ud4pIioGREIIj8/GneCBzxEPYtkiSwL/ipbuMsvGPQD2IFEdQfNC4mNKErfjoXsosszKTQrgY2T7B2pMRnM/kQBLkwwFguU5zdacgOdWszDoC5tsL4XBO87R4DMMXvLltjh1lOm3m/ZTNhrYZr+thkym3plFvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=F2KWK52m; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="F2KWK52m"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-43b3a5973e7so189303f8f.0
        for <linux-raid@vger.kernel.org>; Wed, 18 Mar 2026 02:35:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773826509; x=1774431309; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4IxVQ0jkQVE4Nc1dS9I649gcZRc0rpB1JsvB57OS5xU=;
        b=F2KWK52mZe0g50Yq6RlS8DU56sVpCGF5n26nSF1g6Te0L/Y//UUOK+TPA02KN2teUo
         SW7AtWqK3aGEmxGFRwzf3dXYxpUc4yHCGCqnT2yed7B2ko/2NLWwAKw/mySGrkUCIy3R
         ezUrhB/VzyBibx89IFBnJP/0OVhjwwejujj5UAHjVdkxlLVnlW+QrPf77zdlSh5Us3WH
         r1ccuZgX7OPVBTsD6mR0lXyAQFtquwn1AlKLVMiMZdWzGxmIpsL2csEGFTNVa/9ClzEf
         tQ9pW9Bze/NuBrlo9rgMJwmDQ4iyDAkB1ExNRDSRsti7ebMRfFTl2YgfcSvTAfgIyEst
         lgDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773826509; x=1774431309;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4IxVQ0jkQVE4Nc1dS9I649gcZRc0rpB1JsvB57OS5xU=;
        b=a3F6tqEcbQvnK4suhKmHUGw+WywuS5uyavjZWwbSmF1kxVoC5oMozmbcEMj5aqjs4C
         32p6Y1vGk/PC5WRUBUK0rR8amsmVjJ1Xg2e+jQsRawda1yQtE+RJiy7jVTrYbbVEVbTG
         2QM8lEf8D5cHt4I+uSkWjt/BHPBs651T8hs/hmR4RL6h4Xddvv05TWAzLJ4ZNV7Ey48P
         V1aeRvI/waDN92qBk9eQo8NF1AE477pIrYAQDsDCJQn0JRdD4soALfdxbyOBw82oVNEr
         9B5tRyNOfvYEoz4c7CUjeDyu+arOtQRlFOFwtRDTXKTLjxxZz4h/nmvxtl1X7Yfaqhuy
         ua8w==
X-Forwarded-Encrypted: i=1; AJvYcCXhcLL4CmXQ41qHt6zm6x+4ZnBMr37UWSq2nJAYI7QqE41ZYzmzpT5eyozudRoGXiE5OwjmjKdwzr9k@vger.kernel.org
X-Gm-Message-State: AOJu0YyMe+C3AWQb+pqyAOGQ81yNmZlgAyX3RBsqLJemC00szz7kPHKo
	SokFkFT7C9T5I8pIl9FTbg46bnZ39h0semQ6TKeWZ1OH+0HBNHwhz4U=
X-Gm-Gg: ATEYQzwcxjHQ2nvOZ38s5byJm27d5kE5M4+bW9HQVYqp83Nn9QD7N8ChlLolB2JCC/o
	2sMeQTInir0tKOG9gaBUv3KTXllwrKxYRnR6Mv2bKSnb0WEMNBaL2Xbah15FTM8NCP9/LCscUCW
	N77UEJmprG2K5fUwFOKYUKU3NshvWxs5kbz1egkgRNNqP/ytyE6qUxZ/Auy20Gl2oUDmDfOz3Ky
	cnpUuUEVPqiVKsDALXYbBVozarC4AXslBw1E2xL4IdSFN4UTNZAT/k3RigaOSUZMbiiWv05KOky
	x7V86dRRPaYciFIdTm320Z9Jt7i7Asd6+ioOhFF/mQ785ySle3bC39zpdgk0W35lf2XZiEB33eZ
	ZeNZEvg7uiGIBsKLoVqKeHlA09m/3VhrWeuIZG5xE579i9my27Gsh7o1X18Y4Wjh3Q3R0EPGkPq
	EWVggQy+PST8miDVPMgkp9X+sHkOqA0r/ZFB2bmXk1KNmqQjIMVF5J8Nu2ngzjMEDQ9fw=
X-Received: by 2002:a05:600c:314c:b0:47b:d992:601e with SMTP id 5b1f17b1804b1-486f442f9e4mr30968715e9.2.1773826509082;
        Wed, 18 Mar 2026 02:35:09 -0700 (PDT)
Received: from localhost (171.red-80-39-136.dynamicip.rima-tde.net. [80.39.136.171])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-486f4434dcasm49931085e9.13.2026.03.18.02.35.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Mar 2026 02:35:08 -0700 (PDT)
Message-ID: <ebafe7e7-4166-4c1b-92b0-378db8f79ebf@gmail.com>
Date: Wed, 18 Mar 2026 10:35:07 +0100
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: Release mdadm-4.6
To: Xiao Ni <xni@redhat.com>, linux-raid <linux-raid@vger.kernel.org>
Cc: Song Liu <song@kernel.org>, Yu Kuai <yukuai@fnnas.com>,
 Nigel Croxon <ncroxon@redhat.com>, Mariusz Tkaczyk <mtkaczyk@kernel.org>,
 Martin Wilck <martin.wilck@suse.com>
References: <CALTww2_2pjjOSsVj-WT++m35555CjnPWokU7fut+HwUJVV-=ZQ@mail.gmail.com>
Content-Language: en-US, en-GB, es-ES
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
In-Reply-To: <CALTww2_2pjjOSsVj-WT++m35555CjnPWokU7fut+HwUJVV-=ZQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/16/26 4:45 PM, Xiao Ni wrote:

> I'm glad to announce mdadm-4.5. It is published to both remotes
> (github and kernel.org). Here are some highlights from CHANGELOG.md.
> 
> # Release [mdadm-4.6](https://git.kernel.org/pub/scm/utils/mdadm/mdadm.git/log/?h=mdadm-4.6)
Could you please upload the corresponding tarball to the official
kernel.org dir ( https://kernel.org/pub/linux/utils/raid/mdadm/ ) ?

Thanks.
