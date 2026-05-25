Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C9F43812DD
	for <linux-raid@vger.kernel.org>; Mon, 25 May 2026 17:11:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779729119; cv=pass; b=oxPhZXPrT8lkSjkT+3Too5X1VShTtiVfUHkyQvxmgo8DAXBI4rLGBg3URRxhwV4/TRpgTv1PkeNyUbbUkZRyedlM75u6edbVucvf4YcP0n0zga6DUWhhuNfKnvlAE6L9NJV7ajVGbWJRPb/wMD3DFcQp6vkMlZgi2zSaqrrwCpc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779729119; c=relaxed/simple;
	bh=sRcH9Z7Pz/9APpHYcEcR1Wuj7q6jhJ/kWJggDz6MYAM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=htJUgSUabmlQm/wu/cBZqvBrfVTXEtkAujaWP7cDBdZ+cf7esBFQzA+50ux7ShhyrjhL+UxtRlsvFU73YfJFrqbvZHFf1806JhyO1B+xuhNpDDftMLX7LzZQ/sLIvjHmjWHDAeC9UCrIV28fwujE1f9UrxO+dlPF1ZVGIRbex7Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Cr3wetsx; arc=pass smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Cr3wetsx"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-bd5047a2a4cso1481178866b.3
        for <linux-raid@vger.kernel.org>; Mon, 25 May 2026 10:11:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779729116; cv=none;
        d=google.com; s=arc-20240605;
        b=PQ5XfQ0BNvGRy8XlVU/PyZS2vqGMFtITXXWt2vVbWxBDz6MI6QDGJc93rdmp6ciiNf
         pvlPfxOGVY0VY3OxaWYIo9mW/NMO8fusEGC4NyN+j7PTh8zy/emN5jWSmfQi0/kzlA4m
         0HIAtybeycWqmOGOA/5n9VF82E00vQdj0sQuzBoJK2WvJUWyxjwmjbu5YSYlm2J5CePl
         W2zeL1mREBU/bJP2tQfJkBmsgudO0GRZgW4/S9odomxSqvo30Cmk+Anup3H0nGvJozNH
         ntk38aOOxQTf3X0XzpZAxCV/AceA9UNScCaR+zGuhmErqFwochdmpCk0Iowgd7bMx98s
         Bm3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=LGpE3HREkRu1OuCdvsG0ysu9KhG8xhBcJjVT8p2UvsY=;
        fh=PZpY5pX+ZDYjH6O92LHrRYbgWeMc3WMCBOkY6GERUhQ=;
        b=gqHeg62El63XFeZTHQVr292y6kLJ8OlulQoFMrC/DqdO37XKngdD9UMutnW7Jzq3Bu
         q07r/Rm3dqioI6eCYuyKagbAiNJiunmYTfulpnGH47RkpbbfXgqDxu9Kouc75t4XwYKU
         30rUMCPU7ZS8zdbbEUgYxu61kSKIigr6ckP6cdcTU8RxQgQl32M8AND4yN3bG4FG+4vC
         HKaF3ChygxvU1TVCKghGDfHtw3ixPoALP8cbRSDNCn1dPiP00jy2X6QC1xsIVWmsCjI2
         PYArK3I9QVjZgH4blDIfIQcseIrqtZ0Fcn6j5K28VTl0et2QY3EDod+ZTFg1cO7/e9a+
         VjhA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779729116; x=1780333916; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LGpE3HREkRu1OuCdvsG0ysu9KhG8xhBcJjVT8p2UvsY=;
        b=Cr3wetsxddoSYJ01+hZW9gyUikHih6Kmz0SJJCWsfWqN/CYDIxlosNCww4ZH1ohVVO
         hLhUFW2hR9L0JZJHUbBX223uEa/tum7uHLms317shriMFTUcv3g5iP68e3esobNMv69e
         NvwKOwy27hEkMUUXmhA6xgH+wO0EXbGM6JefCu6jBfN9mK+yhp2uTzOS7VXK6OYkJ7x/
         sOKfnhkNJa6P8I6+IzOVyHun6W4zk3fgghZHsGBS6wWAXY104m/mGCUIq1D+YnmrPGpf
         VpYEzaAPD9u4CEhVQTHi46NwobXFAin3vT+VM+agDF8X2doICz1uLVmpVZTiNIukIt/2
         pnpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779729116; x=1780333916;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=LGpE3HREkRu1OuCdvsG0ysu9KhG8xhBcJjVT8p2UvsY=;
        b=Ho8PHHGgR1hf1pb16V3I77nl9nP2QorOgFuWFMzNzDe5tJLs4HLfsS/rJeqHNowiSB
         v67qOFxtz63+Rko03DIic/5lNQ2tFTY03e4HQOFdumv1NMGXnrkh9xWljm5/mreAauUj
         MOHlrpGTLojKWgwSgjQMut14F7ksus0Pprbsba+1mC9eX6Vd9JPAT4uAsMrc5nJa8I92
         6INuCs3yQo50AlepZbe9Fczep/oyhKdJx4jHo2MwF6sgHjq8WsH1DkZlL5kXZS2MPpCF
         7TDJhGsEMPLd+srXAOhx32yUGe2aWbcCe0P5WZrAZFeRbhvjGwWBQPQq0+xPYJqzAT4L
         FV9g==
