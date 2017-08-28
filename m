From: Song Liu <songliubraving@fb.com>
Subject: [PATCH 1/2] mdadm: install two more udev rules in mdadm.spec
Date: Mon, 28 Aug 2017 15:20:35 -0700
Message-ID: <20170828222036.3278481-2-songliubraving@fb.com>
References: <20170828222036.3278481-1-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170828222036.3278481-1-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Song Liu <songliubraving@fb.com>, shli@fb.com, neilb@suse.com, kernel-team@fb.com, dan.j.williams@intel.com, hch@infradead.org, jes.sorensen@gmail.com
List-Id: linux-raid.ids

To avoid rpmbuild error.

Signed-off-by: Song Liu <songliubraving@fb.com>
---
 mdadm.spec | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mdadm.spec b/mdadm.spec
index 4e97efb..4e6f870 100644
--- a/mdadm.spec
+++ b/mdadm.spec
@@ -37,8 +37,10 @@ rm -rf $RPM_BUILD_ROOT
 %doc TODO ChangeLog mdadm.conf-example COPYING
 %{_sbindir}/mdadm
 %{_sbindir}/mdmon
+/usr/lib/udev/rules.d/01-md-raid-creating.rules
 /usr/lib/udev/rules.d/63-md-raid-arrays.rules
 /usr/lib/udev/rules.d/64-md-raid-assembly.rules
+/usr/lib/udev/rules.d/69-md-clustered-confirm-device.rules
 %config(noreplace,missingok)/%{_sysconfdir}/mdadm.conf
 %{_mandir}/man*/md*
 
-- 
2.9.5

