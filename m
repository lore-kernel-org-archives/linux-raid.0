Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E77E3E5589
	for <linux-raid@vger.kernel.org>; Fri, 26 Jun 2026 10:50:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782471002; cv=none; b=b3eswA4T1sCbi9i90+MoNhW9XGmArWrNQs/tleDZd/8ZHTm87wNK+DHkfprAMXo5yAegOPWBPRNnBfGh8bclJSNi1AzrKTUEvYKJBKNh5ns+sRnLJ76XzCuWL6Wd/XiWBrwWFEdVrW9sZ9R175KIVj/I+iWnoF+DK9JFGueVEMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782471002; c=relaxed/simple;
	bh=203pWt4Jm7PC4KEO3FHeYQ3VSYID6CvF/RFcjlJ3oGU=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Pu9OwJqL+WDXAyaqkTXHxNZtG7I5pXzK96AUytMWhaLN3briJlw8WVTmmYdVmWlGCpNWQ0XPJrerSdm7kcDakJdnz7mvplRc3I8o5QwQBuqY6tYURHGRAPPqNr02FKefHqtgrMGccba7HgNvUXWoJW80u6eC4DKkhaB3BJu3P5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=k1ckVfS5; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="k1ckVfS5"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-490cf322ed0so5729685e9.1
        for <linux-raid@vger.kernel.org>; Fri, 26 Jun 2026 03:50:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782471000; x=1783075800; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cT0BDtDugceKAggCQsSGYTrTPkbadSs08NjvUXAN76c=;
        b=k1ckVfS5NPKveV0plkyfHtxOVv+O/OK7HuboKDAW3hYpEQqHKFt21rt3aVRtI2SUmJ
         mVGNL4sF0zCAp93SOInaY05qV0YtE1tzQM2qtc/Ho5Hmvu+DRIXctgXpba5pgbCtkOXD
         JSVWUWuYeOvZv8QreZtn4R1GEU24S2UIFEA9sx2AcZSvLUVg95kf/+6Z0KD4g+Hq/5nB
         u61thapNx0qD/nW2OGUtYP6clsJzBBmFU9S+kpshx3Ev9pBmo7wenRfDEs9VubIA6sxZ
         SoBPG181asyK56eogAXErzP0GcB/RB8XEsnedCBxGOs0q96CTdq/Jtaw264KW3EV9ie0
         VdtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782471000; x=1783075800;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=cT0BDtDugceKAggCQsSGYTrTPkbadSs08NjvUXAN76c=;
        b=YiBEAAjSSZw0BN5hb7GRGrqwBcFAjluBhSytvkIrEzwxoUSYCRbCOUoG56Nh30++mK
         Pai2VccsepNuJt0WCQuVwVi66OGhc3XjSbhCyVDhkK6aVuitVA5MYb3w375pADCigg9n
         oCONSqzI7Dq1soJ/5KyMgz8StLdcM1BEwaQ/RmimVBxz8QDnwxa0p/SFX7IlQSCz4V8h
         taaryl2N8smLFd7lCG6vQthmm14CGWOmyejSiKwOeyHT2a/HwwhtrVtGyXlt56VcDii5
         NsBcjQG12YK8p2Ut8ZXtrvCFodEF9MyUoPmw/JhyFFeuM9VJ7Kbirgt0Ug1XOwcW4VZs
         zGEA==
X-Forwarded-Encrypted: i=1; AFNElJ/QKOTBaFvL+kT16Ntq0aneXEFxTLCeuM6WpYf/v+RQWmRNkgipvnrLf2qLtQYHDF4wqB0NYpDdyZIb@vger.kernel.org
X-Gm-Message-State: AOJu0YycjVbnxcjr3n/iXjVJk+UY9UU109JlOZbV7FHH8eHTUTXS7z8P
	M4beHQvTxPvA4GPQgrROPZj4PnZBG758V93IEY2oCIxuBFfTZ0rdgupg
X-Gm-Gg: AfdE7clCw4VA+7oHl8FAZV62iuLOqsgO7mitGxK3PgOO/u/GVXUm2qCvKwvjAj+It9L
	9WxuT/1GY4OQMCJmKJTElDbDlyaGqgVNd2/cnS0BR8fEhCX32nks6P4UmKrPf5uK8WF3nl0A+r5
	VdpHOrNAUtgw2FEukPMGHRPBw80Q3E0+5vnDQZim5bMDM9P1+ChtpEYX1kpp0mXFFKUCzk6bDA7
	AXB0AmjaDNhxhCEU12HR92kHQs5MvmKg11XeXf2W2i7mjGR8t16TKN1HyM2Gq+kcBS4Ag6MM1T+
	uJeAbhz5AJ9BkoEC3YcxUZ5QNOhirXlm2IQ7uJOC5Rrky3y6vFM2cTFVDCVJfF/4J7E6aCvShOZ
	/HPY8KLOtVR9wLeU7OuiatxCMk/9yHJquv4SNJDR8UvcLaGInECrApcD1rzDnhp2TowNRXiIqw3
	fbQJFtSP55JtelAqvlPhcNjKfsAyhVRcbaNtPjP+RRG6U9po4kWw==
X-Received: by 2002:a05:600d:8494:20b0:490:5cb3:e94a with SMTP id 5b1f17b1804b1-4926684a83fmr72058605e9.2.1782470999554;
        Fri, 26 Jun 2026 03:49:59 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-46c221d9371sm25352587f8f.21.2026.06.26.03.49.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Jun 2026 03:49:59 -0700 (PDT)
Date: Fri, 26 Jun 2026 11:49:57 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Anton Ivanov <anton.ivanov@cambridgegreys.com>
Cc: Eric Biggers <ebiggers@kernel.org>, x86@kernel.org,
 linux-um@lists.infradead.org, linux-raid@vger.kernel.org,
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, Christoph
 Hellwig <hch@lst.de>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/8] um: Check for missing AVX and AVX-512 xstate bits
Message-ID: <20260626114957.1a2b7e5b@pumpkin>
In-Reply-To: <6a20b442-b97f-4cae-9168-30201d5ef82c@cambridgegreys.com>
References: <20260626043731.319287-1-ebiggers@kernel.org>
	<20260626043731.319287-3-ebiggers@kernel.org>
	<20260626084113.42eae31c@pumpkin>
	<6a20b442-b97f-4cae-9168-30201d5ef82c@cambridgegreys.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 26 Jun 2026 09:21:49 +0100
Anton Ivanov <anton.ivanov@cambridgegreys.com> wrote:

> On 26/06/2026 08:41, David Laight wrote:
> > On Thu, 25 Jun 2026 21:37:25 -0700
> > Eric Biggers <ebiggers@kernel.org> wrote:
> >   
> >> If the CPU declares AVX or AVX-512 support, verify that all the
> >> corresponding xstate bits are also set.  If any are missing, warn and
> >> don't set the corresponding X86_FEATURE_* flags.
> >>
> >> This eliminates the perceived need for UML-supporting AVX and AVX-512
> >> optimized code in the kernel (that is, lib/raid/ currently) to start
> >> checking the xstate bits in addition to X86_FEATURE_AVX*.
> >>  
> > ...  
> >>   static void __init parse_host_cpu_flags(char *line)
> >>   {
> >> +	u64 xcr0 = read_xcr0();
> >>   	int i;
> >> +
> >>   	for (i = 0; i < 32*NCAPINTS; i++) {
> >>   		if ((x86_cap_flags[i] != NULL) && strstr(line, x86_cap_flags[i]))  
> > 
> > 'line' comes from /proc/cpuinfo
> > Surely something would be terribly wrong if that included something the kernel
> > had disabled (or didn't support).
> > 
> > 	David
> > 
> >   
> >> -			set_cpu_cap(&boot_cpu_data, i);
> >> +			validate_and_set_cpu_cap(i, xcr0);
> >>   	}
> >>   }
> >>   
> >>   static void __init parse_cache_line(char *line)
> >>   {  
> > 
> > 
> > 
>  >  
> Lots of other stuff will go wrong before that. Glibc, things compiled with LLVM, python, perl, etc.
> 
> Half of the userland will go belly up, because AVX is used in string operations and hashing if it is available.

And glibc will check xcr0.

> 
> UML is just another userland application from this perspective, so there is no reason for it to behave any different from the rest of the userland.

