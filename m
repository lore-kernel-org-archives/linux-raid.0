Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.219.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793872196;
	b=W/hw0lbVL3Eou416o6SG/i/OOqVQNiV3ijlCHjjSPJHKziac2pxbnJarTKljyqjsFo4c
	 EJffvdYg0iGr2FnI2JC+tc6enF/W/5laSOun3jbgZQi58eQHAIO0LVpVrxvcgvBo1BxWW
	 oEcONoUOXWfpn+Qcy9JZ0akIP/j5H2+Ldc4ExSURfSYcNGGgMWogb/Qess8b15VsJ4b6v
	 JOwiAcbz3/3JRS+KLmpuSv56I7fD3diXxN6R0NHKz5auINWJo1TTlJHPw4JZ70PvZnqVR
	 ydJ6tycHBRB8RIswCm8Vah4ScG8Z5HB3MLbUMZe5tJCNDvNzYcAi2WPoaOQdFd6H65Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793872196;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Received:
	 X-Forwarded-Encrypted:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type;
	bh=SqrTjgENN7Dfs+HehxbKPgACeb32UvvfMAFijNHd6N4=;
	b=jAVlLykpanqQ+kDgIUCBnJbnvSCGSuDw/LhlMKMl/dGoGJTXjj4EiVm2rA3wH0HckVvi
	 iZ6XcpPrQamKfY87ck3+9Et5AChS0GxtlaF4AU6/bWYj+croDAJErBA7mo1SsSE0Hezlj
	 U0DAkZBBYXab1yUSKy1HK03BqMstRU/nQm9NlNvoYY5zDGetvJzNy57Nu+I4YYqCzy/dY
	 al3xhZj8FJsr2Z2aSgGsXAlM5la4mWie9GNOp+di6KZV32DqHTqR9nvRi5zw+O99BZmsL
	 RFFg+FaxWJo9JFDHGUNjvZyAVLCviL7J5HHAvsT+VRVysI4Gej401Yi9S1GR4caj6Hw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=linux-m68k.org;
	spf=pass smtp.mailfrom=gmail.com;
	arc=none smtp.remote-ip=209.85.219.42
Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B630160A3826
	for <linux-raid@vger.kernel.org>; Thu,  5 Nov 2026 09:49:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B630160A3826
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-91c79a9a739so23567036d6.1
        for <linux-raid@vger.kernel.org>; Thu, 05 Nov 2026 01:49:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793872194; x=1794476994;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=SqrTjgENN7Dfs+HehxbKPgACeb32UvvfMAFijNHd6N4=;
        b=whEIUTugvgMowHsxb+3LApFM0rug0mATUruTYOUm/7foTOhXQfTZK+pH9DsfyoJlMG
         wjV9dYLMJ/E7C/lBHLdJ4tMr7j6whRYsiGjDPtPk+ow9e8T/QKoHEwgGf0+NuSNZU/jb
         AoEsBLAgipfz9YBhzD0YSqvyj9razdUEfpefu/7cEsPcnXONDY9Zq51tjOB7dRUDXQfL
         y6ocPU9UTS++M2yPNqTjZbumrG4oAnfvcy467I1biMwxamNR1CcmQHUsO3Fohb9sWOj1
         Ousr+NA1jyyJ9use7fD9ATO3OojyEV+7MJdLzxQ93rX/juymkuhr5FoLizfR6u6eMMwT
         SoQg==
X-Forwarded-Encrypted: i=1; AKwUvBwBTD/6IN8/sAQszOD7IUPRWJcLzPAUrmOYAv0k0R13G4xp/1c4SxnXS8tU++Idp4y654AiVLT+D8gH@vger.kernel.org
X-Gm-Message-State: APuU4Z+OSzWzNCtD5hkPBXD4xNd1BvgPYSC7pVhQz+fK4bvLBcw+xdj4
	gnzAJSUGwr6foTHa3+4rQ7pjbhHqF5zXJ74nJw6Nd+2VOR/bfYZxVPNKVdedZcAzrDI=
