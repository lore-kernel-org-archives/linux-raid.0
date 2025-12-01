Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8880D2D97A9
	for <linux-raid@vger.kernel.org>; Mon,  1 Dec 2025 08:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764578305; cv=none; b=WZtEgK7eXz4Upq09/dn7GPlQOOH6lfLSQHoRdBwCWOpCz6Edn+yQp/ExhOMODWqOVLyw1CqMw7d9ZN2ul4YiPQV4U2M578+BWYxY6gaIZ6QNQXBzp4ToUI9pQ7bgjhHfLxquJrRQaOM4MLkc0WH9rtKw7zXDFdjitaHLo8a5Tg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764578305; c=relaxed/simple;
	bh=fXoiSxBMXPBJYllTDM0tV24rcyzAB/c48bYW9/o3+uU=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=oeNMzSTmYqHGnRK259pdbF/xUEY1TMzriUJk08vP9XW8kqkIXoOBy/fmAElPLpm0y4hHkL7LC9YYEozudfVaP9ZM8vMJULbQ2CH7VA4FVkCdZ8cS8LPK07wKr5rIuOiDRUHQ8MNXmwP5bs4db3BF6mOqmddYDbZVAJIuRg6iU/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kNZ2kkE6; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kNZ2kkE6"
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-b739ef3f739so22793066b.1
        for <linux-raid@vger.kernel.org>; Mon, 01 Dec 2025 00:38:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764578302; x=1765183102; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=qE5VzGvYfKr1Huua8Y7v2cpok19vRITfBUB4nFOT49Q=;
        b=kNZ2kkE6gaGiB12uN8bospLOZjDJDPE7AD/uIBeuwrHSsQnwrlCwEWAifH4kr5kadv
         G5LUs+hbHAWqMeGwVn4JvrHcqqyqYadQR2jf80+aGU3ryAr1xQw66Qrl9hYyX5XX1gGt
         SCfRR2sZuF6C/qSuoyC3+ND95jOObD+MgyCelrH6wOFUytT0kcnGHOnSrhkRr+bhgkE7
         bO6/b+y42uR3elWlQYoIR+UhTiyj/IXGizjKlvZE0BPSHirHgelA3aXeNyXCohtAypA8
         0JdDPelbNPAx6PEjLi5bLLa3K7xwImrsp9jfBAY+VGqal4fdlRcVeAjcskHqYXBs4PqO
         47Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764578302; x=1765183102;
        h=to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qE5VzGvYfKr1Huua8Y7v2cpok19vRITfBUB4nFOT49Q=;
        b=w4OIK00rzKTQ2Bc25U0gsr2glyZBn2sCZpUi6gVP8+SUBPEntxRDK2mMuZOWfoHUxM
         9cXHAsoel3p02WpxJD8/Yp9UgHEaYFgm27rO4+rau4pC+3pBDrG7zlcYhdvGZ1VspRGI
         1xPzIxy/Mf7bPP88sChXCY5h8NQTWvq/LLfBJRgVdVjnakhukyd7J8IKTjZ/gwWvhZoy
         i6DrBHk1U2X8EGo7sn+gOLb9UylXLZtJTyq1jbSoqC9NJnxTJkEPHAV2idmrxRL3lTtN
         MJSuid4H/5jC9poTPRh/ipTQivHRmYy6RHT9/ZpfzOuGFTX+bYQ8vKfugzK7hPIqH5LW
         lRTw==
X-Gm-Message-State: AOJu0YzeGDRT5TOyGx+0jH3uB2P69Ht2TIUZ7BI0KWuHzpSsOz/9G55h
	ChlS8vUAqEH5dFj12WtFzymRnnGHaGFDY4hlOx9a2eT7ANR//w85uYkoMkoCpwmnqO37igPRoJl
	u7naQPKnQLoXFNB9trkL7zZruQ3EDo43oTnGF
X-Gm-Gg: ASbGnctRmnyka54nfPHdUV1z70AilfMqsLKZPLWHZ8+NmQ18mnnSXLbxqMNN7Uw9GqR
	q7cabxW+DKGrapDhMHH/e3tFsApmlbzP9ompmQKzDAdOHYw4K26oI0NMGgyEEpwGShJbt4ldcch
	ISDDDRbgyc4zmaPFDfNpDf0TGmrvRbISDwTv6oPKQyIEJJAmB8Gx6BGNb/vKrtG6sRItInloY+r
	Zb4bFzm94OxHL1uOtCcA7QfwsLqQ9GpgSt95zxk1TcN/5EdQpFe8x3MCsozbD/bR2iT6/24jb99
	+SJ1v2w=
