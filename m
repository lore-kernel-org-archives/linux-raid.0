From: Vignesh Babu BM <vignesh.babu@wipro.com>
Subject: [KJ] [PATCH] is_power_of_2 in md
Date: Fri, 16 Feb 2007 17:35:16 +0530
Message-ID: <1171627516.6127.2.camel@wriver-t81fb058.linuxcoe>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <kernel-janitors-bounces@lists.osdl.org>
List-Unsubscribe: <https://lists.osdl.org/mailman/listinfo/kernel-janitors>,
	<mailto:kernel-janitors-request@lists.osdl.org?subject=unsubscribe>
List-Archive: <http://lists.osdl.org/pipermail/kernel-janitors>
List-Post: <mailto:kernel-janitors@lists.osdl.org>
List-Help: <mailto:kernel-janitors-request@lists.osdl.org?subject=help>
List-Subscribe: <https://lists.osdl.org/mailman/listinfo/kernel-janitors>,
	<mailto:kernel-janitors-request@lists.osdl.org?subject=subscribe>
Sender: kernel-janitors-bounces@lists.osdl.org
Errors-To: kernel-janitors-bounces@lists.osdl.org
To: Kernel Janitors List <kernel-janitors@lists.osdl.org>
Cc: neilb@suse.de, linux-raid@vger.kernel.org, mingo@redhat.com
List-Id: linux-raid.ids


Replacing (n & (n-1)) in the context of power of 2 checks
with is_power_of_2


diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index 0821a2b..f2d4b23 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -17,6 +17,7 @@
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
+#include <linux/log2.h>
 =

 #include "dm-snap.h"
 #include "dm-bio-list.h"
@@ -414,7 +415,7 @@ static int set_chunk_size(struct dm_snapshot *s, const =
char *chunk_size_arg,
 	chunk_size =3D round_up(chunk_size, PAGE_SIZE >> 9);
 =

 	/* Check chunk_size is a power of 2 */
-	if (chunk_size & (chunk_size - 1)) {
+	if (!is_power_of_2(chunk_size)) {
 		*error =3D "Chunk size is not a power of 2";
 		return -EINVAL;
 	}

-- =

Regards,  =

Vignesh Babu BM  =

_____________________________________________________________  =

"Why is it that every time I'm with you, makes me believe in magic?"
