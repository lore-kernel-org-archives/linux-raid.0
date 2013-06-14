From: Joe Perches <joe@perches.com>
Subject: [Trivial PATCH 13/33] md: Convert use of typedef ctl_table to struct ctl_table
Date: Thu, 13 Jun 2013 19:37:38 -0700
Message-ID: <f688e5c8901e3fadf381ba5ba5cde664bd95ab93.1371177118.git.joe@perches.com>
References: <cover.1371177118.git.joe@perches.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1371177118.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jiri Kosina <trivial@kernel.org>
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

This typedef is unnecessary and should just be removed.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/md/md.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 9b82377..f7edaf9 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -112,7 +112,7 @@ static inline int speed_max(struct mddev *mddev)
 
 static struct ctl_table_header *raid_table_header;
 
-static ctl_table raid_table[] = {
+static struct ctl_table raid_table[] = {
 	{
 		.procname	= "speed_limit_min",
 		.data		= &sysctl_speed_limit_min,
@@ -130,7 +130,7 @@ static ctl_table raid_table[] = {
 	{ }
 };
 
-static ctl_table raid_dir_table[] = {
+static struct ctl_table raid_dir_table[] = {
 	{
 		.procname	= "raid",
 		.maxlen		= 0,
@@ -140,7 +140,7 @@ static ctl_table raid_dir_table[] = {
 	{ }
 };
 
-static ctl_table raid_root_table[] = {
+static struct ctl_table raid_root_table[] = {
 	{
 		.procname	= "dev",
 		.maxlen		= 0,
-- 
1.8.1.2.459.gbcd45b4.dirty
