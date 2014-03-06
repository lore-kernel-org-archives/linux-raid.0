From: Pawel Baldysiak <pawel.baldysiak@intel.com>
Subject: [PATCH] mdmon@.service: Change type of process start-up to
 'forking'.
Date: Thu, 06 Mar 2014 15:51:44 +0100
Message-ID: <20140306145144.9690.29220.stgit@gklab-154-222.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, artur.paszkiewicz@intel.com
List-Id: linux-raid.ids

Mdadm does not wait enough time when mdmon is started by systemd.
It causes various problems with behaviour of a RAID volume with external metadata.
For example: mdmon does not update a value of checkpoint during migration
and second RAID5 volume is read-only after reboot done during
container reshape (both problems occur with IMSM matadata).
If a type of process start-up is changed to 'forking', systemctl will
wait until mdmon (parent) process exits after calling fork.
This way mdmon will always be fully initialized after start_mdmon
and these problems will not occur.
In this case it is recommended to add a path to PIDFile, so that systemd
does not have to guess a PID of the mdmon process.

Signed-off-by: Pawel Baldysiak <pawel.baldysiak@intel.com>
Reviewed-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Reviewed-by: Lukasz Dorau <lukasz.dorau@intel.com>
---
 systemd/mdmon@.service |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/systemd/mdmon@.service b/systemd/mdmon@.service
index 5520cd0..304b26e 100644
--- a/systemd/mdmon@.service
+++ b/systemd/mdmon@.service
@@ -14,5 +14,7 @@ Before=initrd-switch-root.target
 # mdmon should never complain due to lack of a platform,
 # that is mdadm's job if at all.
 Environment=IMSM_NO_PLATFORM=1
-ExecStart=/sbin/mdmon --foreground %I
+ExecStart=/sbin/mdmon %I
+Type=forking
+PIDFile=/run/mdadm/%I.pid
 KillMode=none

