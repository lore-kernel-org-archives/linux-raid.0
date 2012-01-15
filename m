From: Sasha Levin <levinsasha928@gmail.com>
Subject: [PATCH] md: Remove annoying debug message when restarting
Date: Sun, 15 Jan 2012 23:14:15 +0200
Message-ID: <1326662055-7098-1-git-send-email-levinsasha928@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: neilb@suse.de, mingo@elte.hu
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Sasha Levin <levinsasha928@gmail.com>
List-Id: linux-raid.ids

This patch removes the "md: stopping all md devices" message when shutting
down/restarting.

On Sat, 2012-01-14 at 09:43 +0100, Ingo Molnar wrote:
> Btw. #2, that annoying 'md: stopping' message should be gotten
> rid of. Some moron added that to the kernel as a one-day debug
> printout to debug a software-RAID hang during development of the
> code, about 15 years ago. (Oh, that was me.)

Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
---
 drivers/md/md.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 9417ae2..1491969 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -8158,8 +8158,6 @@ static int md_notify_reboot(struct notifier_block *this,
 
 	if ((code == SYS_DOWN) || (code == SYS_HALT) || (code == SYS_POWER_OFF)) {
 
-		printk(KERN_INFO "md: stopping all md devices.\n");
-
 		for_each_mddev(mddev, tmp) {
 			if (mddev_trylock(mddev)) {
 				/* Force a switch to readonly even array
-- 
1.7.8.3
