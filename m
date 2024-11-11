Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56BCF1991A3
	for <linux-raid@vger.kernel.org>; Mon, 11 Nov 2024 11:59:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731326376; cv=none; b=XpE7yx+dI1DFdn7FcWuW2WYM7vj5CwfREdKkBxTakJKEONtJJhRX2tDNikgsyMDPEzr20JYuVL3dXL6j4cjRMCVeWnUsJ1m2xvJGp9UceHIUHyozyrG8WJZvpQn7NqWDitR7C8CUnqF7XXGNMYyisLbD55fgPfusDhr6HufZPEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731326376; c=relaxed/simple;
	bh=YoZPDmmhrPebQD3/pbETEw2AHc0FEc1o+YKLGmCUE98=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=T8v0CaRfo/vMFINz6ZfwDqoKI4ZoBKc0ERO95UQzThBhZXZbbiivmQAqHQ7Sy+C6pkLimfBlTkLxp43oBk33dGfU3FmLnq/Ir3cvuqrV/222+56b00ie7SikckFiXE49IAa/V04lExTrqioFrOumuHyGTWe0sOzF6LO7uzUSAYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pkm-inc.com; spf=pass smtp.mailfrom=pkm-inc.com; dkim=pass (2048-bit key) header.d=pkm-inc.com header.i=@pkm-inc.com header.b=fpfs4uQp; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pkm-inc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pkm-inc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pkm-inc.com header.i=@pkm-inc.com header.b="fpfs4uQp"
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-a9e8522445dso796358966b.1
        for <linux-raid@vger.kernel.org>; Mon, 11 Nov 2024 03:59:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pkm-inc.com; s=google; t=1731326372; x=1731931172; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gOw65c1va8iyapaV9MsyfbXAp3IEX2tLULW7gYuxwg8=;
        b=fpfs4uQpr/ZqYPx+sEhmgXUElAcmMvGqNDHGRn73nG6dYhKgtkTo72UOEwFJnzv1XV
         +Wo2Do0AYnnFyiq/E2DimDPi58sGbwyfjdb7WN+obuWpwCKgrE8mfgnTuBpfFBvOg3fp
         x9DV5xZ6UthTpg2rOP7EIHrb211jKacLpEnG4ZY2Yo1yV5VCRhAx358l2o8z4WG1E2EE
         d2F/sdMbkxLGARchsQ3N6QmFHOxX4r/7/qs3AlCI38toauRsmCcF6NxPXLhZKWiWkIAP
         3/50Ruiex/cnL7ni1QjQKrupgvYDcsy3vBAzxhgnvEDIlViXpwxy5SzDw7bBL9XeTnjJ
         r9rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731326372; x=1731931172;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gOw65c1va8iyapaV9MsyfbXAp3IEX2tLULW7gYuxwg8=;
        b=Iiq0knNgifzH5ASVlo1I57Wq+lyvP9PYxH6dBPR0G8D+mA+Vuw0olJpM6gFFitaKer
         Z5KwONZu4Rt5vUEMuociPL22YxrXABJjrt4UDluPI985bq+DtExRWLCBnEdw5dEGJs6X
         JErfgc0l1DP4/1oGkBrlOhn4vI1QBbzWDoolA7xNcoKO6C/c4QkCL35ggtO0JVOrFA30
         JBr6gjei/ezFzSJKVYLr5kqfDRkrgOHIgexORT1HZxIhs76riRcNMO7hbKvXlj6mVCXC
         ijFM0uVj4QP0zUN7I7Q6o0Lg3JbibT6J8hXovfTatmeEAv7Py2LWfnmQb4l7qQQHYz31
         mUEw==
X-Forwarded-Encrypted: i=1; AJvYcCXfOPrEVxU5UNGC5Ik2FaxiPSa7EqiojuMuY5sXOOfYBu3BPLCiSBxOJ9wixEZn+tulS2b8iN+1SbA6@vger.kernel.org
X-Gm-Message-State: AOJu0YxpoKWlBeZltKtu2DMkRszi/Tk9/aOnLTp2vduC8MdxndldYEAy
	UdWxajUpGB7g2C36w1WcJV7ysdwEBE5EUDlf+dWD1m92KJeu4s5L1RdWGdhCCF8=
X-Google-Smtp-Source: AGHT+IEgAM3gZvmh9YCYWB2YNuBAjCWg50z4I0bi4gWMRUzhkzvR0kFrMpaGo0pBegabxrQN/X2pEg==
X-Received: by 2002:a17:907:3f86:b0:a9e:8612:f201 with SMTP id a640c23a62f3a-a9ef0019406mr1308966866b.59.1731326371161;
        Mon, 11 Nov 2024 03:59:31 -0800 (PST)
Received: from [10.8.0.8] (178-221-200-39.dynamic.isp.telekom.rs. [178.221.200.39])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9ee0deebabsm581360766b.153.2024.11.11.03.59.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Nov 2024 03:59:30 -0800 (PST)
Message-ID: <cf00703f-f4bd-4b6a-9626-72d839ebaf7b@pkm-inc.com>
Date: Mon, 11 Nov 2024 12:59:29 +0100
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH md-6.13] md: remove bitmap file support
To: Yu Kuai <yukuai1@huaweicloud.com>, "yukuai (C)" <yukuai3@huawei.com>
Cc: Song Liu <song@kernel.org>, linux-raid@vger.kernel.org,
 linux-kernel@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com,
 "Luse, Paul E" <paul.e.luse@intel.com>
References: <20241107125911.311347-1-yukuai1@huaweicloud.com>
 <CAPhsuW7Ry0iUs6X7P4jL5CX3+8EGfb5uL=g-q_8jVR-g19ummQ@mail.gmail.com>
 <ef4dcb9e-a2fa-d9dc-70c1-e58af6e71227@huaweicloud.com>
 <CAPhsuW4tcXqL3K3Pdgy_LDK9E6wnuzSkgWbmyXXqAa=qjAnv7A@mail.gmail.com>
 <CALtW_agCsNM66DppGO-0Trq2Nzyn3ytg1t8OKACnRT5Yar7vUQ@mail.gmail.com>
 <8ae77126-3e26-2c6a-edb6-83d2f1090ebe@huaweicloud.com>
 <CALtW_ajYN4byY_hWLyKadAyLa9Rmi==j6yCYjLLUuR_nttKMrQ@mail.gmail.com>
 <36659c34-08bf-2103-a762-ce9e75e8262e@huaweicloud.com>
 <CALtW_ai-xfkphuch64f2n544cfWzg__59bwX3Yxkf-N61K-SvA@mail.gmail.com>
 <8dc1ee79-fd64-70d7-bb48-b38920c1cddd@huaweicloud.com>
Content-Language: en-GB
From: =?UTF-8?Q?Dragan_Milivojevi=C4=87?= <galileo@pkm-inc.com>
In-Reply-To: <8dc1ee79-fd64-70d7-bb48-b38920c1cddd@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/11/2024 03:04, Yu Kuai wrote:

> Yes, as I said please show me you how you creat the array and your test
> script. I must know what you are testing, like single threaded or high
> concurrency. For example your result shows bitmap none close to bitmap
> external, this is impossible in our previous results. I can only guess
> that you're testing single threaded.

