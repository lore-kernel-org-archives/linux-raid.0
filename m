Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3B6E7D063
	for <linux-raid@vger.kernel.org>; Thu, 29 Feb 2024 11:52:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709207555; cv=none; b=VawEgndM1wIOcA/y2r2G4+Ei/k6NhLWEPPzK+zd0fhK7zgOw88lnP0xj2gZMiN6OeYUfO0HEMzZKSwyOA690NYJ/kvwb35KA8K2JSNMJiln0KhjOxsMtB3TrLQC0Z37HiBWxd9Z3kLIIQeZT9Fsiy9jHZuuAvyFNF6KSXKnztYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709207555; c=relaxed/simple;
	bh=NBMjCqASLPv65qRXzRoZbEvuC8aloBYLd10/n99m07A=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=eAMcdzyUM865ULfliuG/+Om2NWx/SCi2+cGhAPVtHqsXqc7B7OWntYZ5k6l+0HoWWXqLSLQgRRw5Xu12qTp0ujt0rUUtO9BPidyHjJABHapatxQC1gK6XydZmfa3mpv/Ug8U3NXaQKNXluNOGn/U1AqPp6uECDRdOtC1eD+6NoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HE9TU8rR; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HE9TU8rR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709207554; x=1740743554;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=NBMjCqASLPv65qRXzRoZbEvuC8aloBYLd10/n99m07A=;
  b=HE9TU8rRH8ksfvN/qZiBEJktM1S/fOJICCWY4i7DpRPKcZC3YMJSwetQ
   iZoJfmbIhXOGWGHNtdlgHt00ezygFwkBpOeePVF7LC/p2xDcBVF2Chlyf
   J7niAHLe9I6uIoGSyjupofXiaHdeaLAwip6XXUa2ZHyylxTXnesRcXHBR
   nzx8nJpxo1iBT3atylmliUGrUIlf8ZFsWpak3ZRK8w0P55OWpN9IWGVKu
   548w1V+Fm/crg2SvQnliAgP4I7MeRE01VQu+DLL1VN742aZGObpJId9LI
   bOGHrCHc8oVBylWFf0Q4M1x142g6HbICh7qVXJVzGJhrsi0HGLWT3GEzP
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10998"; a="7499443"
X-IronPort-AV: E=Sophos;i="6.06,194,1705392000"; 
   d="scan'208";a="7499443"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Feb 2024 03:52:34 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,194,1705392000"; 
   d="scan'208";a="7754802"
Received: from unknown (HELO mtkaczyk-devel.igk.intel.com) ([10.102.108.91])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Feb 2024 03:52:33 -0800
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: jes@trained-monkey.org
Cc: linux-raid@vger.kernel.org,
	Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Subject: [PATCH 03/13] Manage: fix check after dereference issue
Date: Thu, 29 Feb 2024 12:52:07 +0100
Message-Id: <20240229115217.26543-4-mariusz.tkaczyk@linux.intel.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20240229115217.26543-1-mariusz.tkaczyk@linux.intel.com>
References: <20240229115217.26543-1-mariusz.tkaczyk@linux.intel.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The code dereferences dev_st earlier without checking, it gives SAST
problem.

dev_st is needed for attempt_re_add(), but it is executed only if
dv->disposition != 'S', so move disposition check up.

tst is a must to reach this place, dup_super() have to return valid
pointer, all it needs to check is if load_super() returns superblock.

Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
---
 Manage.c | 26 ++++++++++++--------------
 1 file changed, 12 insertions(+), 14 deletions(-)

diff --git a/Manage.c b/Manage.c
index 30302ac833f2..77b79cf57554 100644
--- a/Manage.c
+++ b/Manage.c
@@ -794,25 +794,23 @@ int Manage_add(int fd, int tfd, struct mddev_dev *dv,
 		 * simply re-add it.
 		 */
 
-		if (array->not_persistent == 0) {
+		if (array->not_persistent == 0 && dv->disposition != 'S') {
+			int rv = 0;
+
 			dev_st = dup_super(tst);
 			dev_st->ss->load_super(dev_st, tfd, NULL);
-			if (dev_st->sb && dv->disposition != 'S') {
-				int rv;
 
-				rv = attempt_re_add(fd, tfd, dv, dev_st, tst,
-						    rdev, update, devname,
-						    verbose, array);
-				dev_st->ss->free_super(dev_st);
-				if (rv) {
-					free(dev_st);
-					return rv;
-				}
-			}
-			if (dev_st) {
+			if (dev_st->sb) {
+				rv = attempt_re_add(fd, tfd, dv, dev_st, tst, rdev, update,
+						    devname, verbose, array);
+
 				dev_st->ss->free_super(dev_st);
-				free(dev_st);
 			}
+
+			free(dev_st);
+
+			if (rv)
+				return rv;
 		}
 		if (dv->disposition == 'M') {
 			if (verbose > 0)
-- 
2.35.3

