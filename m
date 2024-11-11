Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B774C155CBF
	for <linux-raid@vger.kernel.org>; Mon, 11 Nov 2024 14:07:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731334055; cv=none; b=Eyx9UpFTpU5Qc/9RJzqiOkHfJ4K5ZIVdv+RUDHrMmVgny1qxHx7mMaKE3eD6QjGLRjwN7VGCsaKsbdG7xgftV2ucRzCS30TAfE0gJG/qsWGISvf17AwStQpzpKf+Mf1HOfzWAhetDwTTchjcr1suQ5AkPjGCMadV1q8V9wZlvdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731334055; c=relaxed/simple;
	bh=8N/EiYO7U1w4bHsY7vrtFKqGxRdhImOoX8c3yz13mZE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Dpe66iheuPUpqoMx1H/4W/YC4UCZdf7bZ/8l2rSFbTzWf+NBNtonAZkkrbqxsnL19by3dUprL4AU19jreah9nrnMrmSsEQrpYJa64SxneXopRujSKe91srUzZDOkkOHzRyLHjGZ2H3PmrtFvBcAYMioYIEOLm7aUhbrtBzq8HUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pkm-inc.com; spf=pass smtp.mailfrom=pkm-inc.com; dkim=pass (2048-bit key) header.d=pkm-inc.com header.i=@pkm-inc.com header.b=ZvlBvLO2; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pkm-inc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pkm-inc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pkm-inc.com header.i=@pkm-inc.com header.b="ZvlBvLO2"
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-a9ed0ec0e92so643595466b.0
        for <linux-raid@vger.kernel.org>; Mon, 11 Nov 2024 06:07:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pkm-inc.com; s=google; t=1731334052; x=1731938852; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=g+QWLvG2z5WXsgEfI54D37IFEeImx5Ik/sQqO3L75L4=;
        b=ZvlBvLO2K6pyEGljEoPGaDjrkwwVvqhnl8bUzGQtzEty2H9vyC2KyBvnxGcgG9/bdC
         XRAEBcBGaA0jke+zKvheLWdCHH3yri1tTEkx8AUDKZAutGZFC65B53mlzR++p/QAWvD/
         VabnXGC3xAPp3HZNSLPHhbY1SdhNXr+jrZ39PIHe3IhH3b9WAD+8yklEHglqwKAYFDcY
         EjEhp5nwfV0/OUYZEnS4epyFbY59c0c172AOGlDmPIXptrlwgH3QdeD21K0ehaHXozDV
         hHH0QEb/Z9EKaiTqteG/Go+iPYRTn8H8bhQ0GI0WwBBfxmrQYivgdZLvj3XWX9NuFdva
         LcSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731334052; x=1731938852;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=g+QWLvG2z5WXsgEfI54D37IFEeImx5Ik/sQqO3L75L4=;
        b=RjnEuGTqSxV46Sjld6f4YIEqBOcFKv2QNxT5WKtqBf2YrjZYpfILvbZ98qET/MP3x5
         wpkRqKY+A9ulq0Pfbx15PQNGOT0+3wjR7o43eg4NRGn6gaB2WW26uy6b99LLT0GC47/U
         +493Ewv0xIkmZZR/1wCosSd+m2PV2gNzb6HfDyXrhvLSiXXG6CrH7kbdpSSn+/e8f0Aa
         hL9goQwuheWVFwPE+ViQ5QdaSqJ94kA22xlweP0ULntAhPurONXKxkutXVS6JhPDRLAB
         d9vBU2Enqr2SGIX275vbj3l+gNruRavS3tH8o4L/Ui+yiR0OceGWx42ep15EuVgnaLp2
         OBdg==
X-Forwarded-Encrypted: i=1; AJvYcCXMNMb9qKSPWfDMwSnrc6R9Tq5pV1wid55GmpCUv9eJmJsa0nKltAnqcZIcd7Ts8Ar/Qqp13JBv8LiV@vger.kernel.org
X-Gm-Message-State: AOJu0Yx442zPu5RcexK3CqLkM5yLQeR3tJ/A3DcZnjPwgnX0sdbUnwM9
	eDU4TKrknhhtP4y0jJ9dY3sqS/OcE+C9t5Rv1NDJNXv+6xPagUayqVDkt1ZzOiw=
