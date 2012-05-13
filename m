From: Alexander Lyakas <alex.bolshoy@gmail.com>
Subject: mdadm: [PATCH] Don't consider disks with a valid recovery offset as
 candidates for bumping up event count
Date: Sun, 13 May 2012 13:10:43 +0300
Message-ID: <CAGRgLy5tEups--dzoV6+bq+CzZzwYMy7tv0FFJqah-Q5ZJc6kA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Neil,
do you think the below patch sounds reasonable?

Thanks,
Alex.


From 98adc21bba9cf5d77214d665f2218fd7de2623b9 Mon Sep 17 00:00:00 2001
From: Alex Lyakas <alex@zadarastorage.com>
Date: Sun, 13 May 2012 13:04:24 +0300
Subject: [PATCH] Don't consider disks with a valid recovery offset as
 candidates for bumping up event count.

When we are looking for a candidate disk to bump up the event count,
we consider only disks that have recovery_start==MaxSector.
However, after we find one such disk, we agree to accept more disks
having same event count, regardless of their recovery_start.
Be consistent and don't accept disks with a valid recovery_start at all.

diff --git a/Assemble.c b/Assemble.c
index 080993d..227d66f 100644
--- a/Assemble.c
+++ b/Assemble.c
@@ -1069,6 +1069,7 @@ int Assemble(struct supertype *st, char *mddev,
                        int j = best[i];
                        if (j >= 0 &&
                            !devices[j].uptodate &&
+                           devices[j].i.recovery_start == MaxSector &&
                            devices[j].i.events == current_events) {
                                chosen_drive = j;
                                goto add_another;