X-Gm-Message-State: AOJu0YwCDckLL204bjHnlT6sfG1ZHSn+RVGw5zpM1X8PT4tSkxs8XBGN
	rSjiCGwjOFzXnc3Oj2v+o3vGrsnLR8qreDVGtysSD+HDVZwm1AuCVuPD0YLH/3ysRawLVgCO/9t
	gAqVPmIa1hlPcckOCTHfZooRvCl590MoOyjPx
X-Gm-Gg: Acq92OGF7MoEjB07H6t87DNhbn7QK1vcB5P5I+CHG46K4QGE9U7XXxwr/nwdLIhjtPF
	sSdZMuyaefRNuw4nsqa/haPerrSFNf51LkE+F1bYLFLaYgnsHFKSf9TddTIkKI5NprXz5yT0ZaO
	/bw99B6oqBTyWEBodWxp85qT+ou0B+iatqPWRoA85wsR8/Dml55Gpa1UDJwFjEFKrcD44hxCGxo
	9U3G45/6Lbe0IiFuJa4z8rRK9FXePIHAZHPTjGqKViMFIpWFN4V2N5CZE/OozqXkIs/43VC341c
	3mIFlVmL
X-Received: by 2002:a17:907:3c92:b0:bd4:f594:8a59 with SMTP id
 a640c23a62f3a-bdd279d2c18mr820484966b.38.1779729115964; Mon, 25 May 2026
 10:11:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAAiJnjpPAur30W4FO2sTZcYWc24yFafKWGR=BZWZsh2JnbrRpQ@mail.gmail.com>
 <5d4b72d7-7e03-463c-82a1-63adcae20344@fygo.io> <CAAiJnjoh9rTHh4gRu2=7A4C7EFP4yfBED94qmeS_ATDyB0yevQ@mail.gmail.com>
In-Reply-To: <CAAiJnjoh9rTHh4gRu2=7A4C7EFP4yfBED94qmeS_ATDyB0yevQ@mail.gmail.com>
From: Anton Gavriliuk <antosha20xx@gmail.com>
Date: Mon, 25 May 2026 20:11:44 +0300
X-Gm-Features: AVHnY4LkHvLL5T_0bVENn707yiHSFNMymRuT_caR9xZFSu0GKEl1wC0NmrFhziM
Message-ID: <CAAiJnjr_FcaivTUy+gJwo6ob7BLivw3eU0_huWMA7hOcw9raPg@mail.gmail.com>
Subject: Re: --bitmap=lockless across server reboot
To: yukuai@fygo.io
Cc: linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I remembered how to reproduce.
The raid is gone after I performed precondition for performance tests
and reboot.
After reboot there are no issues in dmesg and messages.

