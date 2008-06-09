From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Subject: raid10: no raid0 support?
Date: Mon, 09 Jun 2008 16:48:18 -0400
Message-ID: <484D9712.7090804@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Is there some reason why the MD RAID10 module does /not/ support a
"RAID0-like" configuration (-p n1)? The comments in drivers/md/raid10.c
seem to suggest it should:  "* If [near_copies and far_copies] are 1, we
get raid0." Yet the code specifically checks for ((near_copies *
far_copies) > 1).

Just curious, as it seems interesting that one could support RAID0,
RAID1 /and/ RAID10 all w/ one RAID module.

Thanks,
Alan D. Brunelle
HP / OSLO / S&P
