From: "Kwolek, Adam" <adam.kwolek@intel.com>
Subject: [PATCH 16/23] Set size on reshape finish by mdadm
Date: Wed, 9 Jun 2010 15:38:52 +0100
Message-ID: <905EDD02F158D948B186911EB64DB3D11EECE8E7@irsmsx503.ger.corp.intel.com>
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
When Online capacity expansion/reshape is finished, md doesn't set new array size for external meta (it is managed externally), so mdadm has to wait until reshape finish, read new array size from metadata and then set it in md.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 Grow.c |   67 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 67 insertions(+), 0 deletions(-)

diff --git a/Grow.c b/Grow.c
index ab83e31..4431b64 100644
--- a/Grow.c
+++ b/Grow.c
@@ -472,6 +472,70 @@ void wait_reshape(struct mdinfo *sra)  }
 			
 		
+int grow_manage_size_ext_meta(char *devname) {
+	int ret_val = 0;
+	struct supertype *st = NULL;
+	struct mdinfo *sra = NULL;
+	struct mdinfo info;
+	int fd = -1;
+	unsigned long long size;
+	int container_fd;
+	int dn;
+
+	/* finalize current volume reshape
+	 * for external meta size has to be managed by mdadm
+	 * read size set in meta and put it to md when
+	 * reshape is finished.
+	 *
+	 * for takeovered array, return to original raid level
+	 */
+
+	if (devname == NULL)
+		goto exit_grow_manage_size_ext_meta;
+
+	fd = open(devname, O_RDONLY | O_DIRECT);
+
+	if (fd < 0)
+		goto exit_grow_manage_size_ext_meta;
+	st = super_by_fd(fd);
+	if (st == NULL)
+		goto exit_grow_manage_size_ext_meta;
+
+	if (st->ss->external == 0)
+		goto exit_grow_manage_size_ext_meta;
+
+	sra = sysfs_read(fd, 0, GET_VERSION);
+	if (sra == NULL)
+		goto exit_grow_manage_size_ext_meta;
+	wait_reshape(sra);
+
+	/* reshape has finished, update md size
+	 * get per-device size and multiply by data disks
+	 */
+	dn = devname2devnum(sra->text_version + 1);
+	container_fd = open_dev_excl(dn);
+	if (container_fd < 0)
+		goto exit_grow_manage_size_ext_meta;
+	st->ss->load_super(st, container_fd, NULL);
+	st->ss->getinfo_super(st, &info);
+	close(container_fd);
+
+	size = info.custom_array_size/2;
+	sysfs_set_num(sra, NULL, "array_size", size);
+
+	/* for takeovered array return to original raid level */
+	ret_val = 1;
+
+exit_grow_manage_size_ext_meta:
+	if (st)
+		st->ss->free_super(st);
+	sysfs_free(sra);
+	if (fd > -1)
+		close(fd);
+	return ret_val;
+}
+
 #define	EXTERNAL_META_STATUS_OK		1
 #define	EXTERNAL_META_STATUS_ERROR	2
 int Grow_reshape(char *devname, int fd, int quiet, char *backup_file, @@ -1411,6 +1475,9 @@ ext_array_configured:
 						       d - odisks, fdlist+odisks, offsets+odisks);
 			if (backup_file && done)
 				unlink(backup_file);
+			if ((done >= 0) && (odata < ndata))
+				grow_manage_size_ext_meta(devname);
+
 			if (level != UnSet && level != array.level) {
 				/* We need to wait for the reshape to finish
 				 * (which will have happened unless odata < ndata)

