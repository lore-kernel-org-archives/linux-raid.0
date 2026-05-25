Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B0CE29E110
	for <linux-raid@vger.kernel.org>; Mon, 25 May 2026 15:08:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779721738; cv=pass; b=IiugIAWtYVywnsh0Rxrcv9sNtlVHPdndlAS2Lz3YhEGqEbP0ApYnvskK1Tv0k7Cve/kPOEM6AKISqW7fY7j+LDXqe/pLMJRTUwdCYr5ohr87OoG+h+1rlxoCzJN2OFuECWu33fc6lLXkULRC6q7HCooxtx3ZthkiywZGRGg6q78=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779721738; c=relaxed/simple;
	bh=iFQ2ZOjn+JHBBDVGMHEhzdR+gtUMj0Ko7Swnm8GRoTk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=J5vxa8Aia1xpIPeuApq+dToYmZjKolSWln70W15PTaeHjSgid/R8RZT2diukm0P3z9usR84dKsViv+uOtP1WxNuKpIbZJ577XmpU5huioq5mSFTHFjF8Pjp9R9KefLva3CLzNSOGYM10iFU022qxANrUQmtH7BSczezW6Kpvdj8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TjGQcLek; arc=pass smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TjGQcLek"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-bd8f6ef4ba6so1427360066b.3
        for <linux-raid@vger.kernel.org>; Mon, 25 May 2026 08:08:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779721735; cv=none;
        d=google.com; s=arc-20240605;
        b=GenvItrlt6ULGRo0VWfSj6GQZFa27+c/fS+v+LzgBmx3DPRbF8X1B6z8sYRBpLvY3s
         bbXl3q19Qgbqz8KUERbo6FZyyZoYTT6fYrUTwnK+mOXuEEbjhrc3SWorAWkl8DapQIxV
         gnYiqlxALmKHwRZDFbOHHTU3AJVZ2gBog8bDPpuxOAa96fdSugZ/hVnL0BZTYHvDz3M0
         pXKM7G7p6xqq+DOdIu0NTIE1RsdmHTlbu0DXz52EYj/fJKRcEU6E7RFmKYsat00mbxuh
         cWQYtS3Rkw+GKngGoJRHaUUdXTKfskxUl6FG5mDlzWozD4sHZX47LIKOgrarneqE6Gpx
         AKmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=2a599TmGN+kn0C010BrnZYZisYw71X1lTvTBaPmx1z8=;
        fh=PZpY5pX+ZDYjH6O92LHrRYbgWeMc3WMCBOkY6GERUhQ=;
        b=UBJd1Ws+zqDnYa+fsoOhSH2Wef3xx/TC81DzeEAXoH4iEsG0M0yQcfrdOvf8yFRYkA
         QHm9Oi3boKRGIgY9pOMu85gUW3X+G6OIgzHRTC1VDz1ICMWRsxaWLm4SD4GTG2AaDckS
         x/Sad0KTah+28DMW+GpkLjLrG9v3NR7UfT/ifrO3LJvGY1sZgc1j+Z32BbPWMBAlf40k
         9lGGGT9aip3ZY2W65ZBpV4D9zydWlZkhmtZggUtXQRuev84QvLhECFZJlicue06iKX1j
         yy7FNKQ9840xf6i7zCQnRwf1C3+eWR6XvDnMGNrNyVrxXjkEAwaw4owykHODn31XGPzX
         rZBg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779721735; x=1780326535; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2a599TmGN+kn0C010BrnZYZisYw71X1lTvTBaPmx1z8=;
        b=TjGQcLekub74gPUdWLbkh0vX78LrOAUr0/XtCnWVt0AqJb8e+mzfarO7T5qzbXjPuQ
         ON42K3hLgfJK6KJD1J2CZAkrURsVR2XuVsDYATGuugjrK3yDMJSSPp4PCQHpIQMrxjRX
         x0mswI4cnQzT2eQnib2lueX50yW8emTLvJeIFTLXkT8WJtylct+V7nvSic1m9BhazIJ6
         It65HLj9T3AXFtT0owv6id4GqMTQVlUJsUyJEdCXTzfx83IaAcx5Ilfg0OOBcKIlwkTz
         fI6JRgUALD6KEHQ2Tw6OWAvD/Cfyi3z5O19Dq4LnjeCvVcaLytdELZNklGA9rtHpPtRV
         zPSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779721735; x=1780326535;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2a599TmGN+kn0C010BrnZYZisYw71X1lTvTBaPmx1z8=;
        b=e7X9ssAa25DSy4VhpjSx0KxmgwIKWHMsiAxReZRsxfenre4odU/1QSOtkwAG0glfSC
         9BP4qhiXruO9C7V+Obom1bgbHvIggDU9pSKA/v6JwUxzZIs9VSCnJ+RYa00zmZ7mlxKu
         ryBUNre6KhBLiS1P5ZqJHBGTCZMUEsYcBPuYD+LsvxrSODE2yAMC0hiyzAWbZlCO4D6s
         H/ivEyCcKMu6tii/+TlN5gYH4zdgYMsPguOGlK+zx2P91u7ZNWMxKsSwtRMG025fAC4w
         F8Zr8bJZq96vFnB0a7aiOBUDQj0X5ilWIyCbEUuFjvyx72YFCfng85tsaC43M4ju8T4U
         2w1Q==