[root@qdevice ~]# fio --name=3Draid5_final --rw=3Dwrite --bs=3D2048k
--filename=3D/dev/md0 --direct=3D1 --numjobs=3D1 --iodepth=3D64
--group_reporting --ioengine=3Dio_uring --time_based --runtime=3D1800
raid5_final: (g=3D0): rw=3Dwrite, bs=3D(R) 2048KiB-2048KiB, (W)
2048KiB-2048KiB, (T) 2048KiB-2048KiB, ioengine=3Dio_uring, iodepth=3D64
fio-3.42-29-gd569
Starting 1 process
Jobs: 1 (f=3D1): [W(1)][100.0%][w=3D8316MiB/s][w=3D4158 IOPS][eta 00m:00s]
raid5_final: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D5070: Mon May 25 19:5=
6:09 2026
  write: IOPS=3D4088, BW=3D8176MiB/s (8574MB/s)(14.0TiB/1800013msec)
    slat (usec): min=3D15, max=3D1287, avg=3D36.23, stdev=3D11.79
    clat (usec): min=3D2072, max=3D43284, avg=3D15618.22, stdev=3D3312.23
     lat (usec): min=3D2094, max=3D43313, avg=3D15654.45, stdev=3D3312.52
    clat percentiles (usec):
     |  1.00th=3D[ 8356],  5.00th=3D[10421], 10.00th=3D[11469], 20.00th=3D[=
12911],
     | 30.00th=3D[13829], 40.00th=3D[14615], 50.00th=3D[15533], 60.00th=3D[=
16319],
     | 70.00th=3D[17171], 80.00th=3D[18220], 90.00th=3D[19792], 95.00th=3D[=
21103],
     | 99.00th=3D[23987], 99.50th=3D[25297], 99.90th=3D[28181], 99.95th=3D[=
29492],
     | 99.99th=3D[32375]
   bw (  MiB/s): min=3D 7736, max=3D 9132, per=3D100.00%, avg=3D8178.90,
stdev=3D166.52, samples=3D3599
   iops        : min=3D 3868, max=3D 4566, avg=3D4089.42, stdev=3D83.27, sa=
mples=3D3599
  lat (msec)   : 4=3D0.01%, 10=3D3.68%, 20=3D87.01%, 50=3D9.32%
  cpu          : usr=3D10.21%, sys=3D5.19%, ctx=3D5637748, majf=3D0, minf=
=3D754452
  IO depths    : 1=3D0.1%, 2=3D0.1%, 4=3D0.1%, 8=3D0.1%, 16=3D0.1%, 32=3D0.=
1%, >=3D64=3D100.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.1%, >=3D64=3D0.0%
     issued rwts: total=3D0,7358832,0,0 short=3D0,0,0,0 dropped=3D0,0,0,0
     latency   : target=3D0.00ns, window=3D0.00ns, percentile=3D100.00%, de=
pth=3D64

Run status group 0 (all jobs):
  WRITE: bw=3D8176MiB/s (8574MB/s), 8176MiB/s-8176MiB/s
(8574MB/s-8574MB/s), io=3D14.0TiB (15.4TB), run=3D1800013-1800013msec

Disk stats (read/write):
    md0: ios=3D20/14716476, sectors=3D2560/30139342848, merge=3D0/0,
ticks=3D0/125528858, in_queue=3D125528858, util=3D100.00%,
aggrios=3D68/7358896, aggsectors=3D3046/7535444480, aggrmerge=3D0/0,
aggrticks=3D6/413853, aggrin_queue=3D413859, aggrutil=3D21.24%
  nvme0n1: ios=3D48/7358896, sectors=3D1680/7535444480, merge=3D0/0,
ticks=3D6/408945, in_queue=3D408951, util=3D20.67%
  nvme3n1: ios=3D67/7358896, sectors=3D3992/7535444480, merge=3D0/0,
ticks=3D4/433875, in_queue=3D433879, util=3D21.24%
  nvme2n1: ios=3D118/7358896, sectors=3D2960/7535444480, merge=3D0/0,
ticks=3D7/405682, in_queue=3D405689, util=3D20.45%
  nvme5n1: ios=3D75/7358896, sectors=3D5136/7535444480, merge=3D0/0,
ticks=3D9/407693, in_queue=3D407702, util=3D20.42%
  nvme1n1: ios=3D51/7358896, sectors=3D2064/7535444480, merge=3D0/0,
ticks=3D7/409760, in_queue=3D409767, util=3D20.59%
  nvme4n1: ios=3D54/7358896, sectors=3D2448/7535444480, merge=3D0/0,
