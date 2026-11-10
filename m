Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794273281;
	b=cmHibdkD5xXiuSJQTrH04o4drQrY8taMkwkkNkp0k9JWyHmg0MiVi+DKZjq7LnGX8+B/
	 CP3yVbfaPchF3iVujXE3aJledkIF5j0TqMbIDhAEd71rVub6AV6IATe3Ns0G6OSOJSqyT
	 +qGwyhCsbmv39G1fVRX2wxcd6rjMg9bdGWIpyb7Rxt+tGIFHGrJ2UKDDLrvbVx+9euv+W
	 mCsEEdF7AT3oC3LGJx3TlkRPfsXPcCadLNNKY6oS8w8U1rFj7v42rlriiGD5SDFpuIuMK
	 cXcvV3fgCILrSlENvEOBYSftsjEzVAMsQ0HutNAqM36Zrx2cUdtG6ED1dQcpm9uLqkQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794273281;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Received:X-Forwarded-Encrypted:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type;
	bh=m2qXctBTC0OPADf0V2KkMb6r2GA0JgabIuFAMe6ERzQ=;
	b=GQ0DR/XNdEq2Z94R5vi27xmfRgbWu8Tn9f15EZ8OPF7Yf60PfA9o6Z7k9ZpGIYf3rlix
	 2s3dCDzuk3TLI2Bw6KjGIyLOsx3AeOz8VKKiYLKUatn8xX1ICup8u0Th0VaZkHsFtXwAH
	 CV4vXHTqeSkDudk/QNEfT5PLAz8LE/6m2GO/x/ovjQZHiL/1QPwgYRaSUGcgtnICB3PAN
	 BcItBxNOknhO3Qbt3sYdUYASPxXtipDZxdt1rVIs1EPAduZXaJ3hkTKoalT9cKj+9TWJi
	 MwMZCZFc3NSbc2Crl7VYK9d+Tk18LApe0GP9MedrFqiX6EtyTKZMQ79Xf+A1Z59FmTQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=linux-foundation.org;
	spf=pass smtp.mailfrom=linuxfoundation.org;
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=google header.b=c3HPZ9w3;
	arc=none smtp.remote-ip=209.85.128.53
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28711606A321
	for <linux-raid@vger.kernel.org>; Tue, 10 Nov 2026 01:14:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 28711606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=google header.b=c3HPZ9w3
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4a2153c8525so11415145e9.3
        for <linux-raid@vger.kernel.org>; Mon, 09 Nov 2026 17:14:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1794273278; x=1794878078; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=m2qXctBTC0OPADf0V2KkMb6r2GA0JgabIuFAMe6ERzQ=;
        b=c3HPZ9w3X3vdF/+J+vaP+PQYAUd2+9JOKWwj6JMce2A8a3XTTDedjlXPO55cC45zjl
         2hZf2gArAaC7b2VANcAz9siQ8hXOL0yOpee0+28IQ4U11h71kiwdUMjW00TOftz1OChD
         IA4Fb2sqqSoZR8rQ6NvDOj7SKOizFmF/BfqF0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794273278; x=1794878078;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=m2qXctBTC0OPADf0V2KkMb6r2GA0JgabIuFAMe6ERzQ=;
        b=O2n9bgdbPifyUdiaWmYMLuUfkPHEpmZJ6PHEeHzBquMEo6vhy4S1gBL4M0ou30OWiD
         Ki+GX1Zj6V/91Gu0rLY7kGgcNL3GOBVO1Q+JId13AanTkHkABAIoInCWB8VkPY0qOOxE
         b28EsCrKWRJjKEMNyd1hiSV7zTsez/3GHDu4x6g1wDefSiSbccrBDi0zPM/ol3gpvFev
         9dJd5fmrnx4U5CWQ9wpPjrV4pha+pAy4hR4YcopCzri0QYyktVO9jWlfzcP22rWHPukP
         rIjUCGaWOwOLmomFcC9Y4vaRvBjIG2T6/S/MgLUyBE0WaH9sOImacj3ePDYA+mUjtO/1
         vA3w==
X-Forwarded-Encrypted: i=1; AL+hErEIAJZ548fFce7Z/OBNPNn65mmtuqJkGrP01POwJK5OX4GsuZH4gUm4Ds/XEWxh9fJ2P40ja9S2RzR8@vger.kernel.org
X-Gm-Message-State: APuU4Z+WBAFbOck200kKbBjovH5DYn70Y9n3IY+9+1qV0hjFu9lqUHcU
	z6YjSSaHEcnBLSVOCioaSyUcp1y6DWRQcAX6RjlHeL7osQcCs89pVGjiKesnTS3kw7ToYIx4PDM
	tdLtYdI/XOg==