X-Gm-Message-State: AOJu0Yyc+dtfx9HMaBq6Rw8dwDGNQUIF4Dbt1aiIkZuIba8RyJ7OGEME
	4tF0fX9oEfdafjVFRfLtdRcAY/zUrgea+TyLl3DQrCaWdnBLgwKppuAbtoHBIRDx4TW7FsKdhUs
	jJLHznxZ/fGO2AE/FnzNiS7lGgEf2s/NvupAF
X-Gm-Gg: Acq92OF5Nx9sq8NYi+iT/UcbhgdpRtD95KCRHcz/UAdj2IH3p6lqQUxh//FCN3i6m4X
	bhVRAscd4VsENXJbAjgoliht7gkIRjUVSXY+3xhsvk8lfQFA/2BGmgr2zrXG8vDI+6L8TL2S4PB
	FKRgjr0VC9QTNU+b5+CwxGiiOUPCNrFdXomW7njTdwdsd8SwC0WlZoMsCUlcAKPJGbplaAZQ/gb
	P+Cwr4cu6yIkQddKmighjiOxY8LbXSmucdxybrswsXQ0oWS/a9urVFZN0PmnTCzYa0E6F2nbEhh
	BiPLI2lpbbXjr7bxs+o=
X-Received: by 2002:a17:907:9813:b0:bd4:9a55:18e2 with SMTP id
 a640c23a62f3a-bdd267c685cmr864962766b.45.1779721734530; Mon, 25 May 2026
 08:08:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAAiJnjpPAur30W4FO2sTZcYWc24yFafKWGR=BZWZsh2JnbrRpQ@mail.gmail.com>
 <5d4b72d7-7e03-463c-82a1-63adcae20344@fygo.io>
In-Reply-To: <5d4b72d7-7e03-463c-82a1-63adcae20344@fygo.io>
From: Anton Gavriliuk <antosha20xx@gmail.com>
Date: Mon, 25 May 2026 18:08:41 +0300
X-Gm-Features: AVHnY4IC4ps2UMv1RpEJfuNrcK0ZkM60KCs5Q8SYg-HgA1B4RsDz4xWCUDRnBpA
Message-ID: <CAAiJnjoh9rTHh4gRu2=7A4C7EFP4yfBED94qmeS_ATDyB0yevQ@mail.gmail.com>
Subject: Re: --bitmap=lockless across server reboot
To: yukuai@fygo.io
Cc: linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hhmm.... I just re-checked it with latest kernel (7.1-rc5) on Fedora
Server 44, and now it works, log below.  I don't remember on which
kernel I saw that issue (7.1-rc3 or 7.1-rc4)

BTW, earlier you mentioned that you are working on raid5 performance
improvements,

"=E2=80=9CBTW we're working on performance
improvement for large raid5 arrays for at most 64 disks, results looks grea=
t.
However, it might take sometime before we push our work to upstream.=E2=80=
=9D

Are there any progress ?, I'm very interested to test on PCIe 5.0 NVMe driv=
es.

This is Fedora Server 44 (up to date) with compiled kernel 7.1-rc5

