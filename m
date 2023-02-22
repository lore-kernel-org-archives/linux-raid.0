Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 405E8C64ED6
	for <linux-raid@archiver.kernel.org>; Wed, 22 Feb 2023 08:31:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230434AbjBVIbA (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 22 Feb 2023 03:31:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230374AbjBVIa7 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 22 Feb 2023 03:30:59 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D0CF30B11
        for <linux-raid@vger.kernel.org>; Wed, 22 Feb 2023 00:30:57 -0800 (PST)
Received: from kwepemi500002.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4PM8Ss6QK5zKpqx;
        Wed, 22 Feb 2023 16:29:01 +0800 (CST)
Received: from [10.174.179.167] (10.174.179.167) by
 kwepemi500002.china.huawei.com (7.221.188.171) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.17; Wed, 22 Feb 2023 16:30:54 +0800
Message-ID: <5ab784a2-df14-62d7-873a-622b34b6a646@huawei.com>
Date:   Wed, 22 Feb 2023 16:30:53 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.0.3
Content-Language: en-US
To:     Jes Sorensen <jes@trained-monkey.org>,
        Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        Paul Menzel <pmenzel@molgen.mpg.de>,
        <linux-raid@vger.kernel.org>
CC:     linfeilong <linfeilong@huawei.com>,
        "liuzhiqiang (I)" <liuzhiqiang26@huawei.com>,
        Wu Guanghao <wuguanghao3@huawei.com>, <lixiaokeng@huawei.com>
From:   miaoguanqin <miaoguanqin@huawei.com>
Subject: [PATCH] Fix memory leak for function Manage_subdevs Manage_add Kill
 V2
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.167]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemi500002.china.huawei.com (7.221.188.171)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

When we test mdadm with asan,we found some memory leaks.
We fix these memory leaks based on code logic.

Signed-off-by: miaoguanqin <miaoguanqin@huawei.com>
---
  Assemble.c | 16 +++++++++++++---
  Kill.c     | 10 +++++++++-
  Manage.c   | 16 +++++++++++++++-
  mdadm.c    |  6 ++++++
  4 files changed, 43 insertions(+), 5 deletions(-)

diff --git a/Assemble.c b/Assemble.c
index 3ef4b29..c23567f 100644
--- a/Assemble.c
+++ b/Assemble.c
@@ -281,8 +281,10 @@ static int select_devices(struct mddev_dev *devlist,
  				st->ss->free_super(st);
  			dev_policy_free(pol);
  			domain_free(domains);
-			if (tst)
+			if (tst) {
  				tst->ss->free_super(tst);
+				free(tst);
+			}
  			return -1;
  		}

@@ -357,6 +359,7 @@ static int select_devices(struct mddev_dev *devlist,
  				st->ss->free_super(st);
  				dev_policy_free(pol);
  				domain_free(domains);
+				free(st);
  				return -1;
  			}
  			if (c->verbose > 0)
@@ -365,6 +368,8 @@ static int select_devices(struct mddev_dev *devlist,

  			/* make sure we finished the loop */
  			tmpdev = NULL;
+			if (st)
+				free(st);
  			goto loop;
  		} else {
  			content = *contentp;
@@ -473,6 +478,7 @@ static int select_devices(struct mddev_dev *devlist,
  				st->ss->free_super(st);
  				dev_policy_free(pol);
  				domain_free(domains);
+				free(tst);
  				return -1;
  			}
  			tmpdev->used = 1;
@@ -486,8 +492,10 @@ static int select_devices(struct mddev_dev *devlist,
  		}
  		dev_policy_free(pol);
  		pol = NULL;
-		if (tst)
+		if (tst) {
  			tst->ss->free_super(tst);
+			free(tst);
+		}
  	}

  	/* Check if we found some imsm spares but no members */
@@ -778,6 +786,7 @@ static int load_devices(struct devs *devices, char 
*devmap,
  				close(mdfd);
  				free(devices);
  				free(devmap);
+				free(best);
  				*stp = st;
  				return -1;
  			}
@@ -1882,7 +1891,8 @@ out:
  		}
  	} else if (mdfd >= 0)
  		close(mdfd);
-
+	if (best)
+		free(best);
  	/* '2' means 'OK, but not started yet' */
  	if (rv == -1) {
  		free(devices);
diff --git a/Kill.c b/Kill.c
index d4767e2..073288e 100644
--- a/Kill.c
+++ b/Kill.c
@@ -41,6 +41,7 @@ int Kill(char *dev, struct supertype *st, int force, 
int verbose, int noexcl)
  	 *  4 - failed to find a superblock.
  	 */

+	int flags = 0;
  	int fd, rv = 0;

  	if (force)
@@ -52,8 +53,10 @@ int Kill(char *dev, struct supertype *st, int force, 
int verbose, int noexcl)
  				dev);
  		return 2;
  	}
-	if (st == NULL)
+	if (st == NULL) {
  		st = guess_super(fd);
+		flags = 1;
+	}
  	if (st == NULL || st->ss->init_super == NULL) {
  		if (verbose >= 0)
  			pr_err("Unrecognised md component device - %s\n", dev);
@@ -77,6 +80,11 @@ int Kill(char *dev, struct supertype *st, int force, 
int verbose, int noexcl)
  			rv = 0;
  		}
  	}
+	if (flags == 1 && st) {
+		if (st->sb)
+			free(st->sb);
+		free(st);
+	}
  	close(fd);
  	return rv;
  }
diff --git a/Manage.c b/Manage.c
index ffe55f8..60c6d12 100644
--- a/Manage.c
+++ b/Manage.c
@@ -222,6 +222,8 @@ int Manage_stop(char *devname, int fd, int verbose, 
int will_retry)
  		if (verbose >= 0)
  			pr_err("Cannot get exclusive access to %s:Perhaps a running 
process, mounted filesystem or active volume group?\n",
  			       devname);
+		if (mdi)
+			sysfs_free(mdi);
  		return 1;
  	}
  	/* If this is an mdmon managed array, just write 'inactive'
@@ -819,8 +821,16 @@ int Manage_add(int fd, int tfd, struct mddev_dev *dv,
  						    rdev, update, devname,
  						    verbose, array);
  				dev_st->ss->free_super(dev_st);
-				if (rv)
+				if (rv){
+					if (dev_st)
+						free(dev_st);
  					return rv;
+				}
+			}
+			if (dev_st) {
+				if (dev_st->sb)
+					dev_st->ss->free_super(dev_st);
+				free(dev_st);
  			}
  		}
  		if (dv->disposition == 'M') {
@@ -1649,6 +1659,8 @@ int Manage_subdevs(char *devname, int fd,
  			break;
  		}
  	}
+	if (tst)
+		free(tst);
  	if (frozen > 0)
  		sysfs_set_str(&info, NULL, "sync_action","idle");
  	if (test && count == 0)
@@ -1656,6 +1668,8 @@ int Manage_subdevs(char *devname, int fd,
  	return 0;

  abort:
+	if(tst)
+		free(tst);
  	if (frozen > 0)
  		sysfs_set_str(&info, NULL, "sync_action","idle");
  	return !test && busy ? 2 : 1;
diff --git a/mdadm.c b/mdadm.c
index da66c76..981fa98 100644
--- a/mdadm.c
+++ b/mdadm.c
@@ -1765,6 +1765,12 @@ int main(int argc, char *argv[])
  		autodetect();
  		break;
  	}
+	if (ss) {
+		if (ss->sb)
+			free(ss->sb);
+		free(ss);
+	
+	}
  	if (locked)
  		cluster_release_dlmlock();
  	if (mdfd > 0)
-- 
2.33.0

