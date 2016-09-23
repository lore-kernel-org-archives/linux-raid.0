From: "Kammela, Gayatri" <gayatri.kammela@intel.com>
Subject: RE: [PATCH v2] raid6/test/test.c: bug fix: Specify
 aligned(alignment) attributes to the char arrays
Date: Fri, 23 Sep 2016 00:18:00 +0000
Message-ID: <2824B99DC70CE746926327C52CA42F7613671A03@ORSMSX111.amr.corp.intel.com>
References: <1474589275-12045-1-git-send-email-gayatri.kammela@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1474589275-12045-1-git-send-email-gayatri.kammela@intel.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "shli@kernel.org" <shli@kernel.org>, "Anvin, H Peter" <h.peter.anvin@intel.com>, "Shankar, Ravi V" <ravi.v.shankar@intel.com>, "Yu, Fenghua" <fenghua.yu@intel.com>, "H . Peter Anvin" <hpa@zytor.com>, "Yu, Yu-cheng" <yu-cheng.yu@intel.com>
List-Id: linux-raid.ids

Hi all,
Sorry for the noise! I didn't mean to send the version2.

-----Original Message-----
From: Kammela, Gayatri 
Sent: Thursday, September 22, 2016 5:08 PM
To: linux-raid@vger.kernel.org; linux-kernel@vger.kernel.org
Cc: shli@kernel.org; Anvin, H Peter <h.peter.anvin@intel.com>; Shankar, Ravi V <ravi.v.shankar@intel.com>; Yu, Fenghua <fenghua.yu@intel.com>; Kammela, Gayatri <gayatri.kammela@intel.com>; H . Peter Anvin <hpa@zytor.com>; Yu, Yu-cheng <yu-cheng.yu@intel.com>
Subject: [PATCH v2] raid6/test/test.c: bug fix: Specify aligned(alignment) attributes to the char arrays

Specifying the aligned attributes to the char recovi[PAGE_SIZE] and char recovi[PAGE_SIZE] arrays, so that all malloc memory is page boundary aligned.

Without these alignment attributes, the test causes a segfault in userspace when the NDISKS are changed to 4 from 16.

Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Yu-cheng Yu <yu-cheng.yu@intel.com>
Signed-off-by: Gayatri Kammela <gayatri.kammela@intel.com>
---
 lib/raid6/test/test.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/lib/raid6/test/test.c b/lib/raid6/test/test.c index 3bebbabdb510..32a00f11ac50 100644
--- a/lib/raid6/test/test.c
+++ b/lib/raid6/test/test.c
@@ -21,12 +21,13 @@
 
 #define NDISKS		16	/* Including P and Q */
 
-const char raid6_empty_zero_page[PAGE_SIZE] __attribute__((aligned(256)));
+const char raid6_empty_zero_page[PAGE_SIZE] 
+__attribute__((aligned(PAGE_SIZE)));
 struct raid6_calls raid6_call;
 
 char *dataptrs[NDISKS];
 char data[NDISKS][PAGE_SIZE];
-char recovi[PAGE_SIZE], recovj[PAGE_SIZE];
+char recovi[PAGE_SIZE] __attribute__((aligned(PAGE_SIZE)));
+char recovj[PAGE_SIZE] __attribute__((aligned(PAGE_SIZE)));
 
 static void makedata(int start, int stop)  {
--
2.7.4