X-Google-Smtp-Source: AGHT+IEgIu4wy/L+YW1wn1EntLjvI1V0cQWVc/wfvJ5hEht6LFCa7tkvuFdXF3cCCMhSmOO8iNryIA==
X-Received: by 2002:a17:906:dc89:b0:a9e:d539:86c4 with SMTP id a640c23a62f3a-a9eefeb2bb7mr1066619666b.9.1731334051681;
        Mon, 11 Nov 2024 06:07:31 -0800 (PST)
Received: from [10.8.0.8] (178-221-200-39.dynamic.isp.telekom.rs. [178.221.200.39])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9ee0dc56f1sm595040366b.92.2024.11.11.06.07.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Nov 2024 06:07:31 -0800 (PST)
Message-ID: <e32688e7-310e-49fc-9f52-44dd183f9666@pkm-inc.com>
Date: Mon, 11 Nov 2024 15:07:30 +0100
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
 <cf00703f-f4bd-4b6a-9626-72d839ebaf7b@pkm-inc.com>
 <e9fd5484-619b-e8a9-984c-359bf5475b9f@huaweicloud.com>
Content-Language: en-GB
From: =?UTF-8?Q?Dragan_Milivojevi=C4=87?= <galileo@pkm-inc.com>
In-Reply-To: <e9fd5484-619b-e8a9-984c-359bf5475b9f@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 11/11/2024 14:02, Yu Kuai wrote:

> TBO, I don't know what is this. :(

It's just a website where you can post text content, notes basically. I use it
with mailing list where messages get rejected if I attach a file.
I prefer not to include long debug logs, test logs etc in the body as it will just
get quoted endless amount of times and pollute the thread. Old habit from the days
when blackquoting was a thing and kilobytes mattered.


> Yes, this is a known problem, the gap here is that I don't think
> external bitmap is much helpful, while your result disagree.
> 
>> bitmap internal 64M
>> ================================================================
>> mdadm --verbose --create --assume-clean --bitmap=internal --bitmap-chunk=64M /dev/md/raid5 --name=raid5 --level=5 --chunk=64K --raid-devices=5 /dev/nvme{1..5}n1
>>
>> for dev in /dev/nvme{1..5}n1; do blockdev --setra 256 $dev; done
>> blockdev --setra 1024 /dev/md/raid5
>>
>> echo 8 > /sys/block/md127/md/group_thread_cnt
>> echo 8192 > /sys/block/md127/md/stripe_cache_size
>>

  
> The array set up is fine. And the following external bitmap is using
> /bitmap/bitmap.bin, does the back-end storage of this file the same as
> test device?


No, I used one of the extra devices.




>> fio --filename=/dev/md/raid5 --direct=1 --rw=randwrite --bs=4k --ioengine=libaio --iodepth=1 --runtime=60 --numjobs=1 --group_reporting --time_based --name=Raid5
> 
> Then this is what I suspected, the above test is quite limited and can't
> replace the real world workload, 1 thread 1 iodepth with 4k randwrite.



That is true. I went down this rabbit hole because I was getting worse results
with a RAID5 array than with a single disk using real world workload, PostgreSQL in my case.
I chose these test parameters as a worst case scenario.

I did test with other parameters, did a whole battery of test with iodepth of 1 and 8 and
BS sizes 4K,8,16 all the way to 2048K. It shows similar behaviour.
For example:

5 disk RAID5, 64K chunk, default internal bitmap, iodepth 8

randread
BS     BW     IOPS    LAT      LAT_DEV  SS  SS_perc  USR_CPU  SYS_CPU
4K     574    146993  53.58    21.63    0   7.50%    13.25    59.30
8K     1127   144268  54.75    19.48    0   4.39%    11.25    61.50
16K    2084   133387  59.32    16.53    0   2.87%    10.52    63.03
32K    3942   126151  62.67    21.59    1   1.30%    13.03    60.14
64K    7225   115606  68.64    19.31    1   1.03%    9.58     65.30
128K   7947   63580   124.73   22.66    1   1.91%    8.94     63.48
256K   9216   36867   216.49   26.47    1   0.51%    2.65     69.43
512K   8065   16130   494.82   42.43    1   1.25%    2.41     72.56
1024K  8130   8130    983.01   64.22    1   0.97%    0.92     73.38
2048K  10685  5342    1496.28  132.24   0   2.50%    0.75     68.89


