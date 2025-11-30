Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B9821B0437
	for <linux-raid@vger.kernel.org>; Sun, 30 Nov 2025 00:57:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764464259; cv=none; b=SK1eiRgm8JE6p9TgekH4DSOSybdaY0ph3DZwpHmNfqwrDrillqp9qRRd2NR9pgRZmPmY3jQCyPishgiVcx6S+/TuaEEM45YODaS/Q9mPfdHdbfwhr/p+hff2pNVr3TnwIj/vdiXTHUaiMyB4lguD1Y3WEfySCtqsziiR9Cws6MM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764464259; c=relaxed/simple;
	bh=k6FYX/RC2meRZKmLL/rdujICr6cSnEexoqs5r2vGL4g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gPCrw9G9/hBd32+47durweFKh+gPtN0eqaQ8jZ6c5LoAlUUGzZaO27cQK0yjWxZrFH5Mp4hrRMj7ubaCQbLLN+kRGTfLxvIs9I7rWcrSChj0XHhyI15ehMn9yWSk95g/ecMdgbA1jlGhSIi3MQWDqBCalUVtTTUmRBzWk5TMAc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=a16u6zen; arc=none smtp.client-ip=209.85.167.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="a16u6zen"
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-5957ac0efc2so3262525e87.1
        for <linux-raid@vger.kernel.org>; Sat, 29 Nov 2025 16:57:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764464255; x=1765069055; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+g49Om8KV5+AE4pKbmfS5SsSZ6jAm9G/Fr+ete77Gs0=;
        b=a16u6zenbhA1R3HmfSHImbulDJf6qYZKuG8bfBXSkn8wqzvkPR8nGf0wYEWZWJsNNO
         9H759adf6+ptPxWNMZGO+zLUkHqaTlQMM+WXeCoxI2cgxZI3hg48ncL26T3NE+eYenm8
         ABWh5VH0G0O4YM7itDh2cPCoJjLKylaFhrVKkOHfCGTX0r0ObA+nwxWKONoxIuWdpi7y
         yhJRNvWw/Vi6oxuo5zehNdEhQH4ry37dTGvM9maDSi29mqEb/NBtwmeJQNsDx9zmxTBU
         eyB/M3usaPYNar2ACuJRiUnNnBZZIt4w51XlRTJG1s9+8IbxCzZRA1Pd+7QUOSnOZCLi
         eQGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764464255; x=1765069055;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+g49Om8KV5+AE4pKbmfS5SsSZ6jAm9G/Fr+ete77Gs0=;
        b=Vv2g7oZ+Mn5vd40XQZfHQCgWPf+ZFdQPbsXisaVr8YQ47wzOxtKGGsn6BLE8yXyFP+
         zJDvj4eBllEA8UeAYpJUt9/KQBPlIM3B9KJjEZV9hXORCsEQDkcnqlMyVQvVBbF+LUL4
         V+Ok0pwEQ0D60FTCuQYCKMMjRyQ76A95hAvSaYN6/+f4cBj+lSejd8I54SgegcZZNp6H
         Lp7p4NCCCmlq8DTQ18gUOTQ0mJB+t78lVk9NkH9CxPGsew5LDW3xtEZ6RKOuatsX1Oti
         fDMWWJnf5C1kTFNQ96QwR+XxpWYw3u92YyjgprEbGh46xJ9X97pMdauFahXo63rtitNT
         wJWg==
X-Forwarded-Encrypted: i=1; AJvYcCUwHb4A10y8XNFyfEFILIdU0r9bMt7+qNrnz/i59Zan/2MdRJJrofqah8+DrWjNmSxCxwuV8h4QPJOj@vger.kernel.org
X-Gm-Message-State: AOJu0YwiOHs9huYBGWsn4utfAflK2qFfS0On8xYOPFsq6Qp94eAyUgX8
	fiAx5QeMTiG9uysR36rlar6hLLRqWVWLJur3/ld+B20CrL0OF7GvdU0g
X-Gm-Gg: ASbGncv+K/eejNxTUKYlEru3Sqs9Z8sVbKnesMFdJgbiKvGPu477D95Zbqs25PG5AA4
	gkInt8Yg0O6loLyFxF9a04rU8aFNDlY80uyZoMDavuJdLmQuz1ans6WP56yMJljLE2o2yh5SKDe
	PBzdiytWJK3UnYe0lQ+getvCmsXgP9HOqMoJoa1FqkrB8yJu90+EeAH+1nUZCXQ5rkDNfh+zwRH
	scZnHvPzKLH2bTv83gSISuxgBtpjJiJOu6MVAeR6EsIHIPzwEKQ2r6xdgtYcsH7KUJ61p80lZUK
	aGcyqKt70GFf7J0TLNV2+XTR32VHAmM5CMhPZ/2fx83s3q50mZVQJZOkhGHwXvs4yYm1C3ijOxg
	GcbCHQ/pY7D3h70C0HQ8CNhdqyGj5hMMdN353cq+Wz/uLz8VhDq1Ci8UeRoFRw2ujmS7KBinMH1
	XCVRzA7Cw=
