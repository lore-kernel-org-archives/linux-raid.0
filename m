From: Roberto Spadim <roberto@spadim.com.br>
Subject: Best configuration for bcache/md cache or other cache using ssd
Date: Tue, 17 Sep 2013 16:20:43 -0300
Message-ID: <CAH3kUhHrK-TKJD1s_7SvtOz=YnpO82EvMGPv0X8rVAaDcuTO0Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi guys, i have one doubt...
i will buy one server and my client want a configuration with SSD + HDD
i don't know yet what SSD will be used if anyone have a suggestion
it's wellcome...

HDD will be a SATA 7200rpm with 2TB, SSD will be ~ 160GB or less (must
be cheap and enterprise level)

he wants a RAID1 level over HDD and a cache (bcache/or md cache layer
of kernel 3.9) over this md device (raid1)

i'm thinking something like...
raid1 over ssd + raid1 over hdd
use ssd raid as a cache to hdd raid, is this ok?

well that's my problem:
1) suggestion about ssd device (size don't need to be 160GB maybe a
better device with bigger space exists and i don't know...)
2) what configuration should i do to create the md device
3) i will make this (cache) only for HOME partition, others partitions
will only have md raid1 of hdd drives

thanks guys

-- 
Roberto Spadim