All of that is included in the previously linked pastebin.
I will include the contents of that pastebin at the end of this email if that helps.
Every test includes the mdadm create line, disk settings, md settings, fio test line
used and the results and the typical iostat output during the test. I hope that is
sufficient.
  
> BTW, it'll be great if you can provide some perf results of the internal
> bitmap in your case, that will show us directly where is the bottleneck.

Not right now, this server is in production and I'm not sure if I will be able
to get it to an idle state or to find the time to do it due to other projects.

>> BTW do you guys do performance tests? All of the raid levels are
> 
> We do, but we never test external bitmap.

I wasn't referring to that, more to the fact that there is a huge difference in
performance between no bitmap and bitmap or that raid (even "simple" levels like 0)
do not scale with real world workloads.

The contents of that pastebin, hopefully my email client won't mess up the formating:


5 disk RAID5, 64K chunk

Summary

Test                   BW         IOPS
bitmap internal 64M    700KiB/s   174
bitmap internal 128M   702KiB/s   175
bitmap internal 512M   1142KiB/s  285
bitmap internal 1024M  40.4MiB/s  10.3k
bitmap internal 2G     66.5MiB/s  17.0k
bitmap external 64M    67.8MiB/s  17.3k
bitmap external 1024M  76.5MiB/s  19.6k
bitmap none            80.6MiB/s  20.6k
Single disk 1K         54.1MiB/s  55.4k
Single disk 4K         269MiB/s   68.8k




AlmaLinux release 9.4 (Seafoam Ocelot)
5.14.0-427.20.1.el9_4


nvme list
Node                  Generic               SN                   Model                                    Namespace  Usage                      Format           FW Rev
--------------------- --------------------- -------------------- ---------------------------------------- ---------- -------------------------- ---------------- --------
/dev/nvme0n1          /dev/ng0n1            1460A0F9TSTJ         Dell DC NVMe CD8 U.2 960GB               0x1        122.33  GB / 960.20  GB    512   B +  0 B   2.0.0
/dev/nvme1n1          /dev/ng1n1            S6WRNJ0WA04045P      Samsung SSD 980 PRO with Heatsink 2TB    0x1          0.00   B /   2.00  TB    512   B +  0 B   5B2QGXA7
/dev/nvme2n1          /dev/ng2n1            S6WRNJ0WA04048B      Samsung SSD 980 PRO with Heatsink 2TB    0x1          0.00   B /   2.00  TB    512   B +  0 B   5B2QGXA7
/dev/nvme3n1          /dev/ng3n1            S6WRNJ0W810396H      Samsung SSD 980 PRO with Heatsink 2TB    0x1          0.00   B /   2.00  TB    512   B +  0 B   5B2QGXA7
/dev/nvme4n1          /dev/ng4n1            S6WRNJ0W808149N      Samsung SSD 980 PRO with Heatsink 2TB    0x1          0.00   B /   2.00  TB    512   B +  0 B   5B2QGXA7
/dev/nvme5n1          /dev/ng5n1            S6WRNJ0WA04043Z      Samsung SSD 980 PRO with Heatsink 2TB    0x1          0.00   B /   2.00  TB    512   B +  0 B   5B2QGXA7
/dev/nvme6n1          /dev/ng6n1            PHBT909504AH016N     INTEL MEMPEK1J016GAL                     0x1         14.40  GB /  14.40  GB    512   B +  0 B   K4110420
/dev/nvme7n1          /dev/ng7n1            S6WRNJ0WA04036R      Samsung SSD 980 PRO with Heatsink 2TB    0x1          0.00   B /   2.00  TB    512   B +  0 B   5B2QGXA7
/dev/nvme8n1          /dev/ng8n1            S6WRNJ0WA04050H      Samsung SSD 980 PRO with Heatsink 2TB    0x1          0.00   B /   2.00  TB    512   B +  0 B   5B2QGXA7




bitmap internal 64M
================================================================
mdadm --verbose --create --assume-clean --bitmap=internal --bitmap-chunk=64M /dev/md/raid5 --name=raid5 --level=5 --chunk=64K --raid-devices=5 /dev/nvme{1..5}n1

for dev in /dev/nvme{1..5}n1; do blockdev --setra 256 $dev; done
blockdev --setra 1024 /dev/md/raid5

echo 8 > /sys/block/md127/md/group_thread_cnt
echo 8192 > /sys/block/md127/md/stripe_cache_size


fio --filename=/dev/md/raid5 --direct=1 --rw=randwrite --bs=4k --ioengine=libaio --iodepth=1 --runtime=60 --numjobs=1 --group_reporting --time_based --name=Raid5

Raid5: (g=0): rw=randwrite, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=libaio, iodepth=1
fio-3.35
Starting 1 process
Jobs: 1 (f=1): [w(1)][100.0%][w=716KiB/s][w=179 IOPS][eta 00m:00s]
Raid5: (groupid=0, jobs=1): err= 0: pid=4718: Sun Jun 30 02:18:30 2024
   write: IOPS=174, BW=700KiB/s (717kB/s)(41.0MiB/60005msec); 0 zone resets
     slat (usec): min=4, max=18062, avg=11.28, stdev=176.21
     clat (usec): min=46, max=13308, avg=5700.08, stdev=1194.59
      lat (usec): min=53, max=22717, avg=5711.36, stdev=1206.03
     clat percentiles (usec):
      |  1.00th=[   51],  5.00th=[ 5800], 10.00th=[ 5800], 20.00th=[ 5866],
      | 30.00th=[ 5866], 40.00th=[ 5866], 50.00th=[ 5866], 60.00th=[ 5932],
      | 70.00th=[ 5932], 80.00th=[ 5932], 90.00th=[ 5932], 95.00th=[ 5997],
      | 99.00th=[ 6194], 99.50th=[ 8586], 99.90th=[10290], 99.95th=[13042],
      | 99.99th=[13042]
    bw (  KiB/s): min=  608, max=  752, per=100.00%, avg=700.03, stdev=20.93, samples=119
    iops        : min=  152, max=  188, avg=175.01, stdev= 5.23, samples=119
   lat (usec)   : 50=0.68%, 100=3.23%
   lat (msec)   : 10=95.99%, 20=0.10%
   cpu          : usr=0.08%, sys=0.24%, ctx=10503, majf=0, minf=8
   IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
      issued rwts: total=0,10499,0,0 short=0,0,0,0 dropped=0,0,0,0
      latency   : target=0, window=0, percentile=100.00%, depth=1

Run status group 0 (all jobs):
   WRITE: bw=700KiB/s (717kB/s), 700KiB/s-700KiB/s (717kB/s-717kB/s), io=41.0MiB (43.0MB), run=60005-60005msec


avg-cpu:  %user   %nice %system %iowait  %steal   %idle
            0.00    0.00    0.07    0.00    0.00   99.93

