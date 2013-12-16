From: "lilofile" <lilofile@aliyun.com>
Subject: =?UTF-8?B?dHdvIHJhaWQ1IHBlcmZvcm1hbmNl?=
Date: Mon, 16 Dec 2013 09:07:50 +0800
Message-ID: <386c52f5-dd36-4697-b76a-d24038bbded3@aliyun.com>
Reply-To: "lilofile" <lilofile@aliyun.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

when I Create a raid5,dd  1M block size,the performance can reached to 1GB/s
when I create another raid5,dd 1M block size ,the performance can reached to 1GB/s
when I simultaneously dd the two different raid,the total performance only reached to 1.4GB/s,why can not reached to 2GB/s.

the memory is 32GB,CPU is x5660,the stripe size is 4096
