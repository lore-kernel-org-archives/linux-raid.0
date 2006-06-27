From: NeilBrown <neilb@suse.de>
Subject: [PATCH 011 of 12] md: Fix "Will Configure" message when interpreting md= kernel parameter.
Date: Tue, 27 Jun 2006 17:06:05 +1000
Message-ID: <1060627070605.26082@suse.de>
References: <20060627170010.25835.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids


If a partitionable array is used, we should say e.g.
  Will configure md_d0 (super-block) from ....
rather than
  Will configure md0 (super-block) from ....
which implies non-partitionable.


Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./usr/kinit/do_mounts_md.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff .prev/usr/kinit/do_mounts_md.c ./usr/kinit/do_mounts_md.c
--- .prev/usr/kinit/do_mounts_md.c	2006-06-27 12:15:15.000000000 +1000
+++ ./usr/kinit/do_mounts_md.c	2006-06-27 12:17:34.000000000 +1000
@@ -205,8 +205,8 @@ static int md_setup(char *str)
 		pername = "super-block";
 	}
 
-	fprintf(stderr, "md: Will configure md%d (%s) from %s, below.\n",
-		minor, pername, str);
+	fprintf(stderr, "md: Will configure md%s%d (%s) from %s, below.\n",
+		partitioned?"_d":"", minor, pername, str);
 	md_setup_args[ent].device_names = str;
 	md_setup_args[ent].partitioned = partitioned;
 	md_setup_args[ent].minor = minor;