Device   r/s    rMB/s  rrqm/s  %rrqm  r_await  rareq-sz  w/s     wMB/s  wrqm/s  %wrqm  w_await  wareq-sz  f/s     f_await  aqu-sz  %util
md127    0.00   0.00   0.00    0.00   0.00     0.00      175.47  0.69   0.00    0.00   5.68     4.00      0.00    0.00     1.00    100.00
nvme1n1  69.40  0.27   0.00    0.00   0.01     4.00      237.80  0.93   0.00    0.00   3.55     4.00      168.47  0.81     0.98    95.59
nvme2n1  69.20  0.27   0.00    0.00   0.01     4.00      237.60  0.93   0.00    0.00   3.55     4.00      168.47  0.81     0.98    95.61
nvme3n1  72.20  0.28   0.00    0.00   0.01     4.00      240.60  0.94   0.00    0.00   3.51     4.00      168.47  0.83     0.98    95.29
nvme4n1  68.07  0.27   0.00    0.00   0.02     4.00      236.53  0.92   0.00    0.00   3.57     4.00      168.47  0.81     0.98    95.65
nvme5n1  72.07  0.28   0.00    0.00   0.02     4.00      240.53  0.94   0.00    0.00   3.52     4.00      168.47  0.83     0.99    95.31


mdadm -X /dev/nvme1n1
         Filename : /dev/nvme1n1
            Magic : 6d746962
          Version : 4
             UUID : 77fa1a1b:2f0dd646:adc85c8e:985513a8
           Events : 3
   Events Cleared : 3
            State : OK
        Chunksize : 64 MB
           Daemon : 5s flush period
       Write Mode : Normal
        Sync Size : 1953382464 (1862.89 GiB 2000.26 GB)
           Bitmap : 29807 bits (chunks), 1517 dirty (5.1%)


bitmap internal 128M
================================================================
for dev in /dev/nvme{1..5}n1; do nvme format --force $dev; done

mdadm --verbose --create --assume-clean --bitmap=internal --bitmap-chunk=128M /dev/md/raid5 --name=raid5 --level=5 --chunk=64K --raid-devices=5 /dev/nvme{1..5}n1

for dev in /dev/nvme{1..5}n1; do blockdev --setra 256 $dev; done
blockdev --setra 1024 /dev/md/raid5

echo 8 > /sys/block/md127/md/group_thread_cnt
echo 8192 > /sys/block/md127/md/stripe_cache_size


fio --filename=/dev/md/raid5 --direct=1 --rw=randwrite --bs=4k --ioengine=libaio --iodepth=1 --runtime=60 --numjobs=1 --group_reporting --time_based --name=Raid5

Raid5: (g=0): rw=randwrite, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=libaio, iodepth=1
fio-3.35
Starting 1 process
Jobs: 1 (f=1): [w(1)][100.0%][w=716KiB/s][w=179 IOPS][eta 00m:00s]
Raid5: (groupid=0, jobs=1): err= 0: pid=6283: Sun Jun 30 02:49:06 2024
   write: IOPS=175, BW=702KiB/s (719kB/s)(41.1MiB/60002msec); 0 zone resets
     slat (usec): min=8, max=18200, avg=16.06, stdev=177.21
     clat (usec): min=61, max=20048, avg=5675.78, stdev=1968.88
      lat (usec): min=74, max=22975, avg=5691.84, stdev=1976.14
     clat percentiles (usec):
      |  1.00th=[   68],  5.00th=[   73], 10.00th=[ 5866], 20.00th=[ 5932],
      | 30.00th=[ 5932], 40.00th=[ 5932], 50.00th=[ 5932], 60.00th=[ 5997],
      | 70.00th=[ 5997], 80.00th=[ 5997], 90.00th=[ 5997], 95.00th=[ 6063],
      | 99.00th=[14615], 99.50th=[15008], 99.90th=[16188], 99.95th=[16319],
      | 99.99th=[16319]
    bw (  KiB/s): min=  384, max=  816, per=99.97%, avg=702.12, stdev=72.52, samples=119
    iops        : min=   96, max=  204, avg=175.53, stdev=18.13, samples=119
   lat (usec)   : 100=7.62%, 250=0.01%
   lat (msec)   : 10=90.80%, 20=1.56%, 50=0.01%
   cpu          : usr=0.11%, sys=0.34%, ctx=10539, majf=0, minf=8
   IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
      issued rwts: total=0,10534,0,0 short=0,0,0,0 dropped=0,0,0,0
      latency   : target=0, window=0, percentile=100.00%, depth=1

Run status group 0 (all jobs):
   WRITE: bw=702KiB/s (719kB/s), 702KiB/s-702KiB/s (719kB/s-719kB/s), io=41.1MiB (43.1MB), run=60002-60002msec





avg-cpu:  %user   %nice %system %iowait  %steal   %idle
            0.00    0.00    0.08    0.00    0.00   99.92

Device   r/s    rMB/s  rrqm/s  %rrqm  r_await  rareq-sz  w/s     wMB/s  wrqm/s  %wrqm  w_await  wareq-sz  f/s     f_await  aqu-sz  %util
md127    0.00   0.00   0.00    0.00   0.00     0.00      173.73  0.68   0.00    0.00   5.73     4.00      0.00    0.00     1.00    99.99
nvme1n1  65.87  0.26   0.00    0.00   0.01     4.00      226.07  0.65   0.00    0.00   3.60     2.94      160.20  0.81     0.94    92.46
nvme2n1  71.33  0.28   0.00    0.00   0.02     4.00      231.53  0.67   0.00    0.00   3.50     2.96      160.27  0.84     0.95    91.79
nvme3n1  68.60  0.27   0.00    0.00   0.02     4.00      228.80  0.66   0.00    0.00   3.68     2.95      160.27  0.93     0.99    94.37
nvme4n1  68.87  0.27   0.00    0.00   0.02     4.00      229.07  0.66   0.00    0.00   3.52     2.95      160.20  0.81     0.94    91.59
nvme5n1  72.80  0.28   0.00    0.00   0.02     4.00      233.00  0.68   0.00    0.00   3.53     2.97      160.27  0.87     0.96    92.29


mdadm -X /dev/nvme1n1
         Filename : /dev/nvme1n1
            Magic : 6d746962
          Version : 4
             UUID : 93fdcd4b:ae61a1f8:4d809242:2cd4a4c7
           Events : 3
   Events Cleared : 3
            State : OK
        Chunksize : 128 MB
           Daemon : 5s flush period
       Write Mode : Normal
        Sync Size : 1953382464 (1862.89 GiB 2000.26 GB)
           Bitmap : 14904 bits (chunks), 1617 dirty (10.8%)





bitmap internal 512M
================================================================
for dev in /dev/nvme{1..5}n1; do nvme format --force $dev; done

mdadm --verbose --create --assume-clean --bitmap=internal --bitmap-chunk=512M /dev/md/raid5 --name=raid5 --level=5 --chunk=64K --raid-devices=5 /dev/nvme{1..5}n1

for dev in /dev/nvme{1..5}n1; do blockdev --setra 256 $dev; done
blockdev --setra 1024 /dev/md/raid5

echo 8 > /sys/block/md127/md/group_thread_cnt
echo 8192 > /sys/block/md127/md/stripe_cache_size


