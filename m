Received: from mail-yb1-f170.google.com (mail-yb1-f170.google.com [209.85.219.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C53A28A2C1
	for <linux-raid@vger.kernel.org>; Thu, 13 Feb 2025 21:36:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739482604; cv=none; b=IUklgyn2gngYMNFRUwBgiHcINiGjuKYFhCae2the+cuYS26EcNJEaks1hLHWgfqD89mIvr3UqUBd/hPM+ulNW9qUb/xLU86PY4nBfiQSdzsZ8DVT7ozFd+vuYZub9qJY+oXCeOBRHovWsjA2dCf4jT9Y2NPYl09Qbml9ZxhUw2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739482604; c=relaxed/simple;
	bh=y9kaHwX3WWWfnPo9xpxWDyWUuMqA4NW0QsEmrgaeSIQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fUVSrfMcs0IILwmdBn4/VIUqdMf3u5gmHC5f3/jVUATJmF0Ly+SjQMvrcN4gFx5d+gbMKp5R1X45aL3roH3LxG3EH77dBCokYmer6wgPu8LDOol7iW/uhfUreAu1P4H66m3Wqlj6eZ8MuSREZzCksUObPSVO5NBWqmJ6Y7xGS+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=CVvIwUig; arc=none smtp.client-ip=209.85.219.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="CVvIwUig"
Received: by mail-yb1-f170.google.com with SMTP id 3f1490d57ef6-e587cca1e47so1307513276.0
        for <linux-raid@vger.kernel.org>; Thu, 13 Feb 2025 13:36:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1739482601; x=1740087401; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=tN5YgbLMf1aDRtVPiBKlBRhDfg2WRlderUDGvHcqbTY=;
        b=CVvIwUigfQdcm/VIjmCoTZkkscSL4yZbX9v/vRn28q7d328giDMCamPRrnK0TYSjoA
         sDPom8C+hWRD9H3hC88Vsp7WtiadiW8i7xKqtJSEGUkxRf4K0+9+eBhRfIivt4zNrzwm
         nT42HDGSB4BifhI5tTng8vYH/gbJPAhzwxypgxK1glj2DsUbK4lRiloTCfLCSfOJBiyj
         RfDadwVDair9R8JAmA7CF0TAk4qMgJxcx/MYqDMgX1KY3fhvaVybCQQ+1NPoeXJL2tQ4
         ixIpEAbyQwJe4GK4KY80lAtrDWyJuhpZfAC8uSjG10wwjwBXJZsq69itiTQVBIu3h/rV
         QH4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739482601; x=1740087401;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tN5YgbLMf1aDRtVPiBKlBRhDfg2WRlderUDGvHcqbTY=;
        b=MkWD18clK8AFPOWf9vquFnn/h3AbQDKMb561t4q6XwaeVuNvy9uMsMMBBqHbwbu3yw
         NhcCQ45zoa9zdaAA1vSOAbnQHPnAAf3AW840ZlQgK1DvB8vpgEadU0o1lPWL5ZOdVK4e
         hsF58F70QuBFrvGq7ZX5kcuoLKyc73DqD2myBN4AvdAEdFaWnvKBKddOPYPvCkeZtwEj
         IOeIXJM3HDcSchd0nf4EjAxbrpAfSvzw7zHezdzzssw2ejLGHX3gFnOBHf/uRc0RA2+r
         H8prWFwj88THHFRbKcQnL5v+TQcBy9HDtmwwtjeek3srldSSm3mj9U68A7EVXVGe4lB0
         4U0w==
X-Forwarded-Encrypted: i=1; AJvYcCV0SgeMOxqdJZQra5jFErt9lRzJgPDCUV7mKgyvvFEdfnDypnls61ensYTIpMMY74DNJRh48LJwbX6W@vger.kernel.org
X-Gm-Message-State: AOJu0YzSCe5eeLyJzidtVsrPQSAWFJhGGXeiQ5mcDbOjn1ZmpZ9wf/EN
	rLd9CwvREJFVHEMMxmTooMz3zOOCMeTSV+kDSs0pLxKkQURxyoHdPagnwrPRSh8=
X-Gm-Gg: ASbGncs/Mmi1pYa0WqzSId6XS0vPzUOJehjK3G41A6t7j6mTMiRIl7m2ewJuSiEmlUf
	lzoEW6grfkfBK15dW7q4WiKNHPWrhgbfACiqYbMX8UimE9BklOsXF0sRZ/MUZdfzbKvWo4TWHFz
	jausCJOmHhNfLICoVDYQw6MTP7NF6weETz7p6MMde7LYG7OFn5d9G9ixR4Emy75qk6hOSQDnh/e
	90/Lp850kuZP0Tz0J7Gsrf2cLqTy7QEvyeMbjR1m7dXALtBzGGg2AscwRqf6wTkPa61HiIFTA/z
	7eQ=
X-Google-Smtp-Source: AGHT+IFrZXty2zvWMcfr9wxzGzvWLUXiH8mGsSyxSxV6zHOMIiY7RNEUKUZiPnL5TCqkmw//gUw1NA==
X-Received: by 2002:a05:6902:1186:b0:e5b:1dda:8f6a with SMTP id 3f1490d57ef6-e5da0209accmr8160531276.12.1739482601327;
        Thu, 13 Feb 2025 13:36:41 -0800 (PST)
Received: from ghost ([50.146.0.9])
        by smtp.gmail.com with ESMTPSA id 3f1490d57ef6-e5dae0da26csm595254276.44.2025.02.13.13.36.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Feb 2025 13:36:40 -0800 (PST)
Date: Thu, 13 Feb 2025 13:36:39 -0800
From: Charlie Jenkins <charlie@rivosinc.com>
To: Chunyan Zhang <zhang.lyra@gmail.com>
Cc: Paul Menzel <pmenzel@molgen.mpg.de>,
	Chunyan Zhang <zhangchunyan@iscas.ac.cn>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>, linux-riscv@lists.infradead.org,
	linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] raid6: Add RISC-V SIMD syndrome and recovery
 calculations
Message-ID: <Z65l51hrDmKQP6dM@ghost>
References: <20250127061529.2437012-1-zhangchunyan@iscas.ac.cn>
 <c0a2fbeb-9a0d-4b69-bc6b-e1652e13debf@molgen.mpg.de>
 <Z5gJ35pXI2W41QDk@ghost>
 <CAAfSe-utAb53278x9X4tKn6jWzdehsPKDRa_CoQy61ND=cXbxQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAfSe-utAb53278x9X4tKn6jWzdehsPKDRa_CoQy61ND=cXbxQ@mail.gmail.com>

On Tue, Feb 11, 2025 at 05:59:26PM +0800, Chunyan Zhang wrote:
> On Tue, 28 Jan 2025 at 06:34, Charlie Jenkins <charlie@rivosinc.com> wrote:
> >
> > On Mon, Jan 27, 2025 at 09:39:11AM +0100, Paul Menzel wrote:
> > > Dear Chunyan,
> > >
> > >
> > > Thank you for the patch.
> > >
> > >
> > > Am 27.01.25 um 07:15 schrieb Chunyan Zhang:
> > > > The assembly is originally based on the ARM NEON and int.uc, but uses
> > > > RISC-V vector instructions to implement the RAID6 syndrome and
> > > > recovery calculations.
> > > >
> > > > Results on QEMU running with the option "-icount shift=0":
> > > >
> > > >    raid6: rvvx1    gen()  1008 MB/s
> > > >    raid6: rvvx2    gen()  1395 MB/s
> > > >    raid6: rvvx4    gen()  1584 MB/s
> > > >    raid6: rvvx8    gen()  1694 MB/s
> > > >    raid6: int64x8  gen()   113 MB/s
> > > >    raid6: int64x4  gen()   116 MB/s
> > > >    raid6: int64x2  gen()   272 MB/s
> > > >    raid6: int64x1  gen()   229 MB/s
> > > >    raid6: using algorithm rvvx8 gen() 1694 MB/s
> > > >    raid6: .... xor() 1000 MB/s, rmw enabled
> > > >    raid6: using rvv recovery algorithm
> > >
> > > How did you start QEMU and on what host did you run it? Does it change
> > > between runs? (For me these benchmark values were very unreliable in the
> > > past on x86 hardware.)
> >
> > I reported dramatic gains on vector as well in this response [1]. Note
> > that these gains are only present when using the QEMU option "-icount
> > shift=0" vector becomes dramatically more performant. Without this
> > option we do not see a performance gain on QEMU. However riscv vector is
> > known to not be less optimized on QEMU so having vector be less
> > performant on some QEMU configurations is not necessarily representative
> > of hardware implementations.
> >
> >
> > My full qemu command is (running on x86 host):
> >
> > qemu-system-riscv64 -nographic -m 1G -machine virt -smp 1\
> >     -kernel arch/riscv/boot/Image \
> >     -append "root=/dev/vda rw earlycon console=ttyS0" \
> >     -drive file=rootfs.ext2,format=raw,id=hd0,if=none \
> >     -bios default -cpu rv64,v=true,vlen=256,vext_spec=v1.0 \
> >     -device virtio-blk-device,drive=hd0
> >
> > This is with version 9.2.0.
> >
> >
> > I am also facing this issue when executing this:
> >
> > raid6: rvvx1    gen()   717 MB/s
> > raid6: rvvx2    gen()   734 MB/s
> > Unable to handle kernel NULL pointer dereference at virtual address 0000000000000020
> >
> > Only rvvx4 is failing. I applied this patch to 6.13.
> 
> I used your command to run but no issue on my side (x86 host, qemu
> version is 9.2.0, kernel 6.13 too):
> 
> qemu-system-riscv64 -nographic -m 1G -machine virt -smp 1 -icount shift=0 \
>         -kernel arch/riscv/boot/Image   \
>         -append "rootwait root=/dev/vda ro"     \
>         -drive file=rootfs.ext4,format=raw,id=hd0 \
>         -bios default -cpu rv64,v=true,vlen=256,vext_spec=v1.0 \
>         -device virtio-blk-device,drive=hd0

I am able to reproduce it with this defconfig:

CONFIG_SYSVIPC=y
CONFIG_NO_HZ_IDLE=y
CONFIG_HIGH_RES_TIMERS=y
CONFIG_BPF_SYSCALL=y
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_NAMESPACES=y
CONFIG_USER_NS=y
CONFIG_CHECKPOINT_RESTORE=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_EXPERT=y
# CONFIG_SYSFS_SYSCALL is not set
CONFIG_PROFILING=y
CONFIG_SMP=y
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_STAT=y
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
CONFIG_CPUFREQ_DT=y
CONFIG_JUMP_LABEL=y
CONFIG_DEVTMPFS=y
CONFIG_DEVTMPFS_MOUNT=y
CONFIG_MTD=y
CONFIG_MTD_BLOCK=y
CONFIG_MTD_CFI=y
CONFIG_MTD_CFI_ADV_OPTIONS=y
CONFIG_BLK_DEV_LOOP=y
CONFIG_VIRTIO_BLK=y
CONFIG_MD=y
CONFIG_BLK_DEV_MD=y
CONFIG_MD_RAID456=y
CONFIG_INPUT_MOUSEDEV=y
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_SERIAL_8250_DW=y
CONFIG_SERIAL_OF_PLATFORM=y
CONFIG_SERIAL_SIFIVE=y
CONFIG_SERIAL_SIFIVE_CONSOLE=y
CONFIG_VIRTIO_CONSOLE=y
CONFIG_HW_RANDOM_VIRTIO=y
CONFIG_PINCTRL=y
CONFIG_GPIOLIB=y
CONFIG_GPIO_DWAPB=y
CONFIG_GPIO_SIFIVE=y
CONFIG_SOUND=y
CONFIG_RTC_CLASS=y
CONFIG_RTC_DRV_GOLDFISH=y
CONFIG_DMADEVICES=y
CONFIG_DW_AXI_DMAC=y
CONFIG_VIRTIO_BALLOON=y
CONFIG_VIRTIO_INPUT=y
CONFIG_VIRTIO_MMIO=y
CONFIG_GOLDFISH=y
CONFIG_MAILBOX=y
CONFIG_RPMSG_CTRL=y
CONFIG_RPMSG_VIRTIO=y
CONFIG_PM_DEVFREQ=y
CONFIG_IIO=y
CONFIG_LIBNVDIMM=y
CONFIG_EXT4_FS=y
CONFIG_EXT4_FS_POSIX_ACL=y
CONFIG_EXT4_FS_SECURITY=y
CONFIG_AUTOFS_FS=y
CONFIG_ISO9660_FS=y
CONFIG_JOLIET=y
CONFIG_ZISOFS=y
CONFIG_MSDOS_FS=y
CONFIG_VFAT_FS=y
CONFIG_PRINTK_TIME=y
CONFIG_SCHED_STACK_END_CHECK=y
# CONFIG_RCU_TRACE is not set
# CONFIG_FTRACE is not set
# CONFIG_RUNTIME_TESTING_MENU is not set

I took the riscv/defconfig and added MD_RAID456 and it's dependencies.
So that the message wasn't too long I started removing some unnecessary
configs. Try this out and let me know if you encounter the issue.

- Charlie

> 
> Thanks,
> Chunyan
> 
> >
> > - Charlie
> >
