From: Song Liu <songliubraving@fb.com>
Subject: [PATCH 14/17] scsi mode sense/select support
Date: Tue, 1 Dec 2015 16:25:30 -0800
Message-ID: <1449015933-255689-15-git-send-email-songliubraving@fb.com>
References: <1449015933-255689-1-git-send-email-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1449015933-255689-1-git-send-email-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.com, dan.j.williams@intel.com, shli@fb.com, Dan Williams <djbw@fb.com>, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

From: Dan Williams <djbw@fb.com>

Add scsi_mode_{sense|select} support in preparation for allowing drive
settings to be specified in the configuration file.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Song Liu <songliubraving@fb.com>
---
 sg_io.c | 170 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 sg_io.h |  27 +++++++++++
 2 files changed, 195 insertions(+), 2 deletions(-)
 create mode 100644 sg_io.h

diff --git a/sg_io.c b/sg_io.c
index 50ad180..813cbdd 100644
--- a/sg_io.c
+++ b/sg_io.c
@@ -16,15 +16,20 @@
  * this program; if not, write to the Free Software Foundation, Inc.,
  * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
  */
+#include "mdadm.h"
+#include <stdio.h>
 #include <string.h>
 #include <scsi/scsi.h>
 #include <scsi/sg.h>
 #include <sys/ioctl.h>
+#include <stdlib.h>
+
+#include "sg_io.h"
 
 int scsi_get_serial(int fd, void *buf, size_t buf_len)
 {
-	unsigned char inq_cmd[] = {INQUIRY, 1, 0x80, 0, buf_len, 0};
-	unsigned char sense[32];
+	__u8 inq_cmd[] = {INQUIRY, 1, 0x80, 0, buf_len, 0};
+	__u8 sense[32];
 	struct sg_io_hdr io_hdr;
 
 	memset(&io_hdr, 0, sizeof(io_hdr));
@@ -40,3 +45,164 @@ int scsi_get_serial(int fd, void *buf, size_t buf_len)
 
 	return ioctl(fd, SG_IO, &io_hdr);
 }
