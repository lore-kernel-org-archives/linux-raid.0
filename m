From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [patch -next] bcache: check for allocation failures
Date: Fri, 5 Jul 2013 09:05:46 +0300
Message-ID: <20130705060307.GB14443@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <kmo-PEzghdH756F8UrSeD/g0lQ@public.gmane.org>, Gabriel de Perthuis <g2p.code-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Neil Brown <neilb-l3A5Bk7waGM@public.gmane.org>, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-raid.ids

There is a missing NULL check after the kzalloc().

Signed-off-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
index 48f0353..4fe6ab2 100644
--- a/drivers/md/bcache/sysfs.c
+++ b/drivers/md/bcache/sysfs.c
@@ -232,6 +232,8 @@ STORE(__cached_dev)
 			bch_uuid_write(dc->disk.c);
 		}
 		env = kzalloc(sizeof(struct kobj_uevent_env), GFP_KERNEL);
+		if (!env)
+			return -ENOMEM;
 		add_uevent_var(env, "DRIVER=bcache");
 		add_uevent_var(env, "CACHED_UUID=%pU", dc->sb.uuid),
 		add_uevent_var(env, "CACHED_LABEL=%s", buf);
