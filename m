Received: from mail-wm1-f66.google.com (mail-wm1-f66.google.com [209.85.128.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCF03647
	for <linux-raid@vger.kernel.org>; Sat,  8 Jun 2024 02:16:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.66
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717812971; cv=none; b=D/rhlMrRh1nJx8iiZxOQUgT8VJCHjNxxhrVm07QxSXcX3k0kEp7BLiKXG9SCSlGuzkdqGjmWY7PMbKeMnP+tD4a//SMpnlOFPuqVDYxYRGrUGUszhRBp0QrXAgHQYqyrFb33nbb+zc4pgtCZ1wHNIU+FLlOaWhF7hoF5EfOYnB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717812971; c=relaxed/simple;
	bh=vPuVlaZzn503E/TxPNpvu3n4Dd0ySPWgfiELgmlR0yU=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=KvGy2s+QNYhkfWoHAJYTVo0c6xwqpaRtbQpkZUv6GLlXJOYUOpokGxuCSpVw2ze0lGbjCpRMAvfCTbzw1x+pG1Gzlv8kugLD14mln7yKymYFPrMrjvOyTtpBJKbcDnN5jyORIhuirY+ZzqWWfXEK4ZJ9DuMgr7PicSNrOOtS/vI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pkm-inc.com; spf=pass smtp.mailfrom=pkm-inc.com; dkim=pass (2048-bit key) header.d=pkm-inc.com header.i=@pkm-inc.com header.b=gIInccYv; arc=none smtp.client-ip=209.85.128.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pkm-inc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pkm-inc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pkm-inc.com header.i=@pkm-inc.com header.b="gIInccYv"
Received: by mail-wm1-f66.google.com with SMTP id 5b1f17b1804b1-42111cf2706so3435675e9.0
        for <linux-raid@vger.kernel.org>; Fri, 07 Jun 2024 19:16:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pkm-inc.com; s=google; t=1717812967; x=1718417767; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vPuVlaZzn503E/TxPNpvu3n4Dd0ySPWgfiELgmlR0yU=;
        b=gIInccYvC5/2qeMMXTg2vKihRAyWBxMyGAFiTOzY6UZjKzHZllRDsh5eoKnNFzw8Yh
         j9+UHz8pGY3Tujqib3DuPPPePuzCow5Y7SibQICqZ8oEyzM0np7A8UJbx6DvdbzhIGvz
         +RWqkZyzRslSj1s5BgNfL95QwTieBaC+Ea+ojS1VV4rLs/XeKi6NPUpNIR5TLnonxKSE
         mCLAyH7AcAD/lgcQyTU4fc1nHL/N5FCH98MBT8Sw5TXQNf3YWfuX7ZPvB3Er3CQuU2hX
         dhviLk+ixl4eWOZBnig6zudcL7/pNXELM0r2Rzp3LdMrFhiPTRL5720jYIOHMA5yFkRe
         SmPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717812967; x=1718417767;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=vPuVlaZzn503E/TxPNpvu3n4Dd0ySPWgfiELgmlR0yU=;
        b=TlEevk5+0RW1v7Jn0p2H8Csynz3dOR5Nza5ObVS2CMWRk9gV6HcTyHcqJPwi/+PhJV
         kt+y//hCN1V3bWV5ADPPMRvvsWYvzMplG6D0XohnDTAx4VCFWLc8sdA63Fsn3qtr/Sp6
         S7oIW/BSL5FqYPtN1sfP42viHnJJ1ANjvnsW5IAnlWYbcznxgJraYTf1RBaJHRQCbwZS
         p1rmaSRLw+ObXXjgRpLtBPs6gIUqvWDLoC5kJhXdtdeV0/+D+zNGQE4wecwLTX4PiCZp
         b25QllKEulz2kfkohQmmK5xLIM2wrai4BxWVNLm6LXqzYAewk1xmkpDLbrVZEpArRvpB
         CJlw==
X-Gm-Message-State: AOJu0YwbrNym89o37mG8HeaGa1hqu0VBAai0dA5JBzUYSOxjV43fZDbe
	3X6X/POYuvHbB1PUDjzHiTqfJEQw8sF4PIZB9KoN/Bb2CZtrm5u+7pKmRTDuT1UcNFLEgbTrjva
	kqUfRVQZW
X-Google-Smtp-Source: AGHT+IEuvPgxZFLsWK3SutVqDZWxJ/rN/myugRUKjUMk0CK59zG24TloNzWvPF6ySqilODi+fl9SWg==
X-Received: by 2002:a05:600c:314a:b0:421:29b4:5339 with SMTP id 5b1f17b1804b1-4216499ba4bmr31373225e9.0.1717812966630;
        Fri, 07 Jun 2024 19:16:06 -0700 (PDT)
Received: from [10.8.0.8] (93-86-103-73.dynamic.isp.telekom.rs. [93.86.103.73])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-421580fe34fsm101278325e9.4.2024.06.07.19.16.05
        for <linux-raid@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Jun 2024 19:16:06 -0700 (PDT)
Message-ID: <1af8f1e0-4f41-4f25-bc34-f655a4c141b4@pkm-inc.com>
Date: Sat, 8 Jun 2024 04:16:05 +0200
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: linux-raid@vger.kernel.org
From: =?UTF-8?Q?Dragan_Milivojevi=C4=87?= <galileo@pkm-inc.com>
Subject: Is NVMe RAID0 useless (performance-wise) for common workloads?
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi all

Sorry about the length of this email; I tried to include all that I found relevant.
While building a new PostgreSQL server, I noticed that single disk performance is the
same or better than a RAID0 4-disk array.

All benchmarks were done with: pgbench -j 4 -c 512 -P 60 -r -T 300 -b tpcb-like test

For example, single disk run:

latency average = 17.524 ms
latency stddev = 6.904 ms
tps = 28870


iostat:

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           26.10    0.00   21.02    2.95    0.00   49.93

| Device  |    r/s   |  rMB/s | rrqm/s | %rrqm | r_await | rareq-sz |    w/s   |  wMB/s | wrqm/s | %wrqm | w_await | wareq-sz |   f/s  | f_await | aqu-sz | %util |
|---------|:--------:|:------:|:------:|:-----:|:-------:|:--------:|:--------:|:------:|:------:|:-----:|:-------:|:--------:|:------:|:-------:|:------:|:-----:|
| nvme0n1 | 28641.27 | 255.00 |   0.00 |  0.00 |    0.16 | 9.12 | 27665.67 | 458.09 |   0.00 |  0.00 |    0.09 |    16.96 | 251.47 |    1.69 |   7.69 | 98.08 |



RAID0 4 disk, 4K chunk result:

latency average = 22.269 ms
latency stddev = 10.825 ms
tps = 22742


avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           23.63    0.00   19.63    1.53    0.00   55.21

| Device  |    r/s   |  rMB/s |  rrqm/s | %rrqm | r_await | rareq-sz |    w/s    |  wMB/s | wrqm/s | %wrqm | w_await | wareq-sz |   f/s  | f_await | aqu-sz | %util |
|---------|:--------:|:------:|:-------:|:-----:|:-------:|:--------:|:---------:|:------:|:------:|:-----:|:-------:|:--------:|:------:|:-------:|:------:|:-----:|
| md127   | 55359.93 | 216.25 |    0.00 |  0.00 |    0.09 | 4.00 | 105629.07 | 412.61 |   0.00 |  0.00 |    0.04 |     4.00 |   0.00 |    0.00 |   9.02 | 93.76 |
| nvme1n1 | 12763.33 |  54.03 | 1067.47 |  7.72 |    0.08 | 4.33 |  26572.07 | 103.31 |  37.33 |  0.14 |    0.05 |     3.98 | 162.53 |    1.74 |   2.67 | 99.18 |
| nvme3n1 | 12753.07 |  53.97 | 1063.87 |  7.70 |    0.08 | 4.33 |  26560.47 | 103.26 |  37.40 |  0.14 |    0.05 |     3.98 | 162.47 |    1.73 |   2.58 | 99.15 |
| nvme4n1 | 12787.27 |  54.10 | 1062.80 |  7.67 |    0.09 | 4.33 |  26492.73 | 102.99 |  35.67 |  0.13 |    0.05 |     3.98 | 162.53 |    1.69 |   2.67 | 99.07 |
| nvme5n1 | 12796.53 |  54.15 | 1065.60 |  7.69 |    0.09 | 4.33 |  26505.67 | 103.04 |  35.73 |  0.13 |    0.05 |     3.98 | 162.53 |    1.66 |   2.56 | 98.95 |


BTW, if these tables are mangled in transport or by email clients, I posted this email to https://pastebin.com/raw/hyM3i12d.

With this RAID configuration, a single disk wins by a comfortable margin.
PostgreSQL uses 8K I/O, so I would expect a 2x increase in performance?

I performed many different tests, tried chunk sizes from 8K to 512K, enabled poll_queues (4 queues),
io_polling, partitioned the drives into 4 partitions and assembled 4 RAID arrays and combined them with
LVM (inspired by this thread: https://yhbt.net/lore/all/5EAED86C53DED2479E3E145969315A2385841062@UMECHPA7B.easf.csd.disa.mil/t/#u), etc.,
and nothing worked. I even tried a ZFS RAID0 zvol with XFS on top of it (performance was abysmal, ~12K tps).
The best that I got was with a plain RAID0 256K chunk, ~31K tps, a 10% uplift compared to a single drive.

In the linked thread, it was suggested that this could be an issue with the lack of blk-mq support for MD devices,
but I'm not sure if that applies to this use case.

As all my attempts to make this work failed, I ran a series of simple sequential read tests against a single disk and various RAID arrays,
trying to rule out MD as a source of the problem. A sample of the results is below.
Unfortunately, I haven't been able to reach a conclusion, hence this email.



System specs:

Dell PowerEdge R7525
Dual AMD EPYC 7313
"Samsung SSD 980 PRO with Heatsink 2TB" drives
All drives under test are connected to the same processor.
AlmaLinux release 9.4 (Seafoam Ocelot)
Kernel 5.14.0-427.18.1.el9_4.x86_64
tuned-adm profile postgresql
poll_queues=4, io_poll = 1



Tests were done using dd_rescue
buffered reads: sync; echo 3 > /proc/sys/vm/drop_caches; dd_rescue -m 64G -b 4k -B 4k /dev/md/raid0 /dev/null
O_DIRECT reads: sync; echo 3 > /proc/sys/vm/drop_caches; dd_rescue -d -m 64G -b 4k -B 4k /dev/md/raid0 /dev/null

Summary of the results:

|                                   | Read 4K | Read 64K | Read 128K | Read 256K | Read 512K |
|-----------------------------------|---------|----------|-----------|-----------|-----------|
| Single disk buffered              | 1.39G/s | 2.27G/s  | 2.29G/s   | 2.31G/s   | 2.32G/s   |
| Single disk O_DIRECT              | 0.31G/s | 2.18G/s  | 2.68G/s   | 2.75G/s   | 4G/s      |
| Raid 0, 4 disk 4K chunk buffered  | 1G/s    | 1.36G/s  | 1.38G/s   | 1.38G/s   | 1.39G/s   |
| Raid 0, 4 disk 4K chunk O_DIRECT  | 0.27G/s | 0.94G/s  | 0.98G/s   | 1.01G/s   | 1.04G/s   |
| Raid 0, 4 disk 64K chunk buffered | 1.42G/s | 2.2G/s   | 2.24G/s   | 2.26G/s   | 2.26G/s   |
| Raid 0, 4 disk 64K chunk O_DIRECT | 0.29G/s | 2.12G/s  | 3.86G/s   | 5.59G/s   | 6.75G/s   |


First thing that stands out is that buffered reads do not scale.


Buffered reads, single disk vs RAID0 64K chunk
===============================================================


Single disk, buffered read 128K

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
            0.03    0.00    1.99    0.00    0.00   97.98

| Device  | r/s      | rMB/s   | rrqm/s | %rrqm | r_await | rareq-sz | aqu-sz | %util |
|---------|----------|---------|--------|-------|---------|----------|--------|-------|
| nvme4n1 | 19874.80 | 2483.20 | 0.60   | 0.00  | 0.68    | 127.94   | 13.60  | 68.74 |



RAID0 64K chunk, buffered read 128K

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
            0.02    0.00    2.61    0.00    0.00   97.37

| Device  |      r/s |   rMB/s |  rrqm/s | %rrqm | r_await | rareq-sz | aqu-sz | %util |
|---------|---------:|--------:|--------:|------:|--------:|---------:|-------:|------:|
| md127   | 42779.80 | 2201.60 |    0.00 |  0.00 |    1.04 | 52.70 |  44.37 | 28.84 |
| nvme0n1 |  4410.00 |  551.25 | 6287.60 | 58.78 |    1.24 | 128.00 |   5.48 | 28.76 |
| nvme1n1 |  4405.00 |  550.62 | 6280.00 | 58.77 |    0.93 | 128.00 |   4.10 | 26.54 |
| nvme2n1 |  4430.00 |  551.20 | 6283.00 | 58.65 |    1.20 | 127.41 |   5.33 | 28.72 |
| nvme4n1 |  4407.80 |  550.77 | 6294.40 | 58.81 |    0.89 | 127.95 |   3.90 | 26.42 |



Maybe it's request merging?

echo 2 > /sys/block/md127/queue/nomerges
for dev in /sys/block/nvme[0-3]n1/queue/nomerges; do echo 2 > $dev; done


avg-cpu:  %user   %nice %system %iowait  %steal   %idle
            0.01    0.00    2.92    0.00    0.00   97.07

| Device  |    r/s   |  rMB/s  | rrqm/s | %rrqm | r_await | rareq-sz | aqu-sz | %util |
|---------|:--------:|:-------:|:------:|:-----:|:-------:|:--------:|:------:|:-----:|
| md127   | 42619.60 | 2169.60 |   0.00 |  0.00 |    0.71 | 52.13 |  30.14 | 28.82 |
| nvme0n1 | 10641.00 |  542.40 |   0.00 |  0.00 |    0.68 | 52.20 |   7.20 | 27.90 |
| nvme2n1 | 10652.20 |  542.40 |   0.00 |  0.00 |    0.63 | 52.14 |   6.68 | 27.68 |
| nvme5n1 | 10659.60 |  542.40 |   0.00 |  0.00 |    0.77 | 52.10 |   8.22 | 28.70 |
| nvme6n1 | 10666.80 |  542.40 |   0.00 |  0.00 |    0.74 | 52.07 |   7.92 | 28.52 |


No change, it just prevents the 64K requests sent to the md device to be merged into
128K requests to the disks.

Why is max_sectors_kb for this RAID array limited to 64K when underlying devices are at 128?

While I'm at it, it's strange that no matter the device type, max_sectors_kb seems to be limited at 128.
For example: "Dell DC NVMe CD8 U.2 960GB" (re-branded Kioxia KCD8XRUG960G), "Samsung SSD 980 PRO with Heatsink 2TB" and
INTEL MEMPEK1J016GAL (old Optane M10), all vastly different devices, have the same max_sectors_kb.
Also all of these devices show practically the same performance when doing 4K O_DIRECT reads.
As if there is some hard limit, related to latency, somewhere?



RAID0 64K chunk, buffered read 512K

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
            0.01    0.00    2.12    0.00    0.00   97.87

| Device  |    r/s   |  rMB/s  |  rrqm/s | %rrqm | r_await | rareq-sz | aqu-sz | %util |
|---------|:--------:|:-------:|:-------:|:-----:|:-------:|:--------:|:------:|:-----:|
| md127   | 41381.20 | 2284.80 |    0.00 |  0.00 |    1.08 | 56.54 |  44.61 | 30.14 |
| nvme0n1 |  4569.60 |  571.20 | 5773.00 | 55.82 |    1.37 | 128.00 |   6.27 | 30.16 |
| nvme1n1 |  4569.60 |  571.20 | 5767.00 | 55.79 |    0.91 | 128.00 |   4.16 | 27.00 |
| nvme2n1 |  4584.20 |  571.20 | 5768.60 | 55.72 |    1.33 | 127.59 |   6.11 | 30.04 |
| nvme4n1 |  4570.40 |  571.18 | 5775.40 | 55.82 |    0.86 | 127.97 |   3.94 | 26.90 |


512K should be 2 full stripes and yet there is no change.

This behaviour would explain why I get no appreciable performance uplift with PostgreSQL, but I failed
to find a way to change this. Are there any tunables that can help with this issue?


I made an attempt to figure out what is going on, so I started by comparing single disk buffered reads versus O_DIRECT.


Single disk, buffered vs O_DIRECT
===============================================================

Read 4K
---------------
buffered 1.39G/s

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
            0.12    0.00    2.57    0.00    0.00   97.31

| Device  | r/s      | rMB/s   | rrqm/s | %rrqm | r_await | rareq-sz | aqu-sz | %util |
|---------|----------|---------|--------|-------|---------|----------|--------|-------|
| nvme4n1 | 10534.40 | 1316.80 | 0.00   | 0.00  | 0.90    | 128.00   | 9.51   | 44.38 |


O_DIRECT 0.31G/s

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
            0.02    0.00    0.36    0.74    0.00   98.88

| Device  | r/s      | rMB/s  | rrqm/s | %rrqm | r_await | rareq-sz | aqu-sz | %util  |
|---------|----------|--------|--------|-------|---------|----------|--------|--------|
| nvme4n1 | 82912.40 | 323.88 | 0.00   | 0.00  | 0.01    | 4.00     | 0.69   | 100.00 |


Makes sense, larger request and queue size.



Read 64K
---------------
buffered 2.27G/s

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
            0.02    0.00    3.13    0.00    0.00   96.85

| Device  | r/s      | rMB/s   | rrqm/s | %rrqm | r_await | rareq-sz | aqu-sz | %util |
|---------|----------|---------|--------|-------|---------|----------|--------|-------|
| nvme4n1 | 16859.00 | 2107.20 | 0.60   | 0.00  | 0.71    | 127.99   | 11.96  | 59.06 |


aqu-sz is higher (compared to the 4K result), but await is lower? How?


O_DIRECT  2.18G/s

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
            0.03    0.00    0.46    1.09    0.00   98.43

| Device  | r/s      | rMB/s   | rrqm/s | %rrqm | r_await | rareq-sz | aqu-sz | %util  |
|---------|----------|---------|--------|-------|---------|----------|--------|--------|
| nvme3n1 | 36139.40 | 2258.71 | 0.00   | 0.00  | 0.02    | 64.00    | 0.82   | 100.02 |


Compared to a buffered 64K read, await is 35 times lower so that's why it's almost the same result?



Read 256K
---------------

buffered    2.31G/s

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
            0.02    0.00    1.57    0.00    0.00   98.41


| Device  | r/s      | rMB/s   | rrqm/s | %rrqm | r_await | rareq-sz | aqu-sz | %util |
|---------|----------|---------|--------|-------|---------|----------|--------|-------|
| nvme4n1 | 21662.20 | 2707.62 | 0.60   | 0.00  | 0.68    | 127.99   | 14.79  | 74.42 |



O_DIRECT    2.75G/s

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
            0.01    0.00    0.42    1.16    0.00   98.41

| Device  | r/s      | rMB/s   | rrqm/s | %rrqm | r_await | rareq-sz | aqu-sz | %util  |
|---------|----------|---------|--------|-------|---------|----------|--------|--------|
| nvme4n1 | 22542.40 | 2817.80 | 0.00   | 0.00  | 0.07    | 128.00   | 1.50   | 100.00 |


The same as with 64K reads, but this time O_DIRECT gets higher results due to a deeper queue compared
to the O_DIRECT 64K result. Kind of makes sense.



Read 512K
---------------

buffered    2.32G/s

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
            0.01    0.00    2.43    0.00    0.00   97.56

| Device  | r/s      | rMB/s   | rrqm/s | %rrqm | r_await | rareq-sz | aqu-sz | %util |
|---------|----------|---------|--------|-------|---------|----------|--------|-------|
| nvme4n1 | 18972.60 | 2371.20 | 0.60   | 0.00  | 0.70    | 127.98   | 13.24  | 66.14 |


O_DIRECT    4G/s


avg-cpu:  %user   %nice %system %iowait  %steal   %idle
            0.01    0.00    0.54    1.00    0.00   98.44

| Device  | r/s      | rMB/s   | rrqm/s | %rrqm | r_await | rareq-sz | aqu-sz | %util |
|---------|----------|---------|--------|-------|---------|----------|--------|-------|
| nvme2n1 | 32124.13 | 4015.52 | 0.00   | 0.00  | 0.07    | 128.00   | 2.24   | 97.46 |


Buffered read has plateaued; maybe this drive can't handle aqu-sz greater than ~11?
O_DIRECT read: Linear increase in aqu-sz, compared to the 256K result, leads to the same performance uplift.
Why is there practically no performance uplift for O_DIRECT reads from 64K to 256K?

Not much makes sense so far. Maybe an example where things work as expected (more or less) will bring some clarity.



O_DIRECT 64K single disk vs O_DIRECT RAID0
===============================================================

single disk O_DIRECT 64K 2.18G/s

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
            0.03    0.00    0.46    1.09    0.00   98.43

| Device  | r/s      | rMB/s   | rrqm/s | %rrqm | r_await | rareq-sz | aqu-sz | %util  |
|---------|----------|---------|--------|-------|---------|----------|--------|--------|
| nvme3n1 | 36139.40 | 2258.71 | 0.00   | 0.00  | 0.02    | 64.00    | 0.82   | 100.02 |


single disk O_DIRECT 128K 2.68G/s

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
            0.02    0.00    0.35    1.20    0.00   98.43


| Device  | r/s      | rMB/s   | rrqm/s | %rrqm | r_await | rareq-sz | aqu-sz | %util  |
|---------|----------|---------|--------|-------|---------|----------|--------|--------|
| nvme3n1 | 22162.20 | 2770.25 | 0.00   | 0.00  | 0.04    | 128.00   | 0.87   | 100.00 |


Request size doubled yet minor change in BW.



RAID0 O_DIRECT 256K (full stripe) read 5.59G/s

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
            0.01    0.00    0.91    0.46    0.00   98.61

| Device  |    r/s   |  rMB/s  | rrqm/s | %rrqm | r_await | rareq-sz | aqu-sz |  %util |
|---------|:--------:|:-------:|:------:|:-----:|:-------:|:--------:|:------:|:------:|
| md127   | 89868.00 | 5616.75 |  0.00  |  0.00 |   0.02  | 64.00  |  2.23  | 100.00 |
| nvme0n1 | 22467.20 | 1404.20 |  0.00  |  0.00 |   0.03  | 64.00  |  0.57  | 100.00 |
| nvme1n1 | 22467.20 | 1404.20 |  0.00  |  0.00 |   0.02  | 64.00  |  0.55  | 100.00 |
| nvme2n1 | 22467.20 | 1404.19 |  0.00  |  0.00 |   0.02  | 64.00  |  0.53  | 100.00 |
| nvme4n1 | 22467.00 | 1404.19 |  0.00  |  0.00 |   0.02  | 64.00  |  0.53  | 100.00 |


Compared to a single disk 64K read, this is a 2.5X uplift, a far cry from the theoretical 4X
but at least it's an increase. It seems to align with the increase in aqu-sz: 2.23/0.82 ≈ 5.59G/2.18G.

Why is rareq-sz 64? It should be 128 in line with the max_sectors_kb limit?



RAID0 O_DIRECT 512K (2x full stripes) read 6.75G/s


avg-cpu:  %user   %nice %system %iowait  %steal   %idle
            0.01    0.00    1.20    0.30    0.00   98.49

| Device  |    r/s    |  rMB/s  | rrqm/s | %rrqm | r_await | rareq-sz | aqu-sz |  %util |
|---------|:---------:|:-------:|:------:|:-----:|:-------:|:--------:|:------:|:------:|
| md127   | 109051.40 | 6815.71 |   0.00 |  0.00 |    0.03 | 64.00 |   3.01 | 100.00 |
| nvme0n1 |  27263.00 | 1703.94 |   0.00 |  0.00 |    0.03 | 64.00 |   0.79 | 100.00 |
| nvme1n1 |  27262.80 | 1703.92 |   0.00 |  0.00 |    0.03 | 64.00 |   0.76 | 100.00 |
| nvme2n1 |  27263.00 | 1703.94 |   0.00 |  0.00 |    0.02 | 64.00 |   0.67 | 100.00 |
| nvme4n1 |  27263.00 | 1703.94 |   0.00 |  0.00 |    0.03 | 64.00 |   0.72 | 100.00 |


Compared to a single disk 64K read: 3x increase. aqu-sz ratio is 3.01/0.82 = 3.6. Reaching a plateau?

Can someone answer some of these questions?

Thanks
Dragan



