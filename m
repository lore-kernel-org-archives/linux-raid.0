From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH] fix extended partition detection
Date: Mon, 24 Jan 2011 18:54:06 -0800
Message-ID: <20110125025303.18675.61317.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, Krzysztof Wasilewski <krzysztof.wasilewski@intel.com>, Przemyslaw Czarnowski <przemyslaw.hawrylewicz.czarnowski@intel.com>
List-Id: linux-raid.ids

# mdadm --detail --export /dev/md127p1

Before:
MD_LEVEL=raid5
MD_DEVICES=4
MD_METADATA=0.90

After:
MD_LEVEL=raid5
MD_DEVICES=4
MD_CONTAINER=/dev/md0
MD_MEMBER=0
MD_UUID=55746a20:925d24a7:4f9bd7e2:9c9a411f

We parse the symlink target with a format:

../../block/mdXXX/mdXXXpYY

...and need the second '/' from the end of the string to read detect a
'md' device.

Reported-by: Krzysztof Wasilewski <krzysztof.wasilewski@intel.com>
Cc: Przemyslaw Czarnowski <przemyslaw.hawrylewicz.czarnowski@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---

[ sorry for any duplicates or triplicates, I failed to notice that my
  MTA was misconfigured after an upgrade to F13, and all my mail from
  stgit was getting rejected externally. ] 

If there are any 3.1.x stable releases planned I would consider this a 
candidate as it allows custom name partitions to be created by udev 
(like /dev/md/vol1p1).  I believe this was masked by the usage of mdp 
devices.

On 3.2 it exposes a segfault as we try to get the container_content() 
of 'mbr' metadata.

 util.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/util.c b/util.c
index c9bdd6e..75a5e6d 100644
--- a/util.c
+++ b/util.c
@@ -1664,7 +1664,7 @@ int stat2devnum(struct stat *st)
 		link[n] = 0;
 		cp = strrchr(link, '/');
 		if (cp) *cp = 0;
-		cp = strchr(link, '/');
+		cp = strrchr(link, '/');
 		if (cp && strncmp(cp, "/md", 3) == 0)
 			return devname2devnum(cp+1);
 	}

