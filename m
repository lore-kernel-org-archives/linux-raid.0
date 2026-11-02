Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793642774;
	b=oGHZ+nUGeV+pMu59Ow0hXNPDIG5cihv5qDsaSiFRqdnXJeY9QP4/xLuS5QIZjOiDcEQ/
	 etGUACBFHi4gHEKhqIZcxOHkwDM0lNu2z8xW51hdEwqbn6WM0ojoIiZyJaho6m6pfMIwf
	 7ws8rdkE1MqmKdaYKoO91IVf/WT984aj1vnHK3Wcfog9F/AR1GUsVvR5LhCVOCiabWCIn
	 eoXs7zaO3sNsA3Pg81iSdtAEe4IOs193IXVlwNZEWQRqcThmu3bHpRb3F0tascdL347p9
	 nAEd4+HBZhK/qn29tN18fcdclNBx422jHpjE+z4VcWYm66+tEMgmqdc0k51FZRMNFAw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793642774;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Received:X-Forwarded-Encrypted:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type;
	bh=/vXXDZI2TLqXD/tqTZGHj/cF0YcMq0fXP1TpWYkM2ME=;
	b=13kMu0c/xcXfb9/NgaaSF+JuoUYiUS1FVDssevxIoFMAt95o6jUp4A6suGOUZ5UqpBVv
	 /FKHXaJ5x7sgXRzclMtbZgudGGC5vxXyWqbKhGhYBbaOgozs17VX4m0ZOx5TdcqvJNBD7
	 BXExfHoQP5A1GD55ULy5W2a61054glmhzktL75wLcY97s18nnzVWTbMabG5/0cKKtuWMf
	 aNh0GpvW3Qc61wEzZWXbdOgygun3aUpDsSYf5PW8jNyZ0ceBU+OSns+WVchfzrnUfu00n
	 9OewYtqZrCpn2AWbnXasj8efvLsNvNWlSFXpGOVl8HNmiYEwxG7y7I5r1OopSwhkvag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=linux-foundation.org;
	spf=pass smtp.mailfrom=linuxfoundation.org;
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=google header.b=JOXQDs0W;
	arc=none smtp.remote-ip=209.85.167.48
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D127B606A32C
	for <linux-raid@vger.kernel.org>; Mon,  2 Nov 2026 18:06:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D127B606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=google header.b=JOXQDs0W
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-5be4fea434bso3802169e87.1
        for <linux-raid@vger.kernel.org>; Mon, 02 Nov 2026 10:06:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1793642772; x=1794247572; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/vXXDZI2TLqXD/tqTZGHj/cF0YcMq0fXP1TpWYkM2ME=;
        b=JOXQDs0WKySicNYsIHlbCR2dvYN2is0ThJmgJkR3kItKFHcmG6VmzDy4j04WEFicWO
         18gjtk3L1M8uw4vGfQERbKkbW7i976RWZDROlQZZwQiLuGTzeImnm+wc/cwJ8eJAY4dc
         3qDAKN0cb+Ld/01GLEgy3oAplQ8KweGijQoYw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793642772; x=1794247572;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=/vXXDZI2TLqXD/tqTZGHj/cF0YcMq0fXP1TpWYkM2ME=;
        b=KNGm2VhC6+yj1+X8laniuTGCYBADh/ZjsTZ2CKnAFjWRYxcCXqaLwgEVDReq+tTZS3
         eeTGte3igKK4vUgDfkJe2GrGPOBK6PQkIrmwq0IxBBAgziN54pEsV+HOCTCzownwWaCb
         lYWSwKDM0f1DBvL6AMJKRyHDxrFw67/W8lW6oj0EtUvjINNouwxrRvrEUZB9YGD1Gcf/
         zycdTsr9bkzPZM1Osl7KnbKsaqgvbjP7eigpC7KvQo9nfCQqmXBk/X9UzD2IK8RgMzMa
         xEH9cI5w50y4FzrS0EO5VyVoX/fyDbIDOx2SyAU6icpjC27tLcmjn7gyXR2fE7cJB68+
         Qjcw==
X-Forwarded-Encrypted: i=1; AKwUvBxxTOzyVRBRG2oR7k5/6X/P+2Y+AJAiyo93TlGBSQgX5umtbjWr582PyqhJIwl4Zss55D4zGG8X5+ts@vger.kernel.org
X-Gm-Message-State: APuU4Z/caWQTlzoX/Y8hjp6CjAHx6ySbT88MnNxcl2BkjlPKmKNlmcSe
	I5lugP8tKT0B0TiTDuen+FpKOilwQGgJhLxPHdO3eJq3lP8hfuBOghXuOyQsLU0lryexbq/ypNB
	aSCyKOVdp9A==
