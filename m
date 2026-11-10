Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.46
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794330753;
	b=Jiq99OrRiYMOcpOKK0lOE4/4+haFbTKmI5eRHpAi6Z0Z9L580LXumD3xvvW1Yl4aOGu7
	 ZCYhheqY/Fw1/0d6vvwmSDvmucM4RpSJzRdZ1/aj46ebzEfcgrkmxYg7vMhEaayeLshsm
	 lvWXR5lTyoP9mZRPMPg9TaK9D9iKhpYvYcdji+2H4JlsqrWCRy+vsdmWBEVtQyJFPqrl9
	 r4l1aycpzalNRV/a+BFNfuEbAl8l5yGOMvbXj2YPuFHWbSjgIOBFSg7KZwh1w/TQ4gQv3
	 YjsoE5BqA7af29+2CwdqDbRvXFB6xOGPTC1Jc1eowO82UNfK24TbajmAdUOHewsaHYA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794330753;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=ucuYkFKvUNXuxfNgwLZgSph0k3eNRJ7+3mwZjOxdjUc=;
	b=Jdl2ilHwgQ3jkG6B1XPGycONNDVoeWq/o7tPll+jJv8p1fvzdWbKq223ECxoE/r4dXZ+
	 RydWoVuZmA6v2WjDkHg7fCNCLB0ansETAvDKAnG0HmF/UnlmV+eWl0lWjfMLep4yJ31aW
	 J+Mbcgm1AE5G6Ui5KRTj3mQC3GMDehMo4snft6XVSvn1m32cX8DTDVlxLvcLO5FYV/5fS
	 CnJc+lnMntpoxBbWo1U0C7sYIt11rC7XN+KD+Y5jGVsbEqIjNwkr8rMRReu08TQZ3ZSzy
	 cCUqMlRmJm99UnOEdK05dvDnBI+3Bo+HMR9InqHuF4JT4p/bISTQZjiTfEPbQdE8WEg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=kvSkJJfT;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.46
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7781606A31C
	for <linux-raid@vger.kernel.org>; Tue, 10 Nov 2026 17:12:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B7781606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=kvSkJJfT
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-c49c32650adso154316466b.0
        for <linux-raid@vger.kernel.org>; Tue, 10 Nov 2026 09:12:32 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794330751; cv=none;
        d=google.com; s=arc-20260327;
        b=JlMtAaSLSa5ILCFBKh6764Z55FGxWqSpkBAnLftPhQPTR43xp5eKLGNNJTr5/N2stU
         dA7kpzw+dYZUk7YHWmqy8ZFy0YF5xGXLwFr8CJ7N7FyTEdDHRojA/oALKWgAWbWeEPwI
         Wge1uYLs7GB/3yFPS7X6tmCz3Xd4PEzghebx9yiSwRkORVgCVsw68FcdkU/Bjzccl+Ui
         Bl2+8nmXg+tmkANq8J2Ha9VW1QTzQWw7Nmj2wbuwQpeJSVd6jIEpLGC8Xr43TD3ntjAh
         HrryqHNKonuZ5Ehdt500SbN2kM0dzMwDaTdfuVTuYiJU4A9ABvanmGrUND/ky/ejCpr2
         W1gQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ucuYkFKvUNXuxfNgwLZgSph0k3eNRJ7+3mwZjOxdjUc=;
        fh=8SXUz0wrNpP/mjN7u0Z01DNmVYG1RudRsUZ7HGzykAA=;
        b=j1b0ZY6RoYUDEVwdQiFnohlWWW/mYmi3P3zVfF059CSSGNmpSG+h/gy4he6uCbJbp2
         QvMM/U0FjulTDdU5p6T10Ugw2o2y+qm7YMHX9WTpxX9H2zNhWKX89fc5EJd/Err6+RHj
         4ynblrkZaxdeVTsc31ou3BA1d/j5jCUWB804VFo6GF0IucDOvu9IxQ5MERxv/xAlDU+J
         37BtGRGjFI5PahRsK9akEnvnosTB+VoWa6Pp9TihtJkEDDYcFJHtCh8OxCUwMtVXRPdy
         yCL84AD0KgsjaCQjrIuZPSELDGj74yl1VSqRYLAxCoBE1vl1fRoaCNiGXYnMWzrba0oK
         7J1g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794330751; x=1794935551; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ucuYkFKvUNXuxfNgwLZgSph0k3eNRJ7+3mwZjOxdjUc=;
        b=kvSkJJfTT6eUFcv9eiAx4Q9KO/aOA6GBsGFztYY/cnYc7i0NImVjsPnq7VzfO6NV8D
         UdzwCBUOcjt5mSETZWH/N9BEO3ebs/2hvZRK9x++mWnepJeUDyYQFyvOXKocZDUioz9Y
         HHBOewgV/dSiAqIMAFXXRz6IR3fSe54bUZjmu4J1tqu4cwwGnWVrt04w8cbBo+OtMDeH
         FuBvGtdvXB++YURyNx6DyX5Nr53asHu95du4IVubJ3jRxfh3s11q8hK76L/4dL4lZcZR
         gKt7W+luxbFe/rZGNkaqhZ2RA+eprprtASrlNqSypoijR26lQmjxOemMKeaC9Jwidw40
         UKUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794330751; x=1794935551;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ucuYkFKvUNXuxfNgwLZgSph0k3eNRJ7+3mwZjOxdjUc=;
        b=HDWCUtubyXHavVulnWqIsdg3Pu7V12EAueSJdlpva/axHfCKcOQG0WyVScxgA69ZCS
         AnKcM/QZChJsiSBF3Jsr6jE7TTMwnK91XoowgbqOCZqhq9FU105GmwB4MIEooijgbGrC
         AmkjijwZudM5/yctNidYInfA6rbm7dLyw0EBmsMEFsQzeSP4qgE9MjiYfDW755r4epy5
         S0EDFWJYUuCFChrCEnzXj0WqAAEUwq/elxQi8bmbsTbF6+ZzXvY78bkVhtTMUvxues/4
         M6RacrBkQhE5/aYPHiOZuqDrv9ou9/5PIzM1uZhrXypGbc5hj9Ud/QX3h8p9yXhHx0CQ
         7djg==
