From: Neil Brown <neilb@suse.de>
Subject: Re: grow raid 6: different errors with mdadm 3.0.3 and 3.1
Date: Thu, 26 Nov 2009 14:22:27 +1100
Message-ID: <20091126142227.496da980@notabene.brown>
References: <1259086899.4139.4@athlon>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1259086899.4139.4@athlon>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Burgess <aab@cichlid.com>
Cc: linux raid mailing list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, 24 Nov 2009 10:21:39 -0800
Andrew Burgess <aab@cichlid.com> wrote:

> 
> mdadm 3.0.3:
> 
> # mdadm -v /dev/md1 --grow --raid-devices=15
> mdadm: Need to backup 19968K of critical section..
> mdadm: /dev/md1: failed to save critical region
> 
> mdadm 3.1:
> 
> sudo ./mdadm -G /dev/md1 --raid-devices=15
> mdadm: this change will reduce the size of the array.
>         use --grow --array-size first to truncate array.
>         e.g. mdadm --grow /dev/md1 --array-size 928142080
> 
> Hmmm. Can I just echo something into /proc to make this happen?
> (assuming these are both mdadm bugs)
> 
> Or should I try another mdadm? I googled and a problem like #1
> occured to someone using 3.0 and they worked around by using
> 2.6.7. But I'm starting to get nervous that mdadm may really be
> trying to stop me from doing something dumb...

Thanks for the report.
There appears to be a big in mdadm-3.1.1 such that the new 
array size gets truncated to 32bits in this calculation so
it looks like it is getting smaller.

The following patch will fix it, and can also be collected
from my git tree (git://neil.brown.name/md).

Thanks,
NeilBrown

From 2ed4f75388f99968be58097941a9704f6e42d701 Mon Sep 17 00:00:00 2001
From: NeilBrown <neilb@suse.de>
Date: Thu, 26 Nov 2009 14:19:26 +1100
Subject: [PATCH] Grow: avoid truncation error when checking size of array.

array.size is only 32bit so it is not safe to multiply it
up before casting to (long long).
Actually, we shouldn't be using array.size here at all, but that
will get fixed in a subsequent patch.

Reported-by: Andrew Burgess <aab@cichlid.com>
Signed-off-by: NeilBrown <neilb@suse.de>
---
 Grow.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Grow.c b/Grow.c
index 7764bdb..a654d4e 100644
--- a/Grow.c
+++ b/Grow.c
@@ -891,7 +891,7 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
 		}
 
 		/* Check that we can hold all the data */
-		size = ndata * array.size;
+		size = ndata * (long long)array.size;
 		get_dev_size(fd, NULL, &array_size);
 		if (size < (array_size/1024)) {
 			fprintf(stderr, Name ": this change will reduce the size of the array.\n"
-- 
1.6.4.3

