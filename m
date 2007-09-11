From: Iustin Pop <iusty@k1024.org>
Subject: [PATCH] Explain the read-balancing algorithm for RAID1 better in
	md.4
Date: Tue, 11 Sep 2007 05:51:57 +0200
Message-ID: <20070911035157.GB20596@teal.hq.k1024.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

There are many questions on the mailing list about the RAID1 read
performance profile. This patch adds a new paragraph to the RAID1
section in md.4 that details what kind of speed-up one should expect
from RAID1.

Signed-off-by: Iustin Pop <iusty@k1024.org>
---
this patch is against the git tree of mdadm.

 md.4 |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/md.4 b/md.4
index cf423cb..db39aba 100644
--- a/md.4
+++ b/md.4
@@ -168,6 +168,13 @@ All devices in a RAID1 array should be the same size.  If they are
 not, then only the amount of space available on the smallest device is
 used (any extra space on other devices is wasted).
 
+Note that the read balancing done by the driver does not make the RAID1
+performance profile be the same as for RAID0; a single stream of
+sequential input will not be accelerated (e.g. a single dd), but
+multiple sequential streams or a random workload will use more than one
+spindle. In theory, having an N-disk RAID1 will allow N sequential
+threads to read from all disks.
+
 .SS RAID4
 
 A RAID4 array is like a RAID0 array with an extra device for storing
-- 
1.5.3.1

