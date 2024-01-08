Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 792A779CC
	for <linux-raid@vger.kernel.org>; Mon,  8 Jan 2024 06:04:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="fjwuyCAt"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-3373a30af67so1467891f8f.0
        for <linux-raid@vger.kernel.org>; Sun, 07 Jan 2024 22:04:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1704693855; x=1705298655; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=o+BisOXYa+/n7tJ3z1WME3Nlpg7Ny3AuMbRuZdgu2n0=;
        b=fjwuyCAtqayZK9rFTofe5Igf7BozT/N3PTaP2P+ONkO15keZyvOEQ8EiBFRjU0tfoz
         KeWAPNyjMkdC80FpCRkZWymwvM9UTwzjDJAenR2Vcrw/FN2BmpH1MMu6gYwD3BWJ703e
         1T7D2OgZWrYF+zemhtYtcclTRcSSIsyAh2dvash8IoEtjJ/9UpZqhT9VVWNWgGuXAFdl
         cp8+7k0MJr2C5TcsD26glapJnJetM6e4+9hs4wt4Xk/Qqth3hObmtTQglU4GYBFNl5xc
         3IBFjzArMamytyv2r/0pEBkL2KFPla/pkB0+yQ8BXbTzHszrqCrkJybfyvXW9AFp8W3K
         ZtfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704693855; x=1705298655;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=o+BisOXYa+/n7tJ3z1WME3Nlpg7Ny3AuMbRuZdgu2n0=;
        b=AwlHvewnVWis0o8lTtmpA0CiPNRcMtPiVtX7jgPTp/7ujWapl3MO2vRvg1aMJihLR8
         igNFfkUd88o5KyuEqfLCPOII5y2zRMQaOhbkK5WQ9Z0i3HgDvsLlD2b+/V/knW7f9FWU
         G7alrqiFQw/XiFAB3N8QElxFf/XmXNMx5pbjRqBUDI1Vntb2FJDMuRpqp764bOdm2227
         JTVnpN8zBDjUMn14WWsNe9p5XCgus2OvDoNWMaOjYLf41D0yNmdI8UWFeHAVzBcLh3ud
         xVyq/4Z8hw5SbpEQKHBl9lH2Dri0skcnBvdR0PIpeAyYbhOeSAV5xXMeW9vlPTbsGNrl
         NdpA==
X-Gm-Message-State: AOJu0YwixumrhBCs3PbaTYOvPP0ot7MtudiRfu+zmeSZcgww5viHOrES
	eagOL4Llgx+z0MLYjgHy0N5zu5srw+3Cfw==
X-Google-Smtp-Source: AGHT+IGBvEr684uOARu7cYuRtYxQJO5212oc+0/ZFj1rAR930e4WTqxyovwYYKH082Zq78zKK1TZuQ==
X-Received: by 2002:a5d:4106:0:b0:333:2fd2:3bdf with SMTP id l6-20020a5d4106000000b003332fd23bdfmr1132397wrp.152.1704693855435;
        Sun, 07 Jan 2024 22:04:15 -0800 (PST)
Received: from ?IPv6:2a02:c7c:7213:c700:e992:6869:474c:a63f? ([2a02:c7c:7213:c700:e992:6869:474c:a63f])
        by smtp.gmail.com with ESMTPSA id c17-20020a5d4cd1000000b00336a0c083easm6822608wrt.53.2024.01.07.22.04.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Jan 2024 22:04:15 -0800 (PST)
Message-ID: <9fbdcab961db9f6bd16bf1884b3aae66bd112bbf.camel@linaro.org>
Subject: Re: RAID1 write-mostly+write-behind lockup bug, reproduced under
 6.7-rc5
From: Alexey Klimov <alexey.klimov@linaro.org>
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: linux-raid@vger.kernel.org, song@kernel.org, klimov.linux@gmail.com, 
 Mathieu Poirier <mathieu.poirier@linaro.org>, "yukuai (C)"
 <yukuai3@huawei.com>
