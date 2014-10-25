From: Justin Maggard <jmaggard10@gmail.com>
Subject: [PATCH] Grow: fix resize of array component size to > 32bits
Date: Fri, 24 Oct 2014 17:55:02 -0700
Message-ID: <1414198502-10167-1-git-send-email-jmaggard10@gmail.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Justin Maggard <jmaggard10@gmail.com>
List-Id: linux-raid.ids

If the request --size to --grow an array to is larger
than 32bits, then mdadm may make the wrong choice and
use ioctl instead of setting component_size via sysfs
and the change is ignored.

Instead of using casts to check for a 32-bit overflow,
just check for set bits outside of INT32_MAX.
---
 Grow.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Grow.c b/Grow.c
index a9c8589..a614102 100644
--- a/Grow.c
+++ b/Grow.c
@@ -1818,7 +1818,7 @@ int Grow_reshape(char *devname, int fd,
 		if (s->size == MAX_SIZE)
 			s->size = 0;
 		array.size = s->size;
-		if (array.size != (signed)s->size) {
+		if (s->size & ~INT32_MAX) {
 			/* got truncated to 32bit, write to
 			 * component_size instead
 			 */
-- 
1.9.1

