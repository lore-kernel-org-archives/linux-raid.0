Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0009139E
	for <linux-raid@vger.kernel.org>; Wed, 25 Jun 2025 07:44:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750837460; cv=none; b=nu94IFtkj8rAVKMCqsMMuBSafOFJ4rx076xWObG2BDP4ZI2l2Vjef7IJjMVC0Kb0fNBujg94/luIWyUt/30QYb25f81NxTTJQk1AgCYOcsiReuXmRzXVv4orIosiwbLVIsSkf3gBcy3McHLYtf7L+jT+20EizA1fKatcJTEJwvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750837460; c=relaxed/simple;
	bh=y6qnYVDOlkwwPsr1sG3aym1xvFneFWPsyjJHEdBM/BE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cYqjV659tDKdMNwcO22vMirdwoub0yBuuu10E6vZQOWWjlROF1WIVYQaSYnPBCVNQ5c0/MvAka5HChc//KfRcUzWZrXWnwXa5Xkv7e7YqUPpDM1a5Xk96xgS/apMVU6U+9ek6mL5F4kuOC4uLg5ZHhLP/Ij8LqY1xAH5XoEdi50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BsMDdHZ7; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BsMDdHZ7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750837457;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bPtnrt+0fA/ESXO7ev0B7D6xeStoCJnHv9m8deDJhd4=;
	b=BsMDdHZ7kDqlPxGtOoxG2C6GVSpt7cLi/ReCk5hN6CzXvWNkQ+ILO6PdaIqLaxaYWF2Ni1
	9x7ByimpYjD97T7m8V+Q1s8vsBI8hbV8uwB/tO3mG98SYfdHaDaYnPnumaFRwYrFvubg/U
	wq9+euaG2rUKDieC46xUpUNT3tnhsTs=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-132-m3P_7n2BP5iZlmCpaDlzIw-1; Wed, 25 Jun 2025 03:44:15 -0400
X-MC-Unique: m3P_7n2BP5iZlmCpaDlzIw-1
X-Mimecast-MFC-AGG-ID: m3P_7n2BP5iZlmCpaDlzIw_1750837454
Received: by mail-lf1-f69.google.com with SMTP id 2adb3069b0e04-5533439602bso659877e87.2
        for <linux-raid@vger.kernel.org>; Wed, 25 Jun 2025 00:44:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750837451; x=1751442251;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bPtnrt+0fA/ESXO7ev0B7D6xeStoCJnHv9m8deDJhd4=;
        b=U7hhEApD589bH35JT0uQkTXotp7dZ7WHic2twdPszb1HbEGjXAVg3Dwf51eSLidJKT
         adTvaY7892N7q7e7Ly0AEgIKxEvlztsa7oRGZwcFeVqh55NBgtrG+XwZxjqANLVM4ySl
         iVgwVFdM5VnKDNrGZfmHA+pLiVBCE9lWatSJx2VQOjgk7VR4568hNU87MLM/VjpISi21
         lfH8uUKrE1Af7ZnrNpPwCu+JI7wS/vXGaBQo7gI+lmmFnXHKRQZuD1ZmRRGIgl6fgUou
         8HH8782omxLfyzK3NEdojNKs11KhvTK66+gNRApeZA5ZNQWBTqs9UH80AuE/bJreuVXj
         2Huw==
X-Forwarded-Encrypted: i=1; AJvYcCURdoV3cOR9Xfo2nyfSxsHu9ESeByLmHTCRUO8HfBIW3V0WA0d0LzKJ0nNjIdOOXISzSVumMY16KPHZ@vger.kernel.org
X-Gm-Message-State: AOJu0Yw1Ncmh5mmLHRjXtKHsSUut1ln+nEjA4W7FG5KOvBDUQTdFa1cQ
	vIbf25xUU9MtWoAgyHZ59/IktdAxLLuq+pQJnjbkC1GMNab5NwxZsM0G811OzlgBWcG1Xb9WLb3
	ZZX0101rAp9lPgd5TX+KNG7KtC0GasEEAOMKZtsBoFgRI7Iw72XGwY2ZmnRbIXjPjHvmH+pAv9i
	jXySZceBRsnnqFhooulCyhnKvQJaat2lLLPdUfLA==
X-Gm-Gg: ASbGnctsYxXl+kma3y0o6QoN9Q0hneOOyRb4YRqmn5yYxbJIE26+2LMwvSGZGMPaukK
	4UDMbUA9dBxtzDeZZ2eCyvC7tENO7p/oylvBY8iHVGtT55gmcDcszjU8ObSUrtp8ERvzVURrPTV
	ziinfd
X-Received: by 2002:a05:6512:2510:b0:554:e7f2:d75d with SMTP id 2adb3069b0e04-554fdcd6b7fmr606955e87.4.1750837451409;
        Wed, 25 Jun 2025 00:44:11 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGsIcrdypMzPP4PGEsnczRLvnexl8lighD7BCjtatXGUqAX8+QpvykwNUf09v2r5vhGpOd22x0e9Uvf1VJbN8Q=
X-Received: by 2002:a05:6512:2510:b0:554:e7f2:d75d with SMTP id
 2adb3069b0e04-554fdcd6b7fmr606947e87.4.1750837450977; Wed, 25 Jun 2025
 00:44:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <202506201427.baf6fdc2-lkp@intel.com>