[root@qdevice ~]# cat /etc/*release
Fedora release 44 (Forty Four)
NAME=3D"Fedora Linux"
VERSION=3D"44 (Server Edition)"
RELEASE_TYPE=3Dstable
ID=3Dfedora
VERSION_ID=3D44
VERSION_CODENAME=3D""
PRETTY_NAME=3D"Fedora Linux 44 (Server Edition)"
ANSI_COLOR=3D"0;38;2;60;110;180"
LOGO=3Dfedora-logo-icon
CPE_NAME=3D"cpe:/o:fedoraproject:fedora:44"
HOME_URL=3D"https://fedoraproject.org/"
DOCUMENTATION_URL=3D"https://docs.fedoraproject.org/en-US/fedora/f44/"
SUPPORT_URL=3D"https://ask.fedoraproject.org/"
BUG_REPORT_URL=3D"https://bugzilla.redhat.com/"
REDHAT_BUGZILLA_PRODUCT=3D"Fedora"
REDHAT_BUGZILLA_PRODUCT_VERSION=3D44
REDHAT_SUPPORT_PRODUCT=3D"Fedora"
REDHAT_SUPPORT_PRODUCT_VERSION=3D44
SUPPORT_END=3D2027-05-19
VARIANT=3D"Server Edition"
VARIANT_ID=3Dserver
Fedora release 44 (Forty Four)
Fedora release 44 (Forty Four)
[root@qdevice ~]#
[root@qdevice ~]# uname -a
Linux qdevice 7.1.0-rc5 #1 SMP PREEMPT_DYNAMIC Mon May 25 15:02:20
EEST 2026 x86_64 GNU/Linux
[root@qdevice ~]#
[root@qdevice mdadm]# lsblk
NAME        MAJ:MIN RM   SIZE RO TYPE MOUNTPOINTS
nvme6n1     259:1    0 447.1G  0 disk
=E2=94=9C=E2=94=80nvme6n1p1 259:2    0     1G  0 part /boot/efi
=E2=94=9C=E2=94=80nvme6n1p2 259:3    0     1G  0 part /boot
=E2=94=9C=E2=94=80nvme6n1p3 259:4    0   220G  0 part /
=E2=94=9C=E2=94=80nvme6n1p4 259:5    0     1G  0 part
=E2=94=94=E2=94=80nvme6n1p5 259:6    0   220G  0 part
nvme3n1     259:10   0   2.9T  0 disk
nvme1n1     259:11   0   2.9T  0 disk
nvme0n1     259:12   0   2.9T  0 disk
nvme4n1     259:16   0   2.9T  0 disk
nvme2n1     259:17   0   2.9T  0 disk
nvme5n1     259:18   0   2.9T  0 disk
[root@qdevice mdadm]#
[root@qdevice mdadm]# mdadm --create --verbose /dev/md0 --level=3D6
--bitmap=3Dlockless --raid-devices=3D6 /dev/nvme0n1 /dev/nvme1n1
/dev/nvme2n1 /dev/nvme3n1 /dev/nvme4n1 /dev/nvme5n1
mdadm: Experimental lockless bitmap, use at your own risk!
mdadm: layout defaults to left-symmetric
mdadm: layout defaults to left-symmetric
mdadm: chunk size defaults to 512K
mdadm: /dev/nvme0n1 appears to be part of a raid array:
       level=3Draid6 devices=3D5 ctime=3DWed May 20 12:45:26 2026
mdadm: /dev/nvme1n1 appears to be part of a raid array:
       level=3Draid6 devices=3D5 ctime=3DWed May 20 12:45:26 2026
mdadm: /dev/nvme2n1 appears to be part of a raid array:
       level=3Draid6 devices=3D5 ctime=3DWed May 20 12:45:26 2026
mdadm: /dev/nvme3n1 appears to be part of a raid array:
       level=3Draid6 devices=3D5 ctime=3DWed May 20 12:45:26 2026
mdadm: /dev/nvme4n1 appears to be part of a raid array:
       level=3Draid6 devices=3D5 ctime=3DWed May 20 12:45:26 2026
mdadm: /dev/nvme5n1 appears to be part of a raid array:
       level=3Draid6 devices=3D6 ctime=3DWed May 20 11:45:38 2026