X-Gm-Gg: AYBFou2vBzkSSIxfUA0kc2JKB8sppIZ+xjns/5RJ6KOTO1/r0gyPXaA6mwLmSU/1fn/
	nuAuOnXcxmA0tmXjX/Di6mIB3xm3oeQ1SpFc2YDJkE/+DOWA3J6XuFbKLr/qv3T0rg3ER/L0bt8
	7YM7ErgEm7y1/2Wpc6Q/W/W976S02a50v/IX4zOiapfKd/QjWLES0LZuCI0GJUYDmVe8hihV8lF
	uGMYoe/h7GA9JMLmuMqS8SRVnWXMrzfoxN5Q6feC6eBbi4sopYRdIJl9NBEgUEnKGNHlKmTTRMr
	5Z5GhGfyUinOKxRQiqB+1J7KUxYCU9e9IFG4unS2VAMOkWls7Y5MdDlsBvUkXpQaflcbFtUQO8b
	HSATQMhhPwInssE+R84RIzjCvaer4KI1BpBuIEpZm7v4EeNXP/t1EaSN5VNZPPT944J2pOsmbAA
	7qrHh73tuXWSyjflDsk/JbgekZ/rhzKVe23v7sSopS1SDcC4wsTxo6H+ZKiOg0U7XUC3bqmQGos
	+WCBrLGBPxPGZTXApxGxsXsutj0+au+l+zZQm6jkIF0225hXe/MURhcUvczI8s9XtlwWAQp9eCE
	NkPc2KspeTiBNIEg3+KXK7vLg4jXDtk/q3WXbDsCpNL3XCfzhNggRuyMIxVZQHc5mACgdAt8xHt
	XaA==
X-Received: by 2002:a05:600c:64c8:b0:4a2:e0c:2b0a with SMTP id 5b1f17b1804b1-4ba02343ac3mr13422385e9.16.1794273278595;
        Mon, 09 Nov 2026 17:14:38 -0800 (PST)
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com. [209.85.218.47])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4ba01fe9357sm30340465e9.9.2026.11.09.17.14.36
        for <linux-raid@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Nov 2026 17:14:37 -0800 (PST)
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-c4d2b741ed9so241841766b.2
        for <linux-raid@vger.kernel.org>; Mon, 09 Nov 2026 17:14:36 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErEDpNOc1zHnpkWdH33pC5VGv/hG0wNcsyXNwCZ5b5TgE4RUU4nutHbxPUi0CR1yI9OYv7ud2gtt9hkp@vger.kernel.org
X-Received: by 2002:a17:907:9451:b0:c41:1750:59a2 with SMTP id
 a640c23a62f3a-c50495dfbd5mr87253466b.12.1794273275844; Mon, 09 Nov 2026
 17:14:35 -0800 (PST)
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Post: <mailto:linux-raid@vger.kernel.org>
List-Help: <mailto:linux-raid+help@vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-raid+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261104-work-procfs-core-v2-14-76ace653a773@kernel.org>
 <CAMuHMdVfakapgBK6TBhO1iWX8qzvLDk8jzRS=t2MVa5G=MCUeg@mail.gmail.com>
 <20261107-akteur-gemieden-eckdaten-21304d085e35@brauner> <20261108185953.28054fb3@pumpkin>
 <alpine.DEB.2.21.2611090504170.17804@angie.orcam.me.uk> <20261109214558.0d9d5228@pumpkin>
In-Reply-To: <20261109214558.0d9d5228@pumpkin>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 9 Nov 2026 17:14:19 -0800
X-Gmail-Original-Message-ID: <CAHk-=whsA3tKcUCBJDj_vmJ11rVGT9rivgnKjGRgMO21CPmCxg@mail.gmail.com>
X-Gm-Features: AclHuK-x8jcOOQUqd2amGoGEAKER9jIFGaeL4LxxWAd0cGV7dz_RR64PtDogpPU
Message-ID: <CAHk-=whsA3tKcUCBJDj_vmJ11rVGT9rivgnKjGRgMO21CPmCxg@mail.gmail.com>
Subject: Re: [PATCH RESEND v2 14/23] proc: let procfs copy in writes before
 pinning the entry
To: David Laight <david.laight.linux@gmail.com>
Cc: "Maciej W. Rozycki" <macro@orcam.me.uk>, Christian Brauner <brauner@kernel.org>, 
	Geert Uytterhoeven <geert@linux-m68k.org>, linux-fsdevel@vger.kernel.org, 
	Jann Horn <jannh@google.com>, Josef Bacik <josef@toxicpanda.com>, Chris Mason <mason@kernel.org>, 
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

On Mon, 9 Nov 2026 at 13:46, David Laight <david.laight.linux@gmail.com> wrote:
>
> Just that the cast would have to be:
>         u8 *foo = (u8 *)bar;
> where 'bar' is 'char *', and I don't think you need a cast there when
> char is unsigned.

.. and just to clarify: 'char' is always unsigned in the kernel on all
architectures since commit 3bc753c06dd0 ("kbuild: treat char as always
unsigned") back four years ago...

            Linus
