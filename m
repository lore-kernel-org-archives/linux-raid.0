Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C69C93E2764
	for <linux-raid@vger.kernel.org>; Fri, 26 Jun 2026 07:41:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782459678; cv=none; b=sCgjGRG/XpIDpyQps9x5UhNZH6cT/rY+aSSPeLJeKn0gg8+RFHn5nkm8uVgehM8VvDNrT7nH87NkCGIRbZUn6iENdrgEm4d5VFTw6mJddfBZ1m9i93rXKt4DeKQMFNkKhQ3nK3FTc7AQf0PRO00RjjA4wRxPH4yYVMMEJv9ub2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782459678; c=relaxed/simple;
	bh=tB6BfSmbDpWx8DBiFm+S2h4b9xfHN2ANaz1OEIho8fQ=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TghdD3T0xTQL77IE4ZZjaT7uPdM63bH+k/s9/2ESnYuTy4Qv069l6amHpSu+niRmYogs10ApgIttgH5ytZd8tQsbPGHkLEtm531pQDcA4kr+RHZioe2WpMYBFnvWOaSQ+KilLna0Y/MSuNxLFHU2S98qswYWl1xRDpnaMpJ6zUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HZ95o8oJ; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HZ95o8oJ"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-46f8562013bso51832f8f.1
        for <linux-raid@vger.kernel.org>; Fri, 26 Jun 2026 00:41:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782459675; x=1783064475; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k25eMOii6qvKTUwqK2ux2YYsD1dZ9vGEfhftC5yZWFo=;
        b=HZ95o8oJbST9PAJPOJEl9Z9evFOonWzoD6BtTidtv2hNkyEP2S4qfTviKp1NsI1bsB
         sxodC3B/Ro3Q0Jt2+e6NUy/grtj21sZ+0L8EffhY+qzcvnnQ/PjfhcWF17zEcJcKzFNI
         JiODiG4OTRp3oWhbn2w2enIoHnKhWdiWvE0CWQ548434DIISs2gHGDNXYT20JVMBGdwQ
         kdpEHg3uCTN1hGtcsMGh1qRA8+dtlUTI95CDIGwVeGd9SbFIcK2ZqI8ysz/nOwI6yZYo
         QD4ViHBIyLQS/GonOUs7xeGgvo04c8hhvKQF/8K+Kc93cI33X9KGmF+3WfFxMIV6SXXC
         6kRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782459675; x=1783064475;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=k25eMOii6qvKTUwqK2ux2YYsD1dZ9vGEfhftC5yZWFo=;
        b=kacol4Fvr1vPeDy0egMTFnbHnbOHebx875SeJr5ZaZD2VXkCKQpeGZUZleORmIREkb
         c0tkgjpNNEelujUMMxqD3wBMyTl7lMjPjqBLc0TDN04Pc2p04eElGfExEZ1rPct70JvJ
         N2cYRNSByd7Dra0pYcO0lYHZojRXMgad/Iniw4WqQZBR10SnNWFhJVOUNGbWct2rNA0C
         RIInqVJS71nMZKltkrpw9xiEr/aaPSdxDP1ZiC1F0YReIBxo7VglVk19GSu0Y67ahEfj
         gcn+3k0MJgEoSURmt3AQYT1SXHv2cX25/2HMG4OXraIoYOVO7LKdwR1Yzde/057Ynce/
         6DXw==
X-Forwarded-Encrypted: i=1; AHgh+Rpw7Oz3+Dy6k/ghajEaoOi6tSPcmubrI4Hspv7UvY76wiIqw/HnFoQNNM12CENoWK6B4hjMmq6MRUWj@vger.kernel.org
X-Gm-Message-State: AOJu0YykEgVjYt0FO9ZvvVqn/4uGIrMUbEZqCjMqDW9EOdLjAv/7uWTX
	z5SY3/gkEWGkrT7jnt0YQ2XoeiqSndNvkLcqcEI3esYymZMHyhKpw2zVGO4KAPOj
X-Gm-Gg: AfdE7clHWrze7Mqngja966sKVlE8LOwRQyU3xl6cNNMsydniZhizBVKC+xT+lZfIfLL
	pPzheNEmtEpVxEsS+j5WECX1mdFSQVilsDGHKFaA0MpLRgwTx7X7mFrynameDW0XhaJduk69wQ6
	pFeovLrxVU9u36pHhI+qEl0IqJm2cs7d+9wcxTLvV4hpsDQ2QJ197PpzykE8YessOvnlIT4QpFf
	8cRpB5C5xziotviVQCcJry/yZbDVSL2cyKgk1feqE8ClFw8Zm5QVeO2itep1zAB83e5TA1cikMf
	QU4Af/iyF02a9Ti5HyjD05NvlLojfHseOw+krp0tfOgGJWOWDWAKAc2mqu10VuZNAjn+XkMXnM6
	/1UinCOv4nqHVjEb+HU+94Q8KPeE6//M7MNd9xY7n6A0NU3O2toPamMHpz7PgKE6g46E26n6N+l
	r25Ayb0f2ey6T1oAeg1ynDUE1aJtNhIddp0Nz6lsatoo74CFpRgg==
X-Received: by 2002:a05:6000:24c2:b0:46d:654:d1f1 with SMTP id ffacd0b85a97d-46dc1a91830mr9870326f8f.21.1782459674983;
        Fri, 26 Jun 2026 00:41:14 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-46c1ee01c3bsm23853241f8f.10.2026.06.26.00.41.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Jun 2026 00:41:14 -0700 (PDT)
Date: Fri, 26 Jun 2026 08:41:13 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: x86@kernel.org, linux-um@lists.infradead.org,
 linux-raid@vger.kernel.org, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Andrew Morton
 <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/8] um: Check for missing AVX and AVX-512 xstate bits
Message-ID: <20260626084113.42eae31c@pumpkin>
In-Reply-To: <20260626043731.319287-3-ebiggers@kernel.org>
References: <20260626043731.319287-1-ebiggers@kernel.org>
	<20260626043731.319287-3-ebiggers@kernel.org>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 25 Jun 2026 21:37:25 -0700
Eric Biggers <ebiggers@kernel.org> wrote:

> If the CPU declares AVX or AVX-512 support, verify that all the
> corresponding xstate bits are also set.  If any are missing, warn and
> don't set the corresponding X86_FEATURE_* flags.
> 
> This eliminates the perceived need for UML-supporting AVX and AVX-512
> optimized code in the kernel (that is, lib/raid/ currently) to start
> checking the xstate bits in addition to X86_FEATURE_AVX*.
> 
...
>  static void __init parse_host_cpu_flags(char *line)
>  {
> +	u64 xcr0 = read_xcr0();
>  	int i;
> +
>  	for (i = 0; i < 32*NCAPINTS; i++) {
>  		if ((x86_cap_flags[i] != NULL) && strstr(line, x86_cap_flags[i]))

'line' comes from /proc/cpuinfo
Surely something would be terribly wrong if that included something the kernel
had disabled (or didn't support).

	David


> -			set_cpu_cap(&boot_cpu_data, i);
> +			validate_and_set_cpu_cap(i, xcr0);
>  	}
>  }
>  
>  static void __init parse_cache_line(char *line)
>  {