Date: Mon, 08 Jan 2024 06:04:14 +0000
In-Reply-To: <3f960a46-082e-8945-1118-649fc6918228@huaweicloud.com>
References: 
	<CANgGJDrUELtNokv2T45RzaUr_8M8BYPr-AXJ2tpTk9umdK90+Q@mail.gmail.com>
	 <da99b77d-61fc-b454-30b6-bf20d536277f@huaweicloud.com>
	 <CANgGJDpsrjbTPDtt7xhDEfx0uheHLo98QsNSFa7Pqbghri4mfg@mail.gmail.com>
	 <0d4558cb-0836-e0dd-d100-a1fa11cec74b@huaweicloud.com>
	 <CANgGJDrTq0J7Yf49xwspeWBsdVBgbrU7zkJ+-CPy==heFSN1Mg@mail.gmail.com>
	 <3f960a46-082e-8945-1118-649fc6918228@huaweicloud.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.50.2-1 
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Tue, 2024-01-02 at 10:54 +0800, Yu Kuai wrote:
> Hi,
>=20
> =E5=9C=A8 2023/12/30 9:27, Alexey Klimov =E5=86=99=E9=81=93:
> > On Thu, 28 Dec 2023 at 12:09, Yu Kuai <yukuai1@huaweicloud.com>
> > wrote:
> > >=20
> > > Hi,
> > >=20
> > > =E5=9C=A8 2023/12/28 12:19, Alexey Klimov =E5=86=99=E9=81=93:
> > > > On Thu, 14 Dec 2023 at 01:34, Yu Kuai <yukuai1@huaweicloud.com>
> > > > wrote:
> > > > >=20
> > > > > Hi,
> > > > >=20
> > > > > =E5=9C=A8 2023/12/14 7:48, Alexey Klimov =E5=86=99=E9=81=93:
> > > > > > Hi all,
> > > > > >=20
> > > > > > After assembling raid1 consisting from two NVMe
> > > > > > disks/partitions where
> > > > > > one of the NVMes is slower than the other one using such
> > > > > > command:
> > > > > > mdadm --homehost=3Dany --create --verbose --level=3D1 --
> > > > > > metadata=3D1.2
> > > > > > --raid-devices=3D2 /dev/md77 /dev/nvme2n1p9 --bitmap=3Dinternal
> > > > > > --write-mostly --write-behind=3D8192 /dev/nvme1n1p2
> > > > > >=20
> > > > > > I noticed some I/O freezing/lockup issues when doing distro
> > > > > > builds
> > > > > > using yocto. The idea of building write-mostly raid1 came
> > > > > > from URL
> > > > > > [0]. I suspected that massive and long IO operations led to
> > > > > > that and
> > > > > > while trying to narrow it down I can see that it doesn't
> > > > > > survive
> > > > > > through rebuilding linux kernel (just simple make -j33).
> > > > > >=20
> > > > > > After enabling some lock checks in kernel and lockup
> > > > > > detectors I think
> > > > > > this is the main blocked task message:
> > > > > >=20
> > > > > > [=C2=A0 984.138650] INFO: task kworker/u65:5:288 blocked for
> > > > > > more than 491 seconds.
> > > > > > [=C2=A0 984.138682]=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Not tai=
nted 6.7.0-rc5-00047-
> > > > > > g5bd7ef53ffe5 #1
> > > > > > [=C2=A0 984.138694] "echo 0 >
> > > > > > /proc/sys/kernel/hung_task_timeout_secs"
> > > > > > disables this message.
> > > > > > [=C2=A0 984.138702] task:kworker/u65:5=C2=A0=C2=A0 state:D stac=
k:0=C2=A0=C2=A0=C2=A0=C2=A0
> > > > > > pid:288
> > > > > > tgid:288=C2=A0=C2=A0 ppid:2=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 flags=
:0x00004000
> > > > > > [=C2=A0 984.138728] Workqueue: writeback wb_workfn (flush-9:77)
> > > > > > [=C2=A0 984.138760] Call Trace:
> > > > > > [=C2=A0 984.138770]=C2=A0 <TASK>
> > > > > > [=C2=A0 984.138785]=C2=A0 __schedule+0x3a5/0x1600
> > > > > > [=C2=A0 984.138807]=C2=A0 ? schedule+0x99/0x120
> > > > > > [=C2=A0 984.138818]=C2=A0 ? find_held_lock+0x2b/0x80
> > > > > > [=C2=A0 984.138840]=C2=A0 schedule+0x48/0x120
> > > > > > [=C2=A0 984.138851]=C2=A0 ? schedule+0x99/0x120
> > > > > > [=C2=A0 984.138861]=C2=A0 wait_for_serialization+0xd2/0x110
> > > > >=20
> > > > > This is waiting for issued IO to be done, from
> > > > > raid1_end_write_request
> > > > > =C2=A0=C2=A0=C2=A0 remove_serial
> > > > > =C2=A0=C2=A0=C2=A0=C2=A0 raid1_rb_remove
> > > > > =C2=A0=C2=A0=C2=A0=C2=A0 wake_up
> > > >=20
> > > > Yep, looks like this.
> > > >=20
> > > > > So the first thing need clarification is that is there
> > > > > unfinished IO
> > > > > from underlying disk? This is not easy, but perhaps you can
> > > > > try:
> > > > >=20
> > > > > 1) don't use the underlying disks by anyone else;
> > > > > 2) reporduce the problem, and then collect debugfs info for
> > > > > underlying
> > > > > disks with following cmd:
> > > > >=20
> > > > > find /sys/kernel/debug/block/sda/ -type f | xargs grep .
> > > >=20
> > > > I collected this and attaching to this email.
> > > > When I collected this debug data I also noticed the following
> > > > inflight counters:
> > > > root@tux:/sys/devices/virtual/block/md77# cat inflight
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 65
> > > > root@tux:/sys/devices/virtual/block/md77# cat
> > > > slaves/nvme1n1p2/inflight
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 0
> > > > root@tux:/sys/devices/virtual/block/md77# cat
> > > > slaves/nvme2n1p9/inflight
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 0
> > > >=20
> > > > So I guess on the md or raid1 level there are 65 write requests
> > > > that
> > > > didn't finish but nothing from underlying physical devices,
> > > > right?
> > >=20
> > > Actually, IOs stuck in wait_for_serialization() are accounted by
> > > inflight from md77.
> >=20
> > Do you think ftracing mdXY_raid1 kernel thread with function plugin
> > will help?
> >=20
> > > However, since there are no IO from nvme disks, looks like
> > > something is
> > > wrong with write behind.
> > >=20
> > > >=20
> > > > Apart from that. When the lockup/freeze happens I can mount
> > > > other
> > > > partitions on the corresponding nvme devices and create files
> > > > there.
> > > > nvme-cli util also don't show any issues AFAICS.
> > > >=20
> > > > When I manually set backlog file to zero:
> > > > echo 0 > /sys/devices/virtual/block/md77/md/bitmap/backlog
> > > > the lockup is no longer reproducible.
> > >=20
> > > Of course, this disables write behind, which also indicates
> > > something
> > > is wrong with write behind.
> >=20
> > Yes, this is in some sense a main topic of my emails. I am just
> > trying
> > to get you more debugging data.
> >=20
> > > I'm trying to review related code, however, this might be
> > > difficult,
> > > can you discribe how do you reporduce this problem in detailed
> > > steps?
> > > and I will try to reporduce this. If I still can't, can you apply
> > > a
> > > debug patch and recompile the kernel to test?
> >=20
> > I am trying to reproduce this using files and loops devices and
> > I'll
> > provide instructions.
> > Regarding patches: yes, see my first email. I will be happy to test
> > patches and collect more debug data.
>=20
> Attached patch can provide debug info for each r10_bio that is
> serialized or wait for serialization, to judge if the problem is
> related to r1_bio dispatching or serialization algorithm.
>=20
> After the problem is reporduced, just cat /sys/block/md77/md/debug

