Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793872951;
	b=3x4rB0ycUs1R7wFLx99kPTX+0PMEFNlE00O6xO6ydsSPtUuyWnONBOKYVed9iOETNuz0
	 YLPM9V4C/c4Fj5EgX0bkuwqHAzJ8vVSj3lq4JqkHGeWKhCavw3woP0d/2i5QpgwZhLweg
	 HfySh6GUcf45mFjovdpCd/eRzLKLXX30gEuESaA0I/9LtLAj9EvvGw4moEw9Y3xuaqH9X
	 rE32RNWT6LZcK6hOkjLuspuXpwMfVN8FLh4Jpi5RxX7jYG3dQ/YG8XiFa+kj2mrs22KAY
	 l90t4nIvBsK3QAGHcu11MWK00WIq5fi57DkJBGPTlJElWOeeLj9iNtO+I4pCDNICvaQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793872951;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Received:
	 X-Forwarded-Encrypted:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type;
	bh=+mKdlgKO27T7zaM0EZirUNSUHhSIV/TKUV4SSUSBbFc=;
	b=1hMMQxHoC/0HYIs7DkmpBEn2uo3bSAZkdd08mqiMpO1fAc0GiYg6iw1jBzBkFIxUuttx
	 LgF7eWiwGren15WuB229dx+fuikJptMHJkFWSKlG0seK0njCVu1nltvQVz0sx3iXXpelb
	 NmASJM5FbHQBtvf4gnSxLWvlB9tVbAgAvp08d3Uzv/S39u56T2X/MTHFowvYkZjCuBeCR
	 eFF7E2TAVHJQD8DhlYTRLg0pYmYpNFIvov1wqRc0Ny+x4th42oLEXqdhrrUAfOLPK25jK
	 8dWhNV1XHWwhPOKEzDwbJAa6uEooUJBV4XqSMd0r8/GZPBv+lUzNqOPZoz/1IobXf3A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=linux-m68k.org;
	spf=pass smtp.mailfrom=gmail.com;
	arc=none smtp.remote-ip=209.85.160.41
