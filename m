Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=173.255.221.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794095425;
	b=xewSkk1O51hxAp8Ybafof82rdhb/gjZqdvKEdZe0dMLxgXXOZ6cq95/h9IT0VF1ug2Jq
	 tJixHlZietZLXE1X7VKGPLc8Cq3klXast/F8YRW549upO+XVAHuURxrjRaPCy8zchPsm7
	 TwKTx+iDZuYHQKHgrQLkqm4ZIqeLtl/yAfFiqhX+8BF1R8aU3FSfVeOmhHFBxiVx0MC4n
	 AFqPXcFy1BRVDX+9+fpQq3gfPVlECVrg4h2DornAObdqpyBeL8fDUe1mCKY0VfcaO7ZFu
	 SqgnH6OysMHYfFrmx5t1hpfNtcKMgSvsS2FTjF1saAV8hoSFQXYpBKOXzximy+YYUEA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794095425;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DomainKey-Signature:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=9unHA2/MqQEFuz0/HSeryTQ1+ySaeT8/sRvi8FKrluY=;
	b=0syLD8ODrpP9nMPt3pyJFyoOYx5VVMS7RIeHTgFpPR17L2qy4BRBJFs8uFNwsi8+sEaU
	 M06MFpD/DUscve86y+qGgFzFixBAy382aaSFaHlgb/+KK5pcy5/4H4f7VS/dqekMz9J2m
	 Y7/1SEJuuvEtaKAxeeVuEi4ay+aZ+kXbf3JEr6++yw+y7dVtA3r4pM/vgJAqEyoh+e/jJ
	 SBnbVRux4QvbCrXi0sCxkurWekDMrT+XJnUZF80XbYajXFnvBbehVfNPTYSCqSm1PQ6du
	 OEOGK9IfqZq8bXuls5aYwu09yYc4EGCBVbcSDdGuifwzy47RHuUwLXA+WTjkYNgYzTg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=fatooh.org;
	spf=pass smtp.mailfrom=fatooh.org;
	dkim=pass header.d=fatooh.org header.i=@fatooh.org header.a=rsa-sha1 header.s=dkim header.b=TUCINPnu;
	arc=none smtp.remote-ip=173.255.221.30
Received: from juniper.fatooh.org (juniper.fatooh.org [173.255.221.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86042606A326;
	Sat,  7 Nov 2026 23:50:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 86042606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fatooh.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fatooh.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=fatooh.org header.i=@fatooh.org header.a=rsa-sha1 header.s=dkim header.b=TUCINPnu
Received: from juniper.fatooh.org (juniper.fatooh.org [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by juniper.fatooh.org (Postfix) with ESMTPS id 5A70C40176;
	Sat, 07 Nov 2026 15:50:16 -0800 (PST)
Received: from juniper.fatooh.org (juniper.fatooh.org [127.0.0.1])
	by juniper.fatooh.org (Postfix) with ESMTP id 30B2F402D9;
	Sat, 07 Nov 2026 15:50:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha1; c=simple; d=fatooh.org; h=message-id
	:date:mime-version:subject:to:cc:references:from:in-reply-to
	:content-type:content-transfer-encoding; s=dkim; bh=8QSzpKnyiTCW
	fiiUawTqB2loh6M=; b=TUCINPnurA5YA80/lsvEM6E+gTaRxCR8bSwjm8sj0Q8w
	Q9hZJQz1d54ObYVxguTF9l7zX7uJIk46i3v516jcLLJlmHX7fJ+UoQpY289FSF8d
	zh/dbPH3Bywgs0WSiZF9iHHjsvc+/odmLlgBPhSOSLhszEsUSuWoYHpo7H0kqZM=
DomainKey-Signature: a=rsa-sha1; c=simple; d=fatooh.org; h=message-id
	:date:mime-version:subject:to:cc:references:from:in-reply-to
	:content-type:content-transfer-encoding; q=dns; s=dkim; b=XPDeHc
	pXV6nixzCCiYMPcbBwJ1R5rApiDmK8v6DtcVkzxatNfzEVIUkTF4iyNe/8DKqaLz
	kwyztbbsssIaqyx1T65RZitLmtF6gDJELIl1DJF/Rom3a1/B+1uhq2VXXF8CO1yL
	gyohJ0TrFfLAG/g3jILDroPZdHW2My3e+DxbY=
Received: from [198.18.0.3] (unknown [104.184.153.121])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by juniper.fatooh.org (Postfix) with ESMTPSA id 1978A40176;
	Sat, 07 Nov 2026 15:50:16 -0800 (PST)
Message-ID: <b1065a1a-1559-4719-bd2f-7967b84be587@fatooh.org>
Date: Sat, 7 Nov 2026 15:50:15 -0800
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Post: <mailto:linux-raid@vger.kernel.org>
List-Help: <mailto:linux-raid+help@vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-raid+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] md: dont warn about sb update on auto read only arrays
To: incharilla@incharilla.site, Song Liu <song@kernel.org>,
 Yu Kuai <yukuai@fygo.io>, Li Nan <magiclinan@didiglobal.com>,
 Xiao Ni <xiao@kernel.org>
Cc: Yu Kuai <yukuai@fnnas.com>, linux-raid@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20261106-md-auto-read-only-sb-warn-v1-1-5bfde3559841@incharilla.site>
Content-Language: en-US
From: Corey Hickey <bugfood-c@fatooh.org>
In-Reply-To: <20261106-md-auto-read-only-sb-warn-v1-1-5bfde3559841@incharilla.site>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2026-11-06 10:20, incharilla via B4 Relay wrote:
> Skip the message for MD_AUTO_READ the same way dm raid is already skipped.
> It is still printed for arrays that are really read only.

Thank you. I tested this on Linus's tree and checked messages upon bootup.


With a41e364995bbcfa627418a70fe913c35b7510728 (unpatched):

$ sudo dmesg | grep 'read-only array'
[    1.589087] md_update_sb: can't update sb for read-only array md2
[    1.758035] md_update_sb: can't update sb for read-only array md1
[    1.773313] md_update_sb: can't update sb for read-only array md0
[    1.885346] md_update_sb: can't update sb for read-only array md3


With your patch on top:

$ sudo dmesg | grep 'read-only array'

(no messages)


I also was no longer able to reproduce the message when creating a 
degraded RAID-1 array.

This seems good to me.

Tested-by: Corey Hickey <bugfood-c@fatooh.org>

Thanks,
Corey