X-Gm-Gg: AYBFou0gH0mAhyFvdb+Le3gMEwcdA38jZ41QzIzSLfW23qvjo2S++P2rTNdEz/aAajb
	nGR22d2mxtqMg0heiKWTezpKFbaw93H7QhKwXIvvObJc+1+s19/nMxP1C141a88g3rpxoylhjDw
	MUvN5qmpv/gOcx++FHzlIVLy3awouN9Lvel8w5aX9k24df4DMnHpjAhXHblJrCqgK+Tk7V2tTNe
	HTbO3q4kJu7FVsXx5PxjHnM9JUya4W7gIL5OY8dHYykzBpNy5jCSs9CG54N0O9NTgrHb3OZVzrn
	wp5Zu17VijUggn+3QSPP7/T/dMhUdjP5R8Gk3hdLR/qGRByRipMoBuEcxCK3ahcgsk0gUsKwMyu
	VCJKA68mITnsFuqTjaBQ61CpIJ8GN8SSYbCPVARNMs80pg5XkR+iyE2i/LRBn6tiO5unqsm/LRK
	AaiuOr/N6ZRLtufJ9dx6+D1wUE8SLdjHBipxjqeSSXUetQlMhVu9dWIDrU/Eaxf30HM6jp4MMEN
	4w8k6TfryC6gX11yscKsxfXwOQgYB0I1RkoZZZu0LsVPinwxIMv4MO8Z4WMHSKENs3Rp69m9d7z
	oCN2I68th5vKlTBalsoNCMnxBEMwQqsiXE7GgsqYlBOH9fVE5SfAFZxfmK7h8tApPA9fAw==
X-Received: by 2002:a05:620a:28c5:b0:936:ab1f:6aa4 with SMTP id af79cd13be357-944214dce98mr3139565185a.1.1793872194672;
        Thu, 05 Nov 2026 01:49:54 -0800 (PST)
Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com. [209.85.222.176])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91e7e01a3f5sm43051956d6.30.2026.11.05.01.49.54
        for <linux-raid@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Nov 2026 01:49:54 -0800 (PST)
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-93cc1ab5f6cso197143285a.0
        for <linux-raid@vger.kernel.org>; Thu, 05 Nov 2026 01:49:54 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvByfNErTeUQbKpVQKm1oWYhnm9R99XHaoC6BWdPlRRzjNPPfLefocSs0hFlFGkvaKO+FYEirek3d0RKo@vger.kernel.org
X-Received: by 2002:a05:6102:3ec5:b0:7cc:2bb7:131d with SMTP id
 ada2fe7eead31-7d072baa484mr7324212137.9.1793871885062; Thu, 05 Nov 2026
 01:44:45 -0800 (PST)
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Post: <mailto:linux-raid@vger.kernel.org>
List-Help: <mailto:linux-raid+help@vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-raid+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org> <20261104-work-procfs-bugfixes-v2-10-021c84d852e0@kernel.org>
In-Reply-To: <20261104-work-procfs-bugfixes-v2-10-021c84d852e0@kernel.org>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Thu, 5 Nov 2026 10:44:33 +0100
X-Gmail-Original-Message-ID: <CAMuHMdUy1RYKG0g8OWss3AD-jyYx3DXL0K7ABYkFUdxTxZ9VdQ@mail.gmail.com>
X-Gm-Features: AclHuK9D-nB8icBns0zdoQH8fV1cfUPJ6LOey8o_VlUZpDIGqKC4cFf8-j5-HdE
Message-ID: <CAMuHMdUy1RYKG0g8OWss3AD-jyYx3DXL0K7ABYkFUdxTxZ9VdQ@mail.gmail.com>
Subject: Re: [PATCH RESEND v2 10/51] zorro: size the proc files like what they serve
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

On Wed, 4 Nov 2026 at 20:18, Christian Brauner <brauner@kernel.org> wrote:
> The files under /proc/bus/zorro hand out a struct ConfigDev and seek
> within that, but their size says sizeof(struct zorro_dev). Say
> sizeof(struct ConfigDev).
>
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
