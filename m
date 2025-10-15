Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0037B3148CA;
	Wed, 15 Oct 2025 08:32:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.178.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760517175; cv=none; b=Pgn+OtHTq3YWtDCeGOSj7AT9mdCuS1uyJTkk94Io0ld9wnVbIh6x0BIdCAO51OeCoRZdPNMiGzWzZ2N5I9NjeQfv7rgw8UwacRuUTaWn2B/BdK6rKtOmvylWlMX8QqrnffXoPyBeL6DW5sylJFEW5Wrtttyo0LEKEfo6G13MSm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760517175; c=relaxed/simple;
	bh=jVPVSXWNGo4mvJT8GJoKCYHGzbI3cPsRAbKsAEMALDM=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=oe2llEmNMsni7xCU2aUJVs2IhQdkIG0dDhN7sptfCIpMgF4kh9tQHHiBIhVQ8HA8HN1Z2dBCyicZuDrLQ+0CYq0VRqkK0y+LYgVwcCUGZqyyV/uZpznkgYtjPvOXnrmJtyTJr88FsSF2KdRlPHWPYnYbnEBjYWNuJSREnaS0hU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=Mdh+zUKu; arc=none smtp.client-ip=205.220.178.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="Mdh+zUKu"
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 59F4no4h1082360;
	Wed, 15 Oct 2025 08:32:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:message-id:mime-version:subject:to; s=PPS06212021; bh=V2EDcbNYv
	LL01IIkWfHOrUR00Ur1zntjnnN1k1MiE48=; b=Mdh+zUKuRxF1Vdhbr3+r+gTmW
	wxG/NDAZ3miIwshhnqfq5TKGCrmmw8LzfuHR/0X2GrwggFvrrmOMWrEQ97cJZowO
	ILelMYH2iHvkJddv0oAljZlHGcjPnq1M3YtT943doJm8UaRwq8X818Nve5DfUYhc
	8SGZ2YJMh0BYKjwGu6MW1px/1lnnSOlA+xRXOzDi6+E1ULlr6lsSWf3MjD9/B/jz
	bwxTbGpbpy4bk8vIjh3nL/cO5npw7r65yGZfKSgUD+Kje+u4wkGrHQgM4lJbYBFM
	aokCGI/YZkOgw5N3pWSSIJQfx3OYXEvGeYevAnlK8RjHNfj7vd4UNNyNUMHYg==
Received: from ala-exchng01.corp.ad.wrs.com ([128.224.246.36])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 49sthh931m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Wed, 15 Oct 2025 08:32:31 +0000 (GMT)
Received: from ala-exchng01.corp.ad.wrs.com (10.11.224.121) by
 ala-exchng01.corp.ad.wrs.com (10.11.224.121) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.59; Wed, 15 Oct 2025 01:32:30 -0700
Received: from pek-lpd-ccm5.wrs.com (10.11.232.110) by
 ala-exchng01.corp.ad.wrs.com (10.11.224.121) with Microsoft SMTP Server id
 15.1.2507.59 via Frontend Transport; Wed, 15 Oct 2025 01:32:28 -0700
From: Yun Zhou <yun.zhou@windriver.com>
To: <yukuai1@huaweicloud.com>, <song@kernel.org>, <yukuai3@huawei.com>,
        <yun.zhou@windriver.com>
CC: <linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] [v2] md: fix rcu protection in md_wakeup_thread
Date: Wed, 15 Oct 2025 16:32:27 +0800
Message-ID: <20251015083227.1079009-1-yun.zhou@windriver.com>
X-Mailer: git-send-email 2.27.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: W7azWnVzKdNRA7Wbk-IKvm8FGJaJv4E-
X-Proofpoint-ORIG-GUID: W7azWnVzKdNRA7Wbk-IKvm8FGJaJv4E-
X-Authority-Analysis: v=2.4 cv=QLBlhwLL c=1 sm=1 tr=0 ts=68ef5c1f cx=c_pps
 a=AbJuCvi4Y3V6hpbCNWx0WA==:117 a=AbJuCvi4Y3V6hpbCNWx0WA==:17
 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=t7CeM3EgAAAA:8
 a=1PL1aEpcXsvkPWtRAHQA:9 a=FdTzh2GWekK77mhwV6Dw:22 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE1MDA2NCBTYWx0ZWRfX+xAArX6q96W+
 e9kaT1Z3Joi0X5eno8BzwJie9nf2f3SDe0RhngxsHVXfVdsWRG7cYuY24OKXxz/BJup12UbIPWk
 VMSZfFJ9I9DZcyzR3XdFdeerL43LrOWg3lLXGxIkTJ3nMgEfc0mPi42JLM2tH4JqZA84Q4aKn6k
 HLD0/g8GISjgE2PVaHaQO0vwTkGGaY8tmbM34qon33ABqsQl98oPtJRqpspPYSFicm6NZTyi0p0
 rmcUhSe49/zEJ/ZMzueQgBv3TQmPsb48JrLg0Ll3NtZRhGlnaaoPzDlcXBCMFj1R6UFVHrFxJhx
 woV+KehOaXPiDr8K/9rzOmLePNl/dkiy8yFusw8r4TomrNbpPVYSYxMoYUMjmBWc1SNbSYk2HJy
 j7dKbo1+Al8l2YFlcpuAjzg7IviD/Q==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-15_04,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 lowpriorityscore=0 impostorscore=0 phishscore=0 adultscore=0
 priorityscore=1501 bulkscore=0 spamscore=0 suspectscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2510020000 definitions=main-2510150064

