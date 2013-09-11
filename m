From: mwilck@arcor.de
Subject: [PATCH] mdmon: honour --offroot, again
Date: Wed, 11 Sep 2013 22:15:19 +0200
Message-ID: <1378930519-7679-1-git-send-email-mwilck@arcor.de>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: mwilck@arcor.de
List-Id: linux-raid.ids

commit 3e32ba9d removed support for --offroot, and a9c15847 made
mdmon use @ in argv[0] only when started from initrd.

This breaks mdadm in OpenSUSE 12.3, which starts mdmon from the
root file system and relies on --offroot to work as documented earlier.

Reintroducing --offroot as an undocumented option, as its use is going to
go away soon anyway.

If this can't be applied, it should probably be included as distro-specific
patch if mdadm 3.3 is built for OpenSUSE 12.3. I haven't checked if the
patch is necesary for OpenSUSE Factory, too.

Signed-off-by: Martin Wilck <mwilck@arcor.de>
---
 mdmon.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mdmon.c b/mdmon.c
index f0b0623..8cd53d8 100644
--- a/mdmon.c
+++ b/mdmon.c
@@ -320,7 +320,7 @@ int main(int argc, char *argv[])
 			dofork = 0;
 			break;
 		case OffRootOpt:
-			/* silently ignore old option */
+			argv[0][0] = '@';
 			break;
 		case 'h':
 		default:
-- 
1.7.3.4
