Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794164398;
	b=ObftbFJXhM8uaul5VGRRm1pddhi/jrSo+AVW53XbU0gUeyBu9uDjt9jzO6SlyKUCEuAD
	 Tfo41EsLpGKdG06Od25uw8TY8Xe1jIEn4q6KzPXCUPJwVSlIBVTSWC34ewpUDX+29owif
	 +C9dWU4xcrev+eGRo7FHsUuqVo2FJGNZ149ykL2IRt0wmzOut0LFB0SYpDG2I9l/X+hOV
	 IBPp/sJpPKaz5cSvD+UpXoTC3USfSOZMVM9C11vKxyEV8CuD1MqSlxmmmpKFarojTjk1h
	 fDm8dey6PGYPJXnbhhoJ7os80q6PSJ+XPTC7jVmB1qXZqnrYvK+bH4lfAGPQ86JZRFQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794164398;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=JLhUwzup1lwefYy8NOOFjthYnrByVfTsqIe79kkV+Lk=;
	b=RYNGDg47IBzMwI0iprWF6Lfoga2MAPiwR6hSWOsxQ3WZZNtmPy67LnueyxG/BRE7Cod2
	 mNMALHkFe11/NllygtTQn91Kp7F/8/LBwhiwpw/f61gefG3wjtNmlkVFv/+mKgX4VoZ88
	 qn4So/PaECYT4rT5aLfOnGWoYOz4LfLMXutlo41zR2EYu4vnjPEPXnXqZOPYXQBrBp27a
	 S7xl+oMZX4AP4uOTjISUDYvz5hzvGBhTxFhtUoAlYinBHZT1qrmTL5//yfcF02VXMh3JP
	 atZyuIDQ/cTv78ovrbB+5pi2uVNl6++5hQbt6HO/bnPypV38r8ykdeTbSLTnVb3DZjw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=XrEUEgHU;
	arc=none smtp.remote-ip=209.85.128.51
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40A8D606D804
	for <linux-raid@vger.kernel.org>; Sun,  8 Nov 2026 18:59:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 40A8D606D804
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=XrEUEgHU
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4a35ac4475dso1148475e9.2
        for <linux-raid@vger.kernel.org>; Sun, 08 Nov 2026 10:59:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794164397; x=1794769197; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=JLhUwzup1lwefYy8NOOFjthYnrByVfTsqIe79kkV+Lk=;
        b=XrEUEgHUwv+lt2Z0T4RzlOQuYT1yMbnY/MJrtF5HY2pc8m0ujKE+1IGJbqc3A1SsPJ
         Pz+po0Wh7ECcrOl1hyNdZBme+OsO/r11IeCA1lW9KMbstFhlOkC0Hm7Ef+TTavGsfrDk
         7T2AE8nlcorDhYFpLo0KTCt4xOv09AacMRilfH2h4PS2mZ0iBReAF8XAcgtI3iT+qlRY
         EJQPYUIUlDRCCjadf1+24R8V0flZyhCZpLCroCVsidoQ510350k4POOaAcSXgGRrBTWF
         rbpUnz5O6K0TOR8uz/zwLHiObwDAqnCJFWP0+ssCNYCBYnXJwQ2yMfUqdKkv6ro/lp/q
         XMaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794164397; x=1794769197;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JLhUwzup1lwefYy8NOOFjthYnrByVfTsqIe79kkV+Lk=;
        b=yUkCyzSGFDmLUEJxN0Y58qWOU1OXIoCbWm3lrcy8FvHLjHKElqaOS61cjNseQjpcBd
         v3ZdUVZDq15SjSq5HokMhgPwMz6kDWdnf0R9suXA3OLSyPKlHV9mKxBwEa9MAFc7CMIt
         g33bZVg6rARBEr9vz/44xnvoUTkyJ8xbatFFFVtPY0S+ArA8c38ums57RnrsMlKdpCuA
         TgnFvf3BurVsD3vZ/LiFGFUBMuTpEUWTDhkG9yCpNlPcjCW05KTWxB0tpZtf+aGV7gKa
         JBMXqcre0INqL4YOTiduh6UB25zznXc8H9ZYzA2JCzOzxZfkfHkj2UWRwnLFL5bXKyPN
         PbpA==
X-Forwarded-Encrypted: i=1; AL+hErG9wo6Y/O4rEd2P1DMt3ok73N6432JbKi6tTLvgn1Nb9MyQTcfI8NENoqQeBwtY+yci6CaKATw5wKZP@vger.kernel.org
X-Gm-Message-State: APuU4Z8xA/cgjpOJUaealGLSPmyB8xPZ1pDtHFjXyj/MaD4vStYFrJdR
	gwUA1FUYnMMd4ZwUiNlitGBwGotPlou4DobbzcmPD93us6dryLEW4Vhp
