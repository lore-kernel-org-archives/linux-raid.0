From: Anna-Maria Gleixner <anna-maria@linutronix.de>
Subject: [PATCH] md/raid5: Cleanup cpu hotplug notifier
Date: Wed, 16 Mar 2016 09:25:23 +0100
Message-ID: <1458116723-66984-1-git-send-email-anna-maria@linutronix.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: rt@linutronix.de, Anna-Maria Gleixner <anna-maria@linutronix.de>, Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

The raid456_cpu_notify() hotplug callback lacks handling of the
CPU_UP_CANCELED case. That means if CPU_UP_PREPARE fails, the scratch
buffer is leaked.

Add handling for CPU_UP_CANCELED[_FROZEN] hotplug notifier transitions
to free the scratch buffer.

CC: Shaohua Li <shli@kernel.org>
CC: linux-raid@vger.kernel.org
Signed-off-by: Anna-Maria Gleixner <anna-maria@linutronix.de>
---
 drivers/md/raid5.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -6376,6 +6376,8 @@ static int raid456_cpu_notify(struct not
 		break;
 	case CPU_DEAD:
 	case CPU_DEAD_FROZEN:
+	case CPU_UP_CANCELED:
+	case CPU_UP_CANCELED_FROZEN:
 		free_scratch_buffer(conf, per_cpu_ptr(conf->percpu, cpu));
 		break;
 	default:
