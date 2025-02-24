Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0389EEEDE
	for <linux-raid@vger.kernel.org>; Mon, 24 Feb 2025 12:45:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740401137; cv=none; b=Wmk1jrxMkJ53OUVeChbop0omNYq7lvp7dfNuyeo+N7d9yXgyy1MklFnqlTx+boohwq9yNuN0Hk9o1btw14xGsu+T1fMfvAU+doGP24tmFzzWtSOrnZNwQuIUx4L+KLJFZdHfhR4y1TMju3M5OWvb7r+AZ8c3DNcNsAT0BcEuaUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740401137; c=relaxed/simple;
	bh=EyHZ2f2TEWbve6X60CmmzYcGBlevFPghbGb3A0XHqc0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cwszxfB4+OGh3Wh7PqC54CqqNqgG9k7IL+mitva2g5BRs9ENaNmHZ1I8kN4KKMLJ8POuOSVlgG3Iu9ypSURA+0Y+D3hvDbS+X/5Vc94K9oj1XgnyRfYXJFVgtJ+whs2sukKD5rLLLx/Rs0MvrasAeSQbIj0RxJblfZfsK4kaCEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ff+fkkLL; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ff+fkkLL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740401134;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cwtHxtFfHlyUlsUsonppNmaDKXavsxCtHNJ3pzBu/yU=;
	b=ff+fkkLLXAKRGKF/iwn8rKSzLLi7tKUNZ93JiEmsuZXXxeMCHzlO4+oc+Kd8hUUhTNLotW
	V0w7Q/PSl5BTXBlcae9EvsFu9FPftxXsA58yIxt0qUvh3w95gIylwVGxEnvrp0JXoVVDrX
	3fUCjDvG3Z1LWMR9BRNj4FUDW2FNe7c=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-631-oh_B-ultMvOaz56vSdFmVw-1; Mon, 24 Feb 2025 07:45:33 -0500
X-MC-Unique: oh_B-ultMvOaz56vSdFmVw-1
X-Mimecast-MFC-AGG-ID: oh_B-ultMvOaz56vSdFmVw_1740401132
Received: by mail-lj1-f200.google.com with SMTP id 38308e7fff4ca-307303a4c7bso24852941fa.1
        for <linux-raid@vger.kernel.org>; Mon, 24 Feb 2025 04:45:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740401131; x=1741005931;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cwtHxtFfHlyUlsUsonppNmaDKXavsxCtHNJ3pzBu/yU=;
        b=Olhy/jODRNqHZGi/oUczVmFcqfBeZ9SS/tPV7kbJBCCprTzENZn5NOZOX+xAjeL89C
         8LiH248Hbk1aJhlgDhXxefOZa4fY1K99yMX/zVsw4dY3PHyjGKQyNLPLoXC+eDW0webh
         oXgw7oKBdfvFSjNrEEUHdqPbM57LXMiLjohq5jzbQ6IVCKi5Dq8/fpYt2Cy7gexoEbt+
         RgzmKMhk292OFeCDXjD8QiK31Sbgt1lfMjCfTVwSp+TKOKLLnA4T8vfhcJhVpc2QaosT
         myePKV8IGXDOKW1ZMUT9zPYlujfeyglRsPfc85LrRFAfPWRB1jQxaE8Yn+ER3uxMHrbW
         d7TQ==
X-Forwarded-Encrypted: i=1; AJvYcCVO7NakQvmX4uKx5dLbWYghl5B493DKVSYgKSwX7la94R6mnleEMIZcjgzbIX4IlvESkgMXROvRVKEl@vger.kernel.org
X-Gm-Message-State: AOJu0YyraswNIz61aW29vIV0ohhjJ81IMz9niFdSCTvRtceS6biSNvx4
	q1jcbUJvNeh/J/diEOP0LOiYh8uwrXxxX18drlz7Xdv9tCi/cwvCxflgDZkTSPxFssVhNww9kXl
	IGub9bJv6CUdY7MogsNb56zPw4q6M5+INQZ+FY3YpeZJTp9X2ZFDw3GyqyMiLUyefSaoIRQEeF1
	LVA2u6faSAS6Zy1Knod6L8sRjfX9YVfHQMnw==
