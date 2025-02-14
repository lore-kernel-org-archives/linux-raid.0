Received: from mail-oa1-f51.google.com (mail-oa1-f51.google.com [209.85.160.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E646A189915;
	Fri, 14 Feb 2025 08:58:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739523499; cv=none; b=a/9M1HbFwqo1hSjkDUVbzYrtDWGJUBJlDXNgLnlOCeDVP+i+p/EDC2lCpmHZQ9BYMh36x6D+KRe8mv5HSqfVLoSgHdRET1GSLify+ZgpcnROzrofYWSqJHw0BmTq9NzonTVKcij6WdBO/KnxR790awjviQQOvYI0/6pNtp4Db/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739523499; c=relaxed/simple;
	bh=VOld3dnw+T4weevCXt6kCyRx+szkiYiuTkVNcPfwJV4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=B+TTkf+CuH/eIGWg+PP9uzKARiRK91ZW8KRXi9ZXApvOuxQFSOydgQaOaxWERr3WZnp6hBONS0aVTHWd8L8gDEIJ2ysn0sNlmtqy+IG/gZ6xgMDWjRT61g7YbJU97D+qTOjQd58BkCYz1qJ4B4j6i961leWo0AyrkXRka21S/TM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=a22o+UKD; arc=none smtp.client-ip=209.85.160.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="a22o+UKD"
Received: by mail-oa1-f51.google.com with SMTP id 586e51a60fabf-2b8e2606a58so970530fac.0;
        Fri, 14 Feb 2025 00:58:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739523496; x=1740128296; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=QtD1EK2iHm2J01pml3P/unMeIKoZgkx4ph4Uy7XYIUg=;
        b=a22o+UKD4q1eyEITdr/4HuR8rf4ldFl7Y347FY0agkM8jB0AaRudFutWSLGFlRmpBT
         zUAnc3mqzhlBe9FzMv0oKsrOwrt+Dk6e8FrQTQQa6uP06h/J+Ujlbclczq+IKMvsgmlp
         a2hwcpb1DNFe5Iv8coa6BUtC9ZPrF58qvSXjcWEaWx8XMf6fdjBDfe0Q+wbZSIDsH+iu
         pEzr4vIGGIpnRebWpBIRclwZ+csJw63nUQhD7Hwdbv7mhv1n5Ef0L6M/VCqmoz2rVoLj
         IAY/pRfwLWvQUCD8YgCkpG3bUALHeSBWL4l7qUnjjOEgjrVDF/B+Z3+GJacYkX+iub3q
         q2uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739523496; x=1740128296;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QtD1EK2iHm2J01pml3P/unMeIKoZgkx4ph4Uy7XYIUg=;
        b=Yf4h+6al50+GsbFX2NrEDCHjcf0ohtG5+ssyEJMnHqCLR/w9P0Rrzp1Rg4vxOXpB+Z
         iKoGKNadpWTR8IpjYEOMJVE0XemzEfy0MURQEco5UeX9a1bOjq2LDIA5xxNzY7kLkQhx
         Ai8YfYk14cwoZ7YjDWIMZwOpGIgEZBFD9UksYEtihvYJiW+07YEf1EnFzc9972RfiRhN
         hbcho9USpD0kfeYjQFGwquejHPEtyNPDYXOXBrMl0JQXt8nQJ8/W+jvzoQybJ/fX6g0O
         JKj5fznWQ9nLGqvFblhXH4y789cyIsfk7IJyQpzPGDav3aoZVkj6fkth5x4aimdxGsh9
         /QVQ==
X-Forwarded-Encrypted: i=1; AJvYcCUZFBvKo7PW42oV/w1f2fPIJ3y2aRzyl+gUQBK3AKGtRmJrtRhnP/SIX8lESyKC5b3cIp6kYOpsEL9HEg==@vger.kernel.org, AJvYcCWORFNlrj6qZxnAA93FUjrg7HZfHYv6A+Fu636CrACrvSLBaa1WPC5G/tWkzqgPkeMUfXPLTjBwcyHnmEU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz67uahdr+StJOO+HwVZ5au9Xk3NzV75Zmz//Dg6U9kfuvy789W
	s+y3a+8SbLHKXPhINY9E3qO3jFbNpGih/eaSaQ57tOfZsoA0RvPtoR6yEyg9cBMpHMHVccKikNJ
	jCnOhkRpEcHNBA8KOeYRgIZEu38Q=
X-Gm-Gg: ASbGncte+LVgEOOxJcd6luF9Z1tUooUC6x5a+sI3N4FwtUTlBsWUU5pr0CH1XtbaJn/
	iTc4T3zXc0/WVJuFVgrKeW1G4HQvxG6R6BMN6Mv6TZng5dfN1PU5ZyyEqDCnJ3fHBGd7BWMcVIN
	t9fzFgx09mfN3cbHMuJLYLXodccqGr
X-Google-Smtp-Source: AGHT+IFLewb412noj4uqcVc4O05Mx0s640QthBlKi29bsLaw4fZCgCoki/X1a7yUuRxKarNYApMZBkUEJ48ks/HSldc=
X-Received: by 2002:a05:6870:ec94:b0:29e:29ac:5ade with SMTP id
 586e51a60fabf-2b8daf9798fmr6678884fac.35.1739523496658; Fri, 14 Feb 2025
 00:58:16 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250127061529.2437012-1-zhangchunyan@iscas.ac.cn>
 <c0a2fbeb-9a0d-4b69-bc6b-e1652e13debf@molgen.mpg.de> <Z5gJ35pXI2W41QDk@ghost>
 <CAAfSe-utAb53278x9X4tKn6jWzdehsPKDRa_CoQy61ND=cXbxQ@mail.gmail.com> <Z65l51hrDmKQP6dM@ghost>
In-Reply-To: <Z65l51hrDmKQP6dM@ghost>
From: Chunyan Zhang <zhang.lyra@gmail.com>
Date: Fri, 14 Feb 2025 16:57:40 +0800
X-Gm-Features: AWEUYZk6Nb2w_oOkYEtmCWxquIeInQemENiiDTKj3yi3kUf3z09tHcasYvPqllI
Message-ID: <CAAfSe-tcNHYY+Jw5CZNOxXgLcK8gvBq7rgOY5KZfM_+9PbTfHw@mail.gmail.com>
Subject: Re: [PATCH V2] raid6: Add RISC-V SIMD syndrome and recovery calculations
To: Charlie Jenkins <charlie@rivosinc.com>
Cc: Paul Menzel <pmenzel@molgen.mpg.de>, Chunyan Zhang <zhangchunyan@iscas.ac.cn>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Song Liu <song@kernel.org>, Yu Kuai <yukuai3@huawei.com>, 
	linux-riscv@lists.infradead.org, linux-raid@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Fri, 14 Feb 2025 at 05:36, Charlie Jenkins <charlie@rivosinc.com> wrote:
>
> On Tue, Feb 11, 2025 at 05:59:26PM +0800, Chunyan Zhang wrote:
> > On Tue, 28 Jan 2025 at 06:34, Charlie Jenkins <charlie@rivosinc.com> wrote:
> > >
> > > On Mon, Jan 27, 2025 at 09:39:11AM +0100, Paul Menzel wrote:
> > > > Dear Chunyan,
> > > >
> > > >
> > > > Thank you for the patch.
> > > >
> > > >
> > > > Am 27.01.25 um 07:15 schrieb Chunyan Zhang:
> > > > > The assembly is originally based on the ARM NEON and int.uc, but uses
> > > > > RISC-V vector instructions to implement the RAID6 syndrome and
> > > > > recovery calculations.
> > > > >
> > > > > Results on QEMU running with the option "-icount shift=0":
> > > > >
> > > > >    raid6: rvvx1    gen()  1008 MB/s
> > > > >    raid6: rvvx2    gen()  1395 MB/s
> > > > >    raid6: rvvx4    gen()  1584 MB/s
> > > > >    raid6: rvvx8    gen()  1694 MB/s
> > > > >    raid6: int64x8  gen()   113 MB/s
> > > > >    raid6: int64x4  gen()   116 MB/s
> > > > >    raid6: int64x2  gen()   272 MB/s
> > > > >    raid6: int64x1  gen()   229 MB/s
> > > > >    raid6: using algorithm rvvx8 gen() 1694 MB/s
> > > > >    raid6: .... xor() 1000 MB/s, rmw enabled
> > > > >    raid6: using rvv recovery algorithm
> > > >
> > > > How did you start QEMU and on what host did you run it? Does it change
> > > > between runs? (For me these benchmark values were very unreliable in the
> > > > past on x86 hardware.)
> > >
> > > I reported dramatic gains on vector as well in this response [1]. Note
> > > that these gains are only present when using the QEMU option "-icount
> > > shift=0" vector becomes dramatically more performant. Without this
> > > option we do not see a performance gain on QEMU. However riscv vector is
> > > known to not be less optimized on QEMU so having vector be less
> > > performant on some QEMU configurations is not necessarily representative
> > > of hardware implementations.
> > >
> > >
> > > My full qemu command is (running on x86 host):
> > >
> > > qemu-system-riscv64 -nographic -m 1G -machine virt -smp 1\
> > >     -kernel arch/riscv/boot/Image \
> > >     -append "root=/dev/vda rw earlycon console=ttyS0" \
> > >     -drive file=rootfs.ext2,format=raw,id=hd0,if=none \
> > >     -bios default -cpu rv64,v=true,vlen=256,vext_spec=v1.0 \
> > >     -device virtio-blk-device,drive=hd0
> > >
> > > This is with version 9.2.0.
> > >
> > >
> > > I am also facing this issue when executing this:
> > >
> > > raid6: rvvx1    gen()   717 MB/s
> > > raid6: rvvx2    gen()   734 MB/s
> > > Unable to handle kernel NULL pointer dereference at virtual address 0000000000000020
> > >
> > > Only rvvx4 is failing. I applied this patch to 6.13.
> >
> > I used your command to run but no issue on my side (x86 host, qemu
> > version is 9.2.0, kernel 6.13 too):
> >
> > qemu-system-riscv64 -nographic -m 1G -machine virt -smp 1 -icount shift=0 \
> >         -kernel arch/riscv/boot/Image   \
> >         -append "rootwait root=/dev/vda ro"     \
> >         -drive file=rootfs.ext4,format=raw,id=hd0 \
> >         -bios default -cpu rv64,v=true,vlen=256,vext_spec=v1.0 \
> >         -device virtio-blk-device,drive=hd0
>
> I am able to reproduce it with this defconfig:
>
> CONFIG_SYSVIPC=y
> CONFIG_NO_HZ_IDLE=y
> CONFIG_HIGH_RES_TIMERS=y
> CONFIG_BPF_SYSCALL=y
> CONFIG_IKCONFIG=y
> CONFIG_IKCONFIG_PROC=y
> CONFIG_NAMESPACES=y
> CONFIG_USER_NS=y
> CONFIG_CHECKPOINT_RESTORE=y
> CONFIG_BLK_DEV_INITRD=y
> CONFIG_EXPERT=y
> # CONFIG_SYSFS_SYSCALL is not set
> CONFIG_PROFILING=y
> CONFIG_SMP=y
> CONFIG_CPU_FREQ=y
> CONFIG_CPU_FREQ_STAT=y
> CONFIG_CPU_FREQ_GOV_USERSPACE=y
> CONFIG_CPU_FREQ_GOV_ONDEMAND=y
> CONFIG_CPUFREQ_DT=y
> CONFIG_JUMP_LABEL=y
> CONFIG_DEVTMPFS=y
> CONFIG_DEVTMPFS_MOUNT=y
> CONFIG_MTD=y
> CONFIG_MTD_BLOCK=y
> CONFIG_MTD_CFI=y
> CONFIG_MTD_CFI_ADV_OPTIONS=y
> CONFIG_BLK_DEV_LOOP=y
> CONFIG_VIRTIO_BLK=y
> CONFIG_MD=y
> CONFIG_BLK_DEV_MD=y
> CONFIG_MD_RAID456=y
> CONFIG_INPUT_MOUSEDEV=y
> CONFIG_SERIAL_8250=y
> CONFIG_SERIAL_8250_CONSOLE=y
> CONFIG_SERIAL_8250_DW=y
> CONFIG_SERIAL_OF_PLATFORM=y
> CONFIG_SERIAL_SIFIVE=y
> CONFIG_SERIAL_SIFIVE_CONSOLE=y
> CONFIG_VIRTIO_CONSOLE=y
> CONFIG_HW_RANDOM_VIRTIO=y
> CONFIG_PINCTRL=y
> CONFIG_GPIOLIB=y
> CONFIG_GPIO_DWAPB=y
> CONFIG_GPIO_SIFIVE=y
> CONFIG_SOUND=y
> CONFIG_RTC_CLASS=y
> CONFIG_RTC_DRV_GOLDFISH=y
> CONFIG_DMADEVICES=y
> CONFIG_DW_AXI_DMAC=y
> CONFIG_VIRTIO_BALLOON=y
> CONFIG_VIRTIO_INPUT=y
> CONFIG_VIRTIO_MMIO=y
> CONFIG_GOLDFISH=y
> CONFIG_MAILBOX=y
> CONFIG_RPMSG_CTRL=y
> CONFIG_RPMSG_VIRTIO=y
> CONFIG_PM_DEVFREQ=y
> CONFIG_IIO=y
> CONFIG_LIBNVDIMM=y
> CONFIG_EXT4_FS=y
> CONFIG_EXT4_FS_POSIX_ACL=y
> CONFIG_EXT4_FS_SECURITY=y
> CONFIG_AUTOFS_FS=y
> CONFIG_ISO9660_FS=y
> CONFIG_JOLIET=y
> CONFIG_ZISOFS=y
> CONFIG_MSDOS_FS=y
> CONFIG_VFAT_FS=y
> CONFIG_PRINTK_TIME=y
> CONFIG_SCHED_STACK_END_CHECK=y
> # CONFIG_RCU_TRACE is not set
> # CONFIG_FTRACE is not set
> # CONFIG_RUNTIME_TESTING_MENU is not set
>
> I took the riscv/defconfig and added MD_RAID456 and it's dependencies.
> So that the message wasn't too long I started removing some unnecessary
> configs. Try this out and let me know if you encounter the issue.

I took the riscv/defconfig and set MD_RAID456=y, but didn't see this issue.
Since RAID6_PQ is selected by MD_RAID456, so RAID6_PQ=y, I got the
raid6 test result during kernel init.

[    0.317147] raid6: rvvx1    gen()    45 MB/s
[    0.390800] raid6: rvvx2    gen()    45 MB/s
[    0.459435] raid6: rvvx4    gen()    45 MB/s
[    0.527651] raid6: rvvx8    gen()    44 MB/s
[    0.596123] raid6: int64x8  gen()  1232 MB/s
[    0.664686] raid6: int64x4  gen()  2728 MB/s
[    0.733291] raid6: int64x2  gen()  3405 MB/s
[    0.801836] raid6: int64x1  gen()  2730 MB/s
[    0.801895] raid6: using algorithm int64x2 gen() 3405 MB/s
[    0.870379] raid6: .... xor() 493 MB/s, rmw enabled

Thanks,
Chunyan
