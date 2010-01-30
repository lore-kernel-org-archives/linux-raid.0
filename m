From: Luca Berra <bluca@comedia.it>
Subject: [PATCH 1/1] super-intel.c: use %zu specifier for printf of size_t
Date: Sat, 30 Jan 2010 10:59:29 +0100
Message-ID: <20100130095928.GD15471@maude.comedia.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Dan Williams <dan.j.williams@intel.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


Signed-off-by: Luca Berra <bluca@vodka.it>
---
  super-intel.c |    2 +-
  1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index fcf438c..91479a2 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -4076,7 +4076,7 @@ static struct mdinfo *container_content_imsm(struct supertype *st)
  
  		this = malloc(sizeof(*this));
  		if (!this) {
-			fprintf(stderr, Name ": failed to allocate %lu bytes\n",
+			fprintf(stderr, Name ": failed to allocate %zu bytes\n",
  				sizeof(*this));
  			break;
  		}
-- 
Luca Berra -- bluca@comedia.it
         Communication Media & Services S.r.l.
  /"\
  \ /     ASCII RIBBON CAMPAIGN
   X        AGAINST HTML MAIL
  / \