X-Google-Smtp-Source: AGHT+IHqqLvvP2sfFnTWOisjSIYIhy2i6Epx2GFFCPJmKULbpNgQPdTlRmyFokY5qYTyoqCENRLjrA==
X-Received: by 2002:a05:6512:ad0:b0:591:c3f1:474d with SMTP id 2adb3069b0e04-596a3eac18bmr9392825e87.15.1764464254932;
        Sat, 29 Nov 2025 16:57:34 -0800 (PST)
Received: from localhost ([194.190.17.114])
        by smtp.gmail.com with UTF8SMTPSA id 2adb3069b0e04-596bfa440d8sm2303111e87.46.2025.11.29.16.57.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 29 Nov 2025 16:57:33 -0800 (PST)
From: Askar Safin <safinaskar@gmail.com>
To: mpatocka@redhat.com
Cc: dm-devel@lists.linux.dev,
	linux-block@vger.kernel.org,
	linux-lvm@lists.linux.dev,
	linux-mm@kvack.org,
	linux-pm@vger.kernel.org,
	linux-raid@vger.kernel.org,
	lvm-devel@lists.linux.dev,
	rafael@kernel.org,
	Milan Broz <gmazyland@gmail.com>,
	linux-fsdevel@vger.kernel.org,
	James Bottomley <James.Bottomley@hansenpartnership.com>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Christian Brauner <brauner@kernel.org>
Subject: Re: [RFC PATCH 2/2] swsusp: make it possible to hibernate to device mapper devices
Date: Sun, 30 Nov 2025 03:56:56 +0300
Message-ID: <20251130005656.3644711-1-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <b32d0701-4399-9c5d-ecc8-071162df97a7@redhat.com>
References: <b32d0701-4399-9c5d-ecc8-071162df97a7@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Mikulas Patocka <mpatocka@redhat.com>:
https://lore.kernel.org/linux-pm/b32d0701-4399-9c5d-ecc8-071162df97a7@redhat.com/ :
> Askar Safin requires swap and hibernation on the dm-integrity device mapper
> target because he needs to protect his data.
> 
> This hits two problems:
> 1. The kernel doesn't send the flush bio to the hibernation device after
>    writing the image and before powering off - this is easy to fix
> 2. The dm-integrity target keeps parts of the device in-memory - it keeps
>    a journal and a dm-bufio cache in memory. If we hibernate and resume,
>    the content of memory no longer matches the data on the hibernate
>    partition and that may cause spurious errors - this is hard to fix

Let me add some more info on this patchset.

First of all, I already solved the problem for me personally:
I wrote hackish patch, which fixes the problem. My patch is tested on
my real hardware under load. I successfully use it for 2 weeks
(I hibernated a lot of times during this period.)
The patch is absolutely rock solid, and I absolutely sure it is correct.
Unfortunately, it is not generic, it is tied to my particular configuration,
it hard codes paths (!!!), and hence is non-upstreamable.

Here is this patch for your information:
https://zerobin.net/?ad6142bd67df015a#68Az6yBUxHA3AXB7jY1+clSRnR745olFHAByxwPGM08= .

Feel free to use code from it.

So I personally is not in hurry, I already have solution, which works for me.
(But I am still available for testing.)


Your patch has a problem: after "notify_swap_device" call, the pages can
still be swapped out. "pm_restrict_gfp_mask" call in "hibernation_snapshot"
prevents further swapping. Thus "notify_swap_device" should be called
after "pm_restrict_gfp_mask" (but read on).

I attempted to create test case, which would expose this problem. And I was
unable to do so. Still I believe this is a real problem.


Also, our problem is very similar to reason of introducing "filesystems_freeze"
( https://elixir.bootlin.com/linux/v6.18-rc7/source/kernel/power/hibernate.c#L824 ).

See problem description here:
https://lore.kernel.org/all/0a76e074ef262ca857c61175dd3d0dc06b67ec42.camel@HansenPartnership.com/ .

See also https://lwn.net/Articles/1018341/ .

(See also this huge thread
https://lore.kernel.org/all/20250327140613.25178-1-James.Bottomley@HansenPartnership.com/ .)

"filesystems_freeze" logic is already implemented in mainline. It is gated
behind /sys/power/freeze_filesystems .

As you can see, authors of "filesystems_freeze" attempted to solve similar
problem. Thus, we should probably flush buffers in "filesystems_freeze" call.
Ideally, flushing of dm-integrity should be correctly ordered with freezing of filesystems
to support complex storage hierarchies (i. e. swap on dm-integrity on loop
device on some filesystem, etc).

But... call to "filesystems_freeze" happens before "pm_restrict_gfp_mask" call.

So... in this point I gave up, and I don't know what to do (i. e. what the upstream
kernel should do).


Feel free to ask any questions.


I changed CCs for further exposure.

-- 
Askar Safin