I haven't yet tested it with that patch to collect debug info, I'll try
to do it during this week. But I managed to reproduce it on another
physical set of NVMe disks. As far as I understand it won't be possible
to reproduce it on two fast disks. To reproduce it one of the disks
should be slower -- to achieve that I connected one of the NVMe disks
via pcie-to-usb adapter (raid sync speed was around 40Mb/s).

Here are the instructions to reproduce it.

0. Prepare disks. I am using one physical nvme disk over usb and one
loop file on fast nvme disk.

time dd if=3D/dev/zero of=3Dfile0 bs=3D1M count=3D96k status=3Dprogress
losetup -f file0

1. Create raid1 device with write-mostly+write-behind
mdadm --homehost=3Dany --create --verbose --level=3D1 --metadata=3D1.2 \
--raid-devices=3D2 /dev/md96 /dev/loop0 --bitmap=3Dinternal \
--write-mostly --write-behind=3D8192 /dev/sda

2. Format it.
mkfs.ext4 -v -m 0 -b 4096 -O fast_commit,metadata_csum \
-E lazy_itable_init=3D0,lazy_journal_init=3D0 /dev/md96

3. Mount somewhere
sudo mount /dev/md96 md96 -o noatime,user,exec

4. Right now in order to reproduce it I compile android mainline kernel
for Pixel6 devices. I just copy the repository to the md96 but it can
be synced online.

https://source.android.com/docs/setup/build/building-pixel-kernels
Section: Download and Compile the Kernel

repo init -u https://android.googlesource.com/kernel/manifest -b gs-
android-gs-raviole-mainline

repo sync -f --fail-fast --force-sync --force-remove-dirty -v -j4 -c \
--no-tags  --jobs-checkout=3D$(nproc)

5. The compilation commands:
tools/bazel clean
tools/bazel run --config=3Dstamp //private/google-
modules/soc/gs:slider_dist


You can monitor inflight counters here. Once the second counter goes as
high as 65 or larger then mostly likely the freeze/hang already
happened.
watch -d -n 1 cat /sys/devices/virtual/block/md96/inflight

I think there should be other tests to reproduce it, it seems massive
I/O is required with some long amount of write requests. Also this can
be reproduced with two loop file devices -- one on fast nvme disk and
another file is on slow nvme disk.

I think that without loop devices it takes significantly more time to
repair the filesystem and I can't confirm that there are no some file
corruptions after that fsck.

Hope this works.

Best regards,
Alexey