mdadm: size set to 3125484544K
Continue creating array [y/N]? y
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md0 started.
[root@qdevice mdadm]#
[root@qdevice mdadm]# lsblk
NAME        MAJ:MIN RM   SIZE RO TYPE  MOUNTPOINTS
nvme6n1     259:1    0 447.1G  0 disk
=E2=94=9C=E2=94=80nvme6n1p1 259:2    0     1G  0 part  /boot/efi
=E2=94=9C=E2=94=80nvme6n1p2 259:3    0     1G  0 part  /boot
=E2=94=9C=E2=94=80nvme6n1p3 259:4    0   220G  0 part  /
=E2=94=9C=E2=94=80nvme6n1p4 259:5    0     1G  0 part
=E2=94=94=E2=94=80nvme6n1p5 259:6    0   220G  0 part
nvme3n1     259:10   0   2.9T  0 disk
=E2=94=94=E2=94=80md0         9:0    0  11.6T  0 raid6
nvme1n1     259:11   0   2.9T  0 disk
=E2=94=94=E2=94=80md0         9:0    0  11.6T  0 raid6
nvme0n1     259:12   0   2.9T  0 disk
=E2=94=94=E2=94=80md0         9:0    0  11.6T  0 raid6
nvme4n1     259:16   0   2.9T  0 disk
=E2=94=94=E2=94=80md0         9:0    0  11.6T  0 raid6
nvme2n1     259:17   0   2.9T  0 disk
=E2=94=94=E2=94=80md0         9:0    0  11.6T  0 raid6
nvme5n1     259:18   0   2.9T  0 disk
=E2=94=94=E2=94=80md0         9:0    0  11.6T  0 raid6
[root@qdevice mdadm]#
[root@qdevice mdadm]# reboot
[root@qdevice mdadm]#

After reboot,

[root@qdevice ~]# lsblk
NAME        MAJ:MIN RM   SIZE RO TYPE  MOUNTPOINTS
nvme6n1     259:1    0 447.1G  0 disk
=E2=94=9C=E2=94=80nvme6n1p1 259:2    0     1G  0 part  /boot/efi
=E2=94=9C=E2=94=80nvme6n1p2 259:3    0     1G  0 part  /boot
=E2=94=9C=E2=94=80nvme6n1p3 259:4    0   220G  0 part  /
=E2=94=9C=E2=94=80nvme6n1p4 259:5    0     1G  0 part
=E2=94=94=E2=94=80nvme6n1p5 259:6    0   220G  0 part
nvme2n1     259:9    0   2.9T  0 disk
=E2=94=94=E2=94=80md0         9:0    0  11.6T  0 raid6
nvme1n1     259:10   0   2.9T  0 disk
=E2=94=94=E2=94=80md0         9:0    0  11.6T  0 raid6
nvme4n1     259:15   0   2.9T  0 disk
=E2=94=94=E2=94=80md0         9:0    0  11.6T  0 raid6
nvme0n1     259:16   0   2.9T  0 disk
=E2=94=94=E2=94=80md0         9:0    0  11.6T  0 raid6
nvme3n1     259:17   0   2.9T  0 disk
=E2=94=94=E2=94=80md0         9:0    0  11.6T  0 raid6
nvme5n1     259:18   0   2.9T  0 disk
=E2=94=94=E2=94=80md0         9:0    0  11.6T  0 raid6
[root@qdevice ~]#


Anton

=D0=BF=D0=BD, 25 =D0=BC=D0=B0=D1=8F 2026=E2=80=AF=D0=B3. =D0=B2 08:32, Yu K=
uai <yukuai@fnnas.com>:
>
> Hi,
>
> =E5=9C=A8 2026/5/20 1:28, Anton Gavriliuk =E5=86=99=E9=81=93:
> > Hi
> >
> > Does md-raid lockless bitmap support server's reboot ?
>
> Yes, of course it should support reboot.
>
> >
> > I don't see md-raid6 created with --bitmap=3Dlockless after reboot.
>
> Do you check kernel log if there is any failure log? And do you try
> mdadm -a manually?
>
> BTW, pPlease report with your environment and test script in details,
> especially kernel version and mdadm version.
>
> >
> > Anton
> >
> --
> Thansk,
> Kuai
