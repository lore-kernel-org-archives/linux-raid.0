Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCB421DF725
	for <linux-raid@vger.kernel.org>; Wed, 25 Jun 2025 05:27:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750829236; cv=none; b=bOyn6ie1Ae0c0CdDOKV70w/Muk7aFulUUK+x3SdeDuG/II8A5eXEgP5sSui+DSvryHM3qtrRSaZZX4f6SSnGd7nlFmdSKGCcsVthRmxujaZkBdqTXV4VmvntyeRsMVuKKUA3HqtKjm+OHEiVjHNTGrSD750spYy8l8LgbKY0vP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750829236; c=relaxed/simple;
	bh=LbnRgsJqaYQR3w0VmAPK39nvGAGLmgdt/bvT0e9diq8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=C+BFB+eqW/cinUEFAVPzr19S3BU9ipEFMOESXhd+KlP6m8Ov4hlWrRSHAK1Wqp27wl3irRaOxMIn1S1li0rYmrS3ZYle/qfhAQepqcMsxMeS+I4Lh9fbj+FjwnlfCupwCr0x/BV2dftMXppRJBmSRwkrEJMBkuoXbei1+7aAdMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=K9xzoBcm; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="K9xzoBcm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750829233;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mpRDJtOibAN+hjHG0vQSfnGW8FBJuEequnOWRE9i4jE=;
	b=K9xzoBcmhvEkNPuiJDHEP0P1H4iyYj235EOSYoXlzupfdOOBRBvL/ojZ2lbQ2zPyhUQNsS
	g/U+YYbFin9KK7x3zj6K06tGaq1QwbxlYSi9wN2Yh18gn4/qEs3+8VOIIQn0c5W4b4eEIw
	2+Io61jy+7zpLCnwH/VK9huIQ7Q9IR8=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-414-mGSPK6XUNSidJLVcg53IPg-1; Wed, 25 Jun 2025 01:27:10 -0400
X-MC-Unique: mGSPK6XUNSidJLVcg53IPg-1
X-Mimecast-MFC-AGG-ID: mGSPK6XUNSidJLVcg53IPg_1750829229
Received: by mail-lj1-f198.google.com with SMTP id 38308e7fff4ca-32b316235a2so25659651fa.0
        for <linux-raid@vger.kernel.org>; Tue, 24 Jun 2025 22:27:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750829228; x=1751434028;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mpRDJtOibAN+hjHG0vQSfnGW8FBJuEequnOWRE9i4jE=;
        b=i8xKKIbJ/HGDlCjYvBKcnoUAscavkwqQnWqTMp3aqUGCbOzVHaKf4dLEyqFNDEE2l4
         qs7iH5LLmcA15+/ulNn490ca7xrEhIt4le7W6tZFOMZ8fWTdyy8etJIGkY4LN3iIiP+5
         o6B8YKOdR+UBE0D+fgLSIiJO+w55yNbMl6IVtHC8lZaeo8OHBl6ZftMiIIjr4tOdNJLD
         U9IBH1JWgMBIWYuljd3etMQnuOrGMfdvM0+c6TkQ2th1NiFCqKA17owfh0zcKyhqVT5X
         ZQ8C9Nl2wSS0EfZXdEHIAPRJd7qeshs9tBr4ibhpLLV4uP2ZVh7bCXiiCa70InQQ6ZHu
         i05w==
X-Forwarded-Encrypted: i=1; AJvYcCX2t12pF86H8Jx9ZsQCEm0ln5g/wqjl2I8dnQmjsEB82vZjozASnhW5BDF2dCz55VKZ8Adary+M5HPd@vger.kernel.org
X-Gm-Message-State: AOJu0Yx1dZKg35djMj22Uky+PjX6E5mmpRPZ5mCKkmIraB5geyRU0N4B
	F8Lzx1q85AsfKbuXUXN4ol1JuJAka5B8qTUzuTXcDzZ6rgSgrVt3FnR8wQ/RmXLynESr9C1JnSc
	0yy5Mbjh0ZLDbV8SfvBZ6qcqzHS8rdqIHxvd4CTelp/PAzYR3Hr/ORPfr/p9AJhBr6IYYUyFM+L
	GHT0vgZqIBVUAgqSQ+EDvR1bhtkFiQGzRkqWzcSw==