fio --filename=/dev/md/raid5 --direct=1 --rw=randwrite --bs=4k --ioengine=libaio --iodepth=1 --runtime=60 --numjobs=1 --group_reporting --time_based --name=Raid5


Raid5: (g=0): rw=randwrite, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=libaio, iodepth=1
fio-3.35
Starting 1 process
Jobs: 1 (f=1): [w(1)][100.0%][w=1232KiB/s][w=308 IOPS][eta 00m:00s]
Raid5: (groupid=0, jobs=1): err= 0: pid=6661: Sun Jun 30 02:58:11 2024
   write: IOPS=285, BW=1142KiB/s (1169kB/s)(66.9MiB/60006msec); 0 zone resets
     slat (usec): min=4, max=18130, avg=10.80, stdev=138.54
     clat (usec): min=42, max=13261, avg=3490.08, stdev=2945.95
      lat (usec): min=50, max=22827, avg=3500.88, stdev=2949.63
     clat percentiles (usec):
      |  1.00th=[   49],  5.00th=[   51], 10.00th=[   52], 20.00th=[   55],
      | 30.00th=[   58], 40.00th=[   72], 50.00th=[ 5866], 60.00th=[ 5932],
      | 70.00th=[ 5932], 80.00th=[ 5932], 90.00th=[ 5997], 95.00th=[ 5997],
      | 99.00th=[ 6128], 99.50th=[ 8586], 99.90th=[ 9896], 99.95th=[13042],
      | 99.99th=[13042]
    bw (  KiB/s): min=  600, max= 1648, per=99.68%, avg=1138.89, stdev=188.44, samples=119
    iops        : min=  150, max=  412, avg=284.72, stdev=47.11, samples=119
   lat (usec)   : 50=3.41%, 100=38.62%, 250=0.04%, 500=0.03%
   lat (msec)   : 10=57.83%, 20=0.07%
   cpu          : usr=0.09%, sys=0.40%, ctx=17130, majf=0, minf=9
   IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
      issued rwts: total=0,17127,0,0 short=0,0,0,0 dropped=0,0,0,0
      latency   : target=0, window=0, percentile=100.00%, depth=1

Run status group 0 (all jobs):
   WRITE: bw=1142KiB/s (1169kB/s), 1142KiB/s-1142KiB/s (1169kB/s-1169kB/s), io=66.9MiB (70.2MB), run=60006-60006msec


avg-cpu:  %user   %nice %system %iowait  %steal   %idle
            0.00    0.00    0.10    0.00    0.00   99.90

Device   r/s     rMB/s  rrqm/s  %rrqm  r_await  rareq-sz  w/s     wMB/s  wrqm/s  %wrqm  w_await  wareq-sz  f/s     f_await  aqu-sz  %util
md127    0.00    0.00   0.00    0.00   0.00     0.00      307.13  1.20   0.00    0.00   3.24     4.00      0.00    0.00     1.00    100.00
nvme1n1  120.47  0.47   0.00    0.00   0.01     4.00      286.07  0.63   0.00    0.00   3.03     2.26      165.60  0.99     1.03    96.58
nvme2n1  123.87  0.48   0.00    0.00   0.01     4.00      289.47  0.65   0.00    0.00   3.00     2.28      165.60  1.00     1.04    96.63
nvme3n1  120.87  0.47   0.00    0.00   0.01     4.00      286.47  0.63   0.00    0.00   3.02     2.27      165.60  1.00     1.03    96.39
nvme4n1  125.00  0.49   0.00    0.00   0.02     4.00      290.60  0.65   0.00    0.00   3.00     2.29      165.60  1.02     1.04    96.54
nvme5n1  124.07  0.48   0.00    0.00   0.02     4.00      289.67  0.65   0.00    0.00   3.01     2.28      165.60  1.03     1.04    96.59


mdadm -X /dev/nvme1n1
         Filename : /dev/nvme1n1
            Magic : 6d746962
          Version : 4
             UUID : 17eadc76:a367542a:feb6e24e:d650576c
           Events : 3
   Events Cleared : 3
            State : OK
        Chunksize : 512 MB
           Daemon : 5s flush period
       Write Mode : Normal
        Sync Size : 1953382464 (1862.89 GiB 2000.26 GB)
           Bitmap : 3726 bits (chunks), 1977 dirty (53.1%)


bitmap internal 1024M
================================================================
for dev in /dev/nvme{1..5}n1; do nvme format --force $dev; done

mdadm --verbose --create --assume-clean --bitmap=internal --bitmap-chunk=1024M /dev/md/raid5 --name=raid5 --level=5 --chunk=64K --raid-devices=5 /dev/nvme{1..5}n1

for dev in /dev/nvme{1..5}n1; do blockdev --setra 256 $dev; done
blockdev --setra 1024 /dev/md/raid5

echo 8 > /sys/block/md127/md/group_thread_cnt
echo 8192 > /sys/block/md127/md/stripe_cache_size


fio --filename=/dev/md/raid5 --direct=1 --rw=randwrite --bs=4k --ioengine=libaio --iodepth=1 --runtime=60 --numjobs=1 --group_reporting --time_based --name=Raid5

fio-3.35
Starting 1 process
Jobs: 1 (f=1): [w(1)][100.0%][w=51.0MiB/s][w=13.1k IOPS][eta 00m:00s]
Raid5: (groupid=0, jobs=1): err= 0: pid=7120: Sun Jun 30 03:08:12 2024
   write: IOPS=10.3k, BW=40.4MiB/s (42.4MB/s)(2425MiB/60001msec); 0 zone resets
     slat (usec): min=6, max=18135, avg= 8.93, stdev=23.41
     clat (usec): min=3, max=10459, avg=86.97, stdev=342.95
      lat (usec): min=63, max=22927, avg=95.90, stdev=344.33
     clat percentiles (usec):
      |  1.00th=[   62],  5.00th=[   63], 10.00th=[   64], 20.00th=[   65],
      | 30.00th=[   65], 40.00th=[   66], 50.00th=[   67], 60.00th=[   67],
      | 70.00th=[   68], 80.00th=[   69], 90.00th=[   70], 95.00th=[   74],
      | 99.00th=[  133], 99.50th=[  155], 99.90th=[ 5997], 99.95th=[ 5997],
      | 99.99th=[ 6063]
    bw (  KiB/s): min=  616, max=52968, per=99.80%, avg=41305.95, stdev=20465.79, samples=119
    iops        : min=  154, max=13242, avg=10326.47, stdev=5116.44, samples=119
   lat (usec)   : 4=0.01%, 10=0.01%, 20=0.01%, 100=98.64%, 250=1.00%
   lat (usec)   : 500=0.01%, 750=0.01%, 1000=0.01%
   lat (msec)   : 2=0.01%, 4=0.01%, 10=0.33%, 20=0.01%
   cpu          : usr=1.89%, sys=12.74%, ctx=620837, majf=0, minf=170751
   IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
      issued rwts: total=0,620822,0,0 short=0,0,0,0 dropped=0,0,0,0
      latency   : target=0, window=0, percentile=100.00%, depth=1

Run status group 0 (all jobs):
   WRITE: bw=40.4MiB/s (42.4MB/s), 40.4MiB/s-40.4MiB/s (42.4MB/s-42.4MB/s), io=2425MiB (2543MB), run=60001-60001msec


