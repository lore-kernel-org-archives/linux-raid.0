From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: [PATCH] Fix oddity where mdadm did not recognise a relative path
Date: Fri, 3 Mar 2017 18:36:16 +0000
Message-ID: <58B9B7A0.9040602@youngman.org.uk>
References: <587E6B56.8090704@youngman.org.uk> <wrfjzih4wt7l.fsf@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040706090008090200080305"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <wrfjzih4wt7l.fsf@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: jes.sorensen@gmail.com
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------040706090008090200080305
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit

> 
> I thought this was still pending but going back, it looks like I did
> apply it. The problem is I noticed a major issue in the patch, which
> doesn't belong in code, it is doing 'if () break' on the same line.

Sorry about that - corporate style and all that :-) but it is important
to not break the standard style.
> 
> Mind sending me a patch to fix that.
> 
> Thanks,
> Jes
> 
Cheers,
Wol

--------------040706090008090200080305
Content-Type: text/x-patch;
 name="0001-Fix-formatting-error.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0001-Fix-formatting-error.patch"

From 945b835cc89fd16279e01f743f8507b80219c8a1 Mon Sep 17 00:00:00 2001
From: Wol <anthony@youngman.org.uk>
Date: Fri, 3 Mar 2017 18:31:52 +0000
Subject: [PATCH] Fix formatting error

---
 mdadm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mdadm.c b/mdadm.c
index b5d89e4..d973ae4 100644
--- a/mdadm.c
+++ b/mdadm.c
@@ -1902,7 +1902,8 @@ static int misc_list(struct mddev_dev *devlist,
 		switch(dv->devname[0] == '/') {
 			case 0:
 				mdfd = open_dev(dv->devname);
-				if (mdfd >= 0) break;
+				if (mdfd >= 0)
+					break;
 			case 1:
 				mdfd = open_mddev(dv->devname, 1);  
 		}
-- 
2.7.3


--------------040706090008090200080305--
