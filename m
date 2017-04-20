From: NeilBrown <neilb@suse.com>
Subject: [mdadm PATCH 1/4] Grow_continue_command: ensure 'content' is properly
 initialised.
Date: Thu, 20 Apr 2017 12:40:05 +1000
Message-ID: <149265600552.31004.6577040107424525064.stgit@noble>
References: <149265560315.31004.3851231165281498425.stgit@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <149265560315.31004.3851231165281498425.stgit@noble>
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <jes.sorensen@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Grow_continue_command() call verify_reshape_position(), which assumes
that info->sys_name is initialised.
'info' in verify_reshape_position() is 'content' in Grow_continue_command().

In the st->ss->external != 0 branch of that function, sysfs_init() is called
to initialize content->sys_name.
In the st->ss->external == 0 branch, ->sys_name is not initialized so
verify_reshape_position() will not do the right thing.

Signed-off-by: NeilBrown <neilb@suse.com>
---
 Grow.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/Grow.c b/Grow.c
index 15f4ed1253bf..c6967ed1c9c7 100755
--- a/Grow.c
+++ b/Grow.c
@@ -5002,6 +5002,7 @@ int Grow_continue_command(char *devname, int fd,
 			goto Grow_continue_command_exit;
 		}
 		content = &array;
+		sysfs_init(content, fd, NULL);
 		/* Need to load a superblock.
 		 * FIXME we should really get what we need from
 		 * sysfs