X-Gm-Gg: ASbGncv6L+gxs6/4Rbxg99p/sLk9UG/9wPc2kumlqsilq1/LzsvlLsk0WOjKs0oVXwK
	UB1kNCI5E5JZyeiTlOrZ4DhzwGLdJCU/MQLITm1KWzn0R9kZAXykh6k7OpCZC+Q9iHCOGOD4AKm
	xtDiyi
X-Received: by 2002:a05:651c:2105:b0:32b:8e39:b0c7 with SMTP id 38308e7fff4ca-32cc65c8421mr3102431fa.40.1750829228032;
        Tue, 24 Jun 2025 22:27:08 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE4iD6cGnxdZpUazM6a1CSqutw5GLV74iOBbDL8UdlQVnJmXxorI9+IC+cjSOu6aWAn2nDVewdVsiUwVpu04+c=
X-Received: by 2002:a05:651c:2105:b0:32b:8e39:b0c7 with SMTP id
 38308e7fff4ca-32cc65c8421mr3102331fa.40.1750829227527; Tue, 24 Jun 2025
 22:27:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <202506201427.baf6fdc2-lkp@intel.com> <CALTww2-0v=60uxbgd=ideL8XQM0Tp_ZOwOkNhTrthC-U+zt4Hg@mail.gmail.com>
 <aFtgsw+bARwZSQQI@xsang-OptiPlex-9020>
In-Reply-To: <aFtgsw+bARwZSQQI@xsang-OptiPlex-9020>
From: Xiao Ni <xni@redhat.com>
Date: Wed, 25 Jun 2025 13:26:55 +0800
X-Gm-Features: Ac12FXyOmw8RcnOj0aLzkzz5hWpInf0qH4Sz2bl3LkDQ77l25u-JtaLCzbSh4hQ
Message-ID: <CALTww2_xT2Awcn4V+NS1kwsWv0p2z+e+Y155Y-LhKm9cGPrH3A@mail.gmail.com>
Subject: Re: [mdraid:md-6.16] [md] bc8ce8eaa2: mdadm-selftests.05r1-failfast.fail
To: Oliver Sang <oliver.sang@intel.com>
Cc: oe-lkp@lists.linux.dev, lkp@intel.com, Yu Kuai <yukuai3@huawei.com>, 
	linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 25, 2025 at 10:37=E2=80=AFAM Oliver Sang <oliver.sang@intel.com=
