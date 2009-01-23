From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [mdadm git pull] imsm fixes and general external metadata
	updates
Date: Fri, 23 Jan 2009 15:51:56 -0700
Message-ID: <1232751116.7825.3.camel@dwillia2-linux.ch.intel.com>
References: <1232576408.2029.56.camel@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1232576408.2029.56.camel@dwillia2-linux.ch.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, 2009-01-21 at 15:20 -0700, Dan Williams wrote:
> Hi Neil,
> 
> The following changes since commit 78fbcc10312649f2f4f88283e3f19dce9b205733:
>   NeilBrown (1):
>         Merge branch 'master' into scratch-3.0
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/djbw/mdadm.git devel
> 

Seems you have not pulled yet, I have appended an important fix.

Thanks,
Dan

---
imsm: fix failed disks are allowed back into the container

From: Dan Williams <dan.j.williams@intel.com>

Failed disks do not have valid serial numbers which means we will not
pick up the 'failed' status bit from the metadata entry.  Check for
dl->index == -2 to prevent failed disks from being incorporated into the
container.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 super-intel.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 0a7c34a..5c9f413 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -1195,8 +1195,11 @@ static void getinfo_super_imsm(struct supertype *st, struct mdinfo *info)
 		info->component_size = reserved;
 		s = disk->status;
 		info->disk.state  = s & CONFIGURED_DISK ? (1 << MD_DISK_ACTIVE) : 0;
-		info->disk.state |= s & FAILED_DISK ? (1 << MD_DISK_FAULTY) : 0;
 		info->disk.state |= s & SPARE_DISK ? 0 : (1 << MD_DISK_SYNC);
+		if (s & FAILED_DISK || super->disks->index == -2) {
+			info->disk.state |= 1 << MD_DISK_FAULTY;
+			info->disk.raid_disk = -2;
+		}
 	}
 
 	/* only call uuid_from_super_imsm when this disk is part of a populated container,