X-Gm-Gg: AYBFou0/r91DdxFliNoFYibmJGTkCEbxD8VNZP5Zk4lOZ6PxpXGuvP+tUVK4vFuzec2
	iEYZG4K83FLIuPkU+g4P+6kbB8FvNCCTvJ8PJpMyhbce7QMSv4uUFBnrYEB7+pVxJnXapdt3sLA
	YxPOzb1uTmPhfjC/GBug8uU3RboSq2y1ZBdYNTla0bTtPAeKMiBYcXcmAW5XWhbCW7z2JP4TxT/
	y0rQzFQzlaMsdyPeiA+oYFx9mw1zpXxylrMyxg9/L5Mml0A+R70RtGM4qb+hCuhw/fqHKt0bILT
	t2h+mUPC6krbJ1fjnmA19MslsuvdsXFG8TEx+jg5vMwlT5KE6r2riwkBWzE/KZOBSwuAemkieNB
	umZ2jhT5cg2QDCaM1YRpNs8D8nUz42tPZAd1742ihvYx0Dat/GtSQ9kIXyBvtaVPptMYOWzeihi
	z+pLsYziOGqntfF/oYFnVyyp75c7MirFOVkYO5XeS2gOtM1b4FKuEuk01Sd8XCkNXjUTpCOeQOM
	vHPAT8v/96PvEGRCIfIv1eT52wcK7IUN13+kboq9DRrgaiTvdMivHQYOtbh19g9T7nU4sIShyBK
	tAOS249XYC51oYet+F8fBDAUBs+dlHY33ynWpvbuOT7ZuLfZVNUwW5f/7jOzEYJs
X-Received: by 2002:a05:600c:468f:b0:4a1:7e77:c382 with SMTP id 5b1f17b1804b1-4b960d9b170mr35982125e9.5.1794164396406;
        Sun, 08 Nov 2026 10:59:56 -0800 (PST)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b7efb1f3acsm185228445e9.14.2026.11.08.10.59.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Nov 2026 10:59:56 -0800 (PST)
Date: Sun, 8 Nov 2026 18:59:53 +0000
From: David Laight <david.laight.linux@gmail.com>
To: Christian Brauner <brauner@kernel.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
 linux-fsdevel@vger.kernel.org, Linus Torvalds
 <torvalds@linux-foundation.org>, Jann Horn <jannh@google.com>, Josef Bacik
 <josef@toxicpanda.com>, Chris Mason <mason@kernel.org>, Jeff Layton
 <jlayton@kernel.org>, NeilBrown <neil@brown.name>, Eric Dumazet
 <edumazet@kernel.org>, Thomas Gleixner <tglx@kernel.org>, Al Viro
 <viro@zeniv.linux.org.uk>, Jonathan Corbet <corbet@lwn.net>, Christoph
 Hellwig <hch@lst.de>, Greg Kroah-Hartman <gregkh@suse.de>, Joel Granados
 <joel.granados@kernel.org>, Kees Cook <kees@kernel.org>, Jan Kara
 <jack@suse.cz>, Jan Kara <jack@suse.com>, linux-kernel@vger.kernel.org,
 linux-nfs@vger.kernel.org, linux-acpi@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-s390@vger.kernel.org,
 linux-scsi@vger.kernel.org, linux-um@lists.infradead.org,
 linux-wireless@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 netdev@vger.kernel.org, ntfs3@lists.linux.dev,
 platform-driver-x86@vger.kernel.org, coreteam@netfilter.org,
 kexec@lists.infradead.org, linux-pci@vger.kernel.org,
 linux-sound@vger.kernel.org, netfilter-devel@vger.kernel.org,
 dri-devel@lists.freedesktop.org, ibm-acpi-devel@lists.sourceforge.net,
 jfs-discussion@lists.sourceforge.net, linux-alpha@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-cifs@vger.kernel.org,
 linux-fbdev@vger.kernel.org, linux-hwmon@vger.kernel.org,
 linux-mm@kvack.org, linux-sh@vger.kernel.org, linux-usb@vger.kernel.org,
 samba-technical@lists.samba.org, sparclinux@vger.kernel.org,
 linux-m68k@lists.linux-m68k.org, linux-doc@vger.kernel.org,
 linux-serial@vger.kernel.org, linux-atm-general@lists.sourceforge.net,
 Takashi Iwai <tiwai@suse.de>, linux-input@vger.kernel.org,
 linux-raid@vger.kernel.org, linux-ext4@vger.kernel.org,
 linux-modules@vger.kernel.org, linux-debuggers@vger.kernel.org, Chuck Lever
 <cel@kernel.org>
Subject: Re: [PATCH RESEND v2 14/23] proc: let procfs copy in writes before
 pinning the entry
Message-ID: <20261108185953.28054fb3@pumpkin>
In-Reply-To: <20261107-akteur-gemieden-eckdaten-21304d085e35@brauner>
References: <20261104-work-procfs-core-v2-14-76ace653a773@kernel.org>
	<CAMuHMdVfakapgBK6TBhO1iWX8qzvLDk8jzRS=t2MVa5G=MCUeg@mail.gmail.com>
	<20261107-akteur-gemieden-eckdaten-21304d085e35@brauner>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Post: <mailto:linux-raid@vger.kernel.org>
List-Help: <mailto:linux-raid+help@vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-raid+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sat, 7 Nov 2026 10:48:35 +0100
Christian Brauner <brauner@kernel.org> wrote:

> > While at it, I think it would be good to use this conversion as an
> > opportunity to replace "char *" by "void *", which will probably let
> > you drop several casts from users.  
> 
> So I tried that too. The thing is it drops exactly one u8 * cast in
> ntfs3's label write. 

Since char is now unsigned that one isn't even needed...

David
