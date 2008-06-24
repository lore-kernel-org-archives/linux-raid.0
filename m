From: Chris Webb <chris@arachsys.com>
Subject: [PATCH] sysfs superblock read oops
Date: Wed, 25 Jun 2008 00:35:33 +0100
Message-ID: <20080624233533.GH9948@arachsys.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="LSp5EJdfMPwZcMS1"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--LSp5EJdfMPwZcMS1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Whilst correcting my rdev resize patch to deal with non-persistent metadata,
I noticed that reading from /sys/block/mdX/md/rdY/super when there isn't a
real superblock causes an oops rather than just returning zero length. The
tiny attached patch fixes this.

Best wishes,

Chris.

------------[ cut here ]------------
kernel BUG at fs/sysfs/file.c:126!
invalid opcode: 0000 [#1] PREEMPT SMP 
Modules linked in:

Pid: 1263, comm: cat Not tainted (2.6.24.4 #12)
EIP: 0060:[<c01ab41f>] EFLAGS: 00010212 CPU: 1
EIP is at fill_read_buffer+0x6b/0x8c
EAX: 00000001 EBX: 00001000 ECX: 00000000 EDX: f6d30360
ESI: f6cf9940 EDI: f6d303c0 EBP: c06bd20c ESP: f6cabf4c
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process cat (pid: 1263, ti=f6caa000 task=f7cb2570 task.ti=f6caa000)
Stack: 00000000 f6c13300 f6cf9940 00001000 0804d038 c01ab467 c053ed00 c053ed00 
       f6c13300 0804d038 c053ed00 f6cabfa0 c0173cbf f6cabfa0 f6c13300 f6c13300 
       fffffff7 0804d038 f6caa000 c0173f57 f6cabfa0 00000000 00000000 00000000 
Call Trace:
 [<c01ab467>] sysfs_read_file+0x27/0x59
 [<c0173cbf>] vfs_read+0x83/0xee
 [<c0173f57>] sys_read+0x41/0x67
 [<c0103e7a>] sysenter_past_esp+0x5f/0x85
 =======================
Code: ed ff ff ff 74 3e 8b 47 18 8b 4e 0c 8b 40 04 89 46 2c 8b 57 14 89 d8 ff 55 00 89 c3 89 f8 e8 cf 08 00 00 81 fb ff 0f 00 00 7e 04 <0f> 0b eb fe 85 db 78 0b c7 46 28 00 00 00 00 89 1e eb 03 89 1c 
EIP: [<c01ab41f>] fill_read_buffer+0x6b/0x8c SS:ESP 0068:f6cabf4c
---[ end trace 6abc62061d49b4ad ]---


--LSp5EJdfMPwZcMS1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="linux-2.6.24.4-md-external-super-sysfs.patch"

From: Chris Webb <chris@arachsys.com>

Fix oops on reading from /sys/block/mdX/md/rdY/super when there is no
persistent superblock to read.

Signed-off-by: Chris Webb <chris@arachsys.com>
---
 drivers/md/md.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1911,7 +1911,7 @@
 static ssize_t
 super_show(mdk_rdev_t *rdev, char *page)
 {
-	if (rdev->sb_loaded && rdev->sb_size) {
+	if (rdev->mddev->persistent && rdev->sb_loaded && rdev->sb_size) {
 		memcpy(page, page_address(rdev->sb_page), rdev->sb_size);
 		return rdev->sb_size;
 	} else

--LSp5EJdfMPwZcMS1--