X-Gm-Message-State: APuU4Z/rCYcrpFFLsMZuKvpbSzxOuw4IxE56TvAzmyNbEa8Dqt4Kbpvv
	h+e1RFe/xvNoy0D18zzY3FsZFPTe7B3JF+1XTleik1PbJXIIC09YIl6GyzXAONdBlplsqn1zGXe
	hFQwxCS1CvCFPHdU83358pG+gMDkpXgFWTF6u
X-Gm-Gg: AYBFou2q7bfgdANwFeCz/NmuN3eD/JEXjj9CnQUZUOhDboub+g8oh9Tov/WLOE51SRq
	Ni85FcgT8hmtLFlf8K7hj/DDWvCZG31g876sxyrn+Na7814ZW/KcFbOkohUDm1TKNmcWoddGYCH
	LtY0+zPkSKdkL2S3yE9YzxBW0fKNoB3dnNRYLiDMDGRqy1i5UU0VJICIIUoEsnCdR3rqQowHW4I
	Hq9OQayExwE90wj4SOQHOa72phAWYWq6mQPJ/sEX/E93e8BtpyAaSedDQLpod97dMgdwd2RELsE
	xN6kh6XZRMneLtDNslKAbyX113VEElTsrrkDS5rA0K+xE3cQSftj7ud9TTTnAdpET3Z18oX8jUj
	yea9Ft2gvA2JXbgyueg/F28YJukR8/17b9Bd9kA==
X-Received: by 2002:a17:907:1788:b0:c42:102f:15d3 with SMTP id
 a640c23a62f3a-c504966f1c3mr256626966b.34.1794330750778; Tue, 10 Nov 2026
 09:12:30 -0800 (PST)
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Post: <mailto:linux-raid@vger.kernel.org>
List-Help: <mailto:linux-raid+help@vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-raid+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <CAAiJnjr6fxY1LKmrYbradXPoxW+cS28uLo6VxYkwLxXsTcY4gg@mail.gmail.com>
 <20261110133756.63676-1-mc@raidlab.org>
In-Reply-To: <20261110133756.63676-1-mc@raidlab.org>
From: Anton Gavriliuk <antosha20xx@gmail.com>
Date: Tue, 10 Nov 2026 19:12:19 +0200
X-Gm-Features: AclHuK-QjSgx01hfo1-Iyaw6_hVmEdzHz8UoZWrPkZOVvtAqEhhUJCSsHGuvZBc
Message-ID: <CAAiJnjqRNYW-GzabJfGkbnei6x7fbkvhuOijqx+_Z4MWxua_Uw@mail.gmail.com>
Subject: Re: xor_gen() md-raid6 performance improvement
To: Miroslav Cimerman <mc@raidlab.org>
Cc: linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Miroslav

I'm very interested in a high performance md-raid subsystem, to be
aligned with current PCIe 5.0 and coming 6.0 NVMe SSDs.
So I'm ready to assist you as much as required.