> wrote:
>
> hi, Xiao,
>
> On Tue, Jun 24, 2025 at 04:36:45PM +0800, Xiao Ni wrote:
> > Hi
> >
> > It needs to use the https://github.com/md-raid-utilities/mdadm/ to do
> > regression tests
>
> just FYI. we really use test from this link:
>
> https://github.com/intel/lkp-tests/blob/master/programs/mdadm-selftests/p=
kg/PKGBUILD
>
> pkgname=3Dmdadm-selftests
> pkgver=3Dgit
> pkgrel=3D1
> url=3D'https://github.com/md-raid-utilities/mdadm'
> arch=3D('i386' 'x86_64' 'aarch64')
> license=3D('GPL')
> source=3D('mdadm-selftests'::'https://github.com/md-raid-utilities/mdadm.=
git')
> md5sums=3D('SKIP')

Thanks for the clarification. I'm looking at this problem.

Regards
Xiao
>
> >
> > Best Regards
> > Xiao
> >
> > On Tue, Jun 24, 2025 at 3:55=E2=80=AFPM kernel test robot <oliver.sang@=
intel.com> wrote:
> > >
> > >
> > >
> > > Hello,
> > >
> > > kernel test robot noticed "mdadm-selftests.05r1-failfast.fail" on:
> > >
> > > commit: bc8ce8eaa290a198cb5303181041aad037299b7f ("md: call del_gendi=
sk in control path")
> > > https://git.kernel.org/cgit/linux/kernel/git/mdraid/linux md-6.16
> > >
> > > in testcase: mdadm-selftests
> > > version: mdadm-selftests-x86_64-0550fb37-1_20250518
> > > with following parameters:
> > >
> > >         disk: 1HDD
> > >         test_prefix: 05r1-failfast
> > >
> > >
> > >
> > > config: x86_64-rhel-9.4-func
> > > compiler: gcc-12
> > > test machine: 8 threads 1 sockets Intel(R) Core(TM) i7-4790T CPU @ 2.=
70GHz (Haswell) with 16G memory
> > >
> > > (please refer to attached dmesg/kmsg for entire log/backtrace)
> > >
> > >
> > >
> > >
> > > If you fix the issue in a separate patch/commit (i.e. not just a new =
version of
> > > the same patch/commit), kindly add following tags
> > > | Reported-by: kernel test robot <oliver.sang@intel.com>
> > > | Closes: https://lore.kernel.org/oe-lkp/202506201427.baf6fdc2-lkp@in=
tel.com
> > >
> > > 2025-06-19 10:07:43 mkdir -p /var/tmp
> > > 2025-06-19 10:07:43 mke2fs -t ext3 -b 4096 -J size=3D4 -q /dev/sda1
> > > 2025-06-19 10:08:14 mount -t ext3 /dev/sda1 /var/tmp
> > > /usr/bin/install -D  -m 755 mdadm /sbin/mdadm
> > > /usr/bin/install -D  -m 755 mdmon /sbin/mdmon
> > > sed -e 's/{DEFAULT_METADATA}/1.2/g' \
> > > -e 's,{MAP_PATH},/run/mdadm/map,g' -e 's,{CONFFILE},/etc/mdadm.conf,g=
' \
> > > -e 's,{CONFFILE2},/etc/mdadm/mdadm.conf,g'  mdadm.8.in > mdadm.8
> > > sed -e 's,{CONFFILE},/etc/mdadm.conf,g' \
> > > -e 's,{CONFFILE2},/etc/mdadm/mdadm.conf,g'  mdadm.conf.5.in > mdadm.c=
onf.5
> > > /usr/bin/install -D -m 644 mdadm.8 /usr/share/man/man8/mdadm.8
> > > /usr/bin/install -D -m 644 mdmon.8 /usr/share/man/man8/mdmon.8
> > > /usr/bin/install -D -m 644 md.4 /usr/share/man/man4/md.4
> > > /usr/bin/install -D -m 644 mdadm.conf.5 /usr/share/man/man5/mdadm.con=
f.5
> > > /usr/bin/install -D -m 644 udev-md-raid-creating.rules /lib/udev/rule=
s.d/01-md-raid-creating.rules
> > > /usr/bin/install -D -m 644 udev-md-raid-arrays.rules /lib/udev/rules.=
d/63-md-raid-arrays.rules
> > > /usr/bin/install -D -m 644 udev-md-raid-assembly.rules /lib/udev/rule=
s.d/64-md-raid-assembly.rules
> > > /usr/bin/install -D -m 644 udev-md-clustered-confirm-device.rules /li=
b/udev/rules.d/69-md-clustered-confirm-device.rules
> > >  [1;33mWarning! Tests are performed on system level mdadm!
> > >  [0mIf you want to test local build, you need to install it first!
> > > test: skipping tests for multipath, which is removed in upstream 6.8+=
 kernels
> > >  [1;33mWarning! Test suite will set up systemd environment!
> > >  [0mUse "systemctl show-environment" to show systemd environment vari=
ables
> > > Added IMSM_DEVNAME_AS_SERIAL=3D1 to systemd environment, use "systemc=
tl unset-environment IMSM_DEVNAME_AS_SERIAL=3D1" to remove it.
> > > Added IMSM_NO_PLATFORM=3D1 to systemd environment, use "systemctl uns=
et-environment IMSM_NO_PLATFORM=3D1" to remove it.
> > > Testing on linux-6.15.0-02014-gbc8ce8eaa290 kernel
> > > /lkp/benchmarks/mdadm-selftests/tests/05r1-failfast... Execution time=
 (seconds): 8  [0;31mFAILED [0m - see /var/tmp/05r1-failfast.log and /var/t=
mp/fail05r1-failfast.log for details
> > > Removed IMSM_DEVNAME_AS_SERIAL=3D1 from systemd environment.
> > > Removed IMSM_NO_PLATFORM=3D1 from systemd environment.
> > >
> > >
> > >
> > > The kernel config and materials to reproduce are available at:
> > > https://download.01.org/0day-ci/archive/20250620/202506201427.baf6fdc=
2-lkp@intel.com
> > >
> > >
> > >
> > > --
> > > 0-DAY CI Kernel Test Service
> > > https://github.com/intel/lkp-tests/wiki
> > >
> > >
> >
>

