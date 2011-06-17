From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] mdadm: Linux 3.x version change
Date: Fri, 17 Jun 2011 22:54:04 +1000
Message-ID: <20110617225404.62fe6f42@notabene.brown>
References: <1307716200-27483-1-git-send-email-namhyung@gmail.com>
	<4DFB4627.7050809@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DFB4627.7050809@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Milan Broz <mbroz@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 17 Jun 2011 14:18:47 +0200 Milan Broz <mbroz@redhat.com> wrote:

> On 06/10/2011 04:30 PM, Namhyung Kim wrote:
> > As Linux 3.x changes its versioning scheme, we have to deal with
> > the 2-digit version number also.
> FYI: we have patch below currently in Fedora rawhide
> (which already switched to 3.0-rc numbering scheme).
> 
> Without it is system unable to assembly RAID during boot
> ("mdadm -As --auto=yes --run" fails because of wrong version detected).
> 
> It seems that 3.2.2 still have the same problem.
> 
> Milan
> 
> --- mdadm-3.2.1.old/util.c	2011-03-28 04:31:20.000000000 +0200
> +++ mdadm-3.2.1/util.c	2011-06-05 07:59:03.741904751 +0200
> @@ -154,8 +154,8 @@ int get_linux_version()
>  	a = strtoul(cp, &cp, 10);
>  	if (*cp != '.') return -1;
>  	b = strtoul(cp+1, &cp, 10);
> -	if (*cp != '.') return -1;
> -	c = strtoul(cp+1, NULL, 10);
> +	if (*cp != '.' && a <= 2) return -1;
> +	c = (*cp == '.') ? strtoul(cp+1, NULL, 10) : 0;
>  
>  	return (a*1000000)+(b*1000)+c;
>  }
> 

Bother - I always seem to miss something :-(

I have added the following (which is different yet again) to git.

According to https://lwn.net/Articles/447572/ it seems it isn't yet 100%
certain that the next version will be 3.0 rather than 3.0.0....  So I might
not need to push out a new version too quickly.

Thanks,
NeilBrown

From f161d047eed634b3380262767f955eb888502e88 Mon Sep 17 00:00:00 2001
From: NeilBrown <neilb@suse.de>
Date: Fri, 17 Jun 2011 22:49:24 +1000
Subject: [PATCH] util: correctly parse shorter linux version numbers.

The next version of Linux might be 3.0.  If it is, get_linux_version
will fail.
So make it more robust.

Reported-by: Namhyung Kim <namhyung@gmail.com>
Reported-by: Milan Broz <mbroz@redhat.com>
Signed-off-by: NeilBrown <neilb@suse.de>
---
 util.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/util.c b/util.c
index 10bbe56..55d171a 100644
--- a/util.c
+++ b/util.c
@@ -146,16 +146,16 @@ int get_linux_version()
 {
 	struct utsname name;
 	char *cp;
-	int a,b,c;
+	int a = 0, b = 0,c = 0;
 	if (uname(&name) <0)
 		return -1;
 
 	cp = name.release;
 	a = strtoul(cp, &cp, 10);
-	if (*cp != '.') return -1;
-	b = strtoul(cp+1, &cp, 10);
-	if (*cp != '.') return -1;
-	c = strtoul(cp+1, NULL, 10);
+	if (*cp == '.')
+		b = strtoul(cp+1, &cp, 10);
+	if (*cp == '.')
+		c = strtoul(cp+1, &cp, 10);
 
 	return (a*1000000)+(b*1000)+c;
 }
-- 
1.7.3.4

