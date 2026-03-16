Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DDBC3B38B7
	for <linux-raid@vger.kernel.org>; Mon, 16 Mar 2026 15:50:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.133.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773676244; cv=pass; b=fPGkLBtKbZ+9Gpnl6hmkdv2j4jtQcwB+caIINT8QlKkhifiXaePFkXB7uszLWZbLnqW3gU817z8hbCgL8+sfKl6M3IiyfJz7bkrHnBjwQkHhzB/3Zb/7eqZ3vTzlVbQR7HmS2Rpyl4m5K30TaxmaTnxRu9DTdekpKTrFz02+r6w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773676244; c=relaxed/simple;
	bh=vq+c7UH/hzdnUw4Pij6E4MRktnbSYB8v/Kul6obUS/k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JB/g6u6HHGXa31I3NCrJA8JoctUCBn8VtaeytY/OdvhPKc4q0dLR2QbnCFHZwZK0PKw7H2A8pyRiGHuKmxkQKoZBeokcoYX7es6qe7AelVgwDmidqyiiYLISRgiTeWZyTJ/yIZ65CGu92k2QovQGehsDh4EGdzx4tJ10rUvNx08=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JM/4ibSc; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=MLE5VzUG; arc=pass smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JM/4ibSc";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="MLE5VzUG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773676237;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vq+c7UH/hzdnUw4Pij6E4MRktnbSYB8v/Kul6obUS/k=;
	b=JM/4ibScwQFsl+PYyqo0xHONePZi2XhiXVoav+6OawkpcnGQjaTuaLUOXU1jHtCVRllszh
	YG4pLN5iW1d++r8spIuxUPyqFyrg/LztLKR+X+yNptWuDasGhBrQn+WV7rqzPBTB0gOGm9
	hq1yGK9S8aWdEhPio9a9RktHYCgOpDA=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-688-d6hA-GepMEGW5O3uP2t37A-1; Mon, 16 Mar 2026 11:50:35 -0400
X-MC-Unique: d6hA-GepMEGW5O3uP2t37A-1
X-Mimecast-MFC-AGG-ID: d6hA-GepMEGW5O3uP2t37A_1773676234
Received: by mail-lj1-f199.google.com with SMTP id 38308e7fff4ca-38a247e261dso28329671fa.3
        for <linux-raid@vger.kernel.org>; Mon, 16 Mar 2026 08:50:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773676234; cv=none;
        d=google.com; s=arc-20240605;
        b=T68T2LnVhR57i5knH9TR2hnC567K6mfKulFxmwlOvk8zTaDHWKbcickaQdNswUYXPn
         cdzyemPizXMimkGxsbmA682lgkJPiQZiI1keruv4FuNOgERP3xBCECliZlZViG1l9ge8
         4nlWFuUtAtROAoK7yAep6n4u+QfjH9ju77Ftjx+5YJuXmjMZFBzRiPqTq+HNzHvhjlfJ
         PAgyQvrB5EsA18n73Ma4QuhYw0jHNaY8NfLQbCWHooWv5DQnjulGzVf3a/Wd8WHimPJB
         rooT6VZrgG/eH+7nzgI7p5oZfz6qoD4bVMoPu5gn/IjpHz7zwM0Utt2T6PyMxv6Br/Bd
         qLlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=vq+c7UH/hzdnUw4Pij6E4MRktnbSYB8v/Kul6obUS/k=;
        fh=7xnjXTOG6hVceEfT2/c7IMB55OA2fjD2V/FAwLLQgLs=;
        b=V7UNzJKWhxHKMJEzMP4rIBdJyvo3JjT+gAJUKDPlwPjr+DM03tV7no+PRIwczNM1v3
         OZo1MOXXeYVDURumvvtVkV8+iIbhs2XlScr/FCE5/tYG7/vzYxGWgYHmfWVvzCYLH78z
         k8c/+uEuiBrC80CjSh2C1xiciMBIiXUtAbTAvzJrAxj30eFsDIplgc2FwX4jM+d5m1OZ
         yVWfcvOELdpW5df57e4ClKOgskfQMAT+HEiaSwrerMKOxv1iTY3api0kn5aw8UuFWloO
         cFhf1zrtdmI6kmnikA+VnO0uyl3gfxcenM5elGoWosQFmE77lK6Dh0cNsFW/LXHDL4tE
         bqNg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1773676234; x=1774281034; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vq+c7UH/hzdnUw4Pij6E4MRktnbSYB8v/Kul6obUS/k=;
        b=MLE5VzUGMWrSwNovJslKFzjh6cyumORrIjhar2QXixuwx6zN+5hmwrxqSS5lj5r0DH
         liwbi4mM4SHMmz423I0khFtbdBCMr5bPBw6fwAgir5Q62fM6Tkn+849Sqjm6Wi1cEWDI
         emHZ4GsbMczbWwtesPmgSzbum+KdZqUSBQKLj85no0h1yyQFDH33yTykebbhTYC0hauf
         g5K6Ia4EvPH87J+fxzuI73lPPbky3EKFi+KmhfErSf/pd98YzY2BCNpPPYzYJgSrCyvy
         t5UNvvq8EzRuJarhgs9dhhpHVPt+DKW86BQXXpLtmch8ph5sMK/3UVsxKgy96sedXk82
         NgvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773676234; x=1774281034;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=vq+c7UH/hzdnUw4Pij6E4MRktnbSYB8v/Kul6obUS/k=;
        b=RXVHkdhfg2dqeU1ZsJxRodyaWQ1jJ3zRYq5N/IngQl97Dce4jaZcTxcMTFqRFK8c3V
         kor7VAp3GLb5+/pcFiVjP6ndLdyxDbL/Npj5tSZZe5hXqMZostMfrkfiVpa7RAMuopa5
         dD7KQcMj6vdd+tH+6HKlNiVoXDF66ohrR8SwCs+tLwtFLv/vLMFrCELi715PhC7slpkL
         ShMofsMbePep3MEq6Ctf81UTcNrxToa37xVE/vFbtyqRIGRfYiKhreiMoCd76SIVdSav
         X3bhHjbNZRReOP4n3ZBwarJRkKoGrxLO1JkyBd2zoMM2EZqEoInGlht5KPcQiX367La2
         Sj/A==
