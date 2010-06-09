From: "Kwolek, Adam" <adam.kwolek@intel.com>
Subject: [PATCH 20/23] Finalize raid0 array expansion
Date: Wed, 9 Jun 2010 15:42:24 +0100
Message-ID: <905EDD02F158D948B186911EB64DB3D11EECE8F9@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

(Online Capacity Expansion for IMSM)
When raid0 grow was started array is transformed to degraded raid5 array.
mdadm has to wait until reshape finish and execute takeover to raid0.
Takeover to raid0 is found by mdmon and array is removed from monitoring.

It can happen that mdmon misses takeover to raid0 and not updates internal data. To resolve this, after takeover ping to container is sent to notify mdmon about takeover action.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 Grow.c |   57 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 56 insertions(+), 1 deletions(-)

diff --git a/Grow.c b/Grow.c
index 77e554c..5e84c2a 100644
--- a/Grow.c
+++ b/Grow.c
@@ -35,6 +35,54 @@
 #define offsetof(t,f) ((size_t)&(((t*)0)->f))  #endif
 
+void ping_container(char *devname)
+{
+	struct supertype *st = NULL;
+	struct mdinfo *sra = NULL;
+	int fd = -1;
+	int dn;
+	char *p;
+
+	/* signal manager to work
+	 */
+
+	if (devname == NULL)
+		goto exit_ping_container;
+
+	fd = open(devname, O_RDONLY | O_DIRECT);
+
+	if (fd < 0)
+		goto exit_ping_container;
+	st = super_by_fd(fd);
+	if (st == NULL)
+		goto exit_ping_container;
+
+	if (st->ss->external == 0)
+		goto exit_ping_container;
+
+	sra = sysfs_read(fd, 0, GET_VERSION);
+	if (sra == NULL)
+		goto exit_ping_container;
+
+	dn = devname2devnum(sra->text_version + 1);
+	p = devnum2devname(dn);
+	/* ping manager to let him know about level change
+	 * in case it miss this
+	 */
+	ping_manager(p);
+	/* ping monitor to make possible monitor exit
+	 * before next volume processing
+	 */
+	ping_monitor(p);
+
+exit_ping_container:
+	if (st)
+		st->ss->free_super(st);
+	sysfs_free(sra);
+	if (fd > -1)
+		close(fd);
+}
+
 int Grow_Add_device(char *devname, int fd, char *newdev)  {
 	/* Add a device to an active array.
@@ -1496,8 +1544,10 @@ ext_array_configured:
 						       d - odisks, fdlist+odisks, offsets+odisks);
 			if (backup_file && done)
 				unlink(backup_file);
-			if ((done >= 0) && (odata < ndata))
+			if ((done >= 0) && (odata < ndata)) {
 				grow_manage_size_ext_meta(devname);
+				level = orig_level;
+			}
 
 			if (level != UnSet && level != array.level) {
 				/* We need to wait for the reshape to finish @@ -1515,6 +1565,11 @@ ext_array_configured:
 				if (err)
 					fprintf(stderr, Name ": %s: could not set level to %s\n",
 						devname, c);
+				/* for external meta mdmon can miss takeover
+				 * to be sure that mdmon notices level change
+				 * send ping to manager
+				 */
+				ping_container(devname);
 			}
 			exit(0);
 		case -1:

