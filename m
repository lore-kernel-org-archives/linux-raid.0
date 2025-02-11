Received: from mail-oo1-f43.google.com (mail-oo1-f43.google.com [209.85.161.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5AD71F191B;
	Tue, 11 Feb 2025 10:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739268007; cv=none; b=V11jbxYaIz7JfaY21gXPo6Cai4YrCsHQiPB00KmRXCrBAOTKvNSobx72u5h8UvkwqcXsEWX8You9uHh9N/4mBskojvzGpPCqDBApihyzwIjl0U11ch25S72giC81bJuZMqfa66bv3w1K8en6+7VK29F4jTmceUe1abum9ODAJEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739268007; c=relaxed/simple;
	bh=ti6eswH41tCqW1GhH9/mQ3eg1ve6Q+ctR/lrIxnOHw8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bl0N6HniE/4LGob6dVfGQeg1a5W3s34P2T9kPbz4TMQtFR4iuOvGTlWxvJWj0osbrCkGgLsvyyMgEQu6YEm8Jg9S++Mi4v4dYvvMXzcClnbYq1ud8mZ/+cK1qoHgVLJ1JUxA2BhfDWFJ/dmTR/flGbODDPAG3v8VlVw2HzprALw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ir4g4tfZ; arc=none smtp.client-ip=209.85.161.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ir4g4tfZ"
Received: by mail-oo1-f43.google.com with SMTP id 006d021491bc7-5fc447b03f2so1340519eaf.0;
        Tue, 11 Feb 2025 02:00:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739268005; x=1739872805; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=kMjcIGjdI0ffRg0rAm5FAcc+FuG3Hvf62mMCY1pQncg=;
        b=ir4g4tfZ0G9ObEtUFo7HuIi0pYsJoDrSfcYMp9B7p6ZNsH3H3yGuM+/XPNnslIHZ2X
         P/+chLPB9fO94GZfTWbSmfrjHR6LVnIk1on7MwtA7HCG9azqS3+cJW6o82KXvJPr7rS2
         +WVsILCkuLWpiOrwY4a29Lxk+t3YXlxWHfTeJ/KB4hISXDTO5MUP+V4kIImUjSODLuAT
         YQKDTaUtPusJiOoR0gb/GAFKPObr7slqL2VADB3Xp6SncKvaeX6rGLfAsI7MB67Nv4Rc
         lSd85RmzOjvmUn6CoxnXSdJ6VLef4jfqL6ntnerYKUjiV3Uxrmu6lKpvyFr2mDdTpDqe
         0Agw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739268005; x=1739872805;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kMjcIGjdI0ffRg0rAm5FAcc+FuG3Hvf62mMCY1pQncg=;
        b=pa4Aecd5emksYsuec7yxVOMrOmrHXZrpUzUl+swPx7yuBeqyDK0sdQhtR6gh5pOIkM
         kSZmFAFlEPIaPdjTCO1LdsyAGTmn+egyvpHZiONyvn/4uOzqKyXp8TKY59VHniRITVP+
         JXFw0gySvlQePhUgoSujNMhdkPo3F+G1QVu1PsE/b5HTFGkoRA20ZJMqG6Y7zq+aaJDz
         wy0R0JdlgyMJO1S4Hge9D7fh3FeLrI/ysSZ9sz9n6PMdQmwF9e/El9yrJrQHoX+7KSY4
         rvfWj6qsg/1qJn7GUh7LVe60MspdzKICEOv2BdtR2naIynGCs4bUrwZ4gnAbsZ7CxSjI
         yCdg==
X-Forwarded-Encrypted: i=1; AJvYcCU0GoEEwlBed9E4OxDgvlFbfUHoosm5nwM1752BZRDGJYHkxjabV0zBpw3VXzk0UN2Gjj29IDRou6/znMk=@vger.kernel.org, AJvYcCWQvyoCP3BMGPJwRFMQewUkmH9AZQSdd5wxVYySw11H5iy6XheNqeHsIyuVPkO9zDIFps0L0tzRmzBlrQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxUoEjyKUgqdu98zUz6myvvjxwZz3puQ32CYm/WBBfPoA3/bWrW
	7ZkLDhCf2ZkjW7DrH8N4O3bEVgF9bSV56Oh4qHVmU+2TDRodcVkJZyIud3ji3GCERWklF6blCiH
	3ON8tyh3NrBe599w1K293nA6/X7w=
X-Gm-Gg: ASbGncud8PQKHmw/Eg4bLylu4067mdH2elEyTEv2x/6ltLfyON4SVfErq513zYStClA
	ENGBofoGuZg0eAPaV1iH3BFQHHiJJwrtJVK73iPTJ6Bu8eEK5/jFijS1P1sk4+cqBd+eKL1dTOP
	GY4o1VPG+gijPYO6g7aVqYYmtb8/li
X-Google-Smtp-Source: AGHT+IGKksbEJ3etHXNKjondEMVicvSi7j8TGiJnnmy64FsLmXK2Iy60qC1Tibj+mbuOXvUSqichua+e9GwzGGxuQRA=
X-Received: by 2002:a05:687c:2187:b0:29e:75ff:4d0c with SMTP id
 586e51a60fabf-2b83eb5153amr11531322fac.4.1739268004642; Tue, 11 Feb 2025
 02:00:04 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250127061529.2437012-1-zhangchunyan@iscas.ac.cn>
 <c0a2fbeb-9a0d-4b69-bc6b-e1652e13debf@molgen.mpg.de> <Z5gJ35pXI2W41QDk@ghost>
In-Reply-To: <Z5gJ35pXI2W41QDk@ghost>
From: Chunyan Zhang <zhang.lyra@gmail.com>
Date: Tue, 11 Feb 2025 17:59:26 +0800
X-Gm-Features: AWEUYZkt8OdocdXVb0pQ5ZqBPoTuLbqJn64H0myEHoRqE0UKOX8xoM8V-7Mr18s
Message-ID: <CAAfSe-utAb53278x9X4tKn6jWzdehsPKDRa_CoQy61ND=cXbxQ@mail.gmail.com>
Subject: Re: [PATCH V2] raid6: Add RISC-V SIMD syndrome and recovery calculations
To: Charlie Jenkins <charlie@rivosinc.com>
Cc: Paul Menzel <pmenzel@molgen.mpg.de>, Chunyan Zhang <zhangchunyan@iscas.ac.cn>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Song Liu <song@kernel.org>, Yu Kuai <yukuai3@huawei.com>, 
	linux-riscv@lists.infradead.org, linux-raid@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 28 Jan 2025 at 06:34, Charlie Jenkins <charlie@rivosinc.com> wrote:
>
> On Mon, Jan 27, 2025 at 09:39:11AM +0100, Paul Menzel wrote:
> > Dear Chunyan,
> >
> >
> > Thank you for the patch.
> >
> >
> > Am 27.01.25 um 07:15 schrieb Chunyan Zhang:
> > > The assembly is originally based on the ARM NEON and int.uc, but uses
> > > RISC-V vector instructions to implement the RAID6 syndrome and
> > > recovery calculations.
> > >
> > > Results on QEMU running with the option "-icount shift=0":
> > >
> > >    raid6: rvvx1    gen()  1008 MB/s
> > >    raid6: rvvx2    gen()  1395 MB/s
> > >    raid6: rvvx4    gen()  1584 MB/s
> > >    raid6: rvvx8    gen()  1694 MB/s
> > >    raid6: int64x8  gen()   113 MB/s
> > >    raid6: int64x4  gen()   116 MB/s
> > >    raid6: int64x2  gen()   272 MB/s
> > >    raid6: int64x1  gen()   229 MB/s
> > >    raid6: using algorithm rvvx8 gen() 1694 MB/s
> > >    raid6: .... xor() 1000 MB/s, rmw enabled
> > >    raid6: using rvv recovery algorithm
> >
> > How did you start QEMU and on what host did you run it? Does it change
> > between runs? (For me these benchmark values were very unreliable in the
> > past on x86 hardware.)
>
> I reported dramatic gains on vector as well in this response [1]. Note
> that these gains are only present when using the QEMU option "-icount
> shift=0" vector becomes dramatically more performant. Without this
> option we do not see a performance gain on QEMU. However riscv vector is
> known to not be less optimized on QEMU so having vector be less
> performant on some QEMU configurations is not necessarily representative
> of hardware implementations.
>
>
> My full qemu command is (running on x86 host):
>
> qemu-system-riscv64 -nographic -m 1G -machine virt -smp 1\
>     -kernel arch/riscv/boot/Image \
>     -append "root=/dev/vda rw earlycon console=ttyS0" \
>     -drive file=rootfs.ext2,format=raw,id=hd0,if=none \
>     -bios default -cpu rv64,v=true,vlen=256,vext_spec=v1.0 \
>     -device virtio-blk-device,drive=hd0
>
> This is with version 9.2.0.
>
>
> I am also facing this issue when executing this:
>
> raid6: rvvx1    gen()   717 MB/s
> raid6: rvvx2    gen()   734 MB/s
> Unable to handle kernel NULL pointer dereference at virtual address 0000000000000020
>
> Only rvvx4 is failing. I applied this patch to 6.13.

I used your command to run but no issue on my side (x86 host, qemu
version is 9.2.0, kernel 6.13 too):

qemu-system-riscv64 -nographic -m 1G -machine virt -smp 1 -icount shift=0 \
        -kernel arch/riscv/boot/Image   \
        -append "rootwait root=/dev/vda ro"     \
        -drive file=rootfs.ext4,format=raw,id=hd0 \
        -bios default -cpu rv64,v=true,vlen=256,vext_spec=v1.0 \
        -device virtio-blk-device,drive=hd0

Thanks,
Chunyan

>
> - Charlie
>
