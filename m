Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E5BE441A
	for <linux-raid@vger.kernel.org>; Sat, 30 Dec 2023 01:27:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="QE7aE0Bp"
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-7812275feccso573279585a.3
        for <linux-raid@vger.kernel.org>; Fri, 29 Dec 2023 17:27:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1703899639; x=1704504439; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=j7bE7y7quYKbhctt/HhR2w2sZh6o/+q0T9GNHsHOfP4=;
        b=QE7aE0BpbJ10QVEujq1yVNbFot9b0bQZaryBsQOtUYDWbMyuyhSKKZTwFWyzSaEdAJ
         PhEZlrDJSuJbha5MJ+VgCjSKDDK0I6XWyGJHXoSp7A93Qy/TA3EhWOp8EBOnLcmbm2tt
         AeUz1QJu33d5r8KS7B14Pgdk2FX1NibSOUXydXayEMr/DrfFuPl8nkrVOmc9aoyZkVt2
         K95bq43Uyle265z2f5zbQEF8qcwOf1xGhxb+XpLeb1c4G8a3oCVuFbBAOw2LsiLm7N8s
         X8fBMcM4Rj37outnS5OOYphx+nG9rpe4HuU9bzaJ9FGZKH8fUw8YOJ1nytXwQRqUnncC
         uKzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703899639; x=1704504439;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=j7bE7y7quYKbhctt/HhR2w2sZh6o/+q0T9GNHsHOfP4=;
        b=iqv2ObXLqFxjRervUgcR86I5ZdAdcdUYabG3b6Zx+meEazml5DSZ+Hc60Pkt86OThY
         OXUVvHt03jum1FZqH+sSDwk0HoHc4KVDP8GbxmPyAS8qwIl3eZpBuV66VGkVncAdOVMA
         e2g8rA0tvhhK7neEwIDp+4oy51CVtkHDoaPy0J2GfS1/JZsLjnhgw77ftuq8+RT6yKNk
         ApMFsvxvl367+sSofu2n3424IKkxt/N2f4yvVqgY5obsTp5UiQxkjXNARTpqpd7iE42A
         Y8uixgjydLDmSxYD8nF2SZqqOWwLxdUPsMgSUAgiVyYVJMNnZjwjOxcYjWeGfboEOova
         7NwQ==
X-Gm-Message-State: AOJu0Yy6MlKpWtxjIp2NSjE0GCqs+aPIAjdW3cewFyxeCqjWsjGvrcy3
	TvTGLJmGDbvqqiLgPG4nuGZNpx7Ntv/kwn90vxcanHB2WW1vkQ==
X-Google-Smtp-Source: AGHT+IGT5iEmdmJzYUEj3tQT635kvsElSNvB3lWZfXYgOoYq3AHNTmbjRmcyq9k2sgPyQrqZmsmEJNA+XJTKqQqTLho=
X-Received: by 2002:a05:620a:15b0:b0:781:7848:1b93 with SMTP id
 f16-20020a05620a15b000b0078178481b93mr3202935qkk.90.1703899638999; Fri, 29
 Dec 2023 17:27:18 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CANgGJDrUELtNokv2T45RzaUr_8M8BYPr-AXJ2tpTk9umdK90+Q@mail.gmail.com>
 <da99b77d-61fc-b454-30b6-bf20d536277f@huaweicloud.com> <CANgGJDpsrjbTPDtt7xhDEfx0uheHLo98QsNSFa7Pqbghri4mfg@mail.gmail.com>
 <0d4558cb-0836-e0dd-d100-a1fa11cec74b@huaweicloud.com>
In-Reply-To: <0d4558cb-0836-e0dd-d100-a1fa11cec74b@huaweicloud.com>
From: Alexey Klimov <alexey.klimov@linaro.org>
Date: Sat, 30 Dec 2023 01:27:08 +0000
Message-ID: <CANgGJDrTq0J7Yf49xwspeWBsdVBgbrU7zkJ+-CPy==heFSN1Mg@mail.gmail.com>
Subject: Re: RAID1 write-mostly+write-behind lockup bug, reproduced under 6.7-rc5
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: linux-raid@vger.kernel.org, song@kernel.org, klimov.linux@gmail.com, 
	Mathieu Poirier <mathieu.poirier@linaro.org>, "yukuai (C)" <yukuai3@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 28 Dec 2023 at 12:09, Yu Kuai <yukuai1@huaweicloud.com> wrote:
>
> Hi,
>
> =E5=9C=A8 2023/12/28 12:19, Alexey Klimov =E5=86=99=E9=81=93:
> > On Thu, 14 Dec 2023 at 01:34, Yu Kuai <yukuai1@huaweicloud.com> wrote:
> >>
> >> Hi,
> >>
> >> =E5=9C=A8 2023/12/14 7:48, Alexey Klimov =E5=86=99=E9=81=93:
> >>> Hi all,
> >>>
> >>> After assembling raid1 consisting from two NVMe disks/partitions wher=
e
> >>> one of the NVMes is slower than the other one using such command:
> >>> mdadm --homehost=3Dany --create --verbose --level=3D1 --metadata=3D1.=
2
> >>> --raid-devices=3D2 /dev/md77 /dev/nvme2n1p9 --bitmap=3Dinternal
> >>> --write-mostly --write-behind=3D8192 /dev/nvme1n1p2
> >>>
> >>> I noticed some I/O freezing/lockup issues when doing distro builds
> >>> using yocto. The idea of building write-mostly raid1 came from URL
> >>> [0]. I suspected that massive and long IO operations led to that and
> >>> while trying to narrow it down I can see that it doesn't survive
> >>> through rebuilding linux kernel (just simple make -j33).
> >>>
> >>> After enabling some lock checks in kernel and lockup detectors I thin=
k
> >>> this is the main blocked task message:
> >>>
> >>> [  984.138650] INFO: task kworker/u65:5:288 blocked for more than 491=
 seconds.
> >>> [  984.138682]       Not tainted 6.7.0-rc5-00047-g5bd7ef53ffe5 #1
> >>> [  984.138694] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> >>> disables this message.
> >>> [  984.138702] task:kworker/u65:5   state:D stack:0     pid:288
> >>> tgid:288   ppid:2      flags:0x00004000
> >>> [  984.138728] Workqueue: writeback wb_workfn (flush-9:77)
> >>> [  984.138760] Call Trace:
> >>> [  984.138770]  <TASK>
> >>> [  984.138785]  __schedule+0x3a5/0x1600
> >>> [  984.138807]  ? schedule+0x99/0x120
> >>> [  984.138818]  ? find_held_lock+0x2b/0x80
> >>> [  984.138840]  schedule+0x48/0x120
> >>> [  984.138851]  ? schedule+0x99/0x120
> >>> [  984.138861]  wait_for_serialization+0xd2/0x110
> >>
> >> This is waiting for issued IO to be done, from
> >> raid1_end_write_request
> >>    remove_serial
> >>     raid1_rb_remove
> >>     wake_up
> >
> > Yep, looks like this.
> >
> >> So the first thing need clarification is that is there unfinished IO
> >> from underlying disk? This is not easy, but perhaps you can try:
> >>
> >> 1) don't use the underlying disks by anyone else;
> >> 2) reporduce the problem, and then collect debugfs info for underlying
> >> disks with following cmd:
> >>
> >> find /sys/kernel/debug/block/sda/ -type f | xargs grep .
> >
> > I collected this and attaching to this email.
> > When I collected this debug data I also noticed the following inflight =
counters:
> > root@tux:/sys/devices/virtual/block/md77# cat inflight
> >         0       65
> > root@tux:/sys/devices/virtual/block/md77# cat slaves/nvme1n1p2/inflight
> >         0        0
> > root@tux:/sys/devices/virtual/block/md77# cat slaves/nvme2n1p9/inflight
> >         0        0
> >
> > So I guess on the md or raid1 level there are 65 write requests that
> > didn't finish but nothing from underlying physical devices, right?
>
> Actually, IOs stuck in wait_for_serialization() are accounted by
> inflight from md77.

Do you think ftracing mdXY_raid1 kernel thread with function plugin will he=
lp?

> However, since there are no IO from nvme disks, looks like something is
> wrong with write behind.
>
> >
> > Apart from that. When the lockup/freeze happens I can mount other
> > partitions on the corresponding nvme devices and create files there.
> > nvme-cli util also don't show any issues AFAICS.
> >
> > When I manually set backlog file to zero:
> > echo 0 > /sys/devices/virtual/block/md77/md/bitmap/backlog
> > the lockup is no longer reproducible.
>
> Of course, this disables write behind, which also indicates something
> is wrong with write behind.

Yes, this is in some sense a main topic of my emails. I am just trying
to get you more debugging data.

> I'm trying to review related code, however, this might be difficult,
> can you discribe how do you reporduce this problem in detailed steps?
> and I will try to reporduce this. If I still can't, can you apply a
> debug patch and recompile the kernel to test?

I am trying to reproduce this using files and loops devices and I'll
provide instructions.
Regarding patches: yes, see my first email. I will be happy to test
patches and collect more debug data.

Thanks,
Alexey
