From: Linux Raid Study <linuxraid.study@gmail.com>
Subject: How to change stripe cache size
Date: Thu, 17 Sep 2009 00:59:49 -0700
Message-ID: <f5d1f90a0909170059g15c88dbfp73ea5f7f5933b527@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

The max stripe_cache_size on my system is 8k. Per mdadm, my chunk size
is default 64k.

Ques:
1. How can I increase stripe_cache size to > 8k? echo 32768>
/sys..../stripe_cache_size doesn't work
2. I would like to export this /dev/md0 device to iSCSI initiators
(running on different PCs) and measure performance. So,
ques is what would be an optimal block size for iSCSI reads if chunk
size is 64k and stripe cache size is 8k.

Thanks for your help...