In-Reply-To: <202506201427.baf6fdc2-lkp@intel.com>
From: Xiao Ni <xni@redhat.com>
Date: Wed, 25 Jun 2025 15:43:58 +0800
X-Gm-Features: Ac12FXz1A1YpLdu27G6clImY6U0RbdPccOPQlw7Q21MOlBCc5f55xQaOO2knU8U
Message-ID: <CALTww28=jOrcKTpKQPAcYQV1btic-_wwE3PjfA-hUAokZGhXwA@mail.gmail.com>
Subject: Re: [mdraid:md-6.16] [md] bc8ce8eaa2: mdadm-selftests.05r1-failfast.fail
To: kernel test robot <oliver.sang@intel.com>
Cc: oe-lkp@lists.linux.dev, lkp@intel.com, Yu Kuai <yukuai3@huawei.com>, 
	linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi all

I've run 05r1-failfast about 50 times and can't reproduce this problem.

The kernel version: branch md-6.16 of
https://git.kernel.org/pub/scm/linux/kernel/git/mdraid/linux.git
The mdadm version: main branch of https://github.com/md-raid-utilities/mdad=
m

Regards
Xiao

On Tue, Jun 24, 2025 at 3:55=E2=80=AFPM kernel test robot <oliver.sang@inte=
l.com> wrote:
>
>
>
> Hello,
>
> kernel test robot noticed "mdadm-selftests.05r1-failfast.fail" on:
>
> commit: bc8ce8eaa290a198cb5303181041aad037299b7f ("md: call del_gendisk i=
n control path")
> https://git.kernel.org/cgit/linux/kernel/git/mdraid/linux md-6.16
>
> in testcase: mdadm-selftests
> version: mdadm-selftests-x86_64-0550fb37-1_20250518
> with following parameters:
>
>         disk: 1HDD
>         test_prefix: 05r1-failfast
>
>
>
> config: x86_64-rhel-9.4-func
> compiler: gcc-12
> test machine: 8 threads 1 sockets Intel(R) Core(TM) i7-4790T CPU @ 2.70GH=
z (Haswell) with 16G memory
>
> (please refer to attached dmesg/kmsg for entire log/backtrace)
>
>
>
>
> If you fix the issue in a separate patch/commit (i.e. not just a new vers=
ion of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <oliver.sang@intel.com>
> | Closes: https://lore.kernel.org/oe-lkp/202506201427.baf6fdc2-lkp@intel.=
com
>
> 2025-06-19 10:07:43 mkdir -p /var/tmp
> 2025-06-19 10:07:43 mke2fs -t ext3 -b 4096 -J size=3D4 -q /dev/sda1
> 2025-06-19 10:08:14 mount -t ext3 /dev/sda1 /var/tmp
> /usr/bin/install -D  -m 755 mdadm /sbin/mdadm
> /usr/bin/install -D  -m 755 mdmon /sbin/mdmon
> sed -e 's/{DEFAULT_METADATA}/1.2/g' \
> -e 's,{MAP_PATH},/run/mdadm/map,g' -e 's,{CONFFILE},/etc/mdadm.conf,g' \
> -e 's,{CONFFILE2},/etc/mdadm/mdadm.conf,g'  mdadm.8.in > mdadm.8
> sed -e 's,{CONFFILE},/etc/mdadm.conf,g' \
> -e 's,{CONFFILE2},/etc/mdadm/mdadm.conf,g'  mdadm.conf.5.in > mdadm.conf.=
5
> /usr/bin/install -D -m 644 mdadm.8 /usr/share/man/man8/mdadm.8
> /usr/bin/install -D -m 644 mdmon.8 /usr/share/man/man8/mdmon.8
> /usr/bin/install -D -m 644 md.4 /usr/share/man/man4/md.4
> /usr/bin/install -D -m 644 mdadm.conf.5 /usr/share/man/man5/mdadm.conf.5
> /usr/bin/install -D -m 644 udev-md-raid-creating.rules /lib/udev/rules.d/=
01-md-raid-creating.rules
> /usr/bin/install -D -m 644 udev-md-raid-arrays.rules /lib/udev/rules.d/63=
-md-raid-arrays.rules
> /usr/bin/install -D -m 644 udev-md-raid-assembly.rules /lib/udev/rules.d/=
64-md-raid-assembly.rules
> /usr/bin/install -D -m 644 udev-md-clustered-confirm-device.rules /lib/ud=
ev/rules.d/69-md-clustered-confirm-device.rules
>  [1;33mWarning! Tests are performed on system level mdadm!
>  [0mIf you want to test local build, you need to install it first!
> test: skipping tests for multipath, which is removed in upstream 6.8+ ker=
nels
>  [1;33mWarning! Test suite will set up systemd environment!
>  [0mUse "systemctl show-environment" to show systemd environment variable=
s
> Added IMSM_DEVNAME_AS_SERIAL=3D1 to systemd environment, use "systemctl u=
nset-environment IMSM_DEVNAME_AS_SERIAL=3D1" to remove it.
> Added IMSM_NO_PLATFORM=3D1 to systemd environment, use "systemctl unset-e=
nvironment IMSM_NO_PLATFORM=3D1" to remove it.
> Testing on linux-6.15.0-02014-gbc8ce8eaa290 kernel
> /lkp/benchmarks/mdadm-selftests/tests/05r1-failfast... Execution time (se=
conds): 8  [0;31mFAILED [0m - see /var/tmp/05r1-failfast.log and /var/tmp/f=
ail05r1-failfast.log for details
> Removed IMSM_DEVNAME_AS_SERIAL=3D1 from systemd environment.
> Removed IMSM_NO_PLATFORM=3D1 from systemd environment.
>
>
>
> The kernel config and materials to reproduce are available at:
> https://download.01.org/0day-ci/archive/20250620/202506201427.baf6fdc2-lk=
p@intel.com
>
>
>
> --
> 0-DAY CI Kernel Test Service
> https://github.com/intel/lkp-tests/wiki
>
>