randwrite
BS     BW    IOPS  LAT       LAT_DEV  SS  SS_perc  USR_CPU  SYS_CPU
4K     1     375   21318.71  5059.72  0   41.06%   0.10     0.38
8K     2     354   22548.71  3084.57  0   4.90%    0.11     0.35
16K    5     346   23107.64  2517.95  0   9.77%    0.11     0.49
32K    13    420   19001.29  5500.62  0   34.75%   0.22     1.30
64K    33    530   15064.25  3916.28  0   8.07%    0.29     2.92
128K   79    637   12549.72  3249.85  0   3.99%    0.72     4.60
256K   184   739   10812.12  2576.32  0   34.02%   3.81     4.32
512K   307   615   12995.86  2891.70  0   2.99%    2.31     4.31
1024K  611   611   13071.85  3287.53  0   6.96%    3.60     8.42
2048K  1051  525   15209.81  3562.27  0   35.79%   8.67     20.12


Bitmap  none, array with the same settings (previous array was shut down, drives were "cleansed" with nvme format)


randread
BS     BW     IOPS    LAT_µs   LAT_DEV  SS  SS_perc  USR_CPU  SYS_CPU
4K     571    146399  53.80    25.07    0   5.17%    13.54    58.45
8K     1147   146866  53.87    17.48    0   3.10%    11.20    59.26
16K    1970   126136  62.70    20.11    0   2.64%    11.06    58.88
32K    3519   112637  70.36    23.60    1   1.98%    11.05    54.55
64K    6502   104037  76.27    21.71    1   1.52%    9.60     60.40
128K   7886   63093   126.05   21.88    1   1.19%    6.84     65.40
256K   9446   37787   211.05   27.00    1   0.77%    3.60     69.37
512K   8397   16794   475.58   42.16    1   1.45%    1.85     71.99
1024K  8510   8510    939.13   55.02    1   1.01%    1.00     72.60
2048K  11035  5517    1448.77  84.14    1   1.99%    0.74     73.49


randwrite
BS     BW    IOPS   LAT_µs   LAT_DEV  SS  SS_perc  USR_CPU  SYS_CPU
4K     195   50151  158.96   48.56    1   1.13%    5.74     34.68
8K     264   33897  235.39   77.11    1   1.32%    4.60     34.46
16K    343   22003  362.88   111.80   1   1.70%    5.34     37.17
32K    645   20642  386.83   145.86   0   33.84%   6.48     45.15
64K    917   14680  543.97   170.23   0   3.01%    6.05     53.27
128K   1416  11332  704.94   202.18   0   4.66%    9.69     57.63
256K   1394  5576   1433.60  375.88   1   1.52%    8.53     24.93
512K   1726  3452   2316.19  500.19   1   1.18%    12.38    30.54
1024K  2598  2598   3077.47  629.37   0   2.53%    18.74    47.02
2048K  2457  1228   6508.20  1825.67  0   3.32%    28.70    61.01



Reads are fine but writes are many times slower ...


> 
> I still can't believe your test result, and I can't figure out why
> internal bitmap is so slow. Hence I use ramdisk(10GB) to create a raid5,
> and use the same fio script to test, the result is quite different from
> yours:
> 
> ram0:            981MiB/s
> non-bitmap:        132MiB/s
> internal-bitmap:    95.5MiB/s
>>

I don't know, I can provide full fio test logs including fio "tracing" for these iodepth 8
tests if that would make any difference.



> There is absolutely something wrong here, it doesn't make sense to me
> that internal bitmap is so slow. However, I have no idea until you can
> provide the perf result.

I may be able to find time to do that over the weekend, but don’t hold me to it.
The test setup will not be the same, server is in production ...
I did leave some "spare" partitions on all drives to investigate this issue further
but did not find the time.

Please send me an example of how would you like me to run the perf tool, I haven't used
it much.

Thanks
Dragan
  