There is the single socket box - HPE DL345g11, 6 x PCIe 5.0 NVMe SSDs
(CM7-V 3.2 TB), 12 x 16 GB DDR5 DRAM 6400 MT/s, AMD Zen5 9455 with
re-installed (since my previous email) Fedora Server 45.

Yesterday NVMe SSDs drives were used for another activity, but now I'm
ready to switch back to test md-raid performance.

[root@family ~]# lsblk
NAME            MAJ:MIN RM   SIZE RO TYPE MOUNTPOINTS
zram0           251:0    0     8G  0 disk [SWAP]
nvme6n1         259:2    0 447.1G  0 disk
=E2=94=9C=E2=94=80nvme6n1p1     259:4    0   600M  0 part /boot/efi
=E2=94=9C=E2=94=80nvme6n1p2     259:5    0     2G  0 part /boot
=E2=94=94=E2=94=80nvme6n1p3     259:6    0 444.5G  0 part
  =E2=94=94=E2=94=80fedora-root 252:0    0 444.5G  0 lvm  /
nvme3n1         259:3    0   2.9T  0 disk
nvme1n1         259:8    0   2.9T  0 disk
nvme5n1         259:10   0   2.9T  0 disk
nvme4n1         259:12   0   2.9T  0 disk
nvme2n1         259:14   0   2.9T  0 disk
nvme0n1         259:16   0   2.9T  0 disk
[root@family ~]#
[root@family ~]# dmesg|grep -i raid6
[    0.492578] raid6: using avx512x2 recovery algorithm
[    0.605293] raid6: skipped pq benchmark and selected avx512x4
[root@family ~]#

Ok, I will create md-raid6 (4+2) with --bitmap=3Dnone and without
lockless.  But which chunk size should I select, default 512K ?

Which kernel should I select ?,

[root@family ~]# uname -r
7.3.3-300.fc45.x86_64

Or 7.4-rc2 ?

I'm not a developer, please provide detailed steps on how to apply the
patch you mentioned.

Anton

=D0=B2=D1=82, 10 =D0=BD=D0=BE=D1=8F=D0=B1. 2026=E2=80=AF=D0=B3. =D0=B2 15:3=
8, Miroslav Cimerman <mc@raidlab.org>:
>
> Hi Anton,
>
> thanks for sharing the numbers. I recently submitted a raid6 patch that
> makes read-modify-writes faster, at least on the Intel machines I have.
> If you have time, could you please test it on your Zen 5 box?
>
>   https://lore.kernel.org/all/20261109030805.25709-1-mc@raidlab.org/
>
> It changes xor_syndrome(), which md uses for small read-modify-writes.
> Your 2 MiB sequential test does not use it, as full-stripe writes
> compute P and Q with gen_syndrome(). Random 4 KiB writes do use it,
> i.e. --rw=3Drandwrite --bs=3D4k:
>
>   echo 2 > /sys/block/md111/md/rmw_level
>   fio --name=3Dtest --rw=3Drandwrite --bs=3D4k --filename=3D/dev/md111 \
>       --direct=3D1 --numjobs=3D1 --iodepth=3D64 --exitall --group_reporti=
ng \
>       --ioengine=3Dio_uring --size=3D100g --runtime=3D60 --time_based=3D1
>
> rmw_level=3D2 is needed on a 4+2 array: a read-modify-write and
> a reconstruct-write both need 3 reads there, and by default md picks
> reconstruct-write on a tie (1 is the default).
>
> One job at QD64 should be enough. md's single raid6 thread should be
> the limit. If the md111_raid6 thread is not near 100% in "top -H", try
> --numjobs=3D4 --iodepth=3D32.
>
> If md111 has the new lockless bitmap and was created without
> --assume-clean, md uses reconstruct-writes in regions not written since
> the array was created. Adding --size=3D100g to fio keeps the writes in
> the start of the array, which your sequential tests have probably
> already written.
>
> Also please make sure that no resync is in progress.
>
> My numbers were measured without a write-intent bitmap, so the
> difference may be smaller with one.
>
> Please make sure that both runs, with and without the patch, use
> avx512x4:
>
>   dmesg | grep 'raid6: using algorithm' | tail -1
>
> The kernel picks the implementation by gen_syndrome() speed when
> raid6_pq is loaded, and the patch only changes the x4 versions (x1 and
> x2 already use normal stores). If another one is picked, reloading
> raid6_pq with md111 stopped runs the benchmark again, or I can send a
> two-line test-only change that forces avx512x4.
>
> Either way, sharing your numbers would help, and a reply with Tested-by
> to the patch if it works for you would be very appreciated.
>
> Thanks,
> Miroslav