avg-cpu:  %user   %nice %system %iowait  %steal   %idle
            0.04    0.00    1.27    0.00    0.00   98.70

Device   r/s      rMB/s  rrqm/s  %rrqm  r_await  rareq-sz  w/s       wMB/s  wrqm/s  %wrqm  w_await  wareq-sz  f/s   f_await  aqu-sz  %util
md127    0.00     0.00   0.00    0.00   0.00     0.00      18216.93  71.16  0.00    0.00   0.05     4.00      0.00  0.00     0.88    100.00
nvme1n1  7256.20  28.34  0.00    0.00   0.01     4.00      7256.27   28.34  0.00    0.00   0.01     4.00      0.00  0.00     0.19    99.71
nvme2n1  7302.53  28.53  0.00    0.00   0.01     4.00      7302.53   28.53  0.00    0.00   0.01     4.00      0.00  0.00     0.17    99.73
nvme3n1  7278.47  28.43  0.00    0.00   0.01     4.00      7278.53   28.43  0.00    0.00   0.01     4.00      0.00  0.00     0.18    99.57
nvme4n1  7303.93  28.53  0.00    0.00   0.01     4.00      7303.93   28.53  0.00    0.00   0.01     4.00      0.00  0.00     0.21    99.74
nvme5n1  7292.67  28.49  0.00    0.00   0.02     4.00      7292.60   28.49  0.00    0.00   0.02     4.00      0.00  0.00     0.22    99.69



mdadm -X /dev/nvme1n1
         Filename : /dev/nvme1n1
            Magic : 6d746962
          Version : 4
             UUID : a0c7ad14:50689e41:e065a166:4935a186
           Events : 3
   Events Cleared : 3
            State : OK
        Chunksize : 1 GB
           Daemon : 5s flush period
       Write Mode : Normal
        Sync Size : 1953382464 (1862.89 GiB 2000.26 GB)
           Bitmap : 1863 bits (chunks), 1863 dirty (100.0%)


bitmap internal 2G
================================================================
for dev in /dev/nvme{1..5}n1; do nvme format --force $dev; done

mdadm --verbose --create --assume-clean --bitmap=internal --bitmap-chunk=2G /dev/md/raid5 --name=raid5 --level=5 --chunk=64K --raid-devices=5 /dev/nvme{1..5}n1

for dev in /dev/nvme{1..5}n1; do blockdev --setra 256 $dev; done
blockdev --setra 1024 /dev/md/raid5

echo 8 > /sys/block/md127/md/group_thread_cnt
echo 8192 > /sys/block/md127/md/stripe_cache_size


fio --filename=/dev/md/raid5 --direct=1 --rw=randwrite --bs=4k --ioengine=libaio --iodepth=1 --runtime=60 --numjobs=1 --group_reporting --time_based --name=Raid5

Raid5: (g=0): rw=randwrite, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=libaio, iodepth=1
fio-3.35
Starting 1 process
Jobs: 1 (f=1): [w(1)][100.0%][w=74.7MiB/s][w=19.1k IOPS][eta 00m:00s]
Raid5: (groupid=0, jobs=1): err= 0: pid=7696: Sun Jun 30 03:30:40 2024
   write: IOPS=17.0k, BW=66.5MiB/s (69.8MB/s)(3993MiB/60001msec); 0 zone resets
     slat (usec): min=2, max=18094, avg= 4.79, stdev=17.94
     clat (usec): min=5, max=10352, avg=53.37, stdev=181.29
      lat (usec): min=41, max=22883, avg=58.16, stdev=182.72
     clat percentiles (usec):
      |  1.00th=[   43],  5.00th=[   44], 10.00th=[   45], 20.00th=[   46],
      | 30.00th=[   46], 40.00th=[   47], 50.00th=[   47], 60.00th=[   48],
      | 70.00th=[   48], 80.00th=[   49], 90.00th=[   50], 95.00th=[   52],
      | 99.00th=[   90], 99.50th=[  126], 99.90th=[  873], 99.95th=[ 5997],
      | 99.99th=[ 6063]
    bw (  KiB/s): min=  640, max=80168, per=99.91%, avg=68080.94, stdev=21547.29, samples=119
    iops        : min=  160, max=20042, avg=17020.24, stdev=5386.82, samples=119
   lat (usec)   : 10=0.01%, 50=92.06%, 100=7.10%, 250=0.73%, 500=0.01%
   lat (usec)   : 750=0.01%, 1000=0.01%
   lat (msec)   : 2=0.01%, 4=0.01%, 10=0.09%, 20=0.01%
   cpu          : usr=2.22%, sys=11.55%, ctx=1022167, majf=0, minf=14
   IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
      issued rwts: total=0,1022154,0,0 short=0,0,0,0 dropped=0,0,0,0
      latency   : target=0, window=0, percentile=100.00%, depth=1

Run status group 0 (all jobs):
   WRITE: bw=66.5MiB/s (69.8MB/s), 66.5MiB/s-66.5MiB/s (69.8MB/s-69.8MB/s), io=3993MiB (4187MB), run=60001-60001msec


avg-cpu:  %user   %nice %system %iowait  %steal   %idle
            0.04    0.00    1.15    0.00    0.00   98.81

Device   r/s      rMB/s  rrqm/s  %rrqm  r_await  rareq-sz  w/s       wMB/s  wrqm/s  %wrqm  w_await  wareq-sz  f/s   f_await  aqu-sz  %util
md127    0.00     0.00   0.00    0.00   0.00     0.00      18836.40  73.58  0.00    0.00   0.05     4.00      0.00  0.00     0.87    100.00
nvme1n1  7505.27  29.32  0.00    0.00   0.01     4.00      7505.40   29.32  0.00    0.00   0.01     4.00      0.00  0.00     0.19    99.93
nvme2n1  7510.00  29.34  0.00    0.00   0.01     4.00      7510.07   29.34  0.00    0.00   0.01     4.00      0.00  0.00     0.17    99.90
nvme3n1  7561.40  29.54  0.00    0.00   0.01     4.00      7561.47   29.54  0.00    0.00   0.01     4.00      0.00  0.00     0.19    100.00
nvme4n1  7543.07  29.47  0.00    0.00   0.01     4.00      7543.07   29.47  0.00    0.00   0.01     4.00      0.00  0.00     0.21    99.91
nvme5n1  7552.73  29.50  0.00    0.00   0.01     4.00      7552.80   29.50  0.00    0.00   0.01     4.00      0.00  0.00     0.22    99.91



mdadm -X /dev/nvme1n1
         Filename : /dev/nvme1n1
            Magic : 6d746962
          Version : 4
             UUID : 7d8ed7e8:4c2c4b17:723a22e5:4e9b5200
           Events : 3
   Events Cleared : 3
            State : OK
        Chunksize : 2 GB
           Daemon : 5s flush period
       Write Mode : Normal
        Sync Size : 1953382464 (1862.89 GiB 2000.26 GB)
           Bitmap : 932 bits (chunks), 932 dirty (100.0%)









