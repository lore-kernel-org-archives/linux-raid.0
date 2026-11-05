Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.174
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793872909;
	b=aLZbW3kKav/l1qHYbzWzntORVR1c8Q40PCBx5S9BXskQ2IIOomqLjakZxJ0yQifd70oB
	 IHANL87shC9OYVpYiQl8O9jGFbKE3QGOoavoJ2CKhNw8OkkopEZEIuRfChJImVjvcrsG5
	 bHP9cHNdoCPIatopvgZEIRfTZhiiqv/4phNNHkUvwrlSZRKlzVYdwR72l3iAHewjDunSn
	 Kor3aZXiH1NcrBzsFTcV/vRLD7AJsveiQpmEz9sK1O42FVB1EIvqh4Q/d318/LjuZt1xd
	 GjJt2HSGVS0Z8ujIWicPeLps0Ge8Ou5QFexPtvQ7+G3nixTl5NcEuw2oBsW2lo2T5bg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793872909;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Received:
	 X-Forwarded-Encrypted:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type;
	bh=n+1lmuZTLENNkpqKh8T8PUriZ63OKZ7RGcjsYNzzAGM=;
	b=5KAc/6j8YSMw1cW0aZ5vLUTeFrGDOC98a/E6OsuNLmBxroZpMDtEfYEyMP1tKlqwYYfW
	 aCCMwObFYw9hqzrP2Qr8VRQti45YBi5uMym6yBN1Q9Z2+ZaVAZeMQcoNT6oYZ8Y+hIEfy
	 eLqIrs+SFDKK9Qvosv/wFL64nCFwjMMKmtyVVbRI7YYqpDVRbJvQSjU8lwQezkJvXEDrR
	 FT5LuqsPfX6qcgNeTjEdAztc6dAfwXPHVMzHe5i1nZ9n1NUU9POrbBmoANTZNqzJCXOes
	 l5bt7OjXTmByuZZVWc4noJB9oyoUZVpOvNxS3FefJZXFntvSww58EVyZ7dV09UKl0jw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=linux-m68k.org;
	spf=pass smtp.mailfrom=gmail.com;
	arc=none smtp.remote-ip=209.85.160.174
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23EF5606A31B
	for <linux-raid@vger.kernel.org>; Thu,  5 Nov 2026 10:01:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 23EF5606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-5365f9a04c5so23584091cf.1
        for <linux-raid@vger.kernel.org>; Thu, 05 Nov 2026 02:01:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793872908; x=1794477708;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=n+1lmuZTLENNkpqKh8T8PUriZ63OKZ7RGcjsYNzzAGM=;
        b=F2Fan/8VeiXbjk9XE98v/xlPvHTgxI7A9Sdr/11GxxfHXcPxLZzMBhG05sEcAwh3wC
         M8yqdiFhUSTvj1HvnUXIKepvhTWp4bHcfm+zRq9uQM4t31/oqLyoltbHyVRAt+QzaT9E
         TaDGpL3hlspff4FJVAJLkIVer2oOeA7XalwUNb/drNlWB1ECv7PrzXhzbam9YBFDcTea
         7D6BjIQ3WlxVqBHP3vNAkX6BwgzYb+yqexmHDySr5kDYXFM6P6w6ep3RrKzLPdXt6U+G
         w4qgA5MzrtO8QPRhlCUySOnQQZw29BYTsC8x8wATCXxlQx++Vc8++yllOwpfLWlWAkz7
         4i4w==
X-Forwarded-Encrypted: i=1; AKwUvBw0YzdFEYV4Bf0oCWZwNI+VLinC0uhw2PanHVS64qi3fUP3drqLas+9igJjaOc3Cwcggp1ws/hr75UE@vger.kernel.org
X-Gm-Message-State: APuU4Z+FlCbH1ZJ68ylrjvJRnucZcSvLKnpurC5O+Ko9IyHsb9G/Bzek
	++OPPR3YwxUjXsoQ8uVH7bZuv00wPeBB6OKgMKCO+7bGFPgZCV+Kkq+lYVwgQrxToH8=
