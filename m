Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793823120;
	b=l1SHeLsmqcWFs7XmKC/q9pqnZn71tmo0Dvqm9Bu+LPz/beXvEq4QKjDUCMGaGZLFiuUn
	 ZB7WAnEIDW9UCry3tPqWRNJnFgOB2hdVXNb4c6lEcA/Fq4lKezWMGSB/O3EipW5zZc77G
	 g8h9rEo1vOEB40eJlMTleh311mmf6paq2ZDgLi4qsqkGgXNYTylyy+T0iwneVBuMuofh1
	 VIo/pEJaNj/mLzV0AHDrLYTqFOoEV/xHoahcUOYYh5TB3pswDItCZMNe7l4+PSB8XKMfc
	 csVYfMSD6dTAg9pBgB3e81bGICbc6XDVFTsJ5rTFin7gQ1QS20fzCXesRFJMRssET8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793823120;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Received:X-Forwarded-Encrypted:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type;
	bh=LCqiLHf1DIbfKNXx3ccWkvqxBhOdwo3yYkazQxIGarg=;
	b=DstcOKBj4GWGarBVNbvqwJGwm7QH9tzINiyddP4qh/MFNB6kg5k4hFahPiKg59FNv2Vt
	 Ql4126P2X+7UDT4r1T7i+D1sPbesbB5D3NacOaikMnZ3meRZ5AwrCDpJZOLGk0kbbpTRe
	 u6jM2Zi3wemVb3d2+ESc3jiw2SB08YZI88vTtWL1sqkuNQWTQaZ0JNyRhwKYE9z76auwD
	 VbEZxWQSDuxvMxMSNejGpdDJRKTrjKTpzPjC1DJXpdbthL9JGUYquD3ugLciiDupGSk3V
	 elEd6+1e2SiQScSnDqiaCz0ioIk8G6QSdLWpeBWzh7w8ubz+Qe+fvFlONw2HvYSrAHw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=linux-foundation.org;
	spf=pass smtp.mailfrom=linuxfoundation.org;
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=google header.b=I87Xvan8;
	arc=none smtp.remote-ip=209.85.218.53
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B950607F2A8
	for <linux-raid@vger.kernel.org>; Wed,  4 Nov 2026 20:11:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9B950607F2A8
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=google header.b=I87Xvan8
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-c423b145922so163075766b.3
        for <linux-raid@vger.kernel.org>; Wed, 04 Nov 2026 12:11:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1793823118; x=1794427918; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LCqiLHf1DIbfKNXx3ccWkvqxBhOdwo3yYkazQxIGarg=;
        b=I87Xvan82apTuNxTLJiwfiF4obnDHzVroOHVTzadV1YGUVp1QwnjRMxSVbsG/iK39G
         EEVt14kbkIBBSSQJoM/D+3ut2JariDEU0SJNqemZCHsv4V/IgRY3Ymmj8T6Awj3Csf0U
         0Zk4haU9R+TZWsmGmd7Lim+kcMslMdg/kdog0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793823118; x=1794427918;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=LCqiLHf1DIbfKNXx3ccWkvqxBhOdwo3yYkazQxIGarg=;
        b=ql1g73uVYBJjFRqHABJ6xqf+CE85o3liWEFEJu90neh4GFVcybZ/l+ONnovbZoNhqD
         x4wgN8/Q/yG05pL676/mZnaIdNnP65V2DWsPouCZ0hnYFgFX+W9ZBwASlCl4qmZft1J8
         7S5+AK8+rzLJqtfSE4D17bpJAOWwGcL/rEnQGM4CF2w/YAbbLFealfFOQVhxmsuPmPEV
         No36jskpDH7gSl5LQGMnU3cTMu98f8xQhmU319iL8f9lsmmJPZRGwPMUUw/cecnHaCeT
         B6zYeclxURoYQa0b5zy93Dh9w5lbjLjXsKI0DsZmpG2sbiMqto2eB6Hwvp7p01ClSZtZ
         Iytg==
X-Forwarded-Encrypted: i=1; AKwUvBxU9NSKAsYP/C5ZJBCZtmTVzF5p3DNc8EJXNMB1tFGmYmp6eIgDuFkzsNK6dScNidUjuk/8jHYfVBAs@vger.kernel.org
X-Gm-Message-State: APuU4Z9wtZneZbmbD/qpwK+SHlqUuToJRUd0rv6gCiMoIhmTEq5cceJ3
	SqAnt9oc/fY1Jd5Hs82mVl6T3tYWIc0+vamkF/v28aLR0nKTome9XFmUo7ItbDhjkyZC+XqCAo+
	3VXFHnB7fBA==
