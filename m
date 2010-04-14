From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH] Fixup default definitions of VAR_RUN and ALT_RUN
Date: Wed, 14 Apr 2010 11:53:56 -0700
Message-ID: <20100414185356.29125.69103.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, Luca Berra <bluca@comedia.it>, Dan Williams <dan.j.williams@intel.com>
List-Id: linux-raid.ids

I suspect commit c132678b wanted VAR_RUN and ALT_RUN to be suffixed by
'/mdadm' to match the defaults in mdadm.h.

Cc: Luca Berra <bluca@comedia.it>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---

 Makefile |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index 1035ea8..74dafa4 100644
--- a/Makefile
+++ b/Makefile
@@ -62,8 +62,8 @@ CONFFILEFLAGS = -DCONFFILE=\"$(CONFFILE)\" -DCONFFILE2=\"$(CONFFILE2)\"
 # from early boot to late boot.
 # If you don't have /lib/init/rw you might want to use /dev/.something
 #  e.g. make ALT_RUN=/dev/.mdadm
-ALT_RUN = /lib/init/rw
-VAR_RUN = /var/run
+ALT_RUN = /lib/init/rw/mdadm
+VAR_RUN = /var/run/mdadm
 ALTFLAGS = -DALT_RUN=\"$(ALT_RUN)\"
 VARFLAGS = -DVAR_RUN=\"$(VAR_RUN)\"
 CFLAGS = $(CWFLAGS) $(CXFLAGS) -DSendmail=\""$(MAILCMD)"\" $(CONFFILEFLAGS) $(ALTFLAGS) $(VARFLAGS)