X-Gm-Gg: ASbGncs4O7RL0bLe3AvyQQgkvlLQppJ9w/xlUPw+rPOUB9QqnYQIYfUV/qYAR+DiP26
	W7UwyntD/R9C6rMwiy3DSxh+0LEZEh7ponKBYBbxZ5OYEc80tY1m7gPPFc13srdiuUOw7pucUeA
	==
X-Received: by 2002:a2e:9594:0:b0:2fa:cdd1:4f16 with SMTP id 38308e7fff4ca-30a5989003dmr37135051fa.14.1740401131553;
        Mon, 24 Feb 2025 04:45:31 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGxjjWtZWC5PT34VZXw3OHqN3nKTQYuiBblyRoXNoyZDKcmkatEHViIbywu4oYEB6kXy/+mqhSEKKcdckRFBZg=
X-Received: by 2002:a2e:9594:0:b0:2fa:cdd1:4f16 with SMTP id
 38308e7fff4ca-30a5989003dmr37135011fa.14.1740401131127; Mon, 24 Feb 2025
 04:45:31 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CALTww2_0LcdYFdPftJAi3MA_qqeMOWPYpBx0j4Nuw_woazMvrw@mail.gmail.com>
 <ef218c71-96ba-4178-8773-6c12ba0e5175@app.fastmail.com>
In-Reply-To: <ef218c71-96ba-4178-8773-6c12ba0e5175@app.fastmail.com>
From: Xiao Ni <xni@redhat.com>
Date: Mon, 24 Feb 2025 20:45:19 +0800
X-Gm-Features: AWEUYZnEvbyMpzzBY5ONW8TEnrXrAqGpBcMIXq7Tkh1nnpv6XlUgLwp_8SbI7f0
Message-ID: <CALTww2_KVDjXfX9vQDj1a_iyDHeLYx+oGHv6uy+O3rMBwQxmXg@mail.gmail.com>
Subject: Re: Failed to connect to control socket
To: Mariusz <mtkaczyk@fastmail.com>
Cc: Mariusz Tkaczyk <mtkaczyk@kernel.org>, Blazej Kucman <blazej.kucman@intel.com>, 
	linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Mariusz

Cool. Thanks for reminding me. The test can run successfully.

Regards
Xiao

On Mon, Feb 24, 2025 at 8:35=E2=80=AFPM Mariusz <mtkaczyk@fastmail.com> wro=
te:
>
> Hi Xiao,
> Please try to set systemd env variables for IMSM. I remember that I descr=
ibed it to you once. Please check "test" file for particular variables to s=
et.
>
> Thanks,
> Mariusz
>
> On Mon, Feb 24, 2025, at 1:24 PM, Xiao Ni wrote:
>
> Hi all
>
> I'm trying to fix ddf test errors which we see recently. But I see
> this error: "Failed to connect to control socket". I tried with an
> imsm array with loop devices and the imsm array also has this problem.
> (Note, this problem doesn't appear with real devices which system
> supports imsm)
>
> mdadm -CR /dev/md/imsm -e imsm -n 4 /dev/loop8 /dev/loop9 /dev/loop10
> /dev/loop11
> mdadm -CR /dev/md/vol1 -n 4 -l 10 /dev/loop8 /dev/loop9 /dev/loop10
> /dev/loop11 -z 10000
> mdadm: Creating array inside imsm container /dev/md127
> mdadm: array /dev/md/vol1 started.
> mdadm: Failed to connect to control socket.
>
> [root@ ~]# systemctl status mdmon@md127.service
> =C3=97 mdmon@md127.service - MD Metadata Monitor on md127
>      Loaded: loaded (/usr/lib/systemd/system/mdmon@.service; static)
>      Active: failed (Result: exit-code) since Mon 2025-02-24 05:43:07
> EST; 14s ago
> Feb 24 05:43:07 storageqe-59.rhts.eng.pek2.redhat.com systemd[1]:
> Started MD Metadata Monitor on md127.
> Feb 24 05:43:07 storageqe-59.rhts.eng.pek2.redhat.com mdmon[47066]:
> mdmon: Cannot load metadata for md127
>
> I used latest mdadm and 6.14.0-rc3+
>
> Best Regards
> Xiao
>
>

