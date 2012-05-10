From: Rajasekhar Pulluru <pullururajasekhar@gmail.com>
Subject: Unable to set chunk size
Date: Thu, 10 May 2012 19:53:58 +0530
Message-ID: <CAGA5_H5c4+9s9OSyQaAxbekfTBDqAsR=y2GJRtO0AdChJTrZNQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi All,

I am unable to set chunk size for a raid5 device.
# cat /sys/block/md0/md/chunk_size
1048576
# echo 4194304 > /sys/block/md0/md/chunk_size
# cat /sys/block/md0/md/chunk_size
1048576

What could be the problem?

Thanks & Regards,
Rajasekhar
