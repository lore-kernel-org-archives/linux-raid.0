From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Subject: [PATCH] imsm: retrieve nvme serial from sysfs
Date: Thu,  6 Oct 2016 11:13:09 +0200
Message-ID: <20161006091309.27263-1-artur.paszkiewicz@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: jes.sorensen@redhat.com
Cc: linux-raid@vger.kernel.org, Artur Paszkiewicz <artur.paszkiewicz@intel.com>
List-Id: linux-raid.ids

Don't rely on SCSI ioctl for reading NVMe serials - SCSI emulation for
NVMe devices can be disabled in the kernel config. Instead, try to get a
serial from /sys/block/nvme*/device/serial. If that fails for whatever
reason (i.e. no such attribute in old kernels) - fall back to the SCSI
method.

This also moves some SCSI-specific code from imsm_read_serial() to
scsi_get_serial().

Signed-off-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Reviewed-by: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Reviewed-by: Alexey Obitotskiy <aleksey.obitotskiy@intel.com>
---
 sg_io.c       | 23 +++++++++++++++++++----
 super-intel.c | 46 +++++++++++++++++++++++++++-------------------
 2 files changed, 46 insertions(+), 23 deletions(-)

diff --git a/sg_io.c b/sg_io.c
index 50ad180..42c91e1 100644
--- a/sg_io.c
+++ b/sg_io.c
@@ -23,20 +23,35 @@
 
 int scsi_get_serial(int fd, void *buf, size_t buf_len)
 {
-	unsigned char inq_cmd[] = {INQUIRY, 1, 0x80, 0, buf_len, 0};
+	unsigned char rsp_buf[255];
+	unsigned char inq_cmd[] = {INQUIRY, 1, 0x80, 0, sizeof(rsp_buf), 0};
 	unsigned char sense[32];
 	struct sg_io_hdr io_hdr;
+	int rv;
+	unsigned int rsp_len;
 
 	memset(&io_hdr, 0, sizeof(io_hdr));
 	io_hdr.interface_id = 'S';
 	io_hdr.cmdp = inq_cmd;
 	io_hdr.cmd_len = sizeof(inq_cmd);
-	io_hdr.dxferp = buf;
-	io_hdr.dxfer_len = buf_len;
+	io_hdr.dxferp = rsp_buf;
+	io_hdr.dxfer_len = sizeof(rsp_buf);
 	io_hdr.dxfer_direction = SG_DXFER_FROM_DEV;
 	io_hdr.sbp = sense;
 	io_hdr.mx_sb_len = sizeof(sense);
 	io_hdr.timeout = 5000;
 
-	return ioctl(fd, SG_IO, &io_hdr);
+	rv = ioctl(fd, SG_IO, &io_hdr);
+
+	if (rv)
+		return rv;
+
+	rsp_len = rsp_buf[3];
+
+	if (!rsp_len || buf_len < rsp_len)
+		return -1;
+
+	memcpy(buf, &rsp_buf[4], rsp_len);
+
+	return 0;
 }
diff --git a/super-intel.c b/super-intel.c
index cfc8904..1304737 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -3331,23 +3331,40 @@ static void fd2devname(int fd, char *name)
 	}
 }
 
+static int nvme_get_serial(int fd, void *buf, size_t buf_len)
+{
+	char path[60];
+	char *name = fd2kname(fd);
+
+	if (!name)
+		return 1;
+
+	if (strncmp(name, "nvme", 4) != 0)
+		return 1;
+
+	snprintf(path, sizeof(path) - 1, "/sys/block/%s/device/serial", name);
+
+	return load_sys(path, buf, buf_len);
+}
+
 extern int scsi_get_serial(int fd, void *buf, size_t buf_len);
 
 static int imsm_read_serial(int fd, char *devname,
 			    __u8 serial[MAX_RAID_SERIAL_LEN])
 {
-	unsigned char scsi_serial[255];
+	char buf[50];
 	int rv;
-	int rsp_len;
 	int len;
 	char *dest;
 	char *src;
-	char *rsp_buf;
-	int i;
+	unsigned int i;
+
+	memset(buf, 0, sizeof(buf));
 
-	memset(scsi_serial, 0, sizeof(scsi_serial));
+	rv = nvme_get_serial(fd, buf, sizeof(buf));
 
-	rv = scsi_get_serial(fd, scsi_serial, sizeof(scsi_serial));
+	if (rv)
+		rv = scsi_get_serial(fd, buf, sizeof(buf));
 
 	if (rv && check_env("IMSM_DEVNAME_AS_SERIAL")) {
 		memset(serial, 0, MAX_RAID_SERIAL_LEN);
@@ -3362,20 +3379,11 @@ static int imsm_read_serial(int fd, char *devname,
 		return rv;
 	}
 
-	rsp_len = scsi_serial[3];
-	if (!rsp_len) {
-		if (devname)
-			pr_err("Failed to retrieve serial for %s\n",
-			       devname);
-		return 2;
-	}
-	rsp_buf = (char *) &scsi_serial[4];
-
 	/* trim all whitespace and non-printable characters and convert
 	 * ':' to ';'
 	 */
-	for (i = 0, dest = rsp_buf; i < rsp_len; i++) {
-		src = &rsp_buf[i];
+	for (i = 0, dest = buf; i < sizeof(buf) && buf[i]; i++) {
+		src = &buf[i];
 		if (*src > 0x20) {
 			/* ':' is reserved for use in placeholder serial
 			 * numbers for missing disks
@@ -3386,8 +3394,8 @@ static int imsm_read_serial(int fd, char *devname,
 				*dest++ = *src;
 		}
 	}
-	len = dest - rsp_buf;
-	dest = rsp_buf;
+	len = dest - buf;
+	dest = buf;
 
 	/* truncate leading characters */
 	if (len > MAX_RAID_SERIAL_LEN) {
-- 
2.10.0