bitmap external 64M
================================================================
for dev in /dev/nvme{1..5}n1; do nvme format --force $dev; done

mdadm --verbose --create --assume-clean --bitmap=/bitmap/bitmap.bin --bitmap-chunk=64M /dev/md/raid5 --name=raid5 --level=5 --chunk=64K --raid-devices=5 /dev/nvme{1..5}n1

for dev in /dev/nvme{1..5}n1; do blockdev --setra 256 $dev; done
blockdev --setra 1024 /dev/md/raid5

echo 8 > /sys/block/md127/md/group_thread_cnt
echo 8192 > /sys/block/md127/md/stripe_cache_size


fio --filename=/dev/md/raid5 --direct=1 --rw=randwrite --bs=4k --ioengine=libaio --iodepth=1 --runtime=60 --numjobs=1 --group_reporting --time_based --name=Raid5

Raid5: (g=0): rw=randwrite, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=libaio, iodepth=1
fio-3.35
Starting 1 process
Jobs: 1 (f=1): [w(1)][100.0%][w=67.3MiB/s][w=17.2k IOPS][eta 00m:00s]
Raid5: (groupid=0, jobs=1): err= 0: pid=7912: Sun Jun 30 03:39:11 2024
   write: IOPS=17.3k, BW=67.8MiB/s (71.1MB/s)(4066MiB/60001msec); 0 zone resets
     slat (usec): min=2, max=21987, avg= 6.11, stdev=22.04
     clat (usec): min=3, max=8410, avg=50.79, stdev=27.03
      lat (usec): min=42, max=22140, avg=56.90, stdev=35.13
     clat percentiles (usec):
      |  1.00th=[   41],  5.00th=[   42], 10.00th=[   44], 20.00th=[   46],
      | 30.00th=[   47], 40.00th=[   48], 50.00th=[   49], 60.00th=[   50],
      | 70.00th=[   51], 80.00th=[   52], 90.00th=[   56], 95.00th=[   68],
      | 99.00th=[   93], 99.50th=[  124], 99.90th=[  155], 99.95th=[  237],
      | 99.99th=[ 1037]
    bw (  KiB/s): min=38120, max=82576, per=100.00%, avg=69402.96, stdev=7769.33, samples=119
    iops        : min= 9530, max=20644, avg=17350.76, stdev=1942.33, samples=119
   lat (usec)   : 4=0.01%, 20=0.01%, 50=67.87%, 100=31.34%, 250=0.76%
   lat (usec)   : 500=0.01%, 750=0.01%, 1000=0.01%
   lat (msec)   : 2=0.01%, 4=0.01%, 10=0.01%
   cpu          : usr=2.23%, sys=14.27%, ctx=1040947, majf=0, minf=233929
   IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
      issued rwts: total=0,1040925,0,0 short=0,0,0,0 dropped=0,0,0,0
      latency   : target=0, window=0, percentile=100.00%, depth=1

Run status group 0 (all jobs):
   WRITE: bw=67.8MiB/s (71.1MB/s), 67.8MiB/s-67.8MiB/s (71.1MB/s-71.1MB/s), io=4066MiB (4264MB), run=60001-60001msec


avg-cpu:  %user   %nice %system %iowait  %steal   %idle
            0.04    0.00    1.15    0.00    0.00   98.81

Device   r/s      rMB/s  rrqm/s  %rrqm  r_await  rareq-sz  w/s       wMB/s  wrqm/s  %wrqm  w_await  wareq-sz  f/s   f_await  aqu-sz  %util
md127    0.00     0.00   0.00    0.00   0.00     0.00      18428.60  71.99  0.00    0.00   0.05     4.00      0.00  0.00     0.87    99.99
nvme1n1  7399.40  28.90  0.00    0.00   0.01     4.00      7399.47   28.90  0.00    0.00   0.01     4.00      0.00  0.00     0.17    99.73
nvme2n1  7361.20  28.75  0.00    0.00   0.01     4.00      7361.27   28.75  0.00    0.00   0.01     4.00      0.00  0.00     0.20    99.63
nvme3n1  7376.67  28.82  0.00    0.00   0.01     4.00      7376.73   28.82  0.00    0.00   0.01     4.00      0.00  0.00     0.21    99.63
nvme4n1  7367.27  28.78  0.00    0.00   0.01     4.00      7367.20   28.78  0.00    0.00   0.01     4.00      0.00  0.00     0.18    99.65
nvme5n1  7352.47  28.72  0.00    0.00   0.01     4.00      7352.67   28.72  0.00    0.00   0.01     4.00      0.00  0.00     0.20    99.73
nvme8n1  0.47     0.00   0.00    0.00   0.00     4.00      293.40    1.15   0.00    0.00   0.02     4.00      0.00  0.00     0.01    24.24



mdadm -X /bitmap/bitmap.bin
         Filename : /bitmap/bitmap.bin
            Magic : 6d746962
          Version : 4
             UUID : 1e3480e5:1f9d8b8a:53ebc6b7:279afb73
           Events : 3
   Events Cleared : 3
            State : OK
        Chunksize : 64 MB
           Daemon : 5s flush period
       Write Mode : Normal
        Sync Size : 1953382464 (1862.89 GiB 2000.26 GB)
           Bitmap : 29807 bits (chunks), 29665 dirty (99.5%)



bitmap external 1024M
================================================================
for dev in /dev/nvme{1..5}n1; do nvme format --force $dev; done

mdadm --verbose --create --assume-clean --bitmap=/bitmap/bitmap.bin --bitmap-chunk=1024M /dev/md/raid5 --name=raid5 --level=5 --chunk=64K --raid-devices=5 /dev/nvme{1..5}n1

for dev in /dev/nvme{1..5}n1; do blockdev --setra 256 $dev; done
blockdev --setra 1024 /dev/md/raid5

echo 8 > /sys/block/md127/md/group_thread_cnt
echo 8192 > /sys/block/md127/md/stripe_cache_size


fio --filename=/dev/md/raid5 --direct=1 --rw=randwrite --bs=4k --ioengine=libaio --iodepth=1 --runtime=60 --numjobs=1 --group_reporting --time_based --name=Raid5

Raid5: (g=0): rw=randwrite, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=libaio, iodepth=1
fio-3.35
Starting 1 process
Jobs: 1 (f=1): [w(1)][100.0%][w=70.6MiB/s][w=18.1k IOPS][eta 00m:00s]
Raid5: (groupid=0, jobs=1): err= 0: pid=8592: Sun Jun 30 03:54:11 2024
   write: IOPS=19.6k, BW=76.5MiB/s (80.2MB/s)(4590MiB/60001msec); 0 zone resets
     slat (usec): min=2, max=21819, avg= 4.12, stdev=20.16
     clat (usec): min=22, max=3706, avg=46.37, stdev=20.38
      lat (usec): min=40, max=21951, avg=50.49, stdev=28.81
     clat percentiles (usec):
      |  1.00th=[   40],  5.00th=[   41], 10.00th=[   42], 20.00th=[   42],
      | 30.00th=[   43], 40.00th=[   44], 50.00th=[   45], 60.00th=[   47],
      | 70.00th=[   48], 80.00th=[   49], 90.00th=[   50], 95.00th=[   52],
      | 99.00th=[   86], 99.50th=[  120], 99.90th=[  157], 99.95th=[  233],
      | 99.99th=[  906]
    bw (  KiB/s): min=61616, max=84728, per=100.00%, avg=78398.66, stdev=5410.81, samples=119
    iops        : min=15404, max=21182, avg=19599.66, stdev=1352.70, samples=119
   lat (usec)   : 50=90.10%, 100=9.16%, 250=0.72%, 500=0.01%, 750=0.01%
   lat (usec)   : 1000=0.01%
   lat (msec)   : 2=0.01%, 4=0.01%
   cpu          : usr=2.35%, sys=11.88%, ctx=1175104, majf=0, minf=11
   IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
      issued rwts: total=0,1175086,0,0 short=0,0,0,0 dropped=0,0,0,0
      latency   : target=0, window=0, percentile=100.00%, depth=1

