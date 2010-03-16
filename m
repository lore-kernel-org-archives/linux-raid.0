From: Justin Maggard <jmaggard10@gmail.com>
Subject: Sysfs update frequency
Date: Tue, 16 Mar 2010 14:32:55 -0700
Message-ID: <150c16851003161432gf38c0f5o1cc957435efd4c3e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I've noticed on recent kernels that /sys/block/md?/md/sync_completed
seems to rarely get updated.  What is the expected update interval?
For me, it seems to only update about once every 6% or so during the
resync.  Of course, /proc/mdstat has the actual current progress.

Thanks,
-Justin