+
+static int process_response(const char *cmd, struct sg_io_hdr *io)
+{
+	if ((io->info & SG_INFO_OK_MASK) != SG_INFO_OK) {
+		if (io->sb_len_wr > 0) {
+			int i;
+
+			dprintf("resp: %x sense: %x asc: %x asq: %x\n",
+				io->sbp[0], io->sbp[2] & 0xf, io->sbp[12],
+				io->sbp[13]);
+			dprintf("%s sense data:\n", cmd);
+			for (i = 0; i < io->sb_len_wr; ++i) {
+				if ((i > 0) && (0 == (i % 10)))
+					printf("\n  ");
+				dprintf("0x%02x ", io->sbp[i]);
+			}
+			dprintf("\n");
+		}
+		if (io->masked_status)
+			dprintf("%s SCSI status=0x%x\n", cmd, io->status);
+		if (io->host_status)
+			dprintf("%s host_status=0x%x\n", cmd, io->host_status);
+		if (io->driver_status)
+			dprintf("%s driver_status=0x%x\n", cmd, io->driver_status);
+		return -1;
+	}
+	return 0;
+}
+
+/**
+ * scsi_mode_sense - fetch mode page(s) and a description
+ *
+ * cdb len based on buffer size
+ */
+static int __scsi_mode_sense(int fd, __u8 pg, __u8 spg,
+			     struct scsi_mode_sense_data *data,
+			     __u8 *buf, size_t buf_len, int force6)
+{
+	struct sg_io_hdr io_hdr;
+	int rc, cdb_len;
+	__u8 sense[32];
+	__u8 cmd[10];
+
+	if (buf_len < 8)
+		return -1;
+
+	memset(data, 0, sizeof(data));
+	memset(cmd, 0, sizeof(cmd));
+	cmd[2] = pg;
+	cmd[3] = spg;
+
+	if (buf_len > 255 || !force6) {
+		cdb_len = 10;
+		cmd[0] = MODE_SENSE_10;
+		cmd[7] = buf_len >> 8;
+		cmd[8] = buf_len;
+	} else {
+		cdb_len = 6;
+		cmd[0] = MODE_SENSE;
+		cmd[4] = buf_len;
+	}
+	memset(&io_hdr, 0, sizeof(io_hdr));
+	memset(sense, 0, sizeof(sense));
+	io_hdr.interface_id = 'S';
+	io_hdr.cmdp = cmd;
+	io_hdr.cmd_len = cdb_len;
+	io_hdr.dxferp = buf;
+	io_hdr.dxfer_len = buf_len;
+	io_hdr.dxfer_direction = SG_DXFER_FROM_DEV;
+	io_hdr.sbp = sense;
+	io_hdr.mx_sb_len = sizeof(sense);
+	io_hdr.timeout = 30000;
+
+	rc = ioctl(fd, SG_IO, &io_hdr);
+	if (rc)
+		return rc;
+
+	if (cdb_len == 10) {
+		data->data_len = buf[0]*256 + buf[1] + 2;
+		data->media_type = buf[2];
+		data->device_specific = buf[3];
+		data->long_lba = buf[4] & 1;
+		data->block_len = buf[6]*256 + buf[7];
+	} else {
+		data->data_len = buf[0] + 1;
+		data->media_type = buf[1];
+		data->device_specific = buf[2];
+		data->block_len = buf[3];
+	}
+	data->hdr_len = cdb_len - 2;
+
+	if ((size_t) (to_mode_page(buf, data) - buf) > buf_len)
+		return -1;
+
+	return process_response("MODE SENSE", &io_hdr);
+}
+
+int scsi_mode_sense(int fd, __u8 pg, __u8 spg,
+		    struct scsi_mode_sense_data *data,
+		    __u8 *buf, size_t buf_len)
+{
+	return __scsi_mode_sense(fd, pg, spg, data, buf, buf_len, 0);
+}
+
+int scsi_mode_select(int fd, enum page_format pf, int save,
+		     const struct scsi_mode_sense_data *data,
+		     __u8 *param_list)
+{
+	struct sg_io_hdr io_hdr;
+	int rc, cdb_len;
+	__u8 sense[32];
+	__u8 cmd[10];
+	__u8 *page;
+
+	memset(cmd, 0, sizeof(cmd));
+	page = to_mode_page(param_list, data);
+	cmd[1] = (!!pf << 4) | ((page[0] >> 7) & !!save);
+
+	/* ps reserved */
+	page[0] &= 0x7f;
+
+	if (data->hdr_len > 4) {
+		cdb_len = 10;
+		cmd[0] = MODE_SELECT_10;
+		cmd[7] = data->data_len >> 8;
+		cmd[8] = data->data_len;
+
+		param_list[0] = 0; /* data len reserved */
+		param_list[1] = 0; /*  "    "     "     */
+		param_list[2] = data->media_type;
+		param_list[3] = 0; /* whole disk parameter */
+		param_list[6] = data->block_len >> 8;
+		param_list[7] = data->block_len;
+	} else {
+		cdb_len = 6;
+		cmd[0] = MODE_SELECT;
+		cmd[4] = data->data_len;
+
+		param_list[0] = 0; /* data len reserved */
+		param_list[1] = data->media_type;
+		param_list[2] = 0; /* whole disk parameter */
+		param_list[3] = data->block_len;
+	}
+	memset(&io_hdr, 0, sizeof(io_hdr));
+	memset(sense, 0, sizeof(sense));
+	io_hdr.interface_id = 'S';
+	io_hdr.cmdp = cmd;
+	io_hdr.cmd_len = cdb_len;
+	io_hdr.dxferp = param_list;
+	io_hdr.dxfer_len = data->data_len;
+	io_hdr.dxfer_direction = SG_DXFER_TO_DEV;
+	io_hdr.sbp = sense;
+	io_hdr.mx_sb_len = sizeof(sense);
+	io_hdr.timeout = 30000;
+
+	rc = ioctl(fd, SG_IO, &io_hdr);
+	if (rc)
+		return rc;
+
+	return process_response("MODE SELECT", &io_hdr);
+}
diff --git a/sg_io.h b/sg_io.h
new file mode 100644
index 0000000..f0988a5
--- /dev/null
+++ b/sg_io.h
@@ -0,0 +1,27 @@
+#include <asm/types.h>
+
+struct scsi_mode_sense_data {
+	int hdr_len;
+	int block_len;
+	int media_type;
+	int data_len;
+	int device_specific;
+	char long_lba;
+};
+
+enum page_format {
+	PF_VENDOR = 0,
+	PF_STANDARD = 1,
+};
+
+static inline __u8 *to_mode_page(__u8 *buf, const struct scsi_mode_sense_data *data)
+{
+	return buf + data->hdr_len + data->block_len;
+}
+
+int scsi_mode_sense(int fd, __u8 pg, __u8 spg,
+		    struct scsi_mode_sense_data *data,
+		    __u8 *buf, size_t buf_len);
+int scsi_mode_select(int fd, enum page_format pf, int save,
+		     const struct scsi_mode_sense_data *data,
+		     __u8 *page);
-- 
2.4.6