X-Gm-Message-State: AOJu0YyQC1PIfpTVhBw7YQQi3HFZ1FA03fJkCt7TvqH1VLNtTE7OsNuz
	zALV+vMFBrGu6QFk6RtTm9fsRSenkhUQqJkrOt1RXNtQ8+pPF7cs9bWZA6y6P9l7bw4aJlRlZlx
	gPJpsB9gb+sWTEBwAeIjATW0ux/me3gttt8iPJOl407vVquWI0uiIK9SJ+5K3io/4Ak1AbhfIrg
	fgsn7oXKXQR6dgCcYeD7JaspzZM67nFcMcW9Y0i2GLWF4Ssg==
X-Gm-Gg: ATEYQzxFsSnuDmCGSF5wGkM8o951PRtN7Eb2QcY0IWOX/MJv7aMjTP1kpjNJYvgw+gE
	glelq/a/mxJqqcb76dcaySmeE/fTttU5CqA59zB/Fz8r2P7qvcFJLz83PNkB4AdGzAgql83Jv+4
	3G46MQP5wQjeqGyn2erZlXBbP+rka2dwymKsHXlPJx64VrYU7kZfOqaQTfnZLeejv/8pKrsEitb
	x8F5OqCRu1RQDhGOkyam7xHsLMAHfKDtY5plwZQDw9IgW1LxZ+Yn2IvaNAIzw5QG98Nxs45avL1
	Nh9dQw==
X-Received: by 2002:a2e:a44a:0:b0:38a:87bc:1a17 with SMTP id 38308e7fff4ca-38a8966f739mr33309211fa.13.1773676233466;
        Mon, 16 Mar 2026 08:50:33 -0700 (PDT)
X-Received: by 2002:a2e:a44a:0:b0:38a:87bc:1a17 with SMTP id
 38308e7fff4ca-38a8966f739mr33309081fa.13.1773676232717; Mon, 16 Mar 2026
 08:50:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CALTww2_2pjjOSsVj-WT++m35555CjnPWokU7fut+HwUJVV-=ZQ@mail.gmail.com>
In-Reply-To: <CALTww2_2pjjOSsVj-WT++m35555CjnPWokU7fut+HwUJVV-=ZQ@mail.gmail.com>
From: Xiao Ni <xni@redhat.com>
Date: Mon, 16 Mar 2026 23:50:19 +0800
X-Gm-Features: AaiRm52dLKnjQ__X-LLWnqLjp0fQe-ugfmq3_PsPEOT0LMh2WrMG9ll8vchq_yA
Message-ID: <CALTww291LdYTWihZ_9fJMwXVbzeTRBE-sLx5t4ORvTOOubAHNQ@mail.gmail.com>
Subject: Re: Release mdadm-4.6
To: linux-raid <linux-raid@vger.kernel.org>
Cc: Song Liu <song@kernel.org>, Yu Kuai <yukuai@fnnas.com>, Nigel Croxon <ncroxon@redhat.com>, 
	Mariusz Tkaczyk <mtkaczyk@kernel.org>, Martin Wilck <martin.wilck@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 16, 2026 at 11:45=E2=80=AFPM Xiao Ni <xni@redhat.com> wrote:
>
> Hi all
>
> I'm glad to announce mdadm-4.5. It is published to both remotes

Sorry, there was a typo above. s/mdadm-4.5/mdadm-4.6/g

Regards
Xiao

> (github and kernel.org). Here are some highlights from CHANGELOG.md.
>
> # Release [mdadm-4.6](https://git.kernel.org/pub/scm/utils/mdadm/mdadm.gi=
t/log/?h=3Dmdadm-4.6)
>
> Features:
> - Add support for new lockless bitmap from Yu Kuai
> - Add "PROBING ddf_extended" option in mdadm.conf from Martin Wilck
> - Add --detail to usage in ReadMe from Brian Matheson
>
> Fixes:
> - Fix uuid endianness mismatch issue in sysfs_rules_apply() from Abirami0=
904
> - Fix mdcheck: don't stop mdcheck_continue.timer from Martin Wilck
> - Deal with hot-unplugged devices in platform-intel from Jean Delvare
> - Detect corosync and libdlm via pkg-config in Makefile from Maxin John
> - Fix UEFI backward compatibility for RAID10D4 in imsm from Blazej Kucman
> - Optimize DDF header search using mmap for better performance from lilin=
zhe
> - Set sysfs name after assembling imsm array in incremental from Xiao Ni
> - Use creation_time for ctime in imsm container info from Xiao Ni
> - Fix sigterm variable to be volatile sig_atomic_t from Cristian Rodr=C3=
=ADguez
> - Use 64-bit off_t across both musl and glibc from Ankur Tyagi
> - Fix format overflow error in super-intel.c from Martin Wilck
> - Fix compilation errors for unused variables with GCC 16 from Martin Wil=
ck
> - Load md_mod first to avoid module loading issues from Xiao Ni
>
> There are some important issues which led to boot failure. These issues
> have been fixed recently. It's better to make a new release. So users
> can choose a version without these problems.
> https://github.com/md-raid-utilities/mdadm/issues/249 has the details.
>
> Best Regards
> Xiao

