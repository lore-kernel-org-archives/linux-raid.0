From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 6/6] md: Add some spaces for better code readability
Date: Tue, 2 May 2017 16:31:00 +0200
Message-ID: <9ef3d847-cab3-d7e4-7d76-2c41700df779@users.sourceforge.net>
References: <f05bfc4e-7935-7e87-cc85-f0d9c5e3846a@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <f05bfc4e-7935-7e87-cc85-f0d9c5e3846a@users.sourceforge.net>
Content-Language: en-GB
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, Neil Brown <neilb@suse.com>, Shaohua Li <shli@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-raid.ids

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Tue, 2 May 2017 16:00:45 +0200

Use space characters and blank lines at some source code places
according to the Linux coding style convention.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/md/faulty.c | 27 +++++++++++++++------------
 1 file changed, 15 insertions(+), 12 deletions(-)

diff --git a/drivers/md/faulty.c b/drivers/md/faulty.c
index 2573009b1265..434c3643c9c3 100644
--- a/drivers/md/faulty.c
+++ b/drivers/md/faulty.c
@@ -110,19 +110,20 @@ static int check_sector(struct faulty_conf *conf, sector_t start, sector_t end,
 {
 	/* If we find a ReadFixable sector, we fix it ... */
 	int i;
-	for (i=0; i<conf->nfaults; i++)
+
+	for (i = 0; i < conf->nfaults; i++)
 		if (conf->faults[i] >= start &&
 		    conf->faults[i] < end) {
 			/* found it ... */
 			switch (conf->modes[i] * 2 + dir) {
-			case WritePersistent*2+WRITE: return 1;
-			case ReadPersistent*2+READ: return 1;
-			case ReadFixable*2+READ: return 1;
-			case ReadFixable*2+WRITE:
+			case WritePersistent * 2 + WRITE: return 1;
+			case ReadPersistent * 2 + READ: return 1;
+			case ReadFixable * 2 + READ: return 1;
+			case ReadFixable * 2 + WRITE:
 				conf->modes[i] = NoPersist;
 				return 0;
-			case AllPersist*2+READ:
-			case AllPersist*2+WRITE: return 1;
+			case AllPersist * 2 + READ:
+			case AllPersist * 2 + WRITE: return 1;
 			default:
 				return 0;
 			}
@@ -134,9 +135,10 @@ static void add_sector(struct faulty_conf *conf, sector_t start, int mode)
 {
 	int i;
 	int n = conf->nfaults;
-	for (i=0; i<conf->nfaults; i++)
+
+	for (i = 0; i < conf->nfaults; i++)
 		if (conf->faults[i] == start) {
-			switch(mode) {
+			switch (mode) {
 			case NoPersist: conf->modes[i] = mode; return;
 			case WritePersistent:
 				if (conf->modes[i] == ReadPersistent ||
@@ -167,7 +169,7 @@ static void add_sector(struct faulty_conf *conf, sector_t start, int mode)
 	conf->faults[n] = start;
 	conf->modes[n] = mode;
 	if (conf->nfaults == n)
-		conf->nfaults = n+1;
+		conf->nfaults = n + 1;
 }
 
 static void faulty_make_request(struct mddev *mddev, struct bio *bio)
@@ -278,7 +280,8 @@ static int faulty_reshape(struct mddev *mddev)
 		conf->nfaults = 0;
 	else if (mode == ClearErrors) {
 		int i;
-		for (i=0 ; i < Modes ; i++) {
+
+		for (i = 0; i < Modes; i++) {
 			conf->period[i] = 0;
 			atomic_set(&conf->counters[i], 0);
 		}
@@ -317,7 +320,7 @@ static int faulty_run(struct mddev *mddev)
 	if (!conf)
 		return -ENOMEM;
 
-	for (i=0; i<Modes; i++) {
+	for (i = 0; i < Modes; i++) {
 		atomic_set(&conf->counters[i], 0);
 		conf->period[i] = 0;
 	}
-- 
2.12.2