Run status group 0 (all jobs):
   WRITE: bw=76.5MiB/s (80.2MB/s), 76.5MiB/s-76.5MiB/s (80.2MB/s-80.2MB/s), io=4590MiB (4813MB), run=60001-60001msec


avg-cpu:  %user   %nice %system %iowait  %steal   %idle
            0.04    0.00    1.03    0.00    0.00   98.93

Device   r/s      rMB/s  rrqm/s  %rrqm  r_await  rareq-sz  w/s       wMB/s  wrqm/s  %wrqm  w_await  wareq-sz  f/s   f_await  aqu-sz  %util
md127    0.00     0.00   0.00    0.00   0.00     0.00      20758.20  81.09  0.00    0.00   0.04     4.00      0.00  0.00     0.89    100.00
nvme1n1  8291.67  32.39  0.00    0.00   0.01     4.00      8291.73   32.39  0.00    0.00   0.01     4.00      0.00  0.00     0.22    99.87
nvme2n1  8270.93  32.31  0.00    0.00   0.01     4.00      8271.07   32.31  0.00    0.00   0.01     4.00      0.00  0.00     0.19    99.79
nvme3n1  8310.67  32.46  0.00    0.00   0.01     4.00      8310.80   32.46  0.00    0.00   0.01     4.00      0.00  0.00     0.20    99.83
nvme4n1  8300.67  32.42  0.00    0.00   0.01     4.00      8300.67   32.42  0.00    0.00   0.01     4.00      0.00  0.00     0.23    99.76
nvme5n1  8342.13  32.59  0.00    0.00   0.02     4.00      8342.13   32.59  0.00    0.00   0.01     4.00      0.00  0.00     0.25    99.85
nvme8n1  0.33     0.00   0.00    0.00   8.40     4.00      0.00      0.00   0.00    0.00   0.00     0.00      0.00  0.00     0.00    0.33


mdadm -X /bitmap/bitmap.bin
         Filename : /bitmap/bitmap.bin
            Magic : 6d746962
          Version : 4
             UUID : 30e6211d:31ac1204:e6cdadb3:9691d3ee
           Events : 3
   Events Cleared : 3
            State : OK
        Chunksize : 1 GB
           Daemon : 5s flush period
       Write Mode : Normal
        Sync Size : 1953382464 (1862.89 GiB 2000.26 GB)
           Bitmap : 1863 bits (chunks), 1863 dirty (100.0%)



bitmap none
================================================================
for dev in /dev/nvme{1..5}n1; do nvme format --force $dev; done

mdadm --verbose --create --assume-clean --bitmap=none /dev/md/raid5 --name=raid5 --level=5 --chunk=64K --raid-devices=5 /dev/nvme{1..5}n1

for dev in /dev/nvme{1..5}n1; do blockdev --setra 256 $dev; done
blockdev --setra 1024 /dev/md/raid5

echo 8 > /sys/block/md127/md/group_thread_cnt
echo 8192 > /sys/block/md127/md/stripe_cache_size


fio --filename=/dev/md/raid5 --direct=1 --rw=randwrite --bs=4k --ioengine=libaio --iodepth=1 --runtime=60 --numjobs=1 --group_reporting --time_based --name=Raid5

Raid5: (g=0): rw=randwrite, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=libaio, iodepth=1
fio-3.35
Starting 1 process
Jobs: 1 (f=1): [w(1)][100.0%][w=82.5MiB/s][w=21.1k IOPS][eta 00m:00s]
Raid5: (groupid=0, jobs=1): err= 0: pid=9158: Sun Jun 30 04:11:01 2024
   write: IOPS=20.6k, BW=80.6MiB/s (84.5MB/s)(4833MiB/60001msec); 0 zone resets
     slat (usec): min=2, max=13598, avg= 3.50, stdev=12.46
     clat (usec): min=4, max=3694, avg=44.31, stdev=21.60
      lat (usec): min=39, max=13681, avg=47.81, stdev=24.98
     clat percentiles (usec):
      |  1.00th=[   39],  5.00th=[   40], 10.00th=[   41], 20.00th=[   41],
      | 30.00th=[   42], 40.00th=[   43], 50.00th=[   43], 60.00th=[   44],
      | 70.00th=[   45], 80.00th=[   46], 90.00th=[   48], 95.00th=[   50],
      | 99.00th=[   87], 99.50th=[  117], 99.90th=[  157], 99.95th=[  229],
      | 99.99th=[  963]
    bw (  KiB/s): min=74112, max=86712, per=100.00%, avg=82486.43, stdev=3696.94, samples=119
    iops        : min=18528, max=21678, avg=20621.59, stdev=924.23, samples=119
   lat (usec)   : 10=0.01%, 50=95.91%, 100=3.33%, 250=0.74%, 500=0.01%
   lat (usec)   : 750=0.01%, 1000=0.01%
   lat (msec)   : 2=0.01%, 4=0.01%
   cpu          : usr=2.30%, sys=10.74%, ctx=1237375, majf=0, minf=179597
   IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
      issued rwts: total=0,1237359,0,0 short=0,0,0,0 dropped=0,0,0,0
      latency   : target=0, window=0, percentile=100.00%, depth=1

Run status group 0 (all jobs):
   WRITE: bw=80.6MiB/s (84.5MB/s), 80.6MiB/s-80.6MiB/s (84.5MB/s-84.5MB/s), io=4833MiB (5068MB), run=60001-60001msec




avg-cpu:  %user   %nice %system %iowait  %steal   %idle
            0.04    0.00    1.06    0.00    0.00   98.91

Device   r/s      rMB/s  rrqm/s  %rrqm  r_await  rareq-sz  w/s       wMB/s  wrqm/s  %wrqm  w_await  wareq-sz  f/s   f_await  aqu-sz  %util
md127    0.00     0.00   0.00    0.00   0.00     0.00      20040.87  78.28  0.00    0.00   0.04     4.00      0.00  0.00     0.89    99.99
nvme1n1  8016.80  31.32  0.00    0.00   0.01     4.00      8016.93   31.32  0.00    0.00   0.01     4.00      0.00  0.00     0.21    99.68
nvme2n1  7983.20  31.18  0.00    0.00   0.01     4.00      7983.20   31.18  0.00    0.00   0.01     4.00      0.00  0.00     0.18    99.74
nvme3n1  8030.07  31.37  0.00    0.00   0.01     4.00      8030.20   31.37  0.00    0.00   0.01     4.00      0.00  0.00     0.20    99.62
nvme4n1  8016.40  31.31  0.00    0.00   0.01     4.00      8016.40   31.31  0.00    0.00   0.01     4.00      0.00  0.00     0.23    99.73
nvme5n1  8034.87  31.39  0.00    0.00   0.02     4.00      8035.00   31.39  0.00    0.00   0.01     4.00      0.00  0.00     0.24    99.71