Received: from mail-oa1-f41.google.com (mail-oa1-f41.google.com [209.85.160.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09C26606A326
	for <linux-raid@vger.kernel.org>; Thu,  5 Nov 2026 10:02:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 09C26606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oa1-f41.google.com with SMTP id 586e51a60fabf-4a85c656c58so1067024fac.3
        for <linux-raid@vger.kernel.org>; Thu, 05 Nov 2026 02:02:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793872950; x=1794477750;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=+mKdlgKO27T7zaM0EZirUNSUHhSIV/TKUV4SSUSBbFc=;
        b=Uls3l+gawXFW4yQhJ+ls7LcFye7s2xk7QVHjxMAL1UPOmSX41+CHS23NPVB2gnAIds
         wQXxorrL8ukjDvX4l521SKBn1161pq6M9bYMfbDkTquuRJfv62beLsgsu9HZ8vEns5bR
         L0JQ2mi3DsLdv8PRTVd6oCG3HVoLOWAmL+fLpMxyx2UonFd61gStifq9y2EGvQNJ4g45
         uJu5tcpo/3k4aaMJ0ia9pCMRrIo7DkXPGohEZBtEPKCzVYKjnEmYkibvI2lP9f+y6bvS
         olybaA6BZfEiMqRlrPZwZeoT83rc3lWbrj3zQ+yKhHhW3FWJ2A0MQsGzSdpF6Wb+ybvj
         Qd5Q==
X-Forwarded-Encrypted: i=1; AKwUvBxup7gCtGmWvUzC0bsrw7FxcmHkEMpVj4H2Rb2p0zngfFrOHNERaKah9sfe6wIZUIjd/uA2UBCp3ZJ0@vger.kernel.org
X-Gm-Message-State: APuU4Z+6Q6TBOPm5LckL/7o9uGUZR5IVuEr0o/03T10RlfUdi3qxN91I
	lp2tV2YfSkrj7BSS5HNcFeTIZlDQkMz2RJAWLwDrnpGkRkYQQKBdmlmJm3CaoPeUUjg=
X-Gm-Gg: AYBFou2BQ5AWEQAoeYHvgffbHSg69Uzlcw5qZpa9k6lEC35dEFBs0Mv5sZxNJO1T4Ta
	eOKuF201C5cQqYs3CQr3M7woBIhFuAe7299jwHH0hRti33QQ14ouXGR7z95K7mBh13Vo2ACJ4Pa
	FTM4x8fkzd575RakittM0hG3fsOjCWp/h9nlh187OfVo2G6vVP2qNR7q7DVRZelKzziDVMGOasJ
	X54LnOR8phPzX+nrtKYfYXArZ5IUN3PsDsTr30zclsmiiFiz/i9YbGsLpJiEl1NHXbqz0hoCgfg
	+GOwz7NXlVOLBcHJnCZuBHkENlqOJ87tu946VOM/5+IVbt2tLmtXlyPiBHF996IdelnjxMQfT8s
	+9yJZzjT6xlFmMVT0YmUmdCRpokvzssceRq0JDa6EgYmLHQ1RENNnWkxLhX/OyjWZ2uPI+L9yE6
	EbDENmRJ7fHaTsYkZSUvSBgQtw2g7ADQQX7HgOx5QBwyGXvqGA371fD5taXFQvB9m3ykHPUDHk0
	+qYxBsKsdBcmfQ9VV0TA/pbB/Y0gGttT90tqUZJkqmJFOEDwmiARug30ieAjQUhZAFTEAffk5Y2
	HczWz9KcRrTTEDg7KkemY3e/kIddVah0mDtlpFWcBzUlPwuMrW3RNjJWLDcn+Rr8pg==
X-Received: by 2002:a05:6870:9686:b0:485:d1ab:7936 with SMTP id 586e51a60fabf-4a9076914cemr11421717fac.23.1793872949720;
        Thu, 05 Nov 2026 02:02:29 -0800 (PST)
Received: from mail-oo1-f41.google.com (mail-oo1-f41.google.com. [209.85.161.41])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4ad7b74d02bsm1143308fac.5.2026.11.05.02.02.28
        for <linux-raid@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Nov 2026 02:02:28 -0800 (PST)
Received: by mail-oo1-f41.google.com with SMTP id 006d021491bc7-6b19e291cc6so1477365eaf.2
        for <linux-raid@vger.kernel.org>; Thu, 05 Nov 2026 02:02:28 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvByNYz3SFWfEK4eark/tMxI3kJDwm4SECzRBOUwfHX2MG8/P2L1NsI8G7rn9UznJaXFU7eoFpyOwQXlC@vger.kernel.org
X-Received: by 2002:a05:6102:950:b0:7b3:8f0a:f76c with SMTP id
 ada2fe7eead31-7d072bb3726mr8218716137.13.1793872596997; Thu, 05 Nov 2026
 01:56:36 -0800 (PST)
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Post: <mailto:linux-raid@vger.kernel.org>
List-Help: <mailto:linux-raid+help@vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-raid+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261104-work-procfs-cleanup-v2-0-1e6687e226b1@kernel.org> <20261104-work-procfs-cleanup-v2-5-1e6687e226b1@kernel.org>
In-Reply-To: <20261104-work-procfs-cleanup-v2-5-1e6687e226b1@kernel.org>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Thu, 5 Nov 2026 10:56:26 +0100
X-Gmail-Original-Message-ID: <CAMuHMdWkL=-oCgLA3HB0_Js_TdJ+P9FDBPF-u2z7uHrL+m7g-g@mail.gmail.com>
X-Gm-Features: AclHuK_YSG69l_UQ8CXymziWm2hhXR-Ce9gvdG6ZGXmuBEE26IV_RBgt33sxH_I
Message-ID: <CAMuHMdWkL=-oCgLA3HB0_Js_TdJ+P9FDBPF-u2z7uHrL+m7g-g@mail.gmail.com>
Subject: Re: [PATCH RESEND v2 5/6] proc: drop the _buf suffix from the new methods
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, 
	Linus Torvalds <torvalds@linux-foundation.org>, Jann Horn <jannh@google.com>, 
	Josef Bacik <josef@toxicpanda.com>, Chris Mason <mason@kernel.org>, 
	Jeff Layton <jlayton@kernel.org>, NeilBrown <neil@brown.name>, Eric Dumazet <edumazet@kernel.org>, 
	Thomas Gleixner <tglx@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, 
	Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@lst.de>, Greg Kroah-Hartman <gregkh@suse.de>, 
	Joel Granados <joel.granados@kernel.org>, Kees Cook <kees@kernel.org>, Jan Kara <jack@suse.cz>, 
	Jan Kara <jack@suse.com>, linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org, 
	linux-acpi@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org, 
	linux-um@lists.infradead.org, linux-wireless@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org, ntfs3@lists.linux.dev, 
	platform-driver-x86@vger.kernel.org, coreteam@netfilter.org, 
	kexec@lists.infradead.org, linux-pci@vger.kernel.org, 
	linux-sound@vger.kernel.org, netfilter-devel@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, ibm-acpi-devel@lists.sourceforge.net, 
	jfs-discussion@lists.sourceforge.net, linux-alpha@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-cifs@vger.kernel.org, 
	linux-fbdev@vger.kernel.org, linux-hwmon@vger.kernel.org, linux-mm@kvack.org, 
	linux-sh@vger.kernel.org, linux-usb@vger.kernel.org, 
	samba-technical@lists.samba.org, sparclinux@vger.kernel.org, 
	linux-m68k@lists.linux-m68k.org, linux-doc@vger.kernel.org, 
	linux-serial@vger.kernel.org, linux-atm-general@lists.sourceforge.net, 
	Takashi Iwai <tiwai@suse.de>, linux-input@vger.kernel.org, linux-raid@vger.kernel.org, 
	linux-ext4@vger.kernel.org, linux-modules@vger.kernel.org, 
	linux-debuggers@vger.kernel.org, Chuck Lever <cel@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Wed, 4 Nov 2026 at 22:16, Christian Brauner <brauner@kernel.org> wrote:
> The _buf suffix told them apart from ->proc_write(), ->proc_read() and
> ->proc_ioctl(), which copied to and from userspace themselves. Those
> are gone now. So drop the suffix. ->proc_write(), ->proc_read() and
> ->proc_ioctl() are the methods that work on procfs' buffers from now
> on, which is what kernfs calls its read and write as well.
>
> Done with sed. The flags and helpers in fs/proc that go with them are
> renamed to match.
>
> No functional changes.
>
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

>  arch/m68k/kernel/bootinfo_proc.c                   |  2 +-
>  drivers/zorro/proc.c                               |  2 +-

Acked-by: Geert Uytterhoeven <geert@linux-m68k.org> # m68k/zorro

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
