From: Jake Yao <jgyao1@gmail.com>
Subject: performance of raid5 on fast devices
Date: Mon, 16 Jan 2017 21:35:21 -0500
Message-ID: <CA+Dh761_kVPEcRdFEAo72Wif_t-G7RpgyoKGetEFveyMpaYD1w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have a raid5 array on 4 NVMe drives, and the performance on the
array is only marginally better than a single drive. Unlike a similar
raid5 array on 4 SAS SSD or HDD,  the performance on array is 3x
better than a single drive, which is expected.

It looks like when the single kernel thread associated with the raid
device running at 100%, the array performance hit its peak. This can
happen easily for fast devices like NVMe.

This can reproduced by creating a raid5 with 4 ramdisks as well, and
comparing performance on the array and one ramdisk. Sometimes the
performance on the array is worse than a single ramdisk.

The kernel version is 4.9.0-rc3 and mdadm is release 3.4, no write
journal is configured.

Is this a known issue?

Please cc me on the email as I am not on the mail list.

Thanks!
