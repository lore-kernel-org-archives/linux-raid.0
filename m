Received: from sg-1-33.ptr.blmpb.com (sg-1-33.ptr.blmpb.com [118.26.132.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 016821FF1C4
	for <linux-raid@vger.kernel.org>; Mon,  1 Dec 2025 08:52:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764579126; cv=none; b=FENJtkUR8dB85Xe9XiyVIZvYytvSbu8sZ0lfurp4Frb4zMvXh+wgUCjNmepmgIykkCZtLsUIlwgQs34wXeWmGUrKtqpoFtboD83/0aNe3syVZ7Hb9+qnHaZR4AgsLq4En3rLdFhyqLXwLkP+6dhQwcYos06uRIvq8kZ2M2+zhao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764579126; c=relaxed/simple;
	bh=gwp4KqQTxHZiwyyej/YFvcqW05NEAZx7ZdRYYGssNP8=;
	h=From:Mime-Version:References:Message-Id:Content-Type:In-Reply-To:
	 To:Subject:Date; b=cy6F5Jyxm+w5WtRUwzhR0JJyH/rKBrQBCqPh2uVY5KHPzD2v4Q4E6CmrM2uOPUP1YbggTmiHd2Z7B65e0GVWdU7XCP9sTqp6e0gj+cAuRJYQx6T8c9PkucGuHlyT8ag54zIuRciuS+eVTt6WghAi09eEIcCsCkvNieTq+BAvTRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=C40+IZxk; arc=none smtp.client-ip=118.26.132.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="C40+IZxk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1764579105;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=oh/5ASCSMPR7696RIIr6GlMidn5UuO9vE7ZygoTDxOw=;
 b=C40+IZxkTz7c0UyGwfk6R5kAlFVmrlzYqOn63pnsccJLhazTjF+I8QsrVK+AjLd9IYSL9I
 X3I8C25jgLox/qTkxukCH+DaiATXWkO3nMup/+YCgFC4MDTGXSYMy0/ilBGoRbWs4Fq9dj
 3mu4ZvPdoS8kVZxEMmX33WkyIulR78wsonIyYE5SW7Jmss662bJZCQMqrOUb9Xi2h1bixi
 ADwjobZTGhhL+eY7jEOQqmAw3KvgGU9Lvccce6eMUXmmeRkjPwfuZFs3PxRZyhtCofBPBf
 tOISqQz62G+uXppglIDqn9WEJF6l7Kq5K00zK52SrIRvy5YpEFkQek6nE6OCag==
From: "Yu Kuai" <yukuai@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Received: from [192.168.1.104] ([39.182.0.153]) by smtp.feishu.cn with ESMTPS; Mon, 01 Dec 2025 16:51:42 +0800
Content-Language: en-US
Reply-To: yukuai@fnnas.com
Content-Transfer-Encoding: quoted-printable
User-Agent: Mozilla Thunderbird
References: <CAAiJnjqo0a0gHs3vMBn7kyAAm8LN95=3HPYdzpiSRe3fXtAMkg@mail.gmail.com>
Organization: fnnas
Message-Id: <7544a246-cf67-42d3-836e-edd0b842ea46@fnnas.com>
X-Original-From: Yu Kuai <yukuai@fnnas.com>
Content-Type: text/plain; charset=UTF-8
In-Reply-To: <CAAiJnjqo0a0gHs3vMBn7kyAAm8LN95=3HPYdzpiSRe3fXtAMkg@mail.gmail.com>
To: "Anton Gavriliuk" <antosha20xx@gmail.com>, <linux-raid@vger.kernel.org>
Subject: Re: Support for polled IO completions for md-raid devices
Date: Mon, 1 Dec 2025 16:51:41 +0800
X-Lms-Return-Path: <lba+2692d571f+ac3fdc+vger.kernel.org+yukuai@fnnas.com>

Hi,

=E5=9C=A8 2025/12/1 16:38, Anton Gavriliuk =E5=86=99=E9=81=93:
> Hello
>
> It is not surprising that polled IO completions significantly reduce
> latency and increase IOPS.  Here is an example with a single CM7-V
> PCIe 5.0 NVMe SSD.
>
> Interrupts,
>
> [root@memverge4 ~]# fio --name=3Dlocal_test --ioengine=3Dio_uring
> --rw=3Drandread --bs=3D4K --numjobs=3D1 --direct=3D1 --filename=3D/dev/nv=
me1n1
> --iodepth=3D64 --fixedbufs=3D1 --time_based=3D1 --runtime=3D20
> local_test: (g=3D0): rw=3Drandread, bs=3D(R) 4096B-4096B, (W) 4096B-4096B=
,
> (T) 4096B-4096B, ioengine=3Dio_uring, iodepth=3D64
> fio-3.41-49-gde3d
> Starting 1 process
> Jobs: 1 (f=3D1): [r(1)][100.0%][r=3D2936MiB/s][r=3D752k IOPS][eta 00m:00s=
]
> local_test: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D96203: Mon Dec  1 10=
:29:47 2025
>    read: IOPS=3D746k, BW=3D2915MiB/s (3056MB/s)(56.9GiB/20001msec)
>      slat (nsec): min=3D510, max=3D931130, avg=3D993.69, stdev=3D462.86
>      clat (usec): min=3D44, max=3D1056, avg=3D84.48, stdev=3D12.57
>       lat (usec): min=3D45, max=3D1057, avg=3D85.48, stdev=3D12.60
>
> Polling,
>
> [root@memverge4 ~]# fio --name=3Dlocal_test --ioengine=3Dio_uring
> --rw=3Drandread --bs=3D4K --numjobs=3D1 --direct=3D1 --filename=3D/dev/nv=
me1n1
> --iodepth=3D64 --fixedbufs=3D1 --hipri=3D1 --time_based=3D1 --runtime=3D2=
0
> local_test: (g=3D0): rw=3Drandread, bs=3D(R) 4096B-4096B, (W) 4096B-4096B=
,
> (T) 4096B-4096B, ioengine=3Dio_uring, iodepth=3D64
> fio-3.41-49-gde3d
> Starting 1 process
> Jobs: 1 (f=3D1): [r(1)][100.0%][r=3D4618MiB/s][r=3D1182k IOPS][eta 00m:00=
s]
> local_test: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D96543: Mon Dec  1 10=
:32:41 2025
>    read: IOPS=3D1174k, BW=3D4588MiB/s (4810MB/s)(89.6GiB/20001msec)
>      slat (nsec): min=3D510, max=3D909786, avg=3D663.38, stdev=3D410.86
>      clat (usec): min=3D34, max=3D1024, avg=3D53.69, stdev=3D 6.33
>       lat (usec): min=3D35, max=3D1024, avg=3D54.36, stdev=3D 6.34
>
> Dut it doesn't work for md-raid device,
>
> [root@memverge4 ~]# cat /proc/mdstat
> Personalities : [raid0]
> md127 : active raid0 nvme6n1[5] nvme0n1[3] nvme5n1[0] nvme2n1[1]
> nvme3n1[4] nvme1n1[2]
>        18752907264 blocks super 1.2 512k chunks
>
> unused devices: <none>
> [root@memverge4 ~]#
> [root@memverge4 ~]# fio --name=3Dlocal_test --ioengine=3Dio_uring
> --rw=3Drandread --bs=3D4K --numjobs=3D1 --direct=3D1 --filename=3D/dev/md=
127
> --iodepth=3D64 --fixedbufs=3D1 --hipri=3D1 --time_based=3D1 --runtime=3D2=
0
> local_test: (g=3D0): rw=3Drandread, bs=3D(R) 4096B-4096B, (W) 4096B-4096B=
,
> (T) 4096B-4096B, ioengine=3Dio_uring, iodepth=3D64
> fio-3.41-49-gde3d
> Starting 1 process
> fio: file /dev/md127 exceeds 32-bit tausworthe random generator.
> fio: Switching to tausworthe64. Use the random_generator=3D option to
> get rid of this warning.
> fio: io_u error on file /dev/md127: Operation not supported: read
> offset=3D18761783697408, buflen=3D4096
> fio: io_u error on file /dev/md127: Operation not supported: read
> offset=3D17577830526976, buflen=3D4096
> fio: io_u error on file /dev/md127: Operation not supported: read
> offset=3D16065491521536, buflen=3D4096
> fio: io_u error on file /dev/md127: Operation not supported: read
> offset=3D15054980657152, buflen=3D4096
> ...............................................
>
> I'm not a developer or programmer.
>
> May I ask as a feature request to add support for polling IO
> completions for md-raid devices ?

This will help improve performance if underlying disks are nvme, I
can add this to my todo list(with low priority), but I can't guarantee
when will this be done. :( Meanwhile, feel free to take a look if anyone
is interested.

>
> Anton
>
--=20
Thanks,
Kuai