X-Gm-Gg: AYBFou0Q/ExyyQuInuEweH4/mqUg0+RMeczM7979j4OHAwYYfxiRCbOx+gsbFKHBzj0
	0Z2mOvf1vmqWy9bs0gvYIYREzceWwNyArkvEXbe3mh8gDVArff6QUkWx6DBOFuQ1c6CZnomCPvv
	JytVPZwTmj/t+lwzFJr6QArpiumu2XuZsNocStoqATHhjOUgHaZoTJqxJ8COm6QyAn/X9Q1/Qs+
	kjtsY2s1DEnPIOJWFOqPGcdxlkrNHmUbMxGF8IpEpU2NdTS5krlkfIvElF71ky08OrI8N+jPUT/
	QyoC59GEW0doWGJnbf+nUwtcdrejbdgU52c9zoQMWcrKypoXTv64hTwbxvxL4dSmoZqaCPHI4wX
	vJbWO7nvpSZufsVX93AgGq0MwX2Z8fGAe0/MJK1o94Pdmu8uWjYTqyMTqoNl+P8cAdoh810+gSL
	i64CxO8oMmqHc+gtO/BQ5eHM/dkBtAaR+HapEqhV2VrF6QgC4+Lj+FC+ug16rvmxVCDo8qCwZeu
	421rsBBSIG0jIqK35OoNS+C3wOdxwMTdJvAfyLz18tzujgx3nJ3iflhWiVBXXiqI9yKZK+cMG+i
	L/t0Y33UNCWFkPWi7FuHznlGQQbA4p9bKzsaKhGlpgQRmZHnPc8ibRFphPAC0x7S4tX1YGa8ID5
	5WgNynx2kZX0pbFs=
X-Received: by 2002:a05:622a:4017:b0:536:64f4:45e with SMTP id d75a77b69052e-542b7525e13mr299735161cf.50.1793872907871;
        Thu, 05 Nov 2026 02:01:47 -0800 (PST)
Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com. [209.85.222.181])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-54b100af507sm48152521cf.6.2026.11.05.02.01.47
        for <linux-raid@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Nov 2026 02:01:47 -0800 (PST)
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-93cc1ab5f6cso198413285a.0
        for <linux-raid@vger.kernel.org>; Thu, 05 Nov 2026 02:01:47 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvBwj78odIGt9mLYpUCRDLWJZNUfaswBHfwbDlzSvIga3lrjucEM+t4dZAXzX9fO0ttgQZT24WdLJmMLD@vger.kernel.org
X-Received: by 2002:a05:6102:6449:b0:7cb:bc5e:7dad with SMTP id
 ada2fe7eead31-7d072baa450mr7614890137.10.1793872492413; Thu, 05 Nov 2026
 01:54:52 -0800 (PST)
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Post: <mailto:linux-raid@vger.kernel.org>
List-Help: <mailto:linux-raid+help@vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-raid+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261104-work-procfs-arch-v2-0-2aeb952c9597@kernel.org> <20261104-work-procfs-arch-v2-4-2aeb952c9597@kernel.org>
In-Reply-To: <20261104-work-procfs-arch-v2-4-2aeb952c9597@kernel.org>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Thu, 5 Nov 2026 10:54:40 +0100
X-Gmail-Original-Message-ID: <CAMuHMdUNBs_NyhFpXonirMXkYptUWsAizMvVpGHUDLzto1LGJg@mail.gmail.com>
X-Gm-Features: AclHuK_RsrcE7hVRjmpZezBV5tMd490Mza2XAQiqUTgUNqAiHAzRP5z7NIbtMh8
Message-ID: <CAMuHMdUNBs_NyhFpXonirMXkYptUWsAizMvVpGHUDLzto1LGJg@mail.gmail.com>
Subject: Re: [PATCH RESEND v2 04/23] m68k/bootinfo: let procfs copy out reads
 of /proc/bootinfo
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

On Wed, 4 Nov 2026 at 20:36, Christian Brauner <brauner@kernel.org> wrote:
> Implement ->proc_read_buf() so procfs copies what is read to userspace
> after it unpinned the entry.
>
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
