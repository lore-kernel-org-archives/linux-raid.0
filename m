From: "Bin Guo" <bguo@starentnetworks.com>
Subject: [PATCH] Manage: kernel 2.6.18 can re-add v1 superblocks.
Date: Mon, 17 Nov 2008 14:37:55 -0500
Message-ID: <1226950675.9688.88.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Class: urn:content-classes:message
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Commit 7eae7080 seems to exclude 2.6.18.
---
 Manage.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Manage.c b/Manage.c
index 160778e..611d0a2 100644
--- a/Manage.c
+++ b/Manage.c
@@ -397,7 +397,7 @@ int Manage_subdevs(char *devname, int fd,
 				 * before 2.6.18 :-(
 				 */
 				if (array.major_version == 1 &&
-				    get_linux_version() <= 2006018)
+				    get_linux_version() < 2006018)
 					;
 				else if (st->sb) {
 					st->ss->uuid_from_super(st, ouuid);
-- 
1.5.6.5



This email and any attachments may contain legally privileged and/or confidential information of Starent Networks, Corp. and is intended only for the individual or entity named in the message.  The information transmitted may not be used to create or change any contractual obligations of Starent Networks, Corp.  Any review, retransmission, dissemination or other use of, or taking of any action in reliance upon this e-mail and its attachments by persons or entities other than the intended recipient is prohibited. If you are not the intended recipient, please notify the sender immediately -- by replying to this message or by sending an email to postmaster@starentnetworks.com -- and destroy all copies of this message and any attachments without reading or disclosing their contents. Thank you.
 