ticks=3D5/417163, in_queue=3D417168, util=3D20.58%
[root@qdevice ~]#
[root@qdevice ~]# lsblk
NAME        MAJ:MIN RM   SIZE RO TYPE  MOUNTPOINTS
nvme6n1     259:1    0 447.1G  0 disk
=E2=94=9C=E2=94=80nvme6n1p1 259:2    0     1G  0 part  /boot/efi
=E2=94=9C=E2=94=80nvme6n1p2 259:3    0     1G  0 part  /boot
=E2=94=9C=E2=94=80nvme6n1p3 259:4    0   220G  0 part  /
=E2=94=9C=E2=94=80nvme6n1p4 259:5    0     1G  0 part
=E2=94=94=E2=94=80nvme6n1p5 259:6    0   220G  0 part
nvme0n1     259:9    0   2.9T  0 disk
=E2=94=94=E2=94=80md0         9:0    0  11.6T  0 raid6
nvme1n1     259:10   0   2.9T  0 disk
=E2=94=94=E2=94=80md0         9:0    0  11.6T  0 raid6
nvme4n1     259:15   0   2.9T  0 disk
=E2=94=94=E2=94=80md0         9:0    0  11.6T  0 raid6
nvme2n1     259:16   0   2.9T  0 disk
=E2=94=94=E2=94=80md0         9:0    0  11.6T  0 raid6
nvme5n1     259:17   0   2.9T  0 disk
=E2=94=94=E2=94=80md0         9:0    0  11.6T  0 raid6
nvme3n1     259:18   0   2.9T  0 disk
=E2=94=94=E2=94=80md0         9:0    0  11.6T  0 raid6
[root@qdevice ~]#
[root@qdevice ~]# reboot
login as: root
root@10.72.14.186's password:
Web console: https://qdevice:9090/ or https://10.72.14.186:9090/

Last login: Mon May 25 19:25:38 2026 from 10.72.12.178
[root@qdevice ~]# uptime
 20:01:59 up 0 min,  1 user,  load average: 0.87, 0.26, 0.09
[root@qdevice ~]#
[root@qdevice ~]# lsblk
NAME        MAJ:MIN RM   SIZE RO TYPE MOUNTPOINTS
nvme5n1     259:1    0 447.1G  0 disk
=E2=94=9C=E2=94=80nvme5n1p1 259:2    0     1G  0 part /boot/efi
=E2=94=9C=E2=94=80nvme5n1p2 259:3    0     1G  0 part /boot
=E2=94=9C=E2=94=80nvme5n1p3 259:4    0   220G  0 part /
=E2=94=9C=E2=94=80nvme5n1p4 259:5    0     1G  0 part
=E2=94=94=E2=94=80nvme5n1p5 259:6    0   220G  0 part
nvme1n1     259:8    0   2.9T  0 disk
nvme3n1     259:10   0   2.9T  0 disk
nvme4n1     259:13   0   2.9T  0 disk
nvme2n1     259:14   0   2.9T  0 disk
nvme0n1     259:17   0   2.9T  0 disk
nvme6n1     259:18   0   2.9T  0 disk
[root@qdevice ~]#
[root@qdevice ~]# uptime
 20:02:40 up 1 min,  1 user,  load average: 0.46, 0.24, 0.09
[root@qdevice ~]#

Anton