X-Google-Smtp-Source: AGHT+IHvW5n3PhrdnuSUrqf9nsSMJCMDTehWzW6D6pqK8nBS0XWB63O5bs2AvgePzj5pQSLw5pmNzdPBQkejmmbBCg4=
X-Received: by 2002:a17:907:1c09:b0:b72:ad95:c1c2 with SMTP id
 a640c23a62f3a-b76c546d3b4mr2727061566b.11.1764578301522; Mon, 01 Dec 2025
 00:38:21 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Anton Gavriliuk <antosha20xx@gmail.com>
Date: Mon, 1 Dec 2025 10:38:09 +0200
X-Gm-Features: AWmQ_bmRSS2qfNQDOn1Qkv-VaXnf3ohUfuoS3fcAXKXEpXr-ISAQ8O1u8L2gSKA
Message-ID: <CAAiJnjqo0a0gHs3vMBn7kyAAm8LN95=3HPYdzpiSRe3fXtAMkg@mail.gmail.com>
Subject: Support for polled IO completions for md-raid devices
To: linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hello

It is not surprising that polled IO completions significantly reduce
latency and increase IOPS.  Here is an example with a single CM7-V
PCIe 5.0 NVMe SSD.

Interrupts,

[root@memverge4 ~]# fio --name=local_test --ioengine=io_uring
--rw=randread --bs=4K --numjobs=1 --direct=1 --filename=/dev/nvme1n1
--iodepth=64 --fixedbufs=1 --time_based=1 --runtime=20
local_test: (g=0): rw=randread, bs=(R) 4096B-4096B, (W) 4096B-4096B,
(T) 4096B-4096B, ioengine=io_uring, iodepth=64
fio-3.41-49-gde3d
Starting 1 process
Jobs: 1 (f=1): [r(1)][100.0%][r=2936MiB/s][r=752k IOPS][eta 00m:00s]
local_test: (groupid=0, jobs=1): err= 0: pid=96203: Mon Dec  1 10:29:47 2025
  read: IOPS=746k, BW=2915MiB/s (3056MB/s)(56.9GiB/20001msec)
    slat (nsec): min=510, max=931130, avg=993.69, stdev=462.86
    clat (usec): min=44, max=1056, avg=84.48, stdev=12.57
     lat (usec): min=45, max=1057, avg=85.48, stdev=12.60

Polling,

[root@memverge4 ~]# fio --name=local_test --ioengine=io_uring
--rw=randread --bs=4K --numjobs=1 --direct=1 --filename=/dev/nvme1n1
--iodepth=64 --fixedbufs=1 --hipri=1 --time_based=1 --runtime=20
local_test: (g=0): rw=randread, bs=(R) 4096B-4096B, (W) 4096B-4096B,
(T) 4096B-4096B, ioengine=io_uring, iodepth=64
fio-3.41-49-gde3d
Starting 1 process
Jobs: 1 (f=1): [r(1)][100.0%][r=4618MiB/s][r=1182k IOPS][eta 00m:00s]
local_test: (groupid=0, jobs=1): err= 0: pid=96543: Mon Dec  1 10:32:41 2025
  read: IOPS=1174k, BW=4588MiB/s (4810MB/s)(89.6GiB/20001msec)
    slat (nsec): min=510, max=909786, avg=663.38, stdev=410.86
    clat (usec): min=34, max=1024, avg=53.69, stdev= 6.33
     lat (usec): min=35, max=1024, avg=54.36, stdev= 6.34

Dut it doesn't work for md-raid device,

[root@memverge4 ~]# cat /proc/mdstat
Personalities : [raid0]
md127 : active raid0 nvme6n1[5] nvme0n1[3] nvme5n1[0] nvme2n1[1]
nvme3n1[4] nvme1n1[2]
      18752907264 blocks super 1.2 512k chunks

unused devices: <none>
[root@memverge4 ~]#
[root@memverge4 ~]# fio --name=local_test --ioengine=io_uring
--rw=randread --bs=4K --numjobs=1 --direct=1 --filename=/dev/md127
--iodepth=64 --fixedbufs=1 --hipri=1 --time_based=1 --runtime=20
local_test: (g=0): rw=randread, bs=(R) 4096B-4096B, (W) 4096B-4096B,
(T) 4096B-4096B, ioengine=io_uring, iodepth=64
fio-3.41-49-gde3d
Starting 1 process
fio: file /dev/md127 exceeds 32-bit tausworthe random generator.
fio: Switching to tausworthe64. Use the random_generator= option to
get rid of this warning.
fio: io_u error on file /dev/md127: Operation not supported: read
offset=18761783697408, buflen=4096
fio: io_u error on file /dev/md127: Operation not supported: read
offset=17577830526976, buflen=4096
fio: io_u error on file /dev/md127: Operation not supported: read
offset=16065491521536, buflen=4096
fio: io_u error on file /dev/md127: Operation not supported: read
offset=15054980657152, buflen=4096
...............................................

I'm not a developer or programmer.

May I ask as a feature request to add support for polling IO
completions for md-raid devices ?

Anton