single disk 1K RW
================================================================
fio --filename=/dev/nvme8n1 --direct=1 --rw=randwrite --bs=1k --ioengine=libaio --iodepth=1 --runtime=60 --numjobs=1 --group_reporting --time_based --name=Single
Single: (g=0): rw=randwrite, bs=(R) 1024B-1024B, (W) 1024B-1024B, (T) 1024B-1024B, ioengine=libaio, iodepth=1
fio-3.35
Starting 1 process
Jobs: 1 (f=1): [w(1)][100.0%][w=54.3MiB/s][w=55.6k IOPS][eta 00m:00s]
Single: (groupid=0, jobs=1): err= 0: pid=4471: Sun Jun 30 18:31:56 2024
   write: IOPS=55.4k, BW=54.1MiB/s (56.7MB/s)(3244MiB/60001msec); 0 zone resets
     slat (usec): min=2, max=2792, avg= 2.71, stdev= 2.12
     clat (nsec): min=651, max=8350.9k, avg=14864.41, stdev=5360.57
      lat (usec): min=15, max=8403, avg=17.57, stdev= 5.79
     clat percentiles (usec):
      |  1.00th=[   15],  5.00th=[   15], 10.00th=[   15], 20.00th=[   15],
      | 30.00th=[   15], 40.00th=[   15], 50.00th=[   15], 60.00th=[   15],
      | 70.00th=[   15], 80.00th=[   16], 90.00th=[   16], 95.00th=[   16],
      | 99.00th=[   18], 99.50th=[   22], 99.90th=[   32], 99.95th=[   33],
      | 99.99th=[  206]
    bw (  KiB/s): min=51884, max=56778, per=100.00%, avg=55394.37, stdev=561.60, samples=119
    iops        : min=51884, max=56778, avg=55394.44, stdev=561.62, samples=119
   lat (nsec)   : 750=0.01%, 1000=0.01%
   lat (usec)   : 2=0.01%, 4=0.01%, 10=0.01%, 20=99.43%, 50=0.54%
   lat (usec)   : 100=0.01%, 250=0.02%, 500=0.01%
   lat (msec)   : 10=0.01%
   cpu          : usr=3.57%, sys=16.41%, ctx=3321571, majf=0, minf=180742
   IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
      issued rwts: total=0,3321653,0,0 short=0,0,0,0 dropped=0,0,0,0
      latency   : target=0, window=0, percentile=100.00%, depth=1

Run status group 0 (all jobs):
   WRITE: bw=54.1MiB/s (56.7MB/s), 54.1MiB/s-54.1MiB/s (56.7MB/s-56.7MB/s), io=3244MiB (3401MB), run=60001-60001msec

Disk stats (read/write):
   nvme8n1: ios=0/3309968, merge=0/0, ticks=0/44637, in_queue=44638, util=99.71%


avg-cpu:  %user   %nice %system %iowait  %steal   %idle
            0.04    0.00    0.42    0.00    0.00   99.54

Device   r/s   rMB/s  rrqm/s  %rrqm  r_await  rareq-sz  w/s       wMB/s  wrqm/s  %wrqm  w_await  wareq-sz  f/s   f_await  aqu-sz  %util
nvme8n1  0.00  0.00   0.00    0.00   0.00     0.00      55496.93  54.20  0.00    0.00   0.01     1.00      0.00  0.00     0.75    100.00





single disk 4K RW
================================================================
blockdev --setra 256 /dev/nvme8n1

fio --filename=/dev/nvme8n1 --direct=1 --rw=randwrite --bs=4k --ioengine=libaio --iodepth=1 --runtime=60 --numjobs=1 --group_reporting --time_based --name=Single

Single: (g=0): rw=randwrite, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=libaio, iodepth=1
fio-3.35
Starting 1 process
Jobs: 1 (f=1): [w(1)][100.0%][w=270MiB/s][w=69.0k IOPS][eta 00m:00s]
Single: (groupid=0, jobs=1): err= 0: pid=4396: Sun Jun 30 18:21:52 2024
   write: IOPS=68.8k, BW=269MiB/s (282MB/s)(15.8GiB/60001msec); 0 zone resets
     slat (usec): min=2, max=796, avg= 2.45, stdev= 1.59
     clat (nsec): min=652, max=8343.1k, avg=11616.73, stdev=5088.99
      lat (usec): min=11, max=8410, avg=14.06, stdev= 5.36
     clat percentiles (usec):
      |  1.00th=[   12],  5.00th=[   12], 10.00th=[   12], 20.00th=[   12],
      | 30.00th=[   12], 40.00th=[   12], 50.00th=[   12], 60.00th=[   12],
      | 70.00th=[   12], 80.00th=[   12], 90.00th=[   12], 95.00th=[   12],
      | 99.00th=[   14], 99.50th=[   17], 99.90th=[   28], 99.95th=[   34],
      | 99.99th=[  204]
    bw (  KiB/s): min=264072, max=277568, per=100.00%, avg=275629.71, stdev=1902.45, samples=119
    iops        : min=66018, max=69392, avg=68907.43, stdev=475.55, samples=119
   lat (nsec)   : 750=0.01%, 1000=0.01%
   lat (usec)   : 2=0.01%, 4=0.01%, 10=0.04%, 20=99.55%, 50=0.38%
   lat (usec)   : 100=0.01%, 250=0.02%, 1000=0.01%
   lat (msec)   : 10=0.01%
   cpu          : usr=5.20%, sys=21.28%, ctx=4129887, majf=0, minf=45204
   IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
      issued rwts: total=0,4130258,0,0 short=0,0,0,0 dropped=0,0,0,0
      latency   : target=0, window=0, percentile=100.00%, depth=1

Run status group 0 (all jobs):
   WRITE: bw=269MiB/s (282MB/s), 269MiB/s-269MiB/s (282MB/s-282MB/s), io=15.8GiB (16.9GB), run=60001-60001msec

Disk stats (read/write):
   nvme8n1: ios=0/4119593, merge=0/0, ticks=0/40922, in_queue=40923, util=99.89%


avg-cpu:  %user   %nice %system %iowait  %steal   %idle
            0.08    0.00    0.57    0.00    0.00   99.35

Device   r/s   rMB/s  rrqm/s  %rrqm  r_await  rareq-sz  w/s       wMB/s   wrqm/s  %wrqm  w_await  wareq-sz  f/s   f_await  aqu-sz  %util
nvme8n1  0.00  0.00   0.00    0.00   0.00     0.00      69041.33  269.69  0.00    0.00   0.01     4.00      0.00  0.00     0.68    100.00