=D0=BF=D0=BD, 25 =D0=BC=D0=B0=D1=8F 2026=E2=80=AF=D0=B3. =D0=B2 18:08, Anto=
n Gavriliuk <antosha20xx@gmail.com>:
>
> Hhmm.... I just re-checked it with latest kernel (7.1-rc5) on Fedora
> Server 44, and now it works, log below.  I don't remember on which
> kernel I saw that issue (7.1-rc3 or 7.1-rc4)
>
> BTW, earlier you mentioned that you are working on raid5 performance
> improvements,
>
> "=E2=80=9CBTW we're working on performance
> improvement for large raid5 arrays for at most 64 disks, results looks gr=
eat.
> However, it might take sometime before we push our work to upstream.=E2=
=80=9D
>
> Are there any progress ?, I'm very interested to test on PCIe 5.0 NVMe dr=
ives.
>
> This is Fedora Server 44 (up to date) with compiled kernel 7.1-rc5
>
> [root@qdevice ~]# cat /etc/*release
> Fedora release 44 (Forty Four)
> NAME=3D"Fedora Linux"
> VERSION=3D"44 (Server Edition)"
> RELEASE_TYPE=3Dstable
> ID=3Dfedora
> VERSION_ID=3D44
> VERSION_CODENAME=3D""
> PRETTY_NAME=3D"Fedora Linux 44 (Server Edition)"
> ANSI_COLOR=3D"0;38;2;60;110;180"
> LOGO=3Dfedora-logo-icon
> CPE_NAME=3D"cpe:/o:fedoraproject:fedora:44"
> HOME_URL=3D"https://fedoraproject.org/"
> DOCUMENTATION_URL=3D"https://docs.fedoraproject.org/en-US/fedora/f44/"
> SUPPORT_URL=3D"https://ask.fedoraproject.org/"
> BUG_REPORT_URL=3D"https://bugzilla.redhat.com/"
> REDHAT_BUGZILLA_PRODUCT=3D"Fedora"
> REDHAT_BUGZILLA_PRODUCT_VERSION=3D44
> REDHAT_SUPPORT_PRODUCT=3D"Fedora"
> REDHAT_SUPPORT_PRODUCT_VERSION=3D44
> SUPPORT_END=3D2027-05-19
> VARIANT=3D"Server Edition"
> VARIANT_ID=3Dserver
> Fedora release 44 (Forty Four)
> Fedora release 44 (Forty Four)
> [root@qdevice ~]#
> [root@qdevice ~]# uname -a
> Linux qdevice 7.1.0-rc5 #1 SMP PREEMPT_DYNAMIC Mon May 25 15:02:20
> EEST 2026 x86_64 GNU/Linux
> [root@qdevice ~]#
> [root@qdevice mdadm]# lsblk
> NAME        MAJ:MIN RM   SIZE RO TYPE MOUNTPOINTS
> nvme6n1     259:1    0 447.1G  0 disk
> =E2=94=9C=E2=94=80nvme6n1p1 259:2    0     1G  0 part /boot/efi
> =E2=94=9C=E2=94=80nvme6n1p2 259:3    0     1G  0 part /boot
> =E2=94=9C=E2=94=80nvme6n1p3 259:4    0   220G  0 part /
> =E2=94=9C=E2=94=80nvme6n1p4 259:5    0     1G  0 part
> =E2=94=94=E2=94=80nvme6n1p5 259:6    0   220G  0 part
> nvme3n1     259:10   0   2.9T  0 disk
> nvme1n1     259:11   0   2.9T  0 disk
> nvme0n1     259:12   0   2.9T  0 disk
> nvme4n1     259:16   0   2.9T  0 disk
> nvme2n1     259:17   0   2.9T  0 disk
> nvme5n1     259:18   0   2.9T  0 disk
> [root@qdevice mdadm]#
> [root@qdevice mdadm]# mdadm --create --verbose /dev/md0 --level=3D6
> --bitmap=3Dlockless --raid-devices=3D6 /dev/nvme0n1 /dev/nvme1n1
> /dev/nvme2n1 /dev/nvme3n1 /dev/nvme4n1 /dev/nvme5n1
> mdadm: Experimental lockless bitmap, use at your own risk!
> mdadm: layout defaults to left-symmetric
> mdadm: layout defaults to left-symmetric
> mdadm: chunk size defaults to 512K
> mdadm: /dev/nvme0n1 appears to be part of a raid array:
>        level=3Draid6 devices=3D5 ctime=3DWed May 20 12:45:26 2026
> mdadm: /dev/nvme1n1 appears to be part of a raid array:
>        level=3Draid6 devices=3D5 ctime=3DWed May 20 12:45:26 2026
> mdadm: /dev/nvme2n1 appears to be part of a raid array:
>        level=3Draid6 devices=3D5 ctime=3DWed May 20 12:45:26 2026
> mdadm: /dev/nvme3n1 appears to be part of a raid array:
>        level=3Draid6 devices=3D5 ctime=3DWed May 20 12:45:26 2026
> mdadm: /dev/nvme4n1 appears to be part of a raid array:
>        level=3Draid6 devices=3D5 ctime=3DWed May 20 12:45:26 2026
> mdadm: /dev/nvme5n1 appears to be part of a raid array:
>        level=3Draid6 devices=3D6 ctime=3DWed May 20 11:45:38 2026
> mdadm: size set to 3125484544K
> Continue creating array [y/N]? y
> mdadm: Defaulting to version 1.2 metadata
> mdadm: array /dev/md0 started.
> [root@qdevice mdadm]#
> [root@qdevice mdadm]# lsblk
> NAME        MAJ:MIN RM   SIZE RO TYPE  MOUNTPOINTS
> nvme6n1     259:1    0 447.1G  0 disk
> =E2=94=9C=E2=94=80nvme6n1p1 259:2    0     1G  0 part  /boot/efi
> =E2=94=9C=E2=94=80nvme6n1p2 259:3    0     1G  0 part  /boot
> =E2=94=9C=E2=94=80nvme6n1p3 259:4    0   220G  0 part  /
> =E2=94=9C=E2=94=80nvme6n1p4 259:5    0     1G  0 part
> =E2=94=94=E2=94=80nvme6n1p5 259:6    0   220G  0 part
> nvme3n1     259:10   0   2.9T  0 disk
> =E2=94=94=E2=94=80md0         9:0    0  11.6T  0 raid6
> nvme1n1     259:11   0   2.9T  0 disk
> =E2=94=94=E2=94=80md0         9:0    0  11.6T  0 raid6
> nvme0n1     259:12   0   2.9T  0 disk
> =E2=94=94=E2=94=80md0         9:0    0  11.6T  0 raid6
> nvme4n1     259:16   0   2.9T  0 disk
> =E2=94=94=E2=94=80md0         9:0    0  11.6T  0 raid6
> nvme2n1     259:17   0   2.9T  0 disk
> =E2=94=94=E2=94=80md0         9:0    0  11.6T  0 raid6
> nvme5n1     259:18   0   2.9T  0 disk
> =E2=94=94=E2=94=80md0         9:0    0  11.6T  0 raid6
> [root@qdevice mdadm]#
> [root@qdevice mdadm]# reboot
> [root@qdevice mdadm]#
>
> After reboot,
>
> [root@qdevice ~]# lsblk
> NAME        MAJ:MIN RM   SIZE RO TYPE  MOUNTPOINTS
> nvme6n1     259:1    0 447.1G  0 disk
> =E2=94=9C=E2=94=80nvme6n1p1 259:2    0     1G  0 part  /boot/efi
> =E2=94=9C=E2=94=80nvme6n1p2 259:3    0     1G  0 part  /boot
> =E2=94=9C=E2=94=80nvme6n1p3 259:4    0   220G  0 part  /
> =E2=94=9C=E2=94=80nvme6n1p4 259:5    0     1G  0 part
> =E2=94=94=E2=94=80nvme6n1p5 259:6    0   220G  0 part
> nvme2n1     259:9    0   2.9T  0 disk
> =E2=94=94=E2=94=80md0         9:0    0  11.6T  0 raid6
> nvme1n1     259:10   0   2.9T  0 disk
> =E2=94=94=E2=94=80md0         9:0    0  11.6T  0 raid6
> nvme4n1     259:15   0   2.9T  0 disk
> =E2=94=94=E2=94=80md0         9:0    0  11.6T  0 raid6
> nvme0n1     259:16   0   2.9T  0 disk
> =E2=94=94=E2=94=80md0         9:0    0  11.6T  0 raid6
> nvme3n1     259:17   0   2.9T  0 disk
> =E2=94=94=E2=94=80md0         9:0    0  11.6T  0 raid6
> nvme5n1     259:18   0   2.9T  0 disk
> =E2=94=94=E2=94=80md0         9:0    0  11.6T  0 raid6
> [root@qdevice ~]#
>
>
> Anton
>
> =D0=BF=D0=BD, 25 =D0=BC=D0=B0=D1=8F 2026=E2=80=AF=D0=B3. =D0=B2 08:32, Yu=
 Kuai <yukuai@fnnas.com>:
> >
> > Hi,
> >
> > =E5=9C=A8 2026/5/20 1:28, Anton Gavriliuk =E5=86=99=E9=81=93:
> > > Hi
> > >
> > > Does md-raid lockless bitmap support server's reboot ?
> >
> > Yes, of course it should support reboot.
> >
> > >
> > > I don't see md-raid6 created with --bitmap=3Dlockless after reboot.
> >
> > Do you check kernel log if there is any failure log? And do you try
> > mdadm -a manually?
> >
> > BTW, pPlease report with your environment and test script in details,
> > especially kernel version and mdadm version.
> >
> > >
> > > Anton
> > >
> > --
> > Thansk,
> > Kuai