We attempted to use RCU to protect the pointer 'thread', but directly
passed the value when calling md_wakeup_thread(). This means that the
RCU pointer has been acquired before rcu_read_lock(), which renders
rcu_read_lock() ineffective and could lead to a use-after-free.

Fixes: 446931543982 ("md: protect md_thread with rcu")
Signed-off-by: Yun Zhou <yun.zhou@windriver.com>
---
 drivers/md/md.c | 14 ++++++--------
 drivers/md/md.h |  8 +++++++-
 2 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 4e033c26fdd4..7df3c47ee709 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -100,7 +100,7 @@ static int remove_and_add_spares(struct mddev *mddev,
 				 struct md_rdev *this);
 static void mddev_detach(struct mddev *mddev);
 static void export_rdev(struct md_rdev *rdev, struct mddev *mddev);
-static void md_wakeup_thread_directly(struct md_thread __rcu *thread);
+static void md_wakeup_thread_directly(struct md_thread __rcu **thread);
 
 /*
  * Default number of read corrections we'll attempt on an rdev
@@ -4982,7 +4982,7 @@ static void stop_sync_thread(struct mddev *mddev, bool locked)
 	 * Thread might be blocked waiting for metadata update which will now
 	 * never happen
 	 */
-	md_wakeup_thread_directly(mddev->sync_thread);
+	md_wakeup_thread_directly(&mddev->sync_thread);
 	if (work_pending(&mddev->sync_work))
 		flush_work(&mddev->sync_work);
 
@@ -8194,22 +8194,21 @@ static int md_thread(void *arg)
 	return 0;
 }
 
-static void md_wakeup_thread_directly(struct md_thread __rcu *thread)
+static void md_wakeup_thread_directly(struct md_thread __rcu **thread)
 {
 	struct md_thread *t;
 
 	rcu_read_lock();
-	t = rcu_dereference(thread);
+	t = rcu_dereference(*thread);
 	if (t)
 		wake_up_process(t->tsk);
 	rcu_read_unlock();
 }
 
-void md_wakeup_thread(struct md_thread __rcu *thread)
+void __md_wakeup_thread(struct md_thread __rcu *thread)
 {
 	struct md_thread *t;
 
-	rcu_read_lock();
 	t = rcu_dereference(thread);
 	if (t) {
 		pr_debug("md: waking up MD thread %s.\n", t->tsk->comm);
@@ -8217,9 +8216,8 @@ void md_wakeup_thread(struct md_thread __rcu *thread)
 		if (wq_has_sleeper(&t->wqueue))
 			wake_up(&t->wqueue);
 	}
-	rcu_read_unlock();
 }
-EXPORT_SYMBOL(md_wakeup_thread);
+EXPORT_SYMBOL(__md_wakeup_thread);
 
 struct md_thread *md_register_thread(void (*run) (struct md_thread *),
 		struct mddev *mddev, const char *name)
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 51af29a03079..c989cc9f6216 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -878,6 +878,12 @@ struct md_io_clone {
 
 #define THREAD_WAKEUP  0
 
+#define md_wakeup_thread(thread) do {   \
+	rcu_read_lock();                    \
+	__md_wakeup_thread(thread);         \
+	rcu_read_unlock();                  \
+} while (0)
+
 static inline void safe_put_page(struct page *p)
 {
 	if (p) put_page(p);
@@ -891,7 +897,7 @@ extern struct md_thread *md_register_thread(
 	struct mddev *mddev,
 	const char *name);
 extern void md_unregister_thread(struct mddev *mddev, struct md_thread __rcu **threadp);
-extern void md_wakeup_thread(struct md_thread __rcu *thread);
+extern void __md_wakeup_thread(struct md_thread __rcu *thread);
 extern void md_check_recovery(struct mddev *mddev);
 extern void md_reap_sync_thread(struct mddev *mddev);
 extern enum sync_action md_sync_action(struct mddev *mddev);
-- 
2.27.0

