Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6972C149DF8
	for <linux-raid@vger.kernel.org>; Tue, 25 Jun 2024 22:18:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719353916; cv=none; b=oezZrvsxFd0JdtELcQWjxDuK1kx+PEgboWp0wspG1ART6rzFpdx8TyklLwm3KBAQaFVHkGQsA85+vieuj45lds32Flqz36eGu8D1Trm1ceW4SeAVwjnVxm2erLIrJh78MNQ+MY94Nc44eRbkOppTCPH0QlFZnC9eZjv1eonAxcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719353916; c=relaxed/simple;
	bh=mtx1tRLMxsYmoJQzghadeu+RJH3Jm7ZM0fpctZYqRQo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=Vds3cg4Z0PxZKmAwDbZvdKbLmD0LnOQX7k9ndhuckx7WXcZrlry6/Z+jXzypGKdcYpzo0JdWQstenAcS6b2DDiW99//Dp+KiPJItSp/p+7ZWnAORV2Blm40W2PEDz/Jqp+VUUUI4YrislEnJk1k512DTbFm35lR4d1o6G37PgjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FsGWy04d; arc=none smtp.client-ip=209.85.222.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FsGWy04d"
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-795569eedcaso317148985a.3
        for <linux-raid@vger.kernel.org>; Tue, 25 Jun 2024 15:18:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1719353914; x=1719958714; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mtx1tRLMxsYmoJQzghadeu+RJH3Jm7ZM0fpctZYqRQo=;
        b=FsGWy04d0E9gvmrJAitadjdBMdMmsOWjeM+VEd2gJo+d3T99opvERQI3gHuIbybo8I
         H9zvup0gLnbY/qwX4023lK5LQk40yRL5NENIDllTd0rLlF0Ov1xafZz5IDvc2eKzooE/
         KyLmeADa8RT6NHM43+LCIrZxOXrnB1mpMrw2N7UkRa5KsCdINtVLKLhIuk57t5CtJghu
         zz9Dh0/z/L53Trn+7m/aViA9VNGZMlEoGClltzu5j7D8cHEAXgoHVqinjFmjKvIqZVd8
         gnIg2yNh51hPSFHeVJcCq0QmsawjS0VkVxycTB0it+3xlFZ1zQlvjMmvLHOsVBw9POc+
         +TUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719353914; x=1719958714;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mtx1tRLMxsYmoJQzghadeu+RJH3Jm7ZM0fpctZYqRQo=;
        b=wqWGwRknfxfBBUWJA4usekLHaQ0AMKVMspgd4TaPjNQeTYd55f89/yeHaHPkqudkWj
         JPtV97Tyfho4JyxGP3yflhAqhDXJgc+XR9sFwu41jB2AtmvNRHLz/lxDcdpPIQQdTu/M
         fovZj1T3eMlqbojMwkpGXOxhp/6vADDBZOAr3MUNfbjQ8yu5X8ziCWm/yn2kZfPWDGXa
         2rHthZMjfBGMz5h3USljDWW+g28Hqlbv7YN+7nVmmGNdy1ncoyjp+w+4rH+4J89fnoTk
         PgW8Ff5bZe+CjP5KD2Ha3HHO6kaEi8uzpn8Eyg+/shzdZzAxoswdms8TmmKDBN8tmDj/
         0yEg==
X-Gm-Message-State: AOJu0Yw7jmURKXBljA8MTQm8ZNYftH0S6B+4TOmIMQvM+JCSZJb1500z
	eFMuA0dT5Y+4xxMVGpViFUZvJ9v0cS1wv8iu0V8JpmmFVuA/aQr3OKgfLjZBc9bGgAGBRYXNrW5
	iwT/rFAqdF/c36qfztzsg/CyHfDYm82jj
X-Google-Smtp-Source: AGHT+IGYwLNLnBWjrjftV6/NuRHsb4Hqjt/gFCE4M8TBbY/tGx+G+qsJZyrhhCSI/5CLyM/t5WzzQ8b0ov1Z5JaEt5c=
X-Received: by 2002:ad4:5fcf:0:b0:6b5:46ad:b92c with SMTP id
 6a1803df08f44-6b546adbb20mr110297266d6.1.1719353914248; Tue, 25 Jun 2024
 15:18:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CALc6PW4A6Q4q3tU7AMA3MArpiRwkTwXrb__2k2Xwzy3=-XE+7A@mail.gmail.com>
In-Reply-To: <CALc6PW4A6Q4q3tU7AMA3MArpiRwkTwXrb__2k2Xwzy3=-XE+7A@mail.gmail.com>
From: William Morgan <therealbrewer@gmail.com>
Date: Tue, 25 Jun 2024 17:18:23 -0500
Message-ID: <CALc6PW7eUNDDT0+iD7b=ZK5PJX0D0XoStubLYmdW3SsbGBLZdA@mail.gmail.com>
Subject: Re: reshape seems to have gotten stuck
To: linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Additional info:

bill@bill-desk:~$ sudo cat /proc/242508/stack
[<0>] wait_barrier.part.0+0x180/0x1e0 [raid10]
[<0>] wait_barrier+0x70/0xc0 [raid10]
[<0>] raid10_sync_request+0x177e/0x19e3 [raid10]
[<0>] md_do_sync+0xa36/0x1390
[<0>] md_thread+0xa5/0x1a0
[<0>] kthread+0xe4/0x110
[<0>] ret_from_fork+0x47/0x70
[<0>] ret_from_fork_asm+0x1a/0x30