X-Gm-Gg: AYBFou2wxyr5D3L5Nxgyega6o4JNCMlVhnL0JD2jQ2schlEDoBi/bT7lFKSVQCmW1sj
	Q/q3mkj/8Bsyc1C6AFv9npnqHULYoOJfVqBsMISXoPAvADK8k59uAcGoeLt+9gHcy3AOjDyUrWI
	mhZY1mpSn591q8NJ8IKKdeUk+s7kp1D/I09zFoXTjCxutiq6TnQapvcYaIe4KoGzKEY95P/jE3x
	q1H7zJwLcyN3xVzrfTaN29CpQ/HN8lg5/RboGOj3aXx0xvgWXeljYJPR70QY2fukrhf5ovYWphu
	E0vQncMNr3iy+Njc0a3p9ivaxuXqs/EsEd/W0UhRbGk8Xxn2Y3U/tdYF3OWcXNy8JNmOb9RD6Fu
	wQJA47Wrj8RBHbtuGqFaYqrbDCaR89ZcDxGeAjWwPnPKe+AlPzLkj2wBBhXlFHTt2PiNefxO/Gl
	ZZA6v5eKBgNpSmO4gp3Z3tDJ9CuDoom2RmYyahu4Paq1ufAWHlu/ztse85BHs5nwreq2Azj9y4R
	PFnyabMAHLHY3SlhxqN9fnge+o5C2r6AneCzPPSGTJ3+UwvlHur9lY6xcKPbWrLwtRC1rYg7JY2
	1/zvBjlWBx+xYSd52YHgoZROlRHJCzthtxgbGA+oDN6aP+SyeUeVfjA1//sG1vMdycKX8H7R1nK
	KFw==
X-Received: by 2002:a05:6512:2383:b0:5bf:c94d:4b49 with SMTP id 2adb3069b0e04-5bfd11ea1e0mr3748366e87.12.1793642772046;
        Mon, 02 Nov 2026 10:06:12 -0800 (PST)
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com. [209.85.167.41])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5bfe0721793sm1818054e87.18.2026.11.02.10.06.11
        for <linux-raid@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Nov 2026 10:06:11 -0800 (PST)
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-5be4fea434bso3802153e87.1
        for <linux-raid@vger.kernel.org>; Mon, 02 Nov 2026 10:06:11 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvBx2/ej2QVuUjaDwuQ7CnYdDzujnkQqGwjdYxgvOmd5P0cgY+UnM688NUR6dmZ3pSDkUPVpDPlNPHnRX@vger.kernel.org
X-Received: by 2002:a17:907:d94:b0:c2d:c80e:8366 with SMTP id
 a640c23a62f3a-c4ca7426f6emr874452266b.0.1793642348398; Mon, 02 Nov 2026
 09:59:08 -0800 (PST)
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Post: <mailto:linux-raid@vger.kernel.org>
List-Help: <mailto:linux-raid+help@vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-raid+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261102-work-procfs-bugfixes-v1-0-59422ed3e465@kernel.org> <20261102-work-procfs-bugfixes-v1-1-59422ed3e465@kernel.org>
In-Reply-To: <20261102-work-procfs-bugfixes-v1-1-59422ed3e465@kernel.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 2 Nov 2026 09:58:51 -0800
X-Gmail-Original-Message-ID: <CAHk-=wiSA7-mqmAjTQDaU7UjUyWt0TxYwXHafL8ZAPudy+B_uQ@mail.gmail.com>
X-Gm-Features: AclHuK_qZTBVsLQIdymgRHScSFenC6XsGggUDmcuOugjrSTbuVkeASUmC_hYPZo
Message-ID: <CAHk-=wiSA7-mqmAjTQDaU7UjUyWt0TxYwXHafL8ZAPudy+B_uQ@mail.gmail.com>
Subject: Re: [PATCH RFC 01/38] PCI/proc: don't truncate the position of config
 space accesses
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
	linux-debuggers@vger.kernel.org, Chuck Lever <cel@kernel.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, 2 Nov 2026 at 06:22, Christian Brauner <brauner@kernel.org> wrote:
>
> proc_bus_pci_write() truncates the file position to an int. A pwrite()
> at an offset like 0xfffff000 turns it negative [..]

I think this would actually be better with rw_verify_area() just
checking a per-file maxbytes.

We already have that logic for lseek and friends - using that fairly
hacky combination of s_maxbytes and !unsigned_offsets().

We should combine s_maxbytes and unsigned_offsets() at file open time
into f_maxbytes and check that not just at lseek but in
rw_verify_area.

And then things like proc_bus_pci could set it's size limit in one single place.

Hmm?

                   Linus