X-Gm-Gg: AYBFou0tudW/EyOMmS2Bijplj3RdGMCSfmswPxNgtd+Z66+Q9zP/p+J5OuUuKPpyRtY
	+H9ro3ng7/cLAMwrgf9OkBLQKcovpDE5JGtaa8jhC6r1BlPE3F+L++NNHNpCxgbLiG70OGJl8oZ
	3sdA7wL5F4U3+Yu3qnphPiY8elf7oon7cyYWloeK+kDVG5+sNEskloxk8Dm2wM5hjRbYZNTnrUk
	/nMGVYv9PWPSuAI9wSG4xGvO6tD0ARdAH8ncNL6DmFUhjM03hNk+4049czWJFoy/Y5+UsyKTI1s
	PExEAqnwl6e9EQ1IPRing84l0/xfrJvdZt1FhHVx4Jeg/DQer73QNS5JjZnpeXAobmikjgLe+SV
	KOfkJh22b91mwLwrMvmeEl2MzpJ+pHXokfLTBT5TVeY3AsqYGYCSTWer4LDyfiCJTUw7X8FZuQ6
	L9uSYjZpJWsdJMw1N9Bdje6V2qvjIxQdQgar0xXm1LW4f4iEuqS8KBU/5UT4XgHHvrBjh+q50DQ
	ZQW+ZRxRRCqWn2aghCRwvBWlwLHXyH/fRHBvE4SBu/O4IQSZSk/zJlp9DMhGYBRFVKNbYkik5IW
	dXECgFW97S9JYIm9NxEW5GyyUQyTF9s9kwwlEYD/1zH36xzcooTI4WZQte7PsDURv0pOjEziMRz
	Icw==
X-Received: by 2002:a17:907:940f:b0:c25:afb6:2d91 with SMTP id a640c23a62f3a-c4ca795fa03mr1526429966b.2.1793823118044;
        Wed, 04 Nov 2026 12:11:58 -0800 (PST)
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com. [209.85.208.50])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c4d0e140005sm110480266b.5.2026.11.04.12.11.57
        for <linux-raid@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Nov 2026 12:11:57 -0800 (PST)
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-6b579003f29so81993a12.0
        for <linux-raid@vger.kernel.org>; Wed, 04 Nov 2026 12:11:57 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvByjhpz00HMPcRNBYlDKLT8a/wDqws98mA3TpfWLLPwTISy1HA/DuedSieqf1HbCSlc51BMG/c3UIOyr@vger.kernel.org
X-Received: by 2002:a17:907:60c8:b0:c49:a4b1:9cb1 with SMTP id
 a640c23a62f3a-c4ca795fa50mr1973235866b.3.1793822725121; Wed, 04 Nov 2026
 12:05:25 -0800 (PST)
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Post: <mailto:linux-raid@vger.kernel.org>
List-Help: <mailto:linux-raid+help@vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-raid+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261104-work-procfs-v2-0-b45cd5789ac5@brauner> <20261104-work-procfs-fs-v2-0-319e0f9a8aae@kernel.org>
In-Reply-To: <20261104-work-procfs-fs-v2-0-319e0f9a8aae@kernel.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 4 Nov 2026 12:05:08 -0800
X-Gmail-Original-Message-ID: <CAHk-=wj9Y9NcOesBBm+jhPjYa7qO00fD7g7uwX+H-k0-R2difA@mail.gmail.com>
X-Gm-Features: AclHuK9j_YIgrwhhpWOlnull6heAULBd4dgTqoOhUQQjFm_MgoIgrL1vgPfefvI
Message-ID: <CAHk-=wj9Y9NcOesBBm+jhPjYa7qO00fD7g7uwX+H-k0-R2difA@mail.gmail.com>
Subject: Re: [PATCH RESEND v2 00/30] proc: convert the fs, kernel and mm
 entries (Part 5/7)
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Jann Horn <jannh@google.com>, 
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

On Wed, 4 Nov 2026 at 11:49, Christian Brauner <brauner@kernel.org> wrote:
>
> Part 5/7 of "proc: move procfs to what kernfs does", on top of part 2

Christian - way too many patches, re-sent much too often, cc'd to way
too many people.

Nobody is going to read these repeated resends, and all you are doing
is clogging up peoples mailboxes.

             Linus
